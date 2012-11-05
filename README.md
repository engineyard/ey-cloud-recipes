ey-cloud-recipes
===============
This is a repository of some basic recipes for EY-Cloud using chef to deploy, setup, and configure common tools for Rails applications.

Installation
============

Follow these steps to use custom deployment recipes with your applications.

* Install the engineyard gem:
  $ gem install engineyard
* Add any custom recipes or tweaks to your copy of these recipes.
* Upload them with: `ey recipes upload -e ENV`, where ENV is the name of your environment in Engine Yard Cloud. This may be different than your Rails environment name.
* Once you have completed these steps, each rebuild will run the your
  recipes after the default Engine Yard recipes have run. When you
  update your recipes, just re-run `ey recipes upload -e ENV`.

Continuous Integration
======================

[![Build Status](https://secure.travis-ci.org/engineyard/ey-cloud-recipes.png?branch=master)](http://travis-ci.org/engineyard/ey-cloud-recipes)
