---
title: "Fusion: Technical Standards"
description: Overview of Technical Standards
author: rotycenh
ms.date: 11/02/2018
---

# Fusion: What are Technical Standards in the context of the Fusion framework

Technical standards will define (or at least influence) many of the configuration activities executed by the Cloud Adoption Team. This article outlines a series of the most important initial Technical Standards to establish before beginning a cloud transformation journey.

## Technical Standards

Each of the following components represents one of the technical standards that will guide all cloud deployments. It's important to learn how these standards influence work.

**Naming convention:** Consistent naming standards are important to understand what is deployed and why. CMDB (Content Management DataBases) are often used to track the purpose of any deployed asset. However, it is seldom financial prudent to maintain such systems. Often times a good naming convention can provide operational understandings to overcome gaps in the CMDB or asset tracking systems.

**Subscription Design:** In Azure specifically, assets are grouped into subscriptions. Implementing a proper design for subscriptions is important to ensure access, billing, and security for each asset.

**Tagging standards:** Assets can be tracked based on tags. When a proper tagging standard is established and enforced, tagging can replace the CMDB. It can also facilitate easier to manage accounting practices regarding cloud costs.

**Management Groups:** Associating assets via management groups reduces the difficulty of managing, deploying, and operating applications or workloads. Establishing management group requirements prior to deploy can reduce long term operational costs.

**Policies & Blueprints** In Azure, policies can establish security rules within a subscription to minimize governance violations. Blueprints then enforce policies across a number of subscriptions in a top-down enforcement model. 

Properly establishing these technical principles will improve consistency and establish a basic foundation for operational excellence and governance disciplines.

## Next steps

Learn how to establish [core infrastructure](../infrastructure/overview.md) based on the defined technical standards.

> [!div class="nextstepaction"]
> [core infrastructure](../infrastructure/overview.md)
