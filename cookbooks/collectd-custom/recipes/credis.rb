#
# Cookbook Name:: collectd-custom
# Recipe:: credis
#
# Installs credis library for use by the redis collectd plugin
#

attributes = node['collectd-custom']['credis']

# Download source
remote_file "#{Chef::Config[:file_cache_path]}/credis-#{attributes['version']}.tar.gz" do
  source attributes['source_url']
  checksum attributes['checksum']
  action :create_if_missing
end

# Compile
bash "install-credis" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    [ -d credis-#{attributes['version']}/ ] || mkdir credis-#{attributes['version']}/
    tar -xzf credis-#{attributes['version']}.tar.gz -C credis-#{attributes['version']}/ --strip 1
    cd credis-#{attributes['version']}
    make
    cp -f libcredis.so /usr/lib
    cp -f libcredis.a /usr/include
    cp -f credis.h /usr/include
  EOH
  not_if "[ -f /usr/lib/libcredis.so ]"
end
