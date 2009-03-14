#
# Cookbook Name:: integrity
# Recipe:: default
#
# Copyright 2009, Engine Yard, Inc.
#
# All rights reserved - Do Not Redistribute
#

if any_app_needs_recipe?('integrity')

  require 'digest/sha1'
  
  gem_package 'foca-integrity-email' do
    action :install
    source "http://gems.github.com"
  end
  
  gem_package 'foca-sinatra-ditties' do
    action :install
    source "http://gems.github.com"
  end
  
  gem_package 'do_sqlite3' do
    action :install
  end
  
  gem_package 'integrity' do
    action :install
    version '0.1.9.0'
  end
  
end

if_app_needs_recipe("integrity") do |app,data,index|
  
  execute "install integrity" do
    command "integrity install --passenger /data/#{app}/current"
  end

  template "/data/#{app}/current/config.ru" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0655
    source "config.ru.erb"
  end

  template "/data/#{app}/current/config.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0655
    source "config.yml.erb"
    variables({
      :app  => app,
      :domain  => data[:vhosts].first[:name],
    })
  end
  
end

