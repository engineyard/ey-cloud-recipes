# CUSTOMIZE TO YOUR MMS account by filling in your API_KEY and SECRET_KEY here, mapped to your cloud environments
# You can find these in the “Settings” page of the MMS console.
# You will need to add a host to your MMS account to seed MMS.
# Add multiple groups, one per cloud environment

# NOTE: Environment names are cap sensitive
API_KEYS = {
  "EnvName" => ""
}
SECRET_KEYS = {
  "EnvName" => ""
}
# setting API_KEYS and SECRET_KEYS for your environment effectively enables this recipe
if API_KEYS.has_key? @node[:environment][:name] and SECRET_KEYS.has_key? @node[:environment][:name]
  InstallDirectory = "/db/mms"
  MmsFileName = "10gen-mms-agent"
  MmsZipFile = "#{MmsFileName}.zip"
  MmsZipUrl = "https://mms.10gen.com/settings/#{MmsZipFile}"

  directory InstallDirectory do
    owner 'deploy'
    group 'deploy'
    mode  '0755'
    action :create
    recursive true
  end

  execute "Install Mongo Monitoring Service Dependencies" do
    command "sudo easy_install -U setuptools; sudo easy_install simplejson; sudo easy_install pymongo"
    not_if { FileTest.directory?("#{InstallDirectory}/mms-agent") }
  end

  execute "Fetch Mongo Monitoring Service zip file" do
    command "cd #{InstallDirectory}; wget #{MmsZipUrl}; unzip #{MmsZipFile}"
    not_if { FileTest.directory?("#{InstallDirectory}/mms-agent") }
  end

  execute "Modify settings.py" do
    cwd "#{InstallDirectory}/mms-agent"
    command "sed -i 's/@API_KEY@/#{API_KEYS[@node[:environment][:name]]}/g' settings.py && sed -i 's/@SECRET_KEY@/#{SECRET_KEYS[@node[:environment][:name]]}/g' settings.py && sed -i 's/mms-stage/mms/g' settings.py"
  end

  remote_file "#{InstallDirectory}/mms.sh" do
    owner "deploy"
    group "deploy"
    mode 0755
    source "mms.sh"
    backup false
    action :create
  end

  remote_file "/etc/monit.d/mms.monitrc" do
    owner "root"
    group "root"
    mode 0644
    source "mms.monitrc"
    backup false
    action :create
  end

  execute "Reload monit" do
    command "sudo /etc/init.d/monit reload"
  end

end

