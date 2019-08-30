---
title: "Large enterprise guide: Multiple layers of governance"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: "Large enterprise guide: Multiple layers of governance"
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

# Large enterprise guide: Multiple layers of governance

When large enterprises require multiple layers of governance, there are greater levels of complexity that must be factored into the governance MVP and later governance improvements.

A few common examples of such complexities include:

- Distributed governance functions.
- Corporate IT supporting Business unit IT organizations.
- Corporate IT supporting geographically distributed IT organizations.

This article explores some ways to navigate this type of complexity.

## Large enterprise governance is a team sport

Large established enterprises often have teams or employees who focus on the disciplines mentioned throughout this guide. This guide demonstrates one approach to making governance a team sport.

In many large enterprises, the Five Disciplines of Cloud Governance can be blockers to adoption. Developing cloud expertise in identity, security, operations, deployments, and configuration across an enterprise takes time. Holistically implementing IT governance policy and IT security can slow innovation by months or even years. Balancing the business need to innovate and the governance need to protect existing resources is delicate.

The inherent capabilities of the cloud can remove blockers to innovation but increase risks. In this governance guide, we showed how the example company created guardrails to manage the risks. Rather than tackling each of the disciplines required to protect the environment, the cloud governance team leads a risk-based approach to govern what could be deployed, while the other teams build the necessary cloud maturities. Most importantly, as each team reaches cloud maturity, governance applies their solutions holistically. As each team matures and adds to the overall solution, the cloud governance team can open stage gates, allowing additional innovation and adoption to thrive.

This model illustrates the growth of a partnership between the cloud governance team and existing enterprise teams (Security, IT Governance, Networking, Identity, and others). The guide starts with the governance MVP and grows to a holistic end state through governance iterations.

## Requirements to supporting such a team sport

The first requirement of a multilayer governance model is to understand of the governance hierarchy. Answering the following questions will help you to understand the general governance hierarchy:

- How is cloud accounting (billing for cloud services) allocated across business units?
- How are governance responsibilities allocated across corporate IT and each business unit?
- What types of environments do each of those units of IT manage?

## Central governance of a distributed governance hierarchy

Tools like management groups allow corporate IT to create a hierarchy structure that matches the governance hierarchy. Tools like Azure Blueprints can apply assets to different layers of that hierarchy. Azure Blueprints can be versioned and various versions can be applied to management groups, subscriptions, or resource groups. Each of these concepts is described in more detail in the governance MVP.

The important aspect of each of these tools is the ability to apply multiple blueprints to a hierarchy. This allows governance to be a layered process. The following is one example of this hierarchical application of governance:

- **Corporate IT:** Corporate IT creates a set of standards and policies that apply to all cloud adoption. This is materialized in a "Baseline" blueprint. Corporate IT then owns the management group hierarchy, ensuring that a version of the baseline is applied to all subscriptions in the hierarchy.
- **Regional or Business Unit IT:** Various IT teams can apply an additional layer of governance by creating their own blueprint. Those blueprints would create additive policies and standards. Once developed, Corporate IT could apply those blueprints to the applicable nodes within the management group hierarchy.
- **Cloud adoption teams:** Detailed decisions and implementation about applications or workloads can be made by each cloud adoption team, within the context of governance requirements. At times the team can also request additional Azure Resource Consistency templates to accelerate adoption efforts.

The details regarding governance implementation at each level will require coordination between each team. The governance MVP and governance improvements outlined in this guide can aid in aligning that coordination.

