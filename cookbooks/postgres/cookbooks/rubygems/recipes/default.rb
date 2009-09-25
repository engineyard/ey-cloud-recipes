require 'pp'
#
# Cookbook Name:: rubygems-1.3.5
# Recipe:: default
#
execute "fetch-rubygems" do
  command "wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz"
  action :run
end

execute "extract-rubygems" do
  command "tar zxvf rubygems-1.3.5.tgz"
  action :run
end

execute "install-rubygems" do
  command "cd rubygems-1.3.5; ruby setup.rb"
  action :run
end

execute "install-bundler" do
  command "gem install bundler"
  action :run
end
