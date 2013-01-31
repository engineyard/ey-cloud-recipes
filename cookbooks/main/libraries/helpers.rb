class Chef
  class Recipe
    # applications
    def applications
      node[:applications]
    end

    # instance role
    def role
      node[:instance_role]
    end
    
    def role?(*roles)
      roles.flatten.map(&:to_s).include?(role)
    end

    # framework env
    def framework_env
      node[:environment][:framework_env]
    end
  end
end