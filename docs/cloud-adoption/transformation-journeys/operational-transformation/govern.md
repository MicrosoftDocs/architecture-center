---
title: "Fusion: Governing Operational Transformation"
description: Operational Transformation - Cloud Governance
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: Governing Operational Transformation Journey (OTJ)

[Operational Transformation](overview.md) is one of the [Transformation Journeys](../overview.md) included in the [Fusion framework](../../overview.md). The objective of an Operational Transformation, is the enablement and realization of internal business outcomes. Often times these outcomes center around increased efficiencies, reduced complexity, and improved agility. This article focuses on the Govern process within a transformation.

![Govern process within Operational Transformation](../../_images/operational-transformation-govern.png)

*Figure 1. Govern process within Operational Transformation. Activities within the process detailed below*

Download the full size infographic: [pdf format](../../_images/operational-transformation-infographic.png) [png format](../../_images/operational-transformation-infographic.pdf)

## Business Activities 

In a governance process, the business experts have one major focus:

* [Business Risks](../../business-strategy/risk-tolerance.md): During each iteration, the Cloud Governance Team will identify and surface any new business risks associated with the assets being migrated to the cloud. Business stakeholders, the Cloud Strategy Team, and the Cloud Governance Team work together to evaluate and document risk tolerance and risk mitigation requirements. These risks and mitigation decisions will drive the creation or modification of corporate policies which govern azure migrations.

## Culture Activities

During Governance iteration, its important that leadership be reminded to demonstrate the [growth mindset](../../culture-strategy/c-suite-readiness.md) discussed in the [Plan process](plan.md). At times business risk activities will seem like impediments to transformation. In all reality, these practices will create stability and safe technical constructs, allowing the team to do more, faster.

## Strategic Activities (Meta Activities)

When governance is implemented for governance sake, there are tangible risks of policy bloat and an overly constrained environment. In Operational Transformation, Governance begins with a Minimally Viable Product (MVP). Learn more about [Governance MVP](../../governance/overview.md)

* [Corporate Policy / Compliance](../../governance/policy-compliance/overview.md): During each iteration, the Governance team integrates changes to business risks and converts those risks to policies which protect the business. This approach allows for "Just Enough" governance to protect the deployed environment.
* [Monitor and Enforce](../../governance/monitoring-enforcement/overview.md): Policies become real, when they can be enforced. During each iteration, the Cloud Governance Team will define the proper processes and actions associated with any new or changed corporate policies. The team will also define the best means to monitor policy adherence and proper actions to be taken when adherence isn't met.

## Technology Activities (Five Disciplines of Cloud Governance)

Each cloud vendor provides a number of tools to monitor and enforce cloud governance. With each passing month, these tools grow closer to parity with on-prem tooling. However, the following sections are not about tools. The five Disciplines of Cloud Governance represent the common activities and disciplines that customers implement to govern cloud deployments. At each iteration of the Govern process, the Cloud Governance Team focuses on advancing capabilities in each discipline to align with the changing business risks and maturing policies.

* [Cost Management](../../governance/cost-management/overview.md): In the cloud, every technical decisions can impact cost. This new paradigm requires slightly different disciplines. The Cost Management discipline focuses on the proper allocation of Cloud spend to various business units or initiative. It also guides the review & modification of spend projection.
* [Security Management](../../governance/security-management/overview.md): Security Management is a broad discipline. We could write volumes on this topic alone. Constraining scope in alignment with Operational Transformation, this journey limits Security Management to the protection of the network, assets, and data deployed to the cloud, or accessible by hybrid connections. These three topics change significantly in a cloud model and require new ways of thinking about protection.
* [Identity Management](../../governance/identity-management/overview.md): Implementation of a hybrid identity management solution allows for rapid maturation in this discipline. Hybrid identity solutions may already as a result of SaaS offerings like Office365. In such scenarios, this discipline may be as simple as the management of role mappings. The materials on this discipline aids Cloud Governance Teams in deciding the full scope of identity based on migration expectations.  
* [Resource Management](../../governance/resource-management/overview.md): Once an asset is migrated to Azure, that asset or resource may require new operational management tools, skills, or processes. The Resource Management discipline aids Cloud Governance teams in making Tech Ops decisions, as the adoption of the cloud evolves.
* [Configuration Management](../../governance/configuration-management/overview.md): How an asset is replicated and staged in the cloud directly impacts how it can be managed. Configuration management helps define the options for deploying assets, but also the options for maintaining and updating configuration throughout the life of an asset. From ASR to DevOps, there are many options for configuration management during and post-deployment.

## Next steps

Learn about [change management](manage.md) in an [Operational Transformation Journey](overview.md), to understand how assets are tracked and managed during a transformation.

> [!div class="nextstepaction"]
> [Manage change and efforts](manage.md)