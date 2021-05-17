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

A startup is a unique business – its purpose is to take an unproven product and test it in market. To test it, you take your product idea and active iterate on it until you reach a point of product/market fit. Once you achieve that fit, you then scale that product and the business to take full advantage of the market opportunity.

This staged approach means that as a developer, architect, or CTO (maybe even all three at once) you're responsible for distinct phases of development. These stages require fundamentally different approaches, and as such – different technology choices. Part of your role is to establish which phase your startup is in, and to choose the technologies and architectures that match.

## Stages of Innovation

Kent Beck describes a [three-stage process of innovation](https://medium.com/@kentbeck_7670/fast-slow-in-3x-explore-expand-extract-6d4c94a7539) in the software product world. Those stages are Explore, Expand, and Extract.

### Explore

When a startup is in the explore stage, your imperative is to invest small amounts of time and effort on many different product ideas. Exploration is driven by the fact that most ideas won’t be right. It's only by iterating and learning that you're likely to find product/market fit. By making many small bets, the aim is to find a product idea that pays off a thousand times over.

This stage requires discipline. It's easy to over-invest in an idea that you could test in a way that requires a lot less time and energy. As a technologist, you'll find this to be especially true. Making the right architectural choices to make exploration easier requires you to remember that you're exploring. You don't yet know if the current product idea is the one that will scale.

### Expand

Once your startup finds growth through exploration, you must shift gears to expand. Your effort must be focused on removing any blockages to the continued growth of your product and company. From a technical perspective, your focus is often on solving infrastructure scale challenges, and increasing development velocity. This focus is all so that you can meet the needs of your new customers and progress your product roadmap.

### Extract

Finally, as the pace of growth slows and you reach the limits of the market opportunity, comes extract. At this point, there is a lot to lose, so a more cautious approach is taken. This phase is characterized by margin expansion, reducing cost, and improving efficiencies. All these must be executed with care to ensure that the captured market is not lost.

## Building Your First Stack

As a startup’s first embodiment of their product, the first technology stack should be firmly rooted in exploration. That means promoting the stack must facilitate rapid iteration of the product without wasting any unnecessary effort investing in infrastructure or architecture that is not required for answering the current question.

Exploration means that you need to optimize for three things: speed, cost, and optionality. Speed is about how fast you can build and move forwards with an idea or move onto the next idea. Cost is how much you're spending to run our infrastructure. Optionality centers around being able to quickly changes directions rapidly using given architecture, allowing you to capitalize if you land on an idea that is successful and will lead to growth.

These three factors must be balanced – focusing too much on cost will cost you speed and optionality. Focusing too much on speed will often lead to increased costs, and reduced optionality. Designing for too many options builds complexity, increasing costs and reducing speed.

## Extending Your Architecture

TODO

## Handling Growth and Maturing Your Stack

TODO

## Next Steps

TODO
