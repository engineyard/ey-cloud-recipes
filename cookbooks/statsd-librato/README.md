# StatsD with Librato Metrics backend

## Overview

This is a simple chef recipe that installs [StatsD](https://github.com/etsy/statsd) with [Librato Metrics](https://metrics.librato.com) backend.

## Requirements

* An active [Librato Metrics](https://metrics.librato.com/sign_up) account.

## Configuration

* Set your [Librato Metrics](https://metrics.librato.com) credentials in ```cookbooks/recipes/defatult.rb```.

```ruby
librato_email = "you@example.com"
librato_token = "your-token-goes-here"
```

## Enabling

* Enable the recipe in ```cookbooks/main/recipes/default.rb```.

```ruby
# uncomment to include the StatsD-Librato recipe
require_recipe "statsd-librato"
```
