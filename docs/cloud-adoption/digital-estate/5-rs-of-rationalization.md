---
title: "Cloud rationalization"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Review the options available for rationalizing a digital estate.
author: BrianBlanchard
ms.author: brblanch
ms.date: 12/10/2018
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
ms.custom: governance
---

# Cloud rationalization

Cloud rationalization is the process of evaluating assets to determine the best way to migrate or modernize each asset in the cloud. For more information about the process of rationalization, see [What is a digital estate?](index.md).

## Rationalization context

The "five Rs of rationalization" listed in this article are a great way to label a potential future state for any workload that's being considered as a cloud candidate. However, this labeling process should be put into the correct context before you attempt to rationalize an environment. Review the following myths to provide that context:

- **Myth: It's easy to make rationalization decisions early in the process.** Accurate rationalization requires a deep knowledge of the workload and associated assets (apps, VMs, and data). Most importantly, accurate rationalization decisions take time. We recommend using an [incremental rationalization process](./rationalize.md#incremental-rationalization).

- **Myth: Cloud adoption has to wait for all workloads to be rationalized.** Rationalizing an entire IT portfolio or even a single datacenter can delay the realization of business value by months or even years. Full rationalization should be avoided when possible. Instead, use the [power of 10 approach to release planning](./rationalize.md#release-planning) to make wise decisions about the next 10 workloads that are slated for cloud adoption.

- **Myth: Business justification has to wait for all workloads to be rationalized.** To develop a business justification for a cloud adoption effort, make a few basic assumptions at the portfolio level. When motivations are aligned to innovation, assume rearchitecture. When motivations are aligned to migration, assume rehost. These assumptions can accelerate the business justification process. Assumptions are then challenged and budgets refined during the assessment phase of each workload's adoption cycles.

Now review the following five Rs of rationalization to familiarize yourself with the long-term process. While developing your cloud adoption plan, choose the option that best aligns with your motivations, business outcomes, and current state environment. The goal in digital estate rationalization is to set a baseline, not to rationalize every workload.

## The five Rs of rationalization

The five Rs of rationalization that are listed here describe the most common options for rationalization.

## Rehost

Also known as a "lift and shift" migration, a rehost effort moves a current state asset to the chosen cloud provider, with minimal change to overall architecture.

Common drivers might include:

- Reducing capital expense
- Freeing up datacenter space
- Achieving rapid return on investment in the cloud

Quantitative analysis factors:

- VM size (CPU, memory, storage)
- Dependencies (network traffic)
- Asset compatibility

Qualitative analysis factors:

- Tolerance for change
- Business priorities
- Critical business events
- Process dependencies

## Refactor

Platform as a service (PaaS) options can reduce the operational costs that are associated with many applications. It's a good idea to slightly refactor an application to fit a PaaS-based model.

"Refactor" also refers to the application development process of refactoring code to enable an application to deliver on new business opportunities.

Common drivers might include:

- Faster and shorter updates
- Code portability
- Greater cloud efficiency (resources, speed, cost)

Quantitative analysis factors:

- Application asset size (CPU, memory, storage)
- Dependencies (network traffic)
- User traffic (page views, time on page, load time)
- Development platform (languages, data platform, middle-tier services)

Qualitative analysis factors:

- Continued business investments
- Bursting options/timelines
- Business process dependencies

## Rearchitect

Some aging applications aren't compatible with cloud providers because of the architectural decisions that were made when the application was built. In these cases, the application might need to be rearchitected before transformation.

In other cases, applications that are cloud-compatible, but not cloud-native, might create cost efficiencies and operational efficiencies by rearchitecting the solution into a cloud-native application.

Common drivers might include:

- Application scale and agility
- Easier adoption of new cloud capabilities
- Mix of technology stacks

Quantitative analysis factors:

- Application asset size (CPU, memory, storage)
- Dependencies (network traffic)
- User traffic (page views, time on page, load time)
- Development platform (languages, data platform, middle tier services)

Qualitative analysis factors:

- Growing business investments
- Operational costs
- Potential feedback loops and DevOps investments.

## Rebuild

In some scenarios, the delta that must be overcome to carry an application forward can be too large to justify further investment. This is especially true for applications that previously met the needs of a business but are now unsupported or misaligned with the current business processes. In this case, a new code base is created to align with a [cloud-native](https://azure.microsoft.com/overview/cloudnative) approach.

Common drivers might include:

- Accelerate innovation
- Build apps faster
- Reduce operational cost

Quantitative analysis factors:

- Application asset size (CPU, memory, storage)
- Dependencies (network traffic)
- User traffic (page views, time on page, load time)
- Development platform (languages, data platform, middle tier services)

Qualitative analysis factors:

- Declining end-user satisfaction
- Business processes limited by functionality
- Potential cost, experience, or revenue gains

## Replace

Solutions are typically implemented by using the best technology and approach available at the time. Sometimes software as a service (SaaS) applications can provide all the necessary functionality for the hosted application. In these scenarios, a workload can be scheduled for future replacement, effectively removing it from the transformation effort.

Common drivers might include:

- Standardizing around industry-best practices
- Accelerating adoption of business process-driven approaches
- Reallocating development investments into applications that create competitive differentiation or advantages

Quantitative analysis factors:

- General operating cost reductions
- VM size (CPU, memory, storage)
- Dependencies (network traffic)
- Assets to be retired

Qualitative analysis factors:

- Cost benefit analysis of the current architecture versus a SaaS solution
- Business process maps
- Data schemas
- Custom or automated processes

## Next steps

Collectively, you can apply these five Rs of rationalization to a digital estate to help you make rationalization decisions about the future state of each application.

> [!div class="nextstepaction"]
> [What is a digital estate?](index.md)
