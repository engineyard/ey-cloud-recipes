monit_disable
=======================================

This recipe allows you to disable monit services that have been installed by default in your Engine Yard Cloud instances. The monit entry will be stopped and unmonitored, and then the monitrc file will be removed.

To specify the monit services to be disabled, edit the ```services_to_disable``` variable in recipes/default.rb file in this recipe:

```
services_to_disable = [
  {:name => "memcache_11211", :monit_file => "memcached"},
  {:name => "redis"}
]
```

If the monit file (the file in /etc/monit.d/) is different from the service name then you need to specify both. Otherwise, you can specify just the service name and the recipe will assume that that is also the monit filename.



