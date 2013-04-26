
queues({
  :all => {
    :groupa => {
      :inventory => [
        :cloning,
        :inventory,
        :schedule
      ],
      :sync => [
        :synchronization,
        :performance_aggregation,
        :performance_keyword_sync,
        :performance_ad_sync,
        :notification
      ]
    },
    :groupb => {
      :gen => [
        :generation,
        :generation,
        :vendor_instance
      ],
      :pub => [
        :publication,
        :publication,
        :vendor_instance
      ]
    },
    :groupc => {
      :perf => [
        :performance_download,
        :performance_import
      ]
    }
  }
})
