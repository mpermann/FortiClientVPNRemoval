#!/bin/bash

# Name: FortiClientVPNRemoval.sh
# Version: 1.0.3
# Created: 05-29-2022 by Michael Permann
# Modified: 07-13-2024
# Purpose: Removes the FortiClient VPN software.

CURRENT_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
USER_ID=$(/usr/bin/id -u "$CURRENT_USER")
LOGO="/Library/Management/PCC/Images/PCC1Logo@512px.png"
JAMF_HELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
JAMF_BINARY=$(which jamf)
TITLE="Restart Needed"
DESCRIPTION="Your computer needs restarted to complete the removal.

Click the \"OK\" button to restart your computer. Your computer will restart automatically 1 minute after clicking the \"OK\" button."

BUTTON="OK"
DEFAULT_BUTTON="1"
VPN_REMOVAL_APP="/Applications/FortiClientUninstaller.app/Contents/Library/LaunchServices/com.fortinet.forticlient.uninstall_helper"

if [ -f "$VPN_REMOVAL_APP" ]
then
    echo "FortiClient software present"
    echo "Running com.fortinet.forticlient.uninstall_helper removal app to remove software" # Credit to seb.fisher on MacAdmins Slack #fortinet channel for finding this removal option
    /Applications/FortiClientUninstaller.app/Contents/Library/LaunchServices/com.fortinet.forticlient.uninstall_helper
    echo "Updating inventory"
    "$JAMF_BINARY" recon
    /bin/launchctl asuser "$USER_ID" /usr/bin/sudo -u "$CURRENT_USER" "$JAMF_HELPER" -windowType utility -windowPosition lr -title "$TITLE" -description "$DESCRIPTION" -icon "$LOGO" -button1 "$BUTTON" -defaultButton "$DEFAULT_BUTTON"
    /sbin/shutdown -r +1 &
else
    echo "FortiClient software NOT present"
    echo "Nothing to be removed"
    echo "Updating inventory"
    "$JAMF_BINARY" recon
fi

exit 0