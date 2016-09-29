#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Credit goes to GoTime for their original recipe ( http://cookbooks.opscode.com/cookbooks/elasticsearch )

version = node[:elasticsearch_version]
download_url = "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/#{version}/elasticsearch-#{version}.zip"
if ['solo','app_master'].include?(node[:instance_role])
  Chef::Log.info "Downloading Elasticsearch v#{node[:elasticsearch_version]} checksum #{node[:elasticsearch_checksum]}"
  remote_file "/tmp/elasticsearch-#{version}.zip" do
    source download_url
    mode "0644"
    checksum node[:elasticsearch_checksum]
    not_if { File.exists?("/tmp/elasticsearch-#{version}.zip") }
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

  # Forcing 'install' because if lower version packages are installed
  # then 'upgrade' installs the desired version every time it runs.
  package node[:elastic_search_java_package_name] do
    version node[:elasticsearch_java_version]
    action :install
  end

  execute "Set the default Java version to #{node[:elasticsearch_java_version]}" do
    command "eselect java-vm set system #{node[:elasticsearch_java_eselect_version]}"
    action :run
  end

  directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}" do
    owner "elasticsearch"
    group "nogroup"
    mode 0755
  end

  ["/var/log/elasticsearch", "/var/lib/elasticsearch", "/var/run/elasticsearch"].each do |dir|
    directory dir do
      owner "elasticsearch"
      group "nogroup"
      mode 0755
    end
  end

  bash "unzip elasticsearch" do
    user "elasticsearch"
    cwd "/tmp"
    code %(unzip /tmp/elasticsearch-#{node[:elasticsearch_version]}.zip)
    not_if { File.exists? "/tmp/elasticsearch-#{node[:elasticsearch_version]}" }
  end

  bash "copy elasticsearch root" do
    user "elasticsearch"
    cwd "/tmp"
    code %(cp -r /tmp/elasticsearch-#{node[:elasticsearch_version]}/* /usr/lib/elasticsearch-#{node[:elasticsearch_version]})
    not_if { File.exists? "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/lib" }
  end

  directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/plugins" do
    owner "elasticsearch"
    group "nogroup"
    mode 0755
  end

  link "/usr/lib/elasticsearch" do
    to "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}"
    owner "elasticsearch"
    group "nogroup"
    mode 0755
  end

  directory "#{node[:elasticsearch_home]}" do
    owner "elasticsearch"
    group "nogroup"
    mode 0755
  end

  # Fix permissions in case we're upgrading from ES 1.x
  execute "set-permissions-data-dir" do
    command "chown -R elasticsearch:nogroup #{node[:elasticsearch_home]}/*"
    user "root"
    action :run
    only_if "[[ -f #{node[:elasticsearch_home]}/* ]]"
    not_if "stat -c %U #{node[:elasticsearch_home]}/* |grep elasticsearch"
  end

  # Fix file permissions on log dir in case we're upgrading from ES 1.x
  execute "set-permissions-log-dir" do
    command "chown -R elasticsearch:nogroup /var/log/elasticsearch/*"
    user "root"
    action :run
    only_if "ls -1 /var/log/elasticsearch/ | wc -l"
    only_if "stat -c %U /var/log/elasticsearch/*log* |grep -v elasticsearch"
  end

  directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/data" do
    owner "elasticsearch"
    group "nogroup"
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

  # Add log rotation for the elasticsearch logs
  remote_file "/etc/logrotate.d/elasticsearch" do
    source "elasticsearch.logrotate"
    owner "root"
    group "root"
    mode "0644"
    backup 0
  end

  template "/etc/monit.d/elasticsearch_#{node[:elasticsearch_clustername]}.monitrc" do
    source "elasticsearch.monitrc.erb"
    owner "elasticsearch"
    group "nogroup"
    backup 0
    mode 0644
    variables(:owner => "elasticsearch")
  end

  # Tell monit to just reload, if elasticsearch is not running start it.  If it is monit will do nothing.
  execute "monit reload" do
    command "monit reload"
  end
end

solo = node[:instance_role] == 'solo'
host_port = if solo
  "127.0.0.1:9200"
else
  app_master_instance = node[:engineyard][:environment][:instances].find { |instance| instance[:role] == 'app_master' }
  if app_master_instance
    app_master_host = app_master_instance[:public_hostname]
  else
    "127.0.0.1:9200"
  end
end

if ['solo','app_master','app','util'].include?(node[:instance_role])
  node[:applications].each do |app_name, data|
    template "/data/#{app_name}/shared/config/elasticsearch.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0660
      source "es.yml.erb"
      backup 0
      variables(
        :yaml_file => {
          node[:environment][:framework_env] => {
            :hosts => host_port
          }
        }
      )
    end
  end
end
