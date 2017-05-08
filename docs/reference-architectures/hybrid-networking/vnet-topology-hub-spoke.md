---
title: Implementing a hub-spoke topology in Azure
description: >-
  How to implement a hub-spoke network topoly in Azure.
author: telmosampaio
ms.service: guidance
ms.topic: article
ms.date: 05/05/2017
ms.author: pnp

pnp.series.title: Implement a hub-spoke network topology in Azure
pnp.series.prev: expressroute
cardTitle: Improving availability
---
# Implement a hub-spoke topology in Azure

This reference architecture shows how to implement a hub-spoke topology in Azure, using the hub as a gateway between Azure and your on-premises datacenter.

Traffic flows between the on-premises datacenter and Azure through an ExpressRoute or VPN gateway connection. This connection is made to a hub virtual network (VNet) in Azure, which in turn is peered to other VNets in the same Azure region, as seen in the piture below.[**Deploy this solution**](#deploy-the-solution).

> [!NOTE]
> Azure has two different deployment models: [Resource Manager](/azure/azure-resource-manager/resource-group-overview) and classic. This reference architecture uses Resource Manager, which Microsoft recommends for new deployments.

Typical uses for this architecture include:

* Workloads deployed in different environments (development, testing, production) that require the specific services that can be shared (in the hub VNet) while maintaining isolation (deployed to spokes).
* Workloads that do not require connectivity among themselves, but require access to shared services, such as DNS, AD DS, firewall, among others.
* Enterprises that require a central control over security aspects (firewall in the hub as a DMZ), and segregated management for each workload (individual spokes).

## Architecture

The following diagram highlights the important components in this architecture:

> A Visio document that includes this architecture diagram is available for download from the [Microsoft download center][visio-download]. This diagram is on the "Hub Spoke" page.

![[0]][0]

The hub VNet, and each spoke VNet, can be implemented in different resource groups, and even different subscriptions, as long as they belong to the same Azure tenant in the same Azure region. This allows for a decentralized management of each workload, while sharing services maintained in the hub VNet. However, if you have several spokes that need to connect to the same hub, you will run out of possible peering connections very quickly due to the [limitation on number of VNets peerings per VNet][vnet-peering-limit].

The architecture consists of the following components.

* **On-premises network**. A private local-area network running within an organization.

* **VPN device**. A device or service that provides external connectivity to the on-premises network. The VPN device may be a hardware device, or it can be a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server 2012. For a list of supported VPN appliances and information on configuring selected VPN appliances for connecting to Azure, see [About VPN devices for Site-to-Site VPN Gateway connections][vpn-appliance].

* **ExpressRoute circuit**. A layer 2 or layer 3 circuit supplied by the connectivity provider that joins the on-premises network with Azure through the edge routers. The circuit uses the hardware infrastructure managed by the connectivity provider.

> [!NOTE]
> Our sample reference architecture uses a VPN connection, instead of an ExpressRoute circuit.

* **ExpressRoute virtual network gateway**. The ExpressRoute virtual network gateway enables the VNet to connect to the ExpressRoute circuit used for connectivity with your on-premises network.

* **Virtual network gateway**. The  virtual network gateway enables the VNet to connect to the VPN appliance in the on-premises network, or routers used for an ExpressRoute circuit. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network][connect-to-an-Azure-vnet].

* **VPN connection**. The connection has properties that specify the connection type (IPSec) and the key shared with the on-premises VPN appliance to encrypt traffic.

* **Hub virtual network (VNet)**. Azure VNet used as a hub in a hub-spoke topology. The hub is used as a central point of connectivity to your on-premises network, and a place to host services that can be consumed by different workloads hosted in spoke VNets.

    * **Gateway subnet**. The virtual network gateways are held in the same subnet.

    * **Shared services subnet**. A subnet in the hub VNet used to host services that can be shared among all spokes, such as DNS, AD DS, among others.

* **VNet peering**. You can connect two VNets in the same Azure region using a peering connection. Once peered, paired VNets exchange traffic by using the Azure backbone, without the need of a router. [Virtual networking peering][vnet-peering] connections are non-transitive, low latency connections between VNets.

* **Spoke VNet**. Azure VNet used as a spoke in a hub-spoke topology. Spokes can be used to isolate wrokloads in their VNets, that can be managed separatly from other spokes. Each workload might include multiple tiers, with multiple subnets connected through Azure load balancers. For more information about the application infrastructure, see [Running Windows VM workloads][windows-vm-ra] and [Running Linux VM workloads][linux-vm-ra].

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### VNet and GatewaySubnet

Create the ExpressRoute virtual network gateway and the VPN virtual network gateway in the same VNet. This means that they should share the same subnet named *GatewaySubnet*.

If the VNet already includes a subnet named *GatewaySubnet*, ensure that it has a /27 or larger address space, so that you can add both an ExpressRoute gateway, and a VPN gateway, for [higher availability][hybrid-ha].

### VNet peering

VNet peering is a non-transitive relationship between two VNets. If you require spokes to connect to each other, consider adding a separate peering connection between those spokes.

However, if you have several spokes that need to connect with each other, you will run out of possible peering connections very quickly due to the [limitation on number of VNets peerings per VNet][vnet-peering-limit]. In this scenario, consider using user defined routes (UDRs) to force traffic destined to a spoke to be sent to the gateway at the hub VNet. This will allow the spokes to connect to each other, as shown below.

![[1]][1]

> [!NOTE]
> You can use the sample deployment provided in this document to add these UDRs and make the peering connections transitive.

To allow traffic to flow through the hub from one spoke to another, you need to:

  - Configure the VNet peering connection in the hub to **allow gateway transit**.
  - Configure the VNet peering connection in each spoke to **use remote gateways**.
  - Configure all VNet peering connections to **allow forwarded traffic**.

## Considerations

### Spoke connectivity

If you require connectivity between spokes, and you do **NOT** have a gateway in the hub VNet, consider implementing an NVA for routing in the hub, and using UDRs in the spoke to forward traffic to the hub, as seen below.

![[2]][2]

In this scenario, you need to configure the peering connections to **allow forwarded traffic**.

### Overcoming VNet peering limits

Make sure you consider the [limitation on number of VNets peerings per VNet][vnet-peering-limit] in Azure. If you decide you need more spokes than the limit will allow, consider creating a hub-spokehub-spoke topology, where the first level of spokes act as hubs, as shown below.

![[3]][3]

### Connection to your on-premises datacenter

For ExpressRoute considerations, see the [Implementing a Hybrid Network Architecture with Azure ExpressRoute][guidance-expressroute] guidance.

For site-to-site VPN considerations, see the [Implementing a Hybrid Network Architecture with Azure and On-premises VPN][guidance-vpn] guidance.

## Deploy the solution

The reference architecture deployed below uses simple Ubuntu VMs in each VNet to test connectivity. There are no actual services hosted in the **shared-services** subnet in the **hub VNet**.

### Pre-requisites

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

### Connection from on-prem to Azure hub

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

3. Test the connectivity between spoke 1 and spoke 2. It should suceed.

```bash
ping 10.1.2.37
```

<!-- links -->

[windows-vm-ra]: ../virtual-machines-windows/index.md
[linux-vm-ra]: ../virtual-machines-linux/index.md
[vnet-peering]: /azure/virtual-network/virtual-network-peering-overview
[hybrid-ha]: /expressroute-vpn-failover.md
[vnet-peering-limit]: /azure/azure-subscription-service-limits#networking-limits
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview
[vpn-appliance]: /azure/vpn-gateway/vpn-gateway-about-vpn-devices
[azure-vpn-gateway]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[connect-to-an-Azure-vnet]: https://technet.microsoft.com/library/dn786406.aspx
[best-practices-security]: /azure/best-practices-network-securit
[naming conventions]: /azure/guidance/guidance-naming-conventions
[visio-download]: http://download.microsoft.com/download/1/5/6/1569703C-0A82-4A9C-8334-F13D0DF2F472/RAs.vsdx
[azure-cli-2]: /azure/install-azure-cli
[azure-powershell]: /powershell/azure/install-azure-ps?view=azuresmps-3.7.0
[ref-arch-repo]: https://github.com/mspnp/reference-architectures
[0]: ./images/hub-spoke.png "Hub-spoke topology in Azure"
[1]: ./images/hub-spoke-gateway-routing.png "Hub-spoke topology in Azure with transitive routing"
[2]: ./images/hub-spoke-no-gateway-routing.png "Hub-spoke topology in Azure with transitive routing using an NVA"
[3]: ./images/hub-spokehub-spoke.png "Hub-spokehub-spoke topology in Azure"
[ARM-Templates]: https://azure.microsoft.com/documentation/articles/resource-group-authoring-templates/