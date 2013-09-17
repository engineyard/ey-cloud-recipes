# Sidekiq

## Introduction

Sidekiq is a simple, efficient message processing for Ruby that uses threads to handle many messages at the same time in the same process. It does not require Rails but will integrate tightly with Rails 3 to make background message processing dead simple.

https://github.com/mperham/sidekiq

## Requirements

Sidekiq requires that Redis be installed and assumes it is located at `localhost:6379`. To install redis, add the following to your gemfile:

```
gem 'redis'
```

Then to install it into your environment uncomment the following line in `main/recipes/default.rb`:

```
include_recipe "redis"
```

## Usage

First ensure that you have Sidekiq working in your development environment by following the Sidekiq "Getting Started" guide:

https://github.com/mperham/sidekiq/wiki/Getting-Started

To install Sidekiq to your environment, first uncomment the following line in `main/recipes/default.rb`:

```
include_recipe "sidekiq"
```

Next, update the settings in `sidekiq/attributes/default.rb`:

```
sidekiq({
  # Sidekiq will be installed on to application/solo instances,
  # unless a utility name is set, in which case, Sidekiq will
  # only be installed on to a utility instance that matches
  # the name
  :utility_name => 'sidekiq',
  
  # Number of workers (not threads)
  :workers => 1,
  
  # Concurrency
  :concurrency => 25,
  
  # Queues
  :queues => {
    # :queue_name => priority
    :default => 1
  },
  
  # Verbose
  :verbose => false
})
```

By default, the recipe will install Sidekiq on to a utility instance with the name `sidekiq`. If the utility name is `nil` or there is no utility instance matching the name given, Sidekiq will be installed on all application/solo instances.

If you wish to have more than one sidekiq utility instance, you can name them `sidekiq_1`, `sidekiq_2`, etc, given the `utility_name` is set to `sidekiq`.

## Multi Instance Deploys

By default engineyard will install Redis to your DB instance and if you wish to keep it there rather than the preferred method of creating a utility instance you will need to tell Sidekiq where to find Redis. You can do this by adding a Sidekiq intializer in `config/initializers/sidekiq.rb` with the following information:

```
Sidekiq.configure_server do |config|
  config.redis = { :url => "redis://<your_db_server>", :namespace => 'sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://<your_db_server>", :namespace => 'sidekiq' }
end
``` 

More information on setting the location of your server can be found at: 
https://github.com/mperham/sidekiq/wiki/Advanced-Options 

## Deploy Hooks

You will need to add a deploy hook to restart Sidekiq during deploys. Add the following to `deploy/after_restart.rb`:

```
on_utilities("sidekiq") do
  sudo "monit restart all -g <app_name>_sidekiq"
end
```

If Sidekiq is installed on your application instances, rather than a utility instance, you can do the following:

```
on_app_servers do
  sudo "monit restart all -g <app_name>_sidekiq"
end
```

More information regarding deploy hooks can be found here:

https://engineyard.zendesk.com/entries/21016568-use-deploy-hooks
