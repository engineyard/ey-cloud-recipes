ey-cloud-recipes/postgresql9_contrib
------------------------------------------------------------------------------

A chef recipe for enabling Postgres contrib packages on Engine Yard AppCloud.  This recipe defines multiple methods that 
can be called from main/recipes/default.rb to enable extensions for a given database.


Dependencies
--------------------------
You need to have a running Postgres 9 instance to apply these recipes.


Extensions Available 
--------------------------
At the moment the following extensions are available. See http://www.postgresql.org/docs/9.0/static/contrib.html for more information.

	auto_explain
	~~~~~~~~~~~~~~~~~~~~~~~~~~~
	This module provides a means for logging execution plans of slow statements automatically, without having to run EXPLAIN by hand. 
	This is especially helpful for tracking down un-optimized queries in large applications. 
	WARNING: Enabling this extension will restart your Postgres service. 

	Enabling this Module: 

	* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
	extension applied to. 
	
	``postgresql9_autoexplain "dbname""``

	To disable, simply comment out the postgresql9_autoexplain line


	chkpass
	~~~~~~~~~~~~~~~~~~~~~~~~~~~
	This module implements a data type chkpass that is designed for storing encrypted passwords. Each password is automatically converted 
	to encrypted form upon entry, and is always stored encrypted.

	Enabling this Module: 

	* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
	extension applied to.
	``postgresql9_chkpass "dbname""``

	To disable, simply comment out the postgresql9_chkpass line


	PostGIS
	~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
	This module adds support for geographic objects. PostGIS "spatially enables" the PostgreSQL server, allowing it to be used as a backend 
	spatial database for geographic information systems (GIS).

	Enabling this Module: 

	* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
	extension applied to.
	``postgresql9_postgis "dbname""``

	To disable, simply comment out the postgresql9_postgis line



Uploading this recipe
--------------------------

1. Edit main/recipes/default.rb to enable or disable extensions as shown above. 

2. Upload recipes to your environment

``ey recipes upload -e <environment>``  

3. Apply recipes to your environment

``ey recipes apply -e <environment>``


TO-DO
--------
This cookbook is work in progress and will be expanded to incorporate additional extensions.


Caveats
--------
None so far. 


Known Bugs
--------
None so far. 


Warranty
--------
This cookbook is provided as is, there is no offer of support for this
recipe by Engine Yard in any capacity.  If you find bugs, please open an
issue and submit a pull request.


Credits
--------
Thanks to Erik Jones, Scott Likens, Joel Watson, Edward Muller, and Jayson Vantuyl for their help. 
