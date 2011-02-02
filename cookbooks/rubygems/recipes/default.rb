#
# Cookbook Name:: rubygems
# Recipe:: default
#
rubygems_version = '1.5.0'

bash "update rubygems to >= #{rubygems_version}" do
  code <<-EOH
    gem install rubygems-update -v #{rubygems_version}
    update_rubygems
  EOH

  not_if do
    Gem::Version.new(`gem -v`) >= Gem::Version.new(rubygems_version)
  end
end