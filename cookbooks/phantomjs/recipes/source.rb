# Installs specified PhantomJS version from source

directory node['phantomjs']['src_dir'] do
  mode    '0755'
  owner   'root'
  group   'root'
end

# Install supporting packages
node['phantomjs']['packages'].each { |name| package name }

version  = node['phantomjs']['version']
base_url = node['phantomjs']['base_url']
src_dir  = node['phantomjs']['src_dir']
basename = node['phantomjs']['basename']
checksum = node['phantomjs']['checksum']

remote_file "#{src_dir}/#{basename}.tar.bz2" do
  owner     'root'
  group     'root'
  mode      '0644'
  backup    false
  source    "#{base_url}/#{basename}.tar.bz2"
  checksum  checksum if checksum
  not_if    { ::File.exists?('/usr/local/bin/phantomjs') && `/usr/local/bin/phantomjs --version`.chomp == version }
  notifies  :run, 'execute[phantomjs-install]', :immediately
end

execute 'phantomjs-install' do
  command   "tar -xvjf #{src_dir}/#{basename}.tar.bz2 -C /usr/local/"
  action    :nothing
  notifies  :create, 'link[phantomjs-link]', :immediately
end

link 'phantomjs-link' do
  target_file   '/usr/local/bin/phantomjs'
  to            "/usr/local/#{basename}/bin/phantomjs"
  owner         'root'
  group         'root'
  action        :nothing
end
