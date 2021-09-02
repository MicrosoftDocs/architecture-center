---
title: Architecture for Startups
description: Understand how to approach architecture when you're working in a startup.
author: mootpointer
ms.date: 05/15/2021
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom:
  - fcp
---

# Architecture for Startups

Building a startup is a unique challenge. The core task is to take an innovation and find a place in the market for it as a product or service. This process requires testing multiple assumptions that are built into the innovation. A successful startup must iterate through these assumptions, and grow and scale as their product gains product/market fit. After finding this fit, the startup must scale to meet the demands of the market.

The different stages in the life of a startup mean that as a developer, architect, or CTO (maybe even all three at once) you're responsible for distinct phases of development. These stages require fundamentally different approaches, and as such – different technology choices. Part of your role is to establish which phase your startup is in, and to choose the technologies and architectures that match.

## Stages of Innovation

Kent Beck describes a [three-stage process of innovation](https://medium.com/@kentbeck_7670/fast-slow-in-3x-explore-expand-extract-6d4c94a7539) in the software product world. Those stages are Explore, Expand, and Extract.

<!-- Maybe include a picture – will need guidance on if we can... -->

### Explore

When a startup is in the _Explore_ stage, your imperative is to invest small amounts of time and effort on many different product ideas. Exploration is driven by the fact that most ideas won’t be right. It's only by iterating and learning that you're likely to find product/market fit. By making many small bets, the aim is to find a product idea that pays off a thousand times over.

This stage requires discipline. It's easy to over-invest in an idea that you could test in a way that requires a lot less time and energy. As a technologist, you'll find it especially easy to fall into this trap. Making the right architectural choices to make exploration easier requires you to remember that you're exploring. You don't yet know if the current product idea is the one that will scale.

### Expand

Once your startup finds growth through exploration, you must shift gears to _Expand_. Your effort must be focused on removing any blockages to the continued growth of your product and company. From a technical perspective, your focus is often on solving infrastructure scale challenges, and increasing development velocity. This focus is all so that you can meet the needs of your new customers and progress your product roadmap.

### Extract

Finally, as the pace of growth slows and you reach the limits of the market opportunity, comes extract. As you have expanded through the previous phase, there is now a lot to lose, so a more cautious approach is taken. The _Extract_ phase is characterized by margin expansion, reducing cost, and improving efficiencies. Extraction must be done with care to ensure that you don't compromise the product for the customers you have won through the _Expand_ phase.

## Building Your First Stack

As your startup’s first version of your product, the first technology stack should be firmly rooted in exploration. That means the technology stack must make rapid iteration of the product easier without wasting any unnecessary effort. You don't want to spend time or effort on infrastructure or architecture that isn't required for answering the current question.

Exploration means that you need to optimize for three things: speed, cost, and optionality. Speed is about how fast you can build and move forwards with an idea or move onto the next idea. Cost is how much you're spending to run our infrastructure. Optionality is being able to quickly change directions rapidly using given architecture.

Cost, speed, and optionality must be balanced – too much focus on cost will cost you speed and optionality. Too much focus on speed will often lead to increased costs, and reduced optionality. Designing for too many options builds complexity, increasing costs and reducing speed.

## Extending Your Architecture

As you iterate on your product, there will inevitably find areas where your architecture needs to be extended. You may complete long-running tasks in the background, or handle high-frequency updates coming from IoT devices. You might need to add full-text search, or add artificial intelligence to your product.

You might look at your roadmap and see the need for architectural changes to accommodate items on it. The temptation is to make those architectural changes too far ahead. If you build them too early, you risk adding complexity to your architecture and infrastructure spend to your balance sheet.

In the early stages of a startup, any extension of your architecture should be just-in-time. It should only take as much time and energy as is required to test the next hypothesis. You will also need to be ready to remove extensions to your architecture to remove complexity. Look for product features that aren't used by your customers as opportunities to simplify your architecture and reduce your infrastructure spend.

## Handling Growth and Maturing Your Stack

Once a product has achieved product/market fit, there will be many demands that direct its architecture. Increased usage may require the scaling of infrastructure to handle load. New compliance requirements from enterprise customers may require greater isolation. These changes are all common steps in maturing a successful application.

Changes to handle growth and add maturity are distinct from extending your architecture. They respond less to functional requirements and are more about unlocking scale. This scale could be new customers with higher regulatory requirements, increased usage from existing customers, or net new customers.

There is always a temptation to prematurely optimize. These growth and maturation steps should be taken in ways that help you continue iterating and improving your product.

## Next Steps

- Put the principles of architecture for startups into practice with the [Core Startup Stack](core-startup-stack.md).
