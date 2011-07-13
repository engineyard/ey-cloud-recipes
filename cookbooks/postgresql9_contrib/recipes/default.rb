#
# Cookbook Name:: postgresql9_contrib
# Recipe:: default
#
# if ['solo', 'db_master','db_slave'].include?(node[:instance_role])
#   #find if db_type is postgresql9? 
# 
#    if @node[:pg9_contrib_apply_list].has_key?("postgis")
#      require_recipe "postgresql9_contrib::postgis"
#    end
#   
#   
# end