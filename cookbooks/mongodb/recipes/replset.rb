user = @node[:users].first

# if @node[:mongo_utility_instances].length < 3 &&  ['db_master','solo'].include? @node[:instance_role]
#   #change for replset instances, not just utilities - do not install an arbiter on a utility node? 
#   Chef::Log.info "Mongo Arbiter #{node[:db_host]}"
#   mongo_arbiter=@node[:db_host]
# else
#   mongo_arbiter="na"
# end

mongo_arbiter="na"
 
if @node[:mongo_replset]
  
  mongo_nodes = @node[:utility_instances].select { |instance| instance[:name].match(/^mongodb_repl#{@node[:mongo_replset]}/) }
  
  Chef::Log.info "Setting up Replica set: #{node[:mongo_replset]} \n mongo_nodes: #{mongo_nodes.inspect} \n executing on node #{@node[:name]}"
  
  if (@node[:name].match(/_1$/) && (mongo_nodes.length == 3 || (mongo_nodes.length ==2 && mongo_arbiter.length > 3)))
     # Chef::Log.info "Found first member of RS in #{@node[:name]}"
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

    #----- wait for set members to be up and initialize -----
    mongo_nodes.each do |mongo_node|
      Chef::Log.info "waiting for mongo on #{mongo_node[:hostname]} to come up"
      # execute "wait for mongo on #{mongo_node[:hostname]} to come up" do
        
        # ruby_block "wait for set members to come up" do
        #   block do
        #     times = 10000
        #     (1..times).each do |iter|
        #       if command "echo 'exit' | #{@node[:mongo_path]}/bin/mongo #{mongo_node[:hostname]}:#{@node[:mongo_port]}/local --quiet;"
        #         Chef::Log.info "woot! set member #{mongo_node[:hostname]} found alive"
        #         break
        #       else
        #         sleep 1
        #       end
        #     end
        #     Chef::Log.info "Set member #{mongo_node[:hostname]} not found"
        #   end
        # end     
        
      # end
    end
    
    # ----- configure the set
    # execute "setup replset #{@node[:mongo_replset]}" do
    #   command "#{@node[:mongo_path]}/bin/mongo local #{setup_js}"
    #   only_if "echo 'rs.status()' | #{@node[:mongo_path]}/bin/mongo local --quiet | grep -q 'run rs.initiate'"
    #   Chef::Log.info "Replica set node initialized" 
    # end

  else
    Chef::Log.info "Not first node in replica or not enough set members defined, skipping set configuration"
  end
end
