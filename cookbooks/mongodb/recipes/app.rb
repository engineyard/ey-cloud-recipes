if node[:utility_instances].empty?
  # no-op here as there are no utility instances, do not pass.
  else
    user = @node[:users].first

    if ['app_master','app'].include?(node[:instance_role])
      mongo_replication_sets = @node[:utility_instances].select { |instance| instance[:name].match(/^mongodb_repl/) }.map { |instance| instance[:name].split("_")[1].sub("repl","") }.uniq   
    end
  mongo_app_names = @node[:applications].keys

  # Chef::Log.info "app.rb - mongo_replication_sets = #{mongo_replication_sets} | node app keys = #{@node[:applications].keys}"

  mongo_app_names.each do |mongo_app_name|
     # Chef::Log.info "looping for mongo_app_name = #{mongo_app_name}"

    template "/data/#{mongo_app_name}/shared/config/mongodb.yml" do
      source "mongodb.yml.erb"
      owner user[:username]
      group user[:username]
      mode 0755

      if @node[:instance_role] == "solo" && @node[:mongo_utility_instances].length == 0
        variables(:yaml_file => {
          node[:environment][:framework_env] => {
            :hosts => [ [ "localhost", @node[:mongo_port].to_i ] ] } } )
      else
        hosts = @node[:mongo_utility_instances].select { |instance| instance[:name].match(/#{mongo_app_name}/) }.map { |instance| [ instance[:hostname], @node[:mongo_port].to_i ] }
        hosts += @node[:mongo_utility_instances].select { |instance| instance[:name].match(/^mongodb_repl/) }.map { |instance| [ instance[:hostname], @node[:mongo_port].to_i ] }
        variables(:yaml_file => {
          node[:environment][:framework_env] => {
            :hosts => hosts} })
      end
    end

    #Mongoid.yml_v3
    template "/data/#{mongo_app_name}/shared/config/mongoid.yml" do
      source "mongoid_v3.yml.erb"
      owner user[:username]
      group user[:username]
      mode 0755

      hosts = @node[:mongo_utility_instances].select { |instance| instance[:name].match(/#{mongo_app_name}/) }.map { |instance| [ instance[:hostname], @node[:mongo_port].to_i ] }
      replica_set = @node[:mongo_utility_instances].any? { |instance| instance[:name].match(/^mongodb_repl/) }
      if replica_set
        hosts += @node[:mongo_utility_instances].select { |instance| instance[:name].match(/^mongodb_repl/) }.map { |instance| [ instance[:hostname], @node[:mongo_port].to_i ] }
      end
      variables(:environment => node[:environment][:framework_env], 
                :hosts => hosts,
                :replica_set => replica_set,
                :mongo_replsetname => node[:environment][:name] )
    end

  end
end
