default[:db_stack] = db_stack = node[:engineyard][:environment][:db_stack_name]
default[:postgres_root] = "/db/postgresql/"

if db_stack == "postgres9"
  default[:postgres_version] = 9.0
elsif db_stack =~ /postgres\d+_\d+/
  default[:postgres_version] = db_stack.gsub('postgres','').gsub('_','.').to_f
end
