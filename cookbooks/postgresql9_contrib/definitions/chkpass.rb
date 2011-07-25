define :postgresql9_chkpass, :dbname => nil do

dbname_to_use = #{params[:dbname]}

Chef::Log.info "db: #{dbname_to_use}"

# include_recipe "postgresql9_contrib::ext_chkpass"

end