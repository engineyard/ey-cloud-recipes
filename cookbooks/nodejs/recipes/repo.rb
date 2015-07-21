case node['platform_family']
when 'debian'
  include_recipe 'apt'

  package 'apt-transport-https'

  apt_repository 'node.js' do
    uri node['nodejs']['repo']
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key node['nodejs']['key']
  end
when 'rhel'
  include_recipe 'yum-epel'
end
