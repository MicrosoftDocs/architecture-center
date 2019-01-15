---
title: "Fusion: Small to Medium Enterprise – Multi-Cloud Evolution"
description: Explanation Small to Medium Enterprise – Governance - Integrating other clouds
author: BrianBlanchard
ms.date: 2/1/2018
---

# Fusion: Small to Medium Enterprise – Multi-Cloud Evolution

This article will evolve the narrative by adding multi-cloud integration to the [Governance MVP](./governance-mvp.md).

Jump to [Narrative Changes](#narrative-changes) | [Corporate Policy Changes](#corporate-policy) | [Technical Changes](#technical-changes)

## Narrative Changes

Microsoft recognizes that customers are adopting multiple clouds for specific purposes. The synthesized customer in this journey is no exception. In parallel to the Azure adoption journey, the business success has led to the acquisition of a small, but complementary business. That business is running all of their IT operations on a different cloud provider.

This article will capture how things change when integrating the new organization. One assumption to note, this company has completed each of the governance evolutions outlined in this customer journey.

### Current State

* Identity is controlled by an on-prem instance of Active Directory. Hybrid Identity is facilitated through replication to Azure Active Directory.
* IT Operations or Cloud Operations are largely managed by Azure Monitor and related automations.
* Disaster Recovery / Business Continuity is controlled by Azure Vault instances
* Azure Security Center is used to monitor security violations and attacks
* Security Center and Azure Monitor are both used to monitor governance of the cloud
* Blueprints, Azure Policy, and Management Groups are used to automate compliance to policy

### Future State 

* Integrate the acquisition company into existing operations wherever possible.

## Corporate Policy

The changes to current and future state expose new risks that will require new policy statements.

### New Risks

**Business Acquisition Cost:** Acquisition of the new business is slated to be profitable in approximately five years. Because of the slow rate of return, the board wants to control acquisition costs, as much as possible. There is a risk of cost control and technical integration conflicting with one another.

This business risk can be expanded into a few technical risks

* There is risk of cloud migration producing additional acquisition costs
* There is also a risk of the new environment not being properly governed or resulting in policy violations

### New Policy Statements

The following changes to policy will help mitigate the new risks and guide implementation.

1) All assets in a secondary cloud must be monitored through existing operational management and security monitoring tools
2) All Organization Units must be integrated into the existing identity provider
3) The primary identity provider should govern authentication to assets in the secondary cloud

## Technical Changes

This section of the article will evolve the Governance MVP design to include new Azure Policies and an implementation of Azure Cost Management. Together, these two design changes will fulfill the new corporate policy statements.

### Design Evolution Overview

1) Connect the networks - Executed by Networking and IT Security, supported by governance
    a. Adding a connection from the MPLS/Leased line provider to the new cloud will integrate networks. Adding routing tables and firewall configurations will control access and traffic between the environments. 
2) Consolidate Identity Providers
    a. Depending on the workloads being hosted in the secondary cloud, there are a variety of options to identity provider consolidation. The following are a few examples:
        i. For applications that authenticate using OAUTH2, OUs from the Active Directory in the secondary cloud could simply be replicated to the existing Azure AD tenant.
        ii. On the other extreme, federation would allow OUs to flow into Active Directory on-prem, then on to the Azure AD instance.
3) Add assets to Azure Site Recovery
    a. Azure Site Recovery was built as a hybrid/multi-cloud tool from the beginning
    b. VMs in the secondary cloud might be able to be protected by the same Azure Site Recovery processes used to protect on-prem assets
4) Add assets to Azure Cost Management
    a. Azure Cost Management was built as a multi-cloud tool from the beginning
    b. VMs in the secondary cloud might be compatible with Azure Cost Management for some cloud providers. Additional costs may apply.
5) Add Assets to Azure Monitor
    a. Azure Monitor was built as a hybrid cloud tool from the beginning
    b. VMs in the secondary cloud might be compatible with Azure Monitor agents, allowing them to be included in Azure Monitor for operational monitoring
6) Governance Enforcement tools
    a. Governance enforcement is cloud specific.
    b. The Corporate policies established in the governance journey are not. While the implementation may vary from cloud to cloud, the policy statements can be applied to the secondary provider

As multi-cloud adoption grows, the design evolution above will continue to mature. Return to this page over time to find new ways to improve cross-cloud governance.

## Next steps

As cloud adoption continues to evolve and deliver additional business value, risks and cloud governance needs will also evolve. The following are a few evolutions that may be experienced in the future.

* [Resource Management](./mission-critical.md): Deployment of mission critical workloads
* [Security Management](./protected-data.md): Inclusion of protected data in defined cloud adoption plans
* [Cost Management](cost-control.md): Scale of deployment exceeds 100 assets to the cloud or Monthly spend exceeding $1,00/month