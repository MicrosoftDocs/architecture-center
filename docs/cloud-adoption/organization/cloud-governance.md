---
title: "Cloud governance capabilities" 
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Describes the formation of cloud governance capabilities
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: organize
ms.custom: organize
---

# Cloud governance capabilities

Any kind of change generates new risks. Cloud governance capabilities ensure that risks and risk tolerance are properly evaluated and managed. This capability ensures the proper identification of risks that can't be tolerated by the business. The people providing this capability can then convert risks into governing corporate policies. Governing policies are then executed through defined disciplines executed by the staff members who provide cloud governance capabilities.

## Possible sources for this capability

Depending on the desired business outcomes, the skills needed to provide full cloud governance capabilities could be provided by:

- IT governance
- Enterprise architecture
- IT operations
- IT infrastructure
- Networking
- Identity
- Virtualization
- Business continuity / Disaster recovery
- Application owners within IT

The cloud governance capability identifies risks related to current and future releases. This capability is seen in the efforts to evaluate risk, understand the potential impacts, and make decisions regarding risk tolerance. In doing so, plans can quickly be updated to reflect the changing needs of the [cloud adoption capability](./cloud-adoption.md).

## Key responsibilities

The primary duty of any cloud governance capability is to balance competing forces of transformation and risk mitigation. Additionally, cloud governance ensures that [cloud adoption](./cloud-adoption.md) is aware of data and asset classification and architecture guidelines that govern all adoption approaches. The team will also work with the [cloud center of excellence](./cloud-center-excellence.md) to apply automated approaches to governing cloud environments.

These tasks are usually executed by the cloud governance capability on a monthly basis.

**Early planning tasks:**

- Understand [business risks](../governance/policy-compliance/risk-tolerance.md) introduced by the plan
- Represent the [business' tolerance for risk](../governance/policy-compliance/risk-tolerance.md)
- Aid in the creation of a [Governance MVP](../governance/journeys/index.md)

**Ongoing monthly tasks:**

- Understand [business risks](../governance/policy-compliance/risk-tolerance.md) introduced during each release
- Represent the [business' tolerance for risk](../governance/policy-compliance/risk-tolerance.md)
- Aid in the incremental improvement of [Policy and Compliance requirements](../governance/policy-compliance/overview.md)

## Meeting cadence

Cloud governance capability is usually delivered by a working team. The time commitment from each team member will represent a large percentage of their daily schedules. Contributions will not be limited to meetings and feedback cycles.

## Additional participants

The following represent participants who will frequently participate in cloud governance activities:

- Leaders from middle management and direct contributors in key roles who have been appointed to represent the business will help evaluate risk tolerances.
- The cloud governance capabilities are offered delivered be an extension of the [cloud strategy capability](./cloud-strategy.md). Just as the CIO and business leaders are expected to participate in cloud strategy capabilities, their direct reports are expected to participate in cloud governance activities.
- Business employees that are members of the business unit who work closely with the leadership of the line-of-business should be empowered to make decisions regarding corporate and technical risk.
- Information Technology (IT) and Information Security (IS) employees who understand the technical aspects of the cloud transformation may serve in a rotating capacity instead of being a consistent provider of cloud governance capabilities.

## Maturation of cloud governance capability

Some large organizations have existing, dedicated teams that focus on IT governance. These teams specialize in risk management across the IT portfolio through methodologies like ITIL or ITSM. When those teams exist, the following maturity models can be accelerated quickly. However, the IT governance team is encouraged to review the cloud governance model to understand how governance shifts slightly in the cloud. Key articles include [Extending corporate policy to the cloud](../governance/corporate-policy.md) and the [five disciplines of cloud governance](../governance/governance-disciplines.md).

**No governance:** It is common for organizations to move into the cloud with no clear plans for governance. Before long, concerns around security, cost, scale, and operations begin to trigger conversations about the need for a governance model and people to staff the processes associated with that model. Starting those conversations before they become concerns is always a good first step to overcome the antipattern of "no governance." The section on [defining corporate policy](../governance/corporate-policy.md) can help facilitate those conversations.

**Governance blocked:** When concerns around security, cost, scale, and operations go unanswered, projects and business goals tend to get blocked. Lack of proper governance generates fear, uncertainty, and doubt amongst stakeholders and engineers. Stop this in its tracks by taking action early. The two governance guides defined in the Cloud Adoption Framework can help you start small, set initially limiting policies to minimize uncertainty and mature governance over time. Choose from the [large enterprise guide](../governance/journeys/large-enterprise/index.md) or [small/medium enterprise guide](../governance/journeys/small-to-medium-enterprise/index.md).

**Voluntary governance:** There tend to be brave souls in every enterprise. Those gallant few who are willing to jump in and help the team learn from their mistakes. Often this is how governance starts, especially in smaller companies. These brave souls volunteer time to fix some issues and push cloud adoption teams toward a consistent well-managed set of best practices.

The efforts of these individuals are much better than "no governance" or "governance blocked" scenarios. While their efforts should be commended, this approach should not be confused with governance. Proper governance requires more than sporadic support to drive consistency, which is the goal of any good governance approach. The guidance in the [five disciplines of cloud governance](../governance/governance-disciplines.md) can help develop this discipline.

**Cloud custodian:** This moniker has become a badge of honor for many cloud architects who specialize in early stage governance. When governance practices first start out, the results appear similar to those of governance volunteers. However, there is one fundamental difference. A cloud custodian has a plan in mind. At this stage of maturity, the team is spending time cleaning up the messes made by the cloud architects who came before them. However, the cloud custodian aligns that effort to well structured [corporate policy](../governance/corporate-policy.md). They also use governance automation tools, like those outlined in the [governance MVP](../governance/journeys/large-enterprise/index.md).

Another fundamental difference between a cloud custodian and a governance volunteer is leadership support. The volunteer puts in extra hours above regular expectations because of their quest to learn and do. The cloud custodian gets support from leadership to reduce their daily duties to ensure regular allocations of time can be invested in improving cloud governance.

**Cloud guardian:** As governance practices solidify and become accepted by cloud adoption teams, the role of cloud architects who specialize in governance changes a bit, as does the role of the cloud governance team. Generally, the more mature practices gain the attention of other subject matter experts who can help strengthen the protections provided by governance implementations.

While the difference is subtle, it is an important distinction when building a governance-focused IT culture. A cloud custodian cleans up the messes made by innovative cloud architects, and the two roles have natural friction and opposing objectives. A cloud guardian helps keep the cloud safe, so other cloud architects can move more quickly with fewer messes.

Cloud guardians begin using more advanced governance approaches to accelerate platform deployment and help teams self-service their environmental needs, so they can move faster. Examples of these more advanced functions are seen in the incremental improvements to the governance MVP, such as [improvement of the security baseline](../governance/journeys/large-enterprise/security-baseline-evolution.md).

**Cloud accelerators:** Cloud guardians and cloud custodians naturally harvest scripts and automations that accelerate the deployment of environments, platforms, or even components of various applications. Curating and sharing these scripts in addition to centralized governance responsibilities develops a high degree of respect for these architects throughout IT.

Those governance practitioners who openly share their curated scripts help deliver technology projects faster and embed governance into the architecture of the workloads. This workload influence and support of good design patterns elevate cloud accelerators to a higher rank of governance specialist.

**Global governance:** When organizations depend on globally dispersed IT needs, there can be significant deviations in operations and governance in various geographies. Business unit demands and even local data sovereignty requirements can cause governance best practices to interfere with required operations. In these scenarios, a tiered governance model allows for minimally viable consistency and localized governance. The article on [multiple layers of governance](../governance/journeys/large-enterprise/multiple-layers-of-governance.md) provides more insights on reaching this level of maturity.

Every company is unique, and so are their governance needs. Choose the level of maturity that fits your organization and use the Cloud Adoption Framework to guide the practices, processes, and tooling to help you get there.

## Next steps

As cloud governance matures, teams will be empowered to adopt the cloud at ever faster paces. Continued cloud adoption efforts tend to trigger maturity in IT operations. This maturation may also necessitate the development of [cloud operations capabilities](./cloud-operations.md).

> [!div class="nextstepaction"]
> [Develop cloud operations capabilities](./cloud-operations.md)
