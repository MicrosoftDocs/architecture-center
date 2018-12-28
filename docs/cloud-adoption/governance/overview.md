---
title: "Fusion: Implementing a Cloud Governance Strategy"
description: Overview of governance content within Fusion
author: BrianBlanchard
ms.date: 12/08/2018
layout: LandingPage
ms.topic: landing-page
---

# Fusion: Implementing a Cloud Governance Strategy

<ul  class="panelContent cardsI">
<li style="display: flex; flex-direction: column;">
    <div class="cardSize">
        <div class="cardPadding" style="padding-bottom:10px;">
            <div class="card" style="padding-bottom:10px;">
                <div class="cardText" style="padding-left:0px;">
Any change to business processes or technology platforms introduce risk to the business. Cloud Governance Teams (also known as Cloud Custodians) are tasked with mitigating these risks, with minimal interruption to adoption or innovation efforts.<br/><br/>Fusion's model to Cloud Governance guides these decisions regardless of the chosen cloud platform by focusing on <a href="#corporate-policy">development of corporate policy</a> and <a href="#disciplines-of-cloud-governance">Disciplines of Cloud Governance</a>. <a href="#actionable-design-guides">Actionable design guides</a> demonstrate this model using Azure services.
                </div>
            </div>
        </div>
    </div>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="../_images/operational-transformation-govern-highres.png" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize">
            <div class="cardPadding" style="padding-bottom:10px;">
                <div class="card" style="padding-bottom:10px;">
                    <div class="cardText" style="padding-left:0px;">
<img src="../_images/operational-transformation-govern-highres.png" alt="Visual of the Fusion Model to Cloud Governance: Corporate policy and governance disciplines">
<br>
<i>Figure 1. Visual of Corporate Policy and Five Cloud Governance Disciplines</i>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

Jump to: [Corporate Policy](#corporate-policy) | [Disciplines of Cloud Governance](#disciplines-of-cloud-governance) | [Azure Specific Design Guides](#actionable-design-guides)

## Corporate Policy

Developing corporate policy focuses on identifying and mitigating business risks regardless of the cloud platform. Healthy cloud governance strategy begins with sound corporate policy, the following three step process guides iterative development of such policies.

<ul  class="panelContent cardsF">
<li style="display: flex; flex-direction: column;">
    <a href="./policy-compliance/understanding-business-risk.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/governance/business-risk.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Business Risk</h3>
                        <p>Investigate current cloud adoption plans and data classification to identify risks to the business. Work with the business to balance risk tolerance and mitigation costs.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./policy-compliance/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/governance/corporate-policy.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Policy & Compliance</h3>
                        <p>Evaluate risk tolerance to inform minimally invasive policies which govern cloud adoption and mitigate risks. In some industries, 3rd party compliance impacts initial policy creation.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./monitoring-enforcement/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/governance/policy-enforcement.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Monitoring & Enforcement</h3>
                        <p>The pace of adoption and innovation will naturally create policy violations. Ensure policies include the proper requirements to detect & resolve violations <u>before</u> they are released.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Disciplines of Cloud Governance

Across each cloud provider, there are common cloud governance disciplines that can serve as a guide to help inform policies and align tool chains. These disciplines guide decisions regarding the proper level of automation and enforcement of corporate policy across cloud providers.

<ul  class="panelContent cardsA">
<li style="display: flex; flex-direction: column;">
    <a href="./cost-management/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/governance/cost-management.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Cost Management</h3>
                        <p>Cost is a primary concern for cloud users. Develop policies for cost control for all cloud platforms.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./security-management/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/governance/security-management.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Security Management</h3>
                        <p>Security is a complex & personal topic, unique to each company. Once security requirements are established, cloud governance policies and enforcement applies those requirements across network, data and asset configurations.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./identity-management/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/governance/identity-management.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Identity Management</h3>
                        <p>Isolated identity providers introduce management overhead and increase the risk profile. Policies, which enforce hybrid identity and extend/improve on-prem identity management, mitigate several business risks.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./resource-management/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/governance/resource-management.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Resource Management</h3>
                        <p>Sound governance happens at the resource level. Policy and architecture guidance regarding hierarchy, grouping, tagging, and access to resources is the foundation for all cloud governance.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./configuration-management/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/governance/configuration-management.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Configuration Management</h3>
                        <p>Changes to asset configuration is the most likely point of policy violation. As cloud adoption matures, so should the tools and approaches to inspect configuration during deployment, modification, and outage recovery.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Actionable Design Guides

To demonstrate actionable implementation patterns of Fusion's Cloud Governance model, the following design guides align Corporate Policy and Cloud Governance Disciplines with the governance tools available in Azure.

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
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/multi-cloud.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../_images/governance/multi-cloud.png" class="x-hidden-focus"/>
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

## Additional Guidance

Evaluating current policy through a [cloud policy review](policy-compliance/what-is-a-cloud-policy-review.md) can be a good place to begin the governance journey. [Policy and compliance](policy-compliance/overview.md) can be a useful guide during policy review. To prepare for a policy review, see the [guide to cloud readiness for chief information security officers (CISOs)](how-can-a-ciso-prepare-for-the-cloud.md).