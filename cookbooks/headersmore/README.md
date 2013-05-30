ey-headersmore-fingerprinting
===================

https://github.com/agentzh/headers-more-nginx-module
Engine Yard upload/apply recipe steps
-
1. Install the latest Engine Yard CLI
 * To upload an apply a new Chef recipe use the Engine Yard Command Line Interface (CLI). http://www.engineyard.com/products/cloud/features/cli 
2. Login to EY from the EY CLI to connect the application the EY service

Create a recipe tar package
> $ tar zcf recipes.tgz cookbooks/

Upload the recipe to the environment
> $ ey recipes upload -e [Environment name] -f recipes.tgz

If you are unsure of the environment name run
> $ ey environments --all

Apply the recipe to the environment
> $ ey recipes apply -e [Environment name]


Reference(s)
-
Windows EY CLI bug.  Workaround is to tar the package before uploading

https://github.com/engineyard/engineyard/issues/113

Engine Yard Command line interface installation guide can be found in the [ey-cloud-recipes] [1] repository.

[1]: https://github.com/engineyard/ey-cloud-recipes "ey-cloud-recipes"

