# DESCRIPTION:
Emerge Cookbook.  

This cookbook holds 2 definitions, one called enable_package and one called update_file.  Between these two definitions it enables you to 'unmask' a package in Chef and then install an 'masked' version of said package.

# USAGE:
For example if you want to install Libxml 2.7.6 on AppCloud you would use the following as a recipe.

    enable_package "dev-libs/libxml2" do
      version "2.7.6"
    end

    package "dev-libs/libxml2" do
      version "2.7.6"
      action :install
    end

# ALTERNATIVE USAGE:
This example shows you how to modify the 'use_flags' that are used during package compilation too.

    enable_package "dev-lang/ruby" do
      version "1.8.7_p299"
    end

    package_use "dev-lang/ruby" do
      flags "threads"
    end

    package "dev-lang/ruby" do
      version "1.8.7_p299"
      action :install
    end

# LEGEND:

Gentoo uses the names 'mask' and 'unmask' terminology between stable and unstable.  Typically this is done in /etc/make.conf with ACCEPT_KEYWORDS declaration for '~amd64' and '~x86'.  However it can also be added to /etc/portage/package.keywords/local to 'unmask' packages individually.
