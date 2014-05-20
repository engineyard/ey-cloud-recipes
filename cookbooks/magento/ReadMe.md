# Magento on Engine Yard on AWS

This recipe will write out the local.xml file required for Magento configuration.  You can also configure Redis as a session store or for page caching.

## Instructions

1. Add all of your Magento applications to attributes/default.rb.  You will need to specify an application name (as configured in the dashboard), an encryption key and wether or not you want Redis page caching and/or session storage emabled.
2. Add a deploy hook to each Magento application (https://support.cloud.engineyard.com/entries/21016568-Use-Deploy-Hooks) to deploy/before_restart.rb:

`run "ln -nfs #{config.shared_path}/config/local.xml #{config.release_path}/app/etc/local.xml"`

3. Uncomment the include_recipe for magento in the main cookbook recipe.

## Redis Instructions

1. You need to use either a single solo instance (application and database), an environment containing a utility instance called 'redis' or an environment with a database master.
2. If you are using a utility instance for redis, uncomment the include_recipe for redis in the main cookbook recipe.  If you are using a solo instance, Redis will already be installed and you can skip this step.  If you plan on using your database master, Redis will already be installed and you can skip this step.
3. Set redis_session_store and/or redis_page_caching to true in attributes/default.rb
4. If you are enabling page caching, make sure you set the proper cached backend class name in attributes/default.rb

## Configurable Attributes

The attributes consist of an array of hashes.  You will need one hash per application.  The app_name should be the same as the application name that you specified in the dashboard.

```
default[:magento_apps] = [{
  :app_name => "APP1 NAME HERE"          # Set your application name here
  :encryption_key => "APP1 KEY HERE",    # Add your encryption key here
  :redis_session_store => true,          # Set to true to enable Redis session storage
  :redis_page_caching => true            # Set to true to enable Redis page caching
}]

```

## Other Magento Configurations

Any other Magento configurations required can be added or updated in templates/default/local.xml.erb
