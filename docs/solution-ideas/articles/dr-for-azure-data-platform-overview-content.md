# Disaster recovery for the Azure Analytics platform

## Overview
Azure provides many options to provide resiliency and address disaster recovery (DR), but higher levels of service will often attract complexity and/or a cost premium. This is the key design trade-off of DR for customers, cost versus resiliency versus complexity.  

While occasional point failures do happen across the Azure service, it should be noted that Microsoft Data Centers and Azure Services have multiple layers of redundancy built-in. Any failure is usually limited in scope and is typically recovered within a matter of hours. Historically it’s far more likely that a key service such as identity management will experience a service issue rather than an entire Azure region going offline.

It should also be acknowledged that cyber-attacks, particularly [ransomware](/azure/security/fundamentals/backup-plan-to-protect-against-ransomware#what-is-ransomware), now pose a tangible threat to any modern data ecosystem and can result in a data platform outage. While this subject is out-of-scope for this documentation, it is strongly advised that customers should implement controls/mitigations against such attacks as part of the security and resiliency design of any data platform.

- Microsoft guidance on ransomware protection is available in Azure’s [Cloud Fundamentals](/azure/security/fundamentals/backup-plan-to-protect-against-ransomware)

## Scope
The scope of this article series includes:

- The service recovery of an Azure data platform from a physical disaster for an illustrative persona of the customer. This illustrative customer is:
    - a mid-large organization with a defined operational support function, following an ITIL based service management methodology
    - not cloud-native, with its core enterprise, shared services still on-premises i.e. access and authentication management, incident management, etc.
    - on the journey of cloud migration to Azure, enabled by automation
- The Azure data platform has implemented the following designs within a customer’s Azure tenancy
    - [Enterprise Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture) – Providing the platform foundation, including networking, monitoring, security etc.
    - [Azure Analytics Platform](https://github.com/Azure/azure-synapse-analytics-end2end) - Providing the data components which support the various solutions and data products provided by the service
- This process is designed to be executed by an Azure technical resource rather than a specialist Azure SME. As such, the resource(s) should have the following level of knowledge/skills
    - [Azure Fundamentals](/certifications/exams/az-900) – working knowledge of Azure, its core services, and data components
    - Working knowledge of Azure DevOps. Able to navigate source control and execute pipeline deployments
- This process describes the Failover process, from the primary to the secondary region.

## Out of scope
The key assumptions for this DR worked example are

- The Organization follows an [ITIL based](https://en.wikipedia.org/wiki/ITIL) service management methodology for operational support of the Azure data platform 
- The Organization has an existing disaster recovery process as part of its service restoration framework for IT assets 
- “[Infrastructure as Code](/azure/architecture/framework/devops/automation-infrastructure)” (IaC) has been used to deploy the Azure data platform enabled by an automation service, such as Azure DevOps or similar
- Each solution hosted by the Azure data platform has completed a Business Impact Assessment or similar, providing clear service requirements for RPO, RTO and MTO

## Next steps
A suggested next step is to learn about the [architecture](article2) designed for the use case.