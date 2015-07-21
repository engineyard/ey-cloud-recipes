# [nodejs-cookbook](https://github.com/redguide/nodejs)
[![CK Version](http://img.shields.io/cookbook/v/nodejs.svg)](https://supermarket.getchef.com/cookbooks/nodejs) [![Build Status](https://img.shields.io/travis/redguide/nodejs.svg)](https://travis-ci.org/redguide/nodejs)

## DESCRIPTION

Installs Node.js and manage npm

## USAGE

Include the nodejs recipe to install node on your system based on the default installation method:
```chef
include_recipe "nodejs"
```
Installation method can be customized with attribute `node['nodejs']['install_method']`

### Install methods

#### Package

Install node from packages:

```chef
node['nodejs']['install_method'] = 'package' # Not necessary because it's the default
include_recipe "nodejs"
# Or
include_recipe "nodejs::nodejs_from_package"
```
Note that only apt (Ubuntu, Debian) appears to have up to date packages available. 
Centos, RHEL, etc are non-functional (try `nodejs_from_binary` for those).

#### Binary

Install node from official prebuilt binaries:
```chef
node['nodejs']['install_method'] = 'binary'
include_recipe "nodejs"
# Or
include_recipe "nodejs::nodejs_from_binary"
```

#### Source

Install node from sources:
```chef
node['nodejs']['install_method'] = 'source'
include_recipe "nodejs"
# Or
include_recipe "nodejs::nodejs_from_source"
```

## NPM

Npm is included in nodejs installs by default.
By default, we are using it and call it `embedded`.
Adding recipe `nodejs::npm` assure you to have npm installed and let you choose install method with `node['nodejs']['npm']['install_method']`
```chef
include_recipe "nodejs::npm"
```
_Warning:_ This recipe will include the `nodejs` recipe, which by default includes `nodejs::nodejs_from_package` if you did not set `node['nodejs']['install_method']`.

## LWRP

### nodejs_npm

`nodejs_npm` let you install npm packages from various sources:
* npm registry:
 * name: `attribute :package`
 * version: `attribute :version` (optionnal)
* url: `attribute :url`
 * for git use `git://{your_repo}`
* from a json (packages.json by default): `attribute :json`
 * use `true` for default
 * use a `String` to specify json file
 
Packages can be installed globally (by default) or in a directory (by using `attribute :path`)

You can append more specific options to npm command with `attribute :options` array :  
 * use an array of options (w/ dash), they will be added to npm call.
 * ex: `['--production','--force']` or `['--force-latest']`
 
This LWRP try to use npm bare as much as possible (no custom wrapper).

#### [Examples](test/cookbooks/nodejs_test/recipes/npm.rb)

## AUTHORS

* Marius Ducea (marius@promethost.com)
* Nathan L Smith (nlloyds@gmail.com)
* Guilhem Lettron (guilhem@lettron.fr)
* Barthelemy Vessemont (bvessemont@gmail.com)
