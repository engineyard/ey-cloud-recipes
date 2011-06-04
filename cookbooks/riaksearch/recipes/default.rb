# Pardon the dust in here. <-- sml 10-10-10..nil?

# This portion of the recipe runs on all instances, except the utility instances.  You don't want haproxy on the utility instances but you do on solo|app|app_master
if ['solo','app','app_master'].include?(node[:instance_role])
  require_recipe "riaksearch::haproxy"
  #require_recipe "riaksearch::basho_bench"
  require_recipe "riaksearch::app_config"
  # Remove old version of Erlang that is NOT new enough
  package "dev-lang/erlang" do
    version "erlang-12.2.5-r1"
    action :remove
    only_if { FileTest.directory?("/var/db/pkg/dev-lang/erlang-12.2.5-r1") }
  end

# Install a version of Erlang (R130B4) provided by me.  I built the package, if you would like to see the ebuild sources make an issue.
  s3_install "dev-lang/erlang" do
    version "13.2.4"
  end
end

# This portion of the recipe runs on only utility instances
if ['util'].include?(node[:instance_role])
  if node['name'].include?('riaksearch_')
# Remove old version of Erlang that is NOT new enough
    package "dev-lang/erlang" do
      version "erlang-12.2.5-r1"
      action :remove
      only_if { FileTest.directory?("/var/db/pkg/dev-lang/erlang-12.2.5-r1") }
    end

# Install a version of Erlang (R130B4) provided by me.  I built the package, if you would like to see the ebuild sources make an issue.
    s3_install "dev-lang/erlang" do
      version "13.2.4"
    end

# Install python_setuptools as the version in portage is too old.

    include_recipe "riaksearch::setuptools"

# Install Mercurial as it's required for most things with Webmachine / rebar.

    execute "easy_install mercurial" do
      action :run
      not_if { FileTest.exists?("/usr/bin/hg") }
    end

    include_recipe "riaksearch::install_riak"
    include_recipe "riaksearch::configure_riak"
    include_recipe "riaksearch::start_riak"
    include_recipe "riaksearch::join_ring"
    include_recipe "riaksearch::basho_bench"
  end
end

