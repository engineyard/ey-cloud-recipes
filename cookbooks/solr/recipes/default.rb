#
# Cookbook Name:: solr
# Recipe:: default
#
# We specify what version we want below.

# For customers in Gentoo 2009 who need to use older JDK and Solr, uncomment these lines below:
# Note: The Java 7 ebuild is only available in Gentoo 12.11
# Gentoo 2009 - start
# use_default_java = true
# solr_dir = "apache-solr-1.4.1"
# solr_file = "apache-solr-1.4.1.tgz"
# solr_url = "http://archive.apache.org/dist/lucene/solr/1.4.1/apache-solr-1.4.1.tgz"
# Gentoo 2009 - end

# For customers in Gentoo 12.11 who want to use the latest Solr for Java 7, uncomment these lines below:
# Gentoo 12.11 - start
use_default_java = false
java_package_name = "dev-java/icedtea-bin"
java_version = node['solr']['java_version']
java_eselect_version = node['solr']['java_eselect_version']
solr_version = node['solr']['solr_version']
solr_dir = "solr-#{solr_version}"
solr_file = "solr-#{solr_version}.tgz"
solr_url = "http://archive.apache.org/dist/lucene/solr/#{solr_version}/#{solr_file}"
core_name = node['solr']['core_name']
write_sunspot_yml = node['solr']['write_sunspot_yml']
# Gentoo 12.11 - end

# Install Solr
if ('solo' == node[:instance_role])  ||
  ( ('util' == node[:instance_role]) && ('solr' == node[:name]) )

  unless use_default_java
    Chef::Log.info "Updating Java JDK"
    enable_package java_package_name do
      version java_version
      unmask true
    end

    package java_package_name do
      version java_version
      action :upgrade
    end

    execute "Set the default Java version to #{java_eselect_version}" do
      command "eselect java-vm set system #{java_eselect_version}"
      action :run
    end
  end

  directory "/var/run/solr" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  directory "/var/log/engineyard/solr" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    recursive true
  end

  template "/engineyard/bin/solr" do
    source "solr.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  variables({
    :rails_env => node[:environment][:framework_env]
  })
  end

  template "/etc/monit.d/solr.monitrc" do
    source "solr.monitrc.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables({
      :user => node[:owner_name],
      :group => node[:owner_name]
    })
  end

  remote_file "/data/#{solr_file}" do
    source "#{solr_url}"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    backup 0
    not_if { FileTest.exists?("/data/#{solr_file}") }
  end

  execute "unarchive solr-to-install" do
    command "cd /data && tar zxf #{solr_file} && sync"
    not_if { FileTest.directory?("/data/#{solr_dir}") }
  end

  execute "rename /data/solr-#{solr_version} to /data/solr" do
    command "mv /data/solr-#{solr_version} /data/solr"
    not_if { FileTest.directory?("/data/solr") }
  end

  directory "/data/solr" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  execute "chown_solr" do
    command "chown #{node[:owner_name]}:#{node[:owner_name]} -R /data/solr"
  end

  # Installs log rotation config
  cookbook_file "/etc/logrotate.d/solr" do
    owner "root"
    group "root"
    mode 0644
    source "solr.logrotate"
    backup false
    action :create
  end

   execute "monit-reload" do
     command "monit quit && telinit q"
   end

   execute "start-solr" do
     command "sleep 3 && monit start solr"
   end

   execute "create default solr core" do
     command "sleep 30 && /data/solr/bin/solr create_core -c #{core_name}"
     user "deploy"
     not_if { FileTest.directory?("/data/solr/server/solr/#{core_name}") }
   end
end

# Create the solr configuration files on solo, app and util instances
solr_instance = if ('solo' == node[:instance_role])
  node
else
  node['utility_instances'].find{ |instance| instance['name'] == 'solr' }
end

if solr_instance && ['app_master', 'app', 'solo', 'util'].include?(node[:instance_role])
  node[:applications].each do |app, data|
    template "/data/#{app}/shared/config/solr.yml" do
      source 'solr.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0655
      backup 0
      variables({
        :environment => node[:environment][:framework_env],
        :hostname => solr_instance[:hostname]
      })
    end

    if write_sunspot_yml
      template "/data/#{app}/shared/config/sunspot.yml" do
        source 'sunspot.yml.erb'
        owner node[:owner_name]
        group node[:owner_name]
        mode 0655
        backup 0
        variables({
          :environment => node[:environment][:framework_env],
          :hostname => solr_instance[:hostname],
          :core_name => core_name
        })
      end
    end
  end
end
