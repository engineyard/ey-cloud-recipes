define :postgresql9_chkpass do
# Chef::Log.info "db: #{dbname_to_use}"
# Chef::Log.info "cmd: psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-9.0/contrib/chkpass.sql"
  dbname_to_use = params[:name]
  execute "enable chpass on db" do
    command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-9.0/contrib/chkpass.sql"
  end
end