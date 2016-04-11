Memcached
===============

A chef recipe for configuring distributed memcached on [EY Cloud]. This recipe is meant to allow memcached to accept remote connections on any instances specified in the attributes file.

Configurable options with defaults:

```
default[:memcached_custom] = {
  :utility_instance_name => "blah",  # utility instance(s) to install memcached on
  :install_on_app_servers => false , # true: install memcached on app servers
  :port => "11211",
  :memory => "64",
  :ttl => "1800",
  :readonly => "false",
  :urlencode => "false",
  :c_threshold => "10000",
  :compression => "true",
  :debug => "false",
  :sessions => "false",
  :session_servers => "false",
  :fragments => "true",
  :benchmarking => "true",
  :raise_errors => "true",
  :fast_hash => "false",
  :fastest_hash => "false",
  :misc_opts => "",
  :maxconn => "1024"
}
```

To make use of this recipe you will also need to add a [deploy hook](https://support.cloud.engineyard.com/entries/21016568-use-deploy-hooks) to your application to create a symlink for the memcached configuration. Just add a line like this to your `before_migrate.rb` hook:

    run "ln -nfs #{shared_path}/config/memcached_custom.yml #{release_path}/config/memcached.yml"


[EY Cloud]: https://cloud.engineyard.com/extras
