ey-cloud-recipes/postgresql_maintenance
------------------------------------------------------------------------------

A chef recipe for enabling a maintenance tasks for Postgresql on Engine Yard Cloud. Currently this recipe consists vacuumdb tasks for a database that can be customized to a specific application need. This recipe may be updated in the future to support additional maintenance options.


Dependencies
--------------------------

These recipes are designed and build for use with Postgres 9.0 or above.


VacuumDB
--------------------------

Your database is configured by default with autovacuum but minimizes resources to this process to prevent it from negatively impacting application performance. Databases that see regular heavy load, or lots of writes and deletes may need regular manual vacuum operations globally or for specific tables. We recommend scheduling these heavier operations for a time that is compatible with your application needs. Configure the cron times and dates in ./recipes/default.rb as necessary.

Additional information on vacuum operation can be found in the PostgreSQL Manual: http://www.postgresql.org/docs/9.3/static/sql-vacuum.html.