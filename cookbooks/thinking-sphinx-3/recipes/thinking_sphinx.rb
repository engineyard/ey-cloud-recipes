#
# Cookbook Name:: sphinx
# Recipe:: thinking_sphinx
#

# setup thinking sphinx on each app (see attributes)
node[:sphinx][:apps].each do |app_name|
  # variables
  current_path = "/data/#{app_name}/current"
  shared_path = "/data/#{app_name}/shared"
  env = node[:environment][:framework_env]
  
  # check that application is deployed
  if File.symlink?(current_path)
    # config yml
    template "#{shared_path}/config/thinking_sphinx.yml" do
      source "thinking_sphinx.yml.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode "0644"
      backup 0
      variables({
        :environment => env,
        :address => node[:sphinx][:host],
        :pid_file => "#{shared_path}/log/#{env}.sphinx.pid"
      })
    end

    #symlink config yml
    link "#{current_path}/config/thinking_sphinx.yml" do
      to "#{shared_path}/config/thinking_sphinx.yml"
    end
      
    if util_or_app_server?(node[:sphinx][:utility_name])       
      # create sphinx directory
      directory "#{shared_path}/sphinx" do
        owner node[:owner_name]
        group node[:owner_name]
      end
      
      # remove sphinx dir
      directory "#{current_path}/db/sphinx" do
        action :delete
        recursive true
        only_if "test -d #{current_path}/db/sphinx"
      end
    
      # symlink
      link "#{current_path}/db/sphinx" do
        to "#{shared_path}/sphinx"
      end
      
      # install bundler if not present
      gem_package "bundler" do
        action :install
        not_if "gem list | grep bundler"
      end
    
      # configure thinking sphinx
      execute "configure sphinx" do 
        command "cd #{current_path} && bundle exec rake ts:configure"
        user node[:owner_name]
        environment 'RAILS_ENV' => env
      end
    
      # index unless index already exists
      execute "indexing" do
        command "cd #{current_path} && bundle exec rake ts:index"
        user node[:owner_name]
        environment 'RAILS_ENV' => env
      end
    end
  else
    Chef::Log.info "Thinking Sphinx was not configured because the application (#{app_name}) must be deployed first. Please deploy your application and then re-run the custom chef recipes."
  end
end