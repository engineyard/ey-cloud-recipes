casperjs Cookbook
=================

Installs the precompiled CasperJS binary.

Installation Options
--------

There are two install options:

1.  **'archive'**
    This downloads the binary from a specified location and installs it, together with any required packages. By default this cookbook will install v1.1.3.

2.  **'git'**
    This downloads the binary from a git repository and installs it.


Installation
--------

Ensure you have the PhantomJS Dependency installed in your local cookbooks repository and add the following to your main/recipes/default.rb

``include_recipe "casperjs"``
