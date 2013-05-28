ey-cloud-recipes/mongodb v2.2.0
--------

A chef recipe for enabling mongodb v2.2.0 on Engine Yard AppCloud.  This recipe downloads the latest version binary from 10gen and sets up a 3 node MongoDB Replica Set.

It makes a few assumptions:

  * You will be running MongoDB on a utility instance(s).
  * You will be using Replica sets.

MMS support
--------
The recipe will also install Mongo Monitoring Service (MMS) on a solo or db_master. You will need to provide your api & secret keys. 
See https://mms.10gen.com/help/ for more information.


Using it
--------

  * add the following to main/recipes/default.rb,

``include_recipe "mongodb"``

  * Upload recipes to your environment

``ey recipes upload -e <environment>``

  * Add an utility instance with the following naming scheme(s)
    * For an replica set,
      * mongodb_repl#{setname}_1
      * mongodb_repl#{setname}_2
      * mongodb_repl#{setname}_3
      * ...

  * Drops /data/#{app.name}/shared/config/mongo.yml with all the
    information needed to connect to MongoDB.

Caveats
--------

Replica sets should normally be in a size of 3 or greater. This recipe does not and will not support 32-bit instances.
Please ensure you use 64-bit instances when you create the Utility slices.

This recipe has been extended to support very basic backups. 

Legend
--------

  * The usage of #{app.name} is an indicator of the application name set on the [Applications][1] Section on the [Dashboard][2].

TODO
--------
Things (currently) lacking from this recipe:

  * Ability to set up a sharded installation

Known Bugs
--------

Previous versions of this recipe used the legacy-static binary. This is no longer needed. Please fetch latest changes as this recipe is being frequently maintained. 

Warranty
--------

If you find bugs, please open a Zendesk ticket or submit a pull request.

Credits
--------

Thanks to [Edward Muller][4] and [Dan Peterson][5] for the original awesome
recipe to begin with.  

[1]: https://cloud.engineyard.com/apps
[2]: https://cloud.engineyard.com
[3]: https://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/mongodb/attributes/recipe.rb#L13
[4]: https://github.com/freeformz
[5]: https://github.com/dpiddy
