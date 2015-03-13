services_to_disable = [
  {:name => "memcache_11211", :monit_file => "memcached"},
  {:name => "redis"}
]

services_to_disable.each do |svc|
  service_name = svc[:name]
  monit_file = svc[:monit_file] || svc[:name]
  monit_file_absolute_path = "/etc/monit.d/#{monit_file}.monitrc"

  ey_cloud_report "monit-disable" do
    message "Stopping and unmonitoring #{service_name}"
  end

  execute "stop #{service_name}" do
    command "monit stop #{service_name}"
    ignore_failure true
    only_if {::File.exists? monit_file_absolute_path}
  end

  execute "add a keep file" do
    command "touch /etc/monit.d/keep.#{monit_file}.monitrc"
    ignore_failure true
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
