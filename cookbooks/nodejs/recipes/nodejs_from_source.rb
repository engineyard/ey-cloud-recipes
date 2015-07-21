#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: nodejs
# Recipe:: source
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

Chef::Resource::User.send(:include, NodeJs::Helper)

include_recipe 'build-essential'

case node['platform_family']
when 'rhel', 'fedora'
  package 'openssl-devel'
when 'debian'
  package 'libssl-dev'
end

version = "v#{node['nodejs']['version']}/"
filename = "node-v#{node['nodejs']['version']}.tar.gz"
nodejs_src_url = node['nodejs']['source']['url'] || ::URI.join(node['nodejs']['prefix_url'], version, filename).to_s

ark 'nodejs-source' do
  url nodejs_src_url
  version node['nodejs']['version']
  checksum node['nodejs']['source']['checksum']
  make_opts ["-j #{node['nodejs']['make_threads']}"]
  action :install_with_make
end
