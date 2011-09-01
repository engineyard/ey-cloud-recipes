define :postgresql9_autoexplain do
  dbname_to_use = params[:name]
  Chef::Log.info "db: #{dbname_to_use}"
  
 load_shared_library do 
    db_name dbname_to_use 
    library_name "auto_explain"
  end
  
  include_recipe "postgresql9_contrib::ext_autoexplain"

end


