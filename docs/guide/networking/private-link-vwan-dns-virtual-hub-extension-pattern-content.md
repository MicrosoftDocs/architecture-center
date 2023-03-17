In a traditional hub-and-spoke topology, the hub exposes common services to isolated workloads that run in spokes. These shared services can include things like DNS, identity, Bastion and more. This article addresses the challenge of exposing common services when using Azure Virtual WAN.

Azure Virtual WAN exposes virtual hubs which are managed resources. You are limited to what you are able to deploy in the virtual hub. The virtual hub extension pattern is designed to guide you on how to securely expose shared services that you are unable to deploy in a virtual hub.

## Architecture

A virtual hub extension is a dedicated spoke virtual network connected to the hub that exposes a single shared service to workload spokes. A service can be something you provide to resources in other spokes where those resource require network connectivity to your resource. DNS is a good example of this. A service can also be a resource, such as Azure Bastion, that requires connectivity to many destinations in the spokes.

:::image type="complex" source="./images/dns-private-endpoints-hub-extension-pattern.svg" lightbox="./images/dns-private-endpoints-hub-extension-pattern.svg" alt-text="Diagram showing the hub extension pattern."::: 
Diagram showing the single-region challenge.
:::image-end:::
*Figure 1: Hub extension pattern*

1. Virtual hub extension for Azure Bastion. This extension lets you connect to virtual machines in spoke networks.
2. Virtual hub extension for DNS. This extension allows you to expose private DNS zone entries to workloads in spoke networks.

## Considerations

### Security

- Ensure you only deploy one service per extension spoke virtual network. This allows you to create network security group (NSG) rules specific to each service.

### Operational excellence

- Follow the single responsibility principal (SRP) when designing virtual hub extension spokes.
- If you choose to co-locate extension resources in the same spoke network, make sure they should be managed together, sharing the same route propagations and route associations.

