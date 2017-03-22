default[:elasticsearch_version] = "2.4.0"
default[:elasticsearch_checksum] = "e5de25e5e0172fd64f27c4b2f8c48b240a4270d3"
default[:elasticsearch_clustername] = "#{node[:environment][:name]}"
default[:elasticsearch_home] = "/data/elasticsearch"
default[:elasticsearch_s3_gateway_bucket] = "elasticsearch_#{node[:environment][:name]}"
default[:elasticsearch_heap_size] = 1000
default[:elasticsearch_fdulimit] = nil #  nofiles limit make this something like 32768, see /etc/security/limits.conf
default[:elasticsearch_defaultreplicas] = 1 # replicas are in addition to the original, so 1 replica means 2 copies of each shard
default[:elasticsearch_defaultshards] = 6 # 6*2 shards per index distributes evenly across 3, 4, or 6 nodes

default[:elastic_search_java_package_name] = "dev-java/icedtea-bin"
default[:elasticsearch_java_version] = "7.2.6.8"
default[:elasticsearch_java_eselect_version] = "icedtea-bin-7"
