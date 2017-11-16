#
# Cookbook Name:: sidekiq
# Attrbutes:: default
#

default[:sidekiq] = {
  # Sidekiq will be installed on to application/solo instances,
  # unless a utility name is set, in which case, Sidekiq will
  # only be installed on to a utility instance that matches
  # the name
  :utility_name => 'sidekiq',
  
  # Number of workers (not threads)
  :workers => 1,
  
  # Concurrency
  :concurrency => 25,
  
  # Queues
  :queues => {
    # :queue_name => priority
    :default => 1
  },

  # Memory limit
  :worker_memory => 400, # MB

  # Verbose
  :verbose => false,

  # Timeout (in seconds) to use when terminating a bloated process
  # this is passed as a parameter to sidekiqctl, invoked inside /engineyard/bin/sidekiq
  :timeout => 115
}
