
# Sets a default schedule of Midnight system time Sunday for a vacuum
if @node[:instance_role][/^db_master/]
  cron "manual_vacuumdb" do
    minute  '0'
    hour    '0'
    day     '*'
    month   '*'
    weekday '0'
    command '/usr/bin/vacuumdb -U postgres --all'
  end
  
  # Alternative form - vacuums a specific named database and set of tables Midnight on Saturday
  # cron "manual_vacuumdb_#{dbname}" do
  #   minute  '0'
  #   hour    '0'
  #   day     '*'
  #   month   '*'
  #   weekday '6'
  #   command "/usr/bin/vacuumdb -U postgres --dbname=#{dbname} --table='#{table1}' --table='#{table2}'"
  # end

end