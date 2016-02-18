#!/bin/bash

[ -d /mnt/tmp ] || mkdir -p /mnt/tmp
echo "Downloading latest database backup for <%= @node[:db_restore][:source_environment_name] %>/<%= @node[:db_restore][:app_name] %>"
backup_index=`sudo /usr/local/ey_resin/bin/eybackup -l <%= @node[:db_restore][:app_name] %> -e <%= @node[:db_restore][:db_type] %> -c /home/<%= @node[:owner_name] %>/download.yml | tail -1 | awk '{ print $1 }'`
sudo /usr/local/ey_resin/bin/eybackup -d $backup_index -e <%= @node[:db_restore][:db_type] %> -c /home/<%= @node[:owner_name] %>/download.yml > /mnt/tmp/backup.log
backup_file=`cat /mnt/tmp/backup.log | awk '{ print $2 }' | sed 's|<%= @node[:db_restore][:source_environment_name] %>.<%= @node[:db_restore][:app_name] %>/||g'`
echo "Download completed"
<% if @node[:db_restore][:db_type] == "mysql" %>
echo "You can restore your database by running:"
echo "            gunzip < /mnt/tmp/$backup_file | mysql <%= @node[:db_restore][:app_name] %>"
<% else %>
echo "Before you restore your database, you must stop all application servers and background workers to clear connections to the database:"
echo "            Passenger: sudo /etc/init.d/nginx stop"
echo "            Unicorn: sudo monit stop all -g unicorn_appname"
echo ""
echo "Ensure all connections have cleared:  "
echo "            psql -U postgres -t -c \"select count(*) from pg_stat_activity where datname='<%= @node[:db_restore][:app_name] %>'\""
echo ""
echo "After all connections to the database have cleared, you can drop and re-create the database:"
echo "            dropdb <%= @node[:db_restore][:app_name] %> && createdb <%= @node[:db_restore][:app_name] %>"
echo ""
echo "Lastly, You can restore your database by running:"
echo "            cat /mnt/tmp/$backup_file | pg_restore --format=c -d <%= @node[:db_restore][:app_name] %>"
<% end %>
