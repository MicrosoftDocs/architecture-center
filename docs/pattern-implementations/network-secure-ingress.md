---
title: Network secure ingress pattern implementation with Azure Front Door Premium tier
description: The pattern implementation for network secure ingress illustrates global routing, health-based origin failover, and attack mitigation at the edge.
author: claytonsiemens77
ms.author: pnp
ms.date: 09/04/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-web
ai-usage: ai-assisted
---

# Pattern implementation for network secure ingress

Network secure ingress encapsulates several design patterns, including the patterns for global routing, global offloading, and health endpoint monitoring. You can use the pattern implementation in this article as a gateway for most HTTP or HTTPS workloads that require high availability or reliability by providing secure global routing to workloads in different regions with health-based origin failover.

## Video: Network secure ingress implementation

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=163c161c-0f7e-4fea-b126-c8f540fc84e0&embedUrl=/azure/architecture/pattern-implementations/network-secure-ingress]

## Pattern requirements

This article describes three requirements that the pattern implementation for network secure ingress focuses on: global routing, health-based origin failover, and attack mitigation at the edge.

### Global routing

The network secure ingress pattern encapsulates the global routing pattern. As such, the implementation can route requests to workloads in different regions.

:::image type="content" source="_images/secure-ingress-use-case-one.png" alt-text="Diagram that shows an HTTPS request being routed to two workloads in different regions.":::

### Health-based origin failover

The implementation must identify healthy and unhealthy origins and route requests away from unhealthy origins. The health-probe interval and sample settings determine how quickly Azure Front Door detects a change in origin health. Configure these settings to meet the workload's failover target without causing unnecessary failovers.

:::image type="content" source="_images/secure-ingress-use-case-two.png" alt-text="Diagram that shows an HTTPS request not being routed to an unhealthy workload.":::

### Mitigating attacks at the edge

Mitigating attacks at the edge necessitates the "network secure" part of the implementation. The workloads or platform as a service (PaaS) services shouldn't be accessible via the internet. Internet traffic should only be able to route through the gateway. The gateway should have the ability to mitigate exploits.

:::image type="content" source="_images/secure-ingress-use-case-three.png" alt-text="Diagram that shows an HTTPS request with a SQL statement in the query string being stopped at the edge.":::

## Patterns

This solution implements the following design patterns:

- [Gateway routing pattern](../patterns/gateway-routing.yml): Route requests to multiple services or service instances that can reside in different regions.
- [Gateway offloading pattern](../patterns/gateway-offloading.yml): Offload functionality, such as mitigating attacks, to a gateway proxy.
- [Health endpoint monitoring pattern](../patterns/health-endpoint-monitoring.yml): Expose endpoints that validate the health of the workload.

## Design

:::image type="complex" source="_images/network-diagram-ingress.png" alt-text="Diagram that shows a request flowing through Azure Front Door Premium to regional stamps.":::
    The diagram shows an HTTPS request flowing to an Azure Front Door Premium box, which has a web application firewall in it. This illustration shows the integration between Azure Front Door Premium and Azure Web Application Firewall. The diagram then shows the request flowing through Private Link to two stamps in different regions. Each stamp has a static website and an internal load balancer. The requests flow through Private Link to the static websites and the load balancers in both stamps.
:::image-end:::

This implementation includes the following details:

- It uses Azure Blob Storage accounts to simulate static web workloads running in two regions. This implementation doesn't include any workloads running behind an internal load balancer (ILB). The diagram shows an ILB to illustrate that this implementation would work for private workloads running behind an ILB.

- It uses Azure Front Door Premium tier as the global gateway.

- The Azure Front Door instance has a global web application firewall (WAF) policy configured with managed rules that help protect against common exploits.

- The storage account firewalls deny public network access so that clients can't bypass Azure Front Door and its security controls.

- The Azure Front Door Premium tier accesses the storage accounts via Azure Private Link.

- The Azure Front Door instance has the following high-level configuration:

  - An endpoint with a single route that points to a single origin group. An origin group is a collection of origins.

  - The origin group has an origin configured to point to each storage account.

  - Each origin requests Private Link access to the storage account.

  - The origin group has health probes configured to access an HTML page in the storage accounts. The page verifies the availability of the static workload. For application workloads, use a health endpoint that checks the critical dependencies required to serve requests.
  
    This implementation considers an origin healthy when three of the last four probes succeed. The probe interval and sample settings determine how quickly Front Door detects a change in origin health.
  
## Components

- [Azure Web Application Firewall](/azure/web-application-firewall/overview) is a security service that protects web applications from common threats and vulnerabilities by using Microsoft-managed rule sets. In this architecture, Azure Web Application Firewall integrates with Azure Front Door Premium to inspect and block malicious HTTP and HTTPS traffic before it reaches origins.

- [Azure Private Link](/azure/private-link/private-link-overview) is a service that enables private connectivity to Azure PaaS services over the Microsoft backbone network. In this architecture, it allows Azure Front Door to securely access storage accounts without exposing them to the public internet.

- [Azure Front Door Premium](/azure/well-architected/service-guides/azure-front-door) is a global application delivery network that provides layer-7 load balancing, routing, and security features. In this architecture, it serves as the secure global gateway. It routes traffic to regional workloads and enforces Web Application Firewall policies while communicating privately via Private Link. The Premium tier supports the following components:

  - [Private Link](/azure/frontdoor/private-link) enables Azure Front Door to connect to PaaS services or workloads in a private virtual network. In this architecture, Azure Front Door uses Private Link to reach each storage origin without traversing the public internet.

  - [Microsoft-managed rule sets](/azure/web-application-firewall/afds/waf-front-door-drs) are available only in the Premium tier of Azure Front Door. In this architecture, Azure Web Application Firewall uses managed rules to inspect incoming requests and block requests that reach the configured anomaly-score threshold.

- [Azure Storage](/azure/well-architected/service-guides/azure-blob-storage) is a scalable cloud storage service for structured and unstructured data. In this architecture, Blob Storage accounts store static web assets and serve as the origin targets for Azure Front Door routing.

- An [ILB](/azure/well-architected/service-guides/azure-load-balancer) distributes private IP traffic within a virtual network or across connected networks. In this architecture, expose the origin web servers behind the ILB through an [Azure Private Link service](/azure/private-link/create-private-link-service-portal) so that Azure Front Door can use the ILB as a custom private origin.

### Operations

Securing resources from a network perspective helps protect against exploits, but it also isolates the resources from processes or administrators who might need to access those resources. For example, a build agent in a DevOps pipeline might need to access the storage account in order to deploy an update to the web application. Also, an administrator might need to access the resource for troubleshooting purposes.

To illustrate access to network-secured resources for operational purposes, this implementation deploys a virtual machine (VM) in a virtual network that has Private Link access to the storage accounts. This implementation deploys Azure Bastion, which the administrator can use to connect to the VM. For the deployment scenario, you could deploy a private build agent to the virtual network, similar to how the VM was.

Here are details about the components for operations:

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that enables secure communication between resources. In this architecture, the virtual network contains the components required for an administrator to securely communicate with the storage account over the private Microsoft backbone network.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure-as-a-service (IaaS) offering that provides scalable compute resources. In this architecture, a VM serves as a jump box for administrators to securely access network-secured resources.

- [Azure Bastion](/azure/bastion/bastion-overview) is a managed PaaS that provides Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to VMs without exposing public IP addresses. In this architecture, it enables administrators to connect to the jump box VM over SSH for secure operations.

- A [private endpoint](/azure/private-link/private-endpoint-overview) is a network interface that connects to Azure services through Private Link and uses a private IP address from the virtual network. In this architecture, the private endpoint connects resources in the virtual network to the storage account over its private IP address.

- A [private Azure DNS zone](/azure/dns/private-dns-privatednszone) is a Domain Name System (DNS) service that resolves domain names to private IP addresses within a virtual network. In this architecture, it resolves the storage account's Private Link host name to its private IP address, which enables secure access from the VM.

## Web request flow

:::image type="complex" source="_images/network-diagram-ingress-user-flow.png" alt-text="Diagram that shows the flow for a web request.":::
    The diagram shows a user making a web request to Azure Front Door. In the Azure Front Door box, the diagram shows each of the steps of the Azure Front Door routing flow. The flow highlights the step where WAF rules are evaluated, where the Azure Front Door route is matched and an origin group is selected, and where the origin is selected from the origin group. The last highlighted piece is where Azure Front Door connects to the Azure Blob Storage account via Private Link.
:::image-end:::

1. The user issues an HTTP or HTTPS request to an Azure Front Door endpoint.

2. The WAF rules are evaluated. Managed rules that use anomaly scoring add to the request's anomaly score when they match. This architecture runs in prevention mode, and WAF applies the **Block** action when the request reaches the anomaly-score threshold. Blocked requests don't reach an origin.

3. The route configured in Azure Front Door is matched and the correct origin group is selected. In this example, the path was to the static content in the website.

4. The origin is selected from the origin group.

   a. In this example, the health probes deemed the website unhealthy, so it's eliminated from the possible origins.  
   b. This website is selected.

5. The request is routed to the Azure Storage account through Private Link over the Microsoft backbone network.

For more information about the Azure Front Door routing architecture, see [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture).

## Operational flow

:::image type="complex" source="_images/network-diagram-ingress-with-vnet.png" alt-text="Diagram that shows the flow that an administrator would use to connect to a protected resource.":::
    The diagram has three parts. The first part shows Azure Blob Storage acting as a static website. Azure Front Door connects through Private Link to the storage account. The second part is a box that represents a virtual network. The virtual network has subnets and their contents. These subnets include a private endpoint subnet that contains a private endpoint with an IP address of 10.0.2.5, a jump box subnet with a jump box virtual machine, and an Azure Bastion subnet with Azure Bastion in it. The third part is an administrative user who is using SSH to access the jump box VM in the virtual network via Azure Bastion. An arrow goes from the VM to the private Azure DNS zone. The last arrow goes from the VM to the private endpoint and then to the storage account.
:::image-end:::

1. An administrator connects to the Azure Bastion instance that's deployed in the virtual network.

2. Azure Bastion provides SSH connectivity to the jump box VM.

3. The administrator on the jump box tries to access the storage account via the Azure CLI. The jump box queries DNS for the public Azure Blob Storage account endpoint: `storageaccountname.blob.core.windows.net`.

   The public DNS name is an alias for `storageaccountname.privatelink.blob.core.windows.net`. The private Azure DNS zone resolves that name to the private endpoint's IP address, which is 10.0.2.5 in this example.

4. The jump box connects to the storage account through the private endpoint.

## Considerations

Keep the following points in mind when you use this solution.

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/well-architected/reliability/).

Consider the following reliability implications when you use this pattern:

- Deploy redundant origins in separate regions, and configure health probes so that Azure Front Door routes requests only to origins that can serve them. Define a failover target based on workload requirements, and tune the probe interval, sample size, and required successful samples to meet that target without causing unnecessary failovers.

- [Keep content consistent across the storage origins](/azure/reliability/reliability-storage-blob#custom-multiregion-solutions-for-resiliency). Publish the same versioned release to each Storage account. If you use [object replication](/azure/storage/blobs/object-replication-overview), account for asynchronous replication.

- Test origin failure and recovery regularly. Validate failure detection, routing to a healthy origin, and failback behavior. If every origin in an origin group fails its health probes, Azure Front Door treats all origins as unhealthy and distributes requests across all of them in a round-robin pattern.

- For origins that use Private Link, configure origins with different Azure Front Door Private Link regions. This configuration provides separate paths through the Azure Front Door regional clusters. Select a supported Private Link region near each origin to limit the latency of the extra network hop.

- Azure Front Door remains the single global ingress service in this design. For a [mission-critical workload](../guide/networking/global-web-applications/mission-critical-global-http-ingress.md) that can't tolerate an Azure Front Door outage, evaluate a tested alternate ingress path. An alternate path increases cost and operational complexity because you must maintain equivalent routing, security, certificate, monitoring, and failover configurations.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/well-architected/security/).

Use the following security practices when you implement this pattern:

- Configure each origin to reject traffic that doesn't arrive through Azure Front Door. For the storage origins in this implementation, use the storage account firewall to deny public network access and approve the [private endpoint connection that Azure Front Door manages](/azure/frontdoor/private-link).

- Use the [latest available Default Rule Set](/azure/web-application-firewall/afds/waf-front-door-drs). Keep production policies in prevention mode.

- Apply [WAF exclusions and rule overrides](/azure/web-application-firewall/afds/waf-front-door-tuning) at the narrowest practical scope. Prefer a rule-level exclusion for a specific request attribute over disabling a rule or rule group.

- Use [Bot Manager rules](/azure/web-application-firewall/afds/waf-front-door-policy-configure-bot-protection) and [rate-limit rules](/azure/web-application-firewall/afds/waf-front-door-rate-limit).

- Enable resource activity, Azure Front Door access, WAF, and health-probe logs. Send the logs to the workload's monitoring and security systems, and configure alerts for unexpected increases in WAF rule matches or blocked requests, origin health failures, and changes to WAF policies. For more information, see [Monitor metrics and logs in Azure Front Door](/azure/frontdoor/monitor-front-door).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/well-architected/cost-optimization/).

Azure Front Door Premium costs more than the Standard tier. The Premium tier includes managed WAF rules and Private Link origin support. Review the following resources to learn more about pricing for Azure Front Door and Web Application Firewall:

- [Azure Front Door pricing](https://azure.microsoft.com/pricing/details/frontdoor/)
- [Web Application Firewall pricing](https://azure.microsoft.com/pricing/details/web-application-firewall/)
- [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator)

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/well-architected/operational-excellence/).

Implementing network security boundaries adds complexity to operations and deployment. Keep these points in mind:

- The [IP ranges for Microsoft-hosted agents vary over time](/azure/devops/pipelines/agents/hosted#networking). Consider implementing self-hosted agents in your virtual network.
- Implement [Azure Bastion](/azure/bastion/bastion-overview) for scenarios where operations teams need to access network-secured resources.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands that users place on it. For more information, see [Overview of the performance efficiency pillar](/azure/well-architected/performance-efficiency/).

Global routing enables horizontal scaling through the deployment of more resources in the same region or different regions.

## Next step

> [!div class="nextstepaction"]
> [Architecture best practices for Azure Front Door](/azure/well-architected/service-guides/azure-front-door)
