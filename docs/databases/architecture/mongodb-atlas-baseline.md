--- 
title: Deploy MongoDB Atlas in Azure
description: Deploy MongoDB Atlas in Azure with secure private connectivity by using single-region and multi-region architectures for scalable workloads.
author: cloud-architect-dev
ms.author: devenwagle
ms.date: 11/12/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-data
ai-usage: ai-assisted
---

# Deploy MongoDB Atlas in Azure

This article describes a recommended architecture for deploying MongoDB Atlas in a typical workload. The solution demonstrates how to establish secure, private connectivity between your workload's compute resources and a MongoDB Atlas cluster that's dedicated to the workload.

> [!IMPORTANT]
> ![GitHub logo.](_images/github.svg) This guidance is supported by an [example implementation](https://github.com/Azure/mongodb-atlas-landing-zone-accelerator) that demonstrates this MongoDB Atlas solution on Azure.

## Architecture

This architecture provides a foundation for scalable, resilient, and secure application data workloads across both single-region and multi-region topologies. Deploy the MongoDB Atlas service by using one of the following two deployment patterns. Each pattern is designed to meet different requirements for availability, resilience, and operational complexity.

### Single-region architecture

In the single-region deployment, all core components, including the MongoDB Atlas cluster, Azure Virtual Network, monitoring, and supporting application infrastructure, are provisioned within a single Azure region. This setup is ideal for applications that have regional data residency requirements or when resilience to regional failure isn't a priority.

#### Architecture

:::image type="complex" source="_images/mongodb-atlas-single-region.svg" alt-text="A diagram that shows a single-region MongoDB Atlas deployment on Azure." lightbox="_images/mongodb-atlas-single-region.svg" border="false":::
   The diagram shows a single-region Azure architecture with MongoDB Atlas. At the top, Application Insights and Log Analytics workspace connect through Azure Monitor Private Link Scope (AMPLS) to the workload services below. The main workload area has three subnets: snet-private with compute services (App Service and Container Apps), snet-private-endpoints with monitoring and storage private endpoints, and snet-function-app with Azure Functions. Azure Key Vault is shown to the right of the virtual network. The MongoDB Atlas cluster at the bottom includes one primary node and two secondary nodes that are connected through a private endpoint, Private Link service, and load balancer. Numbers 1, 2, and 3 indicate the private endpoint connection, load balancer, and network security group respectively.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mongodb-atlas-single-region.vsdx) of this architecture*

#### Workflow

The following workflow corresponds to the previous diagram:

1. Applications or services are deployed in a subnet protected by a network security group (NSG) and configured with network address translation (NAT) so that they're secured and can connect to the MongoDB Atlas clusters. These deployments can include web apps, back-end services, analytics jobs, or integration tools.

1. The MongoDB Atlas clusters can be accessed through a private endpoint connection and the applications or services deployed in the secured virtual network can connect to them over private networking.

1. Because MongoDB Atlas clusters don't have Azure Monitor-native integrations, you must periodically scrape the metrics API and send that data to Azure Monitor. You can build a custom Azure Functions app that periodically queries the MongoDB Atlas API to gather and store database health and performance metrics. That data can then be visualized in Application Insights dashboards and queried in Azure Monitor. The API doesn't currently support Microsoft Entra authentication, so you must use a preshared key. This key is stored in Azure Key Vault.

For more information about a single region architecture, see [Single-region deployment paradigm](https://www.mongodb.com/docs/atlas/architecture/current/deployment-paradigms/single-region/).

### Multi-region architecture

For workloads that have higher requirements for business continuity, the multi-region architecture distributes MongoDB Atlas cluster nodes and infrastructure that supports them across multiple Azure regions in an active-passive topology. In this configuration, all nodes are members of a single cluster that you deploy, which defines the node count and regions to deploy into. The design uses virtual network peering and multiple private endpoints to provide redundant connectivity, even if a regional outage occurs.

In this architecture, your workload compute is deployed in three regions. Each region connects to its own region's MongoDB Atlas resource.

#### Architecture

:::image type="complex" source="_images/mongodb-atlas-multi-region.svg" alt-text="A diagram that illustrates a multi-region MongoDB Atlas architecture on Azure." lightbox="_images/mongodb-atlas-multi-region.svg" border="false":::
   The diagram shows a three-region Azure architecture with MongoDB Atlas. At the top, Application Insights and Log Analytics workspace connect through Azure Monitor Private Link Scope (AMPLS) to Region 1. The architecture spans three regions connected by virtual network peering. Region 1 includes the primary MongoDB Atlas node with compute services (App Service and Container Apps), private endpoints, Azure Functions, and Azure Key Vault. Regions 2 and 3 each contain secondary MongoDB Atlas nodes with their own compute services and private endpoint connections. Each region's MongoDB Atlas resources include Private Link service and a load balancer. The MongoDB Atlas cluster consists of one primary node in Region 1 and secondary nodes in Regions 2 and 3. Numbers 1-4 indicate the private endpoint connections, MongoDB Atlas resources, Azure Functions, and Key Vault respectively.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mongodb-atlas-multi-region.vsdx) of this architecture*

#### Workflow

The following workflow corresponds to the previous diagram:

1. Applications or services are deployed in a subnet protected by an NSG and configured with NAT so that they're secured and can connect to the MongoDB Atlas clusters. These deployments can include web apps, back-end services, analytics jobs, or integration tools.

1. The MongoDB Atlas clusters can be accessed through a private endpoint connection, and the applications or services deployed in the secured virtual network can connect to them over private networking.

1. An Azure Functions app periodically queries the MongoDB Atlas API by using a preshared key stored in Key Vault to gather database health and performance metrics. The metrics are visualized in Application Insights dashboards. In this design, if the entire primary region is offline, the Azure Functions app needs to be redeployed into the new primary region. If only the primary node fails over, monitoring isn't affected.

1. Virtual network peering is enabled so that if a regional outage occurs, all remaining regions can connect to the MongoDB Atlas clusters in other regions. MongoDB Atlas manages connection string routing, so failover requires no application changes.

For more information, see [5-Node, 3-Region Architecture (2+2+1)](https://www.mongodb.com/docs/atlas/architecture/current/deployment-paradigms/multi-region/#5-node--3-region-architecture--2-2-1-).

## Components

- [MongoDB Atlas (managed service)](/azure/partner-solutions/mongo-db/overview) is a managed cloud database service that provides managed database clusters with automated backups, high availability, and optional multi-region deployment. In this architecture, MongoDB Atlas serves as the primary data store for applications. MongoDB Atlas role-based access control (RBAC) ensures fine-grained data security. Clusters are automatically deployed across availability zones in regions that support availability zones.

- [Virtual Network](/azure/well-architected/service-guides/virtual-network) is a fundamental Azure building block for private networks that enable secure communication between Azure resources. In this architecture, Virtual Network provides isolated network environments that host application compute resources and establish private connectivity to MongoDB Atlas.

- [Private endpoints](/azure/private-link/private-endpoint-overview) are network interfaces that connect privately and securely to services that Azure Private Link supports. In this architecture, private endpoints ensure that all communications between Azure resources and MongoDB Atlas are private and encrypted and never traverse the public internet.

- [NSGs](/azure/virtual-network/network-security-groups-overview) are the Azure-native network firewall that controls inbound and outbound traffic to network interfaces. In this architecture, NSGs enforce network segmentation and secure outbound connectivity.

- [Application Insights](/azure/azure-monitor/app/app-insights-overview) is an extensible application performance management service for developers and development operations (DevOps) professionals. In this architecture, Application Insights provides centralized monitoring and operational visibility for the workload.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless compute service that lets you run event-triggered code without having to explicitly provision or manage infrastructure. In this architecture, Azure Functions periodically queries the MongoDB Atlas API to gather database health and performance metrics.

- [Key Vault](/azure/key-vault/general/overview) is a cloud service that securely stores and accesses secrets, keys, and certificates. In this architecture, Key Vault stores the preshared key for MongoDB Atlas API authentication and any application secrets that you might need for your use case.

- Infrastructure automation tools like [Terraform](/azure/developer/terraform/overview) and [GitHub Actions](/azure/developer/github/github-actions) enable infrastructure as code (IaC), automation, and repeatable deployments. In this architecture, these tools provide consistent and reliable deployment processes for the MongoDB Atlas infrastructure.

## Security considerations

Most databases store sensitive data. Implementing security only at the database level isn't enough to secure the workloads. Defense in-depth is an approach to security that implements multiple layers of defense mechanisms to protect data. Instead of relying on a single security measure at a specific level, like an approach that focuses only on network security mechanisms, the defense in-depth strategy uses a combination of different layer security measures to create a robust security posture. You can architect the defense in-depth approach for MongoDB Atlas workloads by using hardened network security with private endpoints and virtual network peering from the Azure infrastructure side. For more information, see [MongoDB Atlas security](https://www.mongodb.com/docs/atlas/setup-cluster-security/).

The Azure infrastructure that hosts applications that connect to MongoDB Atlas must be secured against unauthorized access. In this architecture, MongoDB Atlas connectivity is established through private endpoints. This approach ensures that all traffic between the workload and databases only traverses private networking.

Use Key Vault to store keys and secrets, like the client secret used for the monitoring function in this architecture.

Depending on your use case and requirements, evaluate whether other Microsoft security services are appropriate for your environment, like Azure Firewall, Azure DDoS Protection, and Microsoft Defender for Cloud. Depending on your architecture and threat model, you might also consider the following options:

- [Azure Web Application Firewall](/azure/web-application-firewall/overview)
- [Defender for App Service](/azure/defender-for-cloud/defender-for-app-service-introduction)
- [Defender for Servers](/azure/defender-for-cloud/defender-for-servers-overview)
- [Global Secure Access](/entra/global-secure-access/overview-what-is-global-secure-access)

### Egress control

In this architecture, there's minimal egress control for outbound traffic that originates from the workload's virtual network. Traffic is controlled through NSGs on the subnets. The MongoDB Atlas cluster has no egress control enabled. Depending on your workload's security policies, you might need to implement extra egress control to restrict outbound traffic to only approved destinations. For Azure components, direct outbound traffic through your egress firewall. For more information about outbound network control options for the MongoDB Atlas cluster, see [Guidance for MongoDB Atlas network security](https://www.mongodb.com/docs/atlas/architecture/current/network-security/).

## Monitoring considerations

Monitoring is a crucial part of workload operations. Design a comprehensive [workload monitoring solution](/azure/well-architected/operational-excellence/observability).

This architecture includes a monitoring component, as shown in the architecture diagrams, where an Azure Functions app periodically queries the MongoDB Atlas API to gather database health and performance metrics. These metrics are visualized in Application Insights dashboards. If you use this solution to capture metrics, you can use the included code as a starting point for your use case. Then you can determine the right metrics to capture and the frequency to run the function to meet your requirements.

Beyond this solution, you can further extend your monitoring solution to gain deeper insights into your cluster's performance and health. For more information about how to [monitor MongoDB](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor), see the following monitoring and optimization features:

- [Scan and order](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#1-scan-and-order)
- [Query targeting](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#2-query-targeting)
- [Normalized system CPU](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#3-normalized-system-cpu)
- [Performance Advisor](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#4-performance-advisor)
- [Namespace Insights](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#5-namespace-insights)
- [Query Profiler](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#6-query-profiler)
- [Billing Cost Explorer](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#7-billing-cost-explorer)

Configure alerts to notify on metric drift from your baseline, like rising query targeting, any scan-and-order queries, or normalized CPU sustained below 40% or above 70%. For more information, see [Monitoring and alerts](https://www.mongodb.com/docs/atlas/monitoring-alerts/).

> [!NOTE]
> Azure Monitor can't read MongoDB Atlas metrics directly. Use MongoDB Atlas [webhooks](https://www.mongodb.com/docs/atlas/cli/current/command/atlas-integrations-create-WEBHOOK/) or supported [integrations](https://www.mongodb.com/docs/atlas/tutorial/third-party-service-integrations/#view-third-party-integrations) to ingest them.

MongoDB Atlas collects and stores activity logs that you can download for auditing and activity tracking. These logs can help you track performance and troubleshoot problems. For more information, see [Guidance for MongoDB Atlas logging](https://www.mongodb.com/docs/atlas/architecture/current/logging/#std-label-arch-center-logging).

## Backup and recovery

MongoDB Atlas automated backup policies ensure that data can be restored to any point in time, within retention limits. For more information, see [Cloud backups](https://www.mongodb.com/docs/atlas/backup-restore-cluster/?msockid=2137d3960740658d00a8c67106e864ed#cloud-backups).

## Next step

To deploy this architecture, follow the step-by-step instructions and Terraform automation in the [MongoDB Atlas reference implementation GitHub repository](https://github.com/Azure/mongodb-atlas-landing-zone-accelerator).
