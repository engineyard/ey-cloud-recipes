ey-cloud-recipes/flexibackup
----------------------------------------
A chef recipe to install and configure the flexibackup MySQL backup tool. 

Why
-----
Flexibackup is designed around allowing more flexibility in how MySQL databases are backed up and restored. This tool uses existing `mysqldump` functionality but allows for the creation of `--tab` delimited backups and options to only backup or restore specific tables.

Usage
------
The flexibackup tool is installed under /db/flexibackup, run `/db/flexibackup/flexibackup --help` for additional usage details. Modify the `Configuration options` section of recipes/default.rb as needed.
