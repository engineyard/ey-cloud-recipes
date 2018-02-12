#
# Cookbook Name:: sidekiq
# Recipe:: default
#

# Running sidekiq::cleanup is only recommended for development environments.
# Please see the README for more information.

#include_recipe "sidekiq::cleanup"
include_recipe "sidekiq::setup"
