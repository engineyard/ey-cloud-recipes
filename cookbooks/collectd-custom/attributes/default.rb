#
# Cookbook Name:: collectd-custom
# Attributes:: default
#

# default attributes for all platforms
default['collectd-custom']['service_name'] = 'collectd-custom'
default['collectd-custom']['version']      = "5.4.0"
default['collectd-custom']['source_url']   = "http://fossies.org/linux/privat/collectd-#{node['collectd-custom']['version']}.tar.gz"
default['collectd-custom']['checksum']     = "a90fe6cc53b76b7bdd56dc57950d90787cb9c96e"
default['collectd-custom']['dir']          = "/var/lib/collectd-custom"
default['collectd-custom']['pid_file']     = "/var/run/collectd/custom.pid"
default['collectd-custom']['interval']     = 30
default['collectd-custom']['read_threads'] = 5
default['collectd-custom']['hostname']     = nil
default['collectd-custom']['packages']     = ['dev-libs/libgcrypt','sys-devel/libtool']
default['collectd-custom']['user']         = 'root'

# redis plugin requires credis, so provide those details
default['collectd-custom']['credis']['version']    = '0.2.3'
default['collectd-custom']['credis']['source_url'] = "http://credis.googlecode.com/files/credis-#{node['collectd-custom']['credis']['version']}.tar.gz"
default['collectd-custom']['credis']['checksum']   = "052ad7ebedf86ef3825a3863cf802baf289a624b"

# graphite configuration if you want to report there
default['collectd-custom']['graphite']['host'] = nil
default['collectd-custom']['graphite']['port'] = 2003
default['collectd-custom']['graphite']['extra_config'] = {
  'Protocol' => 'tcp',
  'Prefix' => 'collectd.'
}

# librato configuration if you want to report there
default['collectd-custom']['librato']['src_dir'] = '/var/lib/collectd-librato'
default['collectd-custom']['librato']['repo']    = 'https://github.com/librato/collectd-librato.git'
default['collectd-custom']['librato']['version'] = '0.0.10'

# provide your librato credentials:
default['collectd-custom']['librato']['email'] = nil
default['collectd-custom']['librato']['api_token'] = nil
default['collectd-custom']['librato']['extra_config'] = {
  # Config for the librato collection plugin
  # For full reference see https://github.com/librato/collectd-librato/blob/master/README.md
  'TypesDB' => "#{node['collectd-custom']['dir']}/share/collectd/types.db",
  'LowercaseMetricNames' => true
}

# plugins to automatically include
default['collectd-custom']['plugins'] = {
  'logfile' => { 'config' => {
    'LogLevel' => 'info',
    'File' => '/var/log/collectd-custom.log',
    'Timestamp' => true
  } },
  'cpu' => {},
  'load' => {},
  'swap' => {},
  'memory' => {},
  'disk' => { 'config' => {
    'Disk' => '/^xv/',
    'IgnoreSelected' => false
  } },
  'interface' => { 'config' => {
    'Interface' => 'eth0',
    'IgnoreSelected' => false
  } }

  # Maybe you want to log to syslog instead?
  # 'syslog'  => { 'config' => {
  #   'LogLevel' => 'info'
  # } },

  # You can track all memcached instances if you want, or override
  # on your memcached instance if you have one.
  # 'memcached' => { 'config' => {
  #   'Host' => '127.0.0.1', 'Port' => '11211'
  # } },
}
