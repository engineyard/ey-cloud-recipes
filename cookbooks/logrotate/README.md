= DESCRIPTION:

Logrotate cookbook, primarily this cookbook is only setup currently to rotate nginx logs every hour if they exceed 100 Megabytes of size in /var/log/engineyard/nginx/*.log

= USAGE:

uncomment / add to main/recipes/default.rb

include_recipe "logrotate"

= NOTES:

This cookbook can be easily updated / expanded to beyond it's original use an intent.
