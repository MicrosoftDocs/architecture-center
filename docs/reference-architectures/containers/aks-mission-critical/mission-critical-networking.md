---
title: Networking and connectivity for mission-critical workloads on Azure
description: Networking decisions for the baseline reference architecture for a mission-critical workload on Azure. 
author: sebader
categories: networking
ms.author: allensu
ms.date: 06/28/2022
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.category:
  - networking
azureCategories:
  - networking  
summary: Networking decisions for the baseline reference architecture for a mission-critical workload on Azure. 
products:
  - azure-monitor
  - azure-front-door
---

# Networking and connectivity for mission-critical workloads

The regional distribution of resources in the [mission-critical reference architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro) requires a robust network infrastructure. 

A globally distributed design is recommended where Azure services come together to provide a highly available application. The global load balancer combined with regional stamps provides that guarantee through reliable connectivity.

The regional stamps are the deployable unit in the architecture. The ability to quickly deploy a new stamp provides scalability and supports high availability. The stamps follow an isolated [virtual network design](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity#isolated-virtual-networks). Cross-stamp traffic isn't recommended. Virtual network peerings or VPN connections to other stamps aren't required.

The architecture is intentional in defining the regional stamps as short-lived. The global state of the infrastructure is stored in the global resources.

A global load balancer is required to route traffic to healthy stamps and provide security services. It must have certain capabilities.

- Health probing is required so that the load balancer can check the health of the origin before routing traffic.

- Weighted traffic distribution.

Optionally, it should be able to perform caching at the edge. Also, provide some security assurance for ingress through the use of web application firewall (WAF).

:::image type="content" border="false" source="./images/network-diagram-all-standard.png" alt-text="Diagram of network for reference architecture." lightbox="./images/network-diagram-all-standard.png":::

*Download a [Visio file](https://arch-center.azureedge.net/mission-critical-networking.vsdx) of this architecture.*

## Traffic ingress

The application defined in the architecture is internet facing and has several requirements:

- A routing solution that is global and can distribute traffic between independent regional stamps.

- Low-latency in health checking and the ability to stop sending traffic to unhealthy stamps.

- Prevention of malicious attacks at the edge.

- Provide caching abilities at the edge.

The entry point for all traffic in the design is through Azure Front Door. Front Door is a global load balancer that routes HTTP(S) traffic to registered backends/origins. Front Door uses health probes that issue requests to a URI in each backend/origin. In the reference implementation, the URI called is a health service. The health service advertises the health of the stamp. Front Door uses the response to determine the health of an individual stamp and route traffic to healthy stamps capable of servicing application requests.

Azure Front Door integration with Azure Monitor provides near real-time monitoring of traffic, security, success and failure metrics, and alerting.

Azure Web Application Firewall, integrated with Azure Front Door, is used to prevent attacks at the edge before they enter the network.

:::image type="content" border="false" source="./images/network-diagram-ingress-standard.png" alt-text="Diagram of network ingress for reference architecture.":::

## Isolated virtual network - API

The API in the architecture uses Azure Virtual Networks as the traffic isolation boundary. Components in one virtual network can't communicate directly with components in another virtual network.

Requests to the application platform are distributed with a standard SKU external Azure Load Balancer. There is a check to ensure that traffic reaching the load balancer was routed via Azure Front Door. This check ensures that all traffic was inspected by the Azure WAF.

Build agents used for the operations and deployment of the architecture must be able to reach into the isolated network. The isolated network can be opened up to allow the agents to communicate. Alternatively, self-hosted agents can be deployed in the virtual network. 

Monitoring of the network throughput, performance of the individual components, and health of the application is required.

## Application platform communication dependency

The application platform used with the individual stamps in the infrastructure, has the following communication requirements:

- The application platform must be able to communicate securely with Microsoft PaaS services.

- The application platform must be able to communicate securely with other services when needed.

The architecture as defined uses Azure Key Vault to store secrets, such as connection strings and API keys, to securely communicate over the internet to Azure PaaS services. There are possible risks to exposing the application platform over the internet for this communication. Secrets can be compromised and increased security and monitoring of the public endpoints is recommended.

:::image type="content" border="false" source="./images/network-diagram-vnet-paas-dependencies-standard.png" alt-text="Diagram of the application platform communication dependencies." lightbox="./images/network-diagram-vnet-paas-dependencies-standard.png":::

## Extended networking considerations

This section discusses the pros and cons of alternative approaches to the network design. Alternative networking considerations and the use of Azure Private endpoints is the focus in the following sections.

### Subnets and NSG

Subnets within the virtual networks can be used to segment traffic within the design. Subnet isolation separates resources for different functions.

Network security groups can be used control the traffic that is allowed in and out of each subnet. Rules used within the NSGs can be used limit traffic based on IP, port, and protocol to block unwanted traffic into the subnet.

### Private endpoints - Ingress

The premium SKU of Front Door supports the use of Azure Private Endpoints. Private endpoints expose an Azure service to a private IP address in a virtual network. Connections are made securely and privately between services without the need to route the traffic to public endpoints.

Azure Front Door premium and Azure Private Endpoints enable fully private compute clusters in the individual stamps. Traffic is fully locked down for all Azure PaaS services.

Using private endpoints increases the security of the design. However, it introduces another point of failure. Public endpoints exposed in the application stamps are no longer needed and can no longer be accessed and exposed to a possible DDoS attack.

The increased security must be weighed versus the increased reliability effort, cost, and complexity. 

Self-hosted build agents must be used for the stamp deployment. The management of these agents comes with a maintenance overhead.

:::image type="content" border="false" source="./images/network-diagram-ingress.png" alt-text="Diagram of network ingress for reference architecture with private endpoints.":::

### Private endpoints - Application platform

Private endpoints are supported for all Azure PaaS services used in this design. With private endpoints configured for the application platform, all communication would travel through the virtual network of the stamp.

The public endpoints of the individual Azure PaaS services can be configured to disallow public access. This would isolate the resources from public attacks that could cause downtime and throttling which affect reliability and availability.

Self-hosted build agents must be used for the stamp deployment the same as above. The management of these agents comes with a maintenance overhead.

:::image type="content" border="false" source="./images/network-diagram-vnet-paas-dependencies.png" alt-text="Diagram of the application platform communication dependencies with private endpoints." lightbox="./images/network-diagram-vnet-paas-dependencies.png":::

## Next steps

Deploy the reference implementation to get a full understanding of the resources and their configuration used in this architecture.

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical Online](https://github.com/Azure/Mission-Critical-Online)
