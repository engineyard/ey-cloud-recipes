#
# Cookbook Name:: collectd-custom
# Recipe:: librato
#
# Installs the librato plugin for the collectd-custom process
#

attributes = node['collectd-custom']
librato = attributes['librato']
plugin_path = "#{attributes['dir']}/lib/collectd/collectd-librato.py"

directory librato['src_dir'] do
  user attributes['user']
  group attributes['user']
  recursive true
  action :create
end

execute "install collectd-librato" do
  user "root"
  cwd librato['src_dir']
  command "git clone #{librato['repo']} ."
  not_if { File.exists?("#{librato['src_dir']}/.git/")}
end

execute "checkout specific collectd-librato version" do
  cwd librato['src_dir']
  command "git checkout v#{librato['version']}"
  not_if "git describe | grep v#{librato['version']}"
end

execute "install collectd-librato plugin" do
  cwd librato['src_dir']
  command "cp -f lib/collectd-librato.py #{plugin_path}"
end

collectd_python_plugin "collectd-librato" do
  path plugin_path
  opts = {
    'APIToken' => librato['api_token'],
    'Email' => librato['email']
  }

  opts['Api'] = librato['api'] if librato['api']
  opts.merge!(librato['extra_config']) if librato['extra_config']

  options(opts)
end

# Delete legacy file, was moved to simplercpu recipe instead
file "/data/collectd.d/librato-aggregate-cpu.conf" do
  action :delete
  notifies :restart, "service[#{attributes['service_name']}]"
end
