#ClamAV installer for Stable v4


This is a standard gentoo package install. 
Install is only done on app and util instances.
There currently is no on-demand scanning schedule setup but if one is desired, please use our cron custom chef script for setting up a clamscan run.

Example


    59 23 * * * /usr/local/bin/scan.sh



Contents of scan.sh


```#!/bin/bash
LOGFILE="/var/log/clamav/clamscan.$(date +%m%d%y).log";
EMAIL_TO="custom@email.com";
EMAIL_SUBJECT="ClamAV Scan Results host $(hostname) Malware Found";
DIRTOSCAN="/data";

clamscan -r -i  -l "$LOGFILE" "$DIRTOSCAN";

MALWARE=$(tail "$LOGFILE" | grep Infected|cut -d" " -f3);

if [ "$MALWARE" -ne "0" ];then
        cat "$LOGFILE" | mailx  -s "$EMAIL_SUBJECT" "$EMAIL_TO";
 fi

exit 0
```



Questions/Issues?
support@cloud.engineyard.com

