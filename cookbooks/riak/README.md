Riak Cookbook for EngineYard EYCloud
=========

[Riak][1] is a Dynamo-inspired key/value store that scales predictably and easily. Riak also simplifies development by giving developers the ability to quickly prototype, test, and deploy their applications.

A truly fault-tolerant system, Riak has no single point of failure. No machines are special or central in Riak, so developers and operations professionals can decide exactly how fault-tolerant they want and need their applications to be.

Don't forget to check out the [Riak Fast Track][9]!!!

Overview
--------

This cookbook once complete will attempt to provide one method of "Hosting" a Riak Ring on EYCloud.  It will not run inside your regular environment as this cookbook will attempt to achieve a scalable stable Riak configuration with the least disruption of automation possible.

>This cookbook requires the ***NEW*** ***AMI*** which runs a kernel of 2.6.32.  If when adding a utility instance your kernel is too old; please file a [Support Ticket requesting access][10] to the ***newami***.

Design
--------

* 3+ utility instances 64-bit (m1.large +) running 

* Riak 1.0.2 w/ defaults to leveldb
* Erlang R140B3 (installed from a custom binary package)
* haproxy is configured on 8097-8098 (pbc,http) with the http back-end using /ping to ensure the back-end is up.

Protobuffer Notes
--------

Haproxy is configured in TCP Mode; if you use protobuffers you should either configure your clients directly to the server or configure a sane reconnect method as the connection will be stale after the connection timeout in haproxy.

Notes
--------

This Cookbook automates the creation (join) action of a Riak 'Ring' on EYCloud.  As your needs may vary it is suggested to fork this recipe and make any customization you do on the fork.  You can omit the main cookbook it is only there for my testing purposes.

Backups
--------

This cookbook does not automate not facilitate any backup method currently.  There are possible ways of handling backups including depending on EBS snapshots and fsync() which may or may not work properly depending on the what files are being written at that time.  A better suggestion would be to create a cronscript such as, (with the proper session cookie and riak hostname provided) 

> ``/data/riak/bin/riak-admin backup riak@ip-10-112-15-117.ec2.internal riakinfo backup-todaysdate()``  
> ``gzip backup-todaysdate()``  
> upload_to_s3()

* Note todaysdate() could be ``date '+%Y%m%d'`` 
* Note upload_to_s3() is a figurative example you should be able to upload this using [fog][3]

Benchmarks
--------

I [damm][4] have been benchmarking Riak on EYCloud for some time and have posted some of my tests with [basho_bench][5] for which you can review.  All posted results are using EBS as the diskstore, you can find better latency and speed by using the instance Ephemeral disks (/mnt) which can be [tuned][6] if you so wish.  *Note* you *MUST* use riak-admin to backup your data as it will *NOT* be stored on the EBS unit.  

* You are free to enable the [basho_bench][7] [recipe][8] and then git clone git://github.com/basho/basho_bench.git to properly determine if your dataset / type would be a good fit for Riak.

> Note the recipe is there for the utility instance if you prefer to use the Erlang Riakclient instead of setting up / configuring Riak on your web instances.  Otherwise using the app instances via haproxy should replicate your usage.

Adding Instances w/out a Snapshot
--------

* It is possible to add a member to the ring without an EBS snapshot.  You should choose the appropriate size and then add the instance and then verify with riak-admin ringready to determine when the new node member has loaded enough data to become 'ready'.  Then you can run custom chef recipes on your app instances to rebuild the haproxy template and then restart haproxy when ready.  (Note: Haproxy automation may be improved in the future)


Specifics of Usage
--------

Currently this Cookbook provides the following methods of using Riak:

1. Riak K/V only.

  * Add an utility instance with the following naming scheme,

  * riak_0
  * riak_1
  * riak_2
  ...

  * Note you must always start with _0 as that is the 'ring master'.  

* Lastly, Words of Wisdom from Basho themselves.

> you should look at the ring ready command and make sure it returns 0 before adding additional nodes.

> If you try and do more than 4 or 5 nodes the gossip is a little heavy for ec2 right now and sometimes it takes a minute or two to converge the ring changing the gossip interval in the conf alleviates this somewhat

Dependencies
--------

This cookbook depends on the dnapi|emerge cookbook, you can add it as a
submodule as follows,

``git submodule update --init``  
``git submodule add git://github.com/damm/ey-dnapi.git cookbooks/dnapi`` 
``git submodule add git://github.com/damm/ey-emerge.git cookbooks/emerge``  

Installation
--------

Ensure you have the Dependencies installed in your local cookbooks repository ...
Add the following to your main/recipes/default.rb

``require_recipe "riak"``  

How to get Support
--------

* irc://irc.freenode.net/#riak
* This Github repository.
* This Cookbook provides a technology that is not listed in the Engine Yard [Technology Stack][2]

* Additionally because of that there is *NO SUPPORT* for this recipe by EngineYard at this time.  If you have any problems with this recipe please open an issue, add a comment.  If you open a ticket regarding this cookbook you will be directed to this Github repository to open an issue.


[1]: http://wiki.basho.com/display/RIAK/Riak
[2]: http://www.engineyard.com/products/technology/stack
[3]: https://github.com/geemus/fog
[4]: https://github.com/damm
[5]: https://github.com/damm/basho_bench
[6]: https://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/riak/attributes/riak.rb#L3
[7]: https://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/riak/recipes/default.rb#L6
[8]: https://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/riak/recipes/default.rb#51
[9]: http://wiki.basho.com/The-Riak-Fast-Track.html
[10]: https://support.cloud.engineyard.com