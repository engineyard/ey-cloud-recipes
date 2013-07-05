ey-cloud-recipes/rds
------------------------------------------------------------------------------

A chef recipe for enabling remote Active Record databases like Amazon's RDS

Dependencies
--------------------------

Requires a running database instance with firewall access configured for
your Engine Yard environment.

Contact our support team if you need additional information about your environment.

Enabling this recipe
---------------------------

* Edit main/recipes/default.rb and comment out the line shown below.
``include_recipe "rds"``
* Alter the rds/attributes/rds.rb file to include your connection
  information.
