---
title: "Fusion: Monitor and enforce policy adherence"
description: How do you ensure compliance with established policies? 
author: BrianBlanchard
ms.date: 1/4/2019
---

# Fusion: How do I monitor and enforce policy adherence?

<!--- 
I've defined policies, I've provided an architecture guide. Now how do I monitor adherence to policy? If there is a violation, how do I enforce the policy?
--->

After establishing your cloud policy statements and drafting a design guide, you'll need to create a strategy for ensuring your cloud deployment stays in compliance with your policy requirements. This monitoring and enforcement strategy will need to encompass your cloud governance teams ongoing review and communication process, establishing criteria for when action is required, and defining the requirements for automated systems that will detect violations and trigger remediation actions.

See the [Azure Design Guides](../design-guides/overview.md) for examples of how monitoring and enforcement requirements can be integrated into a cloud governance plan.

## Prioritize policy monitoring and enforcement

How important are monitoring and enforcement process to maintaining your policy goals? Depending on the size and maturity of your cloud deployment, the effort required to ensure policy compliance, and the costs associated with this effort, can vary widely. 

For small deployments consisting of development and test resources, policy requirements may be minor and require few dedicated resources to address. On the other hand, a mature mission-critical cloud deployment with high-priority security and performance needs may require a team of staff and extensive custom monitoring tooling to support your established policy goals.

As a first step in defining your monitoring and enforcement strategy, examine the effort required to keep your deployment in compliance with policy requirements. Use this information to establish realistic budget and staffing plans to meet these needs.

## Establish cloud governance team monitoring processes

Before defining the exact triggers for policy compliance remediation, you need establish the overall processes that your team will use and how information will be shared and escalated between IT staff and the cloud governance team.

### Assign cloud governance team members

Who will provide ongoing guidance on policy compliance and handle policy-related issues that emerge when deploying and operating your cloud assets? The size and composition of your cloud governance team will depend on the complexity of your policy requirements, and the budgeting and staffing priorities you've attached to policy compliance.

Choose team that have expertise in the areas covered by your defined policy statements. For initial test deployments this can be limited to a few system administrators responsible for establishing the basics of governance. As your deployments mature and your policies become more complex and more integrated with your wider corporate policy requirements, your cloud governance team will need to change to support increasingly complicated policy requirements. 

As your governance processes mature, review the cloud guidance team's membership regularly to ensure that you can properly address the latest policy requirements.

### Reviews and policy iteration

As additional resources are deployed, the cloud governance team will need to ensure that new workloads or assets comply with policy requirements. Plan to meet with the teams responsible for deploying any new resources to discuss alignment with your design guides.

As your overall deployment grows, evaluate new potential risks regularly and update policy statements and design guides as needed. Schedule regular review cycles each of the five governance disciplines to ensure policy is up-to-date and being met.

### Education

Policy compliance requires IT staff and developers to understand the policy requirements that affect their areas of responsibility. Plan to devote resources to educate all relevant teams on the design guides that support your policy requirements.

### Establish escalation paths

If a resource goes out of compliance, who gets notified? If IT staff detect a policy compliance issue, who do they contact? Make sure the escalation process to the cloud governance team is clearly defined for staff.

## Violation triggers and actions

After defining your cloud governance team and its overall processes, you need to explicitly define what qualifies compliance violations that triggers actions, and what those actions should be. 

### Define triggers

For each of your policy statements, review requirements to determine what constitutes a policy violation. Generate your triggers using the information you've already established as part of the policy definition process.

* Risk tolerance - Create violation triggers based on the metrics and risk indicators you established as part of your [risk tolerance analysis](risk-tolerance.md). 
* Defined policy requirements - Policy statements may provide Service Level Agreement (SLA), Business continuity and disaster recovery (BRCD), or performance requirements that should be used as the basis for compliance triggers.

### Define actions

Each violation trigger should have a corresponding action. Triggered actions should always notify an appropriate IT staff or cloud governance  team member when a violation. This notification can lead to a manual review of the compliance issue or kickoff a pre-established remediation process depending on the type and severity of the detected violation. 

Some examples of violation triggers and enforcement actions:

| Cloud governance discipline | Sample trigger | Sample action |
|-----------------------------|----------------|---------------|
| Cost management | Monthly cloud spending is more than 20% higher than expected. | Notify billing unit leader who will begin a review of resource usage. |
| Security management | Detect suspicious user login activity. | Notify IT security team and disable suspect user account. |
| Resource management | CPU utilization for workload is greater than 90%. | Notify IT operations team and scale out additional resources to handle load. |

## Monitoring and enforcement automation

After you've defined your compliance violation triggers and actions, you can start planning how best to use the logging and reporting tools and other features of the cloud platform you're deploying on to help automate your monitoring and enforcement strategy. 

Consult the Fusion Infrastructure [Logs, reporting, and monitoring](../../infrastructure/logs-and-reporting/overview.md) topic for guidance on choosing the best monitoring pattern for your deployment.

