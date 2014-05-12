#Magento on Cloud.EngineYard.com#

##This recipe is to write out the local.xml file for Magento.##

1. Fill in `app_name` in `recipes/default.rb`
2. Fill in your encryption key in the `key` variable in `recipes/default.rb`
3. Uncomment the recipe in the main cookbook `main/recipes/default.rb`
4. Add a (deploy hook)[https://support.cloud.engineyard.com/entries/21016568-Use-Deploy-Hooks] in before_restart.rb of:

```
run “ln -nfs #{config.shared_path}/config/local.xml #{config.release_path}/app/etc/local.xml”
```

