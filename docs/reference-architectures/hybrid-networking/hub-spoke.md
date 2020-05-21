---
title: Hub-spoke network topology in Azure
titleSuffix: Azure Reference Architectures
description: This reference architecture deploys a hub-spoke network topology in Azure.
author: adamboeglin
ms.date: 05/21/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - networking
  - management-and-governance
ms.subservice: reference-architecture
ms.custom: seodec18, networking, fcp
---

# Hub-spoke network topology in Azure

This reference architecture shows how to implement a hub-spoke topology in Azure. The *hub* is a virtual network in Azure that acts as a central point of connectivity to your on-premises network. The *spokes* are virtual networks that peer with the hub, and can be used to isolate workloads. Traffic flows between the on-premises datacenter and the hub through an ExpressRoute or VPN gateway connection. [**Deploy this solution**](#deploy-the-solution).

![[0]][0]

*Download a [Visio file][visio-download] of this architecture*

The benefits of this topology include:

- **Cost savings** by centralizing services that can be shared by multiple workloads, such as network virtual appliances (NVAs) and DNS servers, in a single location.
- **Overcome subscriptions limits** by peering virtual networks from different subscriptions to the central hub.
- **Separation of concerns** between central IT (SecOps, InfraOps) and workloads (DevOps).

Typical uses for this architecture include:

- Workloads deployed in different environments, such as development, testing, and production, that require shared services such as DNS, IDS, NTP, or AD DS. Shared services are placed in the hub virtual network, while each environment is deployed to a spoke to maintain isolation.
- Workloads that do not require connectivity to each other, but require access to shared services.
- Enterprises that require central control over security aspects, such as a firewall in the hub as a DMZ, and segregated management for the workloads in each spoke.

## Architecture

The architecture consists of the following components.

- **On-premises network**. A private local-area network running within an organization.

- **VPN device**. A device or service that provides external connectivity to the on-premises network. The VPN device may be a hardware device, or a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server 2012. For a list of supported VPN appliances and information on configuring selected VPN appliances for connecting to Azure, see [About VPN devices for Site-to-Site VPN Gateway connections][vpn-appliance].

- **VPN virtual network gateway or ExpressRoute gateway**. The virtual network gateway enables the virtual network to connect to the VPN device, or ExpressRoute circuit, used for connectivity with your on-premises network. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network][connect-to-an-Azure-vnet].

   > [!NOTE]
   > The deployment scripts for this reference architecture use a VPN gateway for connectivity, and a virtual network in Azure to simulate your on-premises network.

- **Hub virtual network**. The virtual network used as the hub in the hub-spoke topology. The hub is the central point of connectivity to your on-premises network, and a place to host services that can be consumed by the different workloads hosted in the spoke virtual networks.

- **Gateway subnet**. The virtual network gateways are held in the same subnet.

- **Spoke virtual networks**. One or more virtual networks that are used as spokes in the hub-spoke topology. Spokes can be used to isolate workloads in their own virtual networks, managed separately from other spokes. Each workload might include multiple tiers, with multiple subnets connected through Azure load balancers. For more information about the application infrastructure, see [Running Windows VM workloads][windows-vm-ra] and [Running Linux VM workloads][linux-vm-ra].

- **Virtual network peering**. Two virtual networks can be connected using a [peering connection][vnet-peering]. Peering connections are non-transitive, low latency connections between virtual networks. Once peered, the virtual networks exchange traffic by using the Azure backbone, without the need for a router. In a hub-spoke network topology, you use virtual network peering to connect the hub to each spoke. You can peer virtual networks in the same region, or different regions. For more information, see [Requirements and constraints][vnet-peering-requirements].

> [!NOTE]
> This article only covers [Resource Manager](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-overview) deployments, but you can also connect a classic virtual network to a Resource Manager virtual network in the same subscription. That way, your spokes can host classic deployments and still benefit from services shared in the hub.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Resource groups

The hub and each spoke can be implemented in different resource groups, and even different subscriptions. When you peer virtual networks in different subscriptions, both subscriptions can be associated to the same or different Azure Active Directory tenant. This allows for a decentralized management of each workload, while sharing services maintained in the hub.

### Virtual network and GatewaySubnet

Create a subnet named *GatewaySubnet*, with an address range of /27. This subnet is required by the virtual network gateway. Allocating 32 addresses to this subnet will help to prevent reaching gateway size limitations in the future.

For more information about setting up the gateway, see the following reference architectures, depending on your connection type:

- [Hybrid network using ExpressRoute][guidance-expressroute]
- [Hybrid network using a VPN gateway][guidance-vpn]

For higher availability, you can use ExpressRoute plus a VPN for failover. See [Connect an on-premises network to Azure using ExpressRoute with VPN failover][hybrid-ha].

A hub-spoke topology can also be used without a gateway, if you don't need connectivity with your on-premises network.

### Virtual network peering

Virtual network peering is a non-transitive relationship between two virtual networks. If you require spokes to connect to each other, consider adding a separate peering connection between those spokes.

However, if you have several spokes that need to connect with each other, you will run out of possible peering connections very quickly due to the limitation on number of virtual network peerings per virtual network. (For more information, see [Networking limits][vnet-peering-limit].) In this scenario, consider using user defined routes (UDRs) to force traffic destined to a spoke to be sent to Azure Firewall or an NVA acting as a router at the hub. This will allow the spokes to connect to each other.

You can also configure spokes to use the hub gateway to communicate with remote networks. To allow gateway traffic to flow from spoke to hub, and connect to remote networks, you must:

- Configure the peering connection in the hub to **allow gateway transit**.
- Configure the peering connection in each spoke to **use remote gateways**.
- Configure all peering connections to **allow forwarded traffic**.

for additional information on [Create a peering](/azure/virtual-network/virtual-network-manage-peering#create-a-peering)

## Considerations

### Spoke connectivity

If you require connectivity between spokes, consider deploying Azure Firewall or an NVA for routing in the hub, and using UDRs in the spoke to forward traffic to the hub. The deployment steps below include an optional step that sets up this configuration. 

![[2]][2]

In this scenario, you must configure the peering connections to **allow forwarded traffic**.

You can also use a VPN gateway to route traffic between spokes, although this will have impacts in terms of latency and throughput. Also, Azure Firewall or a network firewall appliance provides an additional layer of security.

Also consider what services are shared in the hub, to ensure the hub scales for a larger number of spokes. For instance, if your hub provides firewall services, consider the bandwidth limits of your firewall solution when adding multiple spokes. You might want to move some of these shared services to a second level of hubs.

## DevOps considerations

In this architecture the entire networking infrastructure is created by using an [Azure Building Blocks][azbb] template, so it follows the IaC process for deploying the resources. To automate infrastructure deployment, you can use Azure DevOps Services or other CI/CD solutions. The deployment process is also idempotent - that is, repeatable to produce the same results. 

Templates are also good for dependency tracking since they allow to define dependencies for resources that are deployed in the same template. For a given resource, there can be other resources that must exist before the resource is deployed.

### Network monitoring

Use the Network Watcher to monitor and troubleshoot the network components, tools like Traffic Analytics will show you the systems in your virtual networks that generate most traffic, so that you can visually identify bottlenecks before they degenerate into problems. Network Performance Manager is the aduquate tool to monitor information about Microsoft ExpressRoute circuits. VPN diagnostics is another tool that can help troubleshooting site-to-site VPN connections connecting your applications to users on-premises.


For more information see [Monitoring For DevOps][devops-monitoring] in the Azure Architecure Framework.

### Network testing

This architecture includes some testing steps to manually verify network connectivity, it uses jump box virtual machines in each virtual network. After the deployment is completed, use these instructions along with the network monitoring tools, to verify the correct operation of the network.

For more information, see the DevOps section in [Azure Architecture Framework][AAF-devops].


## Cost considerations

Centralizing services that can be shared by multiple workloads in a single location can be cost efficient.

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

### Azure Firewall

In this architecture, Azure Firewall is deployed in the hub, which provides an additional layer of security. Azure Firewall is cost effective, especially if it's used as a shared solution consumed by multiple workloads. Here are the Azure Firewall pricing models:
- Fixed rate per deployment hour.
- Data processed per GB to support auto scaling. 

When compared to network virtual appliances (NVAs), with Azure Firewall you can save up to 30-50%. For more information see [Azure Firewall vs NVA][Firewall-NVA].

### Virtual network peering

You can use virtual network peering to route traffic between virtual networks by using private IP addresses. Here are some points:

- Ingress and egress traffic is charged at both ends of the peered networks. 
- Different zones have different transfer rates.

   For instance, data transfer from a virtual network in zone 1 to another virtual network in zone 2, will incur outbound transfer rate for zone 1 and inbound rate for zone 2. For more information, see [Virtual network pricing][VN-pricing].

## Deploy the solution

> [!CAUTION]
> "Don't use azbb - it is in sustain mode and the npm package is out of date"

A deployment for this architecture is available on [GitHub][ref-arch-repo]. It uses VMs in each virtual network to test connectivity. Two instances of each jumpbox are deployed &mdash; one Linux VM and one Windows VM. In a real deployment, you would deploy a single type. 

No shared services are deployed in the hub. For a version that includes shared services, see [Hub-spoke network topology with shared services in Azure](./shared-services.md).

The deployment creates the following resource groups in your subscription:

- hub-vnet-rg
- onprem-jb-rg
- onprem-vnet-rg
- spoke1-vnet-rg
- spoke2-vnet-rg

### Prerequisites

[!INCLUDE [ref-arch-prerequisites.md](../../../includes/ref-arch-prerequisites.md)]

### Deploy the reference architecture

Follow these steps to deploy the architecture:

1. Navigate to the `hybrid-networking/hub-spoke` folder of the reference architectures repository.

1. Open the `hub-spoke.json` file. 

1. Replace the values for all instances of `[replace-with-username]` and `[replace-with-password]`.

    ```json
    "adminUsername": "[replace-with-username]",
    "adminPassword": "[replace-with-password]",
    ```

1. Find both instances of `[replace-with-shared-key]` and enter a shared key for the VPN connection. The values must match.

    ```json
    "sharedKey": "[replace-with-shared-key]",
    ```

1. Save the file.

1. Run the following command:

    ```bash
    azbb -s <subscription_id> -g onprem-vnet-rg -l <location> -p hub-spoke.json --deploy
    ```

1. Wait for the deployment to finish. This deployment creates four virtual networks, eight VMs, two VPN gateways, the connection between the two VPN gateways, and configures virtual network peering. It can take about 40 minutes to create the VPN gateways.

### Test connectivity &mdash; Windows

To test connectivity from the simulated on-premises environment to the hub and spokes using Windows, follow these steps:

1. Use the Azure portal to find the VM named `jb-vm1` in the `onprem-jb-rg` resource group.

2. Click `Connect` to open a remote desktop session to the VM. Use the password that you specified in the `hub-spoke.json` parameter file.

3. Open a PowerShell console in the VM, and use the `Test-NetConnection` cmdlet to verify that you can connect to the jumpbox VM in the hub.

   ```powershell
   Test-NetConnection 10.0.0.36 -CommonTCPPort RDP
   ```

   The output should look similar to the following:

   ```powershell
   ComputerName     : 10.0.0.36
   RemoteAddress    : 10.0.0.36
   RemotePort       : 3389
   InterfaceAlias   : Ethernet 2
   SourceAddress    : 192.168.1.000
   TcpTestSucceeded : True
   ```

3. Use the `Test-NetConnection` cmdlet to verify that you can connect to the jumpbox VMs in the spokes.

   ```powershell
   Test-NetConnection 10.1.0.36 -CommonTCPPort RDP
   Test-NetConnection 10.2.0.36 -CommonTCPPort RDP
   ```

> [!NOTE]
> By default, Windows Server VMs do not allow ICMP responses in Azure. If you want to use `ping` to test connectivity, enable ICMP traffic in the Windows Advanced Firewall for each VM.

### Test connectivity &mdash; Linux

To test connectivity from the simulated on-premises environment to the hub and spokes using Linux, follow these steps:

1. Use the Azure portal to find the VM named `jbl-vm1` in the `onprem-jb-rg` resource group.

2. Click `Connect` and copy the `ssh` command shown in the portal.

3. Run `ssh` to connect to the simulated on-premises environment. Use the password that you specified in the `hub-spoke.json` parameter file.

4. Use the `nc` command to test connectivity to the jumpbox VM in the hub:

   ```shell
   nc -vzw 1 10.0.0.37 22
   ```

   The output should look similar to the following:

   ```shell
   Connection to 10.0.0.37 22 port [tcp/ssh] succeeded!
   ```

4. Use the `nc` command to test connectivity to the jumpbox VMs in each spoke:

   ```bash
   nc -vzw 1 10.1.0.37 22
   nc -vzw 1 10.2.0.37 22
   ```

### Add connectivity between spokes

This step is optional. If you want to allow spokes to connect to each other, use [Azure Firewall](https://docs.microsoft.com/azure/firewall/) to force traffic from spokes to the router when trying to connect to another spoke. Perform the following steps to deploy Azure Firewall, firewall rules to allow RDP and SSH, and user-defined routes (UDRs) to allow the two spoke virtual networks to connect:

1. Navigate to the `hybrid-networking/hub-spoke` folder of the reference architectures repository.

2. Run the following command:

    ```bash
    azbb -s <subscription_id> -g hub-vnet-rg -l <location> -p hub-firewall.json --deploy
    ```

> [!NOTE]
> The private IP address of the Azure Firewall is set to 10.0.0.132. This will be the IP address for this deployment due to the way Azure allocates private IP addresses. Any modifications to this deployment may change this default address. In that situation, edit the `hub-firewall.json` route tables and replace all instances of `nextHop` in the routes to point to the correct private IP address of Azure Firewall.

### Test connectivity between spokes &mdash; Windows

If you connected the spokes, perform these steps to verify connectivity using Windows:

1. Use the Azure portal to find the VM named `jb-vm1` in the `onprem-jb-rg` resource group.

2. Click `Connect` to open a remote desktop session to the VM. Use the password that you specified in the `hub-spoke.json` parameter file.

3. From inside this remote desktop session, open another remote desktop session to 10.1.0.36. That's the private IP address of the jumpbox in spoke 1. 

4. From the second remote desktop session, open a PowerShell console. Use the `Test-NetConnection` cmdlet to verify that you can connect to the jumpbox VM in spoke 2.

   ```powershell
   Test-NetConnection 10.2.0.36 -CommonTCPPort RDP
   ```

### Test connectivity between spokes &mdash; Linux

If you connected the spokes, perform these steps to verify connectivity using Linux:

1. Use the Azure portal to find the VM named `jbl-vm1` in the `onprem-jb-rg` resource group.

2. Click `Connect` and copy the `ssh` command shown in the portal.

3. From a Linux prompt, run `ssh` to connect to the simulated on-premises environment. Use the password that you specified in the `hub-spoke.json` parameter file.

4. Use the Azure portal to find the VM named `s1jbl-vm1` in the `spoke1-vnet-rg` resource group.

5. Click `Connect` and copy the `ssh` command shown in the portal.

6. In the ssh session created in step 3, run `ssh` to connect to the spoke-1 jumpbox. Use the password that you specified in the `hub-spoke.json` parameter file.

7. Use the `nc` command to test connectivity to the jumpbox VM in spoke 2:

   ```bash
   nc -vzw 1 10.2.0.37 22
   ```

## Next steps

For a version of this architecture that deploys shared identity and security services, see [Hub-spoke network topology with shared services in Azure](./shared-services.md).

<!-- links -->

[aaf-cost]: ../../framework/cost/overview.md
[AAF-devops]: /azure/architecture/framework/devops/overview
[azure-cli-2]: /azure/install-azure-cli
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[azbb]: https://github.com/mspnp/template-building-blocks/wiki/Install-Azure-Building-Blocks
[azure-vpn-gateway]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[connect-to-an-Azure-vnet]: https://technet.microsoft.com/library/dn786406.aspx
[devops-monitoring]: https://docs.microsoft.com/azure/architecture/framework/devops/monitoring
[Firewall-NVA]: https://azure.microsoft.com/blog/azure-firewall-and-network-virtual-appliances
[guidance-expressroute]: ./expressroute.md
[guidance-vpn]: ./vpn.md
[linux-vm-ra]: ../n-tier/n-tier-cassandra.md
[hybrid-ha]: ./expressroute-vpn-failover.md
[naming conventions]: https://docs.microsoft.com/azure/guidance/guidance-naming-conventions
[VN-pricing]: https://azure.microsoft.com/pricing/details/virtual-network
[vnet-peering]: https://docs.microsoft.com/azure/virtual-network/virtual-network-peering-overview
[vnet-peering-limit]: https://docs.microsoft.com/azure/azure-subscription-service-limits#networking-limits
[vnet-peering-requirements]: https://docs.microsoft.com/azure/virtual-network/virtual-network-manage-peering#requirements-and-constraints
[vpn-appliance]: https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpn-devices
[windows-vm-ra]: ../n-tier/n-tier-sql-server.md
[visio-download]: https://archcenter.blob.core.windows.net/cdn/hybrid-network-hub-spoke.vsdx
[ref-arch-repo]: https://github.com/mspnp/reference-architectures

[0]: ./images/hub-spoke.png "Hub-spoke topology in Azure"
[2]: ./images/spoke-spoke-routing.png "Routing between spokes using Azure Firewall"
