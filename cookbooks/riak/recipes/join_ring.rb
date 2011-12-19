# Ring Related code here.
#
require 'json'
require 'net/http'
require 'resolv'
case node['name']
when "riak_0"
#I shouldn't do squat here, i'm on the master node.
Chef::Log.info "I am riak_0 at #{node[:ec2][:public_hostname]}"
else
#      begin
#        sleep 10
#        riak_stats = JSON.parse(`curl http://localhost:8098/stats`)
#        Net::HTTP.get_response(URI.parse('http://localhost:8098/stats')).body)
#      rescue
#        sleep 10
#        riak_stats = JSON.parse(Net::HTTP.get_response(URI.parse('http://localhost:8098/stats')).body)
#      end
  riak_hostname = node["engineyard"]["environment"]["instances"].map{|x| x["private_hostname"] if x["name"] =~ /^riak_0/ }.compact


# dirty hack below cover your eyes, please pardon.
#  Chef::Log.info "I am #{node[:name]} and my /stats is #{riak_stats}"
#  ring_members = riak_stats["ring_members"]

  execute "cd /data/riak;bin/riak-admin join riak@#{riak_hostname}" do
    action :run
    epic_fail true
    # FIXME: I need to start checking properly again, todo.
#    not_if { ring_members.include?("riak@#{riak_hostname}") }
  end
end
