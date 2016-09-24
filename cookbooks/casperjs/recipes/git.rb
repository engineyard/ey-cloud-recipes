include_recipe "phantomjs"

source_dir = node['casperjs']['git']['source_dir']
source_url = node['casperjs']['git']['source_url']
source_ref = node['casperjs']['version']

git "#{source_dir}/casperjs" do
  repository source_url
  reference  source_ref
  action     :checkout
end

link '/usr/local/bin/casperjs' do
  to "#{source_dir}/casperjs/rubybin/casperjs"
end
