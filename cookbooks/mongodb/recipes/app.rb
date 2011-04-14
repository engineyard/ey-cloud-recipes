user = @node[:users].first

if ['app_master','app'].include?(node[:instance_role])
  mongo_replication_sets = @node[:utility_instances].select { |instance| instance[:name].match(/^mongodb_repl/) }.map { |instance| instance[:name].split("_")[1].sub("repl","") }.uniq
  mongo_app_names = @node[:applications].keys.select { |app_name| mongo_replication_sets.include?(app_name) }
else
  mongo_app_names = @node[:applications].keys
end

mongo_app_names.each do |mongo_app_name|
  Chef::Log.info "#{mongo_app_name}"
  template "/data/#{mongo_app_name}/shared/config/mongodb.yml" do
    source "mongodb.yml.erb"
    owner user[:username]
    group user[:username]
    mode 0755
    if @node[:instance_role] == "solo" && @node[:mongo_utility_instances].length == 0
      variables(:yaml_file => {
        node.engineyard.environment.framework_env => { 
          :hosts => [ [ "localhost", @node[:mongo_port].to_i ] ] } } )
    else
      hosts = @node[:mongo_utility_instances].select { |instance| instance[:name].match(/#{mongo_app_name}/) }.map { |instance| [ instance[:hostname], @node[:mongo_port].to_i ] }
      variables(:yaml_file => {
        node.engineyard.environment.framework_env => { 
          :hosts => hosts} })
    end
  end

  #FIXME: our old chef's Link resource can't set the owner/group
  #execute "fixup silly" do
  #  command "chown -h #{user[:username]}:#{user[:username]} /data/#{mongo_app_name}/current/config/mongodb.yml"
  #end
end
