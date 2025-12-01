## Overview

This series provides an illustrative example of how an organization could design a disaster recovery (DR) strategy for an Azure enterprise data platform.

- This series of articles complements the guidance provided by Microsoft's [Cloud Adoption Framework](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery), the Azure [Well-Architected Framework](/azure/well-architected/reliability/disaster-recovery) and [Business Continuity Management](/azure/reliability/business-continuity-management-program).

Azure provides a broad range of reliability options that can provide service continuity in the event of a disaster. But higher service levels can introduce complexity and a cost premium. The trade-off of cost versus reliability versus complexity is the key decision-making factor for most customers regarding DR.

While occasional point failures do happen across the Azure platform, Microsoft's Azure datacenters and Azure services have multiple layers of redundancy built-in. Any failure is normally limited in scope and is typically remediated within a matter of hours. Historically, it's far more likely that a key service such as identity management experiences a service issue rather than an entire Azure region going offline.

It should also be acknowledged that cyber-attacks, particularly ransomware, pose a tangible threat to any modern data ecosystem and can result in a data platform outage. While this is out-of-scope for this series, customers are advised to implement controls against such attacks as part of any data platform's security and reliability design.

- Microsoft guidance on ransomware protection is available in the Azure [Cloud Fundamentals](/azure/security/fundamentals/backup-plan-to-protect-against-ransomware)

## Scope

The scope of this article series includes:

- The service recovery of an Azure data platform from a physical disaster for an illustrative persona of the customer. This illustrative customer is:
    - A mid-large organization with a defined operational support function, following an Information Technology Infrastructure Library (ITIL) based service management methodology.
    - Not cloud-native, with its core enterprise, shared services like access and authentication management and incident management remaining on-premises.
    - On the journey of cloud migration to Azure, enabled by automation.
- The Azure data platform has implemented the following designs within the customer's Azure tenancy:
    - [Enterprise landing zone](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture) – Providing the platform foundation, including networking, monitoring, security, and so on.
    - [Azure analytics platform](https://github.com/Azure/azure-synapse-analytics-end2end) - Providing the data components that support the various solutions and data products provided by the service.
- The processes described in this article should be performed by an individual that has the following level of knowledge/skills:
    - [Azure Fundamentals](/certifications/exams/az-900) – working knowledge of Azure, its core services, and data components.
    - Working knowledge of Azure DevOps. Able to navigate source control and execute pipeline deployments.
- The processes described in this article cover service failover operations, from the primary to the secondary region.

## Out of scope

The following items are considered out-of-scope for this article series:

- The fallback process, from the secondary region back to the primary region.
- Any non-Azure applications, components, or systems – this includes but isn't limited to on-premises, other cloud vendors, third-party web services, and so on.
- Recovery of any upstream services, such as on-premises networks, gateways, enterprise shared services, and others, regardless of any dependencies on these services.
- Recovery of any downstream services, such as on-premises operational systems, third party reporting systems, data modeling or data science applications, and others, regardless of any dependencies on these services.
- Data loss scenarios, including recovery from [ransomware or similar data security incidents](/azure/security/fundamentals/backup-plan-to-protect-against-ransomware)
- Data backup strategies and data restoration plans
- Establishing the root cause of a DR event.
    - For Azure service/component incidents, Microsoft publishes a "Root Cause Analysis" within the [Status – History webpage](https://azure.status.microsoft/status/history/)

## Key assumptions

The key assumptions for this DR worked example are:

- The Organization follows an ITIL based service management methodology for operational support of the Azure data platform.
- The Organization has an existing disaster recovery process as part of its service restoration framework for IT assets.
- [Infrastructure as Code (IaC)](/azure/architecture/framework/devops/automation-infrastructure) has been used to deploy the Azure data platform enabled by an automation service, such as Azure DevOps or similar.
- Each solution hosted by the Azure data platform has completed a Business Impact Assessment or similar, providing clear service requirements for recovery point objective (RPO), recovery time objective (RTO) and mean time to recover (MTTR) metrics.

## Next steps

After you review the scenario at a high level, proceed to the [architecture](../disaster-recovery/dr-for-azure-data-platform-architecture.yml) for this use case.

## Related resources

- [DR for Azure Data Platform - Architecture](dr-for-azure-data-platform-architecture.yml)
- [DR for Azure Data Platform - Scenario details](dr-for-azure-data-platform-scenario-details.yml)
- [DR for Azure Data Platform - Recommendations](dr-for-azure-data-platform-recommendations.yml)
