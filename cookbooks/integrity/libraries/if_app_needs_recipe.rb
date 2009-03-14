class Chef
  class Recipe
    def if_app_needs_recipe(recipe, &block)
      index = 0
      node[:applications].map{|k,v| [k,v] }.sort_by {|a,b| a }.each do |name, app_data|
        if app_data[:recipes].detect { |r| r == recipe }
          Chef::Log.info("Applying Recipe: #{recipe}")
          block.call(name, app_data, index)
          index += 1
        end
      end
    end

    def any_app_needs_recipe?(recipe)
      needs = false
      node[:applications].each do |name, app_data|
        if app_data[:recipes].detect { |r| r == recipe }
          needs = true
        end
      end
      needs
    end

  end
end