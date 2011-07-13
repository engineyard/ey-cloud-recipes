define :postgresql9_postgis, :dbname => nil, :hack => nil do

  include_recipe "postgresql9_contrib::postgis_configure"

  # template "/etc/exim/exim.conf" do
  #   cookbook "exim"
  #   source "exim.conf.erb"
  #   owner "root"
  #   group "root"
  #   mode 0644
  #   backup 2
  #   variables(:p => params)
  # end

  # execute "ensure-exim-is-running" do
  #   command %Q{
  #    /etc/init.d/exim start
  #   }
  #   not_if "pgrep exim"
  # end
end
