if Chef::VERSION[/^0.6/]
  class Chef
    class Resource
      class RubyBlock < Chef::Resource
        def initialize(name, collection=nil, node=nil)
          super(name, collection, node)
          @resource_name = :ruby_block
          @action = :create
          @allowed_actions.push(:create)
        end
 
        def block(&block)
          if block
            @block = block
          else
            @block
          end
        end
      end
    end
  end

  class Chef
    class Provider
      class RubyBlock < Chef::Provider
        def load_current_resource
          Chef::Log.debug(@new_resource.inspect)
          true
        end
 
        def action_create
          @new_resource.block.call
        end
      end
    end
  end

  Chef::Platform.platforms[:default].merge! :ruby_block => Chef::Provider::RubyBlock
end
