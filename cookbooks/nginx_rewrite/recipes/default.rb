# Uncomment the following lines to include different recipes
# include_recipe 'nginx_rewrite::custom'

service 'nginx' do
	action :reload
end
