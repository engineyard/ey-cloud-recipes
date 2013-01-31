#
# Cookbook Name:: resque
# Recipe:: default
#

require_recipe "resque::workers"
require_recipe "resque::scheduler"