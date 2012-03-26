# Delayed Job

This cookbook can serve as a good starting point for setting up Delayed Job support in your application. 
In this recipe your Delayed Job workers will be set up to run under monit. The number of workers will
vary based on the size of the instance running Delayed Job.

** Please Note ** This recipe will setup delayed_job on a single instance environment or on a Utility instance in a cluster environment. If you need delayed_job to run on app instances (if you are not using a Utility instance), you will need to modify the recipe.

## Installation

To install this, you will need to add the following to cookbooks/main/recipes/default.rb:

    require_recipe "delayed_job"
    
Make sure this and any customizations to the recipe are committed to your own fork of this 
repository.

## Restarting your workers

This recipe does NOT restart your workers. The reason for this is that shipping your application and
rebuilding your instances (i.e. running chef) are not always done at the same time. It is best to 
restart your Delayed Job workers when you ship (deploy) your application code. To do this, add a
deploy hook to perform the following:

    sudo "monit -g dj_<app_name> restart all"
    
Make sure to replace <app_name> with the name of your application. You likely want to use the
after_restart hook for this. See our [Deploy Hook](https://engineyard.zendesk.com/entries/21016568-use-deploy-hooks) documentation
for more information on using deploy hooks.

