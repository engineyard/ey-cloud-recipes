# New Relic Infrastructure

This cookbook can serve as a good starting point for setting up the New Relic Infrastructure agent in your environment.

## Installation

To install this, you will need to add the following to cookbooks/main/recipes/default.rb:

    include_recipe "newrelic_infra"

Make sure this and any customizations to the recipe are committed to your own fork of this
repository.

## Customizations

Some common customizations can be made in `attributes/default.rb`.

### License Key

Please make sure to specify the license key in attributes/default.rb:

```ruby
# Replace value with actual license key
default['newrelic_infra']['license_key'] = "INSERT_NEW_RELIC_INFRA_KEY"
```

This will be used to in generating /etc/newrelic-infra.yml.

If you are using the New Relic account from the New Relic add-on, you can avoid specifying the license key in the attributes file. Please uncomment the following line in `recipes/default.rb` to set the license_key using the `newrelic_license_key` helper method:

```ruby
# Use newrelic_license_key helper method if you are using the New Relic add-on. Uncomment line below:
license_key = newrelic_license_key
```

### Package Version

The recipe downloads the New Relic Infrastructure .deb package version as specified in the attributes/default.rb. Please update the version number as necessary:

```ruby
default['newrelic_infra']['package_version'] = "1.0.785"
```

### Display Name

New Relic Infrastructure uses the hostname as the unique identifier for each host. If you prefer to override the auto-generated hostname for reporting, you can specify your own `display_name` in the newrelic-infra.yml. You can dynamically build the display name in recipes/default.rb using attributes like:

* `node[:instance_role]` - instance role (e.g. "app_master" or "db_slave" or "util")
* `node[:name]` - name of the instance (e.g. "redis" utility instance)
* `node[:environment][:name]` - name of the environment

Please refer to the New Relic Infrastructure configuration documentation:

https://docs.newrelic.com/docs/infrastructure/new-relic-infrastructure/configuration/configure-infrastructure-agent

## Credits

Thanks to [Aviram Radai][1] for showing their recipe on how they installed the New Relic Infrastructure agent in their environment.

[1]: https://github.com/aviramradai
