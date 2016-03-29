# Custom passenger_monitor4 Custom Chef Recipe for EY Cloud

## Overview

For the Passenger 4 stack, EY Cloud installs a cron job that runs `/engineyard/bin/passenger_monitor4` every minute. This script checks the output of passenger-memory-stats to see if there are any Passenger workers that are using up more than the memory limit. Passenger workers that exceed the memory limit are terminated with `kill -USR1 <pid_of_worker>`; this prevents bloated workers and memory leak issues from bringing down the site.

However, if the worker is busy or is frozen, `kill -USR1 <pid_of_worker>` fails to terminate it. For Passenger versions prior to 4.0.52, this is a known bug, documented in https://github.com/phusion/passenger/wiki/Phusion-Passenger:-Node.js-tutorial#restarting_apps_that_serve_long_running_connections. A workaround in this case is to send a `kill -9 <pid_of_worker>` to the frozen worker.

Immediately sending a `kill -9` is not recommended, however. We want to use it only as a last resort; for normal cases we want to give the worker a chance to clean up. For e-commerce sites that involve transactions we want to avoid `kill -9` as much as possible because it can lead to credit cards getting charged but orders not being flagged for delivery.

This custom chef recipe includes an updated `/engineyard/bin/passenger_monitor4` with a `grace_time` option (-w). When a worker is terminated with `kill -USR1`, we'll verify if the worker process was actually killed. If the worker process is still alive after `grace_time` seconds, we'll send the worker a `kill -9` to really terminate it.

```
NOTE: If a worker has exceeded the memory limit and has been marked for termination, it will be terminated within `grace_time` seconds, even if the worker has recovered and memory consumption has decreased below the limit within the time.
```

Engine Yard is still in the process of evaluating this updated `/engineyard/bin/passenger_monitor4` script. Getting this integrated into the Passenger main chef recipe may take some time. In the meantime, customers who wish to implement the `kill -9` with `grace_time` logic can use this custom chef recipe.


## Installation and Usage

Include the recipe in `cookbooks/main/recipes/default.rb`:

```
include_recipe 'passenger_monitor'
```

Customize the application name, memory limit, and grace_time in `cookbooks/passenger_monitor/attributes/default.rb`.
