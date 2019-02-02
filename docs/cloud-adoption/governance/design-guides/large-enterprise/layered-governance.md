---
title: "Fusion: Large Enterprise – Multiple layers of governance in large enterprises"
description: Large Enterprise – Multiple layers of governance in large enterprises
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Large Enterprise – Multiple layers of governance in large enterprises

When large enterprises require multiple layers of governance, there are greater levels of complexity that must be factored into the Governance MVP and later governance evolutions.

A few common examples of such complexities include:

- Distributed governance functions.
- Corporate IT supporting Business unit IT organizations.
- Corporate IT supporting geographically distributed IT organizations.

This article explores some ways to navigate this type of complexity.

## Large enterprise governance is a team sport

Large established enterprises often have teams or employees who focus on the disciplines mentioned throughout this journey. This journey demonstrates one approach to making governance a team sport.

In many large enterprises, the disciplines of cloud governance can be blockers to adoption. Developing cloud expertise in identity, security, operations, deployments, and configuration across an enterprise takes time. Holistically implementing IT governance policy and IT security can slow innovation by months or even years. Balancing the business need to innovate and the governance need to protect existing resources is delicate.

The inherent capabilities of the cloud can remove blockers to innovation but increase risks. In this governance journey, we showed how the example company created guardrails to mitigate the risk. Rather than tackling each of the disciplines required to protect the environment, the Cloud Governance team leads a risk-based approach to govern what could be deployed, while the other teams build the necessary cloud maturities. Most importantly, as each team reaches cloud maturity, governance applies their solutions holistically. As each team matures and adds to the overall solution, the Cloud Governance team can open stage gates, allowing additional innovation and adoption to thrive.

This model illustrates the growth of a partnership between the Cloud Governance team and existing enterprise teams (Security, IT Governance, Networking, Identity, and others). The journey starts with the Governance MVP and grows to a holistic end state through Governance Evolutions.

## Requirements to supporting such a team sport

The first requirement of a multi-layer governance model is to understand of the governance hierarchy. Answering the follownig questions will help you to understand the general governance hierarchy:

- How is cloud accounting (billing for cloud services) allocated across business units?
- How are governance responsibilities allocated across corporate IT and each business unit?
- What types of environments do each of those units of IT manage?

## Central governance of a distributed governance hierarchy

Tools like Management Groups allow corporate IT to create a hierarchy structure that matches the governance hierarchy. Tools like Azure Blueprints can apply assets to different layers of that hierarchy. Azure Blueprints can be versioned and various versions can be applied to management groups, subscriptions, &/or resource groups. Each of these concepts is described in more detail in the Governance MVP.

The important aspect of each of these tools is the ability to apply multiple blueprints to a hierarchy. This allows governance to be a layered process. The following is one example of this hierarchical application of governance:

- Corporate IT: Corporate IT creates a set of standards and policies that apply to all cloud adoption. This is materialized in a “Baseline” Azure Blueprint. Corporate IT then owns the management group hierarchy, ensuring that a version of the baseline is applied to all subscriptions in the hierarchy.
- Regional or Business Unit IT: Various IT teams can apply an additional layer of governance by creating their own Azure Blueprint. Those blueprints would create additive policies and standards. Once developed, Corporate IT could apply those blueprints to the applicable nodes within the Management Group Hierarchy.
- Adoption teams: Detailed decisions and implementation about applications or workloads can be made by the Cloud Adoption team, within the context of governance requirements. At times the team can also request additional Azure Resource Management templates to accelerate adoption efforts.

The details regarding governance implementation at each level will require coordination between each team. The Governance MVP and Governance Evolutions outlined in this journey can aid in aligning that coordination.
