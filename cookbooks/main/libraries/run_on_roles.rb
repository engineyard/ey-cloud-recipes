class Chef
  class Recipe
    def on_app_master(&block) do
      
    end
    
    def on_app_servers(&block) do
      
    end
    
    def on_app_servers_and_utilities(&block) do
      
    end
    
    def on_utilities(*names, &block) do
      
    end
    
    def on_db_master(&block) do
      
    end
    
    def on_db_servers(&block) do
      
    end
  end
end