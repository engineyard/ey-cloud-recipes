queues({
  :inventory            => %w(cloning inventory schedule tracking_code),
  :generation           => %w(generation vendor_instance publication),
  :publication          => %w(publication vendor_instance generation),
  :performance_download => %w(performance_download),
  :performance_import   => %w(performance_import),
  :sync                 => %w(synchronization performance_aggregation performance_keyword_sync performance_ad_sync),
  :notification         => %w(notification)
})

settings({
  'production' => [
    [8, (queues[:generation] + queues[:sync] + queues[:inventory]) ],
    [8, (queues[:publication] + queues[:sync] + queues[:inventory]) ],
    [4, (queues[:inventory] + queues[:publication]) ],
    [2, (queues[:notification] + queues[:performance_download] + queues[:performance_import] + queues[:sync] + queues[:generation] + queues[:inventory]) ],
    [2, (queues[:notification] + queues[:performance_import] + queues[:performance_download] + queues[:sync] + queues[:generation] + queues[:inventory]) ]
  ],
  'develop' => [
    [2, (queues[:generation] + queues[:sync] + queues[:inventory]) ],
    [2, (queues[:publication] + queues[:sync] + queues[:inventory]) ],
    [0, (queues[:inventory] + queues[:publication]) ],
    [2, (queues[:notification] + queues[:performance_download] + queues[:performance_import] + queues[:sync] + queues[:generation] + queues[:inventory]) ],
    [2, (queues[:notification] + queues[:performance_import] + queues[:performance_download] + queues[:sync] + queues[:generation] + queues[:inventory]) ]
  ]
})
