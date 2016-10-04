#
# Cookbook Name:: classiclink
# Recipe:: install
#

remote_file "/tmp/awscli-bundle.zip" do
  source "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
  owner "root"
  group "root"
  mode "0644"
end

bash "install-aws-cli" do
  code "cd /tmp && rm -rf /tmp/awscli-bundle && unzip -o /tmp/awscli-bundle.zip && rm -rf /usr/local/aws && /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && rm /tmp/awscli-bundle.zip"
end

directory "/root/.aws/" do
  owner "root"
  group "root"
  mode 0755
  action :create
  recursive true
end

template "/root/.aws/config" do
  source "aws.config.erb"
  owner "root"
  group "root"
  mode 0755
end

template "/root/.aws/credentials" do
  source "aws.credentials.erb"
  owner "root"
  group "root"
  mode 0755
end
