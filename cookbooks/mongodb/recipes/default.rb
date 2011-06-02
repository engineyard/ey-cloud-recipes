#
# Cookbook Name:: mongodb
# Recipe:: default
#

# Setup an arbiter on the db_master|solo as replica sets need another vote to properly failover.  If you have a Replica set > 3 nodes we don't set this up, you can tune this obviously.

if ['app_master','app','solo'].include? @node[:instance_role]
  Chef::Log.info "running app mongo.yml code"
  require_recipe "mongodb::app"
end

case node[:kernel][:machine]
when "i686"
  # Do nothing, you should never run MongoDB in a i686/i386 environment it will damage your data.
  Chef::Log.info "MongoDB cannot be hold data in 32bit systems - add arb config"
  # if (['db_master','solo'].include?(@node[:instance_role]) &&  @node[:mongo_utility_instances].length < 3)
  #   require_recipe "mongodb::install"
  #   require_recipe "mongodb::configure"
  #   require_recipe "mongodb::start"
  # end
else
  
  if (@node[:instance_role] == 'util' && @node[:name].match(/mongodb/)) || (@node[:instance_role] == "solo" &&  @node[:mongo_utility_instances].length == 0)
    require_recipe "mongodb::install"
    require_recipe "mongodb::configure"
    require_recipe "mongodb::start"
    if @node[:mongo_replset]
      Chef::Log.info "Setting up Replica set"
      require_recipe "mongodb::replset"
    end
  end
end
