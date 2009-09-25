#
# Cookbook Name:: mbari-ruby
# Recipe:: default
#


directory "/etc/portage/package.keywords" do
  owner 'root'
  group 'root'
  mode 0775
  recursive true
end

execute "add mbari keywords" do
  command %Q{
    echo "=dev-lang/ruby-1.8.6_p287-r2" >> /etc/portage/package.keywords/local
  }
  not_if "cat /etc/portage/package.keywords/local | grep '=dev-lang/ruby-1.8.6_p287-r2'"
end

directory "/etc/portage/package.use" do
  owner 'root'
  group 'root'
  mode 0775
  recursive true
end

execute "add mbari use flags" do
  command %Q{
    echo "dev-lang/ruby mbari" >> /etc/portage/package.use/local
  }
  not_if "cat /etc/portage/package.use/local | grep 'dev-lang/ruby mbari'"
end

package "dev-lang/ruby" do
  version "1.8.6_p287-r2"
  action :install
end