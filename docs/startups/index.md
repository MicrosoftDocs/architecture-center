---
title: Architecture for Startups
description: Understand how to approach architecture when you are working in a startup.
author: mootpointer
ms.date: 05/15/2021
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom:
  - fcp
---

# Architecture for Startups

A startup is a unique business – its purpose is to take an as yet unproven product and test it in market. This is done by actively iterating on it until you reach a point of product/market fit, then scaling the product and the business to take full advantage of the market opportunity.

This approach means that as a developer, architect, or CTO (maybe even all three at once) you are responsible for distinct phases of development, which require fundamentally different approaches, and as such – different technology choices. Part of your role is to establish which stage of product development your startup is in, and to choose the technologies and architectures which match that stage.

## Stages of Innovation

Kent Beck describes a [three-stage process of innovation](https://medium.com/@kentbeck_7670/fast-slow-in-3x-explore-expand-extract-6d4c94a7539) in the software product world. Those stages are Explore, Expand, and Extract.

### Explore

When a startup is in the explore stage, the imperative to invest small amounts of time and effort on numerous different product ideas. This exploration is driven by the knowledge that most ideas won’t result in much than break-even (and most will be worse). By making many small bets, the aim is to find one that pays of a thousand times over, and will lead to massive growth.

### Expand

Once a startup finds growth through exploration, you must shift gears to expand. This means effort is focused on doing whatever you can to unblock the continued growth of our product and company. From a technical perspective that means a focus on overcoming whatever is preventing you from fully taking advantage of the opportunity you have discovered. This is often manifest in solving infrastructure scaling challenges, and in increasing development velocity so that you can meet the needs of your new customers and progress your product roadmap.

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
