---
title: "Enterprise Cloud Adoption: Understanding the impact of Global Markets"
description: Explanation of the concept of global markets
author: BrianBlanchard
ms.date: 10/10/2018
---

# Enterprise Cloud Adoption: How will Global Market decisions impact the Transformation Journey?

The Cloud opens new opportunities to perform on a global scale. Barriers to global operations are significantly reduced, by empowering companies to deploy assets in market, without the need to invest heavily in new data centers. Unfortunately, this also adds a great deal of complexity from technical and legal perspectives.

## Data Sovereignty

Many geo-political regions have established Data Sovereignty regulations. Those regulations place restrictions on where data can be stored, what data can leave the country of origin, what data can be collected about citizens of that region, etc... Before deciding to operate any Cloud based solution in a foreign geography, it may be wise to understand how that cloud provider handles data sovereignty. More information on Azure's approach by geography is available [here](https://azure.microsoft.com/en-us/global-infrastructure/geographies/). Additional resource on compliance within Azure are available [here](https://www.microsoft.com/en-us/trustcenter/privacy/ensure-compliance).

The remainder of this article assumes legal council has reviewed and approved operations in a foreign country.

## Business Units

It is important to understand which business units operate in foreign countries, and which countries are impacted. This information will be used to design solutions for hosting, billing, and deployments to the cloud provider.

## Employee Usage Patterns

It is important to understand how global users access applications that are not hosted in the same country as the user. Often time global WANs (Wide Area Networks) route users based on existing networking agreements. In a traditional on-prem world, there are a number of constraints that limit WAN design. Those constraints can lead to very poor user experiences, if not properly understood prior to cloud adoption. 

In a Cloud model, commodity internet opens up many new options as well. Communicating the spread of employees across multiple geographies can help the Cloud Migration Team design WAN solutions that create positive user experiences AND potential reduce networking costs.

## External User Usage Patterns

It is equally important to understand the usage patterns of external users, like customers or partners. Much like employee usage patterns, External User Usage Patterns can negatively impact performance of cloud deployments. When a large or mission critical user base resides in a foreign country, it could be wise to include a global deployment strategy into the overall solution design.

## Next steps

Once global market decisions have been made and communicated, the team is ready to begin [establishing technical standards](../digital-estate/overview.md) against those metrics.
The result will be a [Transformation Backlog or Migration Backlog](../migration/plan/migration-backlog.md).

> [!div class="nextstepaction"]
> [Assess the Digital Estate](../digital-estate/overview.md)