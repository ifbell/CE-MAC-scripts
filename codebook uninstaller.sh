#!/bin/bash
##############################
#codebook unistaller
#created by IFBELL 14/08/18
##############################
CBinstall="blank"
#get current user
curruser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

#quit Codebook
osascript -e 'quit app "Codebook"'
sleep 15

#check for codebook installed
CBinstall=$(/usr/sbin/pkgutil --pkgs | grep net.zetetic)

if [[ $CBinstall != "net.zetetic.Strip.mac" ]]; then
echo $(date) "We did not find codebook installed"; exit 0
fi

#remove codebook from the Machine.
rm $curruser/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/net.zetetic.strip.mac.sfl2 

rm -rf $curruser/Library/Application\ Scripts/net.zetetic.Strip.mac 

rm -fdr $currcuser/Library/Group\ Containers/PD7G6HRMGV.net.zetetic.STRIP 

rm -rf $curruser/Library/Containers/net.zetetic.Strip.mac

rm -fdr /Applications/Codebook.app

/usr/sbin/pkgutil --forget net.zetetic.Strip.mac > /dev/null 2>&1 

#complete the uninstall
if [ -d /Applications/Codebook.app ];then
echo $(date) "We have found Codebook files!" >> /var/log/GSAlog ; exit 1
fi
echo $(date) "Uninstalled Codebook"  >> /var/log/GSAlog



