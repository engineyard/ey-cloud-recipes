version='1.9'

directory "/data/swarm" do
	owner 'deploy'
	group 'deploy'
	mode 0755
	action :create
end

remote_file "/data/swarm/swarm-client.jar" do
	source "http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/#{version}/swarm-client-1.9-jar-with-dependencies.jar"
    mode 0644
  	user 'deploy'
  	group 'deploy'
end

remote_file "/etc/monit.d/swarm.monitrc" do
  source "swarm.monitrc"
  action :create
  mode 0644
end

template "/etc/init.d/swarm" do
	source "swarm-init.sh.erb"
	variables({
    	:jenkins_server => node['master_app_server']['public_ip']
        })
	mode 0775
end

execute "sudo monit reload" do
 action :run
end