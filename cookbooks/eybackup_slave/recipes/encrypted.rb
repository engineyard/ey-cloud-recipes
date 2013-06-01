#
# Cookbook Name:: eybackup_slave
# Recipe:: default
#

# gnupg package
package "app-crypt/gnupg" do
  version '2.0.9'
  action :nothing
end.run_action(:install)

# public key
if node[:encrypted_backups]
  execute "writing public key to /root/backup_pgp_key" do
    action :nothing
  end.run_action(:run)

  unless component['public_key'].empty?
    execute "gpg --import /root/backup_pgp_key" do
      action :nothing
    end.run_action(:run)
  end
end