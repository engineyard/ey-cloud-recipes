define :postgresql9_autoexplain do
  dbname_to_use = params[:name]

 load_shared_library do
    db_name dbname_to_use
    library_name "auto_explain"
    minimum_version 9.0
  end

  include_recipe "postgresql9_extensions::ext_autoexplain"

end
