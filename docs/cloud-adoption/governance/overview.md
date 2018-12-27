---
title: "Fusion: What is cloud governance?"
description: Overview of governance content for Azure Fusion
author: BrianBlanchard
ms.date: 12/08/2018
layout: LandingPage
ms.topic: landing-page
---

# Fusion: What is cloud governance?

Any change to technology platforms or business processes introduces risks to the business. The Fusion model to cloud governance guides architects through the processes of identifying risks, understanding tolerance for risk, and maturing cloud governance disciplines in alignment with cloud adoption. 

![Corporate policy and governance disciplines](../_images/operational-transformation-govern.png)<br>
*Figure 1. Corporate policy and five governance disciplines*

Fusion cloud governance starts with [Corporate Policy](#corporate-policy), which guides decisions regarding Business Risks, Policy Definition, and Enforcement. The model then builds on corporate policy by guiding decisions regarding the [disciplines of Cloud Governance](#disciplines-of-cloud-governance). [Actionable design guides](#actionable-design-guides) provide a number of specific customer scenarios, to guide implementation of the model in a relatable context.

Jump to Cloud Governance Guidance: [Design Guides](#actionable-design-guides) | [Corporate Policy](#corporate-policy) | [Disciplines of Cloud Governance](#disciplines-of-cloud-governance)

## Actionable Design Guides

To demonstrate actionable implementation patterns of the Fusion Cloud Governance model, this section provides design guides based on the governance tools available in Azure.

However, in a multi-cloud/hybrid-cloud world, governance decisions are bigger than a single cloud provider. To avoid vendor lock-in and guide holistic decision making, each design guide is supported by a decision process that can be applied to any cloud platform. See [Corporate Policy](#corporate-policy) and [Disciplines of Cloud Governance](#disciplines-of-cloud-governance), for cloud governance decision guidance that must be made for any cloud platform.

<ul  class="panelContent cardsC">
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/cloud-native.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../_images/governance/cloud-native.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Cloud Native</h3>
                        <p>Cloud native applications leverage the native governance and enforcement capabilities of a cloud provider. This reduces the amount of governance effort required, when compared to similar solutions that include PaaS, IaaS, and multi-cloud architectures.</p>
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
                            <img src="../_images/governance/protected-data.png" class="x-hidden-focus"/>
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
                            <img src="../_images/governance/enterprise-mvp.png" class="x-hidden-focus"/>
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
                            <img src="../_images/governance/enterprise-scale.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Enterprise @ scale</h3>
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
                            <img src="../_images/governance/enterprise-enforcement.png" class="x-hidden-focus"/>
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
</ul>

## Corporate Policy

 The cloud offers a variety of management tools. You can use these tools to automate and define action-based policies. A healthy governance strategy starts with an [understanding of business risks](policy-compliance/understanding-business-risk.md). Then you enact [policies](policy-compliance/overview.md) to create barriers that help mitigate those risks. Once policy is established, [monitoring and enforcement](monitoring-enforcement/overview.md) provides additional guidelines that define how policy is enforced and what happens when a deviation to policy occurs.

In some industry verticals, [regulatory compliance](policy-compliance/what-is-regulatory-compliance.md) supercedes corporate policy, and therefore requires a set of stricter guidelines. These enforceable yet flexible policies are the basis of any mature governance strategy. When policies accurately reflect tangible risks and the business' tolerance for risk, and not technical dogma, you can more easily adapt policy and resulting strategy to align with the cloud or any other technical deployment.

## Disciplines of Cloud Governance

The Fusion cloud governance model focuses on the five disciplines of cloud governance, and each implements a different aspect of corporate policies to support safe cloud adoption. These disciplines include [cost management](cost-management/overview.md), [security management](security-management/overview.md), [identity management](identity-management/overview.md), [resource management](resource-management/overview.md), and [configuration management](configuration-management/overview.md). When policy focuses on risk and tolerance, the management disciplines can extend policy by applying proper risk mitigation to the chosen [deployment model](../getting-started/cloud-deployment-models.md).

If a design guide mitigates some of the identified business risks, but doesn't fit perfectly, the discipline descriptions can help make decisions that better align implementation.

## Next steps

The first step to taking action for any governance strategy is conducting a [policy review](policy-compliance/what-is-a-cloud-policy-review.md). [Policy and compliance](policy-compliance/overview.md) is a useful guide for you to reference during policy review. To prepare for a policy review, see the [guide to cloud readiness for chief information security officers (CISOs)](how-can-a-ciso-prepare-for-the-cloud.md).

> [!div class="nextstepaction"]
> [Prepare for a policy review](policy-compliance/what-is-a-cloud-policy-review.md)
