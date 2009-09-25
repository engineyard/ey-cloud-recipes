ey-postgrecipes
===============

A chef recipe for enabling postgres on [solo][eysolo].  Data is persisted to
EBS so your db naturally restores if you grow/shrink your instances.  An
upcoming release of the ey-flex-gem will be delivering support for native
eybackup features.

It's almost ready for everyone, it's working wonderfully for us right now.

Dependencies
============
    % sudo gem install ey-flex

You'll also need your ey-cloud.yml credentials from ey's [cloud][cloud].


Using it
========
    mbp:: p/ey-postgrecipes » ey-recipes 
    Current Environments:
    env: compton  running instances: 1
      instance_ids: ["i-5eu8x492"]
    mbp:: p/ey-postgrecipes » ey-recipes --update compton

Issues
=======
Under rails you'll see an error like this.

    Please install the postgres adapter: `gem install
    activerecord-postgres-adapter` (no such file to load --
    active_record/connection_adapters/postgres_adapter)

You'll need to modify cookbooks/postgres/templates/default/database.yml.erb and
set the adapter to 'postgresql' instead of 'postgres'.  Just fork the project
and do yo thang.

[eysolo]: http://www.engineyard.com/solo
[cloud]: https://cloud.engineyard.com/extras
