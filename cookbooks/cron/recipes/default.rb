#
# Cookbook Name:: cron
# Recipe:: default
#

# Find all cron jobs specified in attributes/cron.rb where current node name matches instance_name
crons = node[:custom_crons].find_all {|c| c[:instance_name] == "#{node[:name]}" }

crons.each do |cron|
  cron cron[:name] do
    user     node['owner_name']
    action   :create
    minute   cron[:time].split[0]
    hour     cron[:time].split[1]
    day      cron[:time].split[2]
    month    cron[:time].split[3]
    weekday  cron[:time].split[4]
    command  cron[:command]
  end
end
