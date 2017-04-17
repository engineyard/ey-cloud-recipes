#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2010-2012, Promet Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#include_recipe 'nodejs::nodejs'
#include_recipe 'nodejs::npm'

if app_server? || util?
  ey_cloud_report "npm-package-install" do
    message "Installing npm packages"
  end

  execute "eselect-nodejs-0.10.38" do
    command <<-EOM
      eselect nodejs set 0.10.38
    EOM
    user 'root'
  end

  node['nodejs']['npm_packages'].each do |pkg|
    f = nodejs_npm pkg['name'] do
      action :nothing
    end
    pkg.reject { |k, _v| k == 'name' || k == 'action' }.each do |key, value|
      f.send(key, value)
    end
    action = pkg.key?('action') ? pkg['action'] : :install
    f.action(action)
  end if node['nodejs'].key?('npm_packages')
end
