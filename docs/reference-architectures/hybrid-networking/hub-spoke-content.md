This reference architecture details a hub-spoke topology in Azure. The hub virtual network acts as a central point of connectivity to many spoke virtual networks. The hub can also be used as the connectivity point to your on-premises networks. The spoke virtual networks peer with the hub and can be used to isolate workloads.

## Potential use cases

The benefits of using a hub and spoke configuration include cost savings, overcoming subscription limits, and workload isolation.

Typical uses for this architecture include:

- Workloads deployed in different environments, such as development, testing, and production, that require shared services such as DNS, IDS, NTP, or AD DS. Shared services are placed in the hub virtual network, while each environment is deployed to a spoke to maintain isolation.
- Workloads that don't require connectivity to each other but require access to shared services.
- Enterprises that require central control over security aspects, such as a firewall in the hub as a DMZ, and segregated management for the workloads in each spoke.

## Architecture

![Hub-spoke topology in Azure](./images/hub-spoke.png)

### Workflow

The architecture consists of the following aspects:

**Hub virtual network:** The hub virtual network is the central point of connectivity to your on-premises network. It's a place to host services that can be consumed by the different workloads hosted in the spoke virtual networks.

**Spoke virtual networks:** Spoke virtual networks are used to isolate workloads in their own virtual networks, managed separately from other spokes. Each workload might include multiple tiers, with multiple subnets connected through Azure load balancers.

**Virtual network peering:** Two virtual networks can be connected using a [peering connection](/azure/virtual-network/virtual-network-peering-overview). Peering connections are non-transitive, low latency connections between virtual networks. Once peered, the virtual networks exchange traffic by using the Azure backbone without the need for a router.

**Bastion Host:** Azure Bastion lets you securely connect to a virtual machine using your browser and the Azure portal. An Azure Bastion host is deployed inside an Azure Virtual Network and can access virtual machines in the virtual network (VNet), or virtual machines in peered VNets.

**Azure Firewall:** Azure Firewall is a managed firewall as a service. The Firewall instance is placed in its own subnet.

**VPN virtual network gateway or ExpressRoute gateway**. The virtual network gateway enables the virtual network to connect to the VPN device, or ExpressRoute circuit, used for connectivity with your on-premises network. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network](/microsoft-365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network?view=o365-worldwide).

**VPN device**. A device or service that provides external connectivity to the on-premises network. The VPN device may be a hardware device or a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server 2012. For more information, see [About VPN devices for Site-to-Site VPN Gateway connections](/azure/vpn-gateway/vpn-gateway-about-vpn-devices).

## Deploy this scenario

This deployment includes one hub virtual network and two peered spokes. An Azure Firewall and Azure Bastion host are also deployed. Optionally, the deployment can include virtual machines in the first spoke network and a VPN gateway.

# [Azure CLI](#tab/cli)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurecli-interactive
az group create --name hub-spoke --location eastus
```

Run the following command to deploy the hub and spoke network configuration, VNet peerings between the hub and spoke, and a Bastion host. When prompted, enter a user name and password. These values can be used to access the virtual machine located in the spoke network.

```azurecli-interactive
az deployment group create --resource-group hub-spoke \
    --template-uri https://raw.githubusercontent.com/mspnp/samples/master/solutions/azure-hub-spoke/azuredeploy.json
```

#### [PowerShell](#tab/powershell)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurepowershell-interactive
New-AzResourceGroup -Name hub-spoke -Location eastus
```

Run the following command to deploy the hub and spoke network configuration, VNet peerings between the hub and spoke, and a Bastion host. When prompted, enter a user name and password. These values can be used to access the virtual machine located in the spoke network.

```azurepowershell-interactive
New-AzResourceGroupDeployment -ResourceGroupName hub-spoke `
    -TemplateUri https://raw.githubusercontent.com/mspnp/samples/master/solutions/azure-hub-spoke/azuredeploy.json
```

#### [Bicep](#tab/bicep)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurecli-interactive
az group create --name hub-spoke --location eastus
```

Use the following command to download the Bicep template.

```azurecli-interactive
curl https://raw.githubusercontent.com/mspnp/samples/master/solutions/azure-hub-spoke/bicep/main.bicep > main.bicep
```

Run the following command to deploy the hub and spoke network configuration, VNet peerings between the hub and spoke, and a Bastion host. When prompted, enter a user name and password. These values can be used to access the virtual machine located in the spoke network.

```azurecli-interactive
az deployment group create --resource-group hub-spoke --template-file main.bicep
```

#### [Azure portal](#tab/portal)

Use the following button to deploy the reference using the Azure portal.

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmaster%2Fsolutions%2Fazure-hub-spoke%2Fazuredeploy.json)

---

For detailed information and extra deployment options, see the Azure Resource Manager (ARM) templates used to deploy this solution.

> [!div class="nextstepaction"]
> [Hub and Spoke ARM and Bicep templates](/samples/mspnp/samples/hub-and-spoke-deployment/)

## Recommendations

The following recommendations apply to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Resource groups

The sample solution included in this document uses a single Azure resource group. In practice, the hub and each spoke can be implemented in different resource groups and even different subscriptions. When you peer virtual networks in different subscriptions, both subscriptions can be associated with the same or different Azure Active Directory tenant. This flexibility allows for decentralized management of each workload while sharing services maintained in the hub.

### Virtual network and GatewaySubnet

Create a subnet named *GatewaySubnet*, with an address range of /27. The virtual network gateway requires this subnet. Giving 32 addresses to this subnet will help to prevent reaching gateway size limitations in the future.

For more information about setting up the gateway, see the following reference architectures, depending on your connection type:

- [Hybrid network using ExpressRoute](./expressroute.yml)
- [Hybrid network using a VPN gateway](./vpn.yml)

For higher availability, you can use ExpressRoute plus a VPN for failover. See [Connect an on-premises network to Azure using ExpressRoute with VPN failover](./expressroute-vpn-failover.yml).

A hub-spoke topology can also be used without a gateway if you don't need connectivity with your on-premises network.

### Virtual network peering

Virtual network peering is a non-transitive relationship between two virtual networks. If you require spokes to connect to each other, consider adding a separate peering connection between those spokes.

Suppose you have several spokes that need to connect with each other. In that case, you'll run out of possible peering connections quickly, because the number of virtual network peerings per virtual network is limited. (For more information, see [Networking limits](/azure/azure-subscription-service-limits#networking-limits). In this scenario, consider using user-defined routes (UDRs) to force traffic destined to a spoke to be sent to Azure Firewall or a network virtual appliance acting as a router at the hub. This change will allow the spokes to connect to each other.

You can also configure spokes to use the hub gateway to communicate with remote networks. To allow gateway traffic to flow from spoke to hub and connect to remote networks, you must:

- Configure the peering connection in the hub to **allow gateway transit**.
- Configure the peering connection in each spoke to **use remote gateways**.
- Configure all peering connections to **allow forwarded traffic**.

For more information, see [Create VNet peerings](/azure/virtual-network/virtual-network-manage-peering#create-a-peering).

### Spoke connectivity

If you require connectivity between spokes, consider deploying an Azure Firewall or other network virtual appliance. Then create routes to forward traffic from the spoke to the firewall or network virtual appliance, which can then route to the second spoke. In this scenario, you must configure the peering connections to **allow forwarded traffic**.

![Routing between spokes using Azure Firewall](./images/spoke-spoke-routing.png)

You can also use a VPN gateway to route traffic between spokes, although this choice will impact latency and throughput. See [Configure VPN gateway transit for virtual network peering](/azure/vpn-gateway/vpn-gateway-peering-gateway-transit) for configuration details.

Consider what services are shared in the hub to ensure the hub scales for a larger number of spokes. For instance, if your hub provides firewall services, consider your firewall solution's bandwidth limits when adding multiple spokes. You might want to move some of these shared services to a second level of hubs.

## Considerations

### Management

Use [Azure Virtual Network Manager](/azure/virtual-network-manager/overview) (AVNM) to create new (and onboard existing) hub and spoke virtual network topologies for the central management of connectivity and security controls.

AVNM ensures that your hub and spoke network topologies are prepared for large scale future growth across multiple subscriptions, management groups, and regions. See the following example scenarios:

- The democratization of spoke virtual networks management to an organization's groups, such as to business units or application teams, which results in large numbers of VNet-to-VNet connectivity and network security rules requirements.
- The standardization of multiple replica hub and spoke architectures in multiple Azure regions to ensure a global footprint for applications.

Discoverability of the desired virtual networks to manage through AVNM can be defined using the [Scopes](/azure/virtual-network-manager/concept-network-manager-scope) feature. This feature allows flexibility on a desired number of AVNM resource instances, which allows the further democratization of management for groups of VNets.

VNets in any subscription, management group, or region, under the same Azure AD tenant, can be grouped into [network groups](/azure/virtual-network-manager/concept-network-groups) to ensure uniformity on the expected connectivity and network rules. Virtual networks can be automatically or manually onboarded to the network group through dynamic or static memberships. 

Spoke VNets in the same network group can be connected with one another by enabling VNet peering through AVNM's [direct connectivity](/azure/virtual-network-manager/concept-connectivity-configuration#direct-connectivity) feature. To extend the capabilities for spokes in different regions to have direct connectivity, use the [global mesh](/azure/virtual-network-manager/concept-connectivity-configuration#global-mesh) feature, which facilitates the creation of global VNet peerings. See the example diagram below:

![Diagram showing spoke direct connectivity.](/azure/virtual-network-manager/media/concept-configuration-types/hub-and-spoke.png)

Further, to ensure a baseline set of security rules, VNets within the same network group can be associated to [security admin rules](/azure/virtual-network-manager/concept-security-admins). Security admin rules are evaluated before NSG rules and have the same nature of NSGs, with support for prioritization, service tags, and L3-L4 protocols.

Finally, to facilitate a controlled rollout of network groups, connectivity, and security rules changes, AVNM's [deployments](/azure/virtual-network-manager/concept-deployments) feature allows you to safely release of these configurations' breaking changes to the hub-and-spoke environments.

For more information on how to get started, see [Create a hub and spoke topology with Azure Virtual Network Manager](/azure/virtual-network-manager/how-to-create-hub-and-spoke).

### Operational considerations

Consider the following information when deploying and managing hub and spoke networks.

#### Network monitoring

Use Azure Network Watcher to monitor and troubleshoot the network components. Tools like Traffic Analytics will show you the systems in your virtual networks that generate the most traffic. Then you can visually identify bottlenecks before they degenerate into problems. Network Performance Manager is the right tool to monitor information about Microsoft ExpressRoute circuits. VPN diagnostics is another tool that can help troubleshoot site-to-site VPN connections connecting your applications to users on-premises.

For more information, see [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) in the Azure Well-Architected Framework.

### Cost optimization

Consider the following cost-related items when deploying and managing hub and spoke networks.

#### Azure Firewall

An Azure Firewall is deployed in the hub network in this architecture. When used as a shared solution and consumed by multiple workloads, an Azure Firewall can save up to 30-50% over other network virtual appliance. For more information, see [Azure Firewall vs network virtual appliance](https://azure.microsoft.com/blog/azure-firewall-and-network-virtual-appliances).

#### Virtual network peering

You can use virtual network peering to route traffic between virtual networks by using private IP addresses. Here are some points:

- Ingress and egress traffic is charged at both ends of the peered networks.
- Different zones have different transfer rates.

For instance, data transfer from a virtual network in zone 1 to another virtual network in zone 2, will incur outbound transfer rate for zone 1 and inbound rate for zone 2. For more information, see [Virtual network pricing](https://azure.microsoft.com/pricing/details/virtual-network).

## Next steps

Learn more about the component technologies:

- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Azure Bastion?](/azure/bastion/bastion-overview)
- [What is Azure Firewall?](/azure/firewall/overview)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Azure Virtual Network Manager overview](/azure/virtual-network-manager/overview)

## Related resources

Explore the following related architectures:

- [Azure firewall architecture guide](../../example-scenario/firewalls/index.yml)
- [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.yml)
- [Extend an on-premises network using VPN](./vpn.yml)
- [Troubleshoot a hybrid VPN connection](./troubleshoot-vpn.yml)
- [Hybrid connection](../../solution-ideas/articles/hybrid-connectivity.yml)
- [Connect standalone servers by using Azure Network Adapter](../../hybrid/azure-network-adapter.yml)
- [Secure and govern workloads with network level segmentation](./network-level-segmentation.yml)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../containers/aks/secure-baseline-aks.yml)