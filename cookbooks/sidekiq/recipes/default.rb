#
# Cookbook Name:: sidekiq
# Recipe:: default
#

include_recipe "sidekiq::setup"
include_recipe "sidekiq::cleanup"
