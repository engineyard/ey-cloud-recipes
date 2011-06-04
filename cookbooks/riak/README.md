Riak Cookbook for EngineYard AppCloud
=========

[Riak][1] is a Dynamo-inspired key/value store that scales predictably and easily. Riak also simplifies development by giving developers the ability to quickly prototype, test, and deploy their applications.

A truly fault-tolerant system, Riak has no single point of failure. No machines are special or central in Riak, so developers and operations professionals can decide exactly how fault-tolerant they want and need their applications to be.

Overview
--------

This cookbook once complete will attempt to provide one method of "Hosting" a Riak Ring on AppCloud.  It will not run inside your regular environment as this cookbook will attempt to achieve a scaleable stable Riak configuration with the least disruption of automation possible.

Design
--------

* 2-3+ utility instances (m1.large or larger)

* Riak 0.14 with Bitcask
* Erlang R13B04
* haproxy on each app instance listening on port 8098 directing to the utility instances.

Notes
--------

This Cookbook automates the creation (join) action of a Riak 'Ring' on AppCloud.  As your needs may vary it is suggested to fork this recipe and make any customization you do on the fork.  You can omit the main cookbook it is only there for my testing purposes.

Specifics of Usage
--------

Currently this Cookbook provides the following methods of using Riak:

1. Riak K/V only

  * Add an utility instance with the following naming scheme,

  * riak_0
  * riak_1
  ...

  * Note you must always start with _0 as that is the 'ring master'.  

* Lastly, Words of Wisdom from Basho themselves.

> you should look at the ring ready command and make it returns 0 before adding the next node
> if you try and do more than 4 or 5 nodes the gossip is a little heavy for ec2 right now
> and sometimes it takes a minute or two to converge the ring
> changing the gossip interval in the conf alleviates this somewhat

Depdencies
--------

This cookbook depends on the dnapi|emerge cookbook, you can add it as a
submodule as follows,

``git submodule update --init``  
``git submodule add git://github.com/damm/ey-dnapi.git cookbooks/dnapi`` 
``git submodule add git://github.com/damm/ey-emerge.git cookbooks/emerge``  

Installation
--------

This cookbook can be added as a submodule, provided you have the proper
dependencies you can add it as such,

``git submodule add git://github.com/damm/ey-riak.git cookbooks/``  

Add the following to your main/recipes/default.rb

``require_recipe "riak"``  

How to get Support
--------

* irc://irc.freenode.net/#riak
* This Github repository.
* This Cookbook provides a technology that is not listed in the Engine Yard [Technology Stack][2]

* Additionally because of that there is *NO SUPPORT* for this recipe by EngineYard at this time.  If you have any problems with this reciple please open an issue, add a comment.  If you open a ticket regarding this cookbook you will be directed to this Github repository to open an issue.


[1]: http://wiki.basho.com/display/RIAK/Riak
[2]: http://www.engineyard.com/products/technology/stack
