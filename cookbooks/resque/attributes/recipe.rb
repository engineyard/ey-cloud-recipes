
queues({
  :all => {
    :groupa => {
      :inventory => [
        :cloning,
        :inventory,
        :inventory,
        :schedule,
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
        :publication
      ]
    },
    :groupc => {
      :perf => [
        :performance_aggregation,
        :performance_download,
        :performance_import
      ]
    }
  }
})

