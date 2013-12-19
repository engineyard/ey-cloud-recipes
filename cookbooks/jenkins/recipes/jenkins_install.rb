stable=true
version='latest'

remote_file "/opt/jetty/webapps/jenkins.war" do
  source "http://mirrors.jenkins-ci.org/war#{ stable ? "-stable" : ""}/#{version}/jenkins.war"
  mode 0644
  owner 'deploy'
  group 'deploy'
end

remote_file "/opt/jetty/contexts/jenkins.xml" do
  source "jenkins.xml"
  owner 'deploy'
  group 'deploy'
  mode 0644
end
