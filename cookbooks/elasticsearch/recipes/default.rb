#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Credit goes to GoTime for their original recipe ( http://cookbooks.opscode.com/cookbooks/elasticsearch )

if ['util'].include?(node[:instance_role])
  if node['utility_instances'].empty?
    Chef::Log.info "No utility instances found"
  else
    elasticsearch_instances = []
    elasticsearch_expected = 0
    node['utility_instances'].each do |elasticsearch|
      if elasticsearch['name'].include?("elasticsearch_")
        elasticsearch_expected = elasticsearch_expected + 1 unless node['fqdn'] == elasticsearch['hostname']
        elasticsearch_instances << "#{elasticsearch['hostname']}:9300" unless node['fqdn'] == elasticsearch['hostname']
      end
    end
  end

  if node['name'].include?("elasticsearch_")
    Chef::Log.info "Downloading Elasticsearch v#{node[:elasticsearch_version]} checksum #{node[:elasticsearch_checksum]}"
    remote_file "/tmp/elasticsearch-#{node[:elasticsearch_version]}.zip" do
      source "http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{node[:elasticsearch_version]}.zip"
      mode "0644"
      checksum node[:elasticsearch_checksum]
      not_if { File.exists?("/tmp/elasticsearch-#{node[:elasticsearch_version]}.zip") }
    end

    user "elasticsearch" do
      uid 61021
      gid "nogroup"
    end

    # Update JAVA as the Java on the AMI can sometimes crash
    #
    Chef::Log.info "Updating Java JDK"
    enable_package node[:elastic_search_java_package_name] do
      version node[:elasticsearch_java_version]
      unmask true
    end

    package node[:elastic_search_java_package_name] do
      version node[:elasticsearch_java_version]
      action :upgrade
    end

    execute "Set the default Java version to #{node[:elasticsearch_java_version]}" do
      command "eselect java-vm set system #{node[:elasticsearch_java_eselect_version]}"
      action :run
    end

    directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}" do
      owner "root"
      group "root"
      mode 0755
    end

    ["/var/log/elasticsearch", "/var/lib/elasticsearch", "/var/run/elasticsearch"].each do |dir|
      directory dir do
        owner "root"
        group "root"
        mode 0755
      end
    end

    bash "unzip elasticsearch" do
      user "root"
      cwd "/tmp"
      code %(unzip /tmp/elasticsearch-#{node[:elasticsearch_version]}.zip)
      not_if { File.exists? "/tmp/elasticsearch-#{node[:elasticsearch_version]}" }
    end

    bash "copy elasticsearch root" do
      user "root"
      cwd "/tmp"
      code %(cp -r /tmp/elasticsearch-#{node[:elasticsearch_version]}/* /usr/lib/elasticsearch-#{node[:elasticsearch_version]})
      not_if { File.exists? "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/lib" }
    end

    directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/plugins" do
      owner "root"
      group "root"
      mode 0755
    end

    link "/usr/lib/elasticsearch" do
      to "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}"
    end

    directory "#{node[:elasticsearch_home]}" do
      owner "elasticsearch"
      group "nogroup"
      mode 0755
    end

    directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/data" do
      owner "root"
      group "root"
      mode 0755
      action :create
      recursive true
    end

    if File.new("/proc/mounts").readlines.join.match(/\/usr\/lib[0-9]*\/elasticsearch-#{node[:elasticsearch_version]}\/data/)
      Chef::Log.info("Elastic search bind already complete")
    else
      mount "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/data" do
        device "#{node[:elasticsearch_home]}"
        fstype "none"
        options "bind,rw"
        action :mount
      end
    end

    template "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/config/logging.yml" do
      source "logging.yml.erb"
      mode 0644
    end

    directory "/usr/share/elasticsearch" do
      group "elasticsearch"
      group "nogroup"
      mode 0755
    end

    max_mem = ((node[:memory][:total].to_i / 1024 * 0.75)).to_i.to_s + "m"
    template "/usr/share/elasticsearch/elasticsearch.in.sh" do
      source "elasticsearch.in.sh.erb"
      mode 0644
      backup 0
      variables(
        :elasticsearch_version => node[:elasticsearch_version],
        :es_max_mem => ((node[:memory][:total].to_i / 1024 * 0.75)).to_i.to_s + "m"
      )
    end

    # include_recipe "elasticsearch::s3_bucket"
    template "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/config/elasticsearch.yml" do
      source "elasticsearch.yml.erb"
      owner "elasticsearch"
      group "nogroup"
      variables(
        :aws_access_key => node[:aws_secret_key],
        :aws_access_id => node[:aws_secret_id],
        :elasticsearch_s3_gateway_bucket => node[:elasticsearch_s3_gateway_bucket],
        :elasticsearch_instances => elasticsearch_instances.join('", "'),
        :elasticsearch_defaultreplicas => node[:elasticsearch_defaultreplicas],
        :elasticsearch_expected => elasticsearch_expected,
        :elasticsearch_defaultshards => node[:elasticsearch_defaultshards],
        :elasticsearch_clustername => node[:elasticsearch_clustername]
      )
      mode 0600
      backup 0
    end

    template "/etc/monit.d/elasticsearch_#{node[:elasticsearch_clustername]}.monitrc" do
      source "elasticsearch.monitrc.erb"
      owner "elasticsearch"
      group "nogroup"
      backup 0
      mode 0644
    end

    # Tell monit to just reload, if elasticsearch is not running start it.  If it is monit will do nothing.
    execute "monit reload" do
      command "monit reload"
    end
  end
end

# This portion of the recipe should run on all instances in your environment.  We are going to drop elasticsearch.yml for you so you can parse it and provide the instances to your application.
if ['solo','app_master','app','util'].include?(node[:instance_role])
  elasticsearch_hosts = []
  node['utility_instances'].each do |elasticsearch|
    if elasticsearch['name'].include?("elasticsearch_")
      elasticsearch_hosts << "#{elasticsearch['hostname']}:9200"
    end

    node.engineyard.apps.each do |app|
      template "/data/#{app.name}/shared/config/elasticsearch.yml" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0660
        source "es.yml.erb"
        backup 0
        variables(:yaml_file => {
          node.engineyard.environment.framework_env => { 
          :hosts => elasticsearch_hosts} })
      end
    end
  end
end
