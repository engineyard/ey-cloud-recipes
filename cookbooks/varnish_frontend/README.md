Varnish Cookbook for EngineYard EYCloud
=========

[Varnish][1] Varnish Cache is a web application accelerator also known as a caching HTTP reverse proxy. You install it in front of any server that speaks HTTP and configure it to cache the contents.  There is a [cool video][2] that shows what Varnish is good at. 

Overview
--------

This cookbook provides a way to install Varnish on every app instance in a EYCloud environment.  While it will work out-of-the-box, it is really provided as a starting point for more complex setups.  As such, Varnish's config is in itself just good enough to have it running; no tuning of any kind is included.

Design
--------

The recipe will setup the following path for incoming traffic:

client -> HAproxy:80 (on app_master) -> |Varnish:81 -> Nginx:82| (on every app instance)

For achieving this Nginx's listening port is moved from the EYCloud standard port 81 to port 82 using [keep files][3].  This recipe sets up the keep files for every application on the environment, but if you're already using them then review the recipe before applying.

While the overall concept of the path will work for SSL traffic, it hasn't been tested and as far as I know depends on where SSL is terminated.  Again this is a reference implementation.

Changing Defaults
--------

A large portion of the defaults of this recipe have been moved to a attribute file; if you need to change how often you save; review the attribute file and modify.

Installation
--------

Ensure you have the Dependencies installed in your local cookbooks repository ...
Add the following to your main/recipes/default.rb

``include_recipe "varnish_fronteds"``

Choosing a different Varnish version
--------
This recipe installs Varnish 3.0.3 by default, and the config is tailored to it. While the concept of traffic flowing will work for newer versions, the config may change thus *at least* the templates and the 'varnishd_wrapper' have to be revisited.  Same applies to older versions

To install a different version of Varnish:

1. Find if the desired version if available in Portage by running `eix www-servers/varnish`
2. Change the `:version => "3.0.3",` line in `recipes/default.rb` to the version you want to install

Testing
-------

Running `curl -I -v URL` should should return a header in the form of:

```
< X-Varnish: 2139700497
< Age: 0
< Via: 1.1 varnish
< Connection: close
< X-Cache: MISS
```

Notes
------
Please be aware these are default config files and will likely need to be updated :)


[1]: http://varnish-cache.org/
[2]: https://www.youtube.com/watch?v=fGD14ChpcL4
[3]: https://support.cloud.engineyard.com/hc/en-us/articles/205407378-Use-Keep-Files-to-Customize-and-Maintain-Configurations

