---
title: "Establish team structures"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Establish team structures
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: organize
---

# Establish team structures

To some degree, each of the cloud capabilities are provided by somebody during every cloud adoption effort. Those assignments and team structures can happen organically, or they can be purposeful and explicit in accordance with a defined team structure.

As adoption needs grow, so does the need to create balance and structure. This article provides examples of common team structures seen at various stages of organizational maturity. The following graphic and bullet point list outline those structures based on commonly seen maturation. Use these examples to find the org structure that best aligns with your operational needs.

![Organizational maturity cycle](../_images/ready/org-ready-maturity.png)

Organizational structures tend to move through a common maturity model outlined below:

1. [Cloud Adoption Team Only](#cloud-adoption-team-only)
2. [**MVP Best Practice**](#best-practice-minimum-viable-product-mvp) Best practice: minimum viable product (MVP)
3. [Cloud Center of Excellence](#cloud-center-of-excellence)
4. [Strategic Alignment](#strategic-alignment)
5. [Operational Alignment](#strategic-alignment)
6. [**Fully staffed Best Practice**](#best-practice-fully-staffed)

While most companies start with little more than a cloud adoption team, it is suggested that customers establish an organizational structure that more closely resembles the [MVP best practice](#best-practice-minimum-viable-product-mvp) organizational structure.

## Cloud adoption team only

The nucleus of all cloud adoption efforts is the cloud adoption team. This team is responsible for driving all of the technical change that makes adoption possible. Depending on the objectives of the adoption effort, this team could include a diverse range of team members performing a wide range of technical and business tasks.

![Cloud Adoption team, with governance and security teams](../_images/ready/org-ready-adoption-only.png)

For small adoption efforts or efforts that come early in a company's adoption lifecycle, this team could be as small as one person. In larger, late stage organizations it's not uncommon to see several cloud adoption teams, each with around six engineers. Regardless of size or tasks, the consistent aspect of any cloud adoption team, is that they serve as the mechanism for on-boarding solutions into the cloud. For some organizations, this may be a sufficient organizational structure. The [cloud adoption team](./cloud-adoption.md) article can provide more insight into the structure, composition, or function of the cloud adoption capability.

> [!WARNING]
> Operating with only a cloud adoption team (or multiple cloud adoption teams) is considered an antipattern and should be avoided. At minimum, consider the Best Practice MVP outlined in the prior section.

## Best practice: minimum viable product (MVP)

At minimum, it is suggested that two teams be established to create balance across cloud adoption efforts. These two teams would be responsible for various capabilities throughout the adoption effort.

- **Cloud adoption teams:** Teams adopting cloud technologies are accountable for technical solutions, business alignment, project management, and operations of the solutions being adopted.
- **Cloud governance team:** To balance the cloud adoption teams, a cloud governance team would be dedicated to ensuring excellence in the solutions being delivered. In this structure, the cloud governance team would be accountable for platform maturity, platform operations, governance, and automation.

![Cloud adoption with a cloud center of excellence](../_images/ready/org-ready-best-practice.png)

This best practice approach is considered an MVP because it may not be sustainable. Each team is wearing many hats, as outlined in the RACI chart below. The next sections will describe a fully staffed, best practice organizational structure and approaches to aligning the appropriate structure for your organization.

## Cloud Center of Excellence

One of the first signs of maturity in adoption efforts, is a desired to move beyond governance to a cloud center of excellence structure. Such a structure is similar to the [MVP best practice](#best-practice-minimum-viable-product-mvp) organizational structure. However, there is one fundamental difference between a cloud center of excellence model and the MVP best practice. The capabilities of the governance team are realigned to accelerate adoption and innovation.

![Cloud adoption with a cloud center of excellence](../_images/ready/org-ready-fully-staffed.png)

## Strategic alignment

When the motivations driving cloud adoption are aligned to business outcomes, it is important to add a defined cloud strategy team as pictured below. This model works well as an addition to the [MVP best practice](#best-practice-minimum-viable-product-mvp) or the [cloud center of excellence](#cloud-center-of-excellence) models.

![Add a defined cloud strategy team](../_images/ready/org-ready-strategy-aligned.png)

## Operational alignment

When stable IT operations are required to achieve business outcomes, it is important to add a defined cloud operations team as pictured below. This model works well as an addition to the [MVP best practice](#best-practice-minimum-viable-product-mvp), [cloud center of excellence](#cloud-center-of-excellence), or [strategic alignment](#strategic-alignment) models.

![Add a defined cloud operations team](../_images/ready/org-ready-operations-aligned.png)

## Best practice: Fully staffed

At the other end of spectrum, the following graphic outlines a fully staffed, best practice organizational structure. In this approach, there are six dedicate teams each accountable for a distinct set of capabilities.

![Fully staffed best practice organizational structure](../_images/ready/org-ready-fully-staffed.png)

It is not feasible for organizations to maintain a fully staffed, best practice organizational structure for long. For most companies, this model quickly creates diminishing returns when used to shape a traditional org chart. However, it is not uncommon for large companies to define v-teams in an effort to align available skills with defined capabilities. A scaled-out v-team model, like the image above or the RACI chart below, is much more sustainable.

## Next steps

After aligning to a chosen level of organizational structure maturity, [RACI charts](./raci-alignment.md) can be used to align accountability and responsibility across each team.

> [!div class="nextstepaction"]
> [Align the appropriate RACI chart](./raci-alignment.md)
