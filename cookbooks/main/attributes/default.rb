default[:owner_name] = node[:users].first[:username]
default[:owner_pass] = node[:users].first[:password]