require 'fileutils'
TOPDIR = File.dirname(__FILE__)

desc "Test your cookbooks for syntax errors"
task :test do
  puts "** Testing your cookbooks for syntax errors"
  Dir[ File.join(TOPDIR, "cookbooks", "**", "*.rb") ].each do |recipe|
    sh %{ruby -c #{recipe}} do |ok, res|
      if ! ok
        raise "Syntax error in #{recipe}"
      end
    end
  end
end

desc "By default, run rake test"
task :default => [ :test ]

desc "Create a new cookbook (with COOKBOOK=name)"
task :new_cookbook do
  create_cookbook(File.join(TOPDIR, "cookbooks"))
end

def create_cookbook(dir)
  raise "Must provide a COOKBOOK=" unless ENV["COOKBOOK"]
  puts "Detected Windows Platform.  Please remember to save files with Unix style EOL's if needed -- https://help.github.com/articles/dealing-with-line-endings/" if Gem.win_platform?
  puts "** Creating cookbook #{ENV["COOKBOOK"]}"
  FileUtils.mkdir_p "#{File.join(dir, ENV["COOKBOOK"], "attributes")}"
  FileUtils.mkdir_p "#{File.join(dir, ENV["COOKBOOK"], "recipes")}"
  FileUtils.mkdir_p "#{File.join(dir, ENV["COOKBOOK"], "definitions")}"
  FileUtils.mkdir_p "#{File.join(dir, ENV["COOKBOOK"], "libraries")}"
  FileUtils.mkdir_p "#{File.join(dir, ENV["COOKBOOK"], "files", "default")}"
  FileUtils.mkdir_p "#{File.join(dir, ENV["COOKBOOK"], "templates", "default")}"
  puts "** Created Directories"

  unless File.exists?(File.join(dir, ENV["COOKBOOK"], "recipes", "default.rb"))
    open(File.join(dir, ENV["COOKBOOK"], "recipes", "default.rb"), "w") do |file|
      file.puts <<-EOH
#
# Cookbook Name:: #{ENV["COOKBOOK"]}
# Recipe:: default
#
EOH
    end
  end
end
