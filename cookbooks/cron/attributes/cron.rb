# Add one hash per cron job required
# Set the utility instance name to install each cron job on via instance_name

default[:custom_crons] = [{:name => "test1", :time => "10 * * * *", :command => "echo 'test1'", :instance_name => "cron"},
                          {:name => "test2", :time => "10 1 * * *", :command => "echo 'test2'", :instance_name => "cron"}]
