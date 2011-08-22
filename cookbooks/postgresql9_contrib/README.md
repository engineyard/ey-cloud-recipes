ey-cloud-recipes/postgresql9_contrib
--------

A chef recipe for enabling Postgres contrib packages on Engine Yard AppCloud.  This recipe defines multiple methods that can be called from main/recipes/default.rb to enable extensions for given databases

It makes a few assumptions:

  * You will 

The only thing (currently) lacking from this recipe is 

Dependencies
--------

None so far.


Using it
--------

  * add the following to main/recipes/default.rb,

``postgresql9_postgis "dbname""``  

  * Upload recipes to your environment

``ey recipes upload -e <environment>``  

  * Apply recipes to your environment
	``ey recipes apply -e <environment>``

Caveats
--------



TODO
--------



Known Bugs
--------


Warranty
--------

This cookbook is provided as is, there is no offer of support for this
recipe by Engine Yard in any capacity.  If you find bugs, please open an
issue and submit a pull request.

Credits
--------

Thanks to Erik Jones, Scott Likens, Joel Watson, and Jayson Vantuyl for their help. I will
continue to attempt to add more to it and accept patches/pulls.

