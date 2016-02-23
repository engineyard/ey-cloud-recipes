#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Credit goes to GoTime for their original recipe ( http://cookbooks.opscode.com/cookbooks/elasticsearch )

if ['solo','app_master'].include?(node[:instance_role])
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

solo = node[:instance_role] == 'solo'
if ['solo','app_master','app','util'].include?(node[:instance_role])
  node.engineyard.apps.each do |app|
    template "/data/#{app.name}/shared/config/elasticsearch.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0660
      source "es.yml.erb"
      backup 0
      variables(:yaml_file => {
        node.engineyard.environment.framework_env => {
        :hosts => solo ? "127.0.0.1:9200" : "#{node[:master_app_server][:public_ip]}:9200" }})
    end
  end
end
