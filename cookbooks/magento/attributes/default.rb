# Use one hash to the array for each Magento application deployed to the environment.
# The application name should be the same name that you specified in the dashboard.

default[:magento_apps] = [
{
  :app_name => "APP1 NAME HERE"          # Set your application name here
  :encryption_key => "APP1 KEY HERE",    # Add your encryption key here
  :redis_session_store => true,          # Set to true to enable Redis session storage
  :redis_page_caching => true            # Set to true to enable Redis page caching
}]

# Example for two applications:
#
# default[:magento_apps] = [{
#  :app_name => "app1"
#  :encryption_key => "app1_key",
#  :redis_session_store => true,
#  :redis_page_caching => true
#},{
#  :app_name => "app2"
#  :encryption_key => "app2_key",
#  :redis_session_store => false,
#  :redis_page_caching => false
#}]
