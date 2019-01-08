---
title: "Fusion: How can corporate IT policy become cloud-ready?"
description: Explanation of the concept of corporate policy in relation to cloud governance
author: BrianBlanchard
ms.date: 01/03/2019
---

# Fusion: How closely does legacy corporate IT policy and cloud policy need to integrate? Incremental governance and the policy minimally viable product

The article on [defining policy](define-policy.md) discusses the creation of cloud policy based on identified risks. If your organization already has existing policies governing your on-premises IT environment, these cloud governance policies should complement them where possible. However, the level of policy integration between on-premises and the cloud will vary depending on the maturity of your cloud governance model and the size of your cloud estate. 

Your cloud estate will evolve over time, and your cloud governance processes and policies will also change. When beginning your cloud transformation journey, you may want to focus on creating a policy minimal viable product (MVP) focusing primarily on risks related to your cloud migration, and then expanding policy as your cloud presence grows to better integrate with your overall corporate IT policy. 

## Incremental governance model

An incremental governance model assumes that it is unacceptable to exceed the [business' tolerance for risk](risk-tolerance.md). Instead, it assumes that the role of governance is to accelerate business change, help engineers understand architecture guidelines, and ensure that [business risks](understanding-business-risk.md) are regularly communicated and mitigated. Alternatively, the traditional role of governance can become a barrier to adoption by engineers or by the business as a whole.

With an incremental governance model there can sometimes be a natural friction between teams who build new business solutions and teams who protect the business from risks. However, in this model those two teams can become peers working in increments or sprints. As peers, the cloud governance and cloud adoption team begin to work together to expose, evaluate, and mitigate business risks. This effort can create a natural means of reducing friction and building collaboration between teams.

## Policy minimally viable product (MVP)

The first step in an emerging partnership between your cloud governance and adoption teams is an agreement regarding the policy MVP. Your MVP for cloud governance should acknowledge that business risks are small in the beginning, but will likely grow as your organization adopts more cloud services over time.

For example: For a business that deploys 5 VMs that don't contain any High Business Impact (HBI) data, the business risk is small. And several increments later, when the number reaches 1,000 VMs and the business is starting to move HBI data, the business risk grows.

Policy MVP is an attempt to define a required foundation for policies required to deploy the first "x" VMs or the first x number of applications. Where x is a small yet impactful quantity of the units being adopted. This policy set requires few constraints, but would contain the foundational aspects needed to quickly grow from one increment of work to the next. Through incremental policy development, this governance strategy would grow over time. Through slow subtle shifts, the policy MVP would grow into feature parity with the outputs of the policy review exercise.

## Incremental policy growth

Incremental policy growth is the key mechanism to growing policy and cloud governance overtime. It is also the key requirement to adopting an incremental model to governance. For this model to work well, the governance team must be committed to an ongoing allocation of time at each sprint, in order to evaluate and implement changing governance disciplines.

**Sprint time requirements:** At the beginning of each iteration, the cloud adoption team creates a list of assets to be migrated or adopted in the current increment. The cloud governance team is expected to allow sufficient time to review the list, validate data classifications for assets, evaluate any new risks associated with each asset, update architecture guidelines, and educate the team on the changes. These commitments commonly require 10-30 hours per sprint. It's also expected for this level of involvement to require at least one dedicated employee to manage governance in a large cloud adoption effort.

**Release Time Requirements:** At the beginning of each release, the Cloud Adoption Team and Cloud Strategy team should have a prioritized list of applications or workloads to be migrated in the current iteration, along with any business change activities. Those data points allow the Cloud Governance Team to understand new business risks early. That allows time to align with the business and gauge the business's tolerance for risk.
