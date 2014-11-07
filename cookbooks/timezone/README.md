# Changing the Timezone

This cookbook makes it easy to change the timezone of an instance to one that suits your geographical location, rather than the default UTC zone.

NOTE: Older instances on Engine Yard Cloud use(d) the PST time zone by default. We've made changes to our stack to default to UTC in an effort to better standardize our product, and any new instances launched will default to UTC.


## Installation

Take a look in `/usr/share/zoneinfo` to find the relevant timezone, and set the `timezone` variable in this recipes/default.rb file.

Add the following to cookbooks/main/recipes/default.rb:

    include_recipe "timezone"


NOTE: the recipe has 'UTC' as an example timezone, so make sure you change as necessary before using.


## Restarting Services

We have added 3 services that should be restarted when this recipe runs, so that they are aware of the new timezone. If you find that you need other system services to be restarted, make sure you modify the recipe file accordingly. You will need to find the appropriate script in /etc/init.d, then add that name as a service resource and also add it into the notifies attribute of the 'link' resource in the recipe file.


## Restarting Databases

**Masters**

The database uses system time by default and will need to be restarted after applying this change. We recommend that the master database be restarted by hand rather than through this recipe so that the downtime associated with that can be managed as parto of a planned maintenance. Additional information on restarting databases can be found here: https://support.cloud.engineyard.com/entries/21016413-Troubleshoot-Your-Database.

**Replicas**

When adding new replicas to your environment the replica database will start before your custom chef updates the timezone configuration. As a result you will need to restart your database on new replicas after the initial chef run completes successfully. Depending on how your replica is leveraged by your application, you may be able to do this automatically by modifying this chef recipe.