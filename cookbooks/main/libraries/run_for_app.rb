class Chef
  class Recipe
    def run_for_app(*apps, &block)
      apps.map! {|a| a.to_s }
      node[:applications].map{|k,v| [k,v] }.sort_by {|a,b| a }.each do |name, app_data|
        if apps.include?(name)
          block.call(name, app_data)
        end
      end
    end
  end
end