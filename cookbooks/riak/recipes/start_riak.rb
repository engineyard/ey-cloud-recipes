execute "cd /data/riak;bin/riak start && sleep 5;true" do
  action :run
#  not_if { "ps aux | grep riak" }
end
