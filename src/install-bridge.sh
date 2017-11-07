#!/bin/sh
#
# Kindle Touch/PaperWhite JailBreak Bridge Installer
#
# $Id: install-bridge.sh 11185 2014-11-29 15:57:11Z NiLuJe $
#
##

HACKNAME="jb_bridge"

# Pull libOTAUtils for logging & progress handling
[ -f ./libotautils5 ] && source ./libotautils5


# Hack specific stuff
MKK_PERSISTENT_STORAGE="/var/local/mkk"
RP_PERSISTENT_STORAGE="/var/local/rp"
MKK_BACKUP_STORAGE="/mnt/us/mkk"
RP_BACKUP_STORAGE="/mnt/us/rp"


## Here we go :)
otautils_update_progressbar

# Install the bridge
logmsg "I" "install" "" "Installing the bridge"
cp -f bridge "/var/local/system/fixup"
chmod a+x "/var/local/system/fixup"

otautils_update_progressbar

# Make sure we have enough space left (>512KB) in /var/local first...
logmsg "I" "install" "" "checking amount of free storage space..."
if [ "$(df -k /var/local | awk '$3 ~ /[0-9]+/ { print $4 }')" -lt "512" ] ; then
    logmsg "C" "install" "code=1" "not enough space left in varlocal"
    # Cleanup & exit w/ prejudice
    rm -f bridge
    rm -f developer.keystore
    rm -f json_simple-1.1.jar
    rm -f gandalf
    rm -f bridge.conf
    return 1
fi

otautils_update_progressbar

# Make sure we have an up to date persistent copy of MKK...
logmsg "I" "install" "" "Creating MKK persistent storage directory"
mkdir -p "${MKK_PERSISTENT_STORAGE}"

otautils_update_progressbar

logmsg "I" "install" "" "Storing combined developer keystore"
cp -f developer.keystore "${MKK_PERSISTENT_STORAGE}/developer.keystore"

otautils_update_progressbar

logmsg "I" "install" "" "Storing kindlet jailbreak"
cp -f json_simple-1.1.jar "${MKK_PERSISTENT_STORAGE}/json_simple-1.1.jar"

otautils_update_progressbar

logmsg "I" "install" "" "Storing gandalf"
cp -f gandalf "${MKK_PERSISTENT_STORAGE}/gandalf"

otautils_update_progressbar

logmsg "I" "install" "" "Setting up gandalf"
chmod a+x "${MKK_PERSISTENT_STORAGE}/gandalf"
chmod +s "${MKK_PERSISTENT_STORAGE}/gandalf"
ln -sf "${MKK_PERSISTENT_STORAGE}/gandalf" "${MKK_PERSISTENT_STORAGE}/su"

otautils_update_progressbar

logmsg "I" "install" "" "Installing bridge job"
cp -f bridge.conf "/etc/upstart/bridge.conf"
chmod 0664 "/etc/upstart/bridge.conf"

otautils_update_progressbar

logmsg "I" "install" "" "Storing bridge job"
cp -af "/etc/upstart/bridge.conf" "${MKK_PERSISTENT_STORAGE}/bridge.conf"

otautils_update_progressbar

logmsg "I" "install" "" "Storing bridge script"
cp -af "/var/local/system/fixup" "${MKK_PERSISTENT_STORAGE}/bridge.sh"

otautils_update_progressbar

logmsg "I" "install" "" "Setting up persistent RP"
mkdir -p "${RP_PERSISTENT_STORAGE}"
for my_job in debrick cowardsdebrick ; do
    if [ -f "/etc/upstart/${my_job}.conf" ] ; then
        cp -af "/etc/upstart/${my_job}.conf" "${RP_PERSISTENT_STORAGE}/${my_job}.conf"
    fi
    if [ -f "/etc/upstart/${my_job}" ] ; then
        cp -af "/etc/upstart/${my_job}" "${RP_PERSISTENT_STORAGE}/${my_job}"
    fi
done

otautils_update_progressbar

logmsg "I" "install" "" "Setting up backup storage"
rm -rf "${MKK_BACKUP_STORAGE}"
mkdir -p "${MKK_BACKUP_STORAGE}"
rm -rf "${RP_BACKUP_STORAGE}"
mkdir -p "${RP_BACKUP_STORAGE}"
# Can't preserve symlinks & permissions on vfat, so do it the hard way ;).
for my_file in ${MKK_PERSISTENT_STORAGE}/* ; do
	if [ -f ${my_file} -a ! -L ${my_file} ] ; then
		cp -f "${my_file}" "${MKK_BACKUP_STORAGE}/"
	fi
done
for my_file in ${RP_PERSISTENT_STORAGE}/* ; do
	if [ -f ${my_file} -a ! -L ${my_file} ] ; then
		cp -f "${my_file}" "${RP_BACKUP_STORAGE}/"
	fi
done

otautils_update_progressbar

# Cleanup
rm -f bridge
rm -f developer.keystore
rm -f json_simple-1.1.jar
rm -f gandalf
rm -f bridge.conf
logmsg "I" "install" "" "done"

otautils_update_progressbar

return 0
