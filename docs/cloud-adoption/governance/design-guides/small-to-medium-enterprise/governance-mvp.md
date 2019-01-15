---
title: "Fusion: Small to Medium Enterprise – Governance MVP Design"
description: Explanation Small to Medium Enterprise – Governance MVP Design
author: BrianBlanchard
ms.date: 2/1/2018
---

# Fusion: Small to Medium Enterprise – Governance MVP Design

This article outlines the implementation of the initial Corporate Policies for this design guide, to support the initial narrative. Before implementation it is advised that the reader review, modify, and integrate those artifacts into decision making processes.

## Governance MVP (Cloud Adoption Foundation)

Any governance foundation requires a few simple principles, which are the root of enabling rapid governance evolutions. These are the first of the three Cloud Governance Disciplines to approach in any governance process. Each will be expanded upon in this article.

To establish the starting point, this article will discuss the high-level strategies behind Identity Management, Security Management, and Configuration Management that are required to create a Governance MVP (Minimally Viable Product), which will serve as the foundation for all adoption.

![Example of Incremental Governance MVP](../../../_images/governance/governance-mvp.png)

### Implementation Process

Implementation of the Governance MVP has dependencies on Identity, Security, and Networking. Once the dependencies are resolved, the Cloud Governance Team will make decisions regarding a few aspects of governance. The decisions from the Cloud Governance Team and the decisions from the supporting teams will all be implemented through a single package of enforcement assets.

![Example of Incremental Governance MVP](../../../_images/governance/governance-mvp-implementation-flow.png)

## Decision and Implementation Summary

This implementation can also be described using a simple check list.

1. Solicit decision regarding core dependencies: Identity, Network, and Encryption
2. Determine Policy Enforcement Pattern
3. Determine appropriate governance patterns: Resource Grouping, Resource Tagging, Log & Reporting
4. Implement the governance tools aligned to the chosen policy enforcement pattern to apply the dependent decisions and governance decisions.

Expanding on the checklist to make step 4 actionable, the implementation checklist would look like the following:

1) Create the desired Subscription and Management Group, adhering to the naming standards and hierarchy decisions for each. See expanded decisions below.
2) To support the on-going enforcement pattern, create an Azure Blueprint name “Governance MVP”. ARM Templates and Azure Policy will be created and added to the Blueprint as assets.
3) Enforce RBAC requirement for the subscription in the Blueprint
4) Create an ARM Template for the VPN Gateway (To be used as needed)
5) Create an Azure Policy to apply or enforce the following:
    a. Resource Tagging should require values for Business Function, Data Classification, Criticality, SLA, Environment, and Application.
    b. Resource Grouping per Application Archetype should align to the application tag
    c. Software Defined Network if the environment lists the Environment tag as DMZ (Demilitarized Zone), ensure the proper VPN is configured
    d. Identity validate role assignments for each resource group and resource
    e. Nether logging, reporting, nor encryption require a policy at this time

For details on the decisions or execution of the steps above, see the detailed decisions section that follows. For technical guidance on implementation of the above five steps, see the resources section at the end of this article.

## Dependent Decisions

The following decisions come from teams outside of the Cloud Governance Team. The implementation of each will come from those same teams. However, the Cloud Governance Team has the responsibility of implementing a solution to validate that those implementations are consistently applied.

### Identity 

Identity Management is the fundamental starting point for all governance. Without a sound strategy for identity management, the users interacting with the cloud foundation can’t be verified or controlled. Before attempting to apply governance, identity must best established. That strategy will then be enforced by the governance solutions.

In this design guide, the Replication pattern has been implemented by the Identity Management team. 

* RBAC will be provided by Azure AD, leveraging the directory synchronization or "Same Sign-On" that was implemented during the Office 365 implementation 
    * See Reference Architecture for Azure AD Integration for implementation guidance.
* The Azure AD tenant will also govern authentication and access for assets deployed to Azure.

In the Governance MVP, the governance team will enforce application of the replicated tenant through subscription governance tooling discussed later in this article. In future evolutions, the governance team could also enforce rich tooling in Azure Ad to extend this capability.

### Networking

Parallel to identity is a vital initial aspect of Security Management, the definition of the software defined network. Establishing the governance MVP is dependent on early decisions from the Security Management Team to define how networks can be safely configured. 

Given the lack of requirements, IT security is playing it safe and has required a Demilitarized Pattern. This means that governance concerning the Azure deployments themselves will be very lite. 

* Azure subscriptions may connect to an existing data center via VPN, but must follow all existing on-prem IT governance policies regarding connection of a demilitarized zone to protected resources. 
    * See VPN Reference Architecture for implementation guidance regarding VPN connectivity
    * Decisions regarding subnet, firewall, and routing are currently being deferred to each application/workload lead.
* Additional analysis will be required prior to the release of any protected data or mission critical workloads.

The only real requirement for the network is that cloud networks can only connect to on-prem resources over a pre-allocated VPN that is compatible with Azure. Traffic over that connection will be treated like any traffic coming from a demilitarized zone.

The Cloud Governance Team has proactively invited members of networking and IT security into a regular sync to stay ahead of networking demands and risks.

### Encryption

Encryption is another fundamental decision within the security management discipline. The Security Team has determined a less aggressive pattern for encryption at this time, given the lack of protected data in the cloud.

At this point, a Cloud Native pattern to encryption is suggested but not required of any development team.

* No governance requirements have been set regarding the use of encryption, because mission critical and protected data are not permitted based in the use case.
* Additional analysis will be required prior to the release of any protected data or mission critical workloads

## Configuration Management Implementation

The core of this Governance MVP is configuration management. The tools and patterns applied at this stage will enable the incremental evolutions needed to support future governance expansion.

### Policy Enforcement

The first decision to be made regarding configuration management is the pattern for enforcement. In this use case, the governance team decided to implement the On-going Enforcement pattern

* Azure security center will be made available to the security and identity teams to monitor security risks and farm future Azure Policy configurations.
* RBAC is required in all subscriptions to govern authentication enforcement.
* Azure Policy is to be applied to all resource groups. However, the level of policies being enforced will be very limited.
* While Management Groups are being leveraged, the level of hierarchy, and on-going management processes are expected to be much simpler than those seen in large enterprises. 
* Azure Blueprints will be leveraged to deploy and update subscriptions by applying RBAC requirements, Azure Management Groups, and Azure Policy

## Application of Dependent Patterns

The following decisions represent the patterns to be enforced through the Policy Enforcement strategy above:

### Identity

Azure Blueprints will set RBAC requirements at a subscription level to ensure consistent identity is configured for all subscriptions.

### Software Defined Network

The Cloud Governance Team maintains an ARM (Azure Resource Manager) Template for establishing a VPN gateway between Azure and the on-prem VPN device. When an application team requires a VPN connection, the Cloud Governance Team will apply the gateway ARM template via Azure Blueprints.

## Application of Governance Defined Patterns
The Cloud governance team will be responsible for the following decisions and implementations. Many will require inputs from other teams, but the cloud governance team is likely to own both the decision and implementation. The following sections outline the decisions made for this use case and details of each decision.

### Subscription Model
The Archetype pattern has been chosen for Azure subscriptions.

* Departments are not likely to be required given the current focus. Deployments are expected to be constrained within a single billing unit. At the stage of adoption, there may not even be an enterprise agreement to centralize billing. It's very likely that this level of adoption is being managed by a single "Pay as you go" Azure subscription.
* Regardless of the use of the EA Portal or the existence of an enterprise agreement, a subscription model should still be defined and agreed upon to minimize administrative overheard beyond just billing.
* In the Archetype patter, "Subscriptions" should be created for each application archetype.
* An application archetype is a means of grouping applications with similar needs. Common examples would include: Applications with protected data, Governed Apps (HIPAA, FedRamp, etc...), Low risk applications, Applications with on-prem dependencies, SAP or other Mainframes in Azure, Applications that extend on-prem SAP or mainframes, etc... These are unique per organization based on data classifications and the types of applications that power the business. Dependency mapping of the digital estate can aid in defining the application archetypes in an organization.
* A common naming convention should be agreed upon as part of the subscription design, based on the above two bullets.

### Resource Grouping

Deployment grouping has been chosen as a resource grouping pattern.

* Deployed assets should be a member of a Resource Group and Azure Management Group. Azure Policy should be applied to all resources.
* As part of the deployment process, an Azure Resource Management (ARM) template(s) for the resource group should be stored in source control.
* Each resource groups should align to a specific workload or application.
* Azure Management Group is likely to be extremely flat and may only require a single management group. This will serve as a future mechanism for updating governance designs, as corporate policy matures. If the use case is expected to include additional business units or billing units in the future, a management group hierarchy should be considered further to account for billing unit and/or application level hierarchies.
* Similarly, extensive Azure Policy implementation could exceed the teams time commitments and may not provide a great deal of value at this time. However, a simple default policy should be created and applied to each management group to enforce the small number of current cloud governance policy statements. This will serve as a mechanism for defining the implementation of specific governance requirements. Those implementations can then be applied across all deployed assets.

### Resource Tagging

The Classification pattern to tagging has been chosen as a model for resource tagging.

* Deployed assets should be tagged with the following values: Data Classification, Criticality, SLA, and Environment.
* These four values will drive governance, operations, and security decisions.
* If this design guide is being implemented for a business unit or team within a larger corporation, tagging should also include metadata for the billing unit.
Log & Reporting
At this point, a Cloud Native pattern to log and reporting is suggested but not required of any development team.
* No governance requirements have been set regarding the data to be collected for logging or reporting purposes.
* Additional analysis will be required prior to the release of any protected data or mission critical workloads.

## Alternative Patterns

If any of the patterns selected in this design guide don't align to the reader's requirements, alternatives to each pattern is available in the list of links below.

* [Subscription model:](../../../infrastructure/subscriptions/overview.md) Alternatives to the Archetype pattern are available here
* [Resource Grouping:](../../../infrastructure/resource-grouping/overview.md) Alternatives to the Deployment Grouping pattern are available here
* [Resource Tagging:](../../../infrastructure/resource-tagging/overview.md) Alternatives to the Classification pattern are available here
* [Identity:](../../../infrastructure/identity/overview.md) Alternatives to the Replication pattern are available here
* [Software Defined Network:](../../../infrastructure/software-defined-networks/overview.md) Alternatives to the Cloud Native pattern are available here
* [Encryption:](../../../infrastructure/encryption/overview.md) Alternatives to the Cloud Native pattern are available here
* [Log & Reporting:](../../../infrastructure/log-and-reporting/overview.md) Alternatives to the Cloud Native pattern are available here
* [Enforcement Automation:](../../../infrastructure/policy-enforcement/overview.md) Alternatives to the Simple Enforcement pattern are available here

## Next steps

Once this guide is implemented the Cloud Adoption Team can go forth with a sound governance foundation. The Cloud Governance Team will work in parallel to continuously update the Corporate Policies and Governance Disciplines.

The two teams will also use the tolerance indicators to identify the next evolution needed to continue supporting cloud adoption. Below are potential next steps that might be needed and the documented tolerance indicators:

* [Security Management](./protected-data.md): Inclusion of protected data in defined cloud adoption plans
* [Resource Management](./mission-critical.md): Deployment of mission critical workloads
* [Cost Management](cost-control.md): Scale of deployment exceeds 100 assets to the cloud or Monthly spend exceeding $1,00/month
* [Multi-Cloud Governance](multi-cloud.md): Leveraging this governance investment to manage multiple clouds