---
title: Managing foundational model lifecycles in your generative AI application infrastructure
description: Learn how you should manage new model versions and retired model versions in your generative AI application infrastructure.
author: robbagby
ms.author: robbag
ms.date: 04/18/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.custom: arb-aiml
products:
  - azure-machine-learning
  - azure-ai-foundry
categories:
  - ai-machine-learning
---

# Managing foundational model lifecycles

There are different reasons to update the foundational model you use in your generative AI solution and the scope of your model update can vary between upgrading for a slight revision change to choosing a different model altogether. Some reasons to update models are voluntary, while others are required. For example, depending upon the model deployment option you choose in Azure, MaaS, MaaP, or self-hosting, you may be required to update to new model versions, as old versions are retired.

This article will touch on some of the reasons for updating to new models or model versions and will detail the architectural choices you should consider to make sure your solution supports these inevitable model updates.

## Model update scopes

The scope of the model update in your generative AI solution can vary drastically, from upgrading for a minor revision change to choosing a new model altogether. There are a variety of reasons you may choose to upgrade the model in your solution. The following table lists different update scopes along with an example and some of the reasons you might choose to make a model upgrade of this scope:

| Scope of change | Example | Reason for updating model |
| --- | --- | --- |
| Minor version update | Moving from GPT-3.5-Turbo to GPT-3.5-Turbo-0125 | A small, incremental change or improvement within the same major version |
| Intermediate version update | Moving from GPT-3 to GPT-3.5 | A significant but not major leap, often involving enhancements and optimizations |
| Major version update | Moving from GPT-3 to GPT-4 | A substantial upgrade with significant new features and improvements |
| Variant update | Moving from GPT-4 to GPT-4-Turbo or GPT-4o-mini | A variation of the same major version, often optimized for specific attributes like cost or speed |
| Generational version update | Moving from GPT-4 to GPT-4o | A new generation of the model, typically introducing new features and capabilities |
| Model change (general) | Moving from GPT-4 to DeepSeek | A change to a different general model for speed, cost, or model performance for your solution |
| Model change (specialized) | Moving from GPT-4 to Prizedata | A change to a model that is trained on a specific domain to achieve better model performance for your solution |
| Deployment option change | Moving from Llama-1 hosted as managed online endpoint in Azure AI Foundry to self-hosting Llama-1 on a virtual machine | Changing your hosting model to have more/less control and more/less hosting responsibility |

