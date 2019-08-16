---
title: "Resource Consistency discipline overview"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Resource Consistency discipline overview
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: landing-page
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
layout: LandingPage
---

# Resource Consistency discipline overview

Resource Consistency is one of the [Five Disciplines of Cloud Governance](../governance-disciplines.md) within the [Cloud Adoption Framework governance model](../index.md). This discipline focuses on ways of establishing policies related to the operational management of an environment, application, or workload. IT Operations teams often provide monitoring of applications, workload, and asset performance. They also commonly execute the tasks required to meet scale demands, remediate performance Service Level Agreement (SLA) violations, and proactively avoid performance SLA violations through automated remediation. Within the Five Disciplines of Cloud Governance, Resource Consistency is a discipline that ensures resources are consistently configured in such a way that they can be discoverable by IT operations, are included in recovery solutions, and can be onboarded into repeatable operations processes.

> [!NOTE]
> Resource Consistency governance does not replace the existing IT teams, processes, and procedures that allow your organization to effectively manage cloud-based resources. The primary purpose of this discipline is to identify potential business risks and provide risk-mitigation guidance to the IT staff that are responsible for managing your resources in the cloud. As you develop governance policies and processes make sure to involve relevant IT teams in your planning and review processes.

This section of the Cloud Adoption Framework outlines how to develop a Resource Consistency discipline as part of your cloud governance strategy. The primary audience for this guidance is your organization's cloud architects and other members of your cloud governance team. However, the decisions, policies, and processes that emerge from this discipline should involve engagement and discussions with relevant members of the IT teams responsible for implementing and managing your organization's Resource Consistency solutions.

If your organization lacks in-house expertise in Resource Consistency strategies, consider engaging external consultants as a part of this discipline. Also consider engaging [Microsoft Consulting Services](https://www.microsoft.com/enterprise/services), the [Microsoft FastTrack](https://azure.microsoft.com/programs/azure-fasttrack) cloud adoption service, or other external cloud adoption experts for discussing how best to organize, track, and optimize your cloud-based assets.

## Policy statements

Actionable policy statements and the resulting architecture requirements serve as the foundation of a Resource Consistency discipline. To see policy statement samples, see the article on [Resource Consistency Policy Statements](./policy-statements.md). These samples can serve as a starting point for your organization's governance policies.

> [!CAUTION]
> The sample policies come from common customer experiences. To better align these policies to specific cloud governance needs, execute the following steps to create policy statements that meet your unique business needs.

## Developing Resource Consistency governance policy statements

The following six steps offer examples and potential options to consider when developing Resource Consistency governance. Use each step as a starting point for discussions within your cloud governance team and with affected business, and IT teams across your organization to establish the policies and processes needed to manage Resource Consistency risks.

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
                        <h3>Resource Consistency Template</h3>
                        <p class="x-hidden-focus">Download the template for documenting a Resource Consistency discipline</p>
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
                        <p class="x-hidden-focus">Understand the motives and risks commonly associated with the Resource Consistency discipline.</p>
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
                        <p class="x-hidden-focus">Indicators to understand if it is the right time to invest in the Resource Consistency discipline.</p>
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
                        <p class="x-hidden-focus">Suggested processes for supporting policy compliance in the Resource Consistency discipline.</p>
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
                        <p class="x-hidden-focus">Azure services that can be implemented to support the Resource Consistency discipline.</p>
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
