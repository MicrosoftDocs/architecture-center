######################################### Variables #########################################
$subscriptionID = "<target subscription id>"
$resourceGroupVM = "<resource group for the VM>"
$location = "<azure location>"
$rdgruleName ="RDP_3389"
$nsgName = "<VM NSG name>"
# This VNet must be on-premises connected
$vnetName ="<vnet name>"
$resourceGroupVNET="<VNET resource group name>"
$clusterSubnet = "<subnet name>"
$vNICBaseName = "<VM VNIC base name>"
 Private IP - Remember that first three VNet IP are Azure reserved
$clusterPrivateIP1="<VM 1 Private IP>"
$clusterPrivateIP2="<VM 2 Private IP>"
$avsetname ="<Availability Set Name>"
$vmNameBase = "<VM base name>"

# Example values
#$subscriptionID = "2635bfba-ef23-4cc8-9306-3df7c65b7cb0"
#$resourceGroupVM = "westcentralusShared"
#$location = "westcentralus"
#$rdgruleName ="RDP_3389"
#$sqlgruleName ="SQL_1433"
#$nsgName = "clusterNSG"
## This VNet must be on-premises connected
#$vnetName ="westcentralusShared-vnet"
#$resourceGroupVNET="westcentralusShared"
#$clusterSubnet = "cluster"
#$vNICBaseName = "clusterNIC"
## Private IP - Remember that first three VNet IP are Azure reserved
#$clusterPrivateIP1="10.2.1.4"
#$clusterPrivateIP2="10.2.1.5"
#$avsetname ="clusteravset"
#$vmNameBase = "clustervm"

#############################################################################################

######################################### Login in Azure ####################################

Connect-AzAccount

Set-AzContext -Subscription $subscriptionID

#############################################################################################

######################################### Create Virtual Machines ###########################

$cred = Get-Credential -Message "Enter a username and password for the virtual machines."

Write-Output "Create inbound network security group rules for ports 3389 and 1433"
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name $rdgruleName -Protocol Tcp  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * `
  -DestinationAddressPrefix *  -DestinationPortRange 3389 -Access Allow
# Below rule is not need because default NSG rules already allow communication. It is used as placeholder to remember the SQL Server communication port
$nsgRuleSQL = New-AzNetworkSecurityRuleConfig -Name $sqlgruleName -Protocol Tcp  -Direction Inbound -Priority 1100 -SourceAddressPrefix VirtualNetwork -SourcePortRange * `
  -DestinationAddressPrefix *  -DestinationPortRange 1433 -Access Allow

# Remove proximy placement group
Write-Output ""
Write-Output "Create a network security group"
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupVM -Location $location  -Name $nsgName -SecurityRules $nsgRuleRDP,$nsgRuleSQL
Write-Output ""
Write-Output "Find virtual network configuration"
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupVNET -Name $vnetname
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $clusterSubnet -VirtualNetwork $VNet
Write-Output ""
Write-Output "Create an availability set and associate with the proximity placement group"
$aset = New-AzAvailabilitySet -ResourceGroupName $resourceGroupVM -Name $avsetname -Location $location -Sku Aligned -PlatformUpdateDomainCount 2 -PlatformFaultDomainCount 2

For ($i=1; $i -le 2; $i++) {
    $ip = Get-Variable -Name "clusterPrivateIP$i" -ValueOnly
    $IPconfig = New-AzNetworkInterfaceIpConfig -Name "IPConfig$i" -PrivateIpAddressVersion IPv4 -PrivateIpAddress $ip -SubnetId $subnet.Id
    Write-Output ""
    Write-Output "Create a network interface card for $vmNameBase$i"
    $nic = New-AzNetworkInterface -Name "$vNICBaseName$i" -ResourceGroupName $resourceGroupVM -Location $location -IpConfiguration $IPconfig -NetworkSecurityGroupId $nsg.Id
    $vmConfig = New-AzVMConfig -VMName "$vmNameBase$i" -VMSize Standard_B2S -AvailabilitySetId $aset.Id| Set-AzVMOperatingSystem -Windows -ComputerName "$vmNameBase$i" `
      -Credential $cred | Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2008-R2-SP1 -Version latest | Add-AzVMNetworkInterface -Id $nic.Id
    Set-AzVMBootDiagnostic -VM $vmConfig -Disable
    Write-Output ""
    Write-Output "Create Virtual Machine $vmNameBase$i"
    New-AzVM -ResourceGroupName $resourceGroupVM -Location $location -VM $vmConfig -LicenseType Windows_Server
}
