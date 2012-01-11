ey-cloud-recipes/postgresql9_contrib
------------------------------------------------------------------------------

A chef recipe for enabling Postgres contrib packages on Engine Yard AppCloud.  This recipe defines multiple methods that 
can be called from main/recipes/default.rb to enable extensions for a given database.


Dependencies
--------------------------
You need to have a running Postgres 9 instance to apply these recipes.


Available Extensions 
--------------------------
At the moment the following extensions are available. See http://www.postgresql.org/docs/9.0/static/contrib.html for more information.

##auto_explain
This extension provides a means for logging execution plans of slow statements automatically, without having to run EXPLAIN by hand. 
This is especially helpful for tracking down un-optimized queries in large applications. 
WARNING: Enabling this extension will restart your Postgres service. 

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to. 	

``postgresql9_autoexplain "dbname""``	


##chkpass
This extension implements a data type chkpass that is designed for storing encrypted passwords. Each password is automatically converted 
to encrypted form upon entry, and is always stored encrypted.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_chkpass "dbname""``


##citext
The citext module provides a case-insensitive character string type, citext. Essentially, it internally calls lower when comparing values. 
Otherwise, it behaves almost exactly like text. (This is great for MySQL compatibility which does text comparisons case-insensitive, by default)

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_citext "dbname""``


##cube
This module implements a data type cube for representing multidimensional cubes.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_cube "dbname""``


##dblink
dblink is a module which supports connections to other PostgreSQL databases from within a database session.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_dblink "dbname""``


##earthdistance
The earthdistance module provides two different approaches to calculating great circle distances on the surface of the Earth.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_earthdistance "dbname""``


##fuzzystrmatch
The fuzzystrmatch module provides several functions to determine similarities and distance between strings.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_fuzzystrmatch "dbname""``


##hstore
This module implements the hstore data type for storing sets of key/value pairs within a single PostgreSQL value. This can be useful 
in various scenarios, such as rows with many attributes that are rarely examined, or semi-structured data. Keys and values are simply 
text strings.	

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_hstore "dbname""``


##intagg
The intarray module provides a number of useful functions and operators for manipulating one-dimensional arrays of integers. There is 
also support for indexed searches using some of the operators.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_intagg "dbname""``


##isn
The isn module provides data types for the following international product numbering standards: EAN13, UPC, ISBN (books), ISMN (music), 
and ISSN (serials). Numbers are validated on input, and correctly hyphenated on output.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_isn "dbname""``


##lo
The lo module provides support for managing Large Objects (also called LOs or BLOBs). This includes a data type lo and a trigger lo_manage.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_lo "dbname""``


##ltree
This module implements a data type ltree for representing labels of data stored in a hierarchical tree-like structure. Extensive facilities 
for searching through label trees are provided.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_ltree "dbname""``


##pgcrypto
The pgcrypto module provides cryptographic functions for PostgreSQL.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_pgcrypto "dbname""``


##pgrowlocks
The pgrowlocks module provides a function to show row locking information for a specified table.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_pgrowlocks "dbname""``


##PostGIS
This extension adds support for geographic objects. PostGIS "spatially enables" the PostgreSQL server, allowing it to be used as a backend 
spatial database for geographic information systems (GIS).

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_postgis "dbname""``


##seg
This module implements a data type seg for representing line segments, or floating point intervals. seg can represent uncertainty in the 
interval endpoints, making it especially useful for representing laboratory measurements.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_seg "dbname""``


##tablefunc
The tablefunc module includes various functions that return tables (that is, multiple rows). These functions are useful both in their own 
right and as examples of how to write C functions that return multiple rows.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_tablefunc "dbname""``


##unaccent
unaccent is a text search dictionary that removes accents (diacritic signs) from lexemes. It's a filtering dictionary, which means its output 
is always passed to the next dictionary (if any), unlike the normal behavior of dictionaries. This allows accent-insensitive processing for 
full text search.

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_unaccent "dbname""``


##uuid-ossp
The uuid-ossp module provides functions to generate universally unique identifiers (UUIDs) using one of several standard algorithms. There are 
also functions to produce certain special UUID constants. (This also requires a separate USE flag when building the postgres binaries that pulls 
in another package.)

Enabling this extension: 

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this 
extension applied to.

``postgresql9_uuid_ossp "dbname""``


Admin-level Contrib packages 
---------------------------------------------
Notes: This module requires a privileged user. Please log in as the postgres user to use the extension

##pg_buffercache
The pg_buffercache module provides a means for examining what's happening in the shared buffer cache in real time. 

Enabling this Module: 

* Edit main/recipes/default.rb and comment out the line shown below. 

``postgresql9_pg_buffercache "postgres""``


##pg_freespacemap
The pg_freespacemap module provides a means for examining the free space map (FSM). It provides a function called pg_freespace, 
or two overloaded functions, to be precise. The functions show the value recorded in the free space map for a given page, or for all 
pages in the relation. 

Enabling this Module: 

* Edit main/recipes/default.rb and comment out the line shown below. 

``postgresql9_pg_freespacemap "postgres""``

Note: This module requires a priviledged user. Please log in as the postgres user to use the pg_freespacemap module



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
