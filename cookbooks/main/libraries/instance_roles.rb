class Chef
  class Recipe
    def is_solo?
      instance_role?(:solo)
    end

    def is_app_master?
      instance_role?(:app_master, :solo)
    end

    def is_app_server?
      instance_role?(:app_master, :app, :solo)
    end
    
    def is_db_master?
      instance_role?(:db_master, :solo)
    end
    
    def is_db_slave?
      instance_role?(:db_slave)
    end
    
    def is_db_server?
      instance_role?(:db_master, :db_slave, :solo)
    end
    
    def is_util?(name = nil)
      instance_role?(:util) && named?(name)
    end
    
    def has_util?(name = nil)
      node[:utility_instances].any? do |util|
        name.empty? || util[:name][/#{name}/i]
      end
    end
    
    def named_util_or_app_server?(name = nil)
      if !name.empty? && has_util?(name)
        is_util?(name)
      else
        is_app_server?
      end
    end
    
    protected
    
    def instance_role?(*roles)
      [*roles].flatten.map{|r| r.to_s}.include?(node[:instance_role])
    end
    
    def named?(str = nil)
      str.empty? || node[:name][/#{str}/i]
    end
  end
end