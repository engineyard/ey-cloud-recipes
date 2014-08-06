actions :run
default_action :run

attribute :line, :kind_of => [String, Regexp], :required => true
attribute :name, :name_attribute => true, :kind_of => String, :required => true
attribute :path, :kind_of => String

attr_accessor :exists