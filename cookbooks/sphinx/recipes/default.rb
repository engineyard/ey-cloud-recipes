#
# Cookbook Name:: sphinx
# Recipe:: default
#

# Set your application name here
appname = "appname"

# Uncomment the flavor of sphinx you want to use
#flavor = "thinking_sphinx"
#flavor = "ultrasphinx"

# If you want to have scheduled reindexes in cron, enter the minute
# interval here. This is passed directly to cron via /, so you should
# only use numbers between 1 - 59.
#
# If you don't want scheduled reindexes, just leave this commented.
#
# Uncommenting this line as-is will reindex once every 10 minutes.
# cron_interval = 10

if ['solo', 'app', 'app_master'].include?(node[:instance_role])

  # be sure to replace "app_name" with the name of your application.
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
        :user => node[:owner_name],
        :flavor => flavor.eql?("thinking_sphinx") ? "thinkingsphinx" : flavor,
        :mem_limit => 32
      })
    end

    execute "sphinx config" do
      command "rake #{flavor}:configure"
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
      command "rake #{flavor}:index"
      user node[:owner_name]
      environment({
        'HOME' => "/home/#{node[:owner_name]}",
        'RAILS_ENV' => node[:environment][:framework_env]
      })
      cwd "/data/#{app_name}/current"
    end

    execute "monit quit"

    if cron_interval
      cron "sphinx index" do
        action  :create
        minute  "*/#{cron_interval}"
        hour    '*'
        day     '*'
        month   '*'
        weekday '*'
        command "cd /data/#{app_name}/current && RAILS_ENV=#{node[:environment][:framework_env]} rake #{flavor}:index"
        user node[:owner_name]
      end
    end

  end

end
