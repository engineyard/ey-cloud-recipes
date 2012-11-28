mongo_version("2.2.0")
mongo_path("/usr")
mongo_base("/data/mongodb")
mongo_port("27017")
total_memory_mb(`df -m /data | awk '/dev/ {print $2}'`.to_i)
oplog_memory_percentage("0.1")
oplog_size((total_memory_mb * oplog_memory_percentage.to_f).to_i)
mongo_utility_instances( @attribute["utility_instances"].select { |ui| ui["name"].match(/mongodb/) } )

if @attribute["utility_instances"].empty?
  # We have detected no utility instances, so we are skipping the logic for this portion of the recipe.
else
    if (@attribute[:instance_role] == 'util' && @attribute[:name].match(/^mongodb_repl/)) 
        mongo_replset ( @attribute["name"].sub("mongodb_repl","").split("_")[0] )
        # Chef::Log.info "Node is a member of a replica set #{@node[:mongo_replset]}"
    else
        mongo_replset( false )
    end
end
