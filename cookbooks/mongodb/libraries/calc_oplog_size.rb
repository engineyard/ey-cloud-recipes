class Chef
  class Recipe
    def calc_oplog_size
      solo = node[:instance_role] == 'solo'
      # TO-DO: remove solo, check if high mem XL is included and if the size listed makes sense for an oplog
      case open("http://169.254.169.254/latest/meta-data/instance-type").read
      when "m1.small"
        solo ? '512M' : '1275M'
      when "c1.medium"
        solo ? '512M' : '1275M'
      when "m1.large"
        solo ? '2400M' : '5625M'
      when "m1.xlarge"
        solo ? '5120M' : '11250M'
      when "m2.2xlarge"
        solo ? '10240M' : '22500M'
      when "m2.4xlarge"
        solo ? '20480M' : '45000M'
      when "c1.xlarge"
        solo ? '2400M' : '5625M'
      end
    end
  end
end
