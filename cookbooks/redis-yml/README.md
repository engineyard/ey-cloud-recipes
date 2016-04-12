Chef recipe to write redis.yml on Engine Yard Cloud
=========

[Redis][1] Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain [strings][6], [hashes][5], [lists][4], [sets][3] and [sorted sets][2].  Learn More at the [introduction][7].

Overview
--------

Redis.yml will help you connect to Redis on the utility instance from your Rails application

First, you have to modify the `recipes/default.rb`. Make sure where is the Redis server running on and set the `redis_instance`.

[1]: http://redis.io/
[2]: http://redis.io/topics/data-types#sorted-sets
[3]: http://redis.io/topics/data-types#sets
[4]: http://redis.io/topics/data-types#lists
[5]: http://redis.io/topics/data-types#hashes
[6]: http://redis.io/topics/data-types#strings
[7]: http://redis.io/topics/introduction

