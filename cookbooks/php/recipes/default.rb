#
# Cookbook Name:: php
# Recipe:: default
#
# Uncomment the following if modifying php.ini
# include_recipe "php::ini_setup"

# Make sure to specify the correct root path in the php::nginx recipe
include_recipe "php::nginx"