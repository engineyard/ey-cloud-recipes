define :postgresql9_autoexplain do
  dbname_to_use = params[:name]

 load_shared_library do
    db_name dbname_to_use
    library_name "auto_explain"
    supported_versions %w[9.0 9.1 9.2]
  end

  include_recipe "postgresql9_extensions::ext_autoexplain"

end
