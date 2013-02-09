#
# Cookbook Name:: sidekiq
# Recipe:: cleanup
#
  
# monit
service "monit" do
  supports :reload => true
end

unless named_util_or_app_server?(node[:sidekiq][:utility_name]) 
  # report to dashboard
  ey_cloud_report "sidekiq" do
    message "Cleaning up sidekiq (if needed)"
  end
  
  if is_app_server? || is_util?
    # loop through applications
    node[:applications].each do |app_name, _|
      # monit
      file "/etc/monit.d/sidekiq_#{app_name}.monitrc" do 
        action :delete
        notifies :reload, resources(:service => "monit")
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