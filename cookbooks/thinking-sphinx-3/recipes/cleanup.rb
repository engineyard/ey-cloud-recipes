#
# Cookbook Name:: sphinx
# Recipe:: cleanup
#

# reload monit
execute "reload-monit" do
  command "monit quit && telinit q"
  action :nothing
end

unless util_or_app_server?(node[:sphinx][:utility_name]) 
  # report to dashboard
  ey_cloud_report "sphinx" do
    message "Cleaning up sphinx (if needed)"
  end
  
  if app_server? || util?
    # loop through applications
    node[:applications].each do |app_name, _|
      # monit
      file "/etc/monit.d/sphinx_#{app_name}.monitrc" do 
        action :delete
        notifies :run, resources(:execute => "reload-monit")
        only_if "test -f /etc/monit.d/sphinx_#{app_name}.monitrc"
      end
    
      # remove cronjob
      cron "indexer-#{app_name}" do
        action :delete
      end
    end 

    # stop sphinx
    execute "kill-sphinx" do
      command "pkill -f searchd"
      only_if "pgrep -f searchd"
    end
  end
end