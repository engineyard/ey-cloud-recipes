#
# Cookbook Name:: sidekiq
# Recipe:: cleanup
#

# reload monit
execute "reload-monit" do
  command "monit quit && telinit q"
  action :nothing
end

unless util_or_app_server?(node[:sidekiq][:utility_name]) 
  # report to dashboard
  ey_cloud_report "sidekiq" do
    message "Cleaning up sidekiq (if needed)"
  end
  
  if app_server? || util?
    # loop through applications
    node[:applications].each do |app_name, _|
      # monit
      file "/etc/monit.d/sidekiq_#{app_name}.monitrc" do 
        action :delete
        notifies :reload, resources(:execute => "reload-monit")
      end

      # yml files
      node[:sidekiq][:workers].times do |count|
        file "/data/#{app_name}/shared/config/sidekiq_#{count}.yml" do
          action :delete
        end
      end
    end 

    # bin script
    file "/engineyard/bin/sidekiq" do
      action :delete
    end

    # stop sidekiq
    execute "kill-sidekiq" do
      command "pkill -f sidekiq"
      only_if "pgrep -f sidekiq"
    end
  end
end