---
title: Connect an on-premises network to Azure
description: Recommended architectures for secure, robust network connections between on-premises networks and Azure.
layout: LandingPage
ms.service: guidance
ms.author: pnp
---

# Connect an on-premises network to Azure

These reference architectures show proven practices for creating a robust network connection between an on-premises network and Azure. [Which should I choose?](./considerations.md)

<ul class="panelContent">
    <li>
        <a href="./vpn.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage">
                            <img src="./images/vpn.svg">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>VPN</h3>
                            <p>Extend an on-premises network to Azure using a site-to-site virtual private network (VPN).</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="./expressroute.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage">
                            <img src="./images/expressroute.svg">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>ExpressRoute</h3>
                            <p>Extend an on-premises network to Azure using Azure ExpressRoute</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="./expressroute-vpn-failover.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage">
                            <img src="./images/expressroute-vpn-failover.svg">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>ExpressRoute with VPN failover</h3>
                            <p>Extend an on-premises network to Azure using Azure ExpressRoute, with a VPN as a failover connection.</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="./hub-spoke.md">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
                        <div class="cardImageOuter">
                            <div class="cardImage">
                            <img src="./images/hub-spoke.svg">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Hope-spoke topology</h3>
                            <p>The hub is a VNet that acts as a central point of connectivity to your on-premises network. The spokes are VNets that peer with the hub, and can be used to isolate workloads. </p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
</ul>

