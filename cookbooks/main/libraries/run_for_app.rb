class Chef
  class Recipe
    def run_for_app(app, &block)
      node[:applications].map{|k,v| [k,v] }.sort_by {|a,b| a }.each do |name, app_data|
        if name == app
          block.call(name, app_data)
        end
      end
    end
  end
end