Packages Cookbook for Engine Yard Cloud
=======================================

This cookbook allows you to automate the installation of packages using the attributes in this cookbook.  All packages are unmasked before installing.  Edit attributes/packages.rb and require this cookbook in the main cookbook recipe. 

Example
--------

```
packages( 
    [{:name => "app-misc/wkhtmltopdf-bin", :version => "0.10.0_beta5"},
     {:name => "dev-util/lockrun", :version => "2-r1"}]
)
```
