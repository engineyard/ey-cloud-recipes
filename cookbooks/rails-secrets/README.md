Don't want to check API keys into version control? No problem!
--------------------------------------------------------------

This Chef recipe will write `secrets.yml` to `/data/<app_name>/shared/config`. During deployment, `secrets.yml` will be symlinked to `/data/<app_name>/current/config`. The end result is you'll have your production `secrets.yml` into your Rails application's `config/` directory.

# Instructions:

1. Populate the templates/default/secrets.yml.erb with your production-ready API keys.
2. Be sure to uncomment `include_recipe "rails-secrets"` from `cookbooks/main/default/recipes.rb` per usual.
3. That's it! Upload (`ey recipes upload -e [env]`) and apply (`ey recipes apply -e [env]`)

# Tips:

You usually want to maintain two version control repositories: one for the application source code and one for the infrastructure source code. The production API keys along with these chef recipes belong to the infrastructure source code.
