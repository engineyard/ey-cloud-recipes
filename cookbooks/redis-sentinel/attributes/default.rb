default['redis-sentinel'].tap do |sentinel|
  # Installing from the Gentoo package in the portage tree is the recommended approach.
  # Set install_from_source to true if you need a version that's not available from the
  # portage tree.
  sentinel['install_from_source'] = true

  # The redis-sentinel version should be the same version as the Redis version
  # If you're installing from the portage tree, only the following versions are available:
  # 2.8.13-r1
  #
  # For the v4 stack, we highly recommend installing from source

  # If you're installing from source, see http://download.redis.io/releases/ for the available versions
  # Beta versions will also work, e.g. 4.0-rc2. Make sure you set the download_url correctly.
  sentinel['version'] = '3.2.3'
  sentinel['download_url'] = "http://download.redis.io/releases/redis-#{redis['version']}.tar.gz"

  # Redis Beta, if you really have to
  # Make sure you also set redis['install_from_source'] to true
  # redis['version'] = '4.0-rc2'
  # redis['download_url'] = 'https://github.com/antirez/redis/archive/4.0-rc2.tar.gz'

  sentinel['force_upgrade'] = false

  sentinel['port'] = '26379'
  sentinel['basedir'] = '/data/redis'

  # Install redis-sentinel on utility instances named 'sidekiq'
  sentinel['utility_name'] = 'sidekiq'
  sentinel['install_type'] = 'NAMED_UTILS'

  # Install redis-sentinel on all app instances
  # sentinel['install_type'] = 'ALL_APP_INSTANCES'

  # Timeout
  sentinel['timeout'] = 300_000
end
