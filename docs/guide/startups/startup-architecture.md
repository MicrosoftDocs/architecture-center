---
title: Architecture for startups
titleSuffix: Azure Architecture Center
description: Understand how to approach architecture when you're working in a startup.
author: mootpointer
ms.author: robbag
ms.date: 6/27/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.custom:
  - fcp
  - guide
categories:
  - developer-tools
  - devops
  - management-and-governance
  - web
products:
  - azure-app-service
---

# Architecture for startups

Building a startup is a unique challenge. The core task is to find a place for an innovation as a product or service in the market. This process requires testing multiple assumptions that are built into the innovation. A successful startup must iterate through these assumptions, and grow and scale as its product gains product and market fit. After finding this fit, the startup must scale to meet market demands.

In the different startup life stages, developers, architects, and chief technical officers (CTOs) handle distinct phases of development. These stages require fundamentally different approaches and different technology choices. Part of the task is to establish which phase your startup is in. Choose the technologies and architectures that match that phase.

## Innovation stages

Kent Beck describes a [three-stage process](https://medium.com/@kentbeck_7670/fast-slow-in-3x-explore-expand-extract-6d4c94a7539) of software product innovation. Those stages are *explore*, *expand*, and *extract*. You can think about the different parts of this process as a graph:

:::image type="complex" source="images/explore-expand-extract.png" alt-text="A graph that shows the Explore, Expand, and Extract phases of product development." border="false":::
  A graph showing a sigmoid curve plotted against a y-axis "Certainty/Investment/Risk of Change" and an x-axis "Time". The graph has three areas highlighted: the initial portion before upward inflection labeled "Explore", the high growth part of the sigmoid curve labeled "Expand" and the plateau labeled "Extract".
:::image-end:::

- The **Explore** stage starts with a low slope, where you're trying to find what works. Certainty is low, you only invest small amounts, and the risk from any changes you make is also low.

- At some point, the graph rises more rapidly. This rapid growth is the **Expand** stage. Your certainty greatly increases, you invest much more, and you're much more aware of risks.

- Finally, as the graph flattens out, you reach the **Extract** stage. The certainty, investment, and risk from change are all high, but the rate of growth has reached a plateau.

## Explore

When your startup is in the exploration stage, your imperative is to invest small amounts of time and effort on many different product ideas. The fact that most ideas won't be right drives exploration. Only by iterating and learning can you find product and market fit. By making many small bets, you aim to find a product idea that pays off.

This stage requires discipline. It's easy to overinvest in an idea that you could test with less time and energy. A technologist finds it especially easy to fall into this trap. To make architectural choices that ease exploration, remember that you're exploring. You don't yet know if the current product idea is one that will scale.

From an architecture perspective, choose services that optimize for speed, cost, and options. Use managed services and platforms as a service (PaaS) like Azure App Service to get started quickly without worrying about complex infrastructure. Manage costs by choosing free tiers and smaller instance sizes while you're exploring. Containers support developing with whatever tools make sense for you and give you flexible deployment options for the future.

### Build your first stack

As with your first product version, your first technology stack should be firmly rooted in exploration. That means the technology stack should ease rapid product iteration without wasting effort. You don't want to spend time or effort on infrastructure or architecture that isn't required for answering current questions.

During the exploration phase, you need to optimize for speed, cost, and optionality. Speed is about how fast you can build and move forward with an idea, or move onto the next idea. Cost is how much you're spending to run your infrastructure. Optionality describes how fast you can change directions given the current architecture.

It's important to balance cost, speed, and optionality. Too much focus on cost limits speed and optionality. Too much focus on speed can lead to increased costs and fewer options. Designing for too many options builds complexity, which increases costs and reduces speed.

Consider using our [suggested first technology stack](../../example-scenario/startups/core-startup-stack.yml). This architecture uses PaaS services for ease of implementation, can be started with a minimal scale, and uses container and open source technologies that can easily be deployed on different technology stacks as you mature.

## Expand

Once your startup finds growth through exploration, you shift gears to expansion. You focus on removing any blockages to your product's and company's continued growth. From a technical perspective, you solve infrastructure scale challenges and increase development velocity. The goals are to meet your new customers' needs and advance your product roadmap.

### Extend your architecture

As you iterate on your product, you'll inevitably find areas where your architecture needs extending. You might need to complete long-running tasks in the background, or handle frequent updates from internet-of-things (IoT) devices. You might need to add full-text search or artificial intelligence to your product.

You might need architectural changes to accommodate items on your roadmap. Resist the temptation to make those changes too far in advance. Extensions risk adding complexity to your architecture and infrastructure costs to your balance sheet.

In early startup stages, any architecture extension should be just-in-time. The extension should take only as much time and energy as needed to test the next hypothesis. Be ready to remove extensions to reduce complexity. Look for product features that your customers aren't using as opportunities to simplify your architecture and reduce your infrastructure spending.

Your architecture could be expanded in many ways, such as:

- Enhancing resiliency through a [zone-redundant deployment](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- Enhancing resiliency through a [highly available multi-region deployment](../../web-apps/app-service/architectures/multi-region.yml)
- Enhancing security through a [network hardened technology stack](../../example-scenario/security/hardened-web-app.yml)

## Extract

In the extraction phase, the pace of growth slows as you reach the limits of the market opportunity. Because you expanded through the previous phase, there's now a lot to lose, so you take a more cautious approach. Margin expansion, cost reduction, and efficiency improvements characterize the extraction phase. During the extraction phase, be careful not to compromise the product for the customers you won in the expansion phase.

### Handle growth and mature your stack

Once a product achieves product and market fit, many demands drive its architecture. Increased usage might require infrastructure scaling to handle load. New enterprise compliance requirements might require greater isolation. These changes are common steps in maturing a successful application.

Changes you make to handle growth and add maturity are different from extending architecture. These changes aren't functional requirements, but relate to unlocking scale. Increased scale can come from net new customers, increased usage from existing customers, and customers with higher regulatory requirements.

Resist the temptation to optimize prematurely. Make sure to take growth and maturation steps that can help you continue iterating and improving your product.

## Next steps

- See and deploy an example [Core startup stack architecture](/azure/architecture/example-scenario/startups/core-startup-stack).

## Related resources

- [Best practices in cloud applications](../../best-practices/index-best-practices.md)
- [Ten design principles for Azure applications](../design-principles/index.md)
