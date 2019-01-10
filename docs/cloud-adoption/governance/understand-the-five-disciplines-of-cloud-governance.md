---
title: "Fusion: Understand the five disciplines of cloud governance"
description: Explanation of Evolving Governance over time
author: BrianBlanchard
ms.date: 01/03/2019
---

# Fusion: Understand the five disciplines of cloud governance

As described in the Incremental Model to Cloud Governance, the Fusion model to Cloud Governance is represented in the image below. This image serves as a framework for the end state of cloud governance. The current and evolving state would see varying degrees of maturity across the five disciplines, based on tangible business risks.

![Fusion model to Cloud Governance](../_images/operational-transformation-govern-highres.png)

The bottom half of this diagram is referred to as the Five Disciplines of Cloud Governance. Defining corporate policy establishes a strategy to mitigate tangible business risks. The five disciplines guide implementation of the tools and processes that actually deliver the desired risk mitigation. 

## Five Disciplines explained

Microsoft actively solicits customer feedback and studies adoption experiences across Azure, AWS, GCP, and other cloud platforms to understand what our customers are experiencing. When discussing risks and approaches to mitigate those risks, the following five disciplines common arose as concerns. To address those concerns for Azure customers, multi-cloud customers, or even customers of other cloud platforms, we designed the five disciplines as a framework for mitigating common risks.

The objective of each discipline is not to implement solutions that address the need mentioned in the title. Instead, it is to implement a governance layer to ensure that corporate policies are mitigating risk across each of these vital functions. The actual functions of security, identity, configuration, and resource/operations... still need to be filled by engineers outside of the Cloud Governance Team. Cost Management is the exception. Our studies suggest that the discipline of Cost Management is often fulfilled as a function of Cloud Governance Team under the guidance of the Cloud Strategy Team.

## Cost Management

Evaluate & monitor costs, limit IT spend, scale to meet need,  create cost  accountability

## Security Management

Protect network, assets, and data. Identify & remediate security incidents. Enforce common standards for protection.

## Resource Management

Size, optimize, & evolve assets. Monitor health, limits, & performance requirements. Remediate any deviations

## Identity Management

Define, create, manage, synchronize and monitor user accounts, as well as, roles & access

## Configuration Management

Deploy, update, & optimize digital assets. Manage the configuration of assets & deployed code including devops

## Apply the theory

After choosing a design template, there will likely be modifications. Either immediately to implement the template, or overtime as risks evolve.
In either case, the need to modify the template identifies a policy statement that needs to be changed or added. Starting with the corporate policy, will ensure clarity and support for the required governance changes.

As corporate policies change, they will change the implementations of one or more of the cloud governance disciplines. It is the duty of the Cloud Governance Team to educate development teams on changes to policy. Update design guidance to match policy. Modify scripted deployments to align with policy. In mature states of cloud governance to execute automated tools that apply the new policies across all environments. Each section of the content that focuses on a specific discipline will share examples of corporate policy, processes, and implementation as they relate to the chosen discipline

## Next steps

With a firm grounding in theory, it's time to choose a design template that aligns with current tangible business risks and grow overtime to reach your future state objectives.
[Choose a Governance Design Template](./choose-a-design-template.md)
> [!div class="nextstepaction"]
> [Choose a Governance Design Template](./choose-a-design-template.md)