services = [
  {:name => "memcache_11211", :monit_file => "memcached"},
  {:name => "redis"}
]

services.each do |service|
  service_name = service[:name]
  monit_file = service[:monit_file] || service[:name]
  monit_file_absolute_path = "/etc/monit.d/#{monit_file}.monitrc"

  ey_cloud_report "monit-disable" do
    message "Stopping and unmonitoring #{service_name}"
  end

  execute "stop #{service_name}" do
    command "monit stop #{service_name}"
    ignore_failure true
    only_if {::File.exists? monit_file_absolute_path}
  end

  execute "monit reload" do
    action :nothing
  end

  file monit_file_absolute_path do
    action :delete
    only_if {::File.exists? monit_file_absolute_path}
    notifies :run, resources(:execute => "monit reload")
  end

end
