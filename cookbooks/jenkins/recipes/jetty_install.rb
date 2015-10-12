remote_file "/tmp/jetty.tar.gz" do
  source "http://download.eclipse.org/jetty/8.1.17.v20150415/dist/jetty-distribution-8.1.17.v20150415.tar.gz"
  action :create_if_missing
  mode 0644
end

remote_file "/etc/monit.d/jetty.monitrc" do
  source "jetty.monitrc"
  action :create
  mode 0644
end

execute "Install Jetty" do
  command "tar -zxvf /tmp/jetty.tar.gz jetty-distribution-8.1.16.v20140903/"
  cwd "/data/"
end

execute "symlink Jetty" do
  command "sudo ln -fs /data/jetty-distribution-8.1.16.v20140903 /opt/jetty"
end

execute "symlink initscript" do
  command "sudo ln -fs /opt/jetty/bin/jetty.sh /etc/init.d/jetty" 
end

execute "sudo monit reload" do
 action :run
end

