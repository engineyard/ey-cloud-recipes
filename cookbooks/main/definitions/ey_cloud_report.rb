# reports data to the EY Cloud dashboard
define :ey_cloud_report do
  execute "reporting for #{params[:name]}" do
    command "ey-enzyme --report '#{params[:message]}'"
    epic_fail true
  end
end
