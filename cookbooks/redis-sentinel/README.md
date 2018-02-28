# Redis Sentinel

This recipe installs version Redis Sentinel 2.8 or later using either the package from the Engine Yard portage tree or the Redis installer from redis.io. Redis Sentinel is actually Redis running in sentinel mode, so you might find some similarities between this recipe and the Redis recipe.

## Installation

1. Edit `cookbooks/main/recipes/default.rb` and add

      ```
      include_recipe 'redis-sentinel'
      ```

2. Boot a redis slave instance. Please refer to the Redis recipe for detailed instructions.


3. Edit `cookbooks/redis-sentinel/attributes.rb` to specify where to install Redis Sentinel. You can choose to install Redis Sentinel on all app instances, or on all utility instances that match a given name. For environments running Sidekiq, we recommend installing Redis Sentinel on all Sidekiq instances. 

  NOTE: You need at least 3 Redis Sentinel instances to have a proper quorum.

4. Download the ey-core gem on your local machine and upload the recipes

  ```
  gem install ey-core
  ey-core recipes upload --environment=<nameofenvironment> --file=<pathtocookbooksfolder> --apply
  ```
  
5. After the chef run, verify that the Redis Sentinels are properly monitoring the Redis master instance. SSH into the Redis Sentinel instances and run this command:

  ```
  redis-cli -p 26379 info
  ```
  
  NOTE: If you specified a different Redis Sentinel port then you should use that in the redis-cli command. 
  
  In the last section of the output you should see information about the Redis master instance, and the number of connected sentinel instances:
  
  ```
  # Sentinel
  sentinel_masters:1
  sentinel_tilt:0
  sentinel_running_scripts:0
  sentinel_scripts_queue_length:0
  sentinel_simulate_failure_flags:0
  master0:name=redis,status=ok,address=172.31.20.21:6379,slaves=1,sentinels=2
  ```

## Customizations

All customizations go to `cookbooks/redis-sentinel/attributes/default.rb`.

### Choose the instances that run the recipe

By default, the Redis Sentinel recipe runs on a utility instance named "sidekiq". You can change this by modifying `attributes/default.rb`.

#### A. Run Redis Sentinel on a utility instances with a custom name

* Ensure that these lines are not commented out:

  ```
  sentinel['utility_name'] = 'sidekiq'
  sentinel['install_type'] = 'NAMED_UTILS'
  ```

* Specify the Redis Sentinel instance name. If the instances are not yet running, boot instances with that name.

* Make sure this line is commented out:

  ```
  # sentinel['install_type'] = 'ALL_APP_INSTANCES'
  ```

#### B. Run Redis Sentinel on all application instances

* Ensure that these lines are not commented out:

  ```
  sentinel['install_type'] = 'ALL_APP_INSTANCES'
  ```

* Make sure these lines are commented out:

  ```
  # sentinel['utility_name'] = 'sidekiq'
  # sentinel['install_type'] = 'NAMED_UTILS'
  ```
	
## Dependencies

You need to install the appropriate Redis client library for your application. See https://redis.io/clients