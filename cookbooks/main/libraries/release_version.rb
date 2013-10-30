class Chef
  class Recipe
    def release_version
      release = File.read('/etc/engineyard/release')
      return "v4" if release.to_i > 2009
      "v2"
    end
  end
end