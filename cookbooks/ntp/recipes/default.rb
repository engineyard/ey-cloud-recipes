#
# Cookbook Name:: ntp
# Recipe:: default
#
# Useful References:
# http://en.gentoo-wiki.com/wiki/NTP#Configuration
#
# Caveats:
# If your instance has 5 minutes or more of clock
# skew, the custom recipes will simply fail to run.


# Install the required package.
package "net-misc/ntp" do
  action :install
end

# Avoid the "cap_set_proc() failed to drop root 
# privileges: Operation not permitted" error when
# switching to the ntp:ntp user.
execute "ensure-user-switching-works" do
  command "modprobe capability"
end

# All instances get their time from the host machine's
# hardware clock by default and ntpd won't be able to
# make adjustments while it's being managed like that.
# This will allow the instance to self-manage its clock.
execute "disassociate-time-from-hardware-clock" do
  command "echo 1 > /proc/sys/xen/independent_wallclock"
end

# Initial quick time sync on deploy to make sure
# we're sync'd up before ntpd takes over with slow
# skew adjustments. ntpd starts with the -g option
# but the large jump takes about 3-4 minutes to occur
# after startup.
execute "initial-time-sync" do
  command "sntp -P no -r pool.ntp.org"
end

# We're using the default for now, but copy over 
# the existing one in case we ever want to change
# anything.
template "/etc/ntp.conf" do
  owner 'root'
  group 'root'
  mode 0644
  source "ntp.conf.erb"
  variables :servers    => ["pool.ntp.org"],
            :driftfile  => "/var/lib/ntp/ntp.drift",
            :restricts  => ["default nomodify nopeer",
                            "127.0.0.1"]
end

# Make sure ntpd is starts at boot and stays running.
execute "add-ntpd-to-default-run-level" do
  command %Q{
    rc-update add ntpd default
  }
  not_if "rc-status | grep ntpd"
end

# Make sure ntpd is running
execute "ensure-ntpd-is-running" do
  command %Q{
    /etc/init.d/ntpd restart
  }
end