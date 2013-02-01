desc "Test your cookbooks for syntax errors"
task :test do
  Dir["cookbooks/**/*.rb"].each do |recipe|
    sh "ruby -c #{recipe}" do |ok, res|
      raise "Syntax error in #{recipe}" unless ok
    end
  end
end

task :default => :test

desc "Create new cookbook skeleton"
task :cookbook do
  # check cookbook name
  name = ARGV.last
  root = "cookbooks/#{name}"
  raise "Must provide a cookbook name" unless name
  
  task name.to_sym do
    # create directories
    sh "mkdir -p #{root}/{attributes,recipes,templates/default,files/default}"
    
    # create readme
    File.open("#{root}/readme.md", "w") do |f|
      f.puts <<-EOH
# #{name}

EOH
    end

    # create default.rb
    File.open("#{root}/recipes/default.rb", "w") do |f|
      f.puts <<-EOH
#
# Cookbook Name:: #{name}
# Recipe:: default
#

EOH
    end
  end
end