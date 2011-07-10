ruby_block "create_bucket" do
  block do
  require 'fog'

  connection = Fog::Storage.new(
  :provider => 'AWS',
  :aws_secret_access_key =>  node.engineyard.environment.aws_secret_key,
  :aws_access_key_id => node.engineyard.environment.aws_secret_id
  )

  bucket = connection.directories.create(
  :key => "elasticsearch_#{node['environment']['name']}",
  :public => false
  )
  end
end
