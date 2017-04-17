#
# Cookbook Name:: nodejs
# Attributes:: nodejs
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

case node['platform_family']
when 'smartos', 'rhel', 'debian', 'fedora'
  default['nodejs']['install_method'] = 'package'
else
  default['nodejs']['install_method'] = 'source'
end

default['nodejs']['version'] = '0.10.26'

default['nodejs']['prefix_url'] = 'http://nodejs.org/dist/'

default['nodejs']['install_repo'] = true

default['nodejs']['source']['url']      = nil # Auto generated
default['nodejs']['source']['checksum'] = 'ef5e4ea6f2689ed7f781355012b942a2347e0299da0804a58de8e6281c4b1daa'

default['nodejs']['binary']['url'] = nil # Auto generated
default['nodejs']['binary']['checksum']['linux_x64'] = '305bf2983c65edea6dd2c9f3669b956251af03523d31cf0a0471504fd5920aac'
default['nodejs']['binary']['checksum']['linux_x86'] = '8fa2d952556c8b5aa37c077e2735c972c522510facaa4df76d4244be88f4dc0f'
default['nodejs']['binary']['checksum']['linux_arm-pi'] = '561ec2ebfe963be8d6129f82a7d1bc112fb8fbfc0a1323ebe38ef55850f25517'

default['nodejs']['make_threads'] = node['cpu'] ? node['cpu']['total'].to_i : 2
