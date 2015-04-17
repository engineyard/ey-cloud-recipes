#
# Cookbook Name:: npm_update
# Recipe:: default
#

execute "install grunt-cli" do
  command "npm install -g grunt-cli"
end
