---
title: "Fusion: Implementing a cloud governance strategy"
description: Overview of governance content within Fusion
author: BrianBlanchard
ms.date: 1/3/2019
layout: LandingPage
ms.topic: landing-page
---

# Fusion: Implementing a cloud governance strategy

<ul  class="panelContent cardsI">
<li style="display: flex; flex-direction: column;">
    <div class="cardSize">
        <div class="cardPadding" style="padding-bottom:10px;">
            <div class="card" style="padding-bottom:10px;">
                <div class="cardText" style="padding-left:0px;">
Any change to business processes or technology platforms introduces risk to the business. Cloud governance teams (also known as cloud custodians) are tasked with mitigating these risks with minimal interruption to adoption or innovation efforts.<br/><br/>Fusion's model for cloud governance guides decisions (regardless of the chosen cloud platform) by focusing on <a href="#corporate-policy">development of corporate policy</a> and <a href="#disciplines-of-cloud-governance">Disciplines of cloud governance</a>. <a href="#actionable-design-guides">Actionable design guides</a> demonstrate this model using Azure services.<BR/><BR/>
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
<i>Figure 1. Visual of corporate policy and five cloud governance disciplines</i>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Incremental Cloud Governance Model

The Fusion approach to cloud governance is built on an incremental model that starts small and grows with cloud adoption. This model helps illustrate the differences between "What can be done with governance" and "What must be done through governance". To learn more about this model, see the article on [Incremental Cloud Governance](./incremental-cloud-governance.md).

Jump to: [Corporate Policy](#corporate-policy) | [Disciplines of Cloud Governance](#disciplines-of-cloud-governance) | [Azure Specific Design Guides](#actionable-design-guides)

## Actionable design guides

To demonstrate actionable implementation patterns of Fusion's Cloud Governance model, the following design guides align Corporate Policy and Cloud Governance Disciplines with the governance tools available in Azure. For cloud agnostic guidance, the sections on [Corporate Policy](#corporate-policy) and [Disciplines of Cloud Governance](#disciplines-of-cloud-governance) may be a better starting point.

<ul  class="panelContent cardsC">
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/future-proof/design-guide.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../_images/governance/cloud-native.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Future proof</h3>
                        <p>Early stage adoption may not warrant an investment in governance. However, this guide establishes a few best practices and policies for you to future proof adoption and ensure that you can add proper governance later.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/production-workload/design-guide.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../_images/governance/production-workload.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Production Workload</h3>
                        <p>Some solutions are dependent upon protected data, such as customer information and business secrets. The business risks associated with hosting protected data in the cloud can often be mitigated with proper disciplines.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/enterprise-mvp/design-guide.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
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
                        <p>Migrating the first few workloads in an organization comes with a few common business risks. The Enterprise MVP design guide provides a scalable starting point to move quickly, enabling you to grow into larger governance needs with cloud adoption.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/enterprise-scale/design-guide.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../_images/governance/enterprise-scale.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Enterprise and scale</h3>
                        <p>As you deploy additional solutions to the cloud, business risks grow. When enterprises reach scale across cloud deployments, governance also requirements scale. This design guide builds on Enterprise MVP to meet these more complex needs.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/enterprise-guardrails/design-guide.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../_images/governance/enterprise-guardrails.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Enterprise Guardrails</h3>
                        <p>Multiple teams deploying to multiple clouds will naturally create policy violations. In complex environments, with thousands of applications and hundreds of thousands of virtual machines (VMs), automated policy enforcement is required.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./design-guides/multi-cloud/design-guide.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage bgdAccent1">
                            <img src="../_images/governance/multi-cloud.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Multi-cloud governance</h3>
                        <p>Industry analysts predict that multi-cloud solutions are an inevitable future. This design guide establishes current approaches to prepare for a multi-cloud landscape.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Corporate policy

Developing corporate policy focuses on identifying and mitigating business risks regardless of the cloud platform. Healthy cloud governance strategy begins with sound corporate policy. The following three-step process guides iterative development of such policies.

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
                        <h3>Business risk</h3>
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
                        <h3>Policy and compliance</h3>
                        <p>Evaluate risk tolerance to inform minimally invasive policies that govern cloud adoption and mitigate risks. In some industries, third party compliance impacts initial policy creation.</p>
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
                            <img src="../_images/governance/enforcement.png" class="x-hidden-focus"/>
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Monitoring and enforcement</h3>
                        <p>The pace of adoption and innovation activities will naturally create policy violations. Ensure that your corporate policies include the proper requirements to detect and resolve violations <u>before</u> they are released.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Disciplines of cloud governance

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
                        <h3>Cost management</h3>
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
                        <h3>Security management</h3>
                        <p>Security is a complex and personal topic that is unique to each company. Once security requirements are established, cloud governance policies and enforcement applies those requirements across network, data, and asset configurations.</p>
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
                        <h3>Identity management</h3>
                        <p>Isolated identity providers introduce management overhead and increase the company's risk profile. Policies, which enforce hybrid identity and extend/improve on-premises identity management, can mitigate several business risks.</p>
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
                        <h3>Resource management</h3>
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
                        <h3>Configuration management</h3>
                        <p>Changes to asset configuration is the most common point of policy violation. As cloud adoption matures, so should the tools and approaches that you use to inspect configuration during deployment, modification, and outage recovery.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>


## Additional guidance

Evaluating current policy through a [cloud policy review](policy-compliance/what-is-a-cloud-policy-review.md) can be a good place to begin the governance journey. [Policy and compliance](policy-compliance/overview.md) can be a useful guide during policy review. To prepare for a policy review, see the [guide to cloud readiness for chief information security officers (CISOs)](how-can-a-ciso-prepare-for-the-cloud.md).

## Next steps

Sound cloud governance strategy starts with an [understanding of business risk](./policy-compliance/understanding-business-risk.md). Lets begin there.

> [!div class="nextstepaction"]
> [Understanding Business Risk](./policy-compliance/understanding-business-risk.md)
