# Configure stuff goes here
#

directory "#{node[:riak][:data_root]}" do
  action :create
  owner "root"
  group "root"
  mode 0755
  recursive true
end

template "/data/riak/etc/vm.args" do
  source "vm.args.erb"
  owner node[:owner_name]
  group node[:owner_name]
  mode 0655
  backup 0
end

template "/data/riak/etc/app.config" do
  source "app.config.erb"
  backup 0
  mode 0655
  owner node[:owner_name]
  group node[:owner_name]
  variables(
    :riak_version => node[:riak][:version],
    :map_js_vm_count => node[:riak][:map_js_vm_count],
    :reduce_js_vm_count => node[:riak][:reduce_js_vm_count],
    :hook_js_vm_count => node[:riak][:hook_js_vm_count],
    :js_max_vm_mem => node[:riak][:js_max_vm_mem],
    :js_thread_stack => node[:riak][:js_thread_stack],
    :riak_kv_stat => node[:riak][:riak_kv_stat],
    :legacy_stats => node[:riak][:legacy_stats],
    :legacy_keylisting => node[:riak][:legacy_keylisting],
    :luwak_enabled => node[:riak][:luwak_enabled],
    :riaksearch_enabled => node[:riak][:riaksearch_enabled],
    :backend_enabled => node[:riak][:backend_enabled],
    :pb_backlog => node[:riak][:pb_backlog],
    :data_root => node[:riak][:data_root]
  )
end
