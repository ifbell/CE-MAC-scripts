#!/bin/sh
## Cylance install script.
## written by IFBELL 07/01/18
##
# check that the installer is in place
if [ -e /usr/local/GSAfiles/CylancePROTECT.pkg ]; then
/usr/sbin/installer -pkg /usr/local/GSAfiles/CylancePROTECT.pkg -target /
else
echo $(date) "Cylance installer is missing" >> /var/log/GSAerrorlog; exit 1

# clean up files.
rm /usr/local/GSAfiles/CylancePROTECT.pkg
rm /usr/local/GSAfiles/cyagent_install_token

# check if files are installed 
pkgFile=$(pkgutil --pkgs | grep com.cylance)
if [ $pkgFile = "com.cylance.agent" ]; then pkgNumb=1;fi
if [ -d /Applications/Cylance/CylanceUI.app ]; then 
appNumb=1
else 
appNumb=0
fi

# finish up install or erase 
if [ $pkgNumb = $appNumb  ]; then
echo $(date) "CylancePROTECT installed." >> /var/log/GSAlog; rm /Applications/Cylance/Uninstall\ CylancePROTECT.app ; exit 0
else  
open -a /Applications/Cylance/Uninstall\ CylancePROTECT.app
fi

#exit 0		## Success
#exit 1		## Failure