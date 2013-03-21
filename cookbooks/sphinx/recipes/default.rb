#
# Cookbook Name:: sphinx
# Recipe:: default
#

# Set your application name here
appname = "myapp"

# Uncomment the flavor of sphinx you want to use
flavor = "thinking_sphinx"
#flavor = "ultrasphinx"

# If you want to install on a specific utility instance rather than
# all application instances, uncomment and set the utility instance
# name here. Note that if you use a utility instance, your very first
# deploy may fail because the initial database migration will not have
# run by the time this executes on the utility instance. If that occurs
# just deploy again and the recipe should succeed.

utility_name = nil
# utility_name = "sphinx"

# If you want to have scheduled reindexes in cron, enter the minute
# interval here. This is passed directly to cron via /, so you should
# only use numbers between 1 - 59.
#
# If you don't want scheduled reindexes, just leave this set to nil.
# Setting it equal to 10 would run the cron job every 10 minutes.

cron_interval = nil #If this is not set your data will NOT be indexed


if ! File.exists?("/data/#{appname}/current")
  Chef::Log.info "Sphinx was not configured because the app must be deployed first.  Please deploy it then re-run custom recipes."
else
  if utility_name
    sphinx_host = node[:utility_instances].find {|u| u[:name] == utility_name }[:hostname]
    if ['solo', 'app', 'app_master'].include?(node[:instance_role])
      run_for_app(appname) do |app_name, data|
        ey_cloud_report "Sphinx" do
          message "configuring #{flavor}"
        end

        directory "/data/#{app_name}/shared/config/sphinx" do
          recursive true
          owner node[:owner_name]
          group node[:owner_name]
          mode 0755
        end

        template "/data/#{app_name}/shared/config/sphinx.yml" do
          owner node[:owner_name]
          group node[:owner_name]
          mode 0644
          source "sphinx.yml.erb"
          variables({
            :app_name => app_name,
            :address => sphinx_host,
            :user => node[:owner_name],
            :mem_limit => '32M'
          })
        end
      end
    end

    if node[:name] == utility_name
      run_for_app(appname) do |app_name, data|
        ey_cloud_report "Sphinx" do
          message "configuring #{flavor}"
        end

        directory "/var/run/sphinx" do
          owner node[:owner_name]
          group node[:owner_name]
          mode 0755
        end

        directory "/var/log/engineyard/sphinx/#{app_name}" do
          recursive true
          owner node[:owner_name]
          group node[:owner_name]
          mode 0755
        end

        directory "/data/#{app_name}/shared/config/sphinx" do
          recursive true
          owner node[:owner_name]
          group node[:owner_name]
          mode 0755
        end

        remote_file "/etc/logrotate.d/sphinx" do
          owner "root"
          group "root"
          mode 0755
          source "sphinx.logrotate"
          backup false
          action :create
        end

        template "/etc/monit.d/sphinx.#{app_name}.monitrc" do
          source "sphinx.monitrc.erb"
          owner node[:owner_name]
          group node[:owner_name]
          mode 0644
          variables({
            :app_name => app_name,
            :user => node[:owner_name],
            :flavor => flavor
          })
        end

        template "/data/#{app_name}/shared/config/sphinx.yml" do
          owner node[:owner_name]
          group node[:owner_name]
          mode 0644
          source "sphinx.yml.erb"
          variables({
            :app_name => app_name,
            :address => sphinx_host,
            :user => node[:owner_name],
            :mem_limit => '32M'
          })
        end

        gem_package "bundler" do 
          source "http://rubygems.org" 
          action :install 
          version "1.0.21" 
        end

        execute "sphinx config" do
          command "bundle exec rake #{flavor}:configure"
          user node[:owner_name]
          environment({
            'HOME' => "/home/#{node[:owner_name]}",
            'RAILS_ENV' => node[:environment][:framework_env]
          })
          cwd "/data/#{app_name}/current"
        end

        ey_cloud_report "indexing #{flavor}" do
          message "indexing #{flavor}"
        end

        execute "#{flavor} index" do
          command "bundle exec rake #{flavor}:index"
          user node[:owner_name]
          environment({
            'HOME' => "/home/#{node[:owner_name]}",
            'RAILS_ENV' => node[:environment][:framework_env]
          })
          cwd "/data/#{app_name}/current"
        end

        execute "monit reload"

        if cron_interval
          cron "sphinx index" do
            action  :create
            minute  "*/#{cron_interval}"
            hour    '*'
            day     '*'
            month   '*'
            weekday '*'
            command "cd /data/#{app_name}/current && RAILS_ENV=#{node[:environment][:framework_env]} bundle exec rake #{flavor}:index"
            user node[:owner_name]
          end
        end
      end
    end
  else
    if ['solo', 'app', 'app_master'].include?(node[:instance_role])
      run_for_app(appname) do |app_name, data|
        ey_cloud_report "Sphinx" do
          message "configuring #{flavor}"
        end

        directory "/var/run/sphinx" do
          owner node[:owner_name]
          group node[:owner_name]
          mode 0755
        end

        directory "/var/log/engineyard/sphinx/#{app_name}" do
          recursive true
          owner node[:owner_name]
          group node[:owner_name]
          mode 0755
        end

        directory "/data/#{app_name}/shared/config/sphinx" do
          recursive true
          owner node[:owner_name]
          group node[:owner_name]
          mode 0755
        end

        remote_file "/etc/logrotate.d/sphinx" do
          owner "root"
          group "root"
          mode 0755
          source "sphinx.logrotate"
          backup false
          action :create
        end

        template "/etc/monit.d/sphinx.#{app_name}.monitrc" do
          source "sphinx.monitrc.erb"
          owner node[:owner_name]
          group node[:owner_name]
          mode 0644
          variables({
            :app_name => app_name,
            :user => node[:owner_name],
            :env => node[:environment][:framework_env],
            :flavor => flavor
          })
        end

        template "/data/#{app_name}/shared/config/sphinx.yml" do
          owner node[:owner_name]
          group node[:owner_name]
          mode 0644
          source "sphinx.yml.erb"
          variables({
            :app_name => app_name,
            :address => 'localhost',
            :user => node[:owner_name],
            :mem_limit => '32'
          })
        end

        gem_package "bundler" do 
          source "http://rubygems.org" 
          action :install 
          version "1.0.21" 
        end


        execute "sphinx config" do
          command "bundle exec rake #{flavor}:configure"
          user node[:owner_name]
          environment({
            'HOME' => "/home/#{node[:owner_name]}",
            'RAILS_ENV' => node[:environment][:framework_env]
          })
          cwd "/data/#{app_name}/current"
        end

        ey_cloud_report "indexing #{flavor}" do
          message "indexing #{flavor}"
        end

        execute "#{flavor} index" do
          command "bundle exec rake #{flavor}:index"
          user node[:owner_name]
          environment({
            'HOME' => "/home/#{node[:owner_name]}",
            'RAILS_ENV' => node[:environment][:framework_env]
          })
          cwd "/data/#{app_name}/current"
        end

        execute "monit reload"

        if cron_interval
          cron "sphinx index" do
            action  :create
            minute  "*/#{cron_interval}"
            hour    '*'
            day     '*'
            month   '*'
            weekday '*'
            command "cd /data/#{app_name}/current && RAILS_ENV=#{node[:environment][:framework_env]} bundle exec rake #{flavor}:index"
            user node[:owner_name]
          end
        end
      end
    end
  end
end
