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
* /etc/hosts mapping for `redis_instance` so that a hard config can be used to connect

Backups
--------

This cookbook does not automate nor facilitate any backup method currently.  By default there is a snapshot enabled for your environment and that should provide a viable backup to recover from.  If you have any backup concerns open a ticket with our [Support Team][9].

Specifics of Usage
--------

Simply add a utility instance named `redis` and the recipe will use that instance for redis.

Changing Defaults
--------

A large portion of the defaults of this recipe have been moved to a attribute file; if you need to change how often you save; review the attribute file and modify.

Installation
--------

Ensure you have the Dependencies installed in your local cookbooks repository ...
Add the following to your main/recipes/default.rb

``require_recipe "redis"``

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
