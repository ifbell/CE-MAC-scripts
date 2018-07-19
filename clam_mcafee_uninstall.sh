#!/bin/sh
## postinstall
##created by IFBELL 19/07/18

#uninstall McAfee from the machine

McAfeeuninstall() {
/usr/local/McAfee/uninstall EPM
#/usr/local/GSAfiles/uninstall.sh
rm -fdvr /usr/local/GSAfiles/uninstall.sh
rm -fdvr /Library/LaunchDaemons/com.mcafee.*
rm -fdvr /Library/LaunchAgents/com.mcafee.*
rm -fdvr /private/etc/cma.d 
rm -fdvr /Applications/McAfee\ Endpoint\ Protection\ for\ Mac.app

if [ ! -d /etc/cma.d/ ];then
echo $(date) "We have found McAfee anti-virus files!" >> /var/log/GSAlog ; exit 1
fi
echo $(date) "Uninstalled McAfee anti-virus"  >> /var/log/GSAlog
}
#check for what antivirus exists
if [ -d /Applications/ClamXAV.app ]; then
/usr/sbin/installer -pkg /usr/local/clamXav/ClamXavEngineRemover.pkg -target /
fi

if [ -d /Applications/McAfee\ Endpoint\ Security\ for\ Mac.app ]; then
McAfeeuninstall
fi
exit 0

exit 0		## Success
exit 1		## Failure
