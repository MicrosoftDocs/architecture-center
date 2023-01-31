## Overview

This series of articles provides an illustrative example of how an organization could design a disaster recovery (DR) strategy, describe the process to recover service for an enterprise Azure Data platform in the event of a disaster and test that DR process.

- This series of articles is intended to complement the guidance provided by Microsoft’s [Cloud Adoption Framework](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery), Azure’s [Well-Architected Framework](/azure/architecture/framework/) and [Business Continuity Management](/azure/availability-zones/business-continuity-management-program)

Azure provides many options to provide resiliency and address disaster recovery (DR), but higher levels of service will often attract complexity and/or a cost premium. The trade-off of cost versus resiliency versus complexity is the key decision-making factor for most customers as it relates to DR.

While occasional point failures do happen across the Azure service, it should be noted that Microsoft Data Centers and Azure Services have multiple layers of redundancy built-in. Any failure is normally limited in scope and is typically recovered within a matter of hours. Historically it’s far more likely that a key service such as identity management will experience a service issue rather than an entire Azure region going offline.

It should also be acknowledged that cyber-attacks, particularly [ransomware](/azure/security/fundamentals/backup-plan-to-protect-against-ransomware#what-is-ransomware), now pose a tangible threat to any modern data ecosystem and can result in a data platform outage. While this subject is out-of-scope for this series of articles, customers are advised to implement controls and mitigations against such attacks as part of the security and resiliency design of any data platform.

- Microsoft guidance on ransomware protection is available in Azure’s [Cloud Fundamentals](/azure/security/fundamentals/backup-plan-to-protect-against-ransomware)

## Scope

The scope of this article series includes:

- The service recovery of an Azure data platform from a physical disaster for an illustrative persona of the customer. This illustrative customer is:
    - a mid-large organization with a defined operational support function, following an ITIL based service management methodology
    - not cloud-native, with its core enterprise, shared services like access and authentication management and incident management remain on premises
    - on the journey of cloud migration to Azure, enabled by automation
- The Azure data platform has implemented the following designs within a customer’s Azure tenancy
    - [Enterprise Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture) – Providing the platform foundation, including networking, monitoring, security etc.
    - [Azure Analytics Platform](https://github.com/Azure/azure-synapse-analytics-end2end) - Providing the data components that support the various solutions and data products provided by the service
- This process can be executed by an Azure technical resource rather than a specialist Azure SME. As such, the resource(s) should have the following level of knowledge/skills
    - [Azure Fundamentals](/certifications/exams/az-900) – working knowledge of Azure, its core services, and data components
    - Working knowledge of Azure DevOps. Able to navigate source control and execute pipeline deployments
- This process describes the Failover process, from the primary to the secondary region.

## Out of scope

The key assumptions for this DR worked example are

- The Organization follows an ITIL based service management methodology for operational support of the Azure data platform 
- The Organization has an existing disaster recovery process as part of its service restoration framework for IT assets 
- “[Infrastructure as Code](/azure/architecture/framework/devops/automation-infrastructure)” (IaC) has been used to deploy the Azure data platform enabled by an automation service, such as Azure DevOps or similar
- Each solution hosted by the Azure data platform has completed a Business Impact Assessment or similar, providing clear service requirements for RPO, RTO and MTO

## Next steps

Now that you have learned about the scenario at a high level, you can move on to learn about the [architecture](../disaster-recovery/dr-for-azure-data-platform-architecture.yml) designed for the use case.

## Related resources

- [DR for Azure Data Platform - Architecture](dr-for-azure-data-platform-architecture.yml)
- [DR for Azure Data Platform - Scenario details](dr-for-azure-data-platform-scenario-details.yml)
- [DR for Azure Data Platform - Recommendations](dr-for-azure-data-platform-recommendations.yml)
- [DR for Azure Data Platform - Deploy this scenario](dr-for-azure-data-platform-deploy-this-scenario.yml)
