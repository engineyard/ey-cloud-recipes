ey-cloud-recipes/db_client_libs
----------------------------------------
A chef recipe to enable easier customization of database client libraries within a `no_database` environment. 

Why
-----
When using a `no_database` environment currently the AMI version of database libraries is the only version available. Under the `v4` stack this means MySQL 5.5 and Postgres 9.2 by default. In order to interact with a database on an external service (such as RDS) that is running a different version of the database it is sometimes necessary to upgrade these base packages.

*Note* we expect to launch support for database library versioning for `no_database` environments in the near future. Once this is available this will be the preferred method of managing library versions unless multiple concurrent versions are required.

Warnings
--------
- Multiple versions of MySQL client libraries is not supported.
- Designed for use with `no_db` environments only!
- This runs against Application and Utility type instances only; the database instance type is intentionally ignored by this cookbook.
- DO NOT USE this to manage the installed database version of database instances within an environment; this type of upgrade would be unsafe and would be reverted during a master chef run. Please refer to the [Engine Yard Database Version documentation](https://support.cloud.engineyard.com/hc/en-us/articles/205408178-Database-Version-Upgrade-Policies) for additional details on upgrading your database.

Usage
------
To use this customize the configuration options section under `recipes/default.rb` to fit your needs and then include this recipe from `/cookbooks/main/recipes/default.rb`.

About Postgres 9.5 Source Builds
------
Postgres 9.5 source builds are tested against an updated (as of 11/23/2016) Stable-v4 stack only, use on prior versions of the stack may result in inconsistent or unexpected behavior. Before using the Postgres 9.5 source build please validate this build against a Testing environment before implementing in Production. The Postgres 9.5 source build will only install the required tools for client libraries and SHOULD NOT be used for running a Postgres 9.5 server. This cookbook should only be used in an Engine Yard environment that is not using a Postgres database stack.

In the event you need to uninstall the Postgres 9.5 client:

```bash
sudo su -
eselect postgresql set 9.2
cd /data/src/postgresql/9.5.5
make uninstall
make clean
rm -rf /usr/lib/postgresql-9.5
cd ~
rm -rf /data/src/postgresql/9.5.5
```

See Also
--------
`/cookbooks/database_yml_custom`
`/cookbooks/rds`