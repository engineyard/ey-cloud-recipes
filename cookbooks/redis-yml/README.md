Chef recipe to write redis.yml on Engine Yard Cloud
=========

[Redis][1] Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain [strings][6], [hashes][5], [lists][4], [sets][3] and [sorted sets][2].  Learn More at the [introduction][7].

Overview
--------

Redis.yml will help you connect to Redis on the utility instance from your Rails application

Currently in the default.rb file under Recipes you utility instance is specified based on the first one it finds, if you have multiple utility instances you can specify it by removing "node['utility_instances'].first" and replace it with the commented out code. You can change the name of the instance based on whatever name you have chosen for your instance.

[1]: http://redis.io/
[2]: http://redis.io/topics/data-types#sorted-sets
[3]: http://redis.io/topics/data-types#sets
[4]: http://redis.io/topics/data-types#lists
[5]: http://redis.io/topics/data-types#hashes
[6]: http://redis.io/topics/data-types#strings
[7]: http://redis.io/topics/introduction

