if node['utility_instances'].empty?
  Chef::Log.info("No utility instances found, aborting")
else
  if ['solo','app_master', 'app'].include?(node[:instance_role])
    enable_package 'net-proxy/haproxy' do
      version '1.4.8'
    end

    package "net-proxy/haproxy" do
      version '1.4.8'
      action :upgrade
    end

    riak_instances = []
    riak_instances << node["engineyard"]["environment"]["instances"].map{|x| x["private_hostname"] if x["name"] =~ /^riak_/ }.compact
    
    template "/etc/haproxy_riak.cfg" do
      owner 'root'
      group 'root'
      mode 0644
      source "haproxy.cfg.erb"
      variables({
        :backends => riak_instances,
        :haproxy_user => node[:haproxy][:username],
        :haproxy_pass => node[:haproxy][:password]
      })
    end
    
    template "/etc/monit.d/haproxy_riak.monitrc" do
      source "haproxy_monitrc.erb"
      backup 0
      owner "root"
      group "root"
      mode 0655
      variables(
        :pidfile => "/var/run/haproxy_riak.pid"
      )
    end

    execute "monit reload" do
      action :run
    end
  end
end

