#
# Cookbook Name:: phantomjs
# Attribute:: default
#
# Copyright 2012-2013, Seth Vargo (sethvargo@gmail.com)
# Copyright 2012-2013, CustomInk
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
#
# This is the default attributes file. Platform-specific attribute
# configurations are each contained in their {platform_name}.rb attribute
# file.
#

# The version of phantomjs to install
default['phantomjs']['version'] = '2.1.1'

# The list of packages to install
default['phantomjs']['packages'] = ['media-libs/fontconfig']

# The checksum of the tarball
default['phantomjs']['checksum'] = 'f8afc8a24eec34c2badccc93812879a3d6f2caf3'

# The default install method ('source' or 'package')
default['phantomjs']['install_method'] = 'source'

# The default package name and version
default['phantomjs']['package_name'] = 'www-client/phantomjs'
default['phantomjs']['package_version'] = '2.0.0'

# The src directory
default['phantomjs']['src_dir'] = '/usr/local/src'

# The base URL to download tarball from
default['phantomjs']['base_url'] = 'https://bitbucket.org/ariya/phantomjs/downloads'
# Older versions available from https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/phantomjs

# The name of the tarball to download (this is automatically calculated from
# the phantomjs version and kernel type)
default['phantomjs']['basename'] = "phantomjs-#{node['phantomjs']['version']}-linux-#{node['kernel']['machine']}"

return unless %w(gentoo).include?(node['platform_family'])

# The list of packages to install on gentoo-based systems
default['phantomjs']['packages'] = [
  'media-libs/fontconfig',
  'media-libs/freetype',
]
