# Configure stuff goes here
#

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
    :js_vm_count => node[:riak][:js_vm_count],
    :js_max_vm_mem => node[:riak][:js_max_vm_mem],
    :max_file_size => node[:bitcask][:max_file_size],
    :open_timeout => node[:bitcask][:open_timeout],
    :sync_strategy => node[:bitcask][:sync_strategy],
    :merge_window => node[:bitcask][:merge_window], 
    :frag_merge_trigger => node[:bitcask][:frag_merge_trigger],
    :dead_bytes_merge_trigger => node[:bitcask][:dead_bytes_merge_trigger],
    :frag_threshold => node[:bitcask][:frag_threshold],
    :dead_bytes_threshold => node[:bitcask][:dead_bytes_threshold],
    :small_file_threshold => node[:bitcask][:small_file_threshold],
    :expiry_secs => node[:bitcask][:expiry_secs],
    :data_root => node[:bitcask][:data_root],
    :luwak => node[:luwak][:enabled]
  )
end
