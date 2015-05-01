module EY
  module Helpers
    def ey_release_version
      release = File.read('/etc/engineyard/release')
      return "12.11" if release.to_i > 2009
      "2009a"
    end
  end
end

Chef::Recipe.send(:include, EY::Helpers)
Chef::Resource.send(:include, EY::Helpers)
