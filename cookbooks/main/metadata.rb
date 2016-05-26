name 'main'
description 'Entry point for all custom chef recipes'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
maintainer 'Engine Yard'
maintainer_email 'info@engineyard.com'
version '0.0.1'

# On Chef 12, this is how you enable recipes
if Chef::VERSION[/^12/]
  #depends 'redis'
end
