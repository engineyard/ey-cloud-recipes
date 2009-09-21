ey-cloud-recipes
===============
This is a repository of some basic recipes for EY-Cloud using chef to deploy, setup, and configure common tools for Rails applications.


Installation
============

Follow these steps to use custom deployment recipes with your applications.

* Download your ey-cloud.yml file from your EY Cloud [Extras](http://cloud.engineyard.com/extras) page and put it in your HOME directory ~/.ey-cloud.yml
* Install the required gems:
  sudo gem install rest-client aws-s3
  sudo gem install ey-flex --source http://gems.engineyard.com # make sure you are using the lastest version
* Add any custom recipes or tweeks to the base recipes of your own and commit them to HEAD.
* Upload them with: ey-recipes --upload ENV # where ENV is the name of your environment in Engine Yard Cloud. This may be different than your Rails environment name.
* Once you have completed these steps, each deployment will run the latest version of your recipes after the default Engine Yard recipes have run. When you update your recipes, just re-run the ey-recipes --upload ENV task.



[eysolo]: http://www.engineyard.com/solo
[cloud]: https://cloud.engineyard.com/extras
