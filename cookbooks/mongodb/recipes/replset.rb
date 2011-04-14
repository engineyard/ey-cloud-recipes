user = @node[:users].first
if @node[:mongo_utility_instances].length < 3
  Chef::Log.info "Mongo Arbiter #{node[:db_host]}"
  mongo_arbiter=@node[:db_host]
else
  mongo_arbiter="na"
end

if @node[:mongo_replset]
  mongo_nodes = @node[:utility_instances].select { |instance| instance[:name].match(/^mongodb_repl#{@node[:mongodb_replset]}/) }
  if @node[:name].match(/_1$/)
    setup_js = "#{node[:mongo_base]}/setup_replset.js"

    template setup_js do
      source "setup_replset.js.erb"
      owner user[:username]
      group user[:username]
      mode '0755'
      variables({ :mongo_replset => @node[:mongo_replset],
                  :mongo_nodes => mongo_nodes,
                  :mongo_port => @node[:mongo_port],
                  :mongo_arbiter => mongo_arbiter
               })
    end

    mongo_nodes.each do |mongo_node|
      execute "wait for mongo on #{mongo_node[:hostname]} to come up" do
        command "until echo 'exit' | #{@node[:mongo_path]}/bin/mongo #{mongo_node[:hostname]}:#{@node[:mongo_port]}/local --quiet; do sleep 10s; done"
      end
    end

    execute "setup replset #{@node[:mongo_replset]}" do
      command "#{@node[:mongo_path]}/bin/mongo local #{setup_js}"
      only_if "echo 'rs.status()' | #{@node[:mongo_path]}/bin/mongo local --quiet | grep -q 'run rs.initiate'"
    end
  end
end
