---
title: Connect an on-premises network to Azure
description: Recommended architectures for secure, robust network connections between on-premises networks and Azure.
layout: LandingPage
---
<!-- This file is generated! -->
<!-- See the templates in ./build/reference-architectures  -->
<!-- See data in index.json -->

# Connect an on-premises network to Azure

These reference architectures show proven practices for creating a robust network connection between an on-premises network and Azure. [Which should I choose?](./considerations.md)

<section class="series">
    <ul class="panelContent">
    <!-- VPN -->
<li style="display: flex; flex-direction: column;">
    <a href="./vpn.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./images/vpn.svg" height="140px" />
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
    <!-- ExpressRoute -->
<li style="display: flex; flex-direction: column;">
    <a href="./expressroute.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./images/expressroute.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>ExpressRoute</h3>
                        <p>Extend an on-premises network to Azure using Azure ExpressRoute.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
    <!-- ExpressRoute with VPN failover -->
<li style="display: flex; flex-direction: column;">
    <a href="./expressroute-vpn-failover.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./images/expressroute-vpn-failover.svg" height="140px" />
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
    <!-- Hub-spoke topology -->
<li style="display: flex; flex-direction: column;">
    <a href="./hub-spoke.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./images/hub-spoke.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Hub-spoke topology</h3>
                        <p>The hub is a central point of connectivity to your on-premises network. The spokes are VNets that peer with the hub, and can be used to isolate workloads.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
    </ul>
</section>

<ul class="panelContent cardsI">
</ul>