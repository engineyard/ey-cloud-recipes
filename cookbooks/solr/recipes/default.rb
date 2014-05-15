#
# Cookbook Name:: solr
# Recipe:: default
#

if util?(node[:solr][:master_instance_name]) || util?(node[:solr][:slave_instance_name])
  solr_dir = "apache-solr-#{node[:solr][:version]}"
  solr_file = "apache-solr-#{node[:solr][:version]}.tgz"
  solr_url = "http://archive.apache.org/dist/lucene/solr/#{node[:solr][:version]}/#{solr_file}"

  master_port = "8983"
  master_host = node['utility_instances'].find { |instance| instance['name'] == node[:solr][:master_instance_name] }

  if util?(node[:solr][:master_instance_name])
    solr_role = "master"
  else
    solr_role = "slave"
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

  execute "force-solr-logrotate" do
    command "logrotate -f /etc/logrotate.d/solr"
    action :nothing
  end

  remote_file "/etc/logrotate.d/solr" do
    owner "root"
    group "root"
    mode 0755
    source "solr.logrotate"
    backup false
    action :create
    notifies :run, resources(:execute => "force-solr-logrotate")
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
      :solr_role => solr_role,
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

#  template "/data/solr/solr/conf/solrconfig.xml" do
#    source "solrconfig.xml.erb"
#    owner node[:owner_name]
#    group node[:owner_name]
#    mode 0755
#    variables({
#      :solr_role => solr_role,
#      :master_host => master_host,
#      :master_port => master_port
#    })
#  end

#  remote_file "/data/solr/solr/conf/schema.xml" do
#    source "schema.xml"
#    owner node[:owner_name]
#    group node[:owner_name]
#    mode 0644
#    backup 0
#  end

  execute "monit-reload" do
   command "monit quit && telinit q"
  end

  execute "start-solr" do
   command "sleep 3 && monit start solr_#{solr_role}"
  end
end
