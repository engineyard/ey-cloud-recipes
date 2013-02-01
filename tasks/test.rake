namespace :test do
  desc "Test your cookbooks for syntax errors"
  task :syntax do
    Dir["cookbooks/**/*.rb"].each do |recipe|
      sh "ruby -c #{recipe}" do |success, response|
        raise "Syntax error in #{recipe}" unless success
      end
    end
  end
  
  desc "Lint your cookbooks"
  task :lint do
    if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
      sh "foodcritic --epic-fail any cookbooks/"
    else
      puts "Lint run skipped for Ruby 1.9.1 and below."
    end
  end
end

desc "Run all testing"
task :test => ["test:syntax", "test:lint"]