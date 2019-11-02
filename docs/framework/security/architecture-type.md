---
title: What types of attack should the architecture resist in Azure | Microsoft Docs
description: An architecture built on good security practices should be resilient to attacks.
author: PageWriter-MSFT
ms.date: 07/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
---

# What types of attack should the architecture resist?

An architecture built on good security practices should be resilient to attacks.
It should both resist attacks and recover rapidly from disruption to the
security assurances of confidentiality, integrity, and availability.

Because security resources are always limited, it is critical to discover and
prioritize risks based on the mission of the organization. This activity should
use the best possible data sources available, which can come from:

-   **Experience and Data** – Services, applications, and architectures that
    already have been in production can leverage real world data from attacks
    and experience to guide prioritization of security investments to mitigate
    risks. These types of systems sometimes have clearly defined actionable best
    practices like the ones that are included in this document.

-   **Threat Modeling** – Newly defined systems such as applications in
    development (or modifications to them) don’t have real world data on the top
    vectors attackers would target, so you must rely more on a model of possible
    and likely vectors to guide risk mitigation. Threat modeling is a
    structured process to applying security expertise that models the possible
    attack vectors and prioritize the most likely/damaging threats, allowing you
    to prioritize risk mitigate efforts. Threat modeling can also be applied to
    existing systems or a combination of systems.

This document focuses on sharing clearly defined good security practices as well
as guidance on applying [threat modeling to your applications and architectures](/azure/architecture/security/applications-services#advanced-threat-modeling-techniques).

For more information on current attacks, see the [Microsoft Security
Intelligence (SIR) report](https://www.microsoft.com/sir).