#!/bin/sh

SERVERIP=
PORTNUMBER=

Error()
{
    echo $* > /dev/stderr
}

Echo()
{
    echo $* 
}

Usage()
{
    Echo "Usage: uninstall.sh" 
    Echo " -h  The usage message" 
    Echo "You will need the +++root privileges+++ to uninstall this software"
    Echo "Either +++su to root+++ or use +++sudo cmduninst+++ to uninstall the software"
    exit 2
}

uid=`id -u`
if (( $uid != 0 )); then
    Usage
    exit -1
fi

if (( $# > 0 )); then
    Usage
    exit -1
fi

#if [ -d /etc/cma.d ]; then
#        for i in /etc/cma.d/*
#        do
#                if [ ! -d $i ]; then
#                        continue
#                fi
#                configname=$i/config.xml
#                if [ -f $configname ]; then
#                        productname=`grep "\<ProductName\>" $configname | sed 's/.*<ProductName>\(.*\)<\/ProductName>.*/\1/'`
#                       	isProductCMA=""
#			isProductCMA=`echo $i | grep 'EPOAGENT\|CMNUPD\|CMDAGENT' `
#			UnloadCmaPluginCmd=`grep "\<UnloadCmaPluginCommand\>" $configname | sed 's/.*<UnloadCmaPluginCommand>\(.*\)<\/UnloadCmaPluginCommand>.*/\1/'`
#			if [ -z "$isProductCMA" ]; then
#				
#				if [ "$productname" != "" ]; then
#					echo "For Product Name : $productname"
#				fi
#
#				if [ -n "$UnloadCmaPluginCmd" ]; then
#					$UnloadCmaPluginCmd
#					RC=$?
#					if [ "$RC" == "0" ] ; then
#						echo "Successfully notified $i to unload cma plugins"
#						echo ""
#					fi
#				fi
#			fi
#               fi
#        done
#fi

echo "Stopping agent service"
#SystemStarter stop ma
/Library/McAfee/agent/scripts/ma stop
echo "Done!!!"

echo "Removing agent configuration information"
#rm -rf /Library/Receipts/cma.pkg
rm -rf /Library/StartupItems/ma
rm -rf /Library/StartupItems/cma
rm -rf /Library/LaunchDaemons/com.mcafee.agent.ma.plist
rm -rf /Library/LaunchDaemons/com.mcafee.agent.macompat.plist
rm -rf /Library/LaunchDaemons/com.mcafee.agent.macmn.plist
rm -rf /Library/McAfee/agent
rm -rf /Library/McAfee/cma
rm -rf /Library/McAfee/shared
rm -rf /var/McAfee/agent
rm -rf /var/tmp/.msgbus/ma_*.*
rm -rf /etc/ma.d/EPOAGENT3700MACX
rm -rf /etc/ma.d/CMNUPD__3000
rm -rf /etc/ma.d/EPOAGENT3000
rm -f /etc/ma.d/mainfo.ini
rm -f /etc/ma.conf
rm -f /etc/ma.d/ma_firewall_rules.ini

rm -rf /etc/cma.d/EPOAGENT3700MACX
rm -rf /etc/cma.d/CMNUPD__3000
rm -f /etc/cma.d/bootstrap.xml
rm -f /etc/cma.d/lpc.conf

#rm -f /Library/LaunchDaemons/masvc.plist
#rm -f /Library/LaunchDaemons/macmnsvc.plist
#rm -f /Library/LaunchDaemons/macompatsvc.plist
#create user
MFEAGENT_USR=mfe
MFEAGENT_GROUP=mfe

delete_user()
{
	echo  "Deleting user ($MFEAGENT_USR) & group ($MFEAGENT_GROUP)"
	dscl . -delete /Users/$MFEAGENT_USR
	dscl . -delete /groups/$MFEAGENT_GROUP

}

if [ ! "$(ls -A /etc/ma.d)" ]; then
    rm -rf /etc/ma.d 
fi

if [ ! "$(ls -A /Library/McAfee)" ]; then
    rm -rf /Library/McAfee
fi

pltvrsn=`/usr/bin/sw_vers | grep ProductVersion | cut -d: -f2`
majvrsn=`echo $pltvrsn | cut -d. -f1`
minvrsn=`echo $pltvrsn | cut -d. -f2`
if (($majvrsn>=10 && $minvrsn>=6)); then
	sudo /usr/sbin/pkgutil --forget comp.nai.cmamac > /dev/null 2>&1 
fi
delete_user

#remove ma_healthcheck from cron
#( crontab -l | grep -v "/Library/McAfee/agent/scripts/ma start" ) | crontab -

echo "Agent uninstalled"
exit 0
