# eybackup slave

This recipe will move the MySQL database backup cronjob from the database master to the database slave instance.

## Caveats

- Replication is an asynchronous process and this backup will run regardless of whether replication is delayed or has failed. It is important to watch for alerts about replication delay or failure when using this cookbook.
- Replication *can be* non-deterministic; meaning that a statement run against the master can have a different result when run against the replica. When running with `binlog-format=[mixed|row]` (`mixed` is the EY default for MySQL 5.5+) this risk is largely mitigated but still important to be aware of.
