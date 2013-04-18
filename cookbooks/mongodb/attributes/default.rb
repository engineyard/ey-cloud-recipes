default[:mongo_version] = "2.2.0"
default[:mongo_path] = "/usr"
default[:mongo_base] = "/data/mongodb"
default[:mongo_port] = "27017"
default[:total_memory_mb] = `df -m /data | awk '/dev/ {print $2}'`.to_i
default[:oplog_memory_percentage] = "0.1"
default[:oplog_size] = (default[:total_memory_mb] * default[:oplog_memory_percentage].to_f).to_i
default[:mongo_utility_instances] = node[:utility_instances].select { |ui| ui[:name][/mongodb/] } 

if node["utility_instances"].empty?
  # We have detected no utility instances, so we are skipping the logic for this portion of the recipe.
else
  if node[:instance_role] == 'util' && node[:name].match(/^mongodb_repl/)
    default[:mongo_replset] = node[:name].sub("mongodb_repl", "").split("_")[0]
  else
    default[:mongo_replset] = false
  end
end
