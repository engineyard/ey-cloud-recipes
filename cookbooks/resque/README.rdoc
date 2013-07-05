= DESCRIPTION:

Resque is a Redis-backed Ruby library for creating background jobs, placing those jobs on multiple queues, and processing them later.

= USAGE: 

add include_recipe "resque" to main/recipes/default.rb

= NOTES:

I setup a basic size for the resque workers based on the instance_type, if you need more or less workers please modify the recipe itself.  

Additionally I setup the QUEUE=* so if you need to be more specific on the queues you want worked obviously you can tailor this better, or if you prefer write the file yourself and that way the 'EBS' would know which queue you want to run.
