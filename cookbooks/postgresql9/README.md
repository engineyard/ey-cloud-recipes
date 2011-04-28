Postgresql Cookbook for AppCloud.  9.0.2
=========

PostgreSQL is a powerful, open source object-relational database system. It has more than 15 years of active development and a proven architecture that has earned it a strong reputation for reliability, data integrity, and correctness. It runs on all major operating systems, including Linux, UNIX (AIX, BSD, HP-UX, SGI IRIX, Mac OS X, Solaris, Tru64), and Windows. It is fully ACID compliant, has full support for foreign keys, joins, views, triggers, and stored procedures (in multiple languages). It includes most SQL:2008 data types, including INTEGER, NUMERIC, BOOLEAN, CHAR, VARCHAR, DATE, INTERVAL, and TIMESTAMP. It also supports storage of binary large objects, including pictures, sounds, or video. It has native programming interfaces for C/C++, Java, .Net, Perl, Python, Ruby, Tcl, ODBC, among others, and [exceptional documentation][1]

Overview
--------

This Cookbook provides the recipes to install/setup postgresql 9.0.2

Warning
--------

1. This cookbook **deletes** the [mysql backup][4] crontab if you do not wish this behavior please change/delete/omit it here.

2. Backups made with this recipe will not likely displayed on the
   Dashboard, you will need to use S3 to retrieve backups and display
   them.

3. We slim MySQL down to a very small process which should not exceed
   256M.  This makes MySQL unusable for any real usage; however MySQL is
   still required to be running for AppCloud automation to work so we
   leave it running.

Replication
--------

Currently i'm abusing the mysql replication process  However due to how replication works with postgresql this should have no negative side effects however it is possible this could lead to problems in the future.  We will update this logic when it's possible to do this properly.

Customization
--------

Ideally it's suggested if you need to make customizations to the configuration to modify /db/postgresql/[postgres_version][3]/custom.conf however you can just modify the attributes file to better suit your personal needs.

Usage
--------

Remove old postgres recipe from your ey-cloud-recipes fork if you haven't already,

``rm -rf cookbooks/postgres*``  

Now add it to main/recipes/default.rb like the following,  

``require_recipe "postgresql9::default"``

Cruft
--------

Pardon any cruft in this cookbook, there may be bits not used and bits that never did anything.  As a whole this recipe works as described however there is some more cleaning to be done.

Warranty
--------

Currently Postgresql is not supported on AppCloud.  This recipe is unsupported at this time, it should work 'as is'.  I currently do use some features that are not properly exposed which may in the future break things, I will try and keep this up to date if this happens.

[1]: http://www.postgresql.org/docs/manuals/
[2]: http://www.postgresql.org/
[3]: http://github.com/damm/ey-postgresql9/blob/master/postgres/attributes/postgresql.rb
[4]: http://github.com/damm/ey-postgresql9/blob/master/postgres/recipes/eybackup.rb#L28-L32
