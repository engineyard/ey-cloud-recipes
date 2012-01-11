Newrelic Server Monitoring
=========

[Newrelic Server Monitoring][1] is a new addition to the Newrelic offering.  

* Monitor CPU usage, physical memory, network activity, load averages, and more as part of your APM tool
* View all apps running on a server, and assess the impact of server utilization on web app performance
* See which servers have capacity issues so you can take corrective action
* See processes prioritized by memory or CPU consumption
* Track server health availability in clouds, physical, or hybrid environments


Overview
--------

This cookbook should install and configure Newrelic Server Monitoring.  This should compliment the Newrelic Application monitoring very well.


Dependencies
--------

This cookbook depends on the emerge cookbook, if you do not have it you can add it like as a submodule as the example below shows,

``git submodule update --init``  
``git submodule add git://github.com/damm/ey-dnapi.git cookbooks/dnapi`` 
``git submodule add git://github.com/damm/ey-emerge.git cookbooks/emerge``  

Installation
--------

# Ensure you have the emerge cookbook dependency installed in your local cookbook repository
# Add the following to main/recipes/default.rb

``require_recipe "newrelic_server_monitoring"``

# Configure the [Newrelic License Key][2] in attributes/newrelic.rb
# Upload your recipes and apply.


How to get Support
--------

* irc://irc.freenode.net/#newrelic
* This Github repository.
* This Cookbook provides a technology that is not listed in the Engine Yard [Technology Stack][3] and is not supported by Engine Yard at this time.

[1]: http://blog.newrelic.com/2011/11/08/server-monitoring-is-here/
[2]: https://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/newrelic_server_monitoring/attributes/newrelic.rb#L1
[3]: http://www.engineyard.com/products/technology/stack
