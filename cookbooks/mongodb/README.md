ey-cloud-recipes/mongodb
========================

A chef recipe for enabling mongodb on the EY AppCloud. This updated recipe
pulls in the latest ebuild maintained on our portage server, and sets up
everything for you for a proper master/slave setup.

It makes a few assumptions:

  * You want MongoDB on a dedicated instance(s).
  * You want a master and (optionally) an arbitrary number of slaves.
  * You want to enable authentication for security.
  
The only thing (currently) lacking from this recipe is the ability to setup
scheduled backups of your MongoDB database.

Dependencies
============

You will need to boot up a cluster (i.e. more than a single "solo" instance).
MongoDB will be installed to a utility instance so as not to conflict with
MySQL or Postgres.


Using it
========

  * Add a utility instance to your cluster, and name it mongodb_master
  * If you want a slave, make sure you have a mongodb_master instance
    running and add a new utility instance named mongodb_slave
  * You can run multiple slaves if you want. Name them like: 
    mongodb_slave1, mongodb_slave2, mongodb_slave3, etc.

Caveats
=======

There is an option to have the MongoDB instance start up as both a master
and a slave, by booting an instance named mongodb_masterslave. However, this
assumes you have an established SSH tunnel to the remote mongod instance you
are replicating from, and as of this writing this scenario is untested. So 
use this at your own risk.

TODO
====

Get backups running. With 1.4.x the idea is to be able to take backups without
the need to shutdown a slave, but issues regarding that have not been fully 
worked out yet.