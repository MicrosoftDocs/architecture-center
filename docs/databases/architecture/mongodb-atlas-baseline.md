--- 
title: Deploy MongoDB Atlas in Azure
description: Deploy MongoDB Atlas in Azure to support a workload.
author: cloud-architect-dev
ms.author: devenwagle
ms.date: 11/12/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-data
---

# Deploy MongoDB Atlas in Azure

This article describes a recommended architecture for deploying MongoDB Atlas in a typical workload. The solution demonstrates how to establish secure, private connectivity between your workload's compute resources and a MongoDB Atlas cluster that is dedicated to the workload.

> [!IMPORTANT]
> ![GitHub logo.](_images/github.svg) This guidance is supported by an [example implementation](https://github.com/mongodb-partners/Azure-MongoDB-Atlas-Landing-Zone) that demonstrates this MongoDB Atlas solution on Azure.

## Architecture

This architecture provides a foundation for scalable, resilient, and secure application data workloads across both single-region and multi-region topologies. You should deploy the MongoDB Atlas service according to one of the following two deployment patterns, each designed to address different requirements for availability, resilience, and operational complexity.

### Single-region architecture

In the single-region deployment, all core components, including the MongoDB Atlas cluster, Azure Virtual Network, monitoring, and supporting application infrastructure, are provisioned within a single Azure region. This setup is ideal for applications with regional data residency requirements or when resilience to regional failure is not a primary concern.

#### Architecture diagram

:::image type="complex" source="_images/mongodb-atlas-single-region.png" alt-text="A diagram showing a single-region MongoDB Atlas deployment on Azure." lightbox="_images/mongodb-atlas-single-region.png":::
   A top monitoring rectangle shows App Insights left of Azure Service Log Analytics; both connect downward by a line to AMPLS, then a long vertical line descends into the main workload services area. That area has three vertical subnet strips: left strip labeled snet-private containing a box titled Example Compute Services with App Services left of Container Apps and a Network Security Group icon to its left; middle strip labeled snet-private-endpoints showing (top to bottom) Monitoring Private Endpoint, Key Vault Private Endpoint, Blob Storage Private Endpoint with dashed horizontal lines from the top endpoint to Azure Functions and from the middle endpoint to Azure Key Vault; right strip labeled snet-function-app containing Azure Functions above a Network Security Group. A separate virtual network column on the far right contains an Azure Key Vault icon aligned with the middle dashed connector. number 1 sits beside a Private Endpoint at the bottom of the left strip; a dashed vertical chain links it to a Private Link Service, then a Load Balancer, then a dashed horizontal line spanning three storage nodes labeled Primary node, Secondary node, Secondary node inside a lower green Managed MongoDB Atlas Resources box; number 2 is near the load balancer and number 3 overlays the Network Security Group in the right strip.
:::image-end:::

#### Workflow

The following steps describe the end-to-end workflow for the single-region scenario. Each step corresponds to a numbered element in the architecture diagram:

1. **Application or service**: Applications or services, are deployed in the subnet with the NSG and the NAT so that they are secured and have visibility to the MongoDB Atlas clusters. These can include web apps, backend services, analytics jobs, or integration tools.
2. **MongoDB Atlas Cluster**: The MongoDB Atlas clusters are visible through a private endpoint connection and the applications or services deployed in the secured Virtual Network can connect to them over private networking.
3. **Observability**: Because MongoDB Altas clusters don't have native Azure Monitor integrations, you need to periodically scrape the metrics API and send that data to Azure Monitor yourself. You can build a custom Azure Function App that periodically queries the MongoDB Atlas API to gather and store database health and performance metrics. That data can then be visualized in Application Insights dashboards and queried in Azure Monitor. The API doesn't currently support Microsoft Entra authentication, so you need to use a pre-shared key. This key is stored in Azure Key Vault.

Please read [this MongoDB Atlas article](https://www.mongodb.com/docs/atlas/architecture/current/deployment-paradigms/single-region/) for more detailed information on single region architecture.

### Multi-Region Architecture

For workloads with higher requirements for business continuity, the multi-region architecture distributes MongoDB Atlas cluster nodes and supporting infrastructure across multiple Azure regions in an active-passive topology. In this configuration, all nodes are members of a single cluster that you deploy, defining the node count and regions to deploy into. The design uses virtual network peering and multiple private endpoints to provide redundant connectivity, even in the event of a regional outage.

In this architecture, your workload compute is deployed in three regions. Each region connects to its own region's MongoDB Atlas resource.

#### Architecture diagram

:::image type="complex" source="_images/mongodb-atlas-multi-region.png" alt-text="A diagram illustrating a multi-region MongoDB Atlas architecture on Azure." lightbox="_images/mongodb-atlas-multi-region.png":::
   Across the upper third a monitoring box contains App Insights to the left of Azure Service Log Analytics, both connected downward via a line and AMPLS to Region 1. The central band shows three adjacent workload service areas: Region 1, Region 2, Region 3. Region 1 is subdivided into three vertical subnet strips labeled snet-private, snet-private-endpoints, and snet-function-app, with a virtual network column on the far right that contains Azure Key Vault. Inside the left strip a box titled Example Compute Services lists App Services left of Container Apps. A Network Security Group appears at the far left and again in the rightmost strip. Number 1 is beside a Private Endpoint at the bottom of Region 1, whose dashed vertical connection descends to a Private Link Service, then a Load Balancer, then horizontally to a Primary node and a Secondary node inside the lower green Managed MongoDB Atlas Resources Region 1 area; number 2 is near that Atlas area. Regions 2 and 3 each repeat a workload services rectangle with App Services left of Container Apps, a Private Endpoint at the bottom connected by dashed lines to separate Private Link Service and Load Balancer elements leading to Secondary nodes only in their respective Managed MongoDB Atlas Resources areas. Virtual network peering is indicated by horizontal connectors across the top between Region 1 and Region 2 and between Region 2 and Region 3. Number 3 is on Azure Functions within Region 1's right strip, and number 4 is on Azure Key Vault in the virtual network column between Regions 1 and 2.
:::image-end:::

#### Workflow

The following steps outline the multi-region scenario, with numbering matching the architecture diagram:

1. **Application or service**: Applications or services, are deployed in the subnet with the NSG and the NAT so that they are secured and have visibility to the MongoDB Atlas clusters. These can include web apps, backend services, analytics jobs, or integration tools.
2. **MongoDB Atlas cluster**: The MongoDB Atlas clusters are visible through a private endpoint connection and the applications or services deployed in the secured Virtual Network can connect to them over private networking.
3. **Observability**: An Azure Function App periodically queries the MongoDB Atlas API using a pre-shared key stored in Azure Key Vault to gather database health and performance metrics. The metrics are visualized in Application Insights dashboards. In this design, if the entire primary region is offline, the Function app would need to be redeployed into the new primary region. If only the primary node fails over, monitoring wouldn't be affected.
4. **Resiliency**: VNet Peering is enabled so that in case of a regional outage, all remaining regions have visibility to the rest of the MongoDB Atlas clusters. MongoDB Atlas manages connection string routing, so failover is transparent to the application.

Please read [this MongoDB Atlas article](https://www.mongodb.com/docs/atlas/architecture/current/deployment-paradigms/multi-region/#5-node--3-region-architecture--2-2-1-) for more detailed information on 5-Node, 3-Region Architecture (2+2+1).

## Components

The architecture brings together several core components to deliver security, scalability, and operational excellence:

- **[MongoDB Atlas (Managed Service)](/azure/partner-solutions/mongo-db/overview)**: Provides managed database clusters with automated backups, high availability, and optional multi-region deployment. Atlas role-based access control (RBAC) ensures fine-grained data security. Clusters are automatically deployed across availability zones in regions that support availability zones.
- **Azure Virtual Networks and [Private Endpoints](/azure/private-link/private-endpoint-overview)**: Ensure all communications between Azure resources and MongoDB Atlas are private and encrypted, never traversing the public internet.
- **Network Security Groups (NSGs)**: Enforce network segmentation and secure outbound connectivity.
- **Observability**: [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview) and [Function Apps](/azure/azure-functions/functions-overview) provide centralized monitoring and operational visibility. 
- **Azure Key Vault:** Stores the pre-shared key for MongoDB Atlas API authentication and any application secrets you might need for your use case.
- **Infrastructure automation**: Terraform modules and GitHub Actions enable infrastructure as code, automation, and repeatable deployments.

## Security considerations

Most databases store sensitive data. Implementing security only at the database level isn't enough to secure the workloads. Defense in-depth is a comprehensive approach to security that implements multiple layers of defense mechanisms to protect data. Instead of relying on a single security measure at a specific level, such as focusing only on network security mechanisms, the defense in-depth strategy uses a combination of different layer security measures to create a robust security posture. You can architect the defense in-depth approach for MongoDB Atlas workloads by using hardened network security with private endpoints and virtual network peering from the Azure infrastructure side. For detailed information about MongoDB Atlas security features, see [MongoDB Atlas Security](https://www.mongodb.com/docs/atlas/setup-cluster-security/).

The Azure infrastructure hosting applications that connect to MongoDB Atlas must be secured against unauthorized access. In this architecture, MongoDB Atlas connectivity is established through private endpoints, which ensures all traffic between the workload and databases only traverses private networking.

Use Azure Key Vault to store keys and secrets, like the client secret used for the monitoring function in this architecture.

Depending on your use case and requirements, evaluate whether additional Microsoft security services beyond those listed, like Azure Firewall, Azure DDoS Protection, and Defender for Cloud are appropriate for your environment. Depending on your architecture and threat model, you may also want to consider among other options:
>
> - [Azure Web Application Firewall (WAF)](/azure/web-application-firewall/overview)
> - [Defender for App Service](/azure/defender-for-cloud/defender-for-app-service-introduction)
> - [Defender for Servers](/azure/defender-for-cloud/defender-for-servers-overview)
> - [Microsoft Entra Global Secure Access (GSA)](/entra/global-secure-access/overview-what-is-global-secure-access)

### Egress control

In this architecture, there is minimal egress control for outbound traffic originating from the workload's virtual network. Traffic is controlled through Network Security Groups on the subnets. The MongoDB Atlas cluster has no egress control enabled. Depending on your workloads's security policies, you might need to implement additional egress control to restrict outbound traffic to only approved destinations. For Azure components, direct outbound traffic through your egress firewall. For the MongoDB Altas cluster, consult [Guidance for Atlas Network Security](https://www.mongodb.com/docs/atlas/architecture/current/network-security/) for outbound network control options.

## Monitoring considerations

Monitoring is a crucial part of workload operations. Design a comprehensive workload [monitoring solution](/azure/well-architected/operational-excellence/observability).

This architecture includes a monitoring component, as shown in the architecture diagrams, where an Azure Function App periodically queries the MongoDB Atlas API to gather database health and performance metrics, which are visualized in the Application Insights dashboards. If you use this solution to capture metrics, you can use the included code as a starting point for your use case. Then, you can determine the right metrics to capture and the frequency to run the function to meet your requirements.

Beyond this solution, you can further extend your monitoring solution to gain deeper insights into your cluster's performance and health. Refer to the [How to Monitor MongoDB](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor) article for more information about:

- [Scan and order](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#1-scan-and-order)
- [Query targeting](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#2-query-targeting)
- [Normalized System CPU](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#3-normalized-system-cpu)
- [Performance Advisor](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#4-performance-advisor)
- [Namespace Insights](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#5-namespace-insights)
- [Query Profiler](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#6-query-profiler)
- [Billing Cost Explorer](https://www.mongodb.com/resources/products/capabilities/how-to-monitor-mongodb-and-what-metrics-to-monitor#7-billing-cost-explorer)

Configure alerts to notify on metric drift from your baseline (for example, rising query targeting, any scan-and-order, or normalized CPU sustained >70% or <40%). For more information, review the [Monitoring and Alerts](https://www.mongodb.com/docs/atlas/monitoring-alerts/) article.

> [!NOTE]
> Azure Monitor cannot read Atlas metrics directly. Use Atlas [webhooks](https://www.mongodb.com/docs/atlas/cli/current/command/atlas-integrations-create-WEBHOOK/) or supported [integrations](https://www.mongodb.com/docs/atlas/tutorial/third-party-service-integrations/#view-third-party-integrations) to ingest them.

MongoDB Atlas collects and stores activity logs that you can download for auditing and for activity tracking. These logs can help you with performance tracking and troubleshooting. Refer to the [Guidance for Atlas logging](https://www.mongodb.com/docs/atlas/architecture/current/logging/#std-label-arch-center-logging) article for detailed guidance on using Atlas logs.

## Backup and recovery

MongoDB Atlas automated backup policies ensure that data can be restored to any point in time, within retention limits. Refer to the [Cloud backups](https://www.mongodb.com/docs/atlas/backup-restore-cluster/?msockid=2137d3960740658d00a8c67106e864ed#cloud-backups) documentation for full details.

## Next Steps

To deploy this architecture, follow the step-by-step instructions and Terraform automation in the [MongoDB Atlas reference implementation GitHub repository](https://github.com/mongodb-partners/Azure-MongoDB-Atlas-Landing-Zone).
