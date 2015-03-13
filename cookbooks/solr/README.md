## DESCRIPTION

Solr Chef Cookbook; allowing you to install Solr easily in /data on a (solo|util) instance.  There is no automation with rsolr or sunspot or other various plugins.  Once you install it, you must manually configure it.

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

The solr server runs on port 8983. This is the default port defined in /config/sunspot.yml.

To access the Solr logs: `/var/log/engineyard/solr`

This recipe does not support multiple instances of Solr, or configuration of the Schema File or anything special like that.  It just starts it, and controls it in monit.

### Additional Notes For Sunspot Users

The default schema.xml that comes with this version of solr will probably not work with sunspot's configuration. Specifically, there are datatypes used by sunspot that do no exist in solr's default schema.xml and other types that are defined differently. You also cannot simply copy the sunpot-provided schema.xml file from your `application/solr/conf/schema.xml` into `/data/solr/solr/conf/schema.xml` on the Engine Yard server  because this will introduce other errors.  You need to make sure that all unique data types that are used by sunspot, as defined in you application in `/solr/conf/schema` are included in the `/data/solr/solr/conf/schema.xml`. 

## CREDITS

Scott M. Likens (damm)

Brian Bommarito http://github.com/bommaritobrianmatthew (For his Sunspot recipe which without... I might not have given a darn otherwise)

Read Me Credit: Naftali Marcus

