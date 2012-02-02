define :postgresql9_btree_gist do
 dbname_to_use = params[:name]  
 
  load_sql_file do 
    db_name dbname_to_use
    username "postgres"
    extname "btree_gist"
    supported_versions %w[9.0 9.1]
  end

end