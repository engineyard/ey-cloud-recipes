# Cookbook:: newrelic
# Recipe:: default

class Chef::Recipe
  include NewrelicHelpers
end

descriptive_hostname = File.read('/etc/descriptive_hostname').strip

if newrelic_enabled?
  node[:engineyard][:environment][:apps].each do |app|
    ey_cloud_report "newrelic" do
      message "configuring NewRelic RPM for #{app['name']}"
    end

    # Use the newrelic resource to install rpm
    php55 "rpm" do
      app_name app['name']
      app_type app['type']
    end
  end

  ey_cloud_report "php55_newrelic" do
    message "configuring NewRelic Server Monitoring"
  end

  # Use the newrelic resource to install server monitoring
  php55 "sysmond" do
    hostname descriptive_hostname
  end
end
