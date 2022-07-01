---
title: Networking and connectivity for mission-critical workloads on Azure
description: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources.
author: asudbring
categories: networking
ms.author: allensu
ms.date: 06/28/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: reference-architecture
ms.category:
    - management-and-governance
    - networking
name: Networking and connectivity for mission-critical workloads on Azure
azureCategories:
  - management-and-governance  
summary: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources.
products:
  - azure-monitor
  - azure-front-door
thumbnailUrl: /azure/architecture/browse/thumbs/mission-critical-online.png
content: |
   [!include[](mission-critical-networking.md)]
---

# Networking and connectivity for mission-critical workloads

The regional distribution of resources in the reference architecture requires a robust network infrastructure. 

A globally distributed design is recommended where Azure services come together to provide a highly available application. The load balancer combined with regional stamps provides that guarantee through reliable connectivity.

The regional stamps are the deployable unit in the architecture. The ability to quickly deploy a new stamp provide scalability and supports high availability. The stamps follow an isolated [virtual network design](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity#isolated-virtual-networks). Cross-stamp traffic isn't required or recommended. Virtual network peerings or VPN connections to other stamps aren't required.

The architecture is intentional in defining the regional stamps as short-lived. The global state of the infrastructure is stored in the regional resources.

A global load balancer is required to route traffic to healthy stamps and provide security services.

:::image type="content" source="./images/network-diagram-all-standard.png" alt-text="Diagram of network for reference architecture.":::

## Traffic ingress

The application defined in the architecture is internet facing and has several requirements:

* A routing solution that is global and can route between independent regional stamps.

* Low-latency failover between the regions.

* Health monitoring of the stamps to provide fail-over in the event of an application or networking issue.

* Prevention of malicious attacks at the edge.

The entry point for all traffic in the design is through Azure Front Door. Front Door is a global load balancer that routes HTTP(S) traffic to registered backends/origins. Front door uses health probes that issue requests to a URI in each backend/origin. In the reference implementation, the URI called is a health service. The health service advertises the health of the stamp. Front Door uses the response to determine the health of an individual stamp and route traffic to healthy stamps capable of servicing application requests.

Azure Front Door integration with Azure Monitor provides near real-time monitoring of security, success and failure metrics, and alerting.

Azure Web Application Firewall, integrated with Azure Front Door, is used to prevent attacks at the edge before they enter the network.

:::image type="content" source="./images/network-diagram-ingress-standard.png" alt-text="Diagram of network ingress for reference architecture.":::

## Isolated virtual network - API

The API in the architecture uses Azure Virtual Networks as the traffic isolation boundary. Components in one virtual network can't communicate directly with components in another virtual network.

When configuring IP address spaces and subnets within the virtual networks, allocation of sufficient IP addresses must be considered for the components within the infrastructure. Steps must be taken to ensure there enough IP address spaces for normal run operation and for failover. If a region becomes unavailable, consider the impact of the failover on IP address space in the other regions.

Requests to the compute platform are distributed with a standard SKU external Azure Load Balancer. All traffic that reaches the load balancer will have been inspected by Azure WAF. There is a check to ensure that traffic reaching the load balancer was routed via Azure Front Door. This check ensures that all traffic was inspected by the Azure WAF.

Agents used for the operations and deployment of the architecture must be able to reach into the isolated network. The isolated network can be opened up to allow the agents to communicate. Alternatively, self-hosted agents can be deployed in the virtual network. Opening up the network for the agents increases the attack vector. Consider using self-hosted agents instead of opening up the network for the Microsoft hosted agents.

Monitoring of the network throughput, performance of the individual components, and health of the application is required.

:::image type="content" source="./images/network-diagram-vnet.png" alt-text="Diagram of virtual network for the API and architecture.":::

## Application platform communication dependency

The application platform used with the individual stamps in the infrastructure, has the following communication requirements:

* The application platform must be able to communicate securely with Microsoft PaaS services.

* The application platform must be able to communicate securely with other services when needed.

The architecture as defined uses Azure Key Vault to store tokens to securely communicate over the internet to Azure PaaS services. There are possible risks to exposing the application platform over the internet for this communication. Tokens can be compromised and increased security and monitoring of the public endpoints is recommended.

:::image type="content" source="./images/network-diagram-vnet-paasdependencies-standard.png" alt-text="Diagram of the application platform communication dependencies.":::

## Enhanced networking

This section discusses the pros and cons of alternative approaches to the network design. Alternative networking considerations and the use of Azure Private endpoints is the focus in the following sections.

### Subnets and NSG

Subnets within the virtual networks can be used to segment traffic within the design. Subnet isolation separates resources for different functions.

Network security groups can be used control the traffic that is allowed in and out of each subnet. Rules used within the NSGs can be used limit traffic based on IP, port, and protocol to block unwanted traffic into the subnet.

### Private endpoints - Ingress

The premium SKU of Front Door supports the use of Azure Private Endpoints. Private endpoints expose an Azure service to a private IP address in a virtual network. Connections are made securely and privately between services without the need to route the traffic to public endpoints.

Azure Front Door premium and Azure Private Endpoints enable fully private compute clusters in the individual stamps. Traffic is fully locked down for all Azure PaaS services.

Reliability of the design is increased with the use of private endpoints. Public endpoints exposed in the application stamps are no longer needed and can no longer be accessed and exposed to a possible DDoS attack.

Front Door premium has an increased cost over the SKU used in the main architecture. The increased security and reliability must be weighed versus the increased cost and complexity. Fully private compute clusters for the application complicate the deployment.

Self-hosted Azure DevOps agents must be used for the stamp deployment. The management of these agents comes with a maintenance cost.

:::image type="content" source="./images/network-diagram-ingress.png" alt-text="Diagram of network ingress for reference architecture with private endpoints.":::

### Private endpoints - Application platform

Private endpoints are supported for several of the Azure PaaS services used in the design. With private endpoints configured for the application platform, all communication would travel through the Microsoft backbone network.

The public endpoints of the individual Azure PaaS services can be configured to disallow public access. This would isolate the resources from public attacks that could cause downtime and throttling which affect reliability and availability.

Managed identities could be used instead of tokens to access the Azure PaaS services. Managed identities improve security over the use of tokens for access.

For more information about Managed identities, see [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview).

Self-hosted Azure DevOps agents must be used for the stamp deployment the same as above. The management of these agents comes with a maintenance cost.

:::image type="content" source="./images/network-diagram-vnet-paasdependencies.png" alt-text="Diagram of the application platform communication dependencies with private endpoints.":::
