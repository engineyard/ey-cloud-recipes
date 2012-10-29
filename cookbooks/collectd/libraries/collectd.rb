require 'chef/resource'
require 'chef/provider'
require 'chef/mixin/command'
require 'chef/log'
 
class Chef
  class Resource
    class Collectd < Chef::Resource      
      if Chef::VERSION == '0.6.0.2'
        def initialize(name, collection = nil, node = nil)
          super(name, collection, node)
          init(name)
        end
      else
        def initialize(name, run_context = nil)
          super(name, run_context)
          init(name)
        end
      end
      
      def init(name)        
        @resource_name = :collectd
        @action = :update
        @allowed_actions.push(:update)
        
        @load = nil
        @root_space = nil
        @db_space = nil
        @data_space = nil
        @mnt_space = nil
      end

      def load(arg = nil)
        arg = check_options(arg)
        set_or_return(:load, arg, :kind_of => [Hash])
      end
      
      def root_space(arg = nil)
        arg = check_options(arg)
        set_or_return(:root_space, arg, :kind_of => [Hash])
      end
      
      def db_space(arg = nil)
        arg = check_options(arg)
        set_or_return(:db_space, arg, :kind_of => [Hash])
      end
      
      def data_space(arg = nil)
        arg = check_options(arg)
        set_or_return(:data_space, arg, :kind_of => [Hash])
      end
      
      def mnt_space(arg = nil)
        arg = check_options(arg)
        set_or_return(:mnt_space, arg, :kind_of => [Hash])
      end
      
      protected
      
      def check_options(arg = nil)
        if arg.is_a?(Array)
          raise ArgumentError unless arg.length == 2
          arg = { :warning => arg[0], :failure => arg[1] }
        end
        
        if arg.is_a?(Hash)
          raise ArgumentError unless arg.key?(:warning) && arg.key?(:failure)
          
          arg.each_pair do |key, value|
            if value.is_a?(String)
              arg[key] = case value
                when /^([\d\.]+)kb/i; $1.to_f * 1024
                when /^([\d\.]+)mb/i; $1.to_f * 1048576
                when /^([\d\.]+)gb/i; $1.to_f * 1073741824 
                else value
              end
            end
          end
        end
        
        arg
      end
    end
  end
  
  class Provider
    class Collectd < Chef::Provider
      include Chef::Mixin::Command
                  
      def load_current_resource
        true
      end
      
      def action_update
        expressions = []
        
        %w[load root_space db_space data_space mnt_space].each do |type|
          if (threshold = @new_resource.send(type))
            Chef::Log.info "Setting collectd #{type} thresholds (#{threshold.inspect})"
            plugin = type[/_space$/] ? "df-#{type[/(.*)_space$/, 1]}" : type
            
            threshold.each_pair do |k, v|
              k = k.to_s.capitalize              
              expressions << %Q{/Plugin "#{plugin}"/,/Plugin/{s/#{k}Max.*/#{k}Max    #{v}/}}
            end
          end
        end
        
        flags = expressions.map{|e| "-e '#{e}'"}.join(' ')
        command = "sed -i -r #{flags} /etc/engineyard/collectd.conf && pkill -9 collectd"
        status = run_command(:command => command)
        
        if status
          Chef::Log.info("Ran #{@new_resource} successfully")
        end
      end
    end
  end
end

Chef::Platform.platforms[:default].merge!(:collectd => Chef::Provider::Collectd)