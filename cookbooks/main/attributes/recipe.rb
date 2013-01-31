# recipes
recipes('main')

# owner
owner_name(@attribute[:users].first[:username])
owner_pass(@attribute[:users].first[:password])

# applications
applications(@attribute[:applications]) # app_name, data

# instance role
role(@attribute[:instance_role])

# framework env
framework_env(@attribute[:environment][:framework_env])