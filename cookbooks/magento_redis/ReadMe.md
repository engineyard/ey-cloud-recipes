#Magento with Redis on Cloud.EngineYard.com#


##This recipe is to write out the local.xml file for Magento. Steps to get redis and Magento working.##

1. You will need your encryption key to add to the default.rb of this repository for your local.xml to be written properly.
1.Fill in app_name in recipes/default.rb
2.Fill in your encryption key in the key variable in recipes/default.rb
3. Uncomment  the `magento_redis` and `redis`  recipe in the main cookbook `main/recipes/default.rb`.
4. Boot a utility instance named `redis`.
5. Add a (deploy hook)[https://support.cloud.engineyard.com/entries/21016568-Use-Deploy-Hooks] in before_restart.rb of:

```
run “ln -nfs #{config.shared_path}/config/local.xml #{config.release_path}/app/etc/local.xml”
```
