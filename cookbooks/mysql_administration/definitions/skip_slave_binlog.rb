define :mysql_administration_skip_slave_binlog do

  if ['db_slave'].include?(node[:instance_role])
    include_recipe "mysql_administration::skip_slave_binlog"
  end
end


