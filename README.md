# Config Converter

Repository for bash scripts that convert config files for Jenkins pipeline to work with appropriate node

## Config parameters

To adapt the configuration for desired node change the following variables

- `CHASSIS_ID`: ChassisID found in first line of saved config file
- `HOSTNAME`: Hostname of the node
- `IP_ADDRESS`: IP address of the node
- `IP_MASK`: IP address mask
- `DEFAULT_ROUTE`: Default route for the node
- `USERNAME`: Administrator account name for node management (e.g. kubebot)
- `PASSWORD`: Password to administrator account (e.g. same as kubebot secret configured onK8s cluster)

> For proper script usage paste hashed variable from the node in single quotes `''`

- `TECH_SUPPORT_PASSWORD`: Tech support password
- `SSH_KEY`: SSH key generated on the node

> For proper script usage paste hashed variable from the node in single quotes `''`, add `\\n` after each slash (`\`) & fold into single line

- `SSH_KEY_LENGTH`: SSH key length for the generated key on the node
- `PORT_SLOT`: Port slot number
- `PORT_PORT`: Port number for the selected slot
- `LICENSE_KEY`: Key license for the node. Best practice to copy it each time from the node before script usage

> For proper script usage paste hashed variable from the node in single quotes `''`, add `\\n` after each slash (`\`) & fold into single line

## Changes in base config doing by script

This script changes the following parameters from base config

- Config file headline
- Tech-support password
- License key
- System hostname & autoconfirm 
- SSH keys
- User account
- Default route
- Port number
