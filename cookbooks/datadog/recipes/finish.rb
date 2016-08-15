execute "monit-start-dd" do
 command "monit start datadog_wrapper"
 only_if " pgrep 'datadog_wrapper' < /dev/null"
end
