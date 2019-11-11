---
title: "Manage organization alignment"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Provides an overview of an approach to managing organization alignment.
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: landing-page
ms.service: cloud-adoption-framework
ms.subservice: organize
ms.custom: organize
layout: LandingPage
---

# Managing organizational alignment

Cloud adoption can't happen without well-organized people. Successful cloud adoption is the result of properly skilled people doing the appropriate types of work, in alignment with clearly defined business goals, and in a well-managed environment. To deliver an effective cloud operating model, it's important to establish appropriately staffed organizational structures. This article outlines an approach to establishing and maintaining the proper organizational structures in four steps.

## Organization alignment exercises

The following exercises will help guide the process of creating a landing zone to support cloud adoption.

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsF">
    <li style="display: flex; flex-direction: column;">
        <a href="#structure-type">
            <div class="cardSize">
                <div class="cardPadding" style="padding-bottom:10px;">
                    <div class="card" style="padding-bottom:10px;">
                        <div class="cardImageOuter">
                            <div class="cardImage">
                                <img alt="" src="../_images/icons/1.png" data-linktype="external">
                            </div>
                        </div>
                        <div class="cardText" style="padding-left:0px;">
                            <h3>Structure type</h3>
                            Define the type of organizational structure that best fits your operating model.
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li style="display: flex; flex-direction: column;">
        <a href="#understand-required-cloud-capabilities">
            <div class="cardSize">
                <div class="cardPadding" style="padding-bottom:10px;">
                    <div class="card" style="padding-bottom:10px;">
                        <div class="cardImageOuter">
                            <div class="cardImage">
                                <img alt="" src="../_images/icons/2.png" data-linktype="external">
                            </div>
                        </div>
                        <div class="cardText" style="padding-left:0px;">
                            <h3>Cloud capabilities</h3>
                            Understand the cloud capabilities required to adopt and operate the cloud.
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li style="display: flex; flex-direction: column;">
        <a href="./organization-structures.md">
            <div class="cardSize">
                <div class="cardPadding" style="padding-bottom:10px;">
                    <div class="card" style="padding-bottom:10px;">
                        <div class="cardImageOuter">
                            <div class="cardImage">
                                <img alt="" src="../_images/icons/3.png" data-linktype="external">
                            </div>
                        </div>
                        <div class="cardText" style="padding-left:0px;">
                            <h3>Establish teams</h3>
                            Define the teams that will be providing various cloud capabilities. A number of best practice options are listed for reference.
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li style="display: flex; flex-direction: column;">
        <a href="./raci-alignment.md">
            <div class="cardSize">
                <div class="cardPadding" style="padding-bottom:10px;">
                    <div class="card" style="padding-bottom:10px;">
                        <div class="cardImageOuter">
                            <div class="cardImage">
                                <img alt="" src="../_images/icons/4.png" data-linktype="external">
                            </div>
                        </div>
                        <div class="cardText" style="padding-left:0px;">
                            <h3>RACI matrix</h3>
                            Clearly defined roles are an important aspect of any operating model. Leverage the provided RACI matrix to map responsibility, accountability, consulted, and informed roles to each of the teams for various functions of the cloud operating model.
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
</ul>

<!-- markdownlint-enable MD033 -->

## Structure type

The following organizational structures do not necessarily have to map to an organizational chart (org chart). Org charts generally reflect command and control management structures. Conversely, the following organizational structures are designed to capture alignment of roles and responsibilities. In an agile, matrix organization, these structures may be best represented as virtual teams (or v-teams). There is no limitation suggesting that these organizational structures couldn't be represented in an org chart, but it is not necessary in order to produce an effective operating model.

The first step of managing organizational alignment is to determine how the following organizational structures will be fulfilled:

- **Org chart alignment:** Management hierarchies, manager responsibilities, and staff alignment will align to organizational structures.
- **Virtual teams (v-teams):** Management structures and org charts remain unchanged. Instead, virtual teams will be created and tasked with the required capabilities.
- **Mixed model:** More commonly, a mixture of org chart and v-team alignment will be required to deliver on transformation goals.

## Understand required cloud capabilities

The following is a list of cloud capabilities that are required to succeed at cloud adoption and longer-term operating models. After you become familiar with the various cloud capabilities, these can be aligned to organizational structures based on staffing and maturity:

- [Cloud adoption](./cloud-adoption.md): Deliver technical solutions.
- [Cloud strategy](./cloud-strategy.md): Align technical change to business needs.
- [Cloud operations](./cloud-operations.md): Support and operate adopted solutions.
- [Cloud center of excellence](./cloud-center-excellence.md): Improve quality, speed, and resiliency of adoption.
- [Cloud governance](./cloud-governance.md): Manage risk
- [Cloud platform](./cloud-platform.md): Operate and mature the platform.
- [Cloud automation](./cloud-automation.md): Accelerate adoption and innovation.

## Maturing organizational structures

To some degree, each of the above capabilities is delivered in every cloud adoption effort, either explicitly or in accordance with a defined team structure.
As adoption needs grow, so does the need to create balance and structure. To meet those needs, companies often follow a process of maturing organizational structures.

![Organizational maturity cycle](../_images/ready/org-ready-maturity.png)

The article on [determining organizational structure maturity](./organization-structures.md) provides additional detail regarding each level of maturity.

## Aligning RACI charts

At each level of maturity, accountability for various cloud capabilities shifts to new teams. This shifting of accountability enables faster migration and innovation cycles by removing and automating barriers to change. To align assignments properly, the article on [RACI alignment](./raci-alignment.md) shares a RACI chart for each of the referenced organizational structures.

## Next steps

To track organization structure decisions over time, download and modify the [RACI spreadsheet template][template]

> [!div class="nextstepaction"]
> [Download the RACI spreadsheet template][template]

<!-- links -->
[template]: https://archcenter.blob.core.windows.net/cdn/fusion/management/raci-template.xlsx
