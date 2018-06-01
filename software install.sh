#!/bin/bash
#First attempt at a single installer script
#IFB 04/17/2017

declare -a filearray=("SSH MOTD banner" "Policy Banner installer" "NessusAgent installer"
"VMware Horizon Client installer" "Google Chrome" "GSA Help Folder" "FireEye
installer" "bigfix installer" "Cisco AnyConnect" "ForeScout Agent" "Citrix Receiver" "Desktopimage"
 "McAfee install" "CiscoJabberMac" "Java")
 
 arraycount=${#filearray[@]}
 echo $arraycount
 arraycount=$" "
 for element in ${filearray[@]}
do
   echo $element
done
filearray=( ${filearray[@]/$element} )

for element in ${filearray[@]}
do
let cntnmb=cntnmb+1
   echo kept elements $cntnmb $element
done

arraycount=${#filearray[@]}
echo $arraycount

#start installs of necessary software.
declare -a PolicyArray=( 1,2,,3,4,5,6 )
Policycount=${#filearray[@]}
 echo $Policycount
 arraycount=$" "
 for element in ${filearray[@]}
do
   JAMF policy ID $PolicyArray
done

#check if the policy is still running 

#if finished go to the next policy
 

#check install log to see if we are installing or have completed install.
counter=0
until [ $counter = 1 ]
do
	result=$(grep "$(date +"%b %d")" /var/log/jamftest.log | grep "$pkgname" | cut -d':' -f 4 | sed 's/^ *//g')
	echo $result
	if [ "$result" == "$results2" ]; then 
	counter=1
	fi
done
