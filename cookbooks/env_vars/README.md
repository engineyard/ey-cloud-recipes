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

To have the environment variables available to a Rails console they must be sourced for the bash session. The most straight-forward way to achieve this is have the .bash_profile source the same env.custom file created by the recipe.

To do this you would update the /home/deploy/.bash_profile to contain:

```
  [[ -f ~/.bashrc ]] && . ~/.bashrc
  [[ -f /data/INSERT_APP_NAME/shared/config/env.custom ]] && . /data/INSERT_APP_NAME/shared/config/env.custom
```

This works best on environments with just one app, as the specified app's variables will be sourced for all sessions. If you have multiple apps, you should choose just one per environment.

Rails 4.1 adds secret.yml support as a better solution than environment variables. You can put this file into the the shared/config directory (like database.yml) so it's not stored in your repo (just on the snapshots) and you can use it in Rails 4.0 and 3.2 with https://github.com/pixeltrix/rails-secrets.

For further information on using environment variables, and alternative solutions, please see: https://support.cloud.engineyard.com/entries/36999448-Environment-Variables-and-Why-You-Shouldn-t-Use-Them
