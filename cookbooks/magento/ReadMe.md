# Magento on Engine Yard Cloud on AWS

This recipe will write out the local.xml file required for Magento configuration.  You can also configure Redis as a session store or for page caching.

## Instructions

1.  Add a deploy hook (https://support.cloud.engineyard.com/entries/21016568-Use-Deploy-Hooks) to deploy/before_restart.rb: 

`run "ln -nfs #{config.shared_path}/config/local.xml #{config.release_path}/app/etc/local.xml"`

2. Add your encryption key to attributes/default.rb
3. Uncomment the include_recipe for magento in the main cookbook recipe.

## Redis Instructions

1. You need to use either a single solo (application and database) instance or an environment containing a utility instance called 'redis'.
2. If you are using a utility instance for redis, uncomment the include_recipe for redis in the main cookbook recipe.  If you are using a solo instance, Redis will already be installed and you can skip this step.
3. Set redis_session_store and/or redis_page_caching to true in attributes/default.rb
4. If you are enabling page caching, make sure you set the proper cached backend class name in attributes/default.rb

## Configurable Attributes

```
default[:magento] = {
  :encryption_key => "INSERT KEY HERE",   # Add your encryption key here
  :redis_session_store => false,          # Set to true to enable Redis session storage
  :redis_page_caching => false            # Set to true to enable Redis page caching
}
```

## Other Magento Configurations

Any other Magento configurations required can be added or updated in templates/default/local.xml.erb
