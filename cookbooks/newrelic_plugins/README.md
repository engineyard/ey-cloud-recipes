newrelic_plugins Cookbook
=========================

Install the newrelic_plugin_agent on your Engine Yard Cloud environment

Usage
-----

1. Make sure that New Relic has been enabled for your environment
2. Include the recipe in the `main/recipes/default.rb` recipe

    ```
    include_recipe 'newrelic_plugins'
    ```

Customization
-----

By default, the recipe will install the same plugins on every instance. If you
need different ones on different instances, copy the newrelic_plugin_agent.yml
file and enable the relevent ones. Then customize the recipe to write the template
based on the instance role/name.

Example:
- Template file with 'redis' enabled on the 'redis' utility instance(s)
- Template file with 'memcached' enabled on the 'memcached' instance(s)

