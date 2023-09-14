---
ms.custom:
  - devx-track-azurepowershell
---
This reference architecture shows how to connect an on-premises network to virtual networks on Azure, using [Azure ExpressRoute][expressroute-introduction]. ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure.

## Architecture

![[0]][0]

*Download a [Visio file][visio-download] of this architecture.*

### Workflow

The architecture consists of the following components.

- **On-premises corporate network**. A private local-area network running within an organization.

- **ExpressRoute circuit**. A layer 2 or layer 3 circuit supplied by the connectivity provider that joins the on-premises network with Azure through the edge routers. The circuit uses the hardware infrastructure managed by the connectivity provider.

- **Local edge routers**. Routers that connect the on-premises network to the circuit managed by the provider. Depending on how your connection is provisioned, you may need to provide the public IP addresses used by the routers.

- **Microsoft edge routers**. Two routers in an active-active highly available configuration. These routers enable a connectivity provider to connect their circuits directly to their datacenter. Depending on how your connection is provisioned, you may need to provide the public IP addresses used by the routers.

- **Azure virtual networks (VNets)**. Each VNet resides in a single Azure region, and can host multiple application tiers. Application tiers can be segmented using subnets in each VNet.

- **Azure public services**. Azure services that can be used within a hybrid application. These services are also available over the Internet, but accessing them using an ExpressRoute circuit provides low latency and more predictable performance, because traffic does not go through the Internet.

- **Microsoft 365 services**. The publicly available Microsoft 365 applications and services provided by Microsoft. Connections are performed using [Microsoft peering][expressroute-peering], with addresses that are either owned by your organization or supplied by your connectivity provider. You can also connect directly to Microsoft CRM Online through Microsoft peering.

- **Connectivity providers** (not shown). Companies that provide a connection either using layer 2 or layer 3 connectivity between your datacenter and an Azure datacenter.

### Components

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute). ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection, with the help of a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Microsoft 365.

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network). Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VMs), to securely communicate with each other, the internet, and on-premises networks.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Connectivity providers

Select a suitable ExpressRoute connectivity provider for your location. To get a list of connectivity providers available at your location, use the following Azure PowerShell command:

```powershell
Get-AzExpressRouteServiceProvider
```

ExpressRoute connectivity providers connect your datacenter to Microsoft in the following ways:

- **Co-located at a cloud exchange**. If you're co-located in a facility with a cloud exchange, you can order virtual cross-connections to Azure through the co-location provider's Ethernet exchange. Co-location providers can offer either layer 2 cross-connections, or managed layer 3 cross-connections between your infrastructure in the co-location facility and Azure.
- **Point-to-point Ethernet connections**. You can connect your on-premises datacenters/offices to Azure through point-to-point Ethernet links. Point-to-point Ethernet providers can offer layer 2 connections, or managed layer 3 connections between your site and Azure.
- **Any-to-any (IPVPN) networks**. You can integrate your wide area network (WAN) with Azure. Internet protocol virtual private network (IPVPN) providers (typically a multiprotocol label switching VPN) offer any-to-any connectivity between your branch offices and datacenters. Azure can be interconnected to your WAN to make it look just like any other branch office. WAN providers typically offer managed layer 3 connectivity.

For more information about connectivity providers, see the [ExpressRoute introduction][expressroute-introduction].

### ExpressRoute circuit

Ensure that your organization has met the [ExpressRoute prerequisite requirements][expressroute-prereqs] for connecting to Azure.

If you haven't already done so, add a subnet named `GatewaySubnet` to your Azure VNet and create an ExpressRoute virtual network gateway using the Azure VPN gateway service. For more information about this process, see [ExpressRoute workflows for circuit provisioning and circuit states][ExpressRoute-provisioning].

Create an ExpressRoute circuit as follows:

1. Run the following PowerShell command:

    ```powershell
    New-AzExpressRouteCircuit -Name <<circuit-name>> -ResourceGroupName <<resource-group>> -Location <<location>> -SkuTier <<sku-tier>> -SkuFamily <<sku-family>> -ServiceProviderName <<service-provider-name>> -PeeringLocation <<peering-location>> -BandwidthInMbps <<bandwidth-in-mbps>>
    ```

2. Send the `ServiceKey` for the new circuit to the service provider.

3. Wait for the provider to provision the circuit. To verify the provisioning state of a circuit, run the following PowerShell command:

    ```powershell
    Get-AzExpressRouteCircuit -Name <<circuit-name>> -ResourceGroupName <<resource-group>>
    ```

    The `Provisioning state` field in the `Service Provider` section of the output will change from `NotProvisioned` to `Provisioned` when the circuit is ready.

    > [!NOTE]
    > If you're using a layer 3 connection, the provider should configure and manage routing for you. You provide the information necessary to enable the provider to implement the appropriate routes.
    >
    >

4. If you're using a layer 2 connection:

    1. Reserve two /30 subnets composed of valid public IP addresses for each type of peering you want to implement. These /30 subnets will be used to provide IP addresses for the routers used for the circuit. If you are implementing private and Microsoft peering, you'll need 4 /30 subnets with valid public IP addresses.

    2. Configure routing for the ExpressRoute circuit. Run the following PowerShell commands for each type of peering you want to configure (private and Microsoft). For more information, see [Create and modify routing for an ExpressRoute circuit][configure-expressroute-routing].

        ```powershell
        Set-AzExpressRouteCircuitPeeringConfig -Name <<peering-name>> -ExpressRouteCircuit <<circuit-name>> -PeeringType <<peering-type>> -PeerASN <<peer-asn>> -PrimaryPeerAddressPrefix <<primary-peer-address-prefix>> -SecondaryPeerAddressPrefix <<secondary-peer-address-prefix>> -VlanId <<vlan-id>>

        Set-AzExpressRouteCircuit -ExpressRouteCircuit <<circuit-name>>
        ```

    3. Reserve another pool of valid public IP addresses to use for network address translation (NAT) for Microsoft peering. It is recommended to have a different pool for each peering. Specify the pool to your connectivity provider, so they can configure border gateway protocol (BGP) advertisements for those ranges.

5. Run the following PowerShell commands to link your private VNet(s) to the ExpressRoute circuit. For more information, see [Link a virtual network to an ExpressRoute circuit][link-vnet-to-expressroute].

    ```powershell
    $circuit = Get-AzExpressRouteCircuit -Name <<circuit-name>> -ResourceGroupName <<resource-group>>
    $gw = Get-AzVirtualNetworkGateway -Name <<gateway-name>> -ResourceGroupName <<resource-group>>
    New-AzVirtualNetworkGatewayConnection -Name <<connection-name>> -ResourceGroupName <<resource-group>> -Location <<location> -VirtualNetworkGateway1 $gw -PeerId $circuit.Id -ConnectionType ExpressRoute
    ```

You can connect multiple VNets located in different regions to the same ExpressRoute circuit, as long as all VNets and the ExpressRoute circuit are located within the same geopolitical region.

### Troubleshooting

If a previously functioning ExpressRoute circuit now fails to connect, in the absence of any configuration changes on-premises or within your private VNet, you may need to contact the connectivity provider and work with them to correct the issue. Use the following PowerShell commands to verify that the ExpressRoute circuit has been provisioned:

```powershell
Get-AzExpressRouteCircuit -Name <<circuit-name>> -ResourceGroupName <<resource-group>>
```

The output of this command shows several properties for your circuit, including `ProvisioningState`, `CircuitProvisioningState`, and `ServiceProviderProvisioningState` as shown below.

```powershell
ProvisioningState                : Succeeded
Sku                              : {
                                     "Name": "Standard_MeteredData",
                                     "Tier": "Standard",
                                     "Family": "MeteredData"
                                   }
CircuitProvisioningState         : Enabled
ServiceProviderProvisioningState : NotProvisioned
```

If the `ProvisioningState` is not set to `Succeeded` after you tried to create a new circuit, remove the circuit by using the command below and try to create it again.

```powershell
Remove-AzExpressRouteCircuit -Name <<circuit-name>> -ResourceGroupName <<resource-group>>
```

If your provider had already provisioned the circuit, and the `ProvisioningState` is set to `Failed`, or the `CircuitProvisioningState` is not `Enabled`, contact your provider for further assistance.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability

ExpressRoute circuits provide a high bandwidth path between networks. Generally, the higher the bandwidth the greater the cost.

ExpressRoute offers two [pricing plans][expressroute-pricing] to customers, a metered plan and an unlimited data plan. Charges vary according to circuit bandwidth. Available bandwidth will likely vary from provider to provider. Use the `Get-AzExpressRouteServiceProvider` cmdlet to see the providers available in your region and the bandwidths that they offer.

A single ExpressRoute circuit can support a certain number of peerings and VNet links. See [ExpressRoute limits](/azure/azure-subscription-service-limits) for more information.

For an extra charge, the ExpressRoute Premium add-on provides some additional capability:

- Increased route limits for private peering.
- Increased number of VNet links per ExpressRoute circuit.
- Global connectivity for services.

See [ExpressRoute pricing][expressroute-pricing] for details.

ExpressRoute circuits are designed to allow temporary network bursts up to two times the bandwidth limit that you procured for no additional cost. This is achieved by using redundant links. However, not all connectivity providers support this feature. Verify that your connectivity provider enables this feature before depending on it.

Although some providers allow you to change your bandwidth, make sure you pick an initial bandwidth that surpasses your needs and provides room for growth. If you need to increase bandwidth in the future, you are left with two options:

- Increase the bandwidth. You should avoid this option as much as possible, and not all providers allow you to increase bandwidth dynamically. But if a bandwidth increase is needed, check with your provider to verify they support changing ExpressRoute bandwidth properties via PowerShell commands. If they do, run the commands below.

    ```powershell
    $ckt = Get-AzExpressRouteCircuit -Name <<circuit-name>> -ResourceGroupName <<resource-group>>
    $ckt.ServiceProviderProperties.BandwidthInMbps = <<bandwidth-in-mbps>>
    Set-AzExpressRouteCircuit -ExpressRouteCircuit $ckt
    ```

    You can increase the bandwidth without loss of connectivity. Downgrading the bandwidth will result in disruption in connectivity, because you must delete the circuit and recreate it with the new configuration.

- Change your pricing plan and/or upgrade to Premium. To do so, run the following commands. The `Sku.Tier` property can be `Standard` or `Premium`; the `Sku.Name` property can be `MeteredData` or `UnlimitedData`.

    ```powershell
    $ckt = Get-AzExpressRouteCircuit -Name <<circuit-name>> -ResourceGroupName <<resource-group>>

    $ckt.Sku.Tier = "Premium"
    $ckt.Sku.Family = "MeteredData"
    $ckt.Sku.Name = "Premium_MeteredData"

    Set-AzExpressRouteCircuit -ExpressRouteCircuit $ckt
    ```

    > [!IMPORTANT]
    > Make sure the `Sku.Name` property matches the `Sku.Tier` and `Sku.Family`. If you change the family and tier, but not the name, your connection will be disabled.
    >
    >

    You can upgrade the SKU without disruption, but you cannot switch from the unlimited pricing plan to metered. When downgrading the SKU, your bandwidth consumption must remain within the default limit of the standard SKU.

### Availability

ExpressRoute does not support router redundancy protocols such as hot standby routing protocol (HSRP) and virtual router redundancy protocol (VRRP) to implement high availability. Instead, it uses a redundant pair of BGP sessions per peering. To facilitate highly-available connections to your network, Azure provisions you with two redundant ports on two routers (part of the Microsoft edge) in an active-active configuration.

By default, BGP sessions use an idle timeout value of 60 seconds. If a session times out three times (180 seconds total), the router is marked as unavailable, and all traffic is redirected to the remaining router. This 180-second timeout might be too long for critical applications. If so, you can change your BGP time-out settings on the on-premises router to a smaller value. ExpressRoute also supports [Bidirectional Forwarding Detection (BFD)](/azure/expressroute/expressroute-bfd) over private peering. By enabling BFD over ExpressRoute, you can expedite link failure detection between Microsoft Enterprise edge (MSEE) devices and the routers on which you terminate the ExpressRoute circuit (PE). You can terminate ExpressRoute over Customer Edge routing devices or Partner Edge routing devices (if you went with managed Layer 3 connection service).

You can configure high availability for your Azure connection in different ways, depending on the type of provider you use, and the number of ExpressRoute circuits and virtual network gateway connections you're willing to configure. The following summarizes your availability options:

- If you're using a layer 2 connection, deploy redundant routers in your on-premises network in an active-active configuration. Connect the primary circuit to one router, and the secondary circuit to the other. This will give you a highly available connection at both ends of the connection. This is necessary if you require the ExpressRoute service level agreement (SLA). See [SLA for Azure ExpressRoute][sla-for-expressroute] for details.

    The following diagram shows a configuration with redundant on-premises routers connected to the primary and secondary circuits. Each circuit handles the traffic for private peering (each peering is designated a pair of /30 address spaces, as described in the previous section).

    ![[1]][1]

- If you're using a layer 3 connection, verify that it provides redundant BGP sessions that handle availability for you.

- Connect the VNet to multiple ExpressRoute circuits, supplied by different service providers. This strategy provides additional high-availability and disaster recovery capabilities.

- Configure a site-to-site VPN as a failover path for ExpressRoute. For more about this option, see [Connect an on-premises network to Azure using ExpressRoute with VPN failover][highly-available-network-architecture]. This option only applies to private peering. For Azure and Microsoft 365 services, the Internet is the only failover path.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

You can configure security options for your Azure connection in different ways, depending on your security concerns and compliance needs.

ExpressRoute operates in layer 3. Threats in the application layer can be prevented by using a network security appliance that restricts traffic to legitimate resources.

To maximize security, add network security appliances between the on-premises network and the provider edge routers. This will help to restrict the inflow of unauthorized traffic from the VNet:

![[2]][2]

For auditing or compliance purposes, it may be necessary to prohibit direct access from components running in the VNet to the Internet and implement forced tunneling. In this situation, Internet traffic should be redirected back through a proxy running on-premises where it can be audited. The proxy can be configured to block unauthorized traffic flowing out, and filter potentially malicious inbound traffic.

![[3]][3]

To maximize security, do not enable a public IP address for your VMs, and use NSGs to ensure that these VMs aren't publicly accessible. VMs should only be available using the internal IP address. These addresses can be made accessible through the ExpressRoute network, enabling on-premises DevOps staff to perform configuration or maintenance.

If you must expose management endpoints for VMs to an external network, use NSGs or access control lists to restrict the visibility of these ports to an allowlist of IP addresses or networks.

> [!NOTE]
> Azure VMs deployed through the Azure portal can include a public IP address that provides login access. However, it is a best practice not to permit this.

#### Network monitoring

Use the Network Watcher to monitor and troubleshoot the network components, tools like Traffic Analytics will show you the systems in your virtual networks that generate most traffic, so that you can visually identify bottlenecks before they degenerate into problems. Network Performance Manager has the ability to monitor information about Microsoft ExpressRoute circuits.

You also can use the [Azure Connectivity Toolkit (AzureCT)][azurect] to monitor connectivity between your on-premises datacenter and Azure.

For more information, see the DevOps section in [Microsoft Azure Well-Architected Framework][AAF-devops]. For information specific to monitoring, see [Monitoring For DevOps][devops-monitoring].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.

The next sections explain the service charges that are used in this architecture.

#### Azure ExpressRoute

In this architecture, an ExpressRoute circuit is used to join the on-premises network with Azure through the edge routers.

There are two main plans. In the **Metered Data** plan, all inbound data transfer is free. All outbound data transfer is charged based on a pre-determined rate.

You can also opt for the **Unlimited Data** plan in which all inbound and outbound data transfer is free. Users are charged a fixed monthly port fee based on high availability dual ports.

Calculate your utilization and choose a billing plan accordingly. The **Unlimited Data** plan is recommended if you exceed about 68% of utilization.

For more information, see [Azure ExpressRoute pricing][expressroute-pricing].

#### Azure Virtual Network

All application tiers are hosted in a single virtual network and are segmented using subnets.

Azure Virtual Network is free. Every subscription is allowed to create up to 50 virtual networks across all regions. All traffic that occurs within the boundaries of a virtual network is free. So, communication between two VMs in the same virtual network is free.

## Next steps

Product documentation:

- [Microsoft 365 services](/office365/servicedescriptions/office-365-service-descriptions-technet-library)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)

Microsoft Learn modules:

- [Configure ExpressRoute and Virtual WAN](/training/modules/configure-expressroute-virtual-wan)
- [Configure virtual network peering](/training/modules/configure-vnet-peering)
- [Design and implement Azure ExpressRoute](/training/modules/design-implement-azure-expressroute)
- [Explore the Microsoft 365 platform services](/training/paths/explore-microsoft-365-platform-services)

## Related resources

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md)
- [Connect an on-premises network to Azure using ExpressRoute](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml)
- [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager)

<!-- links -->

[highly-available-network-architecture]: ./expressroute-vpn-failover.yml
[AAF-devops]: /azure/architecture/framework/devops/overview
[expressroute-prereqs]: /azure/expressroute/expressroute-prerequisites
[configure-expressroute-routing]: /azure/expressroute/expressroute-howto-routing-arm
[sla-for-expressroute]: https://azure.microsoft.com/support/legal/sla/expressroute
[link-vnet-to-expressroute]: /azure/expressroute/expressroute-howto-linkvnet-arm
[devops-monitoring]: /azure/architecture/framework/devops/checklist
[ExpressRoute-provisioning]: /azure/expressroute/expressroute-workflows
[expressroute-introduction]: /azure/expressroute/expressroute-introduction
[expressroute-peering]: /azure/expressroute/expressroute-circuit-peerings
[expressroute-pricing]: https://azure.microsoft.com/pricing/details/expressroute/
[aaf-cost]: /azure/architecture/framework/cost/overview
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[azurect]: https://github.com/Azure/NetworkMonitoring/tree/master/AzureCT
[0]: ./images/expressroute.png "Diagram showing hybrid network architecture using Azure ExpressRoute"
[1]: ../_images/guidance-hybrid-network-expressroute/figure2.png "Using redundant routers with ExpressRoute primary and secondary circuits"
[2]: ../_images/guidance-hybrid-network-expressroute/figure3.png "Adding security devices to the on-premises network"
[3]: ../_images/guidance-hybrid-network-expressroute/figure4.png "Using forced tunneling to audit Internet-bound traffic"
[visio-download]: https://arch-center.azureedge.net/hybrid-networking-expressroute.vsdx
