redis_package = 'dev-db/redis'
redis_version = node['redis-sentinel']['version']

enable_package redis_package do
  version redis_version
  override_hardmask true
  unmask :true
end

package redis_package do
  version redis_version
  action :install
end
