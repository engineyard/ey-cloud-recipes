Environment Variables for Cloud
-------------------------------

This cookbook allows you to set environment variables for any application server that sources /data/INSERT_APP_NAME/shared/env.custom, this includes Unicorn and PHP-FPM.  If Passenger is used, a Ruby wrapper script is created and the passenger_ruby directive is added in the Nginx configuration.  This script just sources the env.custom file and calls Ruby.

Set environment variables in attributes/env_vars.rb

  Example:

  ```
  default[:env_vars] = {
    :RUBY_HEAP_MIN_SLOT => "10000",
    :RUBY_HEAP_SLOTS_INCREMENT => "10000",
    :RUBY_HEAP_SLOTS_GROWTH_FACTOR => "1.8",
    :RUBY_GC_MALLOC_LIMIT => "8000000",
    :RUBY_HEAP_FREE_MIN => "4096",
  }
  ```
