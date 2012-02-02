#execute "testing" do
#  command %Q{
#    echo "i ran at #{Time.now}" >> /root/cheftime
#  }
#end

# uncomment to turn on thinking sphinx/ultra sphinx. Remember to edit cookbooks/sphinx/recipes/default.rb first!
# require_recipe "sphinx"

#uncomment to turn on memcached
# require_recipe "memcached"

#uncomment ot run the riak recipe
# require_recipe "riak"

#uncomment to run the authorized_keys recipe
#require_recipe "authorized_keys"

#uncomment to run the eybackup_slave recipe
#require_recipe "eybackup_slave"

#uncomment to run the ssmtp recipe
#require_recipe "ssmtp"

#uncomment to run the sunspot recipe
# require_recipe "sunspot"

#uncomment to run the exim recipe
#exim_auth "auth" do
#  my_hostname "my_hostname.com"
#  smtp_host "smtp.sendgrid.net"
#  username "username"
#  password "password"
#end

#uncomment to run the exim::auth recipe
#require_recipe "exim::auth"
#require_recipe "mongodb"

#uncomment to run the resque recipe
# require_recipe "resque"

#uncomment to run the resque-scheduler recipe
# require_recipe "resque-scheduler"

#uncomment to run the redis recipe
#require_recipe "redis"

#require_recipe "logrotate"
#
#uncomment to use the solr recipe
#require_recipe "solr"

#uncomment to include the emacs recipe
#require_recipe "emacs"

#uncomment to include the eybackup_verbose recipe
#require_recipe "eybackup_verbose"

#uncomment to include the mysql_replication_check recipe
#require_recipe "mysql_replication_check"

#uncomment to include the mysql_administrative_tools recipe
# additional configuration of this recipe is required
#require_recipe "mysql_administrative_tools"

#uncomment to include the Elasticsearch recipe
#require_recipe "elasticsearch"

# To install specific plugins to Elasticsearch see below as an example
#es_plugin "cloud-aws" do
#  action :install
#end

#es_plugin "transport-memcached" do
#  action :install
#end

#uncomment to include the newrelic_server_monitoring recipe
#require_recipe "newrelic_server_monitoring"

#enable contrib modules for a given Postgresql database
if ['solo','db_master', 'db_slave'].include?(node[:instance_role])
  # postgresql9_autoexplain "dbname"
  # postgresql9_btree_gin "todosinatra"
  postgresql9_chkpass "todosinatra"
  # postgresql9_citext "dbname"
  # postgresql9_cube "dbname"
  # postgresql9_dblink "dbname"
  # postgresql9_earthdistance "dbname"
  # postgresql9_fuzzystrmatch "dbname"
  # postgresql9_hstore "dbname"
  # postgresql9_intagg "dbname"
  # postgresql9_isn "dbname"
  # postgresql9_lo "dbname"
  # postgresql9_ltree "dbname"
  # postgresql9_pg_stat_statements"postgres_test" - Not done
  # postgresql9_pg_trgm "postgres_test"  
  # postgresql9_pgcrypto "postgres_test"
  # postgresql9_pgrowlocks "dbname"
  # postgresql9_postgis "dbname" 
  # postgresql9_seg "dbname"
  # postgresql9_tablefunc "dbname"
  # postgresql9_unaccent "dbname"
  # postgresql9_uuid_ossp "dbname"
  
  #Admin-Level Contribs
  # postgresql9_pg_buffercache "postgres"
  # postgresql9_pg_freespacemap "postgres"
  
end
