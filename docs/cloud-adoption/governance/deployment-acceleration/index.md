---
title: "Deployment Acceleration discipline overview"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of Deployment Acceleration in relation to cloud governance.
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: landing-page
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
layout: LandingPage
---

# Deployment Acceleration discipline overview

Deployment Acceleration is one of the [Five Disciplines of Cloud Governance](../governance-disciplines.md) within the [Cloud Adoption Framework governance model](../index.md). This discipline focuses on ways of establishing policies to govern asset configuration or deployment. Within the Five Disciplines of Cloud Governance, Deployment Acceleration includes deployment, configuration alignment, and script reusability. This could be through manual activities or fully automated DevOps activities. In either case, the policies would remain largely the same. As this discipline matures, the cloud governance team can serve as a partner in DevOps and deployment strategies by accelerating deployments and removing barriers to cloud adoption, through the application of reusable assets.

This article outlines the Deployment Acceleration process that a company experiences during the planning, building, adopting, and operating phases of implementing a cloud solution. It's impossible for any one document to account for all of the requirements of any business. As such, each section of this article outlines suggested minimum and potential activities. The objective of these activities is to help you build a [policy MVP](../policy-compliance/index.md#minimum-viable-product-mvp-for-policy), but establish a framework for [Incremental Policy](../policy-compliance/index.md#incremental-policy-growth) improvement. The cloud governance team should decide how much to invest in these activities to improve the Deployment Acceleration position.

> [!NOTE]
> The Deployment Acceleration discipline does not replace the existing IT teams, processes, and procedures that allow your organization to effectively deploy and configure cloud-based resources. The primary purpose of this discipline is to identify potential business risks and provide risk-mitigation guidance to the IT staff that are responsible for managing your resources in the cloud. As you develop governance policies and processes make sure to involve relevant IT teams in your planning and review processes.

The primary audience for this guidance is your organization's cloud architects and other members of your cloud governance team. However, the decisions, policies, and processes that emerge from this discipline should involve engagement and discussions with relevant members of your business and IT teams, especially those leaders responsible for deploying and configuring cloud-based workloads.

## Policy statements

Actionable policy statements and the resulting architecture requirements serve as the foundation of a Deployment Acceleration discipline. To see policy statement samples, see the article on [Deployment Acceleration Policy Statements](./policy-statements.md). These samples can serve as a starting point for your organization's governance policies.

> [!CAUTION]
> The sample policies come from common customer experiences. To better align these policies to specific cloud governance needs, execute the following steps to create policy statements that meet your unique business needs.

## Developing Deployment Acceleration governance policy statements

The following six steps will help you define governance policies to control deployment and configuration of resources in your cloud environment.

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsE">
<li style="display: flex; flex-direction: column;">
    <a href="./template.md">
        <div class="cardSize">
            <div class="cardPadding" >
                <div class="card" >
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../_images/governance/process-template.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText" style="padding-left:0px;">
                        <h3>Deployment Acceleration Template</h3>
                        <p class="x-hidden-focus">Download the template for documenting a Deployment Acceleration discipline</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li><li style="display: flex; flex-direction: column;">
    <a href="./business-risks.md">
        <div class="cardSize">
            <div class="cardPadding" >
                <div class="card" >
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../_images/governance/process-risks.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText" style="padding-left:0px;">
                        <h3>Business Risks</h3>
                        <p class="x-hidden-focus">Understand the motives and risks commonly associated with the Deployment Acceleration discipline.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./metrics-tolerance.md">
        <div class="cardSize">
            <div class="cardPadding" >
                <div class="card" >
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../_images/governance/process-metrics.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText" style="padding-left:0px;">
                        <h3>Indicators and Metrics</h3>
                        <p class="x-hidden-focus">Indicators to understand if it is the right time to invest in the Deployment Acceleration discipline.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./compliance-processes.md">
        <div class="cardSize">
            <div class="cardPadding" >
                <div class="card" >
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../_images/governance/process-enforce.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText" style="padding-left:0px;">
                        <h3>Policy adherence processes</h3>
                        <p class="x-hidden-focus">Suggested processes for supporting policy compliance in the Deployment Acceleration discipline.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./discipline-improvement.md">
        <div class="cardSize">
            <div class="cardPadding" >
                <div class="card" >
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../_images/governance/process-maturity.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText" style="padding-left:0px;">
                        <h3>Maturity</h3>
                        <p class="x-hidden-focus">Aligning Cloud Management maturity with phases of cloud adoption.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./toolchain.md">
        <div class="cardSize">
            <div class="cardPadding" >
                <div class="card" >
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../_images/governance/process-toolchain.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText" style="padding-left:0px;">
                        <h3>Toolchain</h3>
                        <p class="x-hidden-focus">Azure services that can be implemented to support the Deployment Acceleration discipline.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Next steps

Get started by evaluating [business risks](./business-risks.md) in a specific environment.

> [!div class="nextstepaction"]
> [Understand business risks](./business-risks.md)

<!-- markdownlint-enable MD033 -->
