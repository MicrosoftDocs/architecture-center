---
title: "Fusion: Align design guides with policy."
description: How do you align design guides with policy?
author: BrianBlanchard
ms.date: 01/04/2019
---
<!---
I've established policies. How to help developers adopt these policies? 
Draft an architecture design guide. 

[Aspirational statement] If you're using azure, you can use one of ours as a starting point. The choose one of the following 6 as a starting point and mold it to fit your policies.
--->

# How do you align design guides with policy?

After you've [defined cloud policies](define-policies.md) based on your [identified risks](understanding-business-risk.md), you'll need to generate actionable guidance that aligns with these policies for your IT staff and developers to refer to. Drafting a cloud architecture design guide allows you to specify specific structural, technological, and process choices based on the policy statements you generated for each of the five governance disciplines.

A cloud governance design guide should establish the architecture choices and design patterns for each of the [core infrastructure components of cloud deployments](../../infrastructure/overview.md) that best meet your policy requirements. Alongside these you should provide a high-level explanation of the technology, tools, and processes that will support each of these design decisions.

Although your risk analysis and policy statements may, to some degree, be cloud platform agnostic, your design guide should provide  platform-specific implementation details that your IT and dev. Focus on the architecture, tools, and features of your chosen platform when making design decision and providing guidance.

While cloud design guides should take into account some of the technical details associated with each infrastructure component, they are not meant to be extensive technical documents or specifications. Make sure your guides address all of your policy statements and clearly state design decisions in a format easy for staff to understand and reference.

## Sample cloud design guides

If you're planning to use the Azure platform for your cloud migration, the Fusion guidance provides several [sample design guides](../design-guides/overview.md) covering a range of common migration scenarios. In addition to the design guide itself, each sample gives the use case, business risks, tolerance requirements, and policy statements that went into creating the example design guide.  

While every migration has unique goals, priorities, and challenges, these samples should provide a good template for converting your policy into guidance. Pick the closest scenario to your situation as a starting point, and mold it to fit your specific policy needs.

| Design guide scenario                                                       | Description                                                                   |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| [Future Proof](../design-guides/future-proof.md) | Early stage adoption may not warrant and investment in governance. However, this guide will establish a few best practices and policies to future proof adoption and ensure that proper governance can be added later. |
| [Protected Data](../design-guides/protected-data.md) | Some solutions are dependent upon protected data, like customer information or business secrets. The business risks associated with hosting protected data in the cloud can often be mitigated with proper disciplines. |
| [Enterprise MVP](../design-guides/enterprise-mvp.md) | Migrating the first few workloads in an enterprise comes with a few common business risks. The Enterprise MVP design guide provides a scalable starting point to move quickly, but grow into larger governance needs with cloud adoption. |
| [Enterprise @ Scale](../design-guides/enterprise-scale.md) | As additional solutions are deployed to the cloud, business risks grow. When enterprises reach scale across cloud deployments, governance requirements scale. This design guide builds on Enterprise MVP to meet these more complex needs. |
| [Enterprise Enforcement](../design-guides/enterprise-enforcement.md) | Multiple teams deploying to multiple clouds will naturally create policy violations. In complex environments, with thousands of applications and hundreds of thousands of VMs, automated policy enforcement is required. |
| [Multi-Cloud Governance](../design-guides/multi-cloud.md) | Industry analysts are predicting that multi-cloud solutions are an inevitable future. This design guide establishes current approaches to prepare for a multi-cloud landscape. |

## Next steps

With design guidance in place, [establish your monitoring and policy enforcement](monitor-enforce.md) plans to ensure policy compliance. 

> [!div class="nextstepaction"]
> [Monitoring and policy enforcement](monitor-enforce.md)