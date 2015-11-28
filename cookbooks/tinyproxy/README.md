# Tinyproxy Custom Chef Recipe for EYCloud

## Overview

In some cases third parties will allow only whitelisted IPs to connect to their services. This is usually the case with payment gateways, but may be applicable other cases as well.

Attaching EIPs to the instances that need to be whitelisted is an option but may not always be feasible if there are many instances need to connect and the third party has limited the whitelist to only a few IPs.

If you connect to the third party via HTTP then you can run tinyproxy on one instance (usually app_master, but can also be any util instance with an EIP), then proxy the HTTP requests through tinyproxy. This custom chef recipe will let you install tinyproxy on app_master. It can also be easily modified to run tinyproxy from a named utility instance instead.

## Installation

1. Add the following to your `main/recipes/default.rb`:

  ```
  include_recipe "redis"
  ```

2. Specify the application name and port by modifying lines 2-3 of `tinyproxy/recipes/default.rb`:

  ```
  app_name = "YOUR_APP_NAME_HERE"
  proxy_port = 8888
  ```

3. If you plan to run tinyproxy from a named utility instance, modify `tinyproxy/recipes/default.rb` with these changes:

* Specify the utility instance name on line 4 (defaults to `tinyproxy`)
* Uncomment lines 9-10:

```
tinyproxy_instance = node[:engineyard][:environment][:instances].find { |instance| instance[:name] == tinyproxy_instance_name }
if (node[:instance_role] == 'util') && (node[:name] == tinyproxy_instance_name)
```

* Comment out lines 13-14:

```
# tinyproxy_instance = node[:engineyard][:environment][:instances].find { |instance| instance[:role] == 'app_master' }
# if node[:instance_role] == 'app_master'
```

## Usage

This custom chef recipe creates `/data/app_name/shared/config/tinyproxy.yml`, which is automatically linked to `/data/app_name/current/config/tinyproxy.yml`.

### Rails Usage

You can parse the tinyproxy.yml file to determine the hostname and port used by tinyproxy like this:

```
yaml_file = File.join(Rails.root || current_path, 'config', 'tinyproxy.yml')
tinyproxy_config = YAML::load(ERB.new(IO.read(yaml_file)).result)
tinyproxy_host = tinyproxy_config[:hostname] || 'localhost'
tinyproxy_port = tinyproxy_config[:port] || '8888'
```

Once that is done, you can call Net::HTTP like this:

```
Net::HTTP.new(target_url, nil, tinyproxy_host, tinyproxy_port).start { |http|
  http.get(target_url, '')
}
```

## Test Cases

This custom chef recipe has been verified using these test cases:

```
A. Install tinyproxy on app_master
  A1. tinyproxy should be running on app_master
  A2. tinyproxy should not be running on any other instance
  A3. /data/app_name/shared/config/tinyproxy.yml should have the correct host and port settings
  A4. Initiate a takeover. tinyproxy should be running on the new app_master

B. Install tinyproxy on util instance named tinyproxy
  B1. tinyproxy should be running on tinyproxy
  B2. tinyproxy should not be running on any other instance
  B3. /data/app_name/shared/config/tinyproxy.yml should have the correct host and port settings
```

If you encounter a problem, please open a Github issue and metion which of these cases failed.
