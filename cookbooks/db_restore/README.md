Database Restore Cookbook for Engine Yard Cloud
------------------------------------------------

This cookbook creates a config file and wrapper script to be used with the eybackup tool to provide an easier way to restore a database backup from one environment into another environment.

To start, set the attributes in attributes/db_restore.rb:

```
default[:db_restore] = {
  :app_name => "",  # The application name as it appears in the Engine Yard dashboard
  :db_type => "",   # mysql or postgresql
  :source_environment_name => "", # The name of the environment containing the backup that you want to restore
  :backup_bucket => "" # See the README.md for information on obtaining this value
}
```

You can obtain the backup bucket by connecting via SSH to the environment containing the database that you want to restore and running the following command, note that the filename will change depending on which relational database you are using:

```
~ # cat /etc/.postgresql.backups.yml | grep bucket
:backup_bucket: ey-backup-5c8dbfba94b9
```

Once the cookbook attributes are set, make sure you uncomment the include_recipe line in cookbooks/main/recipes/default.rb

After you upload and apply the Chef cookbooks, there will be an eybackup config file in place and a wrapper script for using it.  Running the command `sudo /home/deploy/download_backup.sh` will download the latest dump and provide a command for you to import the dump.
