---
title: Network DMZ | Architectural Blueprints
description: Explains and compares the different methods available for protecting applications and components running in Azure as part of a hybrid system from unauthorized intrusion.
layout: LandingPage
pnp.series.title: Network DMZ
pnp.series.next: secure-vnet-hybrid
---
<link href="/azure/architecture/_css/hubCards.css" type="text/css" rel="stylesheet" />

# Series overview
[!INCLUDE [header](../../_includes/header.md)]

An on-premises network can be connected to a virtual network in Azure by using an Azure VPN gateway. The network boundary between these two environments can expose areas of weakness in terms of security, and it is necessary to protect this boundary to block unauthorized requests. Similar protection is required for applications running on VMs in Azure that are exposed to the public Internet.

<ul class="cardsD panel x2">
    <li>
        <a href="./secure-vnet-hybrid.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage bgdAccent1 cardScaleImage" style="background-image: url('./images/secure-vnet-hybrid.svg');">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>DMZ between Azure and on-premises</h3>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="./secure-vnet-dmz.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage bgdAccent1 cardScaleImage" style="background-image: url('./images/secure-vnet-dmz.svg');">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>DMZ between Azure and the Internet</h3>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="./nva-ha.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage bgdAccent1 cardScaleImage" style="background-image: url('./images/nva-ha.svg');">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Deploy highly available network virtual appliances</h3>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
</ul>

