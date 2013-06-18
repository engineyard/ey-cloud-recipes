default[:db_stack] = db_stack = node[:engineyard][:environment][:db_stack_name]
default[:postgres_root] = "/db/postgresql/"

if db_stack == "postgres9"
  default[:postgres_version] = "9.0"
elsif db_stack == "postgres9_1"
  default[:postgres_version] = "9.1"
elsif db_stack == "postgres9_2"
  default[:postgres_version] = "9.2"
end
