#
# Cookbook Name:: sidekiq
# Recipe:: default
#

include_recipe "sidekiq::cleanup"
include_recipe "sidekiq::setup"
