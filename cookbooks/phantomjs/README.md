PhantomJs Cookbook
==================

Installs PhantomJs and necessary packages.

Installation Options
--------

There are two install options:

1.  **'source'**
    This downloads the specified version and installs it, together with any required packages. By default this cookbook will install v2.1.0.

2.  **'package'**
    This unmasks and uses the available Gentoo package - currently limited to v2.0.0.

Installation
--------

Add the following to your main/recipes/default.rb

``include_recipe "phantomjs"``
