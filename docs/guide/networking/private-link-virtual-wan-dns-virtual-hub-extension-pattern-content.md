In a [traditional hub-spoke topology with bring-your-own-networking](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke), you can completely manipulate the hub virtual network. You can deploy common services into the hub and make them available to workload spokes. These shared services often include things like DNS resources, custom NVAs, and Azure Bastion. When you use Azure Virtual WAN, however, you have restricted access and limitations on what you can install on the virtual hubs.

For example, to implement [Private Link and DNS integration in a traditional hub-spoke network architecture](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale#private-link-and-dns-integration-in-hub-and-spoke-network-architectures), you would create and link private DNS zones to the hub network. Your [plan for virtual machine remote access](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access#design-recommendations) might include Azure Bastion as a shared service in the regional hub. You might also deploy custom compute resources, such as Active Directory VMs in the hub. None of these approaches are possible with Virtual WAN.

This article describes the virtual hub extension pattern that provides guidance on how to securely expose shared services to spokes that you're unable to deploy directly in a virtual hub.

## Architecture

A virtual hub extension is a dedicated spoke virtual network connected to the virtual hub that exposes a single, shared service to workload spokes. You can use a virtual hub extension to  provide, to many workload spokes, network connectivity to your shared resource. DNS resources are an example of this use. You can also use an extension to contain a centralized resource that requires connectivity to many destinations in the spokes. A centralized Azure Bastion deployment is an example of this use.

:::image type="complex" source="images/dns-private-endpoints-hub-extension-pattern.svg" lightbox="images/dns-private-endpoints-hub-extension-pattern.svg" alt-text="Diagram showing the hub extension pattern.":::
Diagram showing a virtual hub with a single workload spoke, and two example hub extensions; one for Azure Bastion, the other for DNS Private Resolver.
:::image-end:::
*Figure 1: Hub extension pattern*

*Download a [Visio file](https://arch-center.azureedge.net/dns-private-endpoints-virtual-wan.vsdx) of this architecture.*
1. Virtual hub extension for Azure Bastion. This extension lets you connect to virtual machines in spoke networks.
1. Virtual hub extension for DNS. This extension allows you to expose private DNS zone entries to workloads in spoke networks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

A virtual hub extension is often deemed business critical, as it's serving a core function within the network. Extensions should align to business requirements, have failure mitigation strategies, and scale with the needs of the spokes.

Your standard operating procedures should include resiliency testing and reliability monitoring of all extensions. These procedures should validate access and throughput requirements. Each extension should have a meaningful health model.

Be clear about your service level objectives (SLO) for this extension and accurately measure reliability against it. Understand the Azure service level agreement (SLA) and the support requirements on each individual component in the extension. This knowledge helps you set the ceiling for your target SLO and understand the supported configurations.

### Security

**Network restrictions**. Although extensions are often used by many spokes or need access to many spokes, they might not need access from or to all spokes. Use available network security controls such as using Network Security Groups and egressing traffic through your secured virtual hub where possible.

**Data and control plane access control**. Follow best practices for all resources deployed into extensions, providing least privileged access to the resources' control plane and any data planes.

### Cost Optimization

As with any workload, ensure that appropriate SKU sizes are selected for extension resources to help control costs. Business hours and other factors can cause predictable usage patterns for some extensions. Understand the patterns and provide the elasticity and scalability that can accommodate them.

As a shared service, the workload resources generally have a relatively long duty cycle in your enterprise architecture. Consider using cost savings through prepurchase offerings such as [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations), [reserved capacity pricing](https://azure.microsoft.com/pricing/reserved-capacity/), and [Azure savings plans](/azure/cost-management-billing/savings-plan/).

### Operational excellence

Build virtual hub extensions to adhere to the single responsibility principle (SRP). Each extension should be for a single offering, so don't combine unrelated services in a single spoke. You can organize your resources such that each extension resides in a dedicated resource group, to make it easier to manage Azure policy and roles.

You should provision these extensions by using Infrastructure as Code, and have a build and release process that supports the needs and lifecycle of each extension. As extensions are often business critical in nature, and it's important to have a rigorous testing methods and safe deployment practices in place for each extension.

Having a clear change control and enterprise communication plan in place is vital. You might need to communicate with stakeholders (workload owners) about disaster recovery (DR) drills you're executing, or any planned or unexpected downtime.

Ensure that you have a solid operational health system in place for these resources. Enable appropriate Azure Diagnostics settings on all extension resources, and capture all the telemetry and logs that you need to understand the health of the workload. Consider long term storage of operation logs and metrics to support customer support interactions during unexpected behavior of the shared service extension.

### Performance Efficiency

An extension is a centralized service. In order to design your scale units to handle load changes, you need to understand:

- The demands that your organization makes on the extension.
- The requirements for capacity planning.
- How spokes will grow over time.

To design your scale units, test and document how each component in your extension individually scales, based on the metrics and service scale limits that are in place. Some extensions might require load balancing across multiple instances to achieve the required throughput.

## Example implementation

**Private Link DNS extension**: [Establish a virtual hub extension for DNS](private-link-virtual-wan-dns-single-region-workload.yml#solution---establish-a-virtual-hub-extension-for-dns) describes a Virtual Hub extension designed to support single region DNS lookup for Private Link scenarios.

## Next Steps

> [!div class="nextstepaction"]
> [Hub-spoke network topology with Azure Virtual WAN](../../networking/hub-spoke-vwan-architecture.yml)

## Related resources

- [What is a private endpoint?](/azure/private-link/private-endpoint-overview)
- [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
- [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale)
- [Azure Private Link in a hub-and-spoke network](/azure/architecture/guide/networking/private-link-hub-spoke-network)
- [DNS for on-premises and Azure resources](/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources)
- [Single-region data landing zone connectivity](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/eslz-network-considerations-single-region)
- [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security)
- [Azure DNS Private Resolver](/azure/architecture/example-scenario/networking/azure-dns-private-resolver)
- [Improved-security access to multitenant web apps from an on-premises network](/azure/architecture/web-apps/guides/networking/access-multitenant-web-app-from-on-premises)
- [Network-hardened web application with private connectivity to PaaS datastores](/azure/architecture/example-scenario/security/hardened-web-app)
- [Tutorial: Create a private endpoint DNS infrastructure with Azure Private Resolver for an on-premises workload](/azure/private-link/tutorial-dns-on-premises-private-resolver)
