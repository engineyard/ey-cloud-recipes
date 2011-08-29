# define loader functions for postgres sql files or libraries

def load_sql_file(db_name, contrib_path)
 command "psql -U postgres -d #{db_name} -f #{contrib_path}"
end

def load_shared_library(db_name, library_name)
 command "psql -U postgres -d #{db_name} -c \"LOAD \'#{library_name}\'\";"
end

