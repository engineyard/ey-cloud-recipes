namespace :test do
  desc "Test your cookbooks for syntax errors"
  task :syntax do
    Dir["cookbooks/**/*.rb"].each do |recipe|
      sh "ruby -c #{recipe}" do |success, response|
        raise "Syntax error in #{recipe}" unless success
      end
    end
  end
end