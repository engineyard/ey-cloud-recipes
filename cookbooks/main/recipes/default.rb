execute "testing" do
  command %Q{
    echo "i ran at #{Time.now}" >> /root/cheftime
  }
end

# uncomment if you want to run couchdb recipe
require_recipe "couchdb"