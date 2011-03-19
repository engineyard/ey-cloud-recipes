ey-cloud-recipes/sphinx
========================

an older and deprecated chef recipe for enabling sphinx on Engine Yard's
AppCloud.  This recipe was originally written for the Legacy Deploy
method, there are several [other][1] [recipes][2] [out][3] there that may
work better for you.


Dependencies
============

If you're using the ultrasphinx flavor in this recipe, you'll need to make sure
you install the chronic gem in your environment (this is not handled by the recipe).

As previously mentioned, your application needs to have the appropriate plugin installed
already.

For thinking_sphinx:

    script/plugin install git://github.com/freelancing-god/thinking-sphinx.git

For ultrasphinx:

    script/plugin install git://github.com/fauna/ultrasphinx.git

Also note that searchd won't actually start unless you've already specified indexes
in your application.

Using it
========

Edit the recipe, changing the appropriate fields as annotated in recipes/default.rb.
Namely:

  * Add your application name.
  * Uncomment the flavor you want to use (thinking_sphinx or ultrasphinx).
  * Set the cron_interval to specify how frequently you want to reindex.

Add the following before_migrate.rb [deploy hooks](http://docs.engineyard.com/appcloud/howtos/deployment/use-deploy-hooks-with-engine-yard-appcloud):

    run "ln -nfs #{shared_path}/config/sphinx #{release_path}/config/sphinx"
    run "ln -nfs #{shared_path}/config/sphinx.yml #{release_path}/config/sphinx.yml"

By default, the recipe will install and run sphinx on all app instances. If you want to
use a dedicated utility instance, just set the "utility_name" variable to the name of
your utility instance. By default this is set to nil.

Caveats
========
If you have multiple app slaves or are installing to a dedicated utility instance, the it's
likely that the recipe run will fail on those instances the very first run because the database
migrations will not have run yet on your application master. If this occurs, simply deploy again
and the recipe should succeed the second time around. This should only occur going forward
if you set new indexes on fields that are in migrations that have to be run.

Warranty
========
This recipe is provided as is, if you have any problems with it please open an issue or make a send a pull request with your fix.

Additional Resources
========

You can get additional information on sphinx configuration and setup here:

  * [thinking_sphinx](http://freelancing-god.github.com/ts/en/)
  * [ultrasphinx](http://blog.evanweaver.com/files/doc/fauna/ultrasphinx/files/README.html)

[1]: https://github.com/bratta/ey-cloud-recipes/tree/master/cookbooks/sphinx
[2]: https://github.com/damm/ey-cloud-recipes/tree/sphinx_test/cookbooks/sphinx
[3]: https://github.com/damm/ey-tsphinx2
