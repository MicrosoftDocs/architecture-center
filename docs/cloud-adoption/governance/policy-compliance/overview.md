---
title: "Fusion: What is corporate policy in relation to cloud governance"
description: Explanation of the concept of corporate policy in relation to cloud governance
author: BrianBlanchard
ms.date: 10/10/2018
---

# Fusion: How do corporate policy and compliance impact cloud adoption and cloud governance?

Technical and business transformations don't happen overnight. They are the product of effort over time. Cloud Adoption, like all other transformations, are no exception. Nor is Cloud Governance. Attempting to deliver either in a big bang push, seldom produces the desired results.

What is different about Cloud Adoption, is the buying cycle and the impact of that buying cycle. Since there is no big Capital Expenditure (CapEx) acquisition requirement, engineers can be begin experimenting and adoption sooner. In most corporate cultures, elimination of the CapEx barrier to adoption, leads to tighter feedback loops, organic growth, and incremental execution.

The shift to incremental Cloud Adoption, also allows for a shift in Governance. In some organizations, it can allow for improved governance and higher rates of adherence through incremental governance and automated enforcement, both powered by new capabilities found in the cloud. This article outlines a few key activities that can shape policy in a way that enables an incremental governance model.

## Defining Corporate Policy to mature Cloud Governance

In traditional governance and incremental governance, Corporate Policy creates the working definition of governance. Most IT Governance actions are an attempt to leverage technology to monitor, enforce, operate, and automate those Corporate Policies. Cloud Governance is built on similar concepts.

![Corporate Governance and Governance Disciplines](../../_images/operational-transformation-govern.png)
*Figure 1. Corporate Governance and Governance Disciplines*

The image above demonstrates the interactions between Business Risk, Policy & Compliance, and Monitor & Enforce to create a Governance Strategy. Followed by the Five Disciplines of Cloud Governance to realize that strategy.

## Reviewing Existing Policies

In the image above, the governance strategy (Risk, Policy & Compliance, Monitor & Enforce) starts with Business Risk. Understanding how [business risk](understanding-business-risk.md) changes in the cloud is the first step to creating a cloud governance strategy. Working with the business to gain an accurate [gauge of the business's tolerance for risk](../../business-strategy/risk-tolerance.md), will help understand what level of risks must be mitigated. The understanding of new risks and acceptable tolerance can fuel a [review of existing policies](what-is-a-cloud-policy-review.md), to determine the required level of governance.

> [!TIP]
> If the organization is governed by 3rd party compliance, one of the biggest business risks to be considered may be a risk of adherence to [regulatory compliance](what-is-regulatory-compliance.md). Often times, that risk can't be mitigated, but instead may require strict adherence. Understand the 3rd party compliance requirements before beginning a policy review.

## Incremental Governance model

An incremental model to governance assumes that it is unacceptable to exceed the [business' tolerance for risk](../../business-strategy/risk-tolerance.md). It also assumes that the role of governance is to accelerate business change, help engineers understand architecture guidelines, and ensure that [business risks](understanding-business-risk.md) are communicated and mitigated. The latter of these assumptions is at odds with the traditional role of governance, which can be seen as barrier to adoption by engineers or the business.

In an incremental model to governance, there is still a nature friction between teams who build new business solutions and teams who protect the business from risks. However, in this model, those two teams are peers working withing each increment or sprint. As peers the Cloud Governance Team and Cloud Adoption Team work together to expose, evaluate, and mitigate business risks. Such tight teamwork creates natural means of reducing the friction and building on the friction that remains.

## Policy MVP (Minimally Viable Product)

The first step in a tight partnership between the Cloud Governance Team and Cloud Adoption Team, is an agreement regarding the Policy MVP. The Minimally Viable Product or MVP for governance acknowledges that risks are small in the beginning and grow as more cloud services are adopted.

For instance: When deploying 5 VMs that don't contain any High Business Impact (HBI) data, the business risk is small. Several increments later, when the number is reached 1,000 VMs and the business is starting to move HBI data, the business risk grows.

Policy MVP is an attempt to define a required foundation for policies required to deploy the first X VMs or the first X number of applications. Where X is a small, yet impactful quantity of the units being adopted. This policy set would require few constraints, but would contain the foundational aspects needed to quickly grow from one increment of work to the next. Through incremental policy development, the governance strategy will grow over time. Through slow, subtle shifts, the Policy MVP will grow into feature parity with the outputs of the Policy Review exercise.

## Incremental Policy

Incremental Policy growth is the key mechanism to growing policy and governance overtime. It is also the key requirement to adopting an incremental model to governance. For this model to work well, the governance team must be committed to an on-going allocation of time at each sprint, to evaluate and implement governance disciplines.

**Sprint Time Requirements:** At the beginning of each iteration, the Cloud Adoption Team should have a list of assets to be migrated or adopted in the current increment of effort. The Cloud Governance Team is expected to have sufficient time to review that list, validate data classifications for those assets, evaluate any new risks associated with the asset, update architecture guidelines, and educate the team on the changes. These commitments commonly require a 10-30 hours time commitment per sprint. Its also not heard of for this level of involvement to require a dedicated employee to manage governance in a large cloud adoption effort.

**Release Time Requirements:** At the beginning of each release, the Cloud Adoption Team and Cloud Strategy team should have a prioritized list of applications or workloads to be migrated in the current iteration, along with any business change activities. Those data points allow the Cloud Governance Team to understand new business risks early. That allows time to align with the business and gauge the business's tolerance for risk.
