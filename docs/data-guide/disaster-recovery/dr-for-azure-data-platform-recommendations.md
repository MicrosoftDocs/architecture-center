---
title: Disaster Recovery for an Azure Data Platform - Recommendations
description: Learn recommendations for implementing a disaster recovery strategy for an Azure data platform, including recovery objectives and operational considerations.
author: lponnam75
ms.author: lsuryadevara
ms.date: 12/18/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Disaster recovery recommendations for an Azure data platform

This article is the fourth in a series about disaster recovery (DR) for an Azure data platform. It provides recommendations and lessons learned for implementing a DR strategy, including guidance about how to define recovery objectives, test DR procedures, and address operational considerations.

## Lessons learned

- Ensure that all the parties involved understand the difference between high availability (HA) and DR. Confusing these concepts can result in mismatched solutions.

- Work with business stakeholders to define recovery point objectives (RPOs) and recovery time objectives (RTOs) based on the following factors:

  - The amount of downtime that they can tolerate. Faster recovery usually costs more.

  - The types of incidents that stakeholders need protection against and how likely they are to occur. For example, a server failure is more likely than a natural disaster that affects all datacenters in a region.

  - The effects of system unavailability on their business.

  - The operational expenses (OPEX) budget for the long-term solution.

- Consider which degraded service options your users can accept, such as:

  - Access to visualization dashboards, even if the data isn't up to date. In this scenario, users can view their data even if ingestion pipelines fail.

  - Read access without write capabilities.

- Your target RTO and RPO determine which DR strategy to use. Common strategies include active-active, active-passive, and redeploy on disaster. Also consider your [composite service-level objective (SLO)](/azure/well-architected/reliability/metrics) to account for all tolerable downtime thresholds.

- Ensure that you understand all the components that might affect the availability of your systems:

  - Identity management

  - Networking topology

  - Secret management and key management

  - Data sources

  - Automation and job scheduling

  - Source repository and deployment pipelines like GitHub and Azure DevOps

- Early detection of outages can decrease RTO and RPO values. Apply the following practices:

  - Define what an outage is and how it maps to the [definition of an outage according to Microsoft](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

  - Implement a monitoring and alerting system with clear ownership so that your team reviews metrics and alerts promptly.

- For subscription design, extra infrastructure for DR can reside in the original subscription. Platform as a service (PaaS) offerings like Azure Data Lake Storage typically include native failover features. These capabilities support secondary instances in other regions while remaining within the original subscription. To optimize costs, you can allocate a dedicated resource group exclusively for DR-related resources.

  - [Subscription limits](/azure/azure-resource-manager/management/azure-subscription-service-limits) might introduce constraints in this approach.

  - This approach also adds design complexity and requires governance controls to prevent teams from using DR resource groups for routine workflows.

- Design the DR workflow based on the criticality and dependencies of a solution. For example, don't try to rebuild an Azure Analysis Services instance before your data warehouse is operational because it triggers an error. Leave development labs for later in the process and recover core enterprise solutions first.

- Run recovery tasks in parallel across solutions to reduce total RTO.

- If your solution uses Fabric pipelines, include on-premises data gateways in the scope. Use [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) for these machines.

- Automate recovery operations where possible to reduce human error, especially for high-pressure situations.

  - Adopt resource provisioning through Bicep, Azure Resource Manager templates (ARM templates), Terraform, or PowerShell scripts.

  - Adopt versioning of source code and resource configuration.

  - Use continuous integration and continuous delivery (CI/CD) release pipelines instead of running steps manually.

- Plan for failback and failover. Document the procedures to return operations to the primary instances after they recover.

- Define clear indicators and metrics to validate that failover succeeds and that your solutions are operational. Confirm that performance returns to normal, also known as *primary functional*.

- Decide whether your service-level agreements (SLAs) must remain unchanged after failover or whether a temporary reduction in service quality is acceptable. The answer depends on workload criticality. For example, a room-booking system has different downtime tolerance from a core financial or operational system.

- Define RTOs and RPOs at the user-scenario level rather than the infrastructure level. Scenario-based targets make it easier to identify which processes and components to prioritize during recovery.

- Perform capacity checks in the target region before you proceed with a failover. In a major disaster, many customers might attempt to fail over to the same paired region simultaneously. This scenario can result in delays or contention in resource provisioning. If these risks are unacceptable, consider either an active-active or active-passive DR strategy.

- Create and maintain a DR plan to document the recovery process and the action owners. Assign a backup contact for each role to account for unavailable team members.

- Perform regular DR drills to validate the DR plan workflow, ensure that it meets the required RTO and RPO requirements, and train the responsible teams. Regularly test data and configuration backups to confirm that they can support recovery when needed.

- Collaborate early with networking, identity, and resource provisioning teams to agree on:

  - Traffic redirection to the secondary site. Consider tools such as Domain Name System (DNS) redirection or [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview).

  - How to grant access to the secondary site quickly and securely.

- During a disaster, communicate clearly with all involved parties to run the plan efficiently. Inform the following groups throughout recovery:

  - Decision-makers
  - Incident response teams
  - Affected internal users and teams
  - External teams

- Coordinate resource recovery in the right sequence to maximize efficiency.

## Antipatterns

- **Copy and paste this article series**

  This article series provides guidance for customers who want a deeper understanding of an Azure-specific DR process. It draws on generic Microsoft intellectual property and reference architectures rather than any single customer-specific Azure implementation.

  This content provides a strong foundational understanding. But you must tailor your approach by considering your unique context, implementation, and requirements to develop a fit-for-purpose DR strategy and process.

- **Treat DR as a tech-only process**

  DR planning tends to focus on technical tasks, but restoring systems without meeting business requirements still fails. Business stakeholders define DR requirements and validate that service recovery meets business needs.

  Engage business stakeholders throughout all DR activities to produce a process that works when needed and delivers real business value.

- **Create static DR plans**

  Azure is constantly evolving, and so are the ways that customers use its services. Your DR process must keep pace with those changes.

  Reassess your DR plan regularly as part of your software development life cycle or through periodic reviews to keep it current with any changes to your components, services, or solutions.

- **Paper-based assessments**

  Organizations often assess DR readiness through documentation reviews or tabletop exercises without running actual recovery tests. This approach can give a false sense of security because real failures rarely match theoretical scenarios.

  A complete end-to-end simulation is difficult across a modern data ecosystem, but aim to test as much of the affected environment as possible. Regular drills build your team's confidence and familiarity with the DR plan.

- **Rely on Microsoft to do it all**

  Azure services define a clear [shared responsibility model for reliability](/azure/reliability/concept-shared-responsibility) based on the cloud service tier.

  :::image type="complex" source="../images/shared-responsibility-model.png" alt-text="Diagram that shows the shared responsibility model." lightbox="../images/shared-responsibility-model.png" border="false":::
  The table has 10 rows of responsibilities and four deployment columns: software as a service (SaaS), platform as a service (PaaS), infrastructure as a service (IaaS), and on-premises. Filled cells indicate customer responsibility and unfilled cells indicate Microsoft responsibility. Diagonally split cells indicate shared responsibility. Three labeled sections on the right group the rows. The first section, labeled responsibility always retained by customer, contains information and data, devices (mobile and PCs), and accounts and identities. All items are marked as customer responsibility across all four deployment types. The second section, labeled responsibility varies by service type, contains identity and directory infrastructure, applications, network controls, and operating system. In this section, customer responsibility decreases from on-premises to SaaS, with some cells showing shared responsibility. The third section, labeled responsibility transfers to cloud provider, contains physical hosts, physical network, and physical datacenter. All items are marked as customer responsibility only for on-premises and as Microsoft responsibility for SaaS, PaaS, and IaaS.
  :::image-end:::

  Even with a full [SaaS stack](https://azurecharts.com/overview/?f=saas), you remain responsible for your accounts, identities, and data, and the devices that users use to access Azure services.

## Event scope and strategy

### Disaster event scope

Different events have varying scopes of impact that require different responses. The following diagram shows the scope of impact and response for a disaster event.

:::image type="complex" source="../images/dr-for-azure-data-platform-event-scope.png" alt-text="Diagram that shows the event scope and recovery process." lightbox="../images/dr-for-azure-data-platform-event-scope.png" border="false":::
The diagram is titled A Disaster Event Scope and has two parts. On the left, seven nested concentric circles decrease in size from outermost to innermost, which represents decreasing scope of impact. An icon labeled disaster event appears at the top, and a downward arrow labeled impact scope runs along the left edge. A note at the bottom says depending on the nature of the event, will decide where on this continuum a DR process will start. On the right is a two-column table with event scope and recovery process columns. Rows progress from broadest to narrowest impact. An internet or power grid outage maps to utilities recovery. An enterprise shared services outage maps to enterprise services support recovery. An Azure service, region, or datacenter outage maps to Microsoft recovery. Platform services offline maps to the platform DR plan. A platform component offline maps to a subset of the platform DR plan or a service incident resolution. An individual solution offline maps to solution DR plan recovery. An individual dataset integrity problem maps to a data incident. A bracket on the right labels rows 4 and 5 as the scope of this platform DR plan.
:::image-end:::

### DR strategy options

Choose from four high-level DR strategies:

- **Wait for Microsoft:** The solution stays offline until Microsoft restores services in the affected region. You then validate and update the solution before you return it to service.

- **Redeploy on disaster:** You manually redeploy the solution from scratch in an available region after a disaster.

- **Warm spare (active-passive):** You deploy a secondary solution in another region with minimal capacity, but it receives no production traffic. The secondary services run at reduced performance or remain turned off until a DR event occurs.

- **Hot spare (active-active):** The solution runs in an active-active setup across multiple regions. Each instance receives, processes, and serves data as part of the overall system.

### DR strategy effects

Cost is often the deciding factor when you [choose a DR strategy](/azure/well-architected/cost-optimization/tradeoffs#cost-optimization-tradeoffs-with-reliability), but RTO, recovery complexity, and customer impact also matter.

> [!NOTE]
> [Cost Optimization](/azure/well-architected/cost-optimization/checklist) is one of the five pillars of architectural excellence within the [Azure Well-Architected Framework](/azure/well-architected/pillars). Its goal is to reduce unnecessary expenses and improve operational efficiencies.

The following table compares the four options for a complete Azure regional outage in the primary region that hosts the Contoso data platform. Green indicates a favorable outcome for that factor. Orange indicates a moderate outcome. Red indicates an unfavorable outcome.

:::image type="complex" source="../images/dr-for-azure-data-platform-strategy.png" alt-text="Diagram that shows the effects of the outage on the DR strategies." lightbox="../images/dr-for-azure-data-platform-strategy.png" border="false":::
The table compares four DR strategies across three columns: Strategy, Description, and Impacts. Five other columns show colored circle indicators: Speed to Recovery, Complexity to Run, Complexity to Implement, Impact to Customers, and Above-line OPEX Cost. Green indicates a favorable outcome, orange indicates moderate, red indicates unfavorable, and an empty circle indicates not applicable. The Wait for Microsoft row describes waiting for Microsoft to complete recovery of services. The impact is that the solution stays offline until Microsoft restores the region and all required components. Speed to Recovery is orange, Complexity to Run is empty, Complexity to Implement is green, Impact to Customers is red, and Above-line OPEX Cost is green. The Redeploy on Disaster row describes redeploying the solution from scratch after the event. The impact is that the solution stays offline while failover activities complete, including procuring component instances and deploying the code base. Speed to Recovery is red, Complexity to Run is orange, Complexity to Implement is orange, Impact to Customers is orange, and Above-line OPEX Cost is orange. The Warm Spare row describes a secondary solution in an alternate region with minimal capacity that doesn't receive production traffic. The impact is a short offline period while failover to the secondary region completes. Speed to Recovery is orange, Complexity to Run is orange, Complexity to Implement is red, Impact to Customers is green, and Above-line OPEX Cost is orange. The Hot Spare row describes an active-active setup across multiple regions where all instances receive, process, and serve data. The impact is that the solution remains in service with no customer impact from the outage. Speed to Recovery is green, Complexity to Run is green, Complexity to Implement is red, Impact to Customers is empty, and Above-line OPEX Cost is red.
:::image-end:::

### Classification key

For this outage scenario, the following factors determine the relative impact of each DR strategy:

- **RTO:** The expected elapsed time from the disaster event to platform service recovery

- **Complexity to run:** The complexity for the organization to carry out the recovery activities

- **Complexity to implement:** The complexity for the organization to implement the DR strategy

- **Customer impact:** The direct impact to customers of the data platform service from the DR strategy

- **Above-the-line OPEX cost:** The extra cost expected from implementing this strategy, like increased monthly billing for Azure for extra components and extra resources required

## Next steps

- [Mission-critical workload](/azure/well-architected/mission-critical/mission-critical-overview)
- [Well-Architected Framework recommendations for designing a DR strategy](/azure/well-architected/reliability/disaster-recovery)

## Related resources

- [DR for an Azure data platform - Overview](dr-for-azure-data-platform-overview.md)
- [DR for an Azure data platform - Architecture](dr-for-azure-data-platform-architecture.md)
- [DR for an Azure data platform - Scenario details](dr-for-azure-data-platform-scenario-details.md)
