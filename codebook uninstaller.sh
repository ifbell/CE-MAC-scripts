#!/bin/bash
#codebook unistaller
#created by IFBELL 14/08/18
##############################
#check for codebook installed
CBinstall="blank"
CBinstall=$(/usr/sbin/pkgutil --pkgs | grep net.zetetic)
if [[ $CBinstall != "net.zetetic.Strip.mac" ]]; then
echo $(date) "We did not find codebook installed"; exit 0
fi

rm ~/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/net.zetetic.strip.mac.sfl2 

rm -rf ~/Library/Application\ Scripts/net.zetetic.Strip.mac 

rm -rf ~/Library/Group\ Containers/PD7G6HRMGV.net.zetetic.STRIP 

rm -rf ~/Library/Containers/net.zetetic.Strip.mac

rm -fdr /Applications/Codebook.app

/usr/sbin/pkgutil --forget net.zetetic.Strip.mac > /dev/null 2>&1 

if [ -d /Applications/Codebook.app ];then
echo $(date) "We have found Codebook files!" >> /var/log/GSAlog ; exit 1
fi
echo $(date) "Uninstalled Codebook"  >> /var/log/GSAlog

