class Chef
  class Recipe
    def on_app_master(&block) do
      run_on_roles('app_master', 'solo', &block)
    end
    
    def on_app_servers(&block) do
      run_on_roles('app_master', 'app', 'solo', &block)
    end
    
    def on_app_servers_and_utilities(&block) do
      run_on_roles('app_master', 'app', 'util', 'solo', &block)
    end
    
    def on_utilities(*names, &block) do
      if names.include?(node[:name])
        run_on_roles('util', &block)
      end
    end

    def on_utility_or_solo(name, &block) do
      if node[:instance_role] == 'solo' || node[:name] == name
        yield
      end
    end
    
    def on_db_master(&block) do
      run_on_roles('db_master', 'solo', &block)
    end
    
    def on_db_servers(*names, &block) do
      run_on_roles('db_master', 'db_slave', 'solo', &block)
    end
    
    protected
    
    def run_on_roles(*roles, &block)
      yield if roles.include?(node[:instance_role])
    end
  end
end