#
# Cookbook Name:: npm_update
# Recipe:: default
#

execute "update npm" do
  command "npm install -g npm"
end
