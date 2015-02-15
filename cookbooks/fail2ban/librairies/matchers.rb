if defined?(ChefSpec)

  def run_file_replace(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:file_replace, :run, resource_name)
  end

end
