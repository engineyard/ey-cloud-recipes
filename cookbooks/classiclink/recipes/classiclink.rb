#
# Cookbook Name:: classiclink
# Recipe:: classiclink
#

id = node[:engineyard][:this]
bash "attach-classiclink-for-#{id}" do
  code "aws ec2 attach-classic-link-vpc --instance-id #{id} --vpc-id #{node[:classiclink_vpc_id]} --groups #{node[:classiclink_security_group_id]}"
end
