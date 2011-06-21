# TO-DO: replace with portage version. Check for 32bit on i686 systems (for arbiter only installs)
file_to_fetch = "http://fastdl.mongodb.org/linux/#{@node[:mongo_name]}.tgz"

execute "fetch #{file_to_fetch}" do
  cwd "/tmp"
  command "wget #{file_to_fetch}"
  not_if { FileTest.exists?("/tmp/#{@node[:mongo_name]}.tgz") }
end

execute "untar /tmp/#{@node[:mongo_name]}.tgz" do
  command "cd /tmp; tar zxf #{@node[:mongo_name]}.tgz -C /opt"
  not_if { FileTest.directory?("/opt/#{@node[:mongo_name]}") }
end

