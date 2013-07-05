# EY Cloud Recipes

[![Build Status](https://secure.travis-ci.org/engineyard/ey-cloud-recipes.png)](http://travis-ci.org/engineyard/ey-cloud-recipes)

## Introduction

The ey-cloud-recipes repository is a collection of [chef](http://wiki.opscode.com/display/chef/Home) cookbooks that setup and configure commonly used tools for ruby applications, as well as cookbooks that can be used to modify parts of the EY Cloud environment.

**Note: These cookbooks are for reference, and do not indicate a supported status.**

## Quick Start Guide

1. Clone this repository
2. Uncomment the recipes that you wish to use in `cookbooks/main/recipes/default.rb`
3. Make any changes that are mentioned in the individual cookbook's `readme.md` file
4. Install the [engineyard](https://github.com/engineyard/engineyard) gem, if you haven't already (`gem install engineyard`).
5. Upload your recipes to EY Cloud using `ey recipes upload -e ENVIRONMENT`, where `ENVIRONMENT` is the name of your environment.
6. Run your recipes on the environment using `ey recipes apply -e ENVIRONMENT`

## EY Cloud Documentation

A full guide to customizing your EY Cloud environment with chef can be found at the following URL:

- https://support.cloud.engineyard.com/entries/21009867-Customize-Your-Environment-with-Chef-Recipes

The following pages may also be of some use:

- https://support.cloud.engineyard.com/entries/21009927-engine-yard-cli-user-guide#eyrecipesapply
- https://support.cloud.engineyard.com/entries/21406977-custom-chef-recipes-examples-best-practices

## Chef Documentation

Below is a list of chef documentation pages that you may find useful, especially if you are just getting started with chef:

- http://docs.opscode.com/chef_solo.html
- http://docs.opscode.com/chef/chef_overview.html
- http://docs.opscode.com/chef/resources.html
- http://docs.opscode.com/chef/essentials_cookbook_attribute_files.html

There is also a great RailsCast on the use of chef-solo (however, it is only available to RailsCasts Pro subscribers):

- http://railscasts.com/episodes/339-chef-solo-basics

## FAQ

### What version of chef is used on EY Cloud?

We use [chef-solo](http://docs.opscode.com/chef_solo.html) on EY Cloud. If you are using the new Gentoo 2012 stack, then you will be using chef 10. If you are running on an older version of the stack, then it will be chef 0.6.

### How can I view the recipes uploaded to an environment?

You can view the recipes that have been uploaded to an environment in two ways:

- You can download the recipes for an environment using `ey recipes download`, which will be downloaded into a directory called `cookbooks` in the current directory.
- You can login to any of your instances and navigate to `/etc/chef-custom/recipes/cookbooks`, which is the location that your custom cookbooks are located.

### An error occurred during my chef run, where can I find the logs?

Next to each instance, on the [dashboard](https://cloud.engineyard.com/), there are two links entitled "Base" and "Custom", the "Custom" link will take you to the chef log for the last run of your custom chef recipes, for that instance.

The chef log for your custom recipes is also located on each instance at `/var/log/chef.custom.log`
