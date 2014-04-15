define :postgresql9_dict_xsyn do
 dbname_to_use = params[:name]

  load_sql_file do
    db_name dbname_to_use
    extname "dict_xsyn"
    minimum_version 9.0
  end
end
