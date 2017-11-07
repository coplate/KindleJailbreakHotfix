#!/bin/sh
#
# Kindle Oasis Dispatch Installer
#
# $Id: install-dispatch.sh 13351 2016-07-11 18:01:40Z NiLuJe $
#
##

HACKNAME="jb_dispatch"

# Pull libOTAUtils for logging & progress handling
[ -f ./libotautils5 ] && source ./libotautils5


# Hack specific stuff
MKK_PERSISTENT_STORAGE="/var/local/mkk"
MKK_BACKUP_STORAGE="/mnt/us/mkk"


## Here we go :)
otautils_update_progressbar

# Install the dispatch
logmsg "I" "install" "" "Installing the dispatch"
cp -f dispatch "/usr/bin/logThis.sh"
chmod a+x "/usr/bin/logThis.sh"


otautils_update_progressbar

# Make sure we have enough space left (>512KB) in /var/local first...
logmsg "I" "install" "" "checking amount of free storage space..."
if [ "$(df -k /var/local | awk '$3 ~ /[0-9]+/ { print $4 }')" -lt "512" ] ; then
    logmsg "C" "install" "code=1" "not enough space left in varlocal"
    # Cleanup & exit w/ prejudice
    rm -f dispatch
    return 1
fi

otautils_update_progressbar


# Make sure we have an up to date persistent copy of MKK...
logmsg "I" "install" "" "Creating MKK persistent storage directory"
mkdir -p "${MKK_PERSISTENT_STORAGE}"

otautils_update_progressbar


logmsg "I" "install" "" "Storing dispatch script"
cp -af "/usr/bin/logThis.sh" "${MKK_PERSISTENT_STORAGE}/dispatch.sh"

otautils_update_progressbar


logmsg "I" "install" "" "Setting up backup storage"
# NOTE: Don't wreck the job the bridge install has just done (we're guaranteed to run *after* the bridge install).
mkdir -p "${MKK_BACKUP_STORAGE}"
cp -f "${MKK_PERSISTENT_STORAGE}/dispatch.sh" "${MKK_BACKUP_STORAGE}/dispatch.sh"

otautils_update_progressbar


# Cleanup
rm -f dispatch
logmsg "I" "install" "" "done"

otautils_update_progressbar

return 0
