# Custom Node.js

This cookbook can serve as a good starting point for upgrading Node.js in your instances.
Specifically, it gives you the tools in order to install versions of nodejs that are not present in the portage tree.

** Please Note ** This recipe will setup the selected version of Node.js (the version specified in attributes) in all instances by default. If you need custom_nodejs to run only in app/util, you will need to modify the recipe. Also, since this recipe is practically installing node versions not officially supported by portage, integration is not guaranteed.  

## Installation

To install this, you will need to add the following to cookbooks/main/recipes/default.rb:

    include_recipe "custom_nodejs"

Make sure this and any customizations to the recipe are committed to your own fork of this
repository.

## Customizations

The version of Node.js to be install can be set in `attributes/default.rb`. Please avoid installing the same versions already existing in portage (check via `eix nodejs`). You can check the available versions [here](https://nodejs.org/en/download/releases/). 

