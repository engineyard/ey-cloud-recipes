user = @node[:users].first

mongo_arbiter="na"

if @node[:mongo_replset]
  mongo_nodes = @node[:utility_instances].select { |instance| instance[:name].match(/^mongodb_repl#{@node[:mongo_replset]}/) }

  # Chef::Log.info "Setting up Replica set: #{node[:mongo_replset]} \n mongo_nodes: #{mongo_nodes.inspect} \n executing on node #{@node[:name]}"

  if (mongo_nodes.length >= 3 || (mongo_nodes.length ==2 && mongo_arbiter.length > 3))
    setup_rb = "#{node[:mongo_base]}/setup_replset.rb"
    
    template setup_rb do
      source "setup_replset.rb.erb"
      owner user[:username]
      group user[:username]
      mode '0755'
      variables({ :mongo_nodes => mongo_nodes,
                  :mongo_port => @node[:mongo_port],
                  :mongo_arbiter => mongo_arbiter,
                  :mongo_path => @node[:mongo_path],
                  :me => @node[:name]
               })
    end

    #----- wait for set members to be up and initialize -----
     mongo_nodes.each do |mongo_node|
      execute "wait for mongo on #{mongo_node[:hostname]} to come up" do
        command "until echo 'exit' | #{@node[:mongo_path]}/bin/mongo #{mongo_node[:hostname]}:#{@node[:mongo_port]}/local --quiet; do sleep 10s; done"
      end
    end
    # ----- configure the set
    execute "setup replset #{@node[:mongo_replset]}" do
      command "#{setup_rb}"
      only_if "echo 'rs.status()' | #{@node[:mongo_path]}/bin/mongo local --quiet | grep -q 'run rs.initiate'"
      # <!!!!------ need to expand on this so that this will also run in a cluster that is booting from a snapshot
      ## > rs.status()
      ## {
      ## 	"startupStatus" : 1,
      ## 	"ok" : 0,
      ## 	"errmsg" : "loading local.system.replset config (LOADINGCONFIG)"
      ## }
      Chef::Log.info "Replica set node initialized" 
    end

  else
    Chef::Log.info "Not first node in replica or not enough set members defined, skipping set configuration"
  end
end
