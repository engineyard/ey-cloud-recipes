class Chef
  class Recipe
    # Returns true if current instance is of type(any):
    # * solo
    def solo?
      instance_role?(:solo)
    end

    # Returns true if current instance is of type(any):
    # * app_master
    # * solo
    def app_master?
      instance_role?(:app_master, :solo)
    end

    # Returns true if current instance is of type(any):
    # * app_master
    # * app
    # * solo
    def app_server?
      instance_role?(:app_master, :app, :solo)
    end

    # Returns true if current instance is of type(any):
    # * db_master
    # * solo
    def db_master?
      instance_role?(:db_master, :solo)
    end

    # Returns true if current instance is of type(any):
    # * db_slave
    def db_slave?
      instance_role?(:db_slave)
    end

    # Returns true if current instance is of type(any):
    # * db_master
    # * db_slave
    # * solo
    def db_server?
      instance_role?(:db_master, :db_slave, :solo)
    end

    # Returns true if current instance is of type(any):
    # * util and have the given name
    def util?(name = nil)
      instance_role?(:util) && instance_named?(name)
    end

    def has_util?(name = nil)
      node[:utility_instances].any? do |util|
        name.empty? || util[:name][/#{name}/i]
      end
    end

    # Returns true if current instance is of type(any):
    # * util
    # * app_master
    # * app
    # * solo
    # and also has the given name
    def util_or_app_server?(name = nil)
      if name.to_s != '' && has_util?(name)
        util?(name)
      else
        app_server?
      end
    end

    protected

    def instance_role?(*roles)
      [*roles].flatten.map { |r| r.to_s }.include?(node[:instance_role])
    end

    def instance_named?(str = nil)
      str.to_s == '' || node[:name][/#{str}/i]
    end
  end
end
