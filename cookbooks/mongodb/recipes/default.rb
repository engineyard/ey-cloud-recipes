#
# Cookbook Name:: glassfish
# Recipe:: default
#
# Copyright 2008, Engine Yard, Inc.
#
# All rights reserved - Do Not Redistribute
#


if_app_needs_recipe("glassfish") do |app,data,index|


  http_request "reporting for glassfish" do
    url node[:reporting_url]
    message :message => "processing glassfish"
    action :post
    epic_fail true
  end
  
  package "sun-jdk" do
    action :install
  end
  
  execute "install-jruby" do
    command %Q{
      curl http://dist.codehaus.org/jruby/1.1.6/jruby-bin-1.1.6.tar.gz -O &&
      tar xvzf jruby-src-1.1.6RC1.tar.gz &&
      pushd jruby-1.1.6RC1 &&
      ant &&
      popd &&
      mv jruby-1.1.6RC1 /usr/jruby &&
      rm jruby-src-1.1.6RC1.tar.gz
    }
    
    not_if { File.directory?('/usr/jruby') }
  end
  
  execute "add-to-path" do
    command %Q{
      echo 'export PATH=$PATH:/usr/jruby/bin' >> /etc/profile
    }
    not_if "grep 'export PATH=$PATH:/usr/jruby/bin' /etc/profile"
  end
  
  execute "install-jgems" do
    command %Q{
      jruby -S gem install rails glassfish --no-rdoc --no-ri
    }
    not_if "jruby -S gem list | grep glassfish"
  end
  
  execute "start-glassfish" do
    command %Q{
      cd /data/#{app}/current &&
      glassfish -p 80 -e #{@node[:environment][:framework_env]} -d
    }
    not_if "pgrep java"
  end  

end
