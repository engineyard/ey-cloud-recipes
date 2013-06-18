Don't want to check API keys into version control? No problem!
--------------------------------------------------------------

This Chef recipe will write api-keys.yml to your Rails app's config/ directory on Engine Yard Cloud.

# Instructions:

1. Populate the templates/default/api-keys.yml.erb with your production-ready API keys.
2. Have your Rails app check locally at `config/api-keys.yml` for all API keys that it needs.
3. Be sure to uncomment `include_recipe "api-keys-yml"` from `cookbooks/main/default/recipes.rb` per usual.
4. That's it! Upload (`ey recipes upload -e [env]`) and apply (`ey recipes apply -e [env]`)

Optional: 
If you need a config/api-keys.yml locally for test/dev, create the file as needed. 

# Tips:

Obviously you'd want to avoid checking these cookbooks or a local api-keys.yml into version control. 

Because you won't be checking config/api-keys.yml into version control, new developers who clone the repository might have trouble running locally without that file in place. We recommend making a file called config/api-keys.yml.example that has fake credentials that are used in your testing suite. That way when the repo is cloned, a developer simply needs to run `cp api-keys.yml.example api-keys.yml` and they're good to go. 