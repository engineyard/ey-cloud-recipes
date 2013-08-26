#
# Cookbook Name:: sphinx
# Recipe:: default
#

if solo? || !db_server?
  include_recipe "thinking-sphinx-3::cleanup"
  include_recipe "thinking-sphinx-3::install"
  include_recipe "thinking-sphinx-3::thinking_sphinx"
  include_recipe "thinking-sphinx-3::setup"
end
