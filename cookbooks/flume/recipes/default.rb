#
# Cookbook Name:: flume
# Recipe:: default
#
# NOTE: This recipe attempts to install Java, which is required by Flume
# If you're running Solr on the environment,
# you need to ensure that Solr and Flume are using the same Java version

use_default_java = false
java_package_name = "dev-java/icedtea-bin"
java_version = node['flume']['java_version']
java_eselect_version = node['flume']['java_eselect_version']
flume_version = node['flume']['flume_version']
flume_dir = "/opt/flume"
flume_file = "apache-flume-#{flume_version}-bin.tar.gz"
flume_url = "http://archive.apache.org/dist/flume/#{flume_version}/#{flume_file}"

instance_id = `curl http://169.254.169.254/latest/meta-data/instance-id`
unique_agent_id = instance_id.split('-').last
agent_name = instance_id
conf_dir = "#{flume_dir}/conf"
conf_file = "#{conf_dir}/flume.conf"
flume_log_file = "/var/log/engineyard/flume/flume.log"

app_name = node['flume']['app_name']
app_logfile = node['flume']['app_logfile']
sink_hostname = node['flume']['sink_hostname']
sink_port = node['flume']['sink_port']

# Install Flume on all app instances
if ( ['app_master', 'app', 'solo'].include?(node[:instance_role]) )

  unless use_default_java
    Chef::Log.info "Updating Java JDK"
    enable_package java_package_name do
      version java_version
      unmask true
    end

    package java_package_name do
      version java_version
      action :upgrade
    end

    execute "Set the default Java version to #{java_eselect_version}" do
      command "eselect java-vm set system #{java_eselect_version}"
      action :run
    end
  end

  directory "/var/log/engineyard/flume" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    recursive true
  end


  remote_file "/opt/#{flume_file}" do
    source flume_url
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    backup 0
    action :create_if_missing
  end

  execute "unarchive flume" do
    cwd "/opt"
    command "tar zxf #{flume_file} && sync"
    not_if { FileTest.directory?(flume_dir) }
  end

  execute "rename /opt/apache-flume-#{flume_version}-bin to #{flume_dir}" do
    command "mv /opt/apache-flume-#{flume_version}-bin #{flume_dir}"
    not_if { FileTest.directory?(flume_dir) }
  end

  execute "chown flume_dir" do
    command "chown #{node[:owner_name]}:#{node[:owner_name]} -R #{flume_dir}"
  end

  template "/engineyard/bin/flume-start.sh" do
    source "flume-start.sh.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  variables({
    :rails_env => node[:environment][:framework_env],
    :flume_dir => flume_dir,
    :bin_dir => "#{flume_dir}/bin",
    :conf_dir => conf_dir,
    :conf_file => conf_file,
    :log_file => flume_log_file,
    :agent_name => agent_name
  })
  end

  template conf_file do
    source "flume.conf.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables({
      :instance_id => instance_id,
      :agent_id => unique_agent_id,
      :app_name => app_name,
      :app_logfile => app_logfile,
      :hostname => sink_hostname,
      :port => sink_port
    })
  end

  remote_file "#{conf_dir}/log4j.properties" do
    source "log4j.properties"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
  end

  remote_file "/etc/monit.d/flume.monitrc" do
    source "flume.monitrc"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
  end

  execute "monit-reload" do
    command "monit quit && telinit q"
  end

  execute "start-solr" do
    command "sleep 3 && monit start flume"
  end
end
