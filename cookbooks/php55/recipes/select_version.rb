execute "eselect-php55" do
  command <<-EOM
    eselect php set cli php#{node[:php][:short_version]}
    eselect php set cgi php#{node[:php][:short_version]}
    eselect php set fpm php#{node[:php][:short_version]}
  EOM
end
