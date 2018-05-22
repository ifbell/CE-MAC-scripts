#!/bin/sh
# Check for ROOT privileges
if [ "$(/usr/bin/id -u)" != "0" ]; then
/bin/echo "BESAgentUninstall.sh must be run as root or with sudo" 1>&2
exit 1
fi

logFile="/Library/Logs/BESAgent.log"
Log()
{
/bin/echo "`/bin/date`( ${SUDO_USER:-$USER} ): $1" >> $logFile
}

if [ -f /Library/LaunchDaemons/BESAgentDaemon.plist ]; then
/bin/echo "Stopping BESAgent"
Log "Unloading BESAgent from launchctl"
/bin/launchctl unload /Library/LaunchDaemons/BESAgentDaemon.plist 2>&1 >> /dev/console

# Wait while the client cleanly exits
sAgentPIDLine="`/bin/ps -axww -o pid,command | /usr/bin/grep -v $0 | /usr/bin/grep \"MacOS/BESAgent\" | /usr/bin/sed -e '/grep/d'`"
if [ "$sAgentPIDLine" != "" ]; then
Log "Confirming BESAgent shut down"
waitCount=15
while [ $waitCount -gt 0 ]; do
sAgentPIDLine="`/bin/ps -axww -o pid,command | /usr/bin/grep -v $0 | /usr/bin/grep \"MacOS/BESAgent\" | /usr/bin/sed -e '/grep/d'`"
if [ "$sAgentPIDLine" == "" ]; then
break
fi
waitCount=`expr "$waitCount" - 1`
/bin/sleep 1
done
sAgentPIDLine="`/bin/ps -axww -o pid,command | /usr/bin/grep -v $0 | /usr/bin/grep \"MacOS/BESAgent\" | /usr/bin/sed -e '/grep/d'`"
if [ "$sAgentPIDLine" != "" ]; then
sAgentPID=`/bin/echo "$sAgentPIDLine" | /usr/bin/awk '{ print $1 }'`
Log "BESAgent did not exit, Killing process: $sAgentPID"
/bin/kill -9 $sAgentPID
fi
fi

/bin/echo "Uninstalling BESAgent"
if [ -f /usr/sbin/pkgutil ]; then
Log "Removing installer receipts from package database"
/usr/sbin/pkgutil --forget com.bigfix.BESAgent >> $logFile 2>/dev/null
/usr/sbin/pkgutil --forget com.bigfix.BESAgentDaemon >> $logFile 2>/dev/null
/usr/sbin/pkgutil --forget com.bigfix.TriggerClientUI >> $logFile 2>/dev/null
/usr/sbin/pkgutil --forget com.bigfix.properties >> $logFile 2>/dev/null
/usr/sbin/pkgutil --forget com.bigfix.ICUData >> $logFile 2>/dev/null
/usr/sbin/pkgutil --forget com.bigfix.SWTAG >> $logFile 2>/dev/null
fi

Log "Removing BESAgent from /Library/LaunchDaemons"
rm -rf /Library/LaunchDaemons/BESAgentDaemon.plist
Log "Removing the data directory: /Library/Application Support/BigFix"
rm -rf "/Library/Application Support/BigFix"

Log "Removing BESAgent preferences"
rm -rf /Library/Preferences/com.bigfix.BESAgent*

Log "Removing BESAgent user specific preferences"
rm -rf /Users/*/Library/Preferences/com.bigfix.BESAgent*

Log "Removing BESAgent from /Library"
rm -rf /Library/BESAgent

Log "Removing the TriggerClientUI app"
rm -rf /Applications/TriggerBESClientUI.app
rm -rf /Applications/TriggerClientUI.app

Log "Removing BESClientUI user cache directories"
rm -rf /var/tmp/BES

Log "Removing our installer packages if present"
rm -rf /Library/Receipts/BESAgent*.pkg
rm -rf /Library/Receipts/Agent.pkg
rm -rf /Library/Receipts/TivoliEndpointManager.pkg
rm -rf /Library/Receipts/IBMEndpointManager.pkg
exit 0
else
Log "Uninstall run without registered BESAgent"
/bin/echo "No BESAgent registered with launchctl"
exit 2
fi

