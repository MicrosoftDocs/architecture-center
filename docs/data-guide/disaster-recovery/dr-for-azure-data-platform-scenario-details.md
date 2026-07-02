---
title: Disaster Recovery for an Azure Data Platform - Scenario Details
description: Learn about disaster recovery impact and activities for each Azure data platform component across datacenter, availability zone, and regional failure scenarios.
author: lponnam75
ms.author: lsuryadevara
ms.date: 12/18/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Disaster recovery scenario details for an Azure data platform

This article is the third in a series about disaster recovery (DR) for an Azure data platform. It describes the DR impact and required activities for each component in the data platform across different failure scenarios, including Azure datacenter failures, availability zone failures, and regional failures.

## Data service topology

The following diagram shows the key functions of the Contoso data ecosystem at a high level. It provides context for the DR scenario deployments described in the following sections, including DR strategy selection and division of recovery responsibilities.

:::image type="complex" source="../images/dr-for-azure-data-contoso-service-topology.png" alt-text="Diagram of the high-level Contoso data service topology." lightbox="../images/dr-for-azure-data-contoso-service-topology.png" border="false":::
The diagram is titled simplified high-level topology and shows two boundary boxes. The outer box is labeled Contoso and contains three elements: source systems on the left, enterprise shared services in the center (listing access and authorization, audit and logging, and alerting and incidents), and dependent services on the right. An upward arrow from enterprise shared services points into the inner box. The inner box is labeled Azure and contains a nested white box labeled data platform. The data platform box holds three identical solution rows labeled solution 1 through solution 3, each described as ingest/transform/serve. Below those rows, a box labeled platform foundation lists access and authorization, platform services including audit and logging, networking and gateways, and shared data components. Outside the Azure box, a box on the left is labeled external sources and a box on the right is labeled external dependent services. Dashed arrows show data flow from external sources into the data platform solutions and from the data platform solutions to external dependent services. Other dashed arrows point from Contoso source systems to each solution and from solution one and two to dependent services.
:::image-end:::

## DR impact vs. customer activity

The following sections describe what Contoso must do for DR events of varying scope and impact.

### Area: Foundational components

- **Microsoft Entra ID including role entitlements**

    - Contoso SKU selection: Premium P1
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable

- **Management groups**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable

- **Subscriptions**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable

- **Azure Key Vault**

    - Contoso SKU selection: Standard
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable

- **Azure Monitor**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable

- **Microsoft Defender for Cloud**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable

- **Microsoft Cost Management**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable

- **Azure DNS**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable

- **Virtual networks, including subnets, user-defined routes (UDRs), and network security groups (NSGs)**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Contoso must redeploy the foundation and data platform virtual networks with their attached UDRs and NSGs into the secondary region.
    - Notes:
        - Use [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) to geo-route traffic between regions that host replica virtual network structures.
        - If both virtual networks share the same address space, you can't connect them both to your on-premises network simultaneously because it causes routing conflicts. When a disaster takes down one region's virtual network, connect the other virtual network in the available region to your on-premises network.

- **Resource groups**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Contoso must redeploy the foundation and data platform resource groups into the secondary region.
    - Notes:
        - A *warm spare* strategy eliminates this step by keeping the network and resource group topology predeployed in the secondary region.

- **Azure VPN Gateway**

    - Contoso SKU selection: VpnGw1
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Contoso must validate availability and redeploy if necessary.
        - Azure regional failure: Contoso must redeploy the foundation VPN gateways into the secondary region.
    - Notes:
        - Create VPN gateways with [zone redundancy](/azure/reliability/reliability-virtual-network-gateway) to improve availability.
        - A *warm spare* strategy eliminates this step.

- **Azure DevOps**

    - Contoso SKU selection: DevOps Services
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Not applicable
    - Notes:
        - DevOps Services [runs on the Azure backbone](/azure/devops/organizations/security/data-protection#built-on-azure) and uses [Azure Blob Storage with geo-replication](/azure/devops/organizations/security/data-protection#data-redundancy) for reliability.

### Area: Data platform components

- **Storage account – Azure Data Lake Storage**

    - Contoso SKU selection: locally redundant storage (LRS)
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Contoso must validate availability and redeploy if necessary.
        - Azure regional failure: Contoso must redeploy the data platform storage accounts in the secondary region and rehydrate them with data.
    - Notes:
        - Storage accounts support a range of [data redundancy](/azure/storage/common/storage-redundancy) options, from primary region redundancy to secondary region redundancy.
        - With secondary region redundancy, data is replicated to the [secondary region asynchronously](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region). A failure that affects the primary region might result in data loss if the primary region can't be recovered. Azure Storage typically has a recovery point objective (RPO) of less than 15 minutes.
        - During a regional outage, geo-redundant storage accounts become available in the secondary region as LRS. Apply extra configuration to restore geo-redundancy in the secondary region.

- **Microsoft Fabric – OneLake**

    - Contoso SKU selection: Fabric Storage
    - DR impact:
      - Azure datacenter failure: Not applicable
      - Availability zone failure: Contoso must validate availability and redeploy if necessary.
      - Azure regional failure: Microsoft handles regional failures. OneLake data remains available through the API during recovery. For more information, see [DR and data protection for OneLake](/fabric/onelake/onelake-disaster-recovery).

- **Fabric Data Warehouse**

    - Contoso SKU selection: Fabric capacity
    - DR impact:
      - Azure datacenter failure: Not applicable
      - Availability zone failure: Not applicable
      - Azure regional failure: Contoso must deploy the Fabric data platform in the secondary region and [restore](/fabric/security/experience-specific-guidance#warehouse) the warehouse.
    - Notes:
       - Cross-region restore constraints:
         - You can't restore a warehouse from one region or workspace to another. You must redeploy the schema and reingest data.
         - After restoration, you can pause Fabric capacity. Only storage costs are incurred during the paused state, which makes it a cost-effective way to maintain a *live* snapshot.
             
- **Fabric – Pipelines**

    - Contoso SKU selection: Fabric capacity
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Contoso must deploy the Fabric data platform in the secondary region and [restore](/fabric/security/experience-specific-guidance) the pipelines.
           
- **Azure Event Hubs**

    - Contoso SKU selection: Standard
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Contoso must redeploy the Event Hubs instance in the secondary region.
    - Notes:
        - When you use the Azure portal, zone redundancy is [automatically turned on](/azure/event-hubs/event-hubs-geo-dr#availability-zones). You can turn it off by using the Azure CLI or PowerShell.
        - Zone redundancy provides local resilience during a zone outage. For region-wide disruptions, use the [Event Hubs geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr) feature to restore operations in a secondary region.

- **Azure IoT Hub**

    - Contoso SKU selection: Standard
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Contoso must redeploy the IoT Hub in the secondary region.
    - Notes:
        - IoT Hub provides [intra-region high availability](/azure/reliability/reliability-iot-hub#resilience-to-availability-zone-failures) and automatically uses an availability zone when created in a [predefined set of Azure regions](/azure/reliability/reliability-iot-hub#requirements).

- **Azure Stream Analytics**

    - Contoso SKU selection: Standard
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Contoso must redeploy the Azure Stream Analytics job in the secondary region.
    - Notes:
        - Stream Analytics can recover automatically from [node failures](/azure/stream-analytics/stream-analytics-concepts-checkpoint-replay#job-recovery-from-node-failure-including-os-upgrade).

- **Azure Machine Learning**

    - Contoso SKU selection: General Purpose – D Series instances
    - DR impact:
        - Azure datacenter failure: Contoso must validate availability and redeploy if necessary.
        - Availability zone failure: Contoso must validate availability and redeploy if necessary.
        - Azure regional failure: Contoso must redeploy Machine Learning in the secondary region.
    - Notes:
        - Microsoft manages the Machine Learning infrastructure, but you manage [the associated resources](/azure/machine-learning/how-to-high-availability-machine-learning#understand-azure-services-for-azure-machine-learning). Only Azure Key Vault is highly available by default.
        - For critical services, Microsoft recommends a [multiregional deployment](/azure/machine-learning/how-to-high-availability-machine-learning#plan-for-multi-regional-deployment).

- **Microsoft Foundry**

    - Contoso SKU selection: Provisioned throughput units (PTUs) or pay-as-you-go
    - DR impact:
      - Azure datacenter failure: Contoso must validate service availability and redeploy Foundry resources if necessary.
      - Availability zone failure: Contoso must validate availability and redeploy workloads to another zone within the same region.
      - Azure regional failure: Contoso must redeploy Foundry resources in the secondary region.
    - Notes:
      - Microsoft manages the Foundry platform infrastructure, but Contoso manages associated resources like storage accounts, compute clusters, and networking to maintain high availability and DR.
      - Design for [Foundry Agent Service DR](/azure/foundry/how-to/agent-service-disaster-recovery).
      - Implement [backup strategies](/azure/foundry-classic/how-to/high-availability-resiliency) for custom models, datasets, and configuration artifacts because the platform doesn't automatically replicate them across regions.

- **Fabric – Eventhouse**

    - Contoso SKU selection: Fabric capacity
    - DR impact:
      - Azure datacenter failure: Not applicable
      - Availability zone failure: Not applicable
      - Azure regional failure: Contoso must redeploy Fabric eventhouses and pipelines in the secondary region.

- **Fabric – Lakehouse**

    - Contoso SKU selection: Fabric capacity
    - DR impact:
      - Azure datacenter failure: Not applicable
      - Availability zone failure: Not applicable
      - Azure regional failure: Contoso must redeploy the Fabric data platform in the secondary region and [restore](/fabric/security/experience-specific-guidance#lakehouse) the lakehouses and pipelines.

- **Power BI**

    - Contoso SKU selection: Fabric capacity or Power BI Pro
    - DR impact:
      - Azure datacenter failure: Not applicable
      - Availability zone failure: Not applicable
      - Azure regional failure: Contoso must wait for confirmation from Microsoft before they publish or edit.
    - Notes:
      - You don't need to initiate failover. The Power BI team [handles failover](/fabric/enterprise/powerbi/service-admin-failover#how-does-microsoft-decide-to-fail-over-) when they declare an outage. Be aware of these constraints during failover:
          - A failed-over instance [only supports read operations](/fabric/enterprise/powerbi/service-admin-failover#what-is-a-power-bi-failover-). Reports that use Direct Query or Live Connect [don't work during a failover](/fabric/enterprise/powerbi/service-admin-failover#do-gateways-function-in-failover-mode--).
          - Don't publish or modify reports until Microsoft confirms that the failover instance is writable or the primary region is restored.
          - On-premises data refreshes through Power BI gateways are paused.

- **Azure Cosmos DB**

    - Contoso SKU selection: Single Region Write with Periodic backup
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Not applicable
        - Azure regional failure: Contoso must monitor [provisioned request units (RUs)](/azure/reliability/reliability-cosmos-db#capacity-planning-and-management) in the remaining regions to confirm that they can support read and write activities.
    - Notes:
        - [Single-region accounts might lose availability](/azure/reliability/reliability-cosmos-db#resilience-to-region-wide-failures) after a regional outage. To ensure high availability of your Azure Cosmos DB instance, configure it with a single write region and at least one read region, and turn on service-managed failover.
        - To preserve write availability, turn on service-managed failover on production workloads. This approach provides automatic failover for [available regions](/azure/reliability/reliability-cosmos-db#configure-multiple-read-regions).

- **Azure Data Share**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Contoso must validate availability and redeploy if necessary.
        - Availability zone failure: Contoso must validate availability and redeploy if necessary.
        - Azure regional failure: Contoso must redeploy Data Share in the secondary region.
    - Notes:
        - Data Share doesn't support [availability zones](/azure/reliability/availability-zones-overview).
        - Deploying Data Share in a [high-availability configuration](/azure/data-share/disaster-recovery#achieving-business-continuity-for-azure-data-share) eliminates each of these outage risks.

- **Microsoft Purview**

    - Contoso SKU selection: Not applicable
    - DR impact:
        - Azure datacenter failure: Not applicable
        - Availability zone failure: Contoso must validate availability and redeploy if necessary.
        - Azure regional failure: Contoso must deploy a Microsoft Purview instance in the secondary region.
    - Notes:
        - A *warm spare* strategy eliminates this step by predeploying a second Microsoft Purview instance in the secondary region.
        - A *warm spare* approach has the following [constraints](/purview/data-gov-best-practices-disaster-recovery-migration#limitations-and-considerations):
            - The primary and secondary Microsoft Purview accounts can't share the same Azure Data Factory, Data Share, or Fabric accounts. As a result, lineage from Azure Data Factory and Data Share isn't visible in the secondary Microsoft Purview account.
            - Integration runtimes are scoped to a single Microsoft Purview account. If scans must run in primary and secondary Microsoft Purview accounts simultaneously, you must maintain multiple self-hosted integration runtimes (SHIRs).

> [!NOTE]
> This section provides general guidance. For any new component or service, consult the vendor's documentation for DR, redundancy, and backup to determine the correct approach.
>
> *Azure datacenter failure* applies to regions where [availability zones](/azure/reliability/availability-zones-overview) aren't available.
>
> If configuration changes or releases occurred at the time of the disaster, check and redeploy them as needed to bring the platform to the current state.

## Next step

Learn about [recommendations related to this scenario](../disaster-recovery/dr-for-azure-data-platform-recommendations.md).

## Related resources

- [DR for Azure Data Platform - Overview](dr-for-azure-data-platform-overview.md)
- [DR for Azure Data Platform - Architecture](dr-for-azure-data-platform-architecture.md)
