# Throw your DataDog API key here
default['datadog']['api_key'] = ""

# Where do you install you extra monits?
default['monit']['directory'] = "/etc/monit.d"

#dont change unless you change this in the monit config
default['wrapper']['directory'] = "/opt"

# directory for your nginx custom config
default['nginx']['custom'] = ""

