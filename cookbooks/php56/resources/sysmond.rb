# Cookbook:: newrelic
# Resource:: sysmond

actions :install, :configure

default_action [:install, :configure] if defined?(default_action)

def initialize(*args)
  super
  @action = [:install, :configure]
end

attribute :license_key, :kind_of => String
