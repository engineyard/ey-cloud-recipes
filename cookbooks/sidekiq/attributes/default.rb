<<<<<<< HEAD
#
# Cookbook Name:: sidekiq
# Attrbutes:: default
#

sidekiq({
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
    :high => 3,
    :default => 1
  },
  
  # Verbose
  :verbose => false
})
=======
sidekiq_workers(1)
sidekiq_utility_name('sidekiq')
>>>>>>> ec0a0fd3582b9d5d364f67ff40890c82baa71261
