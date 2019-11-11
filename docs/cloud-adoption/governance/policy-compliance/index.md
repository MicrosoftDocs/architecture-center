---
title: "Prepare corporate IT policy for the cloud"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of the concept of corporate policy in relation to cloud governance.
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

<!-- markdownlint-disable MD026 -->

# Prepare corporate IT policy for the cloud

Cloud governance is the product of an ongoing adoption effort over time, as a true lasting transformation doesn't happen overnight. Attempting to deliver complete cloud governance before addressing key corporate policy changes using a fast aggressive method seldom produces the desired results. Instead we recommend an incremental approach.

What is different about our Cloud Adoption Framework is the purchasing cycle and how it can enable authentic transformation. Since there is not a big capital expenditure acquisition requirement, engineers can begin experimentation and adoption sooner. In most corporate cultures, elimination of the capital expense barrier to adoption can lead to tighter feedback loops, organic growth, and incremental execution.

The shift to cloud adoption requires a shift in governance. In many organizations, corporate policy transformation allows for improved governance and higher rates of adherence through incremental policy changes and automated enforcement of those changes, powered by newly defined capabilities that you configure with your cloud service provider.

This article outlines key activities that can help you shape your corporate policies to enable an expanded governance model.

## Define corporate policy to mature cloud governance

In traditional governance and incremental governance, corporate policy creates the working definition of governance. Most IT governance actions seek to implement technology to monitor, enforce, operate, and automate those corporate policies. Cloud governance is built on similar concepts.

![Corporate governance and governance disciplines](../../_images/operational-transformation-govern-highres.png)

*Figure 1 - Corporate governance and governance disciplines.*

The image above demonstrates the interactions between business risk, policy and compliance, and monitor and enforce to create a governance strategy. Followed by the Five Disciplines of Cloud Governance to realize your strategy.

## Review existing policies

In the image above, the governance strategy (risk, policy and compliance, monitor and enforce) starts with recognizing business risks. Understanding how [business risk](understanding-business-risk.md) changes in the cloud is the first step to creating a lasting cloud governance strategy. Working with your business units to gain an accurate [gauge of the business's tolerance for risk](risk-tolerance.md), helps you understand what level of risks need to be remediated. Your understanding of new risks and acceptable tolerance can fuel a [review of existing policies](what-is-a-cloud-policy-review.md), in order to determine the required level of governance that is appropriate for your organization.

> [!TIP]
> If your organization is governed by third-party compliance, one of the biggest business risks to consider may be a risk of adherence to [regulatory compliance](what-is-regulatory-compliance.md). This risk often cannot be remediated, and instead may require a strict adherence. Be sure to understand your third-party compliance requirements before beginning a policy review.

## An incremental approach to cloud governance

An incremental approach to cloud governance assumes that it is unacceptable to exceed the [business' tolerance for risk](risk-tolerance.md). Instead, it assumes that the role of governance is to accelerate business change, help engineers understand architecture guidelines, and ensure that [business risks](understanding-business-risk.md) are regularly communicated and remediated. Alternatively, the traditional role of governance can become a barrier to adoption by engineers or by the business as a whole.

With an incremental approach to cloud governance, there is sometimes a natural friction between teams building new business solutions and teams protecting the business from risks. However, in this model those two teams can become peers working in increments or sprints. As peers, the cloud governance team and the cloud adoption teams begin to work together to expose, evaluate, and remediate business risks. This effort can create a natural means of reducing friction and building collaboration between teams.

## Minimum viable product (MVP) for policy

The first step in an emerging partnership between your cloud governance and adoption teams is an agreement regarding the policy MVP. Your MVP for cloud governance should acknowledge that business risks are small in the beginning, but will likely grow as your organization adopts more cloud services over time.

For example, the business risk is small for a business deploying five VMs that don't contain any high business impact (HBI) data. Later in the cloud adoption process, when the number reaches 1,000 VMs and the business is starting to move HBI data, the business risk grows.

Policy MVP attempts to define a required foundation for policies needed to deploy the first _x_ VMs or the first _x_ number of applications, where _x_ is a small yet meaningful quantity of the units being adopted. This policy set requires few constraints, but would contain the foundational aspects needed to quickly grow from one incremental cloud adoption effort to the next. Through incremental policy development, this governance strategy would grow over time. Through slow subtle shifts, the policy MVP would grow into feature parity with the outputs of the policy review exercise.

## Incremental policy growth

Incremental policy growth is the key mechanism to growing policy and cloud governance over time. It is also the key requirement to adopting an incremental model to governance. For this model to work well, the governance team must be committed to an ongoing allocation of time at each sprint, in order to evaluate and implement changing governance disciplines.

**Sprint time requirements:** At the beginning of each iteration, each cloud adoption team creates a list of assets to be migrated or adopted in the current increment. The cloud governance team is expected to allow sufficient time to review the list, validate data classifications for assets, evaluate any new risks associated with each asset, update architecture guidelines, and educate the team on the changes. These commitments commonly require 10-30 hours per sprint. It's also expected for this level of involvement to require at least one dedicated employee to manage governance in a large cloud adoption effort.

**Release time requirements:** At the beginning of each release, the cloud adoption teams and the cloud strategy team should prioritize a list of applications or workloads to be migrated in the current iteration, along with any business change activities. Those data points allow the cloud governance team to understand new business risks early. That allows time to align with the business and gauge the business's tolerance for risk.

## Next steps

Effective cloud governance strategy begins with understanding business risk.

> [!div class="nextstepaction"]
> [Understand business risk](./understanding-business-risk.md)
