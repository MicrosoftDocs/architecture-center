######################################### Variables #########################################
$subscriptionID = "<target subscription id>"
# This VNet must be on-premises connected
$vnetName ="<vnet name>"
$resourceGroupVNET="<VNET resource group name>"
$clusterSubnet = "<subnet name>"
$ipName = "<LB frontend name>"
$fePool_IP = "<LB internal IP>"
$sqlPool_Name = "<LB Backend name>"
$probe_Name = "<LB probe name>"
$loadBalancerName = "<LB name>"
$loadBalancerLocation = "<azure location>"
$vm1_Name = "<first cluster node name>"
$vm2_Name = "<second cluster node name>"
$vmsResourceGroup = "<cluster nodes resource group>"

# Example values
#$subscriptionID = "2635bfba-ef23-4cc8-9306-3df7c65b7cb0"
#$vnetName ="westcentralusShared-vnet"
#$resourceGroupVNET="westcentralusShared"
#$clusterSubnet = "cluster"
#$ipName = "sqlinternalip"
#$fePool_IP = "10.2.1.8"
#$sqlPool_Name = "sqlpool"
#$probe_Name = "sqlprobe"
#$loadBalancerName = "sqlinternalLB"
#$loadBalancerLocation = "westcentralus"
#$vm1_Name ="clustervm1"
#$vm2_Name ="clustervm2"
#$vmsResourceGroup = "westcentralusShared"

######################################### Login in Azure ####################################

Connect-AzAccount

Set-AzContext -Subscription $subscriptionID

#############################################################################################

######################################### Create Load Balancer ##############################

Write-Output ""
Write-Output "Find virtual network configuration"
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupVNET -Name $vnetname
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $clusterSubnet -VirtualNetwork $VNet
Write-Output ""
Write-Output "Set Load Balancer configurations"
$frontendIP = New-AzLoadBalancerFrontendIpConfig -Name $ipName -PrivateIpAddress $fePool_IP -SubnetId $subnet.id
$beaddresspool= New-AzLoadBalancerBackendAddressPoolConfig -Name $sqlPool_Name
$healthProbe = New-AzLoadBalancerProbeConfig -Name $probe_Name -Protocol TCP -Port 59999 -IntervalInSeconds 15 -ProbeCount 2
$lbrule = New-AzLoadBalancerRuleConfig -Name "SQL" -FrontendIpConfiguration $frontendIP -BackendAddressPool $beAddressPool -Probe $healthProbe -Protocol Tcp -FrontendPort 1433 -BackendPort 1433 -EnableFloating
Write-Output ""
Write-Output "Create Load Balancer"
$sqlLB = New-AzLoadBalancer -ResourceGroupName $resourceGroupVNET -Name $loadBalancerName -Location $loadBalancerLocation -FrontendIpConfiguration $frontendIP `
  -LoadBalancingRule $lbrule -BackendAddressPool $beAddressPool -Probe $healthProbe -sku basic
Write-Output ""
Write-Output "Find virtual machines"
$vm1=Get-AzVM -Name $vm1_Name -ResourceGroupName $vmsResourceGroup
$vm2=Get-AzVM -Name $vm2_Name -ResourceGroupName $vmsResourceGroup
$nic1 = Get-AzNetworkInterface | Where-Object { $_.Id -eq $vm1.NetworkProfile.NetworkInterfaces.id}
$nic2 = Get-AzNetworkInterface | Where-Object { $_.Id -eq $vm2.NetworkProfile.NetworkInterfaces.id}
Write-Output ""
Write-Output "Update Load Balancer backend pool"
$loadbalancer = Get-AzLoadBalancer -Name $loadBalancerName -ResourceGroupName $resourceGroupVNET
$backendPool = Get-AzLoadBalancerBackendAddressPoolConfig `
  -Name $backendPoolName `
  -LoadBalancer $loadBalancer
$nic1.IpConfigurations[0].LoadBalancerBackendAddressPools = $backendPool
$nic2.IpConfigurations[0].LoadBalancerBackendAddressPools = $backendPool
Set-AzNetworkInterface -NetworkInterface $nic1
Set-AzNetworkInterface -NetworkInterface $nic2