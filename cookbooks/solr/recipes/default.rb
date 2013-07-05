#
# Cookbook Name:: solr
# Recipe:: default
#
# We specify what version we want below.
solr_desiredversion = 1.4
if ['solo', 'util'].include?(node[:instance_role])
  if solr_desiredversion == 1.3
    solr_file = "apache-solr-1.3.0.tgz"
    solr_dir = "apache-solr-1.3.0"
    solr_url = "http://archive.apache.org/dist/lucene/solr/1.3.0/apache-solr-1.3.0.tgz"
  else
    solr_dir = "apache-solr-1.4.1"
    solr_file = "apache-solr-1.4.1.tgz"
    solr_url = "http://archive.apache.org/dist/lucene/solr/1.4.1/apache-solr-1.4.1.tgz"
  end

  directory "/var/run/solr" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  directory "/var/log/engineyard/solr" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    recursive true
  end

  template "/engineyard/bin/solr" do
    source "solr.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  variables({
    :rails_env => node[:environment][:framework_env]
  })
  end

  template "/etc/monit.d/solr.monitrc" do
    source "solr.monitrc.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables({
      :user => node[:owner_name],
      :group => node[:owner_name]
    })
  end

  remote_file "/data/#{solr_file}" do
    source "#{solr_url}"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    backup 0
    not_if { FileTest.exists?("/data/#{solr_file}") }
  end

  execute "unarchive solr-to-install" do
    command "cd /data && tar zxf #{solr_file} && sync"
    not_if { FileTest.directory?("/data/#{solr_dir}") }
  end

  execute "install solr example package" do
    command "cd /data/#{solr_dir} && mv example /data/solr"
    not_if { FileTest.exists?("/data/solr/start.jar") }
  end

   directory "/data/solr" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

   execute "chown_solr" do
     command "chown #{node[:owner_name]}:#{node[:owner_name]} -R /data/solr"
   end

   execute "monit-reload" do
     command "monit quit && telinit q"
   end

   execute "start-solr" do
     command "sleep 3 && monit start solr_9080"
   end
end
