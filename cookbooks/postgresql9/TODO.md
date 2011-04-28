TODO
------

Make snapshot of volume using fog calls, and use the proper select pg_start_backup('clone',true).  Currently we abuse MySQL's link, it works as this is WAL logs but if it was not, it could pose problems.
