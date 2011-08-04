define :postgresql9_autoexplain do
  dbname_to_use = params[:name]
  execute "enable chpass on db" do
    command "psql -U postgres -d #{dbname_to_use} -c "LOAD 'auto_explain'";"
  end
  
  include_recipe "postgresql9_contrib::ext_autoexplain"

end


