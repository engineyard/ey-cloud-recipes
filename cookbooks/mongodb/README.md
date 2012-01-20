ey-cloud-recipes/mongodb v2.0.2
--------

A chef recipe for enabling mongodb v2.0.2 on Engine Yard AppCloud.  This recipe downloads the latest version binary from 10gen and sets up a basic MongoDB instance, or a Replica Set.

It makes a few assumptions:

  * You will be running MongoDB on a utility instance(s).
  * You will want [journaling][3] enabled.
  * If you want to use replication you will it will be using Replica
    sets.

The only thing (currently) lacking from this recipe is the ability to setup
scheduled backups of your MongoDB database.

Dependencies
--------

None so far.


Using it
--------

  * add the following to main/recipes/default.rb,

``require_recipe "mongodb"``  

  * Upload recipes to your environment

``ey recipes upload -e <environment>``  

  * Add an utility instance with the following naming scheme(s)
    * For a stand alone instance,
      * mongodb_#{app.name}
    * For an replica set,
      * mongodb_repl#{setname}_1
      * mongodb_repl#{setname}_2
      * mongodb_repl#{setname}_3
      * ...
    * Sharding? TODO

  * Drops /data/#{app.name}/shared/config/mongo.yml with all the
    information needed to connect to MongoDB.


Caveats
--------

Replica sets should normally be in a size of 3 or greater.  However, if you prefer to only have 2 nodes, this recipe will configure the solo|db_master instance as an Arbiter to ensure that if there is a failover that the vote can pass.  This recipe does not and will not support 32-bit instances.  Please ensure you use 64-bit instances (Any type of Large, not Small or Medium) when you create the Utility slices.


Legend
--------

  * The usage of #{app.name} is an indicator of the application name set on the [Applications][1] Section on the [Dashboard][2].

TODO
--------

Get backups running. 

Sharding?

Use MongoS on each app instance instead of dropping mongo.yml?

Known Bugs
--------

This recipe is likely broken on 32-bit.  You should not be running
mongodb this way normally so we will not be addressing this.

Warranty
--------

This cookbook is provided as is, there is no offer of support for this
recipe by Engine Yard in any capacity.  If you find bugs, please open an
issue and submit a pull request.

Credits
--------

Thanks to [Edward Muller][4] and [Dan Peterson][5] for the original awesome
recipe to begin with.  I just updated it so it worked with 1.8 and will
continue to attempt to add more to it and accept patches/pulls.

[1]: https://cloud.engineyard.com/apps
[2]: https://cloud.engineyard.com
[3]: https://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/mongodb/attributes/recipe.rb#L13
[4]: https://github.com/freeformz
[5]: https://github.com/dpiddy
