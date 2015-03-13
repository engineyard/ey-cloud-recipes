Envirnoment motd customization
------------------------------

Add some interesting message at ssh login and bash shell.

Using it
--------

  * add this in your main


	include_recipe "env_motd"


  * If you prefere you can only active bash or motd recipe only


	include_recipe "env_motd::motd"
	include_recipe "env_motd::bash"  


Sample
------
*motd* (displayed at ssh connexion)

	-[====]-
	
	Monday, 17 November 2014, 04:58:51 PM
	Linux 3.4.45-amazon-xen x86_64 GNU/Linux
	
	Uptime.............: 220 days, 07h42m07s
	Memory.............: 389 Mb (Free) / 1695Mb (Total) with 540Mb (cache) and 7Mb (swap)
	Load Averages......: 0.11 0.10 0.13 (1, 5 and 15 min)
	Running Processes..: 97
	Disk Space.........: 9.3G/15G (34%)
	
	IP Addresses.......: 172.XXX.XXX.XXX
	Server Name........: ip-172-XXX-XXX-XXX
	Public Name........: ec2-54-XXX-XXX-XXX.eu-west-1.compute.amazonaws.com
	Public Ip..........: 54.XXX.XXX.XXX
	
	Ey info............: app_master/production
	
	-[====]-

*bash*

	app_master/production - deploy@ip-172-XXX-XXX-XXX

