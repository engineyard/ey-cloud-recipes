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
      if names.empty? || names.flatten.map(&:to_s).include?(node[:name])
        run_on_roles('util', &block)
      end
    end

    def on_solo_or_utility(name, &block) do
      if role?(:solo) || (role?(:util) && [nil, '', name.to_s].include?(node[:name].to_s))
        yield
      end
    end
    
    def on_db_master(&block) do
      run_on_roles('db_master', 'solo', &block)
    end
    
    def on_db_servers(&block) do
      run_on_roles('db_master', 'db_slave', 'solo', &block)
    end
    
    protected
    
    def run_on_roles(*roles, &block)
      yield if role?(roles)
    end
  end
end