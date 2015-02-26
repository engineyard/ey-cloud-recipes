#
# Cookbook Name:: npm_update
# Recipe:: default
#

execute "update npm" do
  command "npm install -g npm"
  command "npm install -g grunt-cli"
end
