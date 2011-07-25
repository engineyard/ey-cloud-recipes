define :postgresql9_autoexplain, :dbname => nil do

include_recipe "postgresql9_contrib::ext_autoexplain"

end



# node.default['mystuff']['config_options']['foo'] = 1