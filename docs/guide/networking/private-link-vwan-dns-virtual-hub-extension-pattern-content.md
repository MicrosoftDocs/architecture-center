In a [traditional hub-spoke topology with bring-your-own-networking](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke), you have the ability to completely manipulate the hub virtual network and deploy common services into the hub to make those hub features available to workload spokes. These shared services often include things like DNS resources, custom NVAs, Azure Bastion, and more. When using Azure Virtual WAN, however, you have restricted access and limitations on what you can install on the virtual hub.

For example, to implement [Private Link and DNS integration in a traditional hub-spoke network architecture](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale#private-link-and-dns-integration-in-hub-and-spoke-network-architectures), you would create and link private DNS zones to the hub network. Your [plan for virtual machine remote access](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access#design-recommendations) might include Azure Bastion as a shared service in the regional hub. You might also deploy custom compute resources, such as Active Directory VMs in the hub. None of these approaches are possible with Azure Virtual WAN.

This article describes the virtual hub extension pattern that provides guidance on how to securely expose shared services to spokes that you're unable to deploy directly in a virtual hub.

## Architecture

A virtual hub extension is a dedicated spoke virtual network connected to the virtual hub that exposes a single, shared service to workload spokes. A virtual hub extension can be a resource you provide to many workload spokes where those spokes require network connectivity to your shared resource. DNS resources are an example of this. An extension can also be used to contain a centralized resource that requires connectivity to many destinations in the spokes. A centralized Azure Bastion deployment is an example of this.

:::image type="complex" source="./images/dns-private-endpoints-hub-extension-pattern.svg" lightbox="./images/dns-private-endpoints-hub-extension-pattern.svg" alt-text="Diagram showing the hub extension pattern.":::
Diagram showing a virtual hub with a single workload spoke, and two example hub extensions; one for Azure Bastion, the other for DNS Private Resolver.
:::image-end:::
*Figure 1: Hub extension pattern*

1. Virtual hub extension for Azure Bastion. This extension lets you connect to virtual machines in spoke networks.
2. Virtual hub extension for DNS. This extension allows you to expose private DNS zone entries to workloads in spoke networks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

A virtual hub extension is often deemed business critical, as it's serving a core function within the network. Extensions should be designed to align to business requirements, have failure mitigation strategies in place, and be designed to scale with the needs of the spokes.

Resiliency testing and reliability monitoring should be part of the standard operating procedures for any extension, validating access and throughput requirements. It's recommended that each extension has a meaningful health model.

Be clear about your service level objectives (SLO) on this extension to your organization and accurately measure against it. Understand Azure's service level agreement (SLA) and support requirements on each individual component in the extension as well, to help set to ceiling your target SLO and undestand supported configurations.

### Security

**Network restrictions**. While extensions are often used by many spokes or need access to many spokes, they might not need access from or to all spokes. Use available network security controls such as using Network Security Groups and egressing traffic through your secured virtual hub where possible.

**Data and control plane access control**. Follow best practices for all resources deployed into extensions, providing least privileged access to the resources' control plane and any data planes.

### Cost Optimization

As with any workload, ensure appropriate SKU sizes are selected for extension resources to help control costs. Some extensions may have predictable usage patterns around business hours or other factors, while others may be less predictable. It's important to understand those usage patterns and understand how elasticity and scalability can be accomplished to meet those usage patterns.

As a shared service, the workload resources generally have a relatively long duty cycle in your enterprise architecture. Consider using cost savings through prepurchase offerings such as [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations), [reserved capacity pricing](https://azure.microsoft.com/pricing/reserved-capacity/), and [Azure savings plans](/azure/cost-management-billing/savings-plan/).

### Operational excellence

Virtual hub extensions should be built with the single responsibility principal (SRP) in mind. Each extension should be for a single offering by not combining unrelated services in a single spoke. You might even wish to organize your resources such that each extension itself resides in a dedicated resource group, allowing more selective and manageable targeting of Azure Policy and Azure RBAC.

You should invest in provisioning these extensions with Infrastructure as Code and having a build and release process that supports the needs and lifecycle of each extension. As extensions are often business critical in nature, and it's important to have a rigorous testing methods and safe deployment practices in place for each extension.

Having a clear change control and enterprise communication plan in place is vital. You might need to communicate with stakeholders (workload owners) about disaster recovery (DR) drills you're executing, or any planned or unexpected downtime.

Ensure you have a solid operational health system in place for these resources. Enable appropriate Azure Diagnostics settings on all extension resources and capture all other telemetry or logs necessary to understand the health of the workload. Long term storage of operation logs and metrics can also be adventagous for customer support interactions during unexpected behavior of the shared service extension.

### Performance Efficiency

As a centralized service the organizational demands on the extension need to be well understood. As an extension operator, you'll need to have an understanding of current needs for capacity planning and how spokes are expected to grow over time, so that you can design your scale units to handle the load changes.

To design your scale units, test and document how each component in your extension individually scales, based on what metrics, and what service scale limits are in place. Some extensions may require deploying and load balancing across multiple instances to acheive required throughput.

## Next Steps

> [!div class="nextstepaction"]
> [Read the single region DNS and Private Link scenario](./private-link-vwan-dns-single-region-workload.yml)

## Related resources

- [What is a private endpoint?](/azure/private-link/private-endpoint-overview)
- [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
- [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale)
- [Azure Private Link in a hub-and-spoke network](/azure/architecture/guide/networking/private-link-hub-spoke-network)
- [DNS for on-premises and Azure resources](/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources)
- [Single-region data landing zone connectivity](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/eslz-network-considerations-single-region)
- [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security)
- [Azure DNS Private Resolver](/azure/architecture/example-scenario/networking/azure-dns-private-resolver)
- [Improved-security access to multitenant web apps from an on-premises network](/azure/architecture/example-scenario/security/access-multitenant-web-app-from-on-premises)
- [Network-hardened web application with private connectivity to PaaS datastores](/azure/architecture/example-scenario/security/hardened-web-app)
- [Tutorial: Create a private endpoint DNS infrastructure with Azure Private Resolver for an on-premises workload](/azure/private-link/tutorial-dns-on-premises-private-resolver)
