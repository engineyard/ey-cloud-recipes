define :postgresql9_autoexplain, :dbname => nil do
  
# ext_name =:auto_explain #:name <= symbol, optimized for identity matching - 
config_options = {'shared_preload_libraries' => "'auto_explain'",
'custom_variable_classes' => "'auto_explain'",
'auto_explain.log_min_duration' => "'3s'"
}

sql_per_db =""

include_recipe "postgresql9_contrib::ext_autoexplain"

end
