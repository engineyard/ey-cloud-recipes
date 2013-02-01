#Etsy Foodcritic rules
@coreservices = ["httpd", "mysql", "memcached", "postgresql-server"]
@coreservicepackages = ["httpd", "Percona-Server-server-51", "memcached", "postgresql-server"]
@corecommands = ["yum -y", "yum install", "yum reinstall", "yum remove", "mkdir", "useradd", "usermod", "touch"]

rule "ETSY001", "Package or yum_package resource used with :upgrade action" do
  tags %w{correctness recipe etsy}
  recipe do |ast|
    pres = find_resources(ast, :type => 'package').find_all do |cmd|
      cmd_str = (resource_attribute(cmd, 'action') || resource_name(cmd)).to_s
      cmd_str.include?('upgrade')
    end
    ypres = find_resources(ast, :type => 'yum_package').find_all do |cmd|
      cmd_str = (resource_attribute(cmd, 'action') || resource_name(cmd)).to_s
      cmd_str.include?('upgrade')
    end
  pres.concat(ypres).map{|cmd| match(cmd)}
  end
end

#ETSY002 and ETSY003 removed as they were added to mainline foodcritic as FC040 and FC041

# This rule does not detect execute resources defined inside a conditional, as foodcritic rule FC023 (Prefer conditional attributes)
# already provides this. It's recommended to use both rules in conjunction. (foodcritic -t etsy,FC023)
rule "ETSY004", "Execute resource defined without conditional or action :nothing" do
  tags %w{style recipe etsy}
  recipe do |ast,filename|
    pres = find_resources(ast, :type => 'execute').find_all do |cmd|
      cmd_actions = (resource_attribute(cmd, 'action') || resource_name(cmd)).to_s
      condition = cmd.xpath('//ident[@value="only_if" or @value="not_if" or @value="creates"][parent::fcall or parent::command or ancestor::if]')
      (condition.empty? && !cmd_actions.include?("nothing"))
    end.map{|cmd| match(cmd)}
  end
end

rule "ETSY005", "Action :restart sent to a core service" do
  tags %w{style recipe etsy}
  recipe do |ast, filename|
    find_resources(ast).select do |resource|
      notifications(resource).any? do |notification|
        @coreservices.include?(notification[:resource_name]) and
          notification[:action] == :restart
      end
    end
  end
end

rule "ETSY006", "Execute resource used to run chef-provided command" do
  tags %w{style recipe etsy}
  recipe do |ast|
    find_resources(ast, :type => 'execute').find_all do |cmd|
      cmd_str = (resource_attribute(cmd, 'command') || resource_name(cmd)).to_s
      @corecommands.any? { |corecommand| cmd_str.include? corecommand }
    end.map{|c| match(c)}
  end
end


rule "ETSY007", "Package or yum_package resource used to install core package without specific version number" do
  tags %w{style recipe etsy}
  recipe do |ast,filename|
    pres = find_resources(ast, :type => 'package').find_all do |cmd|
      cmd_str = (resource_attribute(cmd, 'version') || resource_name(cmd)).to_s
      cmd_action = (resource_attribute(cmd, 'action') || resource_name(cmd)).to_s
      cmd_str == resource_name(cmd) && @coreservicepackages.any? { |svc| resource_name(cmd) == svc } && cmd_action.include?('install') 
    end
    ypres = find_resources(ast, :type => 'yum_package').find_all do |cmd|
      cmd_str = (resource_attribute(cmd, 'version') || resource_name(cmd)).to_s
      cmd_action = (resource_attribute(cmd, 'action') || resource_name(cmd)).to_s
      cmd_str == resource_name(cmd) && @coreservicepackages.any? { |svc| resource_name(cmd) == svc } && cmd_action.include?('install') 
    end
    pres.concat(ypres).map{|cmd| match(cmd)}
  end
end