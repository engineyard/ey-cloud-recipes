ey-cloud-recipes/swap
----------------------------------------

A chef recipe to assist with moving the default swap from an 8GB EBS GP2 volume to a different volume (default: /mnt/swapfile). We don't endorse or encourage reliance on swap but realize that for some applications swap activity may be difficult or impossible to entirely prevent. The default setup for swap on Engine Yard instances is designed to meet the needs of most of our customer base, but have encountered cases where something else was needed; this cookbook is designed to help meet those special requirements. Prior to using this cookbook we encourage you to try and eliminate your swap activity through any reasonable means.

Why
------
GP2 volumes provide a baseline performance of 3 IO Operations per second per GB (3IOPs/GB) with a capability to burst to 3,000 IOPs for ~5 million IOs; for smaller volumes the minimum IOPs level is 100 IOPs (as of 5/26/2016). The Swap volume size is not designed to be configurable as larger volumes add a lot of configuration time, additional cost, and add unnecessary complexity that does not add value for the majority of cases. The /mnt volume for each instance can be sized when creating an instance (default: 25GB). For cases where the /mnt volume is larger than 34GB and swap is active enough to consume the volume burst IO credits regularly there may be a performance advantage to having the swap located on the /mnt volume instead of an independent swap partition.

Warnings
--------
- Databases use the /mnt partition as a staging area for database backups and database temp files. If this volume is already very active from that activity, migrating the swap file here as well may decrease rather than increase performance.
- Relying on swap is not recommended practice.
- YMMV.

Usage
------

To use this customize the configuration options section under `recipes/default.rb` to fit your needs and then include this recipe under `/main/recipes/default.rb`. In order for this cookbook to run on a given instance your /mnt volume size must be larger than 33GB.

The default settings will work on all instance types except `m1.small` and `c1.medium` which requires a change documented in the recipe. This will create an 8GB swapfile on the /mnt volume at `/mnt/swapfile` and remove the existing default swapfile. The 8GB EBS volume that hosted the original swapfile will remain attached to the instance and cannot be removed currently.