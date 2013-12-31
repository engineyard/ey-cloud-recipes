directory = "#{@node[:postgres_root]}#{@node[:postgres_version]}"

execute "append to custom.conf" do
  command %Q{echo "include \'#{directory}/custom_autoexplain.conf\'" >> #{directory}/custom.conf}
  not_if { File.exists?("#{directory}/custom_autoexplain.conf") }
end

template "#{@node[:postgres_root]}#{@node[:postgres_version]}/custom_autoexplain.conf" do
  source "custom_autoexplain.erb"
  owner "postgres"
  group "root"
  mode 0600
  backup 0
  variables({
    :db_version => @node[:postgres_version],
    :shared_preload_libraries => "'auto_explain'",
    :custom_variable_classes => "'auto_explain'",
    :auto_explain_log_min_duration => "'3s'",
    :auto_explain_log_analyze => "'false'",
    :auto_explain_log_verbose => "'false'",
    :auto_explain_log_buffers => "'false'",
    :auto_explain_log_format =>  "'text'",
    :auto_explain_log_nested_statements => "'false'"
  })
end

execute "reload postgres service" do
  command "/etc/init.d/postgresql-#{@node[:postgres_version]} reload"
end

