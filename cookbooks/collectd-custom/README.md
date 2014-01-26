collectd-custom Cookbook
========================

This cookbook will install a secondary collectd process on your instances so that it does not interfere with Engine Yard's primary collectd process. This way you can install your own plugins, alerting components, etc without having to worry what Engine Yard has set up.

So that it does not interfere at all, it will compile collectd from source rather than using `emerge` and install it to `/var/lib/collectd-custom` (or your own directory of choice).

Requirements
------------

### Platforms

* Engine Yard Gentoo 12.11 stack

Other Gentoo platforms should work fine as well.

TL;DR
-----

If you don't want to read the rest of this README, you can just paste this in your `main::default` recipe and get most of the way there:

```ruby
service "monit" do
  supports [:start, :restart, :reload, :stop]
  action :nothing
end

include_recipe "collectd-custom::credis"
include_recipe "collectd-custom"
include_recipe "collectd-custom::simplercpu"
# include_recipe "collectd-custom::graphite"
# include_recipe "collectd-custom::librato"
include_recipe "collectd-custom::monit"
```

You'll now need to include either [`collectd-custom::librato`](#collectd-customlibrato) or [`collectd-custom::graphite`](#collectd-customgraphite) as your backend of choice.

Attributes
----------

The following are the default attributes used when running chef. You can modify them in your own repo, or override them in your `main/recipes/default.rb` recipe as such:

```ruby
node.override['collectd-custom']['service_name'] = 'my-collectd-service'
```

#### default['collectd-custom']

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>service_name</tt></td>
    <td>String</td>
    <td>Name of the custom collectd service.</td>
    <td><tt>collectd-custom</tt></td>
  </tr>
  <tr>
    <td><tt>version</tt></td>
    <td>String</td>
    <td>Version of collectd to install.</td>
    <td><tt>5.4.0</tt></td>
  </tr>
  <tr>
    <td><tt>source_url</tt></td>
    <td>String</td>
    <td>URL from which to download the collectd source.</td>
    <td><tt>http://fossies.org/linux/privat/collectd-5.4.0.tar.gz</tt></td>
  </tr>
  <tr>
    <td><tt>checksum</tt></td>
    <td>String</td>
    <td>SHA checksum of the source archive for validation.</td>
    <td><tt>a90fe6cc53b76b7bdd56dc57950d90787cb9c96e</tt></td>
  </tr>
  <tr>
    <td><tt>dir</tt></td>
    <td>String</td>
    <td>Absolute directory to install collectd to.</td>
    <td><tt>/var/lib/collectd-custom</tt></td>
  </tr>
  <tr>
    <td><tt>pid_file</tt></td>
    <td>String</td>
    <td>Absolute path to the pid file to use.</td>
    <td><tt>/var/run/collectd-custom.pid</tt></td>
  </tr>
  <tr>
    <td><tt>interval</tt></td>
    <td>Integer</td>
    <td>Interval for use in <tt>collectd.conf</tt>.</td>
    <td><tt>30</tt></td>
  </tr>
  <tr>
    <td><tt>read_threads</tt></td>
    <td>Integer</td>
    <td>Number of read threads for use in <tt>collectd.conf</tt>.</td>
    <td><tt>5</tt></td>
  </tr>
  <tr>
    <td><tt>hostname</tt></td>
    <td>String</td>
    <td>Hostname for the collectd process for use in <tt>collectd.conf</tt>.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>packages</tt></td>
    <td>Array</td>
    <td>Packages to install with collectd. Usually just the dependencies.</td>
    <td><tt>['dev-libs/libgcrypt','sys-devel/libtool']</tt></td>
  </tr>
  <tr>
    <td><tt>user</tt></td>
    <td>String</td>
    <td>User to run collectd as. <strong>NOTE:</strong> This user will not be setup as part of the recipe, you must create it elsewhere.</td>
    <td><tt>root</tt></td>
  </tr>
</table>

#### default['collectd-custom']['credis']

If you want to install the redis plugin, you must include the `credis` recipe. These attributes are used for that.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>version</tt></td>
    <td>String</td>
    <td>Version of credis to install.</td>
    <td><tt>0.2.3</tt></td>
  </tr>
  <tr>
    <td><tt>source_url</tt></td>
    <td>String</td>
    <td>URL from which to download the credis source.</td>
    <td><tt>http://credis.googlecode.com/files/credis-0.2.3.tar.gz</tt></td>
  </tr>
  <tr>
    <td><tt>checksum</tt></td>
    <td>String</td>
    <td>SHA checksum of the credis archvice for validation.</td>
    <td><tt>052ad7ebedf86ef3825a3863cf802baf289a624b</tt></td>
  </tr>
</table>

#### default['collectd-custom']['graphite']

If you want to have collectd report to graphite, you must include the `graphite` recipe. These attributes are used for that.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>host</tt></td>
    <td>String</td>
    <td>Hostname or IP address of your graphite installation.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>port</tt></td>
    <td>Integer</td>
    <td>Port that graphite will listen on.</td>
    <td><tt>2003</tt></td>
  </tr>
  <tr>
    <td><tt>extra_config</tt></td>
    <td>Hash</td>
    <td>Extra configuration values to be passed to graphite's config.</td>
    <td>See <tt>attributes/default.rb</tt></td>
  </tr>
</table>

#### default['collectd-custom']['librato']

If you want to have collectd report to librato, you must include the `librato` recipe. These attributes are used for that.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>src_dir</tt></td>
    <td>String</td>
    <td>Absolute directory to install `collectd-librato` to.</td>
    <td><tt>/var/lib/collectd-librato</tt></td>
  </tr>
  <tr>
    <td><tt>repo</tt></td>
    <td>String</td>
    <td>Git repository address for `collectd-librato`.</td>
    <td><tt>https://github.com/librato/collectd-librato.git</tt></td>
  </tr>
  <tr>
    <td><tt>version</tt></td>
    <td>String</td>
    <td>Git version tag used when checking out the repo.</td>
    <td><tt>0.0.10</tt></td>
  </tr>
  <tr>
    <td><tt>email</tt></td>
    <td>String</td>
    <td>Your librato account's email.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>api_token</tt></td>
    <td>String</td>
    <td>Your librato account's API token.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>extra_config</tt></td>
    <td>Hash</td>
    <td>Extra configuration values to be passed to collectd-librato's config. See <a href="https://github.com/librato/collectd-librato/blob/master/README.md#configuration">README</a> for all options.</td>
    <td>See <tt>attributes/default.rb</tt></td>
  </tr>
</table>

#### default['collectd-custom']['plugins']

You can specify all the plugins you want and their configuration values directly from attributes if you please. A set number of defaults are installed automatically, but you can remove them as you see fit.

```ruby
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
```

Alternatively, you can install them via the [`collectd_plugin`](#definitions) or [`collectd_python_plugin`](#definitions) definitions.

Recipes
-------

#### collectd-custom::default

This recipe will install all dependencies (except for credis), compile collectd from source, create configuration files, install plugins, and setup collectd as a service.

To use, just add it to your node's `run_list`, or in the case of Engine Yard, reference it from another cookbook:

```ruby
include_recipe "collectd-custom"
```

#### collectd-custom::plugins

This recipe is automatically included via `collectd-custom::default` so you don't need to specify it yourself.

This recipe will install any plugins configured via the node attributes and delete any plugins that were automatically generated and no longer in use.

#### collectd-custom::librato

This recipe is optional.

This recipe will install collectd-librato and configure your custom collectd process to report to it. You must provide `node['collectd-custom']['librato']['email']` and `node['collectd-custom']['librato']['api_token']` for this to work properly.

To use, just add it to your node's `run_list`, or in the case of Engine Yard, reference it from another cookbook after the `default` recipe:

```ruby
include_recipe "collectd-custom"
include_recipe "collectd-custom::librato"
```

#### collectd-custom::graphite

This recipe is optional.

This recipe will enable the collectd graphite write plugin for reporting its metrics. You must provide `node['collectd-custom']['graphite']['host']` for this to work properly. Even if you don't host Graphite yourself, it may be useful to enable this while testing on EY Local or Vagrant.

To use, just add it to your node's `run_list`, or in the case of Engine Yard, reference it from another cookbook after the `default` recipe:

```ruby
include_recipe "collectd-custom"
include_recipe "collectd-custom::graphite"
```

#### collectd-custom::monit

This recipe is optional.

This recipe will setup monit to track your custom collectd process. Otherwise, it will not restart if it crashes or gets killed. You can also set it up in `inittab` if you prefer, but that recipe is not provided.

To use, just add it to your node's `run_list`, or in the case of Engine Yard, reference it from another cookbook after the `default` recipe:

```ruby
include_recipe "collectd-custom"
include_recipe "collectd-custom::monit"
```

You may also need to define your monit service in another of your cookbooks if you haven't already. This is for the proper reload notifications to work. To do that, include the following in another of your recipes, maybe `monit::service`:

```ruby
service "monit" do
  supports [:start, :restart, :reload, :stop]
  action :nothing
end
```

#### collectd-custom::credis

This recipe is required if you intend to use the redis plugin.

This recipe will download and compile [credis](https://code.google.com/p/credis/) for use when compiling collectd. Failure to include this recipe will result in no redis plugin being compiled.

To use, just add it to your node's `run_list`, or in the case of Engine Yard, reference it from another cookbook. It **must** come before the `default` recipe:

```ruby
include_recipe "collectd-custom::credis"
include_recipe "collectd-custom"
```

If you previously had collectd compiled before including the redis plugin, you will need to recompile. That recipe is provided.

#### collectd-custom::recompile

This recipe is optional and advisable to use only after making drastric changes.

This recipe will remove collectd and recompile it from source. Useful if you added plugin depencides after collectd has already been compiled but needs recompiling to get those plugins enabled.

**NOTE:** This recipe should not be necessary for version upgrades.

To use, just add it to your node's `run_list`, or in the case of Engine Yard, reference it from another cookbook replacing the `default` recipe:

```ruby
include_recipe "collectd-custom::recompile"
```

#### collectd-custom::simplercpu

This recipe is optional but recommended.

This recipe will enable an aggregate plugin to aggregate CPU measurements per [Librato's recommendations](https://github.com/librato/collectd-librato/blob/master/README.md#simpler-cpu-metrics). Even if you aren't using Librato, consoliding your CPU measurements may be helpful.

To use, just add it to your node's `run_list`, or in the case of Engine Yard, reference it from another cookbook replacing the `default` recipe:

```ruby
include_recipe "collectd-custom::simplercpu"
```

Definitions
-----------

You can install collectd plugins from your own recipes too.

```ruby
collectd_plugin "postgresql" do
  cookbook "main"                        # default: collectd-custom
  template "postgresql.plugin.conf.erb"  # default: plugin.conf.erb
  options({
    'Database' => {
      'myapp' => { 'Host' => 'localhost', 'Port' => '5432', 'User' => 'postgres', 'Password' => node[:owner_pass] }
    }
  })
  only_if { node[:instance_role] == 'db_master' }
end
```

Or for python plugins:

```ruby
collectd_python_plugin "collectd-librato" do
  path "/usr/local/bin/some-plugin.py"
  module "some-module"
  options({
    'ApiToken' => 'some-token'
  })
end
```

So it may be useful for you to end up with your own `collectd-plugins` cookbook that generates your plugin configurations. For example, in my `main::default` recipe, I would include the plugins I defined:

```ruby
include_recipe "collectd-custom::librato" unless vagrant?
include_recipe "collectd-custom::graphite" if vagrant?

include_recipe "collectd-plugins::df"
include_recipe "collectd-plugins::filecount"
include_recipe "collectd-plugins::memcached" if util?(:memcached)
include_recipe "collectd-plugins::nginx" if app_server?
include_recipe "collectd-plugins::postgresql" if db_server?
include_recipe "collectd-plugins::redis" if util?(:redis)
include_recipe "collectd-plugins::resque" if util?(:redis)
```

See also
--------

This cookbook has been refactored and adapted for the EY Gentoo platform, inspired by these fine recipes:

* [hectcastro/chef-collectd](https://github.com/hectcastro/chef-collectd)
* [coderanger/chef-collectd](https://github.com/coderanger/chef-collectd)

Check them out if you have needs on other platforms.

License and Authors
-------------------
Author:: Stephen Craton (scraton@gmail.com)

The MIT License (MIT)

Copyright (c) 2014 Stephen Craton

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
