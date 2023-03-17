In a [traditional hub-spoke topology with bring-your-own-networking](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke), you have the ability to expose common services to isolated workloads that run in spokes. These shared services can include things like DNS, identity, Bastion and more. When using Azure Virtual WAN, you have restricted access and limitations on what you can install on the virtual hub.

For example, to implement Private Link at scale in a traditional hub-spoke model, you would create and link private DNS zones to the hub network. To enable secure connectivity to resources in the network you might deploy Azure Bastion in the regional hub. You might also deploy custom compute resources, such as Active Directory VMs in the hub. None of these are possible with Azure Virtual WAN.

This article describes the virtual hub extension pattern which provides guidance on how to securely expose shared services that you are unable to deploy in a virtual hub.

## Architecture

A virtual hub extension is a dedicated spoke virtual network connected to the hub that exposes a single shared service to workload spokes. A virtual hub extension can be a service you provide to resources in other spokes where those resources require network connectivity to your resource. DNS is a good example of this. An extension can also contain a resource, such as Azure Bastion, that requires connectivity to many destinations in the spokes.

:::image type="complex" source="./images/dns-private-endpoints-hub-extension-pattern.svg" lightbox="./images/dns-private-endpoints-hub-extension-pattern.svg" alt-text="Diagram showing the hub extension pattern."::: 
Diagram showing the single-region challenge.
:::image-end:::
*Figure 1: Hub extension pattern*

1. Virtual hub extension for Azure Bastion. This extension lets you connect to virtual machines in spoke networks.
2. Virtual hub extension for DNS. This extension allows you to expose private DNS zone entries to workloads in spoke networks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Ensure you only deploy one service per extension spoke virtual network. This allows you to configure each extension taking into account the requirements of only that service. For example, Azure Bastion [requires that internet traffic is *not* routed through Azure Firewall](/azure/bastion/bastion-faq#vwan). This might conflict with your egress routing requirements for other services.

### Operational excellence

- Follow the single responsibility principal (SRP) when designing virtual hub extension spokes.
- If you choose to co-locate extension resources in the same spoke network, make sure they should be managed together, including sharing the same route propagations and route associations.
