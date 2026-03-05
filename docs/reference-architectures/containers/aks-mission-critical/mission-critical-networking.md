---
title: Networking and connectivity for mission-critical workloads on Azure
description: Networking decisions for the architecture of a mission-critical workload on Azure. 
author: asudbring
ms.author: allensu
ms.date: 11/30/2023
ms.topic: reference-architecture
ms.subservice: reference-architecture
summary: Networking decisions for the architecture of a mission-critical workload on Azure.
---

# Networking and connectivity for mission-critical workloads

The regional distribution of resources in a mission-critical architecture requires a robust network infrastructure.

A globally distributed design is recommended where Azure services come together to provide a highly available application. The global load balancer combined with regional stamps provides that guarantee through reliable connectivity.

Design regional deployment stamps as the deployable units for mission-critical workloads. The ability to efficiently deploy new deployment stamps provides scalability and supports high availability. Design deployment stamps with an isolated [virtual network design](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity#isolated-virtual-networks). Cross-stamp traffic isn't recommended. Virtual network peerings or VPN connections between deployment stamps aren't required.

The architecture is intentional in defining the regional stamps as short-lived. The global state of the infrastructure is stored in the global resources.

A global load balancer is required to route traffic to healthy stamps and provide security services. It must have certain capabilities.

- Health probing is required so that the load balancer can check the health of the origin before routing traffic.

- Weighted traffic distribution.

Optionally, it should be able to perform caching at the edge. Also, provide some security assurance for ingress by using the web application firewall (WAF).

:::image type="content" border="false" source="./images/network-diagram-all-standard.png" alt-text="Diagram of network for a mission critical architecture." lightbox="./images/network-diagram-all-standard.png":::

*Download a [Visio file](https://arch-center.azureedge.net/mission-critical-networking.vsdx) of this architecture.*

## Traffic ingress

The application defined in the architecture is internet facing and has several requirements:

- A routing solution that is global and can distribute traffic between independent regional stamps.

- Low-latency in health checking and the ability to stop sending traffic to unhealthy stamps.

- Prevention of malicious attacks at the edge.

- Provide caching abilities at the edge.

Route all traffic through Azure Front Door as the entry point for mission-critical workloads. Front Door is a global load balancer that routes HTTP(S) traffic to registered backends/origins. Configure Front Door to use health probes that issue requests to a URI in each backend/origin. The URI called should be a dedicated health service. The health service advertises the health of each deployment stamp. Front Door uses the response to determine the health of individual deployment stamps and route traffic to healthy stamps capable of servicing application requests.

Azure Front Door integration with Azure Monitor provides near real-time monitoring of traffic, security, success and failure metrics, and alerting.

Azure Web Application Firewall, integrated with Azure Front Door, is used to prevent attacks at the edge before they enter the network.

:::image type="content" border="false" source="./images/network-diagram-ingress-standard.png" alt-text="Diagram of network ingress for mission-critical workloads.":::

## Isolated virtual network - API

Use Azure Virtual Networks as the traffic isolation boundary for mission-critical APIs. Components in one virtual network can't communicate directly with components in another virtual network.

The standard external Azure Load Balancer distributes requests to the application platform. It checks that traffic reaching the load balancer was routed via Azure Front Door, ensuring Azure WAF inspects all traffic.

Build agents used for operations and deployment must be able to reach into the isolated network. The isolated network can be opened up to allow the agents to communicate. Alternatively, deploy self-hosted agents in the virtual network.

Network throughput monitoring, performance of the individual components, and health of the application is required.

## Application platform communication dependency

Design the application platform for individual stamps with the following communication requirements:

- The application platform must be able to communicate securely with Microsoft PaaS services.

- The application platform must be able to communicate securely with other services when needed.

Use Azure Key Vault to store secrets, such as connection strings and API keys, to securely communicate over the internet to Azure PaaS services. There are possible risks to exposing the application platform over the internet for this communication. Secrets can be compromised and increased security and monitoring of the public endpoints is recommended.

:::image type="content" border="false" source="./images/network-diagram-vnet-paas-dependencies-standard.png" alt-text="Diagram of the application platform communication dependencies." lightbox="./images/network-diagram-vnet-paas-dependencies-standard.png":::

## Extended networking considerations

This section discusses the pros and cons of alternative approaches to the network design. Alternative networking considerations and the use of Azure Private endpoints is the focus in the following sections.

### Subnets and Network Security Groups

Subnets within the virtual networks can be used to segment traffic within the design. Subnet isolation separates resources for different functions.

Network security groups control the traffic that's allowed in and out of each subnet. Rules used within the network security groups limit traffic based on IP, port, and protocol to block unwanted traffic entering or leaving the subnet.

### Private endpoints - Ingress

The premium version of Front Door supports the use of Azure Private Endpoints. Private endpoints expose an Azure service to a private IP address in a virtual network. Connections are made securely and privately between services without the need to route the traffic to public endpoints.

Azure Front Door premium and Azure Private Endpoints enable fully private compute clusters in the individual stamps. Traffic is fully locked down for all Azure PaaS services.

Using private endpoints increases the security of mission-critical workloads. Application deployment stamps don't need to expose public endpoints, and using private endpoints reduces the risk of networking attacks including DDoS attacks. However, it introduces another point of failure.

The increased security must be weighed versus the increased reliability effort, cost, and complexity.

Use self-hosted build agents for deployment stamp provisioning. The management of these agents comes with a maintenance overhead.

:::image type="content" border="false" source="./images/network-diagram-ingress.png" alt-text="Diagram of network ingress for mission-critical workloads with private endpoints.":::

### Private endpoints - Application platform

Private endpoints are supported for all Azure PaaS services recommended for mission-critical workloads. With private endpoints configured for the application platform, all communication would travel through the virtual network of the stamp.

The public endpoints of the individual Azure PaaS services can be configured to disallow public access. This process isolates the resources from public attacks that could cause downtime and throttling which affect reliability and availability.

Use self-hosted build agents for deployment stamp operations. The management of these agents comes with a maintenance overhead.

:::image type="content" border="false" source="./images/network-diagram-vnet-paas-dependencies.png" alt-text="Diagram of the application platform communication dependencies with private endpoints." lightbox="./images/network-diagram-vnet-paas-dependencies.png":::

## Next steps

> [!div class="nextstepaction"]
> [Mission-critical: Data platform](mission-critical-data-platform.md)
