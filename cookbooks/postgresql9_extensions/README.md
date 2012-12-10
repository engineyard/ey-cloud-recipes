ey-cloud-recipes/postgresql9_extensions
------------------------------------------------------------------------------

A chef recipe for enabling Postgres extensions (contribs on Postgres 9.0) packages on Engine Yard Cloud.  This recipe defines multiple methods that
can be called from main/recipes/default.rb to enable extensions for a given database.


Dependencies
--------------------------
You need to have an instance running Postgres 9.0 or above to apply these recipes.


Available Extensions
--------------------------
At the moment the following extensions are available.

##auto_explain
###supported versions: 9.0, 9.1, 9.2
This extension provides a means for logging execution plans of slow statements automatically, without having to run EXPLAIN by hand.
This is especially helpful for tracking down un-optimized queries in large applications.
WARNING: Enabling this extension will restart your Postgres service.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_autoexplain "dbname""``

##btree_gin
###supported versions: 9.0, 9.1, 9.2
This extension provides support for indexing common datatypes in GIN

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_btree_gin "dbname""``

##intarray
###supported versions: 9.0, 9.1
The intarray module provides a number of useful functions and operators for manipulating null-free arrays of integers. There is also support for indexed searches using some of the operators.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_intarray "dbname""``


##btree_gist
###supported versions: 9.0, 9.1, 9.2
This extension provides support for indexing common datatypes in GiST

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_btree_gist "dbname""``


##chkpass
###supported versions: 9.0, 9.1, 9.2
This extension implements a data type chkpass that is designed for storing encrypted passwords. Each password is automatically converted
to encrypted form upon entry, and is always stored encrypted.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_chkpass "dbname""``


##citext
###supported versions: 9.0, 9.1, 9.2
The citext module provides a case-insensitive character string type, citext. Essentially, it internally calls lower when comparing values.
Otherwise, it behaves almost exactly like text. (This is great for MySQL compatibility which does text comparisons case-insensitive, by default)

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_citext "dbname""``


##cube
###supported versions: 9.0, 9.1, 9.2
This module implements a data type cube for representing multidimensional cubes.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_cube "dbname""``


##dblink
###supported versions: 9.0, 9.1, 9.2
dblink is a module which supports connections to other PostgreSQL databases from within a database session.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_dblink "dbname""``

##dict_int
###supported versions: 9.0, 9.1, 9.2
dict_int is an example of an add-on dictionary template for full-text search. The motivation for this example dictionary is to control the indexing of integers (signed and unsigned), allowing such numbers to be indexed while preventing excessive growth in the number of unique words, which greatly affects the performance of searching.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_dict_int "dbname""``

##dict_xsyn
###supported versions: 9.0, 9.1, 9.2
dict_xsyn (Extended Synonym Dictionary) is an example of an add-on dictionary template for full-text search. This dictionary type replaces words with groups of their synonyms, and so makes it possible to search for a word using any of its synonyms.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_dict_xsyn "dbname""``


##earthdistance
###supported versions: 9.0, 9.1, 9.2
The earthdistance module provides two different approaches to calculating great circle distances on the surface of the Earth.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_earthdistance "dbname""``


##file_fdw
###supported versions: 9.1, 9.2
The file fdw module provides the foreign-data wrapper, which can be used to access data files in the server's file system. Data files must be in a format that can be read by COPY FROM;

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_file_fdw "dbname""``


##fuzzystrmatch
###supported versions: 9.0, 9.1, 9.2
The fuzzystrmatch module provides several functions to determine similarities and distance between strings.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_fuzzystrmatch "dbname""``


##hstore
###supported versions: 9.0, 9.1, 9.2
This module implements the hstore data type for storing sets of key/value pairs within a single PostgreSQL value. This can be useful
in various scenarios, such as rows with many attributes that are rarely examined, or semi-structured data. Keys and values are simply
text strings.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_hstore "dbname""``

##intarray
###supported versions: 9.0, 9.1, 9.2
The intarray module provides a number of useful functions and operators for manipulating null-free arrays of integers. There is also support for indexed searches using some of the operators.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_intarray "dbname""``


##isn
###supported versions: 9.0, 9.1, 9.2
The isn module provides data types for the following international product numbering standards: EAN13, UPC, ISBN (books), ISMN (music),
and ISSN (serials). Numbers are validated on input, and correctly hyphenated on output.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_isn "dbname""``


##lo
###supported versions: 9.0, 9.1, 9.2
The lo module provides support for managing Large Objects (also called LOs or BLOBs). This includes a data type lo and a trigger lo_manage.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_lo "dbname""``


##ltree
###supported versions: 9.0, 9.1
This module implements a data type ltree for representing labels of data stored in a hierarchical tree-like structure. Extensive facilities
for searching through label trees are provided.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_ltree "dbname""``

##pg_trgm
###supported versions: 9.0, 9.1, 9.2
The pg_trgm module provides GiST and GIN index operator classes that allow you to create an index over a text column for the purpose of very fast similarity searches. These index types support the above-described similarity operators, and additionally support trigram-based index searches for LIKE and ILIKE queries. (These indexes do not support equality nor simple comparison operators, so you may need a regular B-tree index too.).

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_pg_trgm "dbname""``

##pgcrypto
###supported versions: 9.0, 9.1, 9.2
The pgcrypto module provides cryptographic functions for PostgreSQL.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_pgcrypto "dbname""``


##pgrowlocks
###supported versions: 9.0, 9.1, 9.2
The pgrowlocks module provides a function to show row locking information for a specified table.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_pgrowlocks "dbname""``

##pg_stat_statements
###supported versions: 9.2
The pg_stat_statements module provides a means for tracking execution statistics of all SQL statements executed by a server.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_pg_stat_statements "dbname""``

##PostGIS
###supported versions: 9.0, 9.1
This extension adds support for geographic objects. PostGIS "spatially enables" the PostgreSQL server, allowing it to be used as a backend
spatial database for geographic information systems (GIS).

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_postgis "dbname""``


##seg
###supported versions: 9.0, 9.1, 9.2
This module implements a data type seg for representing line segments, or floating point intervals. seg can represent uncertainty in the
interval endpoints, making it especially useful for representing laboratory measurements.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_seg "dbname""``


##sslinfo
###supported versions: 9.0, 9.1
The sslinfo module provides information about the SSL certificate that the current client provided when connecting to PostgreSQL. The module is useless (most functions will return NULL) if the current connection does not use SSL.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_sslinfo "dbname""``

##tablefunc
###supported versions: 9.0, 9.1, 9.2
The tablefunc module includes various functions that return tables (that is, multiple rows). These functions are useful both in their own
right and as examples of how to write C functions that return multiple rows.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_tablefunc "dbname""``


##test_parser
###supported versions: 9.0, 9.1, 9.2
test_parser is an example of a custom parser for full-text search. It doesn't do anything especially useful, but can serve as a starting point for developing your own parser.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_test_parser "dbname""``


##unaccent
###supported versions: 9.0, 9.1
unaccent is a text search dictionary that removes accents (diacritic signs) from lexemes. It's a filtering dictionary, which means its output
is always passed to the next dictionary (if any), unlike the normal behavior of dictionaries. This allows accent-insensitive processing for
full text search.

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_unaccent "dbname""``


##uuid-ossp
###supported versions: 9.0, 9.1, 9.2
The uuid-ossp module provides functions to generate universally unique identifiers (UUIDs) using one of several standard algorithms. There are
also functions to produce certain special UUID constants. (This also requires a separate USE flag when building the postgres binaries that pulls
in another package.)

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_uuid_ossp "dbname""``

##xml2
###supported versions: 9.1, 9.2
The uuid-ossp module provides functions to generate universally unique identifiers (UUIDs) using one of several standard algorithms. There are
also functions to produce certain special UUID constants. (This also requires a separate USE flag when building the postgres binaries that pulls
in another package.)

Enabling this extension:

* Edit main/recipes/default.rb and comment out the line shown below. Replace dbname with the name of the database you want this
extension applied to.

``postgresql9_xml2 "dbname""``


Admin-level Contrib packages
---------------------------------------------
Notes: This module requires a privileged user. Please log in as the postgres user to use the extension

##pg_buffercache
###supported versions: 9.0, 9.2
The pg_buffercache module provides a means for examining what's happening in the shared buffer cache in real time.

Enabling this Module:

* Edit main/recipes/default.rb and comment out the line shown below.

``postgresql9_pg_buffercache "postgres""``


##pg_freespacemap
###supported versions: 9.0, 9.2
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


Credits
--------
Thanks to Erik Jones, Scott Likens, Joel Watson, Edward Muller, and Jayson Vantuyl for their help.
