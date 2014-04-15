define :load_shared_library, :db_name => nil, :library_name => nil, :minimum_version => nil do
  library_name = params[:library_name]
  db_name = params[:db_name]
  minimum_version = params[:minimum_version].to_f
  
  Chef::Log.info "Loading to database #{db_name} library #{library_name} supported on versions higher than: #{minimum_version}. PG version installed is #{@node[:postgres_version]}"
  
  # we ensure a minimum version is set, the version selected is at least the minimum version
  if not minimum_version.nil? && @node[:postgres_version] >= minimum_version
    # now we ensure the install syntax is appropriate for this version
    if @node[:postgres_version] == 0.0
      # we skip this
    # elsif @node[:postgres_version].to_f >= [some future revision where syntax changes]
    elsif @node[:postgres_version] >= 9.0
      execute "Postgresql loading library #{library_name}" do
        command "psql -U postgres -d #{db_name} -c \"LOAD \'#{library_name}\'\";"
      end
    end
  end
end
