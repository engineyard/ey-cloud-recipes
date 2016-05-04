ey_cloud_report "filebeat" do
 message "Filebeat::Install Start"
end

filebeat_file = "filebeat-#{node['filebeat']['version']}-x86_64.tar.gz"
filebeat_url = " https://download.elastic.co/beats/filebeat/filebeat-#{node['filebeat']['version']}-x86_64.tar.gz"
filebeat_dir = "filebeat-#{node['filebeat']['version']}-x86_64"

remote_file "/opt/#{filebeat_file}" do
     source "#{filebeat_url}"
     owner 'root'
     group 'root'
     mode '644'
     backup 0
     not_if { FileTest.exists?("/opt/#{filebeat_file}") }
 end

 execute "unarchive filebeat" do
    command "cd /opt && tar zxf #{filebeat_file} && sync"
    not_if { FileTest.directory?("/opt/#{filebeat_dir}") }
end

template "/opt/filebeat-#{filebeat_dir}/filebeat.yml" do
  source 'filebeat.yml.erb'
  owner 'root'
  group 'root'
  mode '640'
  variables({
    :host => node.default['filebeat']['logstash']['host'],
    :port => node.default['filebeat']['logstash']['port'],
  })
end

execute "start filebeat" do
    command "cd #{filebeat_dir} && ./filebeat -e -c /opt/#{filebeat_dir}filebeat.yml -d "publish""
    not_if { FileTest.exists?("/opt/#{filebeat_dir}/filebeat.yml") }
  end
