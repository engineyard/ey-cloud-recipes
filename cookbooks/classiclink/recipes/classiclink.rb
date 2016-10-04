#
# Cookbook Name:: classiclink
# Recipe:: classiclink
#

if solo? || app_master?
  node[:engineyard][:environment][:instances].each do |i|
    id = i.first[1]
    bash "attach-classiclink-for-#{id}" do
      code "aws ec2 attach-classic-link-vpc --instance-id #{id} --vpc-id #{node[:classiclink_vpc_id]} --groups #{node[:classiclink_security_group_id]}"
    end
  end
end
