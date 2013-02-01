namespace :cookbook do
  desc "Create new cookbook skeleton"
  task :new do
    # check cookbook name
    name = ARGV.last
    root = "cookbooks/#{name}"
    raise "Must provide a cookbook name" unless name
  
    task name.to_sym do
      # create directories
      sh "mkdir -p #{root}/{attributes,recipes,templates/default,files/default}"
    
      # create readme
      File.open("#{root}/readme.md", "w") do |f|
        f.puts <<-EOH.gsub(/^\s+/, '')
        # #{name}

        EOH
      end

      # create default.rb
      File.open("#{root}/recipes/default.rb", "w") do |f|
        f.puts <<-EOH.gsub(/^\s+/, '')
        #
        # Cookbook Name:: #{name}
        # Recipe:: default
        #

        EOH
      end
    end
  end
end
