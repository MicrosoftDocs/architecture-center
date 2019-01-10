---
title: "Fusion: Cloud Governance Design Guides for Azure"
description: Overview of governance content within Fusion
author: BrianBlanchard
ms.date: 12/08/2018
layout: LandingPage
ms.topic: landing-page
---

# Fusion: Cloud Governance Design Guides for Azure

The Fusion model guides cloud governance decisions (regardless of the chosen cloud platform) by focusing on <a href="#corporate-policy">development of corporate policy</a> and <a href="#disciplines-of-cloud-governance">Disciplines of Cloud Governance</a>. This series of articles attempts to demonstrate the cloud agnostic principles of cloud governance, based on the governance services in Azure. The following design guides can be expanded and/or customized to integrate additional cloud providers and/or custom policy statements.

## Use Case and Corporate Policy Dependency

Each design guide is based on an accompanying Use Case and Corporate Policy. Within each design guide, is a summary of each and links for further reading. If those two artifacts align with the readers current scenario, the assets are then intended to be modified to meet the specific needs of the Cloud Governance Team.

![This design guide is a specific solution based on a specific use case and corporate policy.](../../_images/governance/design-guide.png)

*This design guide is a specific solution based on a specific use case and corporate policy. This design guide is dependent upon the criteria set in each of those articles.*

> [!CAUTION]
> These articles contain highly opinionated design guides. The opinions in this guide DO NOT fit every situation. Caution should be exercised before implementing this guidance. Prior to implementation of this design guide, the reader should understand each design guide's Use Case and Corporate Policy which influenced the guidance.

<ul  class="panelContent cardsC">
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/future-proof.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../../_images/governance/cloud-native.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Future Proof</h3>
                        <p>Early stage adoption may not warrant and investment in governance. However, this guide will establish a few best practices and policies to future proof adoption and ensure that proper governance can be added later.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/protected-data.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../../_images/governance/protected-data.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Protected Data</h3>
                        <p>Some solutions are dependent upon protected data, like customer information or business secrets. The business risks associated with hosting protected data in the cloud can often be mitigated with proper disciplines.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/enterprise-mvp.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../../_images/governance/enterprise-mvp.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Enterprise MVP</h3>
                        <p>Migrating the first few workloads in an enterprise comes with a few common business risks. The Enterprise MVP design guide provides a scalable starting point to move quickly, but grow into larger governance needs with cloud adoption.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/enterprise-scale.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../../_images/governance/enterprise-scale.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Enterprise @ Scale</h3>
                        <p>As additional solutions are deployed to the cloud, business risks grow. When enterprises reach scale across cloud deployments, governance requirements scale. This design guide builds on Enterprise MVP to meet these more complex needs.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/enterprise-enforcement.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../../_images/governance/enterprise-enforcement.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Enterprise Enforcement</h3>
                        <p>Multiple teams deploying to multiple clouds will naturally create policy violations. In complex environments, with thousands of applications and hundreds of thousands of VMs, automated policy enforcement is required.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/multi-cloud.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../../_images/governance/multi-cloud.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Multi-Cloud Governance</h3>
                        <p>Industry analysts are predicting that multi-cloud solutions are an inevitable future. This design guide establishes current approaches to prepare for a multi-cloud landscape.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Next steps

[Future Proofing](./future-proof.md) is a suggested pre-cursor to cloud governance. Ensuring deployments have a consistent set of deployment standards will reduce friction when implementing more advance governance.

> [!div class="nextstepaction"]
> [Align deployments to a stable foundation](./future-proof.md)