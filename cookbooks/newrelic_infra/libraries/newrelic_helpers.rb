module NewrelicHelpers
  # check that New Relic addon is enabled
  def newrelic_enabled?
    !!newrelic_dna
  end
  
  # the New Relic license key
  def newrelic_license_key
    newrelic_dna[:config][:vars][:license_key] if newrelic_enabled?
  end
  
  # New Relic config
  def newrelic_dna
    @newrelic_dna ||= begin
      node[:engineyard][:environment][:apps].each do |app|
        app[:components].each do |component|
          if component[:key].eql?('addons')
            component[:collection].each do |addon|            
              return addon if addon[:name] == 'New Relic'
            end
          end
        end
      end
      
      nil
    end
  end
end
