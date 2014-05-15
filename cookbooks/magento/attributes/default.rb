default[:magento] = {
  :encryption_key => "INSERT KEY HERE",   # Add your encryption key here
  :redis_session_store => true,          # Set to true to enable Redis session storage
  :redis_page_caching => true            # Set to true to enable Redis page caching
}