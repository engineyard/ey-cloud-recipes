#
# Cookbook Name:: le
# Recipe:: default
#
require_recipe 'le::install'
require_recipe 'le::configure'
require_recipe 'le::start'
