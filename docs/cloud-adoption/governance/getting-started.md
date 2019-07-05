---
title: "Getting started with governance"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
description: Getting started with governance
author: BrianBlanchard
ms.date: 01/03/2019
layout: LandingPage
ms.topic: landing-page
---

# Getting started with governance

Governance can be a large, iterative topic. It can be challenging to find a balance between speed and control. Especially during early phases of cloud adoption. The governance guidance in the Cloud Adoption Framework seeks to provide that balance through an agile approach to adoption.

This article provides two options for establishing an initial foundation for governance. This initial foundation ensures that governance constraints can be scaled and expanded, as the adoption plan is implemented and requirements become more clearly defined. By default, the initial foundation assumes an isolate and control position. It also focuses on organization of resources more than governance of resources. This small, light-weight starting point is referred to as a minimally viable product or MVP for governance. The objective of the MVP is to reduce barriers to establishing an initial governance position, and then enable rapid maturation of the solution to address a variety of tangible risks.

## Already using the Cloud Adoption Framework

If you have been following along with the Cloud Adoption Framework, you may already have deployed a governance MVP. Guidance is a core aspect of any operating model. It is present throughout every phase of the cloud adoption lifecycle. As such, the [Cloud Adoption Framework](../index.md) provides guidance that injects governance into activities related to the implementation of your [cloud adoption plan](../plan/index.md). One example of this governance integration would be the use of blueprints to deploy one or more landing zones seen throughout in the [ready](../ready/index.md) guidance. Another example is the guidance regarding [scaling out subscriptions](../ready/considerations/scaling-subscriptions.md). If you have leveraged either of those points of guidance, then the following MVP sections will be little more than a review of your existing deployment decisions. After a quick review, jump ahead to [Mature the initial governance solution and apply best practice controls](./best-practices.md).

## Implement an initial governance foundation (or governance MVP)

The following are two different examples of initial governance foundations (or governance MVPs) to apply a sound foundation for governance to new or existing deployments. Choose the MVP that best aligns with your business needs to get started:

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="./journeys/small-to-medium-enterprise/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Small-to-Medium Enterprise</h3>
                        <p>A governance journey for enterprises that own fewer than five datacenters and manage costs through a central IT or showback model.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./journeys/large-enterprise/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Large Enterprise</h3>
                        <p>A governance journey for enterprises that own more than five datacenters and manage costs across multiple business units.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Next steps

Once a governance foundation is in place, apply appropriate best practices to evolve the solution and protect against tangible risks.

> [!div class="nextstepaction"]
> [Mature the initial governance solution and apply best practice controls](./best-practices.md)