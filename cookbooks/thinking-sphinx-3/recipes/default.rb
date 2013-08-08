#
# Cookbook Name:: sphinx
# Recipe:: default
#

unless db_server?
  include_recipe "sphinx::cleanup"
  include_recipe "sphinx::install"
  include_recipe "sphinx::thinking_sphinx"
  include_recipe "sphinx::setup"
end