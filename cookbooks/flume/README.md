# Flume

This recipe installs the client component of [Apache Flume](https://flume.apache.org/).

## Installation

1. Enable the recipe. Edit `main/recipes/default.rb` and add the line:

  ```
  include_recipe 'flume'
  ```

2. Edit `flume/attributes/default.rb`. Specify valid values for these attributes:

  ```
  default['flume']['app_name'] = 'myapp'
  default['flume']['app_logfile'] = 'production.log'
  default['flume']['sink_hostname'] = 'sink.host.name'
  default['flume']['sink_port'] = '9001'
  ``` 
  
  You can also specify the Flume version. The recipe default is 1.7.0 which is the most recent version as of this writing.
  
  ```
  default['flume']['flume_version'] = '1.7.0'
  ```

## Customizations

The recipe uses the AWS instance ID to generate a unique agent ID for each instance. If you want to customize the agent names you need to modify this part of the recipe (`flume/recipes/default.rb`):

  ```
  template conf_file do
    source "flume.conf.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables({
      :agent_id => unique_agent_id,
      :app_name => app_name,
      :log_file => app_logfile,

    })
  end
  ```
