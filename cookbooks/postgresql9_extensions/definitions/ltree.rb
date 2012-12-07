define :postgresql9_ltree do
 dbname_to_use = params[:name]

  load_sql_file do
    db_name dbname_to_use
    extname "ltree"
    supported_versions %w[9.0 9.1 9.2]
  end
end
