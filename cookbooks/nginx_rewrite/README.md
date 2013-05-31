# Nginx Rewrite

Use this cookbook to add custom rewrites to Nginx configuration. This is really
meant as a jumping-off point for other Nginx configuration so feel free to add
other templates and/or recipes.

## Installation

Use the default recipe to include the recipes that correspond to the type of
configuration that you wish to perform. Then, just include the `nginx_rewrite::default`
in the `main` recipe as usual.

```
include_recipe 'nginx::default'
```

