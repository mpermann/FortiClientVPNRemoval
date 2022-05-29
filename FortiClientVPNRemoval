#!/bin/bash

# Name: FortiClientVPNRemoval.sh
# Date: 05-29-2022
# Author: Michael Permann
# Version: 1.0
# Purpose: Removes the FortiClient VPN software.

CURRENT_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
USER_ID=$(/usr/bin/id -u "$CURRENT_USER")
LOGO="/Library/Application Support/HeartlandAEA11/Images/HeartlandLogo@512px.png"
JAMF_HELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
JAMF_BINARY=$(which jamf)
TITLE="Uninstall Application"
DESCRIPTION="The FortiClient VPN will be removed. 

1. Click the \"Uninstall\" button on the FortiClient Uninstaller dialog. 
2. Enter your computer password and click the \"Install Helper\" button.
3. Click the \"Done\" button to close FortiClient Uninstaller.

Then click the \"OK\" button to dismiss this dialog."
BUTTON1="OK"
DEFAULT_BUTTON="1"
TITLE1="Restart Needed"
DESCRIPTION1="Your computer needs restarted to complete the removal.

Click the \"OK\" button to restart your computer. Your computer will restart automatically after 1 minute."
VPN_APP="/Applications/FortiClient.app/Contents/MacOS/FortiClient"

if [ -f "$VPN_APP" ]
then
    echo "FortiClient software present"
    echo "Launching FortiClientUninstaller.app"
    /bin/launchctl asuser "$USER_ID" /usr/bin/sudo -u "$CURRENT_USER" "/usr/bin/open" "/Applications/FortiClientUninstaller.app"
    /bin/launchctl asuser "$USER_ID" /usr/bin/sudo -u "$CURRENT_USER" "$JAMF_HELPER" -windowType utility -windowPosition lr -title "$TITLE" -description "$DESCRIPTION" -icon "$LOGO" -button1 "$BUTTON1" -defaultButton "$DEFAULT_BUTTON"
    echo "Updating inventory"
    "$JAMF_BINARY" recon
    /bin/launchctl asuser "$USER_ID" /usr/bin/sudo -u "$CURRENT_USER" "$JAMF_HELPER" -windowType utility -windowPosition lr -title "$TITLE1" -description "$DESCRIPTION1" -icon "$LOGO" -button1 "$BUTTON1" -defaultButton "$DEFAULT_BUTTON"
    /sbin/shutdown -r +1 &
else
    echo "FortiClient software NOT present"
    echo "Nothing to be removed"
    echo "Updating inventory"
    "$JAMF_BINARY" recon
fi

exit 0