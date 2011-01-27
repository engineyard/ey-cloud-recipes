Postgresql Cookbook for AppCloud.  9.0.2
=========

PostgreSQL is a powerful, open source object-relational database system. It has more than 15 years of active development and a proven architecture that has earned it a strong reputation for reliability, data integrity, and correctness. It runs on all major operating systems, including Linux, UNIX (AIX, BSD, HP-UX, SGI IRIX, Mac OS X, Solaris, Tru64), and Windows. It is fully ACID compliant, has full support for foreign keys, joins, views, triggers, and stored procedures (in multiple languages). It includes most SQL:2008 data types, including INTEGER, NUMERIC, BOOLEAN, CHAR, VARCHAR, DATE, INTERVAL, and TIMESTAMP. It also supports storage of binary large objects, including pictures, sounds, or video. It has native programming interfaces for C/C++, Java, .Net, Perl, Python, Ruby, Tcl, ODBC, among others, and [exceptional documentation][1]

Overview
--------

This Cookbook provides the recipes to install/setup postgresql 9.0.2

If you wish to use this in production you should consider customizing mysql's configuration files so it can use the minimal settings possible.  It currently is required to be enabled and running on AppCloud, so **disabling/turning** off **mysql** is **never** an option.

Warning
--------

1. This cookbook **deletes** the [mysql backup][4] crontab if you do not wish this behavior please change/delete/omit it here.

2. This recipe currently offers **zero** replication support.  It may be added in the future.

3. Backups made with this recipe will not likely displayed on the
   Dashboard.  You will need to use S3 in order to retrieve and/or see
   them.

Customization
--------

Ideally it's suggested if you need to make customizations to the configuration to modify /db/postgresql/[postgres_version][3]/custom.conf however you can just modify the attributes file to better suit your personal needs.

Usage
--------

Add the following to main/recipes/default.rb

``require_recipe "postgresql9::default"``

Warranty
--------

This cookbook comes with no warranty of any kind.  Additionally
PostgreSQL is not supported on AppCloud at this time.  **DO NOT** file a
ticket requesting support on this cookbook as it is not supported.

[1]: http://www.postgresql.org/docs/manuals/
[2]: http://www.postgresql.org/
[3]: https://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/postgresql9/attributes/postgresql.rb
[4]: https://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/postgresql9/recipes/eybackup.rb#L28-L32
