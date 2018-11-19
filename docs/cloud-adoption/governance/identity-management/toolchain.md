---
title: "Fusion: What tools can help better manage user identities in Azure?"
description: Explanation of the tools that can facilitate improved identity management in Azure
author: BrianBlanchard
ms.date: 10/10/2018
---

# Fusion: What tools can help better manage user identities in Azure?

In the [Intro to Cloud Governance](../overview.md), [Identity Management](overview.md) is one of the Five Disciplines to Cloud Governance. This discipline focuses on ways of establishing policies that ensure consistency and continuity of user identities regardless of the cloud provider that hosts the application or workload.

Unlike the cloud agnostic position throughout Fusion, this article is Azure specific. The following is a list of Azure native tools that can help mature the policies and processes that support this governance discipline.

The following tools are included in the discovery guide on Hybrid Identity.

**Active Directory (on-prem):** Active Directory is the identity provider most frequently used in the enterprise to store and validate user credentials.

**Azure Active Directory:** SaaS (Software as a Service) equivalent to Active Directory, with the ability to federate to Active Directory (on-prem)

**Active Directory (IaaS):** An instance of the Active Directory application running in a virtual machine in Azure.

The [Hybrid Identity Digital Transformation Framework](https://resources.office.com/ww-landing-M365E-EMS-IDAM-Hybrid-Identity-WhitePaper.html?LCID=EN-US) outlines a number of combinations and solutions for choosing and integrating each of these components. Additionally, the article on [choosing the right authentication method for Azure Active Directory](https://docs.microsoft.com/azure/security/azure-ad-choose-authn), contains a decision tree to help choose the best solution for a given scenario.