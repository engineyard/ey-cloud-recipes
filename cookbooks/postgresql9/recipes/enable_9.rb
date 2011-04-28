# Note this recipe is just a lame placeholder as I was not select'ing 9.0 to enabled on the app slices...

execute "activate_postgres_9" do
  command "eselect postgresql set 9.0"
  action :run
end
