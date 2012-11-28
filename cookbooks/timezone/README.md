# Changing the Timezone

This cookbook makes it easy to change the timezone of an instance to one that suits your geographical location, rather than the default UTC zone.

NOTE: Older instances on Engine Yard Cloud use(d) the PST time zone by default. We've made changes to our stack to default to UTC in an effort to better standardize our product, and any new instances launched will default to UTC.


## Installation

Take a look in `/usr/share/zoneinfo` to find the relevant timezone, and set the `timezone` variable in this recipes/default.rb file.

Add the following to cookbooks/main/recipes/default.rb:

    require_recipe "timezone"


NOTE: the recipe has 'UTC' as an example timezone, so make sure you change as necessary before using.


## Restarting services

We have added 3 services that should be restarted when this recipe runs, so that they are aware of the new timezone. If you find that you need other system services to be restarted, make sure you modify the recipe file accordingly. You will need to find the appropriate script in /etc/init.d, then add that name as a service resource and also add it into the notifies attribute of the 'link' resource in the recipe file.
