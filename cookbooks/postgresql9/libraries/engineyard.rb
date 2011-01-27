require 'dnapi'
class Chef::Node
  def engineyard
    @engineyard ||= DNApi.from(File.read("/etc/chef/dna.json"))
  end
end
