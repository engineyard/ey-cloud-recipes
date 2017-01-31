# Delayed Job

This cookbook can serve as a good starting point for setting up Delayed Job support in your application.
In this recipe your Delayed Job workers will be set up to run under monit. The number of workers will
vary based on the size of the instance running Delayed Job.

** Please Note ** This recipe will setup delayed_job on a single instance environment or on a Utility instance in a cluster environment. If you need delayed_job to run on app instances (if you are not using a Utility instance), you will need to modify the recipe.

## Installation

To install this, you will need to add the following to cookbooks/main/recipes/default.rb:

    include_recipe "delayed_job4"

Make sure this and any customizations to the recipe are committed to your own fork of this
repository.

## Customizations

Some common customizations can be made in `attributes/default.rb`.

### Set the worker memory limit

Monit keeps track of your DJ workers and by default, it restarts workers exceeding 300MB of memory.

```ruby
# specify custom memory limit
default['delayed_job4']['worker_memory'] = 400
```

## Restarting your workers

This recipe does NOT restart your workers. The reason for this is that shipping your application and
rebuilding your instances (i.e. running chef) are not always done at the same time. It is best to
restart your Delayed Job workers when you ship (deploy) your application code. You likely want to use the after_restart hook for this.

If you're running DelayedJob on a solo instance or on your app_master, add a deploy hook similar to:

```
on_app_master do
  sudo "monit -g dj_#{config.app} restart all"
end
```

On the other hand, if you're running DelayedJob on a dedicated utility instance, the deploy hook should be like:

```
on_utilities("delayed_job") do
  sudo "monit -g dj_#{config.app} restart all"
end
```

Replace "delayed_job" with the name of your Utility server (default is "delayed_job")

See our [Deploy Hook](https://engineyard.zendesk.com/entries/21016568-use-deploy-hooks) documentation for more information on using deploy hooks.
