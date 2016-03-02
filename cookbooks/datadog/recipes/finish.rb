
execute "monit-start-dd" do
 user "root"
 command "monit start datadog_wrapper"
end
