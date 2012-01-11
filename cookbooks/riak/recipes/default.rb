# Pardon the dust in here. <-- sml 10-10-10..nil?

# This portion of the recipe runs on all instances, except the utility instances.  You don't want haproxy on the utility instances but you do on solo|app|app_master
if ['solo','app','app_master'].include?(node[:instance_role])
  require_recipe "riak::haproxy"
  #require_recipe "riak::basho_bench"
  require_recipe "riak::app_config"
  # Remove old version of Erlang that is NOT new enough
  package "dev-lang/erlang" do
    version "erlang-12.2.5-r1"
    action :remove
    only_if { FileTest.directory?("/var/db/pkg/dev-lang/erlang-12.2.5-r1") }
  end

# Install a version of Erlang (R130B4) provided by me.  I built the package, if you would like to see the ebuild sources make an issue.
  s3_install "dev-lang/erlang" do
    version "14.2.3"
  end
end

# This portion of the recipe runs on only utility instances
if ['util'].include?(node[:instance_role])
  if node['name'].include?('riak_')
# Remove old version of Erlang that is NOT new enough
    package "dev-lang/erlang" do
      version "erlang-12.2.5-r1"
      action :remove
      only_if { FileTest.directory?("/var/db/pkg/dev-lang/erlang-12.2.5-r1") }
    end

# Install a version of Erlang (R130B4) provided by me.  I built the package, if you would like to see the ebuild sources make an issue.
    s3_install "dev-lang/erlang" do
      version "14.2.3"
    end

# Install python_setuptools as the version in portage is too old.

    include_recipe "riak::setuptools"

# Install Mercurial as it's required for most things with Webmachine / rebar.

    execute "easy_install mercurial" do
      action :run
      not_if { FileTest.exists?("/usr/bin/hg") }
    end

    include_recipe "riak::install_riak"
    include_recipe "riak::configure_riak"
    include_recipe "riak::start_riak"
    include_recipe "riak::join_ring"
    #include_recipe "riak::basho_bench"
  end
end
