Cron Cookbook for Engine Yard Cloud
===================================

Overview
--------
This cookbook automates the installation of cron jobs on Engine Yard Cloud.  The cron jobs are added for the application user on the utility instance name specified for each cron job.  All cron jobs are specified in the attributes file of the cookbook.

Specifics of Usage
------------------
Add your cron jobs as an array of hashes to attributes/cron.rb and uncomment the include_recipe in the main cookbook recipe.  You must specify a name, time, command and instance name.  The time value must be the full string containing minute, hour, day, month and weekday separated by spaces (eg: '* * * * *').

Example Configuration:

```
default[:custom_crons] = [{:name => "test1", :time => "10 * * * *", :command => "echo 'test1'", :instance_name => "cron"},
                          {:name => "test2", :time => "10 1 * * *", :command => "echo 'test2'", :instance_name => "cron"}]
```

Notes
-----
This cookbook will not install cron jobs for the root user, it must be modified if this is required.  Cron jobs are installed for the default application user, typically called deploy.
