stable=true
version='latest'

remote_file "/opt/jetty/webapps/jenkins.war" do
  source "http://mirrors.jenkins-ci.org/war#{ stable ? "-stable" : ""}/#{version}/jenkins.war"
  mode 0644
  owner node[:owner_name]
  group node[:owner_name]
end

remote_file "/opt/jetty/contexts/jenkins.xml" do
  source "jenkins.xml"
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
end
