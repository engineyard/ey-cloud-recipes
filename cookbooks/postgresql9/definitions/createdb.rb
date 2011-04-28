define :createdb, :user => 'postgres' do
  db_name = params[:name].downcase
  statement = %{su - postgres -c "psql -h localhost -c \\"SELECT * FROM pg_database\\""}
  owner = params[:owner]

if ['solo','db_master'].include?(node[:instance_role])
    execute "create database for #{db_name}" do
      command %{psql -U postgres postgres -c \"CREATE DATABASE #{db_name} OWNER #{owner}\"}
    not_if "#{statement} | grep #{db_name}"
    end

    psql "alter-public-schema-owner-on-#{db_name}-to-#{owner}" do
      action :nothing
      sql "ALTER SCHEMA public OWNER TO #{owner}"

      subscribes :run, resources(:psql => "grant permissions to #{owner} on #{db_name}"), :immediately
    end
  end
end
