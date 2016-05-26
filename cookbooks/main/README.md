Main Recipe for EngineYard EY Cloud
=========

This is the entry point for EY Cloud custom chef recipes.

```

### Chef 10, Chef 0.6

To enable a recipe, add `include_recipe '<recipe_name>'` to `main/recipes/default.rb`. For example, to enable the `redis` recipe:

```
include_recipe 'redis'
```

### Chef 12

To enable a recipe, in addition to including the recipe in `main/recipes/default.rb`, you also need to add it as a dependency in `main/metadata.rb`. For example, to enable the `redis` recipe:

```
if Chef::VERSION[/^12/]
  depends 'redis'
end
