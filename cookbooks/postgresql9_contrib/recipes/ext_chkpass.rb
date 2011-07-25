Chef::Log.info "-- from ext_chkpass --" 

  execute "enable chpass on db" do
    command "psql -d #{dbname_to_use} -f /usr/share/postgresql-9.0/contrib/chkpass.sql"
  end

  
  
