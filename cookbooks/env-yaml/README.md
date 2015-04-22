Don't want to check environment variables into version control? No problem!
--------------------------------------------------------------

This Chef recipe will write env.yml to your Rails app's config/ directory on Engine Yard Cloud.

# Instructions:

1. Populate the shared or default variable names and values in the `defaults`
   hash in recipes/default.rb
2. Populate the environment-specific variable names and values in the desired
   named hash in the `namespaces` hash in recipes/default.rv.  It is most
   common to use the Rails.env name for these namespaces.
3. Be sure to uncomment `include_recipe env-yaml"` from
   `cookbooks/main/default/recipes.rb` per usual.
4. That's it! Upload (`ey recipes upload -e [env]`) and apply (`ey recipes
   apply -e [env]`)

# Accessing the file from your application

There are two recommended ways of accessing the contents of this file.

### Use SettingLogic gem
The preferred way is to use settinglogic gem, and create a model called
Settings (or whatever you want) as per the instructions found here: https://github.com/settingslogic/settingslogic
This keeps the ENV variable unpoluted, but you'll need to update your app to
use the Settings singleton instead if your app currently uses ENV directly.

### Inject values into ENV
If you are used to finding these values in the ENV variable and would prefer
to keep using it that way (or have subprocesses that expect to find values in
ENV), then you can add the following to config/application.rb before the Rails
application class is defined (or the initializer of your choice)

    if File.exists?(File.expand_path('../env.yml', __FILE__))
      config = YAML.load(File.read(File.expand_path('../env.yml', __FILE__)))
      config.fetch(Rails.env, {}).each do |key, value|
        ENV[key] = value.to_s unless value.kind_of? Hash
      end
    end

Check in these changes to your application repo, then deploy your app.

# Note:

By default, it creates a file named env.yml in
/data/&lt;appname&gt;/shared/config directory -- if you already have a file by
that name, or you want to duplicate this recipe for creating another yaml
file, you can change this name in the basename variable.  Just make sure you
also change the name in the deploy hook and YAML.load or SettingsLogic
command.
