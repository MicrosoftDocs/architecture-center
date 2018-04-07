---
title: Azure Reference Architectures
description: Reference architectures, blueprints, and prescriptive implementation guidance for common workloads on Azure.
layout: LandingPage
---
<!-- This file is generated! -->
<!-- See the templates in ./build/reference-architectures  -->
<!-- See data in index.json -->

# Azure Reference Architectures

Our reference architectures are arranged by scenario, with related architectures grouped together. Each architecture includes recommended practices, along with considerations for scalability, availability, manageability, and security. Most also include a deployable solution.

<section class="series">
    <ul class="panelContent">
    <!-- N-tier application -->
<li style="display: flex; flex-direction: column;">
    <a href="./n-tier/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./virtual-machines-windows/images/n-tier.svg" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>N-tier application</h3>
                        <p>Deploying an N-tier application to Azure, for Windows or Linux.</p><p>Configurations include single region, single region with Availability Zones, and active-passive in two regions, depending on your availability requirements.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>

    <!-- Hybrid network -->
<li style="display: flex; flex-direction: column;">
    <a href="./hybrid-networking/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./hybrid-networking/images/vpn.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Hybrid network</h3>
                        <p>Create a hybrid network connection between an on-premises network and Azure.</p><p>Configurations include VPN Gateway and ExpressRoute, depending on your bandwidth and scalability requirements.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
    <!-- Network DMZ -->
<li style="display: flex; flex-direction: column;">
    <a href="./dmz/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./dmz/images/secure-vnet-dmz.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Network DMZ</h3>
                        <p>Create a network DMZ to protect the boundary between an Azure virtual network and an on-premises network or the Internet.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
    <!-- Identity management -->
<li style="display: flex; flex-direction: column;">
    <a href="./identity/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./identity/images/adds-extend-domain.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Identity management</h3>
                        <p>Integrate your on-premises Active Directory (AD) environment with an Azure virtual network. Options include integrating with Azure Active Directory, extending AD DS to Azure, and extending AD FS to Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
    <!-- App Service web application -->
<li style="display: flex; flex-direction: column;">
    <a href="./app-service-web-app/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./app-service-web-app/images/scalable-web-app.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>App Service web application</h3>
                        <p>This series shows best practices for web applications that use Azure App Service.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
    </ul>
</section>

<ul class="panelContent cardsI">
    <!-- Jenkins build server -->
<li style="display: flex; flex-direction: column;">
    <a href="./jenkins/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./jenkins/images/logo.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Jenkins build server</h3>
                        <p>Deploy and operate a scalable, enterprise-grade Jenkins server on Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
    <!-- SharePoint Server 2016 farm -->
<li style="display: flex; flex-direction: column;">
    <a href="./sharepoint/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./sharepoint/images/sharepoint.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>SharePoint Server 2016 farm</h3>
                        <p>Deploy and run a high availability SharePoint Server 2016 farm on Azure with SQL Server Always On Availability Groups.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
    <!-- SAP NetWeaver and SAP HANA -->
<li style="display: flex; flex-direction: column;">
    <a href="./sap/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./sap/images/sap.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>SAP NetWeaver and SAP HANA</h3>
                        <p>Deploy and run SAP NetWeaver and SAP HANA in a high availability environment on Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>