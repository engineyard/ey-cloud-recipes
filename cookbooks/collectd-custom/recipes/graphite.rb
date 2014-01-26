#
# Cookbook Name:: collectd-custom
# Recipe:: graphite
#
# Installs and configures the WriteGraphite plugin for the collectd-custom process
#

graphite = node['collectd-custom']['graphite']

collectd_plugin "write_graphite" do
  opts = {
    'Node' => {
      'carbon' => { 'Host' => graphite['host'], 'Port' => graphite['port'] }
    }
  }
  opts['Node']['carbon'].merge!(graphite['extra_config']) if graphite['extra_config']
  options(opts)

  not_if { graphite['host'].nil? }
end
