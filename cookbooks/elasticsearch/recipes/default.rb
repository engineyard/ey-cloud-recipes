#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Credit goes to GoTime for their original recipe ( http://cookbooks.opscode.com/cookbooks/elasticsearch )

if ['util'].include?(node[:instance_role])
  if node['name'].include?('elasticsearch_')
    elasticsearch_instances = []
    node['utility_instances'].each do |elasticsearch|
      if elasticsearch['name'].include?("elasticsearch_")
        elasticsearch_instances << elasticsearch['hostname']
    end
  end

  remote_file "/tmp/elasticsearch-#{node[:elasticsearch_version]}.zip" do
    source "https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-#{node[:elasticsearch_version]}.zip"
    mode "0644"
    checksum node[:elasticsearch_checksum]
  end

  user "elasticsearch" do
  uid 61021
  gid "nogroup"
  end

  # Update JAVA as the Java on the AMI can sometimes crash
  #
  package "dev-java/sun-jdk" do
    version "1.6.0.26"
    action :upgrade
  end

  directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}" do
    owner "root"
    group "root"
    mode 0755
  end

  ["/var/log/elasticsearch", "/var/lib/elasticsearch", "/var/run/elasticsearch"].each do |dir|
    directory dir do
      owner "root"
      group "root"
      mode 0755
    end
  end

  bash "unzip elasticsearch" do
    user "root"
    cwd "/tmp"
    code %(unzip /tmp/elasticsearch-#{node[:elasticsearch_version]}.zip)
    not_if { File.exists? "/tmp/elasticsearch-#{node[:elasticsearch_version]}" }
  end

  bash "copy elasticsearch root" do
    user "root"
    cwd "/tmp"
    code %(cp -r /tmp/elasticsearch-#{node[:elasticsearch_version]}/* /usr/lib/elasticsearch-#{node[:elasticsearch_version]})
    not_if { File.exists? "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/lib" }
  end

  directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/plugins" do
    owner "root"
    group "root"
    mode 0755
  end

  link "/usr/lib/elasticsearch" do
    to "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}"
  end

  directory "#{node[:elasticsearch_home]}" do
    owner "elasticsearch"
    group "nogroup"
    mode 0755
  end

  directory "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/data" do
    owner "root"
    group "root"
    mode 0755
    action :create
    recursive true
  end

  mount "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/data" do
    device "#{node[:elasticsearch_home]}"
    fstype "none"
    options "bind,rw"
    action :mount
  end

  template "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/config/logging.yml" do
    source "logging.yml.erb"
    mode 0644
  end

  directory "/usr/share/elasticsearch" do
    group "elasticsearch"
    group "nogroup"
    mode 0755
  end

  max_mem = ((node[:memory][:total].to_i / 1024 * 0.75)).to_i.to_s + "m"
  template "/usr/share/elasticsearch/elasticsearch.in.sh" do
    source "elasticsearch.in.sh.erb"
    mode 0644
    backup 0
    variables(
      :es_max_mem => ((node[:memory][:total].to_i / 1024 * 0.75)).to_i.to_s + "m"
    )
  end

  # include_recipe "elasticsearch::s3_bucket"

  template "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/config/elasticsearch.yml" do
    source "elasticsearch.yml.erb"
    owner "elasticsearch"
    group "nogroup"
    variables(
    :aws_access_key => node[:aws_secret_key],
    :aws_access_id => node[:aws_secret_id],
    :elasticsearch_s3_gateway_bucket => node[:elasticsearch_s3_gateway_bucket],
    :elasticsearch_instances => elasticsearch_instances,
    :elasticsearch_defaultreplicas => node[:elasticsearch_defaultreplicas],
    :elasticsearch_defaultshards => node[:elasticsearch_defaultshards],
    :elasticsearch_clustername => node[:elasticsearch_clustername]
    )
    mode 0600
    backup 0
  end
  end
end
execute "start elasticsearch" do
  cwd "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/bin"
  command "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/bin/elasticsearch;true"
  not_if { File.exists?("/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/data/#{node[:elasticsearch_clustername]}/nodes/0/node.lock") }
  # NO I AM NOT SURE THIS IS RIGHT? GOT A BETTER IDEA?
end

#template "/etc/monit.d/elasticsearch_#{node[:elasticsearch_clustername]}" do
#  source "elasticsearch.monitrc.erb"
#  owner "elasticsearch"
#  group "nogrpup"
#  backup 0
#  mode 0644
#end
