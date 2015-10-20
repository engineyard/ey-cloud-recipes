# fail2ban.conf
#          1 = ERROR
#          2 = WARN
#          3 = INFO
#          4 = DEBUG
default['fail2ban']['loglevel'] = 3
default['fail2ban']['socket'] = '/var/run/fail2ban/fail2ban.sock'
default['fail2ban']['logtarget'] = '/var/log/fail2ban.log'

# global config
# XXX /!\ fail2ben 0.8.13 are comming and after 0.9.0 ... and this change some stuff in the jails
default['fail2ban']['version'] = '0.8.6'

# jail.local
default['fail2ban']['jails'] = {
	# defined using space separator.
	'ignoreip'    => '127.0.0.1/8',
	# "bantime" is the number of seconds that a host is banned.
	'bantime'     => 600,
	# A host is banned if it has generated "maxretry" during the last "findtime"
	# seconds.
	'findtime'    => 600,
	# "maxretry" is the number of failures before a host get banned.
	'maxretry'    => 3,
	'pidfile'     => '/var/run/fail2ban/fail2ban.pid',
	'ignorecommand' => '',
	# "usedns" specifies if jails should trust hostnames in logs,
	#   warn when DNS lookups are performed, or ignore all hostnames in logs
	#
	# yes:   if a hostname is encountered, a DNS lookup will be performed.
	# warn:  if a hostname is encountered, a DNS lookup will be performed,
	#        but it will be logged as a warning.
	# no:    if a hostname is encountered, will not be used for banning,
	#        but it will be logged as info.
	'usedns'      => 'warn',
	# gamin:   requires Gamin (a file alteration monitor) to be installed. If Gamin
	#          is not installed, Fail2ban will use polling.
	# polling: uses a polling algorithm which does not require external libraries.
	# auto:    will choose Gamin if available and polling otherwise.
	'backend'     => 'auto',
	# mail configuration
	'mail'      => {
		'destination'   => 'security_control@company.com',
		'sender'        => 'root@localhost'
	},
	'banaction' => 'iptables-multiport',
	'mta'       => 'sendmail',
	'protocol'  => 'all', # all, tcp, udp
	'actions'    => 'action_mw',
	# jails to build
	'jails'       => {
		'ssh'  => {
			'comment'   => '',
			'options'   => {
				'enabled'   => 'true',
				'port'      => 'ssh',
				'filter'    => 'sshd',
				'protocol'	=> 'tcp',
				'logpath'   => '/var/log/auth.log',
				'maxretry'   => '3'
			}
		},
        'ssh-ddos'  => {
            'comment'   => '',
            'options'   => {
				'enabled'   => 'true',
				'port'      => 'ssh',
				'filter'    => 'sshd-ddos',
				'protocol'	=> 'tcp',
				'logpath'   => '/var/log/auth.log',
				'maxretry'   => '3'
            }
        },
#        'apache'  => {
#			'comment'   => 'apache http',
#			'options'   => {
#				'enabled'   => 'false',
#				'port'      => 'http,https',
#				'filter'    => 'apache-auth',
#				'logpath'   => '/var/log/apache*/*error.log',
#				'maxretry'   => '5'
#			}
#        },
#        'apache-multiport'  => {
#            'comment'   => '',
#            'options'   => {
#				'enabled'   => 'false',
#				'port'      => 'http,https',
#				'filter'    => 'apache-auth',
#				'logpath'   => '/var/log/apache*/*error.log',
#				'maxretry'   => '5'
#            }
#        },
#		'apache-overflows'  => {
#			'comment'   => '',
#			'options'   => {
#				'enabled'   => 'false',
#				'port'      => 'http,https',
#				'filter'    => 'apache-overflows',
#				'logpath'   => '/var/log/apache*/*error.log',
#				'maxretry'   => '2'
#			}
#		},
#		'apache-noscript'  => {
#			'comment'   => '',
#			'options'   => {
#				'enabled'   => 'false',
#				'port'      => 'http,https',
#				'filter'    => 'apache-noscript',
#				'logpath'   => '/var/log/apache*/*error.log',
#				'maxretry'   => '5'
#			}
#		},
#		'apache-w00tw00t'  => {
#			'comment'   => '',
#			'options'   => {
#				'enabled'   => 'false',
#				'port'      => 'http,https',
#				'filter'    => 'apache-w00tw00t',
#				'logpath'   => '/var/log/apache*/*access.log',
#				'maxretry'   => '1'
#			}
#		},
#        'vsftpd'  => {
#            'comment'   => 'FTP servers',
#            'options'   => {
#                'enabled'   => 'false',
#                'port'      => 'ftp,ftp-data,ftps,ftps-data',
#                'filter'    => 'vsftpd',
#                'logpath'   => '/var/log/vsftpd.log',
#                'maxretry'   => '6'
#            }
#        },
#        'proftpd'  => {
#            'comment'   => '',
#            'options'   => {
#                'enabled'   => 'false',
#                'port'      => 'ftp,ftp-data,ftps,ftps-data',
#                'filter'    => 'proftpd',
#                'logpath'   => '/var/log/proftpd/proftpd.log',
#                'maxretry'   => '6'
#            }
#        },
		'nginx-auth'  => {
			'comment'   => 'nginx basic auth',
			'options'   => {
				'enabled'   => 'false',
				'port'      => 'http,https',
				'filter'    => 'nginx-auth',
				'logpath'   => '/var/log/nginx*/*error*.log',
				'maxretry'  => '6',
				'bantime'   => '600 # 10 minutes',
				'action'    => 'iptables-multiport[name=NoAuthFailures, port="http,https"]'
			}
		},
		'nginx-login'  => {
			'comment'   => 'nginx login',
			'options'   => {
				'enabled'   => 'false',
				'port'      => 'http,https',
				'filter'    => 'nginx-login',
				'logpath'   => '/var/log/nginx*/*access*.log',
				'maxretry'  => '6',
				'bantime'   => '600 # 10 minutes',
				'action'    => 'iptables-multiport[name=NoLoginFailures, port="http,https"]'
			}
		},
		'nginx-badbots'  => {
			'comment'   => 'block bad bots',
			'options'   => {
				'enabled'   => 'false',
				'port'      => 'http,https',
				'filter'    => 'nginx-badbots',
				'logpath'   => '/var/log/nginx*/*access*.log',
				'maxretry'  => '1',
				'bantime'   => '86400 # 1 day',
				'action'    => 'iptables-multiport[name=BadBots, port="http,https"]'
			}
		},
		'nginx-noscript'  => {
			'comment'   => 'block access to executable file names (exe, cgi, pl, etc)',
			'options'   => {
				'enabled'   => 'false',
				'port'      => 'http,https',
				'filter'    => 'nginx-noscript',
				'logpath'   => '/var/log/nginx*/*access*.log',
				'maxretry'  => '6',
				'bantime'   => '86400 # 1 day',
				'action'    => 'iptables-multiport[name=NoScript, port="http,https"]'
			}
		},
		'nginx-proxy'  => {
			'comment'   => 'prevent using nginx as a proxy',
			'options'   => {
				'enabled'   => 'false',
				'port'      => 'http,https',
				'filter'    => 'nginx-proxy',
				'logpath'   => '/var/log/nginx*/*access*.log',
				'maxretry'  => '0',
				'bantime'   => '86400 # 1 day',
				'action'    => 'iptables-multiport[name=NoProxy, port="http,https"]'
			}
		},
		'nginx-dos'  => {
			'comment'   => 'ban dos attacks',
			'options'   => {
				'enabled'   => 'false',
				'port'      => 'http,https',
				'filter'    => 'nginx-dos',
				'logpath'   => '/var/log/nginx/*access.log',
				'maxretry'  => '240',
				'findtime'  => 60,
				'bantime'   => 172800
			}
		},
        'postfix'  => {
            'comment'   => 'Mail servers',
            'options'   => {
                'enabled'   => 'false',
                'port'      => 'smtp,ssmtp',
                'filter'    => 'postfix',
                'logpath'   => '/var/log/mail.log'
            }
        },
        'sasl'  => {
            'comment'   => '',
            'options'   => {
                'enabled'   => 'false',
                'port'      => 'smtp,ssmtp,imap2,imap3,imaps,pop3,pop3s',
                'filter'    => 'sasl',
                'logpath'   => '/var/log/mail.log'
            }
        },
        'exim-iptables'  => {
            'comment'   => 'ban ips listed in a dns realtime-blacklist',
            'options'   => {
                'enabled'   => 'false',
                'port'      => 'smtp,2525,465',
                'filter'    => 'exim',
                #'action' => 'iptables-multiport[name=Exim, port="smtp,2525,465", protocol=tcp]'
                'logpath'   => '/var/log/exim4/mainlog',
                'maxretry'  => '2',
				# ban almost 6h
                'bantime'   => '20000'
            }
        },
        'ssh-repeater'  => {
            'comment'   => 'see http://stuffphilwrites.com/2013/03/permanently-ban-repeat-offenders-fail2ban/',
            'options'   => {
                'enabled'   => 'false',
                'filter'    => 'sshd',
                'logpath'   => '/var/log/auth.log',
                'maxretry'  => '15',
                'fintime'   => 31536000,
                'bantime'   => 31536000,
                'action'    => 'iptables-repeater[name=ssh-repeat]
                                         %(mailaction)s'
            }
        },
        'repeatoffender'  => {
            'comment'   => 'see http://tscadfx.com/permanently-ban-repeat-offenders-with-fail2ban/',
            'options'   => {
                'enabled'   => 'false',
                'filter'    => 'repeatoffender',
                'logpath'   => '/var/log/fail2ban.log',
                'maxretry'  => '15',
                'bantime'   => '-1',
                'findtime'  => 31536000,
                'action'    => 'repeatoffender[name=repeatoffender]
                                	 %(mailaction)s'
            }
        }
	}
}
