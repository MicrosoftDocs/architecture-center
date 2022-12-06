This reference architecture is about implementing the hub-spoke network pattern with customer-managed hub infrastructure components. The hub virtual network acts as a central point of connectivity to many spoke virtual networks. You can also enable cross-premises scenarios by using the hub to connect to your on-premises networks. The spoke virtual networks peer with the hub and can be used to isolate workloads.

For a Microsoft-managed hub infrastructure solution, see [Hub-spoke network topology with Azure Virtual WAN](/azure/architecture/networking/hub-spoke-vwan-architecture).

## Architecture

![Hub-spoke topology in Azure](./images/hub-spoke.png)

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-network-topology-architecture.vsdx) of this architecture.*

### Workflow

The architecture consists of the following aspects:

- **Hub virtual network:** The hub virtual network is the central point of connectivity for your cross-premises networks. It's a place to host services in Azure that can be consumed by the different workloads hosted in the spoke virtual networks.

- **Spoke virtual networks:** Spoke virtual networks are used to isolate workloads in their own virtual networks, managed separately from other spokes. Each workload can include multiple tiers, with multiple subnets connected through Azure load balancers.

- **Virtual network peering:** Two virtual networks can be connected using a [peering connection](/azure/virtual-network/virtual-network-peering-overview). Peering connections are non-transitive, low-latency connections between virtual networks. Once peered, the virtual networks exchange traffic using the Azure backbone without needing a router.

- **Bastion Host:** Azure Bastion lets you securely connect to a virtual machine using your browser and the Azure portal. An Azure Bastion host is deployed inside an Azure Virtual Network and can access virtual machines in the virtual network (VNet) or in peered VNets.

- **Azure Firewall:** Azure Firewall is a managed firewall service. The Firewall instance is placed in its own subnet.

- **VPN virtual network gateway or ExpressRoute gateway**. The virtual network gateway enables the virtual network to connect to the VPN device, or ExpressRoute circuit, for cross-premises network connectivity. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network](/microsoft-365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network?view=o365-worldwide).

- **VPN device**. A device or service that provides external connectivity to the cross-premises network. The VPN device can be a hardware device or a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server. For more information, see [Validated VPN devices and device configuration guides](/azure/vpn-gateway/vpn-gateway-about-vpn-devices#devicetable).

### Components

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network). Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many Azure resources, such as Azure Virtual Machines (VMs), to securely communicate with each other, your cross-premises network, and the internet.

- [Azure Bastion](https://azure.microsoft.com/products/azure-bastion). Azure Bastion is a fully managed service that provides more secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to virtual machines (VMs), without any exposure through public IP addresses.

- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall). Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. The stateful firewall service has built-in high availability and unrestricted cloud scalability to help you create, enforce, and log application and network connectivity policies across subscriptions and virtual networks.

- [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway). VPN Gateway sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet. You can also use VPN Gateway to send encrypted traffic between Azure virtual networks over the Microsoft network. A VPN gateway is a specific type of virtual network gateway.

- [Azure Monitor](https://azure.microsoft.com/services/monitor). Collect, analyze, and act on telemetry data from your cross-premises environments, including Azure and on-premises. Azure Monitor helps you maximize the performance and availability of your applications and helps you proactively identify problems in seconds.

## Scenario details

The benefits of using a hub and spoke configuration include [cost savings, overcoming subscription limits, and workload isolation](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology).

### Potential use cases

Typical uses for this architecture include:

- Workloads deployed in different environments, such as development, testing, and production, require shared services such as DNS IDS, NTP, or AD DS. Shared services are placed in the hub virtual network, while each environment is deployed to a spoke to maintain isolation.
- Workloads that don't require connectivity to each other but require access to shared services.
- Enterprises that require central control over security aspects, like a firewall in the hub as a DMZ, and segregated management for the workloads in each spoke.

## Recommendations

The following recommendations apply to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Resource groups

The sample solution included in this document uses a single Azure resource group. You can implement the hub and each spoke in different resource groups and subscriptions. When you peer virtual networks in different subscriptions, both subscriptions can be associated with the same or different Azure Active Directory tenant. This flexibility allows for decentralized management of each workload while sharing services maintained in the hub. See [Create a virtual network peering - Resource Manager, different subscriptions, and Azure Active Directory tenants](/azure/virtual-network/create-peering-different-subscriptions).

As a general rule of thumb, a recommendation is to have at least one hub per region. This configuration helps avoid a single point of failure. For example, to avoid Region A resources being affected at the network level because of an outage in Region B.

### Virtual network and GatewaySubnet

Create a subnet named *GatewaySubnet*, with an address range of at least **/27**. The /27 address range gives it enough scalability configuration options to prevent reaching the gateway size limitations in the future. The virtual network gateway requires this subnet.

For more information about setting up the gateway, see the following reference architectures, depending on your connection type:

- [Hybrid network using ExpressRoute](./expressroute.yml)
- [Hybrid network using a VPN gateway](/azure/expressroute/expressroute-howto-coexist-resource-manager)

For higher availability, you can use ExpressRoute plus a VPN for failover. See [Connect an on-premises network to Azure using ExpressRoute with VPN failover](./expressroute-vpn-failover.yml).

A hub-spoke topology can also be used without a gateway if you don't need cross-premises network connectivity.

### Virtual network peering

Virtual network peering is a non-transitive relationship between two virtual networks. If you require spokes to connect to each other, consider adding a separate peering connection between those spokes.

Suppose you have several spokes that need to connect with each other. In that case, you'll run out of possible peering connections quickly because the number of virtual network peerings per virtual network is limited. For more information, see [Networking limits](/azure/azure-subscription-service-limits#networking-limits). In this scenario, consider using user-defined routes (UDRs) to force traffic destined to a spoke to be sent to Azure Firewall or a network virtual appliance acting as a router at the hub. This change will allow the spokes to connect to each other.

While Azure Firewall is primarily used for egress security, it can be used as an ingress point. The topology in this article is designed to facilitate egress flows. For more ingress considerations to hub network virtual appliance and ingress routing, see [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway).

You can also configure spokes to use the hub gateway to communicate with remote networks. To allow gateway traffic to flow from spoke to hub and connect to remote networks, you must:

- Configure the peering connection in the hub to **allow gateway transit**.
- Configure the peering connection in each spoke to **use remote gateways**.
- Configure all peering connections to **allow forwarded traffic**.

For more information, see [Create VNet peerings](/azure/virtual-network/virtual-network-manage-peering#create-a-peering).

### Spoke connectivity

If you require connectivity between spokes, consider deploying an Azure Firewall or other network virtual appliance. Then create routes to forward traffic from the spoke to the firewall or network virtual appliance, which can then route to the second spoke. In this scenario, you must configure the peering connections to **allow forwarded traffic**.

![Routing between spokes using Azure Firewall](./images/spoke-spoke-routing.png)

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-network-topology-spock-connectivity.vsdx) of this architecture.*

You can also use a VPN gateway to route traffic between spokes, although this choice will impact latency and throughput. See [Configure VPN gateway transit for virtual network peering](/azure/vpn-gateway/vpn-gateway-peering-gateway-transit) for configuration details.

Consider what services are shared in the hub to ensure the hub scales for a larger number of spokes. For instance, if your hub provides firewall services, consider your firewall solution's bandwidth limits when adding multiple spokes. You can move some of these shared services to a second level of hubs.

For more in-depth information, see [spoke-to-spoke networking](/azure/architecture/networking/spoke-to-spoke-networking).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Management

Use [Azure Virtual Network Manager](/azure/virtual-network-manager/overview) (AVNM) to create new (and onboard existing) hub and spoke virtual network topologies for the central management of connectivity and security controls.

AVNM ensures that your hub and spoke network topologies are prepared for large-scale future growth across multiple subscriptions, management groups, and regions. See the following example scenarios:

- The democratization of spoke virtual networks management to an organization's groups, such as to business units or application teams, which results in large numbers of VNet-to-VNet connectivity and network security rules requirements.
- The standardization of multiple replica hub and spoke architectures in multiple Azure regions to ensure a global footprint for applications.

Discoverability of the desired virtual networks to manage through AVNM can be defined using the [Scopes](/azure/virtual-network-manager/concept-network-manager-scope) feature. This feature allows flexibility on the desired number of AVNM resource instances, which allows the further democratization of management for groups of VNets.

VNets in any subscription, management group, or region under the same Azure AD tenant can be grouped into [network groups](/azure/virtual-network-manager/concept-network-groups) to ensure uniformity on the expected connectivity and network rules. Virtual networks can be automatically or manually onboarded to the network group through dynamic or static memberships.

Spoke VNets in the same network group can be connected with one another by enabling VNet peering through AVNM's [direct connectivity](/azure/virtual-network-manager/concept-connectivity-configuration#direct-connectivity) feature. To extend the capabilities for spokes in different regions to have direct connectivity, use the [global mesh](/azure/virtual-network-manager/concept-connectivity-configuration#global-mesh) feature, which facilitates the creation of global VNet peerings. See the example diagram below:

![Diagram showing spoke direct connectivity.](/azure/virtual-network-manager/media/concept-configuration-types/hub-and-spoke.png)

Further, to ensure a baseline set of security rules, VNets within the same network group can be associated with [security admin rules](/azure/virtual-network-manager/concept-security-admins). Security admin rules are evaluated before NSG rules and have the same nature as NSGs, with support for prioritization, service tags, and L3-L4 protocols.

Finally, to facilitate a controlled rollout of network groups, connectivity, and security rules changes, AVNM's [deployments](/azure/virtual-network-manager/concept-deployments) feature allows you to safely release these configurations' breaking changes to the hub-and-spoke environments.

For more information on how to get started, see [Create a hub and spoke topology with Azure Virtual Network Manager](/azure/virtual-network-manager/how-to-create-hub-and-spoke).

### Cost optimization

Cost optimization is about ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Consider the following cost-related items when deploying and managing hub and spoke networks.

#### Azure Firewall

An Azure Firewall is deployed in the hub network in this architecture. When used as a shared solution and consumed by multiple workloads, an Azure Firewall deployment can save on cloud spending significantly over other network virtual appliances. For more information, see [Azure Firewall vs. network virtual appliances](https://azure.microsoft.com/blog/azure-firewall-and-network-virtual-appliances).

Consider rightsizing the Azure Firewall to ensure you use all deployed resources effectively. Review what features you need and decide on what tier is the most suitable for your current set of workloads. See [What is Azure Firewall](/azure/firewall/overview) to learn about the available SKUs.

#### Virtual network peering

Using private IP addresses, you can use virtual network peering to route traffic between virtual networks. Here are some points:

- Ingress and egress traffic is charged at both ends of the peered networks.
- Different zones have different transfer rates.

For instance, data transfer from a virtual network in zone 1 to another virtual network in zone 2 will incur an outbound transfer rate for zone 1 and an inbound rate for zone 2. For more information, see [Virtual network pricing](https://azure.microsoft.com/pricing/details/virtual-network).

Consider [planning for IP addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing) based on your peering requirements, and ensure the address space doesn't overlap across cross-premises locations and Azure locations.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### Network monitoring

Use Azure Network Watcher to monitor and troubleshoot the network components. Tools like Traffic Analytics will show you the systems in your virtual networks that generate the most traffic. Then you can visually identify bottlenecks before they degenerate into problems. Network Performance Manager is the right tool to monitor information about Microsoft ExpressRoute circuits. VPN diagnostics is another tool to help troubleshoot site-to-site VPN connections connecting your applications to users on-premises.

For more information, see [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview).

You should also consider enabling the [Azure Firewall diagnostic logging](/azure/firewall/firewall-diagnostics) to better get insights into DNS requests and allow/deny results in the logs.

## Deploy this scenario

This deployment includes one hub virtual network, and two peered spokes. An Azure Firewall and Azure Bastion host are also deployed. Optionally, the deployment can include virtual machines in the first spoke network and a VPN gateway.

### [Azure CLI](#tab/cli)

Use the following command to create a resource group for the deployment. Select the **Try it** button to use an embedded shell.

```azurecli-interactive
az group create --name hub-spoke --location eastus
```

Run the following command to deploy the hub and spoke network configuration, VNet peerings between the hub and spoke, and a Bastion host. When prompted, enter a username and password. These values can be used to access the virtual machine located in the spoke network.

```azurecli-interactive
az deployment group create --resource-group hub-spoke \
    --template-uri https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke/azuredeploy.json
```

### [PowerShell](#tab/powershell)

Use the following command to create a resource group for the deployment. Select the **Try it** button to use an embedded shell.

```azurepowershell-interactive
New-AzResourceGroup -Name hub-spoke -Location eastus
```

Run the following command to deploy the hub and spoke network configuration, VNet peerings between the hub and spoke, and a Bastion host. When prompted, enter a username and password. These values can be used to access the virtual machine located in the spoke network.

```azurepowershell-interactive
New-AzResourceGroupDeployment -ResourceGroupName hub-spoke `
    -TemplateUri https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke/azuredeploy.json
```

### [Bicep](#tab/bicep)

Use the following command to create a resource group for the deployment. Select the **Try it** button to use an embedded shell.

```azurecli-interactive
az group create --name hub-spoke --location eastus
```

Use the following command to download the Bicep template.

```azurecli-interactive
curl https://raw.githubusercontent.com/mspnp/samples/main/solutions/azure-hub-spoke/bicep/main.bicep > main.bicep
```

Run the following command to deploy the hub and spoke network configuration, VNet peerings between the hub and spoke, and a Bastion host. When prompted, enter a username and password. These values can be used to access the virtual machine located in the spoke network.

```azurecli-interactive
az deployment group create --resource-group hub-spoke --template-file main.bicep
```

### [Azure portal](#tab/portal)

Use the following button to deploy the reference using the Azure portal.

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmain%2Fsolutions%2Fazure-hub-spoke%2Fazuredeploy.json)

---

For detailed information and extra deployment options, see the Azure Resource Manager (ARM) templates used to deploy this solution.

> [!div class="nextstepaction"]
> [Hub and Spoke ARM and Bicep templates](/samples/mspnp/samples/hub-and-spoke-deployment/)

## Next steps

Learn more about secured virtual hubs and the associated security and routing policies configured by Azure Firewall Manager.

- [What is a secured virtual hub?](/azure/firewall-manager/secured-virtual-hub)

## Related resources

Explore the following related architectures:

- [Azure firewall architecture guide](../../example-scenario/firewalls/index.yml)
- [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.yml)
- [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager)
- [Troubleshoot a hybrid VPN connection](./troubleshoot-vpn.yml)
- [Define an Azure network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology)
- [Hybrid connection](../../solution-ideas/articles/hybrid-connectivity.yml)
- [Connect standalone servers by using Azure Network Adapter](../../hybrid/azure-network-adapter.yml)
- [Secure and govern workloads with network level segmentation](./network-level-segmentation.yml)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
