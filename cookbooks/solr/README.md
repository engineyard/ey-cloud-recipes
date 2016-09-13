## DESCRIPTION

Solr Chef Cookbook; allowing you to install Solr easily in /data on a (solo|util) instance.

## NOTICE
This Cookbook is for an "Unsupported" Stack item; Engine Yard does not support more than the installation of Solr.  

## USAGE

`require_recipe "solr"` in `main/recipes/default.rb`

To stop the solr server use the following on the SSH console: `/engineyard/bin/solr stop`

To start the solr server use the following on the SSH console: `/engineyard/bin/solr start`

## RAMBLINGS

This recipe does the following:

* Setup Solr in /data/solr in a solo environment. In a cluster environment, this sets up Solr in /data/solr of a util instance named "solr"
* Create `/engineyard/bin/solr` for starting and stopping solr
* Create a monitrc file for solr
* Create `/data/app_name/shared/config/solr.yml` populated with the IP address of the solr instance
* (If enabled) create `/data/app_name/shared/config/sunspot.yml` populated with the IP address of the solr instance
* Create a solr core named `default`

The solr server runs on port 8983. This is the default port defined in /config/sunspot.yml.

To access the Solr logs: `/var/log/engineyard/solr`

This recipe does not support multiple instances of Solr, or configuration of the Schema File or anything special like that.  It just starts it, and controls it in monit.

This recipe is designed for Solr 5 (and 6, on V5 where Java 8 is available). Significant changes were done on the recipe to make it work with the newer Solr version. If you _really_ want to run Solr 4, simply changing the version numbers in the recipe will not work. You can find the Solr 4 version of this recipe here: https://github.com/engineyard/ey-cloud-recipes/tree/solr4/cookbooks/solr

If you're currently running Solr 4 and wish to upgrade, you will need to manually uninstall Solr 4 first. You will need to stop Solr, remove the solr .monitrc file, and remove the solr directory (usually `/data/solr`). If you need help with this, please open a Support ticket as the actual steps may vary especially if you've customized your Solr recipe.

### Additional Notes For Sunspot Users

This recipe has been updated to support the latest version of Sunspot, 2.2.5. Please use this recipe instead of the Sunspot recipe which has been deprecated.

Running `bundle exec rake sunspot:reindex` on an empty index fails. After installing, seed the index first by updating some data from the Rails console. 

## CREDITS

Radamanthus Batnag (update to Solr 5.5 and Sunspot support)

Scott M. Likens (damm)

Brian Bommarito http://github.com/bommaritobrianmatthew (For his Sunspot recipe which without... I might not have given a darn otherwise)

Read Me Credit: Naftali Marcus

