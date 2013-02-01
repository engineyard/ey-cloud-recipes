#foodcritic-rules
================

These are the foodcritic rules we've written here at Etsy to enforce rules on our cookbooks. Some of these rules are  best practices we've identified for our particular use case, and some were put in place as remediation items after issues we experienced.

# Usage

Once you've cloned the repo from github, you can run foodcritic using the following options to test your cookbooks against these rules:

````
foodcritic -t etsy,FC023 -I <rules.rb> cookbooks
````
You should make sure that <rules.rb> is replaced with the location of the rules.rb file from this repository.

Note that we're also checking against the built in foodcritic rule FC023 (Prefer conditional attributes). This is to complement the functionality in rule ETSY004 (see description below)

All of the below rules have the "style" tag as they are best practices and recommendations from our experience rather than rules to detect things which might break your cookbooks.

# Rules

## ETSY001 - Package or yum_package resource used with :upgrade action

We've had several instances of new packages being put into our yum repository and rolled out to servers before we intended due to the use of the :upgrade action in "package" and "yum_package" resources. This rule will detect when :upgrade has been used instead of :install.

For example, this block would trip this rule:

````
package "sendmail" do
  action :upgrade
end
````

## ETSY002 - Execute resource used to run git commands

This rule detects when Git commands are run as bash commands inside of an "execute" block, rather than using the "git" resource. We alert on this behaviour as running these commands inside "execute" blocks gives you much less visibility of the commands' output and status.

For example, this block would trip this rule:

````
execute "checkout" do
  command "git clone git://github.com/foo/bar.git"
  cwd "/home/me"
end

````

## ETSY003 - Execute resource used to run curl or wget commands

This rule detects when wget or curl commands are run as bash commands inside of an "execute" block, rather than using the "remote_file" resource. We alert on this behaviour as running these commands inside "execute" blocks gives you much less visibility of the commands' output and status.

For example, this block would trip this rule:

````
execute "fetch_file" do
    command "wget -O /tmp/foo.tar.gz http://me.mycorp.com/files/foo.tar.gz"
    not_if "test -f /tmp/foo.tar.gz"
end

````

## ETSY004 - Execute resource defined without conditional or action :nothing

This rule detects when an "execute" block is defined without specifying a conditional (ie not_if or only_if) or action :nothing. This is to avoid the presence of resources which run on every chef run, whether they need to or not. Please note, this rule does not identify "execute" blocks which are themselves wrapped in a conditional, ie an if statement. For this reason, we recommend that you also use the built in foodcritic rule FC023, which detects this case. Rule FC023 recommends that you always use conditionals inside your resources instead of wrapping them, and we'd concur with this.

For example, this block would trip this rule:

````
execute "fetch_file" do
    command "wget -O /tmp/foo.tar.gz http://me.mycorp.com/files/foo.tar.gz"
end
````

As would this block, even though there is technically a conditional wrapping the resource.

````
if !File.exists?("/tmp/foo.tar.gz")
    execute "fetch_file" do
        command "wget -O /tmp/foo.tar.gz http://me.mycorp.com/files/foo.tar.gz"
    end
end
````
However, the above block would subsequently be flagged by rule FC023.

## ETSY005 - Action :restart sent to a core service

This rule identifies when a recipe might send "action :restart" to a service we've identified as a "core" service. We've had instances in the past of chef changes causing hard restarts of services such as memcached or httpd, which can have unexpected side effects. For this reason, we alert if any restart notifications are sent to a defined list of "core" services. Restart notifications sent to any services not in this list will not cause this rule to trip.

The core services list is defined at the top of rules.rb:

````
@coreservices = ["httpd", "mysql", "memcached", "postgresql-server"]
````

For example, this block would trip this rule:
````
cookbook_file "/etc/httpd/conf.d/myvhost.conf" do
  source "myvhost.conf"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "httpd")
end
````

Wheras this block would not (as we're using reload instead of restart):

````
cookbook_file "/etc/httpd/conf.d/myvhost.conf" do
  source "myvhost.conf"
  mode 0644
  owner "root"
  group "root"
  notifies :reload, resources(:service => "httpd")
end
````

And neither would this one (as sendmail is not a core service):

````
template "/etc/mail/sendmail.mc" do
  source "sendmail.mc.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, resources(:service => "sendmail")
end
````

## ETSY006 - Execute resource used to run chef-provided command

This rule detects when an "execute" block is using a shell command when Chef already provides a built in resource with equivalent functionality.

The list of commands to check for is defined at the top of rules.rb:

````
@corecommands = ["yum -y", "yum install", "yum reinstall", "yum remove", "mkdir", "useradd", "usermod", "touch"]
````

For example, this block would trip this rule:

````
execute "reinstall_pear" do
  command "yum -y reinstall php-pear"
end
````

## ETSY007 - Package or yum_package resource used to install core package without specific version number

This rule identifies when a recipe is installing a package for something we've identified as a "core" service without specifying a specific version number to install. We've had instances in the past of divergence occurring when action :install is used by itself, and a new package has been added to the repository resulting in new servers installing the new version while old servers are still using the previous version.

The list of package names to check for is defined at the top of rules.rb:

````
@coreservicepackages = ["httpd", "Percona-Server-server-51", "memcached", "postgresql-server"]
````

For example, this block would trip this rule:

````
package "httpd" do
  action :install
end
````