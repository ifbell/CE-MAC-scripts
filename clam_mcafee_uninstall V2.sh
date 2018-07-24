#!/bin/sh
## clam_mcafee_uninstall V2.sh
## created by IFBELL 23/07/18
MFEaccount=""
MFEgroup=""
#uninstall McAfee from the machine
echo 1
McAfeeuninstall () {
echo 4
/usr/local/McAfee/uninstall EPM
/Library/McAfee/agent/scripts/ma stop
launchctl stop com.mcafee.menulet
launchctl stop com.mcafee.reporter
launchctl remove com.mcafee.menulet
launchctl remove com.mcafee.reporter
launchctl unload /Library/LaunchDaemons/com.mcafee.*
/usr/sbin/pkgutil --forget comp.nai.cmamac > /dev/null 2>&1 
#crontab -l | grep -v "/Library/McAfee/agent/scripts/ma start" ) | crontab -
#/usr/local/GSAfiles/uninstall.sh
rm -fdvr /usr/local/GSAfiles/uninstall.sh
rm -fdvr /Library/LaunchDaemons/com.mcafee.*
rm -fdvr /Library/LaunchAgents/com.mcafee.*
rm -fdvr /private/etc/cma.d 
rm -rf /Library/Application\ Support/McAfee
rm -rf /Library/McAfee
#rm -rf /Library/Receipts/cma.pkg
rm -rf /usr/local/McAfee
rm -rf /Library/StartupItems/ma
rm -rf /Library/StartupItems/cma
rm -rf /var/McAfee
rm -rf /var/tmp/.msgbus/ma_*.*
rm -rf /etc/ma.d/EPOAGENT3700MACX
rm -rf /etc/ma.d/CMNUPD__3000
rm -rf /etc/ma.d/EPOAGENT3000
rm -rf /etc/cma.d
rm -rf /etc/ma.d
rm -rf /Library/Application\ Support/McAfee
rm -rf /Library/Documentation/Help/McAfeeSecurity_AVOnly.help
rm -rf /Library/Documentation/Help/McAfeeSecurity_CommonPolicy.help
rm -rf /Library/Frameworks/AVEngine.framework
rm -rf /Library/Frameworks/VirusScanPreferences.framework
rm -f /etc/ma.conf
rm -fdvr /Applications/McAfee\ Endpoint\ Protection\ for\ Mac.app > /dev/null 2>&1
rm -fdvr /Applications/McAfee\ Endpoint\ Security\ for\ Mac.app > /dev/null 2>&1
#remove the mfe account and group if exists
MFEaccount=$(dscl . list /Users | grep mfe)
if [ $MFEaccount = "mfe" ]; then
dscl localhost delete /Local/Default/Users/mfe
fi
MFEgroup=$(dscl . list /Groups | grep mfe)
if [ $MFEgroup = "mfe" ]; then
dscl localhost delete /Local/Default/Groups/mfe
fi
#check to see if we removed the McAfee 
if [ -d /etc/cma.d/ ];then
echo $(date) "We have found McAfee anti-virus files!" >> /var/log/GSAlog ; exit 1
fi
echo $(date) "Uninstalled McAfee anti-virus"  >> /var/log/GSAlog
}
echo 2
#check for what antivirus exists
if [ -d /Applications/ClamXAV.app ]; then
/usr/sbin/installer -pkg /usr/local/clamXav/ClamXavEngineRemover.pkg -target /
fi
echo 3
if [ -d /Applications/McAfee\ Endpoint\ Security\ for\ Mac.app ]; then
	McAfeeuninstall
elif [ -d /Applications/McAfee\ Endpoint\ Protection\ for\ Mac.app ]; then
	McAfeeuninstall
elif [ -d /etc/cma.d ]; then
	McAfeeuninstall
fi
echo 5
exit 0

