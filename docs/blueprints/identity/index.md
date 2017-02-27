---
title: Identity management | Architectural Blueprints
description: Explains and compares the different methods available for managing identity in hybrid systems that span the on-premises/cloud boundary with Azure.
layout: LandingPage
pnp.series.title: Identity management
pnp.series.next: azure-ad
---
<link href="/azure/architecture/_css/hubCards.css" type="text/css" rel="stylesheet" />

# Series overview
[!INCLUDE [header](../../_includes/header.md)]

Most enterprise systems based on Windows use Active Directory (AD) for identity management. When you extend your network infrastructure to the cloud, there are several options for managing identity.

<ul class="cardsD panel x2">
    <li>
        <a href="./azure-ad.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage bgdAccent1 cardScaleImage" style="background-image: url('./images/azure-ad.svg');">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Integrate on-premises AD with Azure AD</h3>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="./adds-extend-domain.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage bgdAccent1 cardScaleImage" style="background-image: url('./images/adds-extend-domain.svg');">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Extend AD DS to Azure</h3>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="./adds-forest.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage bgdAccent1 cardScaleImage" style="background-image: url('./images/adds-forest.svg');">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Create an AD DS forest in Azure</h3>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="./adfs.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage bgdAccent1 cardScaleImage" style="background-image: url('./images/adfs.svg');">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Extend AD FS to Azure</h3>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
</ul>

