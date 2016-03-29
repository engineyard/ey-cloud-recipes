Redis Cookbook for EngineYard EYCloud
=========

[Redis][1] Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain [strings][7], [hashes][6], [lists][5], [sets][4] and [sorted sets][3].  Learn More at the [introduction][7].

Overview
--------

This cookbook provides a method to host a dedicated redis instance.  This recipe should *NOT* be used on your Database instance as it is not designed for that instance.  Additionally it will not change nor modify your database instance in anyway what so ever.

Design
--------

* 1+ utility instances
* over-commit is enabled by default to ensure the least amount of problems saving your database.
* 64-bit is required for storing over 2gigabytes worth of keys.
* /etc/hosts mapping for `redis-instance` so that a hard config can be used to connect

Backups
--------

This cookbook does not automate nor facilitate any backup method currently.  By default there is a snapshot enabled for your environment and that should provide a viable backup to recover from.  If you have any backup concerns open a ticket with our [Support Team][9].

Specifics of Usage
--------

Simply add a utility instance named `redis` and the recipe will use that instance for redis. If the utility instance you wish to use redis on isn't called `redis`, update redis/attributes/default.rb with the correct instance name:

```ruby
default[:redis] = {
  :utility_name => "my_custom_name", # default: redis
  # ...
}
```

Changing Defaults
--------

A large portion of the defaults of this recipe have been moved to a attribute file; if you need to change how often you save; review the attribute file and modify.

Installation
--------

Ensure you have the Dependencies installed in your local cookbooks repository ...
Add the following to your main/recipes/default.rb

``include_recipe "redis"``

Choosing a different Redis version
--------
This recipe installs Redis 2.8.13-r1 by default. We do not recommend earlier versions of Redis 2.8.x or 2.6.x as these versions have a known vulnerability: http://benmmurphy.github.io/blog/2015/06/04/redis-eval-lua-sandbox-escape/

To install a different version of Redis:

1. Change the `:version => "2.8.13-r1",` line in `attributes/default.rb` to the version you want to install
2. Copy over the corresponding `redis-?.?.conf.erb` file to `templates/default/redis.conf.erb`


Notes
------
Please be aware these are default config files and will likely need to be updated :)

How to get Support
--------

* irc://irc.freenode.net/#redis
* This Github repository.
* This Cookbook provides a technology that is listed in the Engine Yard [Technology Stack][2]

[1]: http://redis.io/
[2]: http://www.engineyard.com/products/technology/stack
[3]: http://redis.io/topics/data-types#sorted-sets
[4]: http://redis.io/topics/data-types#sets
[5]: http://redis.io/topics/data-types#lists
[6]: http://redis.io/topics/data-types#hashes
[7]: http://redis.io/topics/data-types#strings
[8]: http://redis.io/topics/introduction
[9]: https://support.cloud.engineyard.com
