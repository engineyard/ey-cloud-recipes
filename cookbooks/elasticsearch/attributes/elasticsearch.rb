elasticsearch_version("0.18.2")
elasticsearch_checksum("ce1bad39c66b2eb1ec0286aa4c75a03e6d7ac076")
elasticsearch_clustername("#{@attribute[:environment][:name]}")
elasticsearch_home("/data/elasticsearch")
elasticsearch_s3_gateway_bucket("elasticsearch_#{@attribute[:environment][:name]}")
elasticsearch_heap_size(1000)
elasticsearch_fdulimit(nil) #  nofiles limit (make this something like 32768, see /etc/security/limits.conf)
elasticsearch_defaultreplicas(1) # replicas are in addition to the original, so 1 replica means 2 copies of each shard
elasticsearch_defaultshards(6) # 6*2 shards per index distributes evenly across 3, 4, or 6 nodes
