ey-cloud-recipes/database_yml_custom
----------------------------------------

A chef recipe to enable easier customization of an application's database.yml file. This recipe is a modified implementation of the main chef run database.yml generation codebase. It drops a `keep` file that prevents the main run from touching your database.yml in the future. It also uses a different chef resource for placing the file so that it still will regenerate this file in the presence of a `keep` file.

Usage
------

To use this customize the template database.yml.erb to fit your needs and then include this recipe under `/main/recipes/default.rb`. Several cookbooks will depend on the database.yml being generated and up to date, so generally this should be the first custom recipe processed.