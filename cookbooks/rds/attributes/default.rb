# place database credentials in this file
#
#   default[:app_name] = { :adapter => '', :database => '', :username => '', :password => '', :host => '' }
#
# for example:
#
#  case node[:environment][:name]
#  when 'env1'
#    default[:todo] = { 
#      :adapter => 'mysql', 
#      :database => 'todoproduction', 
#      :username => 'engineyard', 
#      :password => 'mypassword', 
#      :host => 'todo.dhvg1ytl1sd8.us-east-1.rds.amazonaws.com' 
#    }
#  when 'env2'
#    default[:todo] = { 
#      :adapter => 'mysql', 
#      :database => 'todoproduction', 
#      :username => 'engineyard', 
#      :password => 'mypassword', 
#      :host => 'todo.prod.us-east-1.rds.amazonaws.com' 
#    }
#  end
