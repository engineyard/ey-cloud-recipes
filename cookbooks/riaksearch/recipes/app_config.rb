node[:applications].each do |app,data|
  template "/data/#{app}/shared/config/ripple.yml" do
    source "ripple.yml.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0655
    backup 0
    variables({
      :hostname => "localhost"
    })
  end
end
