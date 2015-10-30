Papertrail Cookbook for EngineYard EYCloud
=========

Papertrail is a service that provides hosted log management. See http://help.papertrailapp.com/ for details.

The official guide on how to run Papertrail on Engine Yard is [here](http://help.papertrailapp.com/kb/hosting-services/engine-yard/).

This recipe has been updated with changes from https://github.com/leonsodhi/ey-cloud-recipes/tree/master/cookbooks/papertrail. We also incorporate fixes as we encounter them.

## Usage

Add `include_recipe "papertrail"` to `main/recipes/default.rb`

Add the port and host from papertrailapp.com to `papertrail/recipes/default.rb`

