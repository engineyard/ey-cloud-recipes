define :postgresql9_chkpass do
 dbname_to_use = params[:name]  
 
  load_sql_file do 
    db_name dbname_to_use
    username "postgres"
    filename "/usr/share/postgresql-9.0/contrib/chkpass.sql"
  end

end