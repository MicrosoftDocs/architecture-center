---
title: "Understand the impact of global market decisions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of the concept of global markets
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: strategy
---

<!-- markdownlint-disable MD026 -->

# How will global market decisions affect the transformation journey?

The cloud opens new opportunities to perform on a global scale. Barriers to global operations are significantly reduced, by empowering companies to deploy assets in market, without the need to invest heavily in new datacenters. Unfortunately, this also adds a great deal of complexity from technical and legal perspectives.

## Data sovereignty

Many geopolitical regions have established data sovereignty regulations. Those regulations restrict where data can be stored, what data can leave the country of origin, and what data can be collected about citizens of that region. Before operating any cloud-based solution in a foreign geography, you should understand how that cloud provider handles data sovereignty. More information on Azure's approach for each geography is available [here](https://azure.microsoft.com/global-infrastructure/geographies). For more information about compliance in Azure, see [Privacy at Microsoft](https://www.microsoft.com/trustcenter/privacy) in the Microsoft Trust Center.

The remainder of this article assumes legal counsel has reviewed and approved operations in a foreign country.

## Business units

It is important to understand which business units operate in foreign countries, and which countries are affected. This information will be used to design solutions for hosting, billing, and deployments to the cloud provider.

## Employee usage patterns

It is important to understand how global users access applications that are not hosted in the same country as the user. Often time global WANs (Wide Area Networks) route users based on existing networking agreements. In a traditional on-premises world, some constraints limit WAN design. Those constraints can lead to poor user experiences if not properly understood before cloud adoption.

In a cloud model, commodity internet opens up many new options as well. Communicating the spread of employees across multiple geographies can help the cloud adoption team design WAN solutions that create positive user experiences **and** potential reduce networking costs.

## External user usage patterns

It is equally important to understand the usage patterns of external users, like customers or partners. Much like employee usage patterns, External User Usage Patterns can negatively affect performance of cloud deployments. When a large or mission-critical user base resides in a foreign country, it could be wise to include a global deployment strategy into the overall solution design.

## Next steps

Once global market decisions have been made and communicated, the team is ready to begin [establishing technical standards](../digital-estate/index.md) against those metrics.
The result will be a [transformation backlog or migration backlog](..//migrate/migration-considerations/prerequisites/technical-complexity.md).

> [!div class="nextstepaction"]
> [Assess the digital estate](../digital-estate/index.md)
