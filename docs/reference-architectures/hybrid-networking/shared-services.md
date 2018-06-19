---
title: Implementing a hub-spoke network topology with shared services in Azure
description: >-
  How to implement a hub-spoke network topology with shared services in Azure.
author: telmosampaio
ms.date: 02/25/2018

pnp.series.title: Implement a hub-spoke network topology with shared services in Azure
pnp.series.prev: hub-spoke
---
# Implement a hub-spoke network topology with shared services in Azure

This reference architecture builds on the [hub-spoke][guidance-hub-spoke] reference architecture to include shared services in the hub that can be consumed by all spokes. As a first step toward migrating a datacenter to the cloud, and building a [virtual datacenter], the first services you need to share are identity and security. This reference architecture shows you how to extend your Active Directory services from your on-premises datacenter to Azure, and how to add a network virtual appliance (NVA) that can act as a firewall, in a hub-spoke topology.  [**Deploy this solution**](#deploy-the-solution).

![[0]][0]

*Download a [Visio file][visio-download] of this architecture*

The benefits of this topology include:

* **Cost savings** by centralizing services that can be shared by multiple workloads, such as network virtual appliances (NVAs) and DNS servers, in a single location.
* **Overcome subscriptions limits** by peering VNets from different subscriptions to the central hub.
* **Separation of concerns** between central IT (SecOps, InfraOps) and workloads (DevOps).

Typical uses for this architecture include:

* Workloads deployed in different environments, such as development, testing, and production, that require shared services such as DNS, IDS, NTP, or AD DS. Shared services are placed in the hub VNet, while each environment is deployed to a spoke to maintain isolation.
* Workloads that do not require connectivity to each other, but require access to shared services.
* Enterprises that require central control over security aspects, such as a firewall in the hub as a DMZ, and segregated management for the workloads in each spoke.

## Architecture

The architecture consists of the following components.

* **On-premises network**. A private local-area network running within an organization.

* **VPN device**. A device or service that provides external connectivity to the on-premises network. The VPN device may be a hardware device, or a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server 2012. For a list of supported VPN appliances and information on configuring selected VPN appliances for connecting to Azure, see [About VPN devices for Site-to-Site VPN Gateway connections][vpn-appliance].

* **VPN virtual network gateway or ExpressRoute gateway**. The virtual network gateway enables the VNet to connect to the VPN device, or ExpressRoute circuit, used for connectivity with your on-premises network. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network][connect-to-an-Azure-vnet].

> [!NOTE]
> The deployment scripts for this reference architecture use a VPN gateway for connectivity, and a VNet in Azure to simulate your on-premises network.

* **Hub VNet**. Azure VNet used as the hub in the hub-spoke topology. The hub is the central point of connectivity to your on-premises network, and a place to host services that can be consumed by the different workloads hosted in the spoke VNets.

* **Gateway subnet**. The virtual network gateways are held in the same subnet.

* **Shared services subnet**. A subnet in the hub VNet used to host services that can be shared among all spokes, such as DNS or AD DS.

* **DMZ subnet**. A subnet in the hub VNet used to host NVAs that can act as security appliances, such as firewalls.

* **Spoke VNets**. One or more Azure VNets that are used as spokes in the hub-spoke topology. Spokes can be used to isolate workloads in their own VNets, managed separately from other spokes. Each workload might include multiple tiers, with multiple subnets connected through Azure load balancers. For more information about the application infrastructure, see [Running Windows VM workloads][windows-vm-ra] and [Running Linux VM workloads][linux-vm-ra].

* **VNet peering**. Two VNets in the same Azure region can be connected using a [peering connection][vnet-peering]. Peering connections are non-transitive, low latency connections between VNets. Once peered, the VNets exchange traffic by using the Azure backbone, without the need for a router. In a hub-spoke network topology, you use VNet peering to connect the hub to each spoke.

> [!NOTE]
> This article only covers [Resource Manager](/azure/azure-resource-manager/resource-group-overview) deployments, but you can also connect a classic VNet to a Resource Manager VNet in the same subscription. That way, your spokes can host classic deployments and still benefit from services shared in the hub.

## Recommendations

All the recommendations for the [hub-spoke][guidance-hub-spoke] reference architecture also apply to the shared services reference architecture. 

ALso, the following recommendations apply for most scenarios under shared services. Follow these recommendations unless you have a specific requirement that overrides them.

### Identity

Most enterprise organizations have an Active Directory Directory Services (ADDS) environment in their on-premises datacenter. To facilitate management of assets moved to Azure from your on-premises network that depend on ADDS, it is recommended to host ADDS domain controllers in Azure.

If you make use of Group Policy Objects, that you want to control separately for Azure and your on-premises environment, use a different AD site for each Azure region. Place your domain controllers in a central VNet (hub) that dependent workloads can access.

### Security

As you move workloads from your on-premises environment to Azure, some of these workloads will require to be hosted in VMs. For compliance reasons, you may need to enforce restrictions on traffic traversing those workloads. 

You can use network virtual appliances (NVAs) in Azure to host different types of security and performance services. If you are familiar with a given set of appliances on-premises today, it is recommended to use the same virtualized appliances in Azure, where applicable.

> [!NOTE]
> The deployment scripts for this reference architecture use an Ubuntu VM with IP forwarding enabled to mimic a network virtual appliance.

## Considerations

### Overcoming VNet peering limits

Make sure you consider the [limitation on number of VNets peerings per VNet][vnet-peering-limit] in Azure. If you decide you need more spokes than the limit will allow, consider creating a hub-spoke-hub-spoke topology, where the first level of spokes also act as hubs. The following diagram shows this approach.

![[3]][3]

Also consider what services are shared in the hub, to ensure the hub scales for a larger number of spokes. For instance, if your hub provides firewall services, consider the bandwidth limits of your firewall solution when adding multiple spokes. You might want to move some of these shared services to a second level of hubs.

## Deploy the solution

A deployment for this architecture is available on [GitHub][ref-arch-repo]. It uses Ubuntu VMs in each VNet to test connectivity. There are no actual services hosted in the **shared-services** subnet in the **hub VNet**.

The deployment creates the following resource groups in your subscription:

- hub-adds-rg
- hub-nva-rg
- hub-vnet-rg
- onprem-vnet-rg
- spoke1-vnet-rg
- spoke2-vent-rg

The template parameter files refer to these names, so if you change them, update the parameter files to match.

### Prerequisites

Before you can deploy the reference architecture to your own subscription, you must perform the following steps.

1. Clone, fork, or download the zip file for the [reference architectures][ref-arch-repo] GitHub repository.

2. Make sure you have the Azure CLI 2.0 installed on your computer. For CLI installation instructions, see [Install Azure CLI 2.0][azure-cli-2].

3. Install the [Azure building blocks][azbb] npm package.

4. From a command prompt, bash prompt, or PowerShell prompt, login to your Azure account by using the command below, and follow the prompts.

   ```bash
   az login
   ```

### Deploy the simulated on-premises datacenter using azbb

To deploy the simulated on-premises datacenter as an Azure VNet, follow these steps:

1. Navigate to the `hybrid-networking\shared-services-stack\` folder for the repository you downloaded in the pre-requisites step above.

2. Open the `onprem.json` file. 

3. Search for all instances of `Password` and `adminPassword`. Enter values for the user name and password in the parameters and save the file. 

4. Run the following command:

   ```bash
   azbb -s <subscription_id> -g onprem-vnet-rg -l <location> -p onprem.json --deploy
   ```
5. Wait for the deployment to finish. This deployment creates a virtual network, a virtual machine running Windows, and a VPN gateway. The VPN gateway creation can take more than 40 minutes to complete.

### Deploy the hub VNet

To deploy the hub VNet, and connect to the simulated on-premises VNet created above, perform the following steps.

1. Open the `hub-vnet.json` file. 

2. Search for `adminPassword` and enter a user name and password in the parameters. 

3. Search for all instances of `sharedKey` and enter a value for a shared key. Save the file.

   ```bash
   "sharedKey": "abc123",
   ```

4. Run the following command:

   ```bash
   azbb -s <subscription_id> -g hub-vnet-rg -l <location> -p hub-vnet.json --deploy
   ```

5. Wait for the deployment to finish. This deployment creates a virtual network, a virtual machine, a VPN gateway, and a connection to the gateway created in the previous section. The VPN gateway creation can take more than 40 minutes to complete.

### Deploy AD DS in Azure

To deploy the AD DS domain controllers in Azure, perform the following steps.

1. Open the `hub-adds.json` file.

2. Search for all instances of `Password` and `adminPassword`. Enter values for the user name and password in the parameters and save the file. 

3. Run the following command:

   ```bash
   azbb -s <subscription_id> -g hub-adds-rg -l <location> -p hub-adds.json --deploy
   ```
  
This deployment step may take several minutes, because it requires joining the two VMs to the domain hosted in the simulated on-premises datacenter, then installing AD DS on them.

### Deploy an NVA

To deploy an NVA in the `dmz` subnet, perform the following steps:

1. Open the `hub-nva.json` file.

2. Search for `adminPassword` and enter a user name and password in the parameters. 

3. Run `azbb` the following command:

   ```bash
   azbb -s <subscription_id> -g hub-nva-rg -l <location> -p hub-nva.json --deploy
   ```

### Azure spoke VNets

To deploy the spoke VNets, perform the following steps.

1. Open the `spoke1.json` file.

2. Search for `adminPassword` and enter a user name and password in the parameters. 

3. Run the following command:

   ```bash
   azbb -s <subscription_id> -g spoke1-vnet-rg -l <location> -p spoke1.json --deploy
   ```
  
4. Repeat steps 1 and 2 for the file `spoke2.json`.

5. Run the following command:

   ```bash
   azbb -s <subscription_id> -g spoke2-vnet-rg -l <location> -p spoke2.json --deploy
   ```

### Peer the hub VNet to the spoke VNets

To create a peering connection from the hub VNet to the spoke VNets, run the following command:

```bash
azbb -s <subscription_id> -g hub-vnet-rg -l <location> -p hub-vnet-peering.json --deploy
```

<!-- links -->

[azure-cli-2]: /azure/install-azure-cli
[azbb]: https://github.com/mspnp/template-building-blocks/wiki/Install-Azure-Building-Blocks
[guidance-hub-spoke]: ./hub-spoke.md
[azure-vpn-gateway]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[best-practices-security]: /azure/best-practices-network-securit
[connect-to-an-Azure-vnet]: https://technet.microsoft.com/library/dn786406.aspx
[guidance-expressroute]: ./expressroute.md
[guidance-vpn]: ./vpn.md
[linux-vm-ra]: ../virtual-machines-linux/index.md
[hybrid-ha]: ./expressroute-vpn-failover.md
[naming conventions]: /azure/guidance/guidance-naming-conventions
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview
[virtual datacenter]: https://aka.ms/vdc
[vnet-peering]: /azure/virtual-network/virtual-network-peering-overview
[vnet-peering-limit]: /azure/azure-subscription-service-limits#networking-limits
[vpn-appliance]: /azure/vpn-gateway/vpn-gateway-about-vpn-devices
[windows-vm-ra]: ../virtual-machines-windows/index.md

[visio-download]: https://archcenter.blob.core.windows.net/cdn/hybrid-network-hub-spoke.vsdx
[ref-arch-repo]: https://github.com/mspnp/reference-architectures
[0]: ./images/shared-services.png "Shared services topology in Azure"
[3]: ./images/hub-spokehub-spoke.svg "Hub-spoke-hub-spoke topology in Azure"
[ARM-Templates]: https://azure.microsoft.com/documentation/articles/resource-group-authoring-templates/
