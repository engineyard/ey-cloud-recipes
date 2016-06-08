# Configuration Options
  # recommended versions as of June 8, 2016
  #  - Postgres: 9.2.7, 9.3.9, 9.4.4
  #  - MySQL: 5.6.27
  #  - Available versions under:
  #    - Postgres: /engineyard/portage/engineyard/dev-db/postgresql-server/*.ebuild
  #    - MySQL: /engineyard/portage/engineyard/dev-db/percona-server/*.ebuild
install_packages=[
  {
    :server => 'postgresql-server',   # postgresql-server or percona-server
    :version => '9.4.4',
    :default_slot => false,                   # postgres packages only, use true only with no_db environments, makes this package the system default
  },
  ]

if ['app', 'app_master', 'util'].include?(node['instance_role'])
  install_packages.each do |package|
    
    ey_cloud_report "Installing db_client_lib #{package[:server]}"
      message "installing #{package[:server]}-#{package[:version]}"
    end
    
    if package[:server] == 'postgresql-server'
      
      enable_package "dev-libs/ossp-uuid" do
        version "1.6*"
      end
      
      enable_package "dev-python/python-exec" do
        version '0.2'
        only_if { package[:version] >= '9.3' }
      end
      
      enable_package "dev-db/postgresql-base" do
        version package[:version]
      end
      
      enable_package "dev-db/postgresql-server" do
        version package[:version]
      end
      
      package "dev-db/postgresql-server" do
        version package[:version]
        action :install
      end
      
      execute "activate_postgres_#{package[:version]}" do
        command "eselect postgresql set #{package[:version]}"
        action :run
        only_if { package[:default_slot] }
      end
      
    elsif package[:server] == 'percona-server'
      
      virtual = "#{package[:version].split('.')[0]}.#{package[:version].split('.')[1]}"
      
      unmask_package "virtual/mysql" do
        version virtual
        unmaskfile "mysql"
      end
      
      enable_package "virtual/mysql" do
        version virtual
      end
      
      unmask_package "dev-db/#{package[:server]}" do
        version package[:version]
        unmaskfile "mysql"
      end
      
      enable_package "dev-db/#{package[:server]}" do
        version package[:version]
      end
      
      enable_package "dev-util/cmake" do
        version '2.6.2'
      end
      
      package "dev-db/#{package[:server]}" do
        version package[:version]
        action :install
      end
    
    else
      ey_cloud_report "Installation of #{package[:server]}-#{package[:version]} failed:"
        message "this server and version is unknown."
      end
    end
    
  end
  
  ey_cloud_report "Installation of db_client_libs"
    message "complete!"
  end
end