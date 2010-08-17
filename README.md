ey-cloud-recipes
================
This is a repository of some basic recipes for EY-Cloud using chef to deploy, setup, and configure common tools for Rails applications.


Installation
============

For full instructions on creating and deploying chef customizations, see [Custom Chef Recipes](http://docs.engineyard.com/appcloud/howtos/customizations/custom-chef-recipes) on the Engine Yard docs site.

* First install the engineyard gem.
 `sudo gem install engineyard`
* Fork this repository.
* Clone the repository from your Github account onto your local development machine. Be sure you do not put this inside of your app repository as nested repositories are not supported in git.
 `git clone git@github.com:<github username>/ey-cloud-recipes.git`

This local copy of your ey-cloud-recipes repository will be the folder you work in when writing custom recipes for your environment.
* Add any custom recipes or tweeks to the base recipes of your own and commit them to HEAD.
* Upload them with: 
 `ey recipes upload -e <environment name>` # where ENV is the name of your environment in Engine Yard Cloud. This may be different than your Rails environment name.
* Then run your recipes with:
 `ey recipes apply -e <environment name>`
