#!/bin/sh

# Modified Carbon Black BIT9 Uninstall Script 20180110 AVB


# Calculate variables dependent upon 10.9 or later
B9EXTDIR="/System/Library/Extensions"
B9KERNELPKG="com.bit9.Bit9Kernel.pkg"

OSVER=`sw_vers -productVersion`
arrOSVER=(${OSVER//./ })

if [ ${arrOSVER[1]} -ge 9 ]; then
B9EXTDIR="/Library/Extensions"
B9KERNELPKG="com.bit9.Bit9Kernel2.pkg"
B9CHECKOTHER="/System/Library/Extensions"
fi

echo "Stopping Bit9 Daemon..."
launchctl unload /Library/LaunchDaemons/com.bit9.Daemon.plist
echo ""
echo "Daemon stopped."

echo ""
echo "Stopping Bit9 Notifier..."
launchctl unload -w /Library/LaunchAgents/com.bit9.Notifier.plist

echo ""
echo "   Notifier stopped."

echo "Stopping the Bit9 Kernel Extension..."
if (test -d "$B9EXTDIR/b9kernel.kext"); then
kextunload $B9EXTDIR/b9kernel.kext &> /dev/null
waitForKext "com.bit9.Kernel "
kextunload $B9EXTDIR/b9kernel.kext/Contents/Plugins/b9kernelkauth.kext &> /dev/null
waitForKext "com.bit9.KernelKauth"
kextunload $B9EXTDIR/b9kernel.kext/Contents/Plugins/b9kernelsupport.kext &> /dev/null
waitForKext "com.bit9.KernelSupport"
rm -fR $B9EXTDIR/b9kernel.kext
fi
if (test -n "$B9CHECKOTHER"); then
if (test -d "$B9CHECKOTHER/b9kernel.kext"); then
kextunload $B9CHECKOTHER/b9kernel.kext &> /dev/null
waitForKext "com.bit9.Kernel "
kextunload $B9CHECKOTHER/b9kernel.kext/Contents/Plugins/b9kernelkauth.kext &> /dev/null
waitForKext "com.bit9.KernelKauth"
kextunload $B9CHECKOTHER/b9kernel.kext/Contents/Plugins/b9kernelsupport.kext &> /dev/null
waitForKext "com.bit9.KernelSupport"
rm -fR $B9CHECKOTHER/b9kernel.kext
fi
fi

echo ""
echo "   Driver stopped."

echo ""
echo "Removing Bit9 files..."
rm /Library/LaunchDaemons/com.bit9.Daemon.plist
rm /Library/LaunchAgents/com.bit9.Notifier.plist
rm -fR /Applications/Bit9
if !(test "$1" = "d") && !(test "$1" == "-d"); then
rm -fR "/Library/Application Support/com.bit9.Agent"
fi

echo ""
echo "   Bit9 files removed."

echo ""
echo "Removing Bit9 Installer Packages..."
pkgutil --forget com.bit9.Bit9Agent.pkg
pkgutil --forget $B9KERNELPKG
pkgutil --forget com.bit9.Bit9Daemon.pkg
pkgutil --forget com.bit9.Bit9Notifier.pkg
echo ""
echo "   Bit9 Installer Packages removed."
echo ""
echo $(date) "Bit9 Uninstall Completed." >> /var/log/GSAlog
