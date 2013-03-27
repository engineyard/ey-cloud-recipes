require 'chef/resource'
require 'chef/provider'
require 'chef/mixin/command'
require 'chef/log'
 
class Chef
  class Resource
    class Block < Chef::Resource      
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
        @resource_name = :block
        @action = :update
        @allowed_actions.push(:update)
        
        @ip = {}
      end

      def ip(address = nil, options = {})
        valid_option_keys = [:ports]
        invalid_keys = options.keys - valid_option_keys
        
        if address
          unless address && address.is_a?(String)
            raise ArgumentError, 'IP Address must be a string, eg: "219.13.1.98"'
          end
        
          unless invalid_keys.empty?
            raise ArgumentError, "The following are invalid options: #{invalid_keys.join(', ')}"
          end
        
          @ip.merge!(address => options)
        end
        
        set_or_return(:ip, @ip, :kind_of => [Hash])
      end
    end
  end
  
  class Provider
    class Block < Chef::Provider
      include Chef::Mixin::Command
                  
      def load_current_resource
        true
      end
      
      def add_rule(ip, port = nil)
        # build flags
        flags = { '-A' => 'INPUT', '-s' => ip, '-j' => 'DROP' }
        flags.merge!('-p' => 'tcp', '--dport' => port) if port
        
        # execute command
        iptables(flags)
      end
      
      def iptables(flags = {})
        command = flags.inject('iptables'){|m,(k,v)| m << " #{k} #{v}"}
        Chef::Log.info "Running: #{command}"
        run_command(:command => command)
      end
      
      def action_update
        # flush rules
        iptables('--flush' => 'INPUT')
        
        # write rules
        @new_resource.ip.each_pair do |ip, options|
          if options[:ports]
            options[:ports].each do |port|
              add_rule(ip, port)
            end
          else
            add_rule(ip)
          end
        end
        
        # save rules
        run_command(:command => "/etc/init.d/iptables save")
      end
    end
  end
end

Chef::Platform.platforms[:default].merge!(:block => Chef::Provider::Block)