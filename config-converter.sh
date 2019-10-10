#!/bin/bash

# Declaration of node variables
LICENSE_KEY='\\\nLICENSE_KEY\\'
CHASSIS_ID="CHASSIS_ID"
HOSTNAME="HOSTNAME"
IP_ADDRESS="IP_ADDRESS"
IP_MASK="IP_MASK"
DEFAULT_ROUTE="DEFAULT_ROUTE"
USERNAME="USERNAME"
PASSWORD='PASSWORD'
TECH_SUPPORT_PASSWORD='TECH_SUPPORT_PASSWORD'
SSH_KEY='SSH_KEY'
SSH_KEY_LENGTH="SSH_KEY_LENGTH"
PORT_SLOT="PORT_SLOT"
PORT_PORT="PORT_PORT"

# Script input arguments
BASE_FILE=$1
PLATFORM=$2

# Validation of input arguments
# If 2 arguments ar given
if [[ ($# == 2) ]]; then
	# Check if ${BASE_FILE} exists in current folder
	ls ${BASE_FILE} > /dev/null 2>&1
	# If ls returns other value than 0
	if [[ ($? != 0) ]]; then
		# No file in folder, inform user & exit
		echo "ERROR: No base config file found in current folder to modify\n"
		exit 2
	fi
	# Check if platform is from falid range
	if ! [[ (${PLATFORM} == 'gw') || (${PLATFORM} == 'sgsn-mme') ]]; then
		# Platform not in allowed options, so inform user & exit
		echo "ERROR: Wrong platform chosen\nChoose one from following:\n\tsgsn-mme | gw\n"
		exit 2
	fi
else
	echo "ERROR: Not enough arguments provided to run the script\nUsage: script.sh [BASE_FILE] [PLATFORM]\n"
	exit 2
fi

# Set target file name
TARGET_FILE="${HOSTNAME}-${PLATFORM}-${BASE_FILE}"
# Copy base file to target file for convertion
cp ${BASE_FILE} ${TARGET_FILE}
echo "==============================="
# Change config in ${TARGET_FILE} according template based on node config
# Change config file headline
echo "Changing chassis ID"
sed -i "1 s/\(.* \).*/\1${CHASSIS_ID}/" ${TARGET_FILE}
# Set proper tech-support password
echo "Changing tech-support password"
sed -i "s/\(tech-support test-commands\).*/\1 password ${TECH_SUPPORT_PASSWORD}/" ${TARGET_FILE}
# Set license key
echo "Changing license key"
sed -i -e "/license key.*/,/.*\"/c\  license key \"${LICENSE_KEY}\"" ${TARGET_FILE}
# Set proper hostname & enable autoconfirm option
echo "Changing hostname"
sed -i -e "s/\(system hostname\).*/\1 ${HOSTNAME}\n  autoconfirm/" ${TARGET_FILE}
# Set an IP address
echo "Changing IP address"
sed -i "0,/.*ip address.*/s/\(.*ip address\).*/\1 ${IP_ADDRESS} ${IP_MASK}/" ${TARGET_FILE}
# Change SSH key
echo "Changing SSH keys"
sed -i -e "/ssh key.*/,/len.*type v2-rsa/c\    ssh key ${SSH_KEY}\n len ${SSH_KEY_LENGTH} type v2-rsa" ${TARGET_FILE}
# Add user account
echo "Changing administrator user account"
sed -i "0,/ administrator.*/s/\( administrator\).*/\1 ${USERNAME} password ${PASSWORD} ftp/" ${TARGET_FILE}
# Configure default route
echo "Changing default route"
sed -i -e "s/\(ip route 0.0.0.0 0.0.0.0\).* \(.*\)/\1 ${DEFAULT_ROUTE} \2/" ${TARGET_FILE}
# Set proper port number
echo "Changing port configuraiton"
sed -i "0,/.*port ethernet.*/s/\(.*port ethernet\).*/\1 ${PORT_SLOT}\/${PORT_PORT}/" ${TARGET_FILE}

# Prepare create file with implemated changes
diff ${BASE_FILE} ${TARGET_FILE} > diff_${TARGET_FILE}

# Summary to user
echo "==============================="
echo "Convertion COMPLETE"
echo "Base file: ${BASE_FILE}"
echo "Target file: ${TARGET_FILE}"
echo "Diff file: diff_${TARGET_FILE}"