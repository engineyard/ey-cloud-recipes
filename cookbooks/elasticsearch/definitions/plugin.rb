define :es_plugin, :name => nil do
  name = params[:name]

  case params[:action].to_sym
  when :install
    Chef::Log.info "attempting to install ElasticSearch plugin #{name}"

    execute "plugin install #{name}" do
      cwd "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}"
      command "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/bin/plugin -install #{name}"
      not_if { File.directory?("/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/plugins/#{name}") }
    end

  when :remove
    Chef::Log.info "attempting to remove ElasticSearch plugin #{name}"

    execute "plugin remove #{name}" do
      cwd "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}"
      command "/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/bin/plugin -remove #{name}"
      not_if { File.directory?("/usr/lib/elasticsearch-#{node[:elasticsearch_version]}/plugins/#{name}") }
    end
  end
end
