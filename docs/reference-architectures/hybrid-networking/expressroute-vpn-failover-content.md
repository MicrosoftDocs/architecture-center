---
ms.custom:
  - devx-track-azurepowershell
---
This reference architecture shows how to connect an on-premises network to an Azure virtual network by using Azure ExpressRoute, with a site-to-site virtual private network (VPN) as a failover connection.

## Architecture

![Reference architecture for a highly available hybrid network architecture that uses ExpressRoute and VPN gateway.](images/expressroute-vpn-failover.svg)

*Download a [Visio file](https://arch-center.azureedge.net/expressroute-vpn-failover.vsdx) of this architecture.*

### Workflow

The architecture consists of the following components.

- **On-premises network**. A private local-area network running within an organization.
- **VPN appliance**. A device or service that provides external connectivity to the on-premises network. The VPN appliance can be a hardware device, or it can be a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server 2012. For a list of supported VPN appliances and information on configuring selected VPN appliances for connecting to Azure, see [About VPN devices for Site-to-Site VPN Gateway connections][vpn-appliance].
- **ExpressRoute circuit**. A layer 2 or layer 3 circuit supplied by the connectivity provider that joins the on-premises network with Azure through the edge routers. The circuit uses the hardware infrastructure managed by the connectivity provider.
- **ExpressRoute virtual network gateway**. The ExpressRoute virtual network gateway enables the Azure virtual network to connect to the ExpressRoute circuit that's used for connectivity with your on-premises network.
- **VPN virtual network gateway**. The VPN virtual network gateway enables the Azure virtual network to connect to the VPN appliance in the on-premises network. The VPN virtual network gateway is configured to accept requests from the on-premises network only through the VPN appliance. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network][connect-to-an-Azure-vnet].
- **VPN connection**. The connection has properties that specify the connection type (IPSec) and the key shared with the on-premises VPN appliance to encrypt traffic.
- **Azure virtual network**. Each virtual network resides in a single Azure region, and can host multiple application tiers. Application tiers can be segmented using subnets in each virtual network.
- **Gateway subnet**. The virtual network gateways are held in the same subnet.

### Components

- [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute)
- [Azure VPN Gateway](https://azure.microsoft.com/products/vpn-gateway)
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network)

## Scenario details

This reference architecture shows how to connect an on-premises network to an Azure virtual network by using ExpressRoute, with a site-to-site virtual private network (VPN) as a failover connection. Traffic flows between the on-premises network and the Azure virtual network through an ExpressRoute connection. If there's a loss of connectivity in the ExpressRoute circuit, traffic is routed through an IPSec VPN tunnel. [**Deploy this solution**](#deploy-this-scenario).

Note that if the ExpressRoute circuit is unavailable, the VPN route will handle only private peering connections. Public peering and Microsoft peering connections pass over the Internet.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### The virtual network and GatewaySubnet

Create the ExpressRoute virtual network gateway connection and the VPN virtual network gateway connection in the same virtual network with a Gateway object already in place. They'll both share the same subnet named *GatewaySubnet*.

If the virtual network already includes a subnet named *GatewaySubnet*, ensure that it has a /27 or larger address space. If the existing subnet is too small, use the following PowerShell command to remove the subnet:

```powershell
$vnet = Get-AzVirtualNetwork -Name <your-vnet-name> -ResourceGroupName <your-resource-group>
Remove-AzVirtualNetworkSubnetConfig -Name GatewaySubnet -VirtualNetwork $vnet
```

If the virtual network doesn't contain a subnet named **GatewaySubnet**, create a new one using the following PowerShell command:

```powershell
$vnet = Get-AzVirtualNetwork -Name <your-vnet-name> -ResourceGroupName <your-resource-group>
Add-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet -AddressPrefix "10.200.255.224/27"
$vnet = Set-AzVirtualNetwork -VirtualNetwork $vnet
```

### VPN and ExpressRoute gateways

Verify that your organization meets the [ExpressRoute prerequisite requirements][expressroute-prereq] for connecting to Azure.

If you already have a VPN virtual network gateway in your Azure virtual network, use the following PowerShell command to remove it:

```powershell
Remove-AzVirtualNetworkGateway -Name <your-gateway-name> -ResourceGroupName <your-resource-group>
```

Follow the instructions in [Configure a hybrid network architecture with Azure ExpressRoute][configure-expressroute] to establish your ExpressRoute connection.

Follow the instructions in [Configure a hybrid network architecture with Azure and On-premises VPN][configure-vpn] to establish your VPN virtual network gateway connection.

After you've established the virtual network gateway connections, test the environment as follows:

1. Make sure you can connect from your on-premises network to your Azure virtual network.
1. Contact your provider to stop ExpressRoute connectivity for testing.
1. Verify that you can still connect from your on-premises network to your Azure virtual network using the VPN virtual network gateway connection.
1. Contact your provider to reestablish ExpressRoute connectivity.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For general Azure security considerations, see [Microsoft cloud services and network security][best-practices-security].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

For ExpressRoute cost considerations, see these articles:

- [Cost considerations in configuring a Hybrid Network Architecture with Azure ExpressRoute](../../reference-architectures/hybrid-networking/expressroute.yml#considerations).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

For ExpressRoute DevOps considerations, see the [Configure a Hybrid Network Architecture with Azure ExpressRoute][guidance-expressroute] guidance.

For site-to-site VPN DevOps considerations, see the [Configure a Hybrid Network Architecture with Azure and On-premises VPN][guidance-vpn] guidance.

## Deploy this scenario

**Prerequisites**. You must have an existing on-premises infrastructure already configured with a suitable network appliance.

To deploy the solution, perform the following steps.

1. Select the link below.

   [![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fazure-quickstart-templates%2fmaster%2fquickstarts%2fmicrosoft.network%2fexpressroute-private-peering-vnet%2fazuredeploy.json)
1. Wait for the link to open in the Azure portal, then select the **Resource group** you would like to deploy these resources into or create a new resource group. The **Region** and **Location** will automatically change to match the resource group.
1. Update the remaining fields if you would like to change the resource names, providers, SKU, or network IP addresses for your environment.
1. Select **Review + create** and then **Create** to deploy these resources.
1. Wait for the deployment to complete.

   > [!NOTE]
   > This template deployment only deploys the following resources:
   >
   > - A resource group (if you create new)
   > - An ExpressRoute circuit
   > - An Azure virtual network
   > - An ExpressRoute virtual network gateway
   >
   > In order for you to successfully establish private peering connectivity from on-premises to the ExpressRoute circuit, you'll need to engage your service provider with the circuit service key. The service key can be found on the overview page of the ExpressRoute circuit resource. For more information on configuring your ExpressRoute circuit, see [Create or modify peering configuration](/azure/expressroute/expressroute-howto-routing-portal-resource-manager). Once you have configured private peering successfully you can link the ExpressRoute virtual network gateway to the circuit. For more information, see [Tutorial: Connect a virtual network to an ExpressRoute circuit using the Azure portal](/azure/expressroute/expressroute-howto-linkvnet-portal-resource-manager).
1. To complete the deployment of site-to-site VPN as a backup to ExpressRoute, see [Create a site-to-site VPN connection](/azure/vpn-gateway/tutorial-site-to-site-portal).
1. Once you've successfully configured a VPN connection to the same on-premises network you configured ExpressRoute, you'll then have completed the setup to back up your ExpressRoute connection if there's total failure at the peering location.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Sarah Parkes](https://www.linkedin.com/in/sarah-p-a06370) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [ExpressRoute Documentation](/azure/expressroute)
- [Azure Security baseline for ExpressRoute](/security/benchmark/azure/baselines/expressroute-security-baseline?toc=%2fazure%2fexpressroute%2fTOC.json)
- [How to create an ExpressRoute circuit](https://azure.microsoft.com/resources/videos/azure-expressroute-how-to-create-an-expressroute-circuit)
- [Azure Networking Blog](https://azure.microsoft.com/blog/topics/networking)
- [Configure ExpressRoute and Site-to-Site coexisting connections using PowerShell](/azure/expressroute/expressroute-howto-coexist-resource-manager)

## Related resources

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md)
- [Azure hybrid options](../../guide/technology-choices/hybrid-considerations.yml)
- [Hub-spoke network topology in Azure](hub-spoke.yml)
- [Spoke-to-spoke networking](../../networking/spoke-to-spoke-networking.yml)
- [Connect an on-premises network to Azure](index.yml)
- [Extend an on-premises network using ExpressRoute](expressroute.yml)
- [Implement a secure hybrid network](../dmz/secure-vnet-dmz.yml)
- [Integrate on-premises AD with Azure](../identity/index.yml)

<!-- links -->

[vpn-appliance]: /azure/vpn-gateway/vpn-gateway-about-vpn-devices
[connect-to-an-Azure-vnet]: /microsoft-365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network?view=o365-worldwide
[expressroute-prereq]: /azure/expressroute/expressroute-prerequisites
[configure-expressroute]: ./expressroute.yml
[configure-vpn]: /azure/expressroute/expressroute-howto-coexist-resource-manager
[guidance-expressroute]: ./expressroute.yml
[guidance-vpn]: /azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering
[best-practices-security]: /azure/best-practices-network-security
