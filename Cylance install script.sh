#!/bin/sh
## Cylance install script.
## written by IFBELL 07/01/18
##

if [ -e /usr/local/GSAfiles/CylancePROTECT.pkg ]; then
/usr/sbin/installer -pkg /usr/local/GSAfiles/CylancePROTECT.pkg -target /
else
echo $(date) "Cylance installer is missing" >> /var/log/GSAerrorlog; exit 1

rm /usr/local/GSAfiles/CylancePROTECT.pkg
rm /usr/local/GSAfiles/cyagent_install_token
mv /Applications/Cylance/Uninstall\ CylancePROTECT.app /usr/local/GSAfiles/

pkgFile=$(pkgutil --pkgs | grep com.cylance)
if [ $pkgFile = "com.cylance.agent" ]; then pkgNumb=1;fi
if [ -d /Applications/Cylance/CylanceUI.app ]; then appNumb=1;fi
#echo $pkgNumb $appNumb


if [ $pkgNumb = $appNumb  ]; then
echo $(date) "CylancePROTECT installed." >> /var/log/GSAlog; exit 0
else  
open -a /usr/local/GSAfiles/Uninstall\ CylancePROTECT.app
fi

#exit 0		## Success
#exit 1		## Failure