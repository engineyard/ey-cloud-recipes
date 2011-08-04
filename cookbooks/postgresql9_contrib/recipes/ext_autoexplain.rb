# ---- Modify pgsql config file ----
Chef::Log.info "-- from ext_autoexplain --" 

template "#{@node[:postgres_root]}#{@node[:postgres_version]}/custom_autoexplain.conf" do
  source "custom_autoexplain.erb"
  owner "postgres"
  group "root"
  mode 0600
  backup 0
  # notifies :restart, resources(:service => "postgresql-#{@node[:postgres_version]}")
  variables({
    :shared_preload_libraries => "'auto_explain'",
    :custom_variable_classes => "'auto_explain'",
    :auto_explain_log_min_duration => "'0s'",
    :auto_explain_log_analyze => "'false'",
    :auto_explain_log_verbose => "'false'",
    :auto_explain_log_buffers => "'false'",
    :auto_explain_log_format =>  "'text'",
    :auto_explain_log_nested_statements => "'false'"
  })
end

