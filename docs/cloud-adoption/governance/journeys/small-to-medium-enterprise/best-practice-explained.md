---
title: "CAF: Small-to-medium enterprise – Best practice explained"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Small-to-medium enterprise – Best practice explained
author: BrianBlanchard
---

# Small-to-medium enterprise: Best practice explained

The governance journey starts with a set of initial [corporate policies](./initial-corporate-policy.md). These policies are used to establish a governance MVP that reflects [best practices](./overview.md).

In this article, we discuss the high-level strategies that are required to create a governance MVP. The core of the governance MVP is the [Deployment Acceleration](../../deployment-acceleration/overview.md) discipline. The tools and patterns applied at this stage will enable the incremental evolutions needed to expand governance in the future.

## Governance MVP (Cloud Adoption Foundation)

Rapid adoption of governance and corporate policy is achievable, thanks to a few simple principles and cloud-based governance tooling. These are the first three disciplines to approach in any governance process. Each will be expanded upon in this article.

To establish the starting point, this article will discuss the high-level strategies behind Identity Baseline, Security Baseline, and Deployment Acceleration that are required to create a governance MVP, which will serve as the foundation for all adoption.

![Example of an incremental governance MVP](../../../_images/governance/governance-mvp.png)

## Implementation process

The implementation of the governance MVP has dependencies on Identity, Security, and Networking. Once the dependencies are resolved, the Cloud Governance team will decide a few aspects of governance. The decisions from the Cloud Governance team and from supporting teams will be implemented through a single package of enforcement assets.

![Example of an incremental governance MVP](../../../_images/governance/governance-mvp-implementation-flow.png)

This implementation can also be described using a simple checklist:

1. Solicit decisions regarding core dependencies: Identity, Network, and Encryption.
2. Determine the pattern to be used during corporate policy enforcement.
3. Determine the appropriate governance patterns for the Resource Consistency, Resource Tagging, and Logging and Reporting disciplines.
4. Implement the governance tools aligned to the chosen policy enforcement pattern to apply the dependent decisions and governance decisions.

[!INCLUDE [implementation-process](../../../../../includes/cloud-adoption/governance/implementation-process.md)]

## Application of governance-defined patterns

The Cloud Governance team is responsible for the following decisions and implementations. Many require inputs from other teams, but the Cloud Governance team is likely to own both the decision and the implementation. The following sections outline the decisions made for this use case and details of each decision.

### Subscription model

The **Application Category** pattern has been chosen for Azure subscriptions.

- An application archetype is a way to group applications with similar needs. Common examples include: Applications with protected data, governed applications (such as HIPAA or FedRAMP), low- risk applications, applications with on-premises dependencies, SAP or other mainframes in Azure, or applications that extend on-premises SAP or mainframes. These archetypes are unique per organization, based on data classifications and the types of applications that power the business. Dependency mapping of the digital estate can aid in defining the application archetypes in an organization.
- Departments are not likely to be required given the current focus. Deployments are expected to be constrained within a single billing unit. At the stage of adoption, there may not even be an enterprise agreement to centralize billing. It's likely that this level of adoption is being managed by a single pay-as-you-go Azure subscription.
- Regardless of the use of the EA Portal or the existence of an enterprise agreement, a subscription model should still be defined and agreed upon to minimize administrative overheard beyond just billing.
- In the **Application Category** pattern, subscriptions are created for each application archetype. Each subscription belongs to an account per environment (Development, Test, and Production).
- A common naming convention should be agreed on as part of the subscription design, based on the previous two points.

### Resource Consistency

The **Deployment Consistency** pattern has been chosen as a Resource Consistency.

- Resource groups are created for each application. Management groups are created for each application archetype. Azure Policy should be applied to all subscriptions from the associated management group.
- As part of the deployment process, Azure Resource Consistency templates for the resource group should be stored in source control.
- Each resource group is associated with a specific workload or application.
- Azure management groups enable updating governance designs as corporate policy matures.
- Extensive implementation of Azure Policy could exceed the team’s time commitments and may not provide a great deal of value at this time. However, a simple default policy should be created and applied to each management group to enforce the small number of current cloud governance policy statements. This policy will define the implementation of specific governance requirements. Those implementations can then be applied across all deployed assets.

### Resource tagging

The **Classification** pattern to tagging has been chosen as a model for resource tagging.

- Deployed assets should be tagged with the following values: Data Classification, Criticality, SLA, and Environment.
- These four values will drive governance, operations, and security decisions.
- If this governance journey is being implemented for a business unit or team within a larger corporation, tagging should also include metadata for the billing unit.

### Logging and reporting

At this point, a **Cloud Native** pattern to logging and reporting is suggested but not required of any development team.

- No governance requirements have been set regarding the data to be collected for logging or reporting purposes.
- Additional analysis will be needed before releasing any protected data or mission-critical workloads.

## Evolution of governance processes

As governance evolves, some policy statements can’t or shouldn’t be controlled by automated tooling. Other policies will result in effort by the IT Security team and the on-premises Identity Management team over time. To help mitigate new risks as they arise, the Cloud Governance team will oversee the following processes.

**Adoption acceleration**: The Cloud Governance team has been reviewing deployment scripts across multiple teams. They maintain a set of scripts that serve as deployment templates. Those templates are used by the cloud adoption and DevOps teams to define deployments more quickly. Each of those scripts contains the necessary requirements to enforce a number of governance policies, with no additional effort from cloud adoption engineers. As the curators of these scripts, the Cloud Governance team can more quickly implement policy changes. As a result of script curation, the Cloud Governance team is seen as a source of adoption acceleration. This creates consistency among deployments, without strictly forcing adherence.

**Engineer training**: The Cloud Governance team offers bi-monthly training sessions and has created two videos for engineers. These materials help engineers quickly learn the governance culture and how things are done during deployments. The team is adding training assets that show the difference between production and non-production deployments, so that engineers will understand how the new policies will affect adoption. This creates consistency among deployments, without strictly forcing adherence.

**Deployment planning**: Before deploying any asset containing protected data, the Cloud Governance team will review deployment scripts to validate governance alignment. Existing teams with previously approved deployments will be audited using programmatic tooling.

**Monthly audit and reporting**: Each month, the Cloud Governance team runs an audit of all cloud deployments to validate continued alignment to policy. When deviations are discovered, they are documented and shared with the cloud adoption teams. When enforcement doesn't risk a business interruption or data leak, the policies are automatically enforced. At the end of the audit, the Cloud Governance team compiles a report for the Cloud Strategy team and each cloud adoption team to communicate overall adherence to policy. The report is also stored for auditing and legal purposes.

**Quarterly policy review**: Each quarter, the Cloud Governance team and the Cloud Strategy team will review audit results and suggest changes to corporate policy. Many of those suggestions are the result of continuous improvements and the observation of usage patterns. Approved policy changes are integrated into governance tooling during subsequent audit cycles.

## Alternative patterns

If any of the patterns selected in this governance journey don't align with the reader's requirements, alternatives to each pattern are available:

- [Encryption patterns](../../../decision-guides/encryption/overview.md)
- [Identity patterns](../../../decision-guides/identity/overview.md)
- [Logging and Reporting patterns](../../../decision-guides/log-and-report/overview.md)
- [Policy Enforcement patterns](../../../decision-guides/policy-enforcement/overview.md)
- [Resource Consistency patterns](../../../decision-guides/resource-consistency/overview.md)
- [Resource Tagging patterns](../../../decision-guides/resource-tagging/overview.md)
- [Software Defined Network patterns](../../../decision-guides/software-defined-network/overview.md)
- [Subscription Design patterns](../../../decision-guides/subscriptions/overview.md)

## Next steps

Once this guide is implemented, each cloud adoption team can go forth with a sound governance foundation. The Cloud Governance team will work in parallel to continuously update the corporate policies and governance disciplines.

The two teams will use the tolerance indicators to identify the next evolution needed to continue supporting cloud adoption. For the fictional company in this journey, the next step is evolving the Security Baseline to support moving protected data to the cloud.

> [!div class="nextstepaction"]
> [Security Baseline evolution](./security-baseline-evolution.md)