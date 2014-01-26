#
# Cookbook Name:: collectd-custom
# Definitions:: collectd_plugin
#

define :collectd_plugin, :options => {}, :template => nil, :cookbook => nil do
  template "/data/collectd.d/plugin-#{params[:name]}.conf" do
    owner node['collectd-custom']['user']
    group node['collectd-custom']['user']
    mode 0644
    if params[:template].nil?
      source "plugin.conf.erb"
      cookbook params[:cookbook] || 'collectd-custom'
    else
      source params[:template]
      cookbook params[:cookbook]
    end
    variables({
      :name => params[:name],
      :options => params[:options]
    })
    notifies :restart, "service[#{node['collectd-custom']['service_name']}]"
  end
end

define :collectd_python_plugin, :options => {}, :module => nil, :path => nil do
  begin
    t = resources(:template => '/data/collectd.d/plugin-python.conf')
  rescue ArgumentError,Chef::Exceptions::ResourceNotFound
    collectd_plugin "python" do
      options :paths => ["#{node['collectd-custom']['dir']}/lib/collectd"], :modules => {}
      template 'python_plugin.conf.erb'
      cookbook 'collectd-custom'
    end
    retry
  end
  t.variables[:options][:paths] << params[:path] unless params[:path].nil?
  t.variables[:options][:modules][params[:module] || params[:name]] = params[:options]
end
