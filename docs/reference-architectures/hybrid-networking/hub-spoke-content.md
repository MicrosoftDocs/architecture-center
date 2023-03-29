This reference architecture implements a hub-spoke network pattern with customer-managed hub infrastructure components. For a Microsoft-managed hub infrastructure solution, see [Hub-spoke network topology with Azure Virtual WAN](/azure/architecture/networking/hub-spoke-vwan-architecture).

## Architecture

[ ![Diagram that shows a hub-spoke virtual network topology in Azure with spoke networks connected through the hub or directly.](./images/hub-spoke.png)](./images/hub-spoke.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-network-topology-architecture.vsdx) of this architecture.*

### Workflow

This hub-spoke network configuration uses the following architectural elements:

- **Hub virtual network.** The hub virtual network hosts shared Azure services. Workloads hosted in the spoke virtual networks can use these services. The hub virtual network is the central point of connectivity for cross-premises networks.

- **Spoke virtual networks.** Spoke virtual networks isolate and manage workloads separately in each spoke. Each workload can include multiple tiers, with multiple subnets connected through Azure load balancers. Spokes can exist in different subscriptions and represent different environments, such as Production and Non-production.

- **Virtual network connectivity.** This architecture connects virtual networks by using [peering connections](/azure/virtual-network/virtual-network-peering-overview) or [connected groups](/azure/virtual-network-manager/concept-connectivity-configuration). Peering connections and connected groups are non-transitive, low-latency connections between virtual networks. Peered or connected virtual networks can exchange traffic over the Azure backbone without needing a router. [Azure Virtual Network Manager](/azure/virtual-network-manager/overview) creates and manages [network groups](/azure/virtual-network-manager/concept-network-groups) and their connections.

- **Azure Bastion host.** Azure Bastion provides secure connectivity from the Azure portal to virtual machines (VMs) by using your browser. An Azure Bastion host deployed inside an Azure virtual network can access VMs in that virtual network or in connected virtual networks.

- **Azure Firewall.** An Azure Firewall managed firewall instance exists in its own subnet.

- **Azure VPN Gateway or Azure ExpressRoute gateway.** A virtual network gateway enables a virtual network to connect to a virtual private network (VPN) device or Azure ExpressRoute circuit. The gateway provides cross-premises network connectivity. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network](/microsoft-365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network?view=o365-worldwide) and [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager).

- **VPN device.** A VPN device or service provides external connectivity to the cross-premises network. The VPN device can be a hardware device or a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server. For more information, see [Validated VPN devices and device configuration guides](/azure/vpn-gateway/vpn-gateway-about-vpn-devices#devicetable).

### Components

- [Virtual Network Manager](https://azure.microsoft.com/products/virtual-network-manager) is a management service that helps you group, configure, deploy, and manage virtual networks at scale across Azure subscriptions, regions, and tenants. With Virtual Network Manager, you can define groups of virtual networks to identify and logically segment your virtual networks. You can define and apply connectivity and security configurations across all virtual networks in a network group at once.

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for private networks in Azure. Virtual Network enables many Azure resources, such as Azure VMs, to securely communicate with each other, cross-premises networks, and the internet.

- [Azure Bastion](https://azure.microsoft.com/products/azure-bastion) is a fully managed service that provides more secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to VMs without exposing their public IP addresses.

- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall) is a managed cloud-based network security service that protects Virtual Network resources. This stateful firewall service has built-in high availability and unrestricted cloud scalability to help you create, enforce, and log application and network connectivity policies across subscriptions and virtual networks.

- [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) is a specific type of virtual network gateway that sends encrypted traffic between a virtual network and an on-premises location over the public internet. You can also use VPN Gateway to send encrypted traffic between Azure virtual networks over the Microsoft network.

- [Azure Monitor](https://azure.microsoft.com/services/monitor) can collect, analyze, and act on telemetry data from cross-premises environments, including Azure and on-premises. Azure Monitor helps you maximize the performance and availability of your applications and proactively identify problems in seconds.

## Scenario details

This reference architecture implements a hub-spoke network pattern where the hub virtual network acts as a central point of connectivity to many spoke virtual networks. The spoke virtual networks connect with the hub and can be used to isolate workloads. You can also enable cross-premises scenarios by using the hub to connect to on-premises networks.

This architecture describes a network pattern with customer-managed hub infrastructure components. For a Microsoft-managed hub infrastructure solution, see [Hub-spoke network topology with Azure Virtual WAN](/azure/architecture/networking/hub-spoke-vwan-architecture).

The benefits of using a hub and spoke configuration include:

- Cost savings
- Overcoming subscription limits
- Workload isolation

For more information, see [Hub-and-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology).

### Potential use cases

Typical uses for a hub and spoke architecture include workloads that:

- Have several environments that require shared services. For example, a workload might have development, testing, and production environments. Shared services might include DNS IDs, Network Time Protocol (NTP), or Active Directory Domain Services (AD DS). Shared services are placed in the hub virtual network, and each environment deploys to a different spoke to maintain isolation.
- Don't require connectivity to each other, but require access to shared services.
- Require central control over security, like a perimeter network (also known as DMZ) firewall in the hub with segregated workload management in each spoke.
- Require central control over connectivity, such as selective connectivity or isolation between spokes of certain environments or workloads.

## Recommendations

The following recommendations apply to most scenarios. Follow these recommendations unless you have specific requirements that override them.

### Resource groups, subscriptions, and regions

This example solution uses a single Azure resource group. You can also implement the hub and each spoke in different resource groups and subscriptions.

When you peer virtual networks in different subscriptions, you can associate the subscriptions to the same or different Azure Active Directory (Azure AD) tenants. This flexibility allows for decentralized management of each workload while maintaining shared services in the hub. See [Create a virtual network peering - Resource Manager, different subscriptions, and Azure AD tenants](/azure/virtual-network/create-peering-different-subscriptions).

As a general rule, it's best to have at least one hub per region. This configuration helps avoid a single point of failure, for example to avoid Region A resources being affected at the network level by an outage in Region B.

### Virtual network subnets

The following recommendations outline how to configure the subnets on the virtual network.

#### GatewaySubnet

The virtual network gateway requires this subnet. You can also use a hub-spoke topology without a gateway if you don't need cross-premises network connectivity.

Create a subnet named *GatewaySubnet* with an address range of at least `/27`. The `/27` address range gives the subnet enough scalability configuration options to prevent reaching the gateway size limitations in the future. For more information about setting up the gateway, see the following reference architectures, depending on your connection type:

- [Hybrid network using ExpressRoute](./expressroute.yml)
- [Hybrid network using a VPN gateway](/azure/expressroute/expressroute-howto-coexist-resource-manager)

For higher availability, you can use ExpressRoute plus a VPN for failover. See [Connect an on-premises network to Azure using ExpressRoute with VPN failover](./expressroute-vpn-failover.yml).

#### AzureFirewallSubnet

Create a subnet named *AzureFirewallSubnet* with an address range of at least `/26`. Regardless of scale, the `/26` address range is the recommended size and covers any future size limitations. This subnet doesn't support network security groups (NSGs).

Azure Firewall requires this subnet. If you use a partner network virtual appliance (NVA), follow its network requirements.

### Spoke network connectivity

Virtual network peering or connected groups are non-transitive relationships between virtual networks. If you need spoke virtual networks to connect to each other, add a peering connection between those spokes or place them in the same network group.

#### Spoke connections through Azure Firewall or NVA

The number of virtual network peerings per virtual network is limited. If you have several spokes that need to connect with each other, you could run out of peering connections. Connected groups also have limitations. For more information, see [Networking limits](/azure/azure-subscription-service-limits#networking-limits) and [Connected groups limits](/azure/virtual-network-manager/faq#what-are-the-service-limitations-of-azure-virtual-network-manager).

In this scenario, consider using user-defined routes (UDRs) to force spoke traffic to be sent to Azure Firewall or another NVA that acts as a router at the hub. This change allows the spokes to connect to each other. To support this configuration, you must implement Azure Firewall with forced tunnel configuration enabled. For more information, see [Azure Firewall forced tunneling](/azure/firewall/forced-tunneling).

The topology in this architectural design facilitates egress flows. While Azure Firewall is primarily for egress security, it can also be an ingress point. For more considerations about hub NVA ingress routing, see [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway).

#### Spoke connections to remote networks through a hub gateway

To configure spokes to communicate with remote networks through a hub gateway, you can use virtual network peerings or connected network groups.

To use virtual network peerings, in the virtual network **Peering** setup:

- Configure the peering connection in the hub to **Allow** gateway transit.
- Configure the peering connection in each spoke to **Use the remote virtual network's gateway**.
- Configure all peering connections to **Allow** forwarded traffic.

For more information, see [Create a virtual network peering](/azure/virtual-network/virtual-network-manage-peering#create-a-peering).

To use connected network groups:

1. In Virtual Network Manager, create a network group and add member virtual networks.
1. Create a hub and spoke connectivity configuration.
1. For the **Spoke network groups**, select **Hub as gateway**.

For more information, see [Create a hub and spoke topology with Azure Virtual Network Manager](/azure/virtual-network-manager/how-to-create-hub-and-spoke).

### Spoke network communications

There are two main ways to allow spoke virtual networks to communicate with each other:

- Communication via an NVA like a firewall and router. This method incurs a hop between the two spokes.
- Communication by using virtual network peering or Virtual Network Manager direct connectivity between spokes. This approach doesn't cause a hop between the two spokes and is recommended for minimizing latency.

#### Communication through an NVA

If you need connectivity between spokes, consider deploying Azure Firewall or another NVA in the hub. Then create routes to forward traffic from a spoke to the firewall or NVA, which can then route to the second spoke. In this scenario, you must configure the peering connections to allow forwarded traffic.

![Diagram that shows routing between spokes using Azure Firewall](./images/spoke-spoke-routing.png)

You can also use a VPN gateway to route traffic between spokes, although this choice affects latency and throughput. For configuration details, see [Configure VPN gateway transit for virtual network peering](/azure/vpn-gateway/vpn-gateway-peering-gateway-transit).

Evaluate the services you share in the hub to ensure that the hub scales for a larger number of spokes. For instance, if your hub provides firewall services, consider your firewall solution's bandwidth limits when you add multiple spokes. You can move some of these shared services to a second level of hubs.

#### Direct communication between spoke networks

To connect directly between spoke virtual networks without traversing the hub virtual network, you can create peering connections between spokes or enable direct connectivity for the network group. It's best to limit peering or direct connectivity to spoke virtual networks that are part of the same environment and workload.

When you use Virtual Network Manager, you can add spoke virtual networks to network groups manually, or add networks automatically based on conditions you define. For more information, see [Spoke-to-spoke networking](/azure/architecture/networking/spoke-to-spoke-networking).

The following diagram illustrates using Virtual Network Manager for direct connectivity between spokes.

![Diagram that shows using Virtual Network Manager for direct connectivity between spokes.](./images/spoke-spoke-avnm.png)

### Management recommendations

To centrally manage connectivity and security controls, use [Virtual Network Manager](/azure/virtual-network-manager/overview) to create new hub and spoke virtual network topologies or onboard existing topologies. Using Virtual Network Manager ensures that your hub and spoke network topologies are prepared for large-scale future growth across multiple subscriptions, management groups, and regions.

Example Virtual Network Manager use case scenarios include:

- Democratization of spoke virtual network management to groups such as business units or application teams. Democratization can result in large numbers of virtual network-to-virtual network connectivity and network security rules requirements.
- Standardization of multiple replica architectures in multiple Azure regions to ensure a global footprint for applications.

To ensure uniform connectivity and network security rules, you can use [network groups](/azure/virtual-network-manager/concept-network-groups) to group virtual networks in any subscription, management group, or region under the same Azure AD tenant. You can automatically or manually onboard virtual networks to network groups through dynamic or static membership assignments.

You define discoverability of the virtual networks that Virtual Network Manager manages by using [Scopes](/azure/virtual-network-manager/concept-network-manager-scope). This feature provides flexibility for a desired number of network manager instances, which allows further management democratization for virtual network groups.

To connect spoke virtual networks in the same network group to each other, use Virtual Network Manager to implement virtual network peering or [direct connectivity](/azure/virtual-network-manager/concept-connectivity-configuration#direct-connectivity). Use the [global mesh](/azure/virtual-network-manager/concept-connectivity-configuration#global-mesh) option to extend mesh direct connectivity to spoke networks in different regions. The following diagram shows global mesh connectivity between regions.

![Diagram showing spoke global mesh direct connectivity over regions.](./images/hub-and-spoke.png)

You can associate virtual networks within a network group to a baseline set of security admin rules. Network group security admin rules prevent spoke virtual network owners from overwriting baseline security rules, while letting them independently add their own sets of security rules and NSGs. For an example of using security admin rules in hub and spoke topologies, see [Tutorial: Create a secured hub and spoke network](/azure/virtual-network-manager/tutorial-create-secured-hub-and-spoke).

To facilitate a controlled rollout of network groups, connectivity, and security rules, Virtual Network Manager [configuration deployments](/azure/virtual-network-manager/concept-deployments) help you safely release potentially breaking configuration changes to hub and spoke environments. For more information, see [Configuration deployments in Azure Virtual Network Manager](/azure/virtual-network-manager/concept-deployments).

To get started with Virtual Network Manager, see [Create a hub and spoke topology with Azure Virtual Network Manager](/azure/virtual-network-manager/how-to-create-hub-and-spoke).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

To ensure a baseline set of security rules, make sure to associate [security admin rules](/azure/virtual-network-manager/concept-security-admins) with virtual networks in network groups. Security admin rules take precedence over and are evaluated before NSG rules. Like NSG rules, security admin rules support prioritization, service tags, and L3-L4 protocols. For more information, see [Security admin rules in Virtual Network Manager](/azure/virtual-network-manager/concept-security-admins).

Use Virtual Network Manager [deployments](/azure/virtual-network-manager/concept-deployments) to facilitate controlled rollout of potentially breaking changes to network group security rules.

[Azure DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable [Azure DDOS Protection Standard](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

### Cost optimization

Cost optimization is about ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Consider the following cost-related factors when you deploy and manage hub and spoke networks. For more information, see [Virtual network pricing](https://azure.microsoft.com/pricing/details/virtual-network).

#### Azure Firewall costs

This architecture deploys an Azure Firewall instance in the hub network. Using an Azure Firewall deployment as a shared solution consumed by multiple workloads can significantly save cloud costs compared to other NVAs. For more information, see [Azure Firewall vs. network virtual appliances](https://azure.microsoft.com/blog/azure-firewall-and-network-virtual-appliances).

To use all deployed resources effectively, choose the right Azure Firewall size. Decide what features you need and which tier best suits your current set of workloads. To learn about the available Azure Firewall SKUs, see [What is Azure Firewall?](/azure/firewall/overview)

#### Private IP address costs

You can use private IP addresses to route traffic between peered virtual networks or between networks in connected groups. The following cost considerations apply:

- Ingress and egress traffic is charged at both ends of the peered or connected networks. For instance, data transfer from a virtual network in zone 1 to another virtual network in zone 2 incurs an outbound transfer rate for zone 1 and an inbound rate for zone 2.
- Different zones have different transfer rates.

[Plan for IP addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing) based on your peering requirements, and make sure the address space doesn't overlap across cross-premises locations and Azure locations.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Use [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) to monitor and troubleshoot network components with the following tools:

- Traffic Analytics shows you the systems in your virtual networks that generate the most traffic. You can visually identify bottlenecks before they become problems.
- Network Performance Monitor monitors information about ExpressRoute circuits.
- VPN diagnostics helps troubleshoot site-to-site VPN connections that connect your applications to on-premises users.

Also consider enabling [Azure Firewall diagnostic logging](/azure/firewall/firewall-diagnostics) to get better insights into the DNS requests and the allow/deny results in the logs.

## Deploy this scenario

This deployment includes one hub virtual network and two connected spokes, and also deploys an Azure Firewall instance and Azure Bastion host. Optionally, the deployment can include VMs in the first spoke network and a VPN gateway.

You can choose between virtual network peering or Virtual Network Manager connected groups to create the network connections. Each method has several deployment options.

### Use virtual network peering

#### [Azure CLI](#tab/cli)

1. Run the following command to create a resource group named `hub-spoke` in the `eastus` region for the deployment. Select **Try It** to use an embedded shell.

   ```azurecli-interactive
   az group create --name hub-spoke --location eastus
   ```

1. Run the following command to deploy the hub and spoke network configuration, virtual network peerings between the hub and spokes, and an Azure Bastion host. When prompted, enter a user name and password. You can use this user name and password to access VMs in the spoke networks.

   ```azurecli-interactive
   az deployment group create --resource-group hub-spoke \
       --template-uri https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke/azuredeploy.json
   ```

#### [PowerShell](#tab/powershell)

1. Run the following command to create a resource group named `hub-spoke` in the `eastus` region for the deployment. Select **Try It** to use an embedded shell.

   ```azurepowershell-interactive
   New-AzResourceGroup -Name hub-spoke -Location eastus
   ```

1. Run the following command to deploy the hub and spoke network configuration, virtual network peerings between the hub and spokes, and an Azure Bastion host. When prompted, enter a user name and password. You can use this user name and password to access VMs in the spoke networks.

   ```azurepowershell-interactive
   New-AzResourceGroupDeployment -ResourceGroupName hub-spoke `
       -TemplateUri https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke/azuredeploy.json
   ```

#### [Bicep](#tab/bicep)

1. Run the following command to create a resource group named `hub-spoke` in the `eastus` region for the deployment. Select **Try It** to use an embedded shell.

   ```azurecli-interactive
   az group create --name hub-spoke --location eastus
   ```

1. Run the following command to download the Bicep template.

   ```azurecli-interactive
   curl https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke/bicep/main.bicep > main.bicep
   ```

1. Run the following command to deploy the hub and spoke network configuration, virtual network peerings between the hub and spokes, and an Azure Bastion host. When prompted, enter a user name and password. You can use this user name and password to access VMs in the spoke networks.

   ```azurecli-interactive
   az deployment group create --resource-group hub-spoke --template-file main.bicep
   ```

#### [Azure portal](#tab/portal)

Select the following button to deploy the reference architecture as an Azure Resource Manager (ARM) template in the Azure portal:

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmain%2Fsolutions%2Fazure-hub-spoke%2Fazuredeploy.json)

---


For detailed information and extra deployment options, see the [hub and spoke templates](/samples/mspnp/samples/hub-and-spoke-deployment) that deploy this solution.

### Use Virtual Network Manager connected groups

#### [Azure CLI](#tab/cli)

1. Run the following command to create a resource group named `hub-spoke` in the `eastus` region for the deployment. Select **Try It** to use an embedded shell.

   ```azurecli-interactive
   az group create --name hub-spoke --location eastus
   ```

1. Run the following command to deploy the hub and spoke network configuration, virtual network connections between the hub and spokes, and an Azure Bastion host. When prompted, enter a user name and password. You can use this user name and password to access VMs in the spoke networks.

   ```azurecli-interactive
   az deployment group create --resource-group hub-spoke \
       --template-uri https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke-connected-group/azuredeploy.json
   ```

#### [PowerShell](#tab/powershell)

1. Run the following command to create a resource group for the deployment. Select **Try It** to use an embedded shell.

   ```azurepowershell-interactive
   New-AzResourceGroup -Name hub-spoke -Location eastus
   ```

1. Run the following command to deploy the hub and spoke network configuration, virtual network connections between the hub and spokes, and an Azure Bastion host. When prompted, enter a user name and password. You can use this user name and password to access VMs in the spoke networks.

   ```azurepowershell-interactive
   New-AzResourceGroupDeployment -ResourceGroupName hub-spoke `
       -TemplateUri https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke-connected-group/azuredeploy.json
   ```

#### [Bicep](#tab/bicep)

1. Run the following command to create a resource group for the deployment. Select **Try It** to use an embedded shell.

   ```azurecli-interactive
   az group create --name hub-spoke --location eastus
   ```

1. Run the following command to download the Bicep template.

   ```azurecli-interactive
   curl https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke-connected-group/bicep/main.bicep > main.bicep
   ```

1. Run the following commands to download all the needed modules to a new directory.

   ```azurecli-interactive
   mkdir modules
   
   curl https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke-connected-group/bicep/modules/avnm.bicep > modules/avnm.bicep
   curl https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke-connected-group/bicep/modules/avnmDeploymentScript.bicep > modules/avnmDeploymentScript.bicep
   curl https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke-connected-group/bicep/modules/hub.bicep > modules/hub.bicep
   curl https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke-connected-group/bicep/modules/spoke.bicep > modules/spoke.bicep
   ```

1. Run the following command to deploy the hub and spoke network configuration, virtual network connections between the hub and spokes, and a Bastion host. When prompted, enter a user name and password. You can use this user name and password to access VMs in the spoke networks.

   ```azurecli-interactive
   az deployment group create --resource-group hub-spoke --template-file main.bicep
   ```

#### [Azure portal](#tab/portal)

Select the following button to deploy the reference architecture as an ARM template in the Azure portal:

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmain%2Fsolutions%2Fazure-hub-spoke-connected-group%2Fazuredeploy.json)


---


<!-- For detailed information and extra deployment options, see the [Hub and Spoke ARM and Bicep templates](/samples/mspnp/samples/hub-and-spoke-deployment-with-connected-groups/) that deploy this solution.-->

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

[Alejandra Palacios](https://www.linkedin.com/in/alejandrampalacios/) | Senior Customer Engineer

Other contributors:

- [Matthew Bratschun](https://www.linkedin.com/in/matthewbratschun/) | Customer Engineer
- [Jay Li](https://www.linkedin.com/in/jiayangl/) | Senior Product Manager
- [Telmo Sampaio](https://www.linkedin.com/in/telmo-sampaio-172200/) | Principal Service Engineering Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- To learn about secured virtual hubs and the associated security and routing policies that [Azure Firewall Manager](https://azure.microsoft.com/products/firewall-manager) configures, see [What is a secured virtual hub?](/azure/firewall-manager/secured-virtual-hub)

- The hub in a hub-spoke network topology is the main component of a connectivity subscription in an [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone). For more information about building large-scale networks in Azure with routing and security managed by the customer or by Microsoft, see [Define an Azure network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology).

## Related resources

Explore the following related architectures:

- [Azure firewall architecture guide](../../example-scenario/firewalls/index.yml)
- [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.yml)
- [Troubleshoot a hybrid VPN connection](./troubleshoot-vpn.yml)
- [Spoke-to-spoke networking](../../networking/spoke-to-spoke-networking.yml)
- [Hybrid connection](../../solution-ideas/articles/hybrid-connectivity.yml)
- [Connect standalone servers by using Azure Network Adapter](../../hybrid/azure-network-adapter.yml)
- [Secure and govern workloads with network level segmentation](./network-level-segmentation.yml)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../containers/aks/baseline-aks.yml)
