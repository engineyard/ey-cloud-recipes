# Cookbook Name:: newrelic
# Resource:: rpm

actions :install

default_action :install if defined?(default_action)

def initialize(*args)
  super
  @action = :install
end

attribute :run_type, :name_attribute => true, :kind_of => String
attribute :app_name, :kind_of => String
attribute :app_type, :kind_of => String
attribute :hostname, :kind_of => String
