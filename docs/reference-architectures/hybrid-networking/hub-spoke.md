---
title: Implementing a hub-spoke network topology in Azure
description: >-
  How to implement a hub-spoke network topology in Azure.
author: telmosampaio
ms.date: 05/05/2017

pnp.series.title: Implement a hub-spoke network topology in Azure
pnp.series.prev: expressroute
---
# Implement a hub-spoke network topology in Azure

This reference architecture shows how to implement a hub-spoke topology in Azure. The *hub* is a virtual network (VNet) in Azure that acts as a central point of connectivity to your on-premises network. The *spokes* are VNets that peer with the hub, and can be used to isolate workloads. Traffic flows between the on-premises datacenter and the hub through an ExpressRoute or VPN gateway connection.  [**Deploy this solution**](#deploy-the-solution).

Typical uses for this architecture include:

* Workloads deployed in different environments, such as development, testing, and production, that require shared services such as DNS, IDS, NTP, or AD DS. Shared services are placed in the hub VNet, while each environment is deployed to a spoke to maintain isolation.
* Workloads that do not require connectivity among themselves, but require access to shared services.
* Enterprises that require central control over security aspects, such as a firewall in the hub as a DMZ, and segregated management for the workloads in each spoke.

![[0]][0]

## Architecture

The architecture consists of the following components.

* **On-premises network**. A private local-area network running within an organization.

* **VPN device**. A device or service that provides external connectivity to the on-premises network. The VPN device may be a hardware device, or a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server 2012. For a list of supported VPN appliances and information on configuring selected VPN appliances for connecting to Azure, see [About VPN devices for Site-to-Site VPN Gateway connections][vpn-appliance].

* **ExpressRoute circuit**. A layer 2 or layer 3 circuit supplied by the connectivity provider that joins the on-premises network with Azure through the edge routers. The circuit uses the hardware infrastructure managed by the connectivity provider.

  > [!NOTE]
  > Our sample deployment uses a VPN connection, instead of an ExpressRoute circuit.

* **ExpressRoute or VPN virtual network gateway**. The virtual network gateway enables the VNet to connect to the ExpressRoute circuit, or VPN device, used for connectivity with your on-premises network. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network][connect-to-an-Azure-vnet].

* **VPN connection**. The connection has properties that specify the connection type (IPSec) and the key shared with the on-premises VPN appliance to encrypt traffic.

* **Hub VNet**. Azure VNet used as the hub in the hub-spoke topology. The hub is the central point of connectivity to your on-premises network, and a place to host services that can be consumed by the different workloads hosted in the spoke VNets.

* **Gateway subnet**. The virtual network gateways are held in the same subnet.

* **Shared services subnet**. A subnet in the hub VNet used to host services that can be shared among all spokes, such as DNS or AD DS.

* **Spoke VNets**. One or more Azure VNets that are used as spokes in the hub-spoke topology. Spokes can be used to isolate workloads in their own VNets, managed separately from other spokes. Each workload might include multiple tiers, with multiple subnets connected through Azure load balancers. For more information about the application infrastructure, see [Running Windows VM workloads][windows-vm-ra] and [Running Linux VM workloads][linux-vm-ra].

* **VNet peering**. You can connect two VNets in the same Azure region using a peering connection. Once peered, paired VNets exchange traffic by using the Azure backbone, without the need of a router. [Virtual networking peering][vnet-peering] connections are non-transitive, low latency connections between VNets. In a hub-spoke network topology, you use VNet peering to connect the hub to each spoke.

You can download a Visio file of this architecture from the [Microsoft download center][visio-download]. This diagram is on the "Hub Spoke" page.

> [!NOTE]
> Azure has two different deployment models: [Resource Manager](/azure/azure-resource-manager/resource-group-overview) and classic. This reference architecture uses Resource Manager, which Microsoft recommends for new deployments.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Resource groups

The hub VNet, and each spoke VNet, can be implemented in different resource groups, and even different subscriptions, as long as they belong to the same Azure tenant in the same Azure region. This allows for a decentralized management of each workload, while sharing services maintained in the hub VNet.

### VNet and GatewaySubnet

Create a subnet named *GatewaySubnet*, with an address range of /27. This subnet is required by the virtual network gateway. Allocating 32 addresses to this subnet will help to prevent reaching gateway size limitations in the future.

For more information about setting up the gateway, see the following reference architectures, depending on your connection type:

- [Hybrid network using ExpressRoute][guidance-expressroute]
- [Hybrid network using a VPN gateway][guidance-vpn]

For higher availability, you can use ExpressRoute plus a VPN for failover. See [Connect an on-premises network to Azure using ExpressRoute with VPN failover][hybrid-ha].

A hub-spoke topology can also be used without a gateway, if you don't need connectivity with your on-premises network. 

### VNet peering

VNet peering is a non-transitive relationship between two VNets. If you require spokes to connect to each other, consider adding a separate peering connection between those spokes.

However, if you have several spokes that need to connect with each other, you will run out of possible peering connections very quickly due to the [limitation on number of VNets peerings per VNet][vnet-peering-limit]. In this scenario, consider using user defined routes (UDRs) to force traffic destined to a spoke to be sent to the gateway at the hub VNet. This will allow the spokes to connect to each other, as shown below.

![[1]][1]

> [!NOTE]
> You can use the sample deployment provided in this document to add these UDRs and make the peering connections transitive. Keep in mind that the bandwidth limitation for your virtual network gateway applies to traffic routed through the gateway.

To allow traffic to flow through the hub from one spoke to another, you need to:

  - Configure the VNet peering connection in the hub to **allow gateway transit**.
  - Configure the VNet peering connection in each spoke to **use remote gateways**.
  - Configure all VNet peering connections to **allow forwarded traffic**.

## Considerations

### Spoke connectivity

If there is no gateway in the hub VNet, and you require connectivity between spokes, consider implementing an NVA for routing in the hub, and using UDRs in the spoke to forward traffic to the hub.

![[2]][2]

In this scenario, you need to configure the peering connections to **allow forwarded traffic**.

### Overcoming VNet peering limits

Make sure you consider the [limitation on number of VNets peerings per VNet][vnet-peering-limit] in Azure. If you decide you need more spokes than the limit will allow, consider creating a hub-spoke-hub-spoke topology, where the first level of spokes also act as hubs. The following diagram shows this approach.

![[3]][3]

## Deploy the solution

A deployment for this architecture is available on [GitHub][ref-arch-repo]. It uses Ubuntu VMs in each VNet to test connectivity. There are no actual services hosted in the **shared-services** subnet in the **hub VNet**.

### Prerequisites

Before you can deploy the reference architecture to your own subscription, execute the steps below.

1. Clone, fork or download the zip file for, the [AzureCAT reference architectures][ref-arch-repo] GitHub repository.

2. If you prefer to use the Azure CLI, make sure you have the Azure CLI 2.0 installed on your computer. To install the CLI, follow the instructions in [Install Azure CLI 2.0][azure-cli-2].

3. If you prefer to use PowerShell, make sure you have the latest PowerShell module for Azure installed on you computer. To install the latest Azure PowerShell module, follow the instructions in [Install PowerShell for Azure][azure-powershell].

4. From a command prompt, bash prompt, or PowerShell prompt, login to your Azure account by using one of the commands below, and follow the prompts.

```bash
az login
```

```powershell
Login-AzureRmAccount
```

### Deploy the simulated on-premises datacenter

To deploy the simulated on-premises datacenter as an Azure VNet, perform the following steps.

1. Switch to the `hybrid-networking\hub-spoke\onprem` folder for the repository you downloaded in the pre-requisites step above.

2. Open the `onprem.vm.parameters.json` file and enter a username and password between the quotes in line 11 and 12, as shown below, then save the file.

```bash
"adminUsername": "XXX",
"adminPassword": "YYY",
```

3. Run the bash or PowerShell command below to deploy the simulated on-premises environment as a VNet in Azure. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./onprem.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-onprem-rg \
  --location westus
```

```powershell
./onprem.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-onprem-rg `
  -Location westus
```
> [!NOTE]
> If you decide to use a different resource group name (other than `ra-onprem-rg`), make sure to search for all parameter files that use that name and edit them to use your own resource group name.

4. Wait for the deployment to finish. This deployment create a virtual network, a virtual machine running Ubuntu, and a VPN gateway. The VPN gateway creation can take more than 40 minutes to complete.

### Azure hub VNet

To deploy the hub VNet, and connect to the simulated on-premises VNet created above, perform the following steps.

1. Switch to the `hybrid-networking\hub-spoke\hub` folder for the repository you downloaded in the pre-requisites step above.

2. Open the `hub.vm.parameters.json` file and enter a username and password between the quotes in line 11 and 12, as shown below, then save the file.

```bash
"adminUsername": "XXX",
"adminPassword": "YYY",
```

3. Open the `hub.gateway.parameters.json` file and enter a shared key between the quotes in line 23, as shown below, then save the file. Keep a note of this value, you will need to use it later in the deployment.

```bash
"sharedKey": "",
```

4. Run the bash or PowerShell command below to deploy the simulated on-premises environment as a VNet in Azure. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./hub.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-hub-rg \
  --location westus
```

```powershell
./hub.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-hub-rg `
  -Location westus
```
> [!NOTE]
> If you decide to use a different resource group name (other than `ra-hub-rg`), make sure to search for all parameter files that use that name and edit them to use your own resource group name.

5. Wait for the deployment to finish. This deployment create a virtual network, a virtual machine running Ubuntu, a VPN gateway, and a connection to the gateway created in the previous section. The VPN gateway creation can take more than 40 minutes to complete.

### Connection from on-premises to the hub

To connect from the simulated on-premises datacenter to the hub VNet, execute the following steps.

1. Switch to the `hybrid-networking\hub-spoke\onprem` folder for the repository you downloaded in the pre-requisites step above.

2. Open the `onprem.connection.parameters.json` file and enter a shared key between the quotes in line 9, as shown below, then save the file. This shared key value must be the same used in the on-premises gateway you deployed previously.

```bash
"sharedKey": "",
```

3. Run the bash or PowerShell command below to deploy the simulated on-premises environment as a VNet in Azure. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./onprem.connection.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-onprem-rg \
  --location westus
```

```powershell
./onprem.connection.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-onprem-rg `
  -Location westus
```
> [!NOTE]
> If you decide to use a different resource group name (other than `ra-onprem-rg`), make sure to search for all parameter files that use that name and edit them to use your own resource group name.

4. Wait for the deployment to finish. This deployment creates a connection between the VNet used to simulate an on-premises datacenter, and the hub VNet.

### Azure spoke VNets

To deploy the spoke VNets, and connect to the hub VNet created above, perform the following steps.

1. Switch to the `hybrid-networking\hub-spoke\spokes` folder for the repository you download in the pre-requisites step above.

2. Open the `spoke1.web.parameters.json` file and enter a username and password between the quotes in line 53 and 54, as shown below, then save the file.

```bash
"adminUsername": "XXX",
"adminPassword": "YYY",
```

3. Repeat the previous step for file `spoke2.web.parameters.json`.

4. Run the bash or PowerShell command below to deploy the first spoke and connect it to the hub. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./spoke.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-spoke1-rg \
  --location westus \
  --spoke 1
```

```powershell
./spoke.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-spoke1-rg `
  -Location westus `
  -Spoke 1
```
> [!NOTE]
> If you decide to use a different resource group name (other than `ra-spoke1-rg`), make sure to search for all parameter files that use that name and edit them to use your own resource group name.

5. Wait for the deployment to finish. This deployment creates a virtual network, a load balancer with three virtual machine running Ubuntu and Apache, and a VNet peering connection to the hub VNet created in the previous section. This deployment may take over 20 minutes.

6. Run the bash or PowerShell command below to deploy the first spoke and connect it to the hub. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./spoke.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-spoke2-rg \
  --location westus \
  --spoke 2
```

```powershell
./spoke.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-spoke2-rg `
  -Location westus `
  -Spoke 2
```
> [!NOTE]
> If you decide to use a different resource group name (other than `ra-spoke2-rg`), make sure to search for all parameter files that use that name and edit them to use your own resource group name.

5. Wait for the deployment to finish. This deployment creates a virtual network, a load balancer with three virtual machine running Ubuntu and Apache, and a VNet peering connection to the hub VNet created in the previous section. This deployment may take over 20 minutes.

### Azure hub VNet peering to spoke VNets

To deploy the VNet peering connections for the hub VNet, perform the following steps.

1. Switch to the `hybrid-networking\hub-spoke\hub` folder for the repository you download in the pre-requisites step above.

2. Run the bash or PowerShell command below to deploy the peering connection to the first spoke. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./hub.peering.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-hub-rg \
  --location westus \
  --spoke 1
```

```powershell
./hub.peering.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-hub-rg `
  -Location westus `
  -Spoke 1
```

2. Run the bash or PowerShell command below to deploy the peering connection to the second spoke. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./hub.peering.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-hub-rg \
  --location westus \
  --spoke 2
```

```powershell
./hub.peering.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-hub-rg `
  -Location westus `
  -Spoke 2
```

### Test connectivity

To verify that the hub-spoke topology connected to an on-premises datacenter deployment worked, follow these steps.

1. From the [Azure portal][portal], connect to your subscription, and navigate to the `ra-onprem-vm1` virtual machine in the `ra-onprem-rg` resource group.

2. In the `Overview` blade, note the `Public IP address` for the VM.

3. Use an SSH client to connect to the IP address you noted above using the user name and password you specified during deployment.

4. From the command promt on the VM you connected to, run the command below to test connectivity from the on-premises VNet to the Spoke1 VNet.

```bash
ping 10.1.1.37
```

### Add connectivity between spokes

If you want to allow spokes to connect to each other, you must deploy UDRs to each spoke that forward traffic destined to other spokes to the gateway in the hub VNet. Execute the following steps to verify that currently you are not able to connect from a spoke to another, then deploy the UDRs and test connectivity again.

1. Repeat steps 1 to 4 above, if you are not connected to the jumpbox VM any longer.

2. Connect to one of the web servers in spoke 1.

```bash
ssh 10.1.1.37
```

3. Test the connectivity between spoke 1 and spoke 2. It should fail.

```bash
ping 10.1.2.37
```

4. Switch back to your computer's command prompt.

5. Switch to the `hybrid-networking\hub-spoke\spokes` folder for the repository you downloaded in the pre-requisites step above.

6. Run the bash or PowerShell command below to deploy an UDR to the first spoke. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./spoke.udr.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-spoke1-rg \
  --location westus \
  --spoke 1
```

```powershell
./spoke.udr.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-spoke1-rg `
  -Location westus `
  -Spoke 1
```

7. Run the bash or PowerShell command below to deploy an UDR to the second spoke. Substitute the values with your subscription, resource group name, and Azure region.

```bash
sh ./spoke.udr.deploy.sh --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --resourcegroup ra-spoke2-rg \
  --location westus \
  --spoke 2
```

```powershell
./spoke.udr.deploy.ps1 -Subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
  -ResourceGroup ra-spoke2-rg `
  -Location westus `
  -Spoke 2
```

8. Switch back to the ssh terminal.

3. Test the connectivity between spoke 1 and spoke 2. It should succeed.

```bash
ping 10.1.2.37
```

<!-- links -->

[azure-cli-2]: /azure/install-azure-cli
[azure-powershell]: /powershell/azure/install-azure-ps?view=azuresmps-3.7.0
[azure-vpn-gateway]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[best-practices-security]: /azure/best-practices-network-securit
[connect-to-an-Azure-vnet]: https://technet.microsoft.com/library/dn786406.aspx
[guidance-expressroute]: ./expressroute.md
[guidance-vpn]: ./vpn.md
[linux-vm-ra]: ../virtual-machines-linux/index.md
[hybrid-ha]: ./expressroute-vpn-failover.md
[naming conventions]: /azure/guidance/guidance-naming-conventions
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview
[vnet-peering]: /azure/virtual-network/virtual-network-peering-overview
[vnet-peering-limit]: /azure/azure-subscription-service-limits#networking-limits
[vpn-appliance]: /azure/vpn-gateway/vpn-gateway-about-vpn-devices
[windows-vm-ra]: ../virtual-machines-windows/index.md

[visio-download]: http://download.microsoft.com/download/1/5/6/1569703C-0A82-4A9C-8334-F13D0DF2F472/RAs.vsdx
[ref-arch-repo]: https://github.com/mspnp/reference-architectures
[0]: ./images/hub-spoke.png "Hub-spoke topology in Azure"
[1]: ./images/hub-spoke-gateway-routing.svg "Hub-spoke topology in Azure with transitive routing"
[2]: ./images/hub-spoke-no-gateway-routing.svg "Hub-spoke topology in Azure with transitive routing using an NVA"
[3]: ./images/hub-spokehub-spoke.svg "Hub-spoke-hub-spoke topology in Azure"
[ARM-Templates]: https://azure.microsoft.com/documentation/articles/resource-group-authoring-templates/