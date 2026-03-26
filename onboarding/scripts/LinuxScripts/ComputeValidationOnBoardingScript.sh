#!/bin/sh

# Why these steps are not in Bicep:
# 1. though we can register features[1], we are unable to register providers[2]
# 2. @onlyIfNotExists() does not work for Microsoft.Authorization/roleDefinitions[3]
#
# [1] https://learn.microsoft.com/azure/templates/microsoft.features/featureproviders/subscriptionfeatureregistrations
# [2] https://github.com/Azure/bicep/issues/3267
# [3] https://github.com/Azure/bicep/issues/18373

set -eu

: ${SUB:=$(az account show --query id --output tsv)}
: ${APP:=f877b90d-59ee-40e3-8d2c-215dae4c80d8}

SP=$(az ad sp show --id $APP --query id --output tsv)

register_feature () {
	az feature register --only-show-errors --namespace $1 --name $2 --output none
	until [ $(az feature show --namespace $1 --name $2 --query properties.state --output tsv) = Registered ]; do
		sleep 3
	done
}

register_feature Microsoft.Validate SelfServeVMImageValidation
for N in Microsoft.Validate Microsoft.Resources; do
	az provider register --subscription $SUB --namespace $N --output none --wait
done

register_feature Microsoft.AzureImageTestingForLinux JobandJobTemplateCrud
for N in Microsoft.Compute Microsoft.Network Microsoft.Storage; do
	az provider register --subscription $SUB --namespace $N --output none --wait
done

DID=$(az role definition list --name 'AITL Delegator' --query '[0].id' --output tsv)
[ "$DID" ] || DID=$({ sed -e 's/\s\+#.*//' | az role definition create --role-definition @- --query id --output tsv; } <<EOF
{
  "Name": "AITL Delegator",
  "Description": "Delegation role is to run test cases and upload logs in Azure Image Testing for Linux (AITL).",
  "Actions": [
    "Microsoft.Resources/subscriptions/resourceGroups/read",
    "Microsoft.Resources/subscriptions/resourceGroups/write",
    "Microsoft.Resources/subscriptions/resourceGroups/delete",
    "Microsoft.Resources/deployments/read",
    "Microsoft.Resources/deployments/write",
    "Microsoft.Resources/deployments/validate/action",
    "Microsoft.Resources/deployments/operationStatuses/read",
    "Microsoft.Compute/virtualMachines/read",
    "Microsoft.Compute/virtualMachines/write",
    "Microsoft.Compute/virtualMachines/retrieveBootDiagnosticsData/action",
    # for availability set testing
    "Microsoft.Compute/availabilitySets/write",
    # for verify GPU PCI device count should be same after stop-start
    "Microsoft.Compute/virtualMachines/start/action",
    "Microsoft.Compute/virtualMachines/restart/action",
    "Microsoft.Compute/virtualMachines/deallocate/action",
    "Microsoft.Compute/virtualMachines/powerOff/action",
    # for testing hot adding disk
    "Microsoft.Compute/disks/read",
    "Microsoft.Compute/disks/write",
    "Microsoft.Compute/disks/delete",
    "Microsoft.Compute/images/read",
    "Microsoft.Compute/images/write",
    # for testing ARM64 VHD and gallery image
    "Microsoft.Compute/galleries/images/read",
    "Microsoft.Compute/galleries/images/write",
    "Microsoft.Compute/galleries/images/delete",
    "Microsoft.Compute/galleries/images/versions/read",
    "Microsoft.Compute/galleries/images/versions/write",
    "Microsoft.Compute/galleries/images/versions/delete",
    "Microsoft.Compute/galleries/read",
    "Microsoft.Compute/galleries/write",
    # for test VM extension running
    "Microsoft.Compute/virtualMachines/extensions/read",
    "Microsoft.Compute/virtualMachines/extensions/write",
    "Microsoft.Compute/virtualMachines/extensions/delete",
    # for verify_vm_assess_patches
    "Microsoft.Compute/virtualMachines/assessPatches/action",
    # for VM resize test suite
    "Microsoft.Compute/virtualMachines/vmSizes/read",
    # For disk_support_restore_point & verify_vmsnapshot_extension
    "Microsoft.Compute/restorePointCollections/write",
    # For verify_vmsnapshot_extension
    "Microsoft.Compute/restorePointCollections/restorePoints/read",
    "Microsoft.Compute/restorePointCollections/restorePoints/write",
    "Microsoft.ManagedIdentity/userAssignedIdentities/write",
    # For verify_azsecpack
    "Microsoft.ManagedIdentity/userAssignedIdentities/assign/action",
    "Microsoft.Network/virtualNetworks/read",
    "Microsoft.Network/virtualNetworks/write",
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/publicIPAddresses/read",
    "Microsoft.Network/publicIPAddresses/write",
    "Microsoft.Network/publicIPAddresses/join/action",
    "Microsoft.Network/networkInterfaces/read",
    "Microsoft.Network/networkInterfaces/write",
    "Microsoft.Network/networkInterfaces/join/action",
    # for verify_dpdk_l3fwd_ntttcp_tcp to set up Azure route table
    "Microsoft.Network/routeTables/read",
    "Microsoft.Network/routeTables/write",
    # for verify_azure_file_share_nfs mount and delete
    "Microsoft.Network/privateEndpoints/write",
    "Microsoft.Network/privateLinkServices/PrivateEndpointConnectionsApproval/action",  # noqa: E501
    # for verify_serial_console write operation
    "Microsoft.SerialConsole/serialPorts/write",
    # For setting firewall rules to access Microsoft tenant VMs
    "Microsoft.Network/networkSecurityGroups/write",
    "Microsoft.Network/networkSecurityGroups/read",
    "Microsoft.Network/networkSecurityGroups/join/action",
    "Microsoft.Storage/storageAccounts/read",
    "Microsoft.Storage/storageAccounts/write",
    "Microsoft.Storage/storageAccounts/listKeys/action",
    "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
    "Microsoft.Storage/storageAccounts/blobServices/containers/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/write",
    "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action",  # noqa: E501
  ],
  "DataActions": [
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
  ],
  "AssignableScopes": [
    "/subscriptions/$SUB"
  ]
}
EOF
)
az role assignment create \
	--assignee-principal-type ServicePrincipal \
	--assignee-object-id $SP \
	--scope /subscriptions/$SUB \
	--role $DID \
	--output none

JID=$(az role definition list --name 'AITL Jobs Access' --query '[0].id' --output tsv)
[ "$JID" ] || JID=$({ sed -e 's/\s\+#.*//' | az role definition create --role-definition @- --query id --output tsv; } <<EOF
{
  "Name": "AITL Jobs Access",
  "Description": "Job access role for Azure Image Testing for Linux (AITL).",
  "Actions": [
    "Microsoft.AzureImageTestingForLinux/jobTemplates/read",
    "Microsoft.AzureImageTestingForLinux/jobTemplates/write",
    "Microsoft.AzureImageTestingForLinux/jobTemplates/delete",
    "Microsoft.AzureImageTestingForLinux/jobs/read",
    "Microsoft.AzureImageTestingForLinux/jobs/write",
    "Microsoft.AzureImageTestingForLinux/jobs/delete",
    "Microsoft.AzureImageTestingForLinux/operations/read",
    "Microsoft.Resources/subscriptions/read",
    "Microsoft.Resources/subscriptions/operationresults/read",
    "Microsoft.Resources/subscriptions/resourcegroups/write",
    "Microsoft.Resources/subscriptions/resourcegroups/read",
    "Microsoft.Resources/subscriptions/resourcegroups/delete"
  ],
  "AssignableScopes": [
    "/subscriptions/$SUB"
  ]
}
EOF
)
az role assignment create \
	--assignee-principal-type ServicePrincipal \
	--assignee-object-id $SP \
	--scope /subscriptions/$SUB \
	--role $JID \
	--output none

exit 0
