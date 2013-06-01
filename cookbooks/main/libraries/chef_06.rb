# monkey patch chef 0.6 so that it understands chef 10 attribute syntax
if Chef::VERSION[/^0.6/]
  class Chef
    class Chef06
      class Attribute
        attr_accessor :node
        
        def initialize(node)
          self.node = node
        end
        
        def [](key)
          if self.node.attribute.has_key?(key)        
            self.node.attribute[key]
          elsif self.node.attribute.has_key?(key.to_s)        
            self.node.attribute[key.to_s]
          else
            nil
          end
        end
        
        def []=(key, value)
          self.node.attribute[key] = value
        end
      end
    end
    
    class Node
      class << self
        attr_accessor :attribute
      end
      
      %w[default force_default normal override force_override automatic node].each do |attr|
        define_method attr do
          Chef::Chef06::Attribute.new(self)
        end
      end
    end
  end
end