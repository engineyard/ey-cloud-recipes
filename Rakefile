# load tasks
Dir['tasks/*.rake'].each do |task|
  import task
end

# default task
task :default => ["test:syntax", "test:lint"]