# Sidekiq

## Introduction

Sidekiq is a simple, efficient message processing for Ruby that uses threads to handle many messages at the same time in the same process. It does not require Rails but will integrate tightly with Rails 3 to make background message processing dead simple.

https://github.com/mperham/sidekiq

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

## Deploy Hooks

You will need to add a deploy hook to restart Sidekiq during deploys. This is needed to ensure the Sidekiq workers are running the latest version of the application.

### Deploy hooks for a dedicated sidekiq instance

If you're running Sidekiq on a utility instance named "sidekiq", use these deploy hooks:

Stop sidekiq at the start of the deploy in `deploy/before_bundle.rb`:

```
on_utilities("sidekiq") do
  worker_count = 1 # change as needed
  (0...worker_count).each do |i|
    sudo "monit stop all -g #{config.app}_sidekiq"
    sudo "/engineyard/bin/sidekiq #{config.app} stop #{config.framework_env} #{i}"
  end
end
```

Then start sidekiq at the end of the deploy in `deploy/after_restart.rb`:

```
on_utilities("sidekiq") do
  sudo "sleep 20s ; monit start all -g #{config.app}_sidekiq"
end
```

### Deploy hooks for sidekiq running from application instances

If you're running Sidekiq on application instances, you can use these deploy hooks:

Stop sidekiq at the start of the deploy in `deploy/before_bundle.rb`:

```
on_app_servers do
  worker_count = 1 # change as needed
  (0...worker_count).each do |i|
    sudo "monit stop all -g #{config.app}_sidekiq"
    sudo "/engineyard/bin/sidekiq #{config.app} stop #{config.framework_env} #{i}"
  end
end
```

Then start sidekiq at the end of the deploy in `deploy/after_restart.rb`:

```
on_app_servers do
  sudo "sleep 20s ; monit start all -g #{config.app}_sidekiq"
end
```

More information regarding deploy hooks can be found here:

https://engineyard.zendesk.com/entries/21016568-use-deploy-hooks
