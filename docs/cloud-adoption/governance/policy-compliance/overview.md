---
title: "Fusion: What is corporate policy in relation to cloud governance"
description: Explanation of the concept of corporate policy in relation to cloud governance
author: BrianBlanchard
ms.date: 11/27/2018
---

# Fusion: How do corporate policy and compliance impact cloud adoption and governance?

Cloud governance is the product of an ongoing adoption effort over time, as a true lasting tranformation doesn't happen overnight. Attempting to deliver complete cloud governance before addressing key corporate policy changes using a fast agressive method seldom produces the desired results. Instead we recommend an incrimental governance model. 

What is different about our cloud adoption framework is the buying cycle and the impact of that how that cycle can enable authentic transformation. Since there is not a big Capital Expenditure (CapEx) acquisition requirement, engineers can begin experimentation and adoption sooner. In most corporate cultures, elimination of the CapEx barrier to adoption can lead to tighter feedback loops, organic growth, and incremental execution.

The shift to cloud adoption requires a shift in governance. In many organizations, corporate policy transformation allows for improved governance and higher rates of adherence through incremental policy changes and automated enforcement of those changes, powered by newly defined capabilities that you configure with your cloud service provider. 

This article outlines key activities that can help you shape your corporate policies to enable an expanded governance model.

## Define corporate policy to mature cloud governance

In both traditional and incremental governance models, corporate policy helps to create a working definition of governance. Most IT governance actions attempt to leverage technology, in order to monitor, enforce, operate, and automate corporate policies. Cloud governance is built on similar concepts.

![Corporate Governance and Governance Disciplines](../_images/operational-transformation-govern.png)<br>
*Figure 1. Corporate governance and governance disciplines*

The image above demonstrates the interactions between business risk, policy and compliance, and monitor and enforce to create a complete governance strategy. This followed by the five disciplines helps you to to realize a complete governance strategy.

## Review existing policies

In the image above, the governance strategy (risk, policy and compliance, monitor and enforce) starts with recognizing business risks. Understanding how [business risk](understanding-business-risk.md) changes in the cloud is the first step to creating a lasting cloud governance strategy. Working with your business units to gain an accurate [gauge of the business's tolerance for risk](../../business-strategy/risk-tolerance.md), helps you understand what level of risks need to be mitigated. Your understanding of new risks and acceptable tolerance can fuel a [review of existing policies](what-is-a-cloud-policy-review.md), in order to determine the required level of governance that is appropriate for your organization.

> [!TIP]
> If your organization is governed by 3rd-party compliance, one of the biggest business risks to consider may be a risk of adherence to [regulatory compliance](what-is-regulatory-compliance.md). Often times this risk cannot be mitigated, and instead may require a strict adherence. Be sure to understand your 3rd-party compliance requirements before beginning a policy review.

## Incremental governance model

An incremental governance model assumes that it is unacceptable to exceed the [business' tolerance for risk](../../business-strategy/risk-tolerance.md). Instead, it assumes that the role of governance is to accelerate business change, help engineers understand architecture guidelines, and ensure that [business risks](understanding-business-risk.md) are regularly communicated and mitigated. Alternatively, the traditional role of governance can become a barrier to adoption by engineers or by the business as a whole.

With an incremental governance model there can sometimes be a natural friction between teams who build new business solutions and teams who protect the business from risks. However, in this model those two teams can become peers working in increments or sprints. As peers, the cloud governance and cloud adoption team begin to work together to expose, evaluate, and mitigate business risks. This effort can create a natural means of reducing friction and building collaboration between teams.

## Policy minimally viable product (MVP)

The first step in an emerging partnership between your cloud governance and adoption teams is an agreement regarding the policy MVP. Your MVP for cloud governance should acknowledge that business risks are small in the beginning, but will likely grow as your organization adopts more cloud services over time.

For example: For a business that deploys 5 VMs that don't contain any High Business Impact (HBI) data, the business risk is small. And several increments later, when the number reaches 1,000 VMs and the business is starting to move HBI data, the business risk grows.

Policy MVP is an attempt to define a required foundation for policies required to deploy the first "x" VMs or the first x number of applications. Where x is a small yet impactful quantity of the units being adopted. This policy set requires few constraints, but would contain the foundational aspects needed to quickly grow from one increment of work to the next. Through incremental policy development, this governance strategy would grow over time. Through slow subtle shifts, the policy MVP would grow into feature parity with the outputs of the policy review exercise.

## Incremental policy growth

Incremental policy growth is the key mechanism to growing policy and cloud governance overtime. It is also the key requirement to adopting an incremental model to governance. For this model to work well, the governance team must be committed to an ongoing allocation of time at each sprint, in order to evaluate and implement changing governance disciplines.

**Sprint time requirements:** At the beginning of each iteration, the cloud adoption team creates a list of assets to be migrated or adopted in the current increment. The cloud governance team is expected to allow sufficient time to review the list, validate data classifications for assets, evaluate any new risks associated with each asset, update architecture guidelines, and educate the team on the changes. These commitments commonly require 10-30 hours per sprint. It's also expected for this level of involvement to require at least one dedicated employee to manage governance in a large cloud adoption effort.

**Release time requirements:** At the beginning of each release, the cloud adoption and cloud strategy teams should have a prioritized list of applications or workloads to be migrated in the current iteration, along with business change activities. These data points allow the cloud governance team to understand new business risks early. This allows time to align with the business and gauge the business's tolerance for risk.
