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
  Chef::Log.info "Setting up Replica set #{node[:mongo_replset]}"
  
  # mongo_nodes = @node[:utility_instances].select { |instance| instance[:name].match(/^mongodb_repl#{@node[:mongodb_replset]}/) }
  
  # if @node[:name].match(/_1$/)
  #   setup_js = "#{node[:mongo_base]}/setup_replset.js"
  #   
  #   template setup_js do
  #     source "setup_replset.js.erb"
  #     owner user[:username]
  #     group user[:username]
  #     mode '0755'
  #     variables({ :mongo_replset => @node[:mongo_replset],
  #                 :mongo_nodes => mongo_nodes,
  #                 :mongo_port => @node[:mongo_port],
  #                 :mongo_arbiter => mongo_arbiter
  #              })
  #   end

    #----- skip set initialization for now -----
    # mongo_nodes.each do |mongo_node|
    #   execute "wait for mongo on #{mongo_node[:hostname]} to come up" do
    #     #Add a timeout or you'll get stuck forever here
    #     #command "until echo 'exit' | #{@node[:mongo_path]}/bin/mongo #{mongo_node[:hostname]}:#{@node[:mongo_port]}/local --quiet; do sleep 10s; done"
    #     
    #     ruby_block "wait for set members to come up" do
    #       block do
    #         times = 600
    #         (1..times).each do |iter|
    #           if command "echo 'exit' | #{@node[:mongo_path]}/bin/mongo #{mongo_node[:hostname]}:#{@node[:mongo_port]}/local --quiet;"
    #             Chef::Log.info " set member found alive"
    #             break
    #           else
    #             sleep 1
    #           end
    #         end
    #         Chef::Log.info "No set member found"
    #       end
    #     end     
    #     
    #   end
    # end
    
    # ----- configure the set
    # execute "setup replset #{@node[:mongo_replset]}" do
    #   command "#{@node[:mongo_path]}/bin/mongo local #{setup_js}"
    #   only_if "echo 'rs.status()' | #{@node[:mongo_path]}/bin/mongo local --quiet | grep -q 'run rs.initiate'"
    #   Chef::Log.info "Replica set node initialized" 
    # end

  # end
end
