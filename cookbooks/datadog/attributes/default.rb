#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#                                                                                         #
#   I RECOMMAND PUTTING YOUR DATADOG API KEY and DB USER PASSWORD IN ENCRYPRED DATABAGS   #
#                                                                                         #
#               EY HAS A GREAT BLOG POST ON HOW TO DO THIS. CHECK IT OUT                  #
#                 https://blog.engineyard.com/2014/encrypted-data-bags                    #
#                                                                                         #
#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #


# Throw your DataDog API key here
default['datadog']['api_key'] = 'API_KEY_GOES_HERE'

# Where do you install you extra monits?
default['monit']['directory'] = "/etc/monit.d"

# Where do you want to put your wrapper script?
default['wrapper']['directory'] = "/opt"

# postgres data
default['postgres']['dd-user'] = "datadog"
default['postgres']['dd-password'] = 'DATA_PG_USER_PASSWORD'
