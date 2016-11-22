class Chef
  class Recipe
    def db_adapter(app_type)
      db_stack_name = node[:engineyard][:environment][:db_stack_name]
      if db_stack_name == 'mysql' && app_type == 'rack'
        'mysql2'
      else
       stack_name = db_stack_name.gsub /[^a-z]+/, ''
       case stack_name
       when 'aurora', 'mariadb'
         'mysql'
       when 'postgres'
         'postgresql'
       else
         stack_name
       end
      end
    end
  end
end
