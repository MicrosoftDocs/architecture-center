---
title: Reference architecture for Oracle Database Migration to Azure
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/12/2019
description: Oracle DB migrations can be accomplished in multiple ways. This architecture covers one of these options wherein Oracle Active Data Guard is used to migrate the Database. It is assumed that Oracle Data Guard (or Active Data Guard) is used for HA/DR purposes. Depending on the application, either the application can be migrated first or the database. In this case, the application is migrated to Azure using Azure Load Balancer. This enables you to split your traffic between on-premises and Azure, allowing you to gradually migrate your application tier. The database migration is performed in multiple steps. As a first step, Oracle Data Guard is used to set up a Secondary/Standby Database in Azure. This allows you to migrate your data to Azure. Once the secondary in Azure is in-sync with the primary, you can flip the database in Azure to be your primary database while maintaining your secondary on-premises. As a next step, you may set up a secondary database in a different Availability Zone (or region) for HA/DR purposes. At this point, you can decommission your on-premises environment. All data traffic between on-premises and Azure flows over Azure ExpressRoute or Site-to-Site VPN connectivity.
ms.custom: acom-architecture, Oracle, Oracle Database, Oracle DB, Oracle on Azure, Oracle DB architecture, interactive-diagram
---
# Reference architecture for Oracle Database Migration to Azure

<div class="alert">
    <p class="alert-title">
        <span class="icon is-left" aria-hidden="true">
            <span class="icon docon docon-lightbulb" role="presentation"></span>
        </span>Solution Idea</p>
    <p>If you'd like to see us add more information to this article, let us know with <a href="#feedback">GitHub Feedback</a>!</p>
    <p>Based on your feedback, this solution idea could be expanded to include implementation details, pricing guidance, code examples, and deployment templates.</p>
</div>

Oracle DB migrations can be accomplished in multiple ways. This architecture covers one of these options wherein Oracle Active Data Guard is used to migrate the Database. It is assumed that Oracle Data Guard (or Active Data Guard) is used for HA/DR purposes. Depending on the application, either the application can be migrated first or the database. In this case, the application is migrated to Azure using Azure Load Balancer. This enables you to split your traffic between on-premises and Azure, allowing you to gradually migrate your application tier. The database migration is performed in multiple steps. As a first step, Oracle Data Guard is used to set up a Secondary/Standby Database in Azure. This allows you to migrate your data to Azure. Once the secondary in Azure is in-sync with the primary, you can flip the database in Azure to be your primary database while maintaining your secondary on-premises. As a next step, you may set up a secondary database in a different Availability Zone (or region) for HA/DR purposes. At this point, you can decommission your on-premises environment. All data traffic between on-premises and Azure flows over Azure ExpressRoute or Site-to-Site VPN connectivity.

## Architecture

<svg class="architecture-diagram" aria-labelledby="reference-architecture-for-oracle-database-migration-to-azure" height="701" viewbox="0 0 1044 701" width="1044" xmlns="http://www.w3.org/2000/svg">
    <g transform="translate(-29 -9)" fill="none" fill-rule="evenodd" stroke="none" stroke-width="1">
        <path d="M0 720.059h1081.57V0H0z"/>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="134.239" y="155.186">O</tspan><tspan letter-spacing=".006" x="141.975" y="155.186">n</tspan><tspan x="147.953" y="155.186">-P</tspan><tspan letter-spacing="-.089" x="158.047" y="155.186">r</tspan><tspan x="161.656" y="155.186">emises Net</tspan><tspan letter-spacing="-.037" x="212.891" y="155.186">w</tspan><tspan x="220.555" y="155.186">ork</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="13.313" font-weight="500">
            <tspan x="151.507" y="100.323">O</tspan><tspan letter-spacing=".008" x="161.57" y="100.323">n</tspan><tspan x="169.347" y="100.323">-P</tspan><tspan letter-spacing="-.114" x="182.478" y="100.323">r</tspan><tspan x="187.174" y="100.323">emises</tspan>
        </text>
        <path d="M194.902 588.675a14.605 14.605 0 00-14.577 14.229 11.133 11.133 0 0113.007 1.949 11.133 11.133 0 012.068 12.988 14.587 14.587 0 00-.498-29.167z" fill="#FFF"/>
        <path d="M195.74 618.47c3.173-2.78 6.558-7.192 6.558-15.19 0-7.997-3.33-12.584-6.59-15.211l-1.32 1.297c3.05 2.458 5.87 5.849 5.87 13.915 0 8.097-2.915 11.326-5.898 13.935l1.38 1.255z" fill="#3898C5"/>
        <path fill="#3898C5" d="M181.267 604.187h27.443v-1.83h-27.443zM194.99 596.433c-4.502 0-8.567-1.255-10.994-3.125l-1.097 1.096c2.706 2.174 7.107 3.596 12.09 3.596s9.385-1.422 12.091-3.596l-1.097-1.097c-2.427 1.87-6.49 3.125-10.994 3.125"/>
        <path d="M176.788 618.017l-8.637 8.637a2.436 2.436 0 00.014 3.437 2.442 2.442 0 003.437.014l8.641-8.632-3.455-3.456z" fill="#7A7B7B"/>
        <path d="M173.4 621.406a12.081 12.081 0 003.453 3.455l2.26-2.259-3.456-3.452-2.258 2.256z" fill="#1D1D1D"/>
        <path d="M185.25 620.458a7.773 7.773 0 100-15.546 7.773 7.773 0 000 15.546" fill="#FFF"/>
        <path d="M185.49 622.271a9.5 9.5 0 009.5-9.5 9.5 9.5 0 00-9.5-9.5 9.5 9.5 0 00-9.5 9.5 9.5 9.5 0 009.5 9.5" fill="#FFF"/>
        <path d="M189.74 602.472c.185-7.483 2.907-10.732 5.85-13.106l-1.32-1.298c-3.058 2.466-6.18 6.663-6.55 13.784.691.142 1.367.35 2.02.62M195.806 608.57c.207.514.376 1.043.505 1.583 3.967.218 7.483 1.394 9.675 3.078l1.096-1.097c-2.556-2.054-6.632-3.42-11.276-3.564" fill="#3898C5"/>
        <path d="M194.991 587.81a15.48 15.48 0 00-15.459 15.46c0 .032.004.063.005.095.626-.397 1.291-.73 1.983-.994a13.51 13.51 0 018.725-11.747 13.5 13.5 0 0114.302 3.093 13.507 13.507 0 01-8.657 23.025 11.058 11.058 0 01-.993 1.978c.032 0 .063.006.094.006 4.101 0 8.033-1.629 10.933-4.528a15.466 15.466 0 000-21.864 15.464 15.464 0 00-10.933-4.528v.004z" fill="#3898C5"/>
        <path fill="#7FBA00" d="M184.265 617.953l-1.786-5.274-1.371 2.704h-2.53v-1.355h1.677l2.476-4.877 1.524 4.504 2.18-6.511 1.787 5.266 1.669-3.184h2.505v1.373h-1.721l-2.708 5.337-1.527-4.498z"/>
        <path d="M179.005 615.784c0-5.614 3.912-9.5 9.5-9.5a9.44 9.44 0 014.759 1.29 9.514 9.514 0 00-2.948-3.144 9.5 9.5 0 00-14.26 4.844 9.49 9.49 0 001.093 8.324 9.505 9.505 0 003.143 2.949 9.445 9.445 0 01-1.287-4.763" fill="#3898C5"/>
        <path d="M185.49 621.669a8.89 8.89 0 01-8.218-5.491 8.897 8.897 0 016.481-12.13 8.902 8.902 0 019.132 3.78 8.902 8.902 0 01.824 8.347 8.897 8.897 0 01-8.219 5.491v.003zm0-20.903a12.01 12.01 0 00-11.092 7.41 12.01 12.01 0 002.603 13.084 12.002 12.002 0 0013.083 2.602 11.994 11.994 0 005.387-4.422 12.006 12.006 0 00-9.981-18.674z" fill="#7A7B7B"/>
        <path d="M845.516 276.028a14.605 14.605 0 00-14.577 14.23 11.133 11.133 0 0113.007 1.948 11.133 11.133 0 012.068 12.988 14.587 14.587 0 00-.498-29.167v.001z" fill="#FFF"/>
        <path d="M846.354 305.824c3.173-2.782 6.558-7.194 6.558-15.19 0-7.998-3.332-12.585-6.59-15.212l-1.32 1.297c3.049 2.458 5.87 5.85 5.87 13.915 0 8.097-2.916 11.325-5.899 13.935l1.38 1.255z" fill="#3898C5"/>
        <path fill="#3898C5" d="M831.88 291.54h27.443v-1.829H831.88zM845.602 283.786c-4.5 0-8.565-1.255-10.992-3.125l-1.097 1.097c2.705 2.174 7.106 3.596 12.09 3.596 4.983 0 9.385-1.422 12.09-3.597l-1.097-1.097c-2.427 1.871-6.491 3.126-10.994 3.126"/>
        <path d="M827.401 305.371l-8.637 8.637a2.436 2.436 0 00.014 3.437 2.441 2.441 0 003.437.014l8.641-8.632-3.455-3.456z" fill="#7A7B7B"/>
        <path d="M824.013 308.76a12.094 12.094 0 003.454 3.455l2.259-2.26-3.455-3.451-2.258 2.256z" fill="#1D1D1D"/>
        <path d="M835.863 307.811a7.773 7.773 0 100-15.545 7.773 7.773 0 000 15.545" fill="#FFF"/>
        <path d="M836.102 309.625a9.5 9.5 0 009.5-9.5 9.5 9.5 0 00-9.5-9.5 9.5 9.5 0 00-9.5 9.5 9.5 9.5 0 009.5 9.5" fill="#FFF"/>
        <path d="M840.352 289.826c.187-7.484 2.909-10.734 5.85-13.107l-1.32-1.297c-3.056 2.466-6.18 6.663-6.55 13.784.692.141 1.369.349 2.02.62M846.419 295.924c.207.514.376 1.043.505 1.583 3.967.218 7.483 1.394 9.675 3.078l1.096-1.097c-2.556-2.054-6.632-3.42-11.276-3.564" fill="#3898C5"/>
        <path d="M845.605 275.164a15.48 15.48 0 00-15.46 15.46c0 .032.005.062.005.095.627-.397 1.292-.73 1.984-.994a13.507 13.507 0 0126.677-1.958 13.503 13.503 0 01-12.307 16.329 11.03 11.03 0 01-.995 1.978c.034 0 .064.006.096.006 4.1 0 8.033-1.63 10.933-4.528a15.466 15.466 0 000-21.864 15.464 15.464 0 00-10.933-4.528v.004z" fill="#3898C5"/>
        <path fill="#7FBA00" d="M834.878 305.307l-1.786-5.276-1.371 2.705h-2.53v-1.354h1.677l2.476-4.877 1.524 4.504 2.18-6.512 1.787 5.267 1.669-3.185h2.505v1.373h-1.721l-2.71 5.337-1.525-4.498z"/>
        <path d="M829.618 303.138c0-5.614 3.912-9.5 9.5-9.5a9.44 9.44 0 014.76 1.29 9.505 9.505 0 00-2.949-3.144 9.502 9.502 0 00-11.984 1.184 9.508 9.508 0 00-2.7 7.949 9.498 9.498 0 004.66 6.984 9.445 9.445 0 01-1.287-4.763" fill="#3898C5"/>
        <path d="M836.104 309.022a8.89 8.89 0 01-4.942-1.499 8.907 8.907 0 01-3.278-3.992 8.9 8.9 0 016.482-12.129 8.89 8.89 0 019.133 3.78 8.902 8.902 0 011.5 4.942 8.896 8.896 0 01-8.895 8.895v.003zm0-20.903a12.007 12.007 0 00-11.093 7.411 12 12 0 00-.681 6.935 11.998 11.998 0 009.431 9.433 11.996 11.996 0 0012.324-5.105 12.006 12.006 0 00-9.981-18.674z" fill="#7A7B7B"/>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="451.846" y="138.743">Client </tspan><tspan letter-spacing="-.241" x="481.469" y="138.743">S</tspan><tspan x="486.556" y="138.743">ys</tspan><tspan letter-spacing="-.055" x="496.17" y="138.743">t</tspan><tspan x="499.753" y="138.743">em</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="167.492" y="354.682">A</tspan><tspan letter-spacing="-.005" x="174.363" y="354.682">p</tspan><tspan x="180.524" y="354.682">p Se</tspan><tspan letter-spacing=".41" x="200.513" y="354.682">r</tspan><tspan letter-spacing="-.076" x="205.121" y="354.682">v</tspan><tspan x="210.157" y="354.682">er1</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="73.215" y="507.917">Oracle DB1</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="76.725" y="520.198">(</tspan><tspan letter-spacing="-.005" x="80.124" y="520.198">p</tspan><tspan x="86.285" y="520.198">rima</tspan><tspan letter-spacing=".411" x="107.153" y="520.198">r</tspan><tspan x="111.762" y="520.198">y)</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="262.689" y="507.917">Oracle DB2</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="266.711" y="520.198">(stan</tspan><tspan letter-spacing="-.005" x="289.533" y="520.198">db</tspan><tspan x="301.856" y="520.198">y)</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="677.59" y="507.917">Oracle DB1</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="681.1" y="520.198">(</tspan><tspan letter-spacing="-.005" x="684.498" y="520.198">p</tspan><tspan x="690.66" y="520.198">rima</tspan><tspan letter-spacing=".411" x="711.528" y="520.198">r</tspan><tspan x="716.137" y="520.198">y)</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="681.765" y="623.614">P</tspan><tspan letter-spacing="-.089" x="687.747" y="623.614">r</tspan><tspan x="691.356" y="623.614">emium</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.291">
            <tspan x="670.825" y="635.895">S</tspan><tspan letter-spacing="-.056" x="675.812" y="635.895">t</tspan><tspan x="679.393" y="635.895">orage using</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="675.461" y="648.176">Oracle ASM</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="971.38" y="623.614">P</tspan><tspan letter-spacing="-.089" x="977.362" y="623.614">r</tspan><tspan x="980.971" y="623.614">emium</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.291">
            <tspan x="960.44" y="635.895">S</tspan><tspan letter-spacing="-.056" x="965.426" y="635.895">t</tspan><tspan x="969.008" y="635.895">orage using</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="965.076" y="648.176">Oracle ASM</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="959.979" y="507.917">Oracle DB2</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="964.001" y="520.198">(stan</tspan><tspan letter-spacing="-.005" x="986.823" y="520.198">db</tspan><tspan x="999.146" y="520.198">y)</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="957.257" y="337.694">A</tspan><tspan letter-spacing="-.005" x="964.128" y="337.694">p</tspan><tspan x="970.29" y="337.694">p Se</tspan><tspan letter-spacing=".41" x="990.278" y="337.694">r</tspan><tspan letter-spacing="-.076" x="994.886" y="337.694">v</tspan><tspan x="999.922" y="337.694">er3</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="670.488" y="337.694">A</tspan><tspan letter-spacing="-.005" x="677.359" y="337.694">p</tspan><tspan x="683.52" y="337.694">p Se</tspan><tspan letter-spacing=".41" x="703.508" y="337.694">r</tspan><tspan letter-spacing="-.077" x="708.116" y="337.694">v</tspan><tspan x="713.152" y="337.694">er2</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.216">
            <tspan x="660.284" y="216.911">A</tspan><tspan letter-spacing="-.167" x="666.719" y="216.911">v</tspan><tspan x="671.575" y="216.911">aila</tspan><tspan letter-spacing="-.005" x="687.605" y="216.911">b</tspan><tspan x="693.767" y="216.911">ility Zone</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="696.011" y="235.997">0</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.216">
            <tspan x="804.165" y="216.911">A</tspan><tspan letter-spacing="-.167" x="810.601" y="216.911">v</tspan><tspan x="815.456" y="216.911">aila</tspan><tspan letter-spacing="-.005" x="831.487" y="216.911">b</tspan><tspan x="837.648" y="216.911">ility Zone</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="840.67" y="235.997">1</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.216">
            <tspan x="950.462" y="216.911">A</tspan><tspan letter-spacing="-.167" x="956.897" y="216.911">v</tspan><tspan x="961.752" y="216.911">aila</tspan><tspan letter-spacing="-.005" x="977.783" y="216.911">b</tspan><tspan x="983.944" y="216.911">ility Zone</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="986.189" y="235.997">2</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.116">
            <tspan x="803.009" y="337.694">F</tspan><tspan x="807.915" y="337.694">SFQ O</tspan><tspan letter-spacing="-.005" x="836.914" y="337.694">b</tspan><tspan x="843.075" y="337.694">se</tspan><tspan letter-spacing=".41" x="852.924" y="337.694">r</tspan><tspan letter-spacing="-.077" x="857.532" y="337.694">v</tspan><tspan x="862.568" y="337.694">er</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="811.953" y="133.421">L</tspan><tspan letter-spacing="-.119" x="816.956" y="133.421">o</tspan><tspan x="822.828" y="133.421">ad Balancer</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="13.313" font-weight="500">
            <tspan x="826.996" y="48.881">Azu</tspan><tspan letter-spacing="-.114" x="849.884" y="48.881">r</tspan><tspan x="854.58" y="48.881">e</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="818.789" y="448.151">DataGua</tspan><tspan letter-spacing="-.088" x="858.96" y="448.151">r</tspan><tspan x="862.57" y="448.151">d</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.274">
            <tspan x="798.668" y="470.236">R</tspan><tspan x="804.496" y="470.236">e</tspan><tspan letter-spacing="-.005" x="809.932" y="470.236">d</tspan><tspan x="816.094" y="470.236">o </tspan><tspan letter-spacing="-.29" x="825.019" y="470.236">S</tspan><tspan x="830.006" y="470.236">t</tspan><tspan letter-spacing="-.089" x="833.704" y="470.236">r</tspan><tspan x="837.313" y="470.236">eam (sync)</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="467.431" y="504.49">DataGua</tspan><tspan letter-spacing="-.088" x="507.603" y="504.49">r</tspan><tspan x="511.213" y="504.49">d</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="440.925" y="558.874">VPN or Ex</tspan><tspan letter-spacing="-.005" x="487.273" y="558.874">p</tspan><tspan letter-spacing="-.088" x="493.435" y="558.874">r</tspan><tspan x="497.045" y="558.874">ess</tspan><tspan letter-spacing="-.278" x="511.306" y="558.874">R</tspan><tspan x="517.125" y="558.874">ou</tspan><tspan letter-spacing="-.056" x="529.208" y="558.874">t</tspan><tspan x="532.789" y="558.874">e</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500">
            <tspan x="460.892" y="571.155">Connectivity</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.116">
            <tspan x="153.511" y="641.79">F</tspan><tspan x="158.417" y="641.79">SFQ O</tspan><tspan letter-spacing="-.005" x="187.415" y="641.79">b</tspan><tspan x="193.577" y="641.79">se</tspan><tspan letter-spacing=".41" x="203.426" y="641.79">r</tspan><tspan letter-spacing="-.077" x="208.034" y="641.79">v</tspan><tspan x="213.069" y="641.79">er</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.274">
            <tspan x="153.112" y="470.257">R</tspan><tspan x="158.939" y="470.257">e</tspan><tspan letter-spacing="-.005" x="164.376" y="470.257">d</tspan><tspan x="170.537" y="470.257">o </tspan><tspan letter-spacing="-.29" x="179.462" y="470.257">S</tspan><tspan x="184.449" y="470.257">t</tspan><tspan letter-spacing="-.089" x="188.147" y="470.257">r</tspan><tspan x="191.756" y="470.257">eam (sync)</tspan>
        </text>
        <text fill="#525252" font-family="SegoeUI-Semibold, Segoe UI" font-size="10.234" font-weight="500" letter-spacing="-.274">
            <tspan x="449.02" y="470.257">R</tspan><tspan x="454.848" y="470.257">e</tspan><tspan letter-spacing="-.005" x="460.284" y="470.257">d</tspan><tspan x="466.446" y="470.257">o </tspan><tspan letter-spacing="-.29" x="475.371" y="470.257">S</tspan><tspan x="480.358" y="470.257">t</tspan><tspan letter-spacing="-.089" x="484.056" y="470.257">r</tspan><tspan x="487.665" y="470.257">eam (sync)</tspan>
        </text>
        <path d="M694.138 463.159v-8.946h-15.031v29.619c0 2.055 3.102 3.868 7.697 4.836v-25.509h7.334z" fill="#0072C6"/>
        <path fill="#2D88CB" d="M694.38 454.213h-.242v8.946h15.555v-8.946z"/>
        <path d="M709.692 454.212c0 3.022-6.85 5.56-15.272 5.56-8.423 0-15.314-2.417-15.314-5.56 0-3.022 6.851-5.562 15.273-5.562s15.313 2.54 15.313 5.562" fill="#FFF"/>
        <path d="M706.59 453.969c0 1.975-5.48 3.627-12.17 3.627-6.688 0-12.17-1.652-12.17-3.627 0-2.055 5.482-3.707 12.17-3.707 6.69 0 12.17 1.652 12.17 3.707" fill="#0072C6"/>
        <path d="M704.05 456.185c1.652-.645 2.538-1.41 2.538-2.217 0-2.054-5.48-3.707-12.17-3.707-6.69 0-12.21 1.653-12.21 3.707 0 .807.967 1.653 2.539 2.217 2.216-.887 5.722-1.41 9.63-1.41 3.95-.04 7.456.523 9.673 1.41" fill="#2D88CB"/>
        <path fill="#0078D4" d="M688.177 491.808h34.495v-26.557h-34.495z"/>
        <path fill="#50E6FF" d="M688.177 468.116h34.495v-3.587h-34.495zM709.451 475.73v-2.539h-15.837v11.444h6.286l3.87 3.991c.08.08.282 0 .241-.162l-.524-3.869h1.975a6.141 6.141 0 01-.766-2.94c.04-2.903 2.055-5.32 4.755-5.925"/>
        <path d="M711.991 476.736v-.442c-.322-.08-.726-.08-1.128-.08-3.022 0-5.56 2.457-5.56 5.56a5.52 5.52 0 005.56 5.561c.564 0 1.168-.08 1.692-.283l-2.82-2.74.805-1.49h1.491c.564 0 1.048-.484 1.048-1.048 0-.564-.484-1.048-1.048-1.048h-4.674l2.417-2.66v1.21h2.217a2.486 2.486 0 012.498 2.498 2.51 2.51 0 01-2.498 2.498l2.015 1.975a5.496 5.496 0 002.297-4.473 5.443 5.443 0 00-1.653-3.909h-1.692c-.524-.12-.967-.565-.967-1.129" fill="#50E6FF"/>
        <path d="M713.357 476.777c-.16 0-.24-.04-.282-.16-.04-.04-.04-.08-.04-.202 0-.2.161-.323.322-.323.202 0 .322.162.322.323s-.12.322-.322.362zm4.191-5.642l-2.94 2.943h-1.533a.534.534 0 00-.524.523v2.056c0 .281.243.523.524.523h2.015a.533.533 0 00.524-.523v-1.975h.322l.484-.484v-.564l.162-.16h.563l.322-.323v-.645l.444-.444h.403v-.967h-.766v.04z" fill="#50E6FF"/>
        <path d="M713.357 476.778c-.04-.04-.202-.08-.282-.16.04.08.121.16.282.16" fill="#50E6FF"/>
        <path d="M285.187 463.159v-8.946h-15.031v29.619c0 2.055 3.103 3.868 7.697 4.836v-25.509h7.334z" fill="#0072C6"/>
        <path fill="#2D88CB" d="M285.429 454.213h-.242v8.946h15.555v-8.946z"/>
        <path d="M300.742 454.212c0 3.022-6.85 5.56-15.273 5.56-8.422 0-15.314-2.417-15.314-5.56 0-3.022 6.852-5.562 15.274-5.562 8.421 0 15.313 2.54 15.313 5.562" fill="#FFF"/>
        <path d="M297.64 453.969c0 1.975-5.48 3.627-12.17 3.627-6.69 0-12.17-1.652-12.17-3.627 0-2.055 5.48-3.707 12.17-3.707 6.69 0 12.17 1.652 12.17 3.707" fill="#0072C6"/>
        <path d="M295.099 456.185c1.652-.645 2.539-1.41 2.539-2.217 0-2.054-5.48-3.707-12.17-3.707-6.69 0-12.211 1.653-12.211 3.707 0 .807.968 1.653 2.539 2.217 2.217-.887 5.723-1.41 9.63-1.41 3.95-.04 7.457.523 9.673 1.41" fill="#2D88CB"/>
        <path fill="#0078D4" d="M279.226 491.808h34.495v-26.557h-34.495z"/>
        <path fill="#50E6FF" d="M279.226 468.116h34.495v-3.587h-34.495zM300.501 475.73v-2.539h-15.838v11.444h6.287l3.868 3.991c.081.08.283 0 .243-.162l-.525-3.869h1.975a6.141 6.141 0 01-.766-2.94c.041-2.903 2.056-5.32 4.756-5.925"/>
        <path d="M303.04 476.736v-.442c-.322-.08-.725-.08-1.128-.08-3.022 0-5.561 2.457-5.561 5.56a5.521 5.521 0 005.561 5.561c.565 0 1.169-.08 1.692-.283l-2.82-2.74.806-1.49h1.491c.563 0 1.048-.484 1.048-1.048 0-.564-.485-1.048-1.048-1.048h-4.675l2.418-2.66v1.21h2.216a2.486 2.486 0 012.499 2.498 2.511 2.511 0 01-2.499 2.498l2.016 1.975a5.497 5.497 0 002.296-4.473 5.442 5.442 0 00-1.652-3.909h-1.692c-.525-.12-.968-.565-.968-1.129" fill="#50E6FF"/>
        <path d="M304.407 476.777c-.16 0-.242-.04-.282-.16-.04-.04-.04-.08-.04-.202 0-.2.161-.323.322-.323.201 0 .322.162.322.323s-.12.322-.322.362zm4.19-5.642l-2.94 2.943h-1.532a.534.534 0 00-.525.523v2.056c0 .281.243.523.525.523H306.14a.534.534 0 00.525-.523v-1.975h.322l.484-.484v-.564l.161-.16h.564l.322-.323v-.645l.444-.444h.402v-.967h-.766v.04z" fill="#50E6FF"/>
        <path d="M304.406 476.778c-.04-.04-.2-.08-.282-.16.041.08.121.16.282.16" fill="#50E6FF"/>
        <path d="M91.013 463.159v-8.946H75.982v29.619c0 2.055 3.102 3.868 7.697 4.836v-25.509h7.334z" fill="#0072C6"/>
        <path fill="#2D88CB" d="M91.255 454.213h-.242v8.946h15.555v-8.946z"/>
        <path d="M106.567 454.212c0 3.022-6.85 5.56-15.272 5.56-8.423 0-15.314-2.417-15.314-5.56 0-3.022 6.851-5.562 15.273-5.562s15.313 2.54 15.313 5.562" fill="#FFF"/>
        <path d="M103.466 453.969c0 1.975-5.48 3.627-12.17 3.627-6.69 0-12.17-1.652-12.17-3.627 0-2.055 5.48-3.707 12.17-3.707 6.69 0 12.17 1.652 12.17 3.707" fill="#0072C6"/>
        <path d="M100.925 456.185c1.65-.645 2.538-1.41 2.538-2.217 0-2.054-5.48-3.707-12.17-3.707-6.69 0-12.21 1.653-12.21 3.707 0 .807.967 1.653 2.539 2.217 2.216-.887 5.722-1.41 9.63-1.41 3.95-.04 7.456.523 9.673 1.41" fill="#2D88CB"/>
        <path fill="#0078D4" d="M85.052 491.808h34.495v-26.557H85.052z"/>
        <path fill="#50E6FF" d="M85.052 468.116h34.495v-3.587H85.052zM106.326 475.73v-2.539H90.49v11.444h6.286l3.87 3.991c.08.08.282 0 .241-.162l-.524-3.869h1.975a6.141 6.141 0 01-.766-2.94c.04-2.903 2.055-5.32 4.755-5.925"/>
        <path d="M108.866 476.736v-.442c-.322-.08-.726-.08-1.128-.08-3.022 0-5.56 2.457-5.56 5.56a5.52 5.52 0 005.56 5.561c.564 0 1.168-.08 1.692-.283l-2.82-2.74.805-1.49h1.491c.564 0 1.048-.484 1.048-1.048 0-.564-.484-1.048-1.048-1.048h-4.675l2.418-2.66v1.21h2.217a2.486 2.486 0 012.498 2.498 2.51 2.51 0 01-2.498 2.498l2.015 1.975a5.498 5.498 0 002.297-4.473 5.443 5.443 0 00-1.653-3.909h-1.692c-.524-.12-.967-.565-.967-1.129" fill="#50E6FF"/>
        <path d="M110.232 476.777c-.16 0-.24-.04-.282-.16-.04-.04-.04-.08-.04-.202 0-.2.161-.323.322-.323.202 0 .322.162.322.323s-.12.322-.322.362zm4.191-5.642l-2.942 2.943h-1.53a.534.534 0 00-.525.523v2.056c0 .281.243.523.524.523h2.015a.534.534 0 00.524-.523v-1.975h.322l.484-.484v-.564l.161-.16h.564l.322-.323v-.645l.444-.444h.403v-.967h-.766v.04z" fill="#50E6FF"/>
        <path d="M110.232 476.778c-.04-.04-.202-.08-.282-.16.04.08.121.16.282.16" fill="#50E6FF"/>
        <path d="M980.506 463.159v-8.946h-15.031v29.619c0 2.055 3.103 3.868 7.697 4.836v-25.509h7.334z" fill="#0072C6"/>
        <path fill="#2D88CB" d="M980.748 454.213h-.242v8.946h15.555v-8.946z"/>
        <path d="M996.062 454.212c0 3.022-6.852 5.56-15.274 5.56-8.422 0-15.313-2.417-15.313-5.56 0-3.022 6.85-5.562 15.274-5.562 8.42 0 15.313 2.54 15.313 5.562" fill="#FFF"/>
        <path d="M992.959 453.969c0 1.975-5.48 3.627-12.17 3.627-6.689 0-12.17-1.652-12.17-3.627 0-2.055 5.481-3.707 12.17-3.707 6.69 0 12.17 1.652 12.17 3.707" fill="#0072C6"/>
        <path d="M990.418 456.185c1.652-.645 2.539-1.41 2.539-2.217 0-2.054-5.48-3.707-12.17-3.707-6.689 0-12.211 1.653-12.211 3.707 0 .807.968 1.653 2.539 2.217 2.217-.887 5.723-1.41 9.631-1.41 3.949-.04 7.455.523 9.672 1.41" fill="#2D88CB"/>
        <path fill="#0078D4" d="M974.545 491.808h34.495v-26.557h-34.495z"/>
        <path fill="#50E6FF" d="M974.545 468.116h34.495v-3.587h-34.495zM995.82 475.73v-2.539h-15.838v11.444h6.287l3.868 3.991c.081.08.283 0 .243-.162l-.525-3.869h1.975a6.141 6.141 0 01-.766-2.94c.04-2.903 2.056-5.32 4.756-5.925"/>
        <path d="M998.36 476.736v-.442c-.323-.08-.726-.08-1.129-.08-3.022 0-5.56 2.457-5.56 5.56a5.521 5.521 0 005.56 5.561c.565 0 1.17-.08 1.692-.283l-2.82-2.74.806-1.49h1.491c.563 0 1.048-.484 1.048-1.048 0-.564-.485-1.048-1.048-1.048h-4.675l2.418-2.66v1.21h2.216a2.486 2.486 0 012.5 2.498 2.511 2.511 0 01-2.5 2.498l2.016 1.975a5.497 5.497 0 002.296-4.473 5.446 5.446 0 00-1.652-3.909h-1.692c-.525-.12-.968-.565-.968-1.129" fill="#50E6FF"/>
        <path d="M999.727 476.777c-.161 0-.242-.04-.282-.16-.04-.04-.04-.08-.04-.202 0-.2.16-.323.322-.323.2 0 .322.162.322.323s-.121.322-.322.362zm4.19-5.642l-2.941 2.943h-1.531a.534.534 0 00-.525.523v2.056c0 .281.243.523.525.523H1001.459a.533.533 0 00.524-.523v-1.975h.323l.484-.484v-.564l.16-.16h.565l.322-.323v-.645l.444-.444h.402v-.967h-.766v.04z" fill="#50E6FF"/>
        <path d="M999.726 476.778c-.04-.04-.201-.08-.282-.16.04.08.12.16.282.16" fill="#50E6FF"/>
        <path d="M193.833 335.263c11.863 0 21.48-9.712 21.48-21.691 0-11.981-9.617-21.692-21.48-21.692s-21.48 9.71-21.48 21.692c0 11.979 9.617 21.69 21.48 21.69" fill="#FFF"/>
        <path d="M179.72 307.78c1.159-.422 2.423-.527 3.58-.21.212-.317.528-.528.738-.844 2-2.105 4.107-3.896 6.002-5.159-2.316-2.422-4.317-4.844-5.791-7.37-1.263.631-2.527 1.367-3.685 2.21-.843.737-1.58 1.37-2.317 2.211-.316 1.685-.422 5.055 1.474 9.161M193.093 299.672c5.896-3.16 11.056-3.16 14.426-2.737-3.897-3.265-8.846-4.95-13.794-4.95-2.212 0-4.423.316-6.634 1.053 2 2.317 4 4.529 6.002 6.634M176.773 317.888c-1.79-2.422-1.79-5.58 0-7.897-1.475-3.581-1.368-6.53-.843-8.634-4.948 7.265-5.16 17.058.106 24.534.106-2.211.422-4.738 1.263-7.476-.21-.105-.316-.316-.526-.527M197.095 303.778c2.526 2.526 4.948 4.843 7.16 6.738 2-1.158 4.528-.632 6.002 1.158 1.053 1.37 1.158 3.054.632 4.423 1.685 1.37 2.843 2.211 3.685 2.843 1.685-6.212.527-13.162-3.685-18.638-.106-.105-.211-.21-.211-.315-.421.105-5.896-.316-13.583 3.791M209.414 318.308c-2 1.58-4.949 1.159-6.528-.842-1.054-1.475-1.159-3.264-.527-4.844-2.738-2.107-5.58-4.529-8.319-6.95l-.21-.21.21.21c-1.79 1.157-3.685 2.738-5.686 4.528l-.737.738c1.053 2.105.947 4.632-.315 6.528.421.315.736.632 1.158.947 2 1.58 4.001 2.844 5.791 3.897 1.895-1.159 4.317-.844 5.686.947.421.526.632 1.157.737 1.685 5.37 1.58 9.266 1.053 10.636.736 1.052-1.474 1.79-3.053 2.421-4.738-.842-.526-2.212-1.474-4.317-2.947.211.105.105.21 0 .315M199.413 329.364c-1.896 1.475-4.527 1.053-6.002-.842-.632-.948-.947-2-.843-3.054-2.105-1.053-4.212-2.317-6.317-4-.632-.528-1.158-.949-1.79-1.475-.948.421-2 .526-3.054.526-1.474 3.896-1.684 7.477-1.474 9.793 3.896 3.264 8.845 4.95 13.794 4.95 4.633 0 9.161-1.475 13.057-4.423l1.896-1.58c-2.212 0-5.055-.105-8.319-.842-.21.211-.527.632-.948.947" fill="#59B3D8"/>
        <path d="M699.208 317.855c11.863 0 21.48-9.712 21.48-21.69 0-11.982-9.617-21.694-21.48-21.694-11.864 0-21.481 9.712-21.481 21.693 0 11.98 9.617 21.691 21.481 21.691" fill="#FFF"/>
        <path d="M685.096 290.372c1.158-.421 2.422-.526 3.58-.211.21-.315.526-.526.737-.842 2-2.106 4.107-3.896 6.002-5.16-2.316-2.422-4.317-4.844-5.792-7.371a26.308 26.308 0 00-3.685 2.212c-.842.737-1.58 1.369-2.317 2.21-.315 1.685-.421 5.056 1.475 9.162M698.467 282.264c5.896-3.159 11.057-3.159 14.426-2.738-3.896-3.264-8.845-4.949-13.794-4.949-2.211 0-4.423.317-6.634 1.053a188.45 188.45 0 006.002 6.635M682.148 300.48c-1.79-2.422-1.79-5.58 0-7.897-1.476-3.58-1.37-6.529-.844-8.634-4.947 7.264-5.159 17.057.106 24.534.106-2.212.423-4.738 1.264-7.477-.212-.105-.315-.315-.526-.526M702.469 286.37c2.527 2.527 4.949 4.844 7.16 6.739 2-1.158 4.528-.632 6.002 1.158 1.054 1.37 1.158 3.054.632 4.423 1.685 1.369 2.843 2.211 3.685 2.843 1.685-6.213.527-13.162-3.685-18.638-.106-.105-.21-.211-.21-.316-.422.105-5.897-.315-13.584 3.791M714.788 300.9c-2 1.58-4.948 1.158-6.528-.842-1.053-1.474-1.159-3.264-.527-4.844-2.737-2.106-5.58-4.528-8.318-6.95l-.21-.21.21.21c-1.79 1.158-3.686 2.74-5.687 4.53l-.736.735c1.053 2.106.947 4.634-.316 6.53.421.315.737.63 1.158.946 2.001 1.58 4.001 2.843 5.792 3.897 1.894-1.159 4.316-.843 5.685.947.421.527.632 1.158.738 1.685 5.37 1.58 9.266 1.053 10.635.737 1.053-1.475 1.79-3.054 2.421-4.738-.84-.527-2.21-1.475-4.317-2.948.211.104.105.21 0 .315M704.788 311.957c-1.896 1.474-4.528 1.053-6.002-.843-.632-.947-.948-2-.843-3.053-2.106-1.053-4.212-2.317-6.318-4.001-.632-.527-1.158-.948-1.79-1.475-.947.422-2 .527-3.054.527-1.473 3.896-1.684 7.476-1.473 9.792 3.895 3.265 8.844 4.949 13.793 4.949 4.633 0 9.162-1.473 13.057-4.422l1.896-1.58c-2.21 0-5.054-.105-8.319-.841-.21.21-.526.63-.947.947" fill="#59B3D8"/>
        <path d="M987.75 317.855c11.864 0 21.481-9.712 21.481-21.69 0-11.982-9.617-21.694-21.481-21.694-11.863 0-21.48 9.712-21.48 21.693 0 11.98 9.617 21.691 21.48 21.691" fill="#FFF"/>
        <path d="M973.639 290.372c1.158-.421 2.422-.526 3.58-.211.21-.315.526-.526.736-.842 2-2.106 4.108-3.896 6.002-5.16-2.316-2.422-4.316-4.844-5.791-7.371-1.263.632-2.527 1.369-3.685 2.212-.842.737-1.58 1.369-2.317 2.21-.315 1.685-.421 5.056 1.475 9.162M987.01 282.264c5.896-3.159 11.056-3.159 14.426-2.738-3.897-3.264-8.845-4.949-13.794-4.949-2.212 0-4.423.317-6.634 1.053 2 2.317 4 4.529 6.002 6.635M970.69 300.48c-1.79-2.422-1.79-5.58 0-7.897-1.475-3.58-1.369-6.529-.843-8.634-4.949 7.264-5.159 17.057.106 24.534.105-2.212.421-4.738 1.263-7.477-.21-.105-.316-.315-.526-.526M991.012 286.37c2.527 2.527 4.949 4.844 7.16 6.739 2-1.158 4.528-.632 6.002 1.158 1.053 1.37 1.158 3.054.632 4.423 1.685 1.369 2.843 2.211 3.685 2.843 1.685-6.213.527-13.162-3.685-18.638-.106-.105-.211-.211-.211-.316-.421.105-5.896-.315-13.583 3.791M1003.331 300.9c-2 1.58-4.949 1.158-6.528-.842-1.053-1.474-1.159-3.264-.527-4.844-2.738-2.106-5.58-4.528-8.318-6.95l-.21-.21.21.21c-1.79 1.158-3.686 2.74-5.687 4.53l-.737.735c1.054 2.106.948 4.634-.315 6.53.421.315.737.63 1.158.946 2.001 1.58 4.001 2.843 5.791 3.897 1.895-1.159 4.317-.843 5.686.947.421.527.632 1.158.738 1.685 5.37 1.58 9.265 1.053 10.635.737 1.052-1.475 1.79-3.054 2.421-4.738-.842-.527-2.21-1.475-4.317-2.948.211.104.105.21 0 .315M993.33 311.957c-1.896 1.474-4.527 1.053-6.002-.843-.632-.947-.947-2-.842-3.053-2.106-1.053-4.212-2.317-6.318-4.001-.632-.527-1.158-.948-1.79-1.475-.947.422-2 .527-3.054.527-1.473 3.896-1.684 7.476-1.473 9.792 3.895 3.265 8.844 4.949 13.793 4.949 4.633 0 9.162-1.473 13.057-4.422l1.896-1.58c-2.21 0-5.055-.105-8.319-.841-.21.21-.526.63-.948.947" fill="#59B3D8"/>
        <path fill="#EBEBEB" d="M466.85 103.762h37.409V77.037H466.85z"/>
        <path d="M492.155 106.44h-11.692c1.405 4.998-.483 5.715-8.75 5.715v2.618H499.827v-2.618c-8.268 0-9.079-.714-7.672-5.716" fill="#7A7A7A"/>
        <path d="M504.675 74.773h.018-38.082c-.557 0-1.061.224-1.46.572.399-.348.902-.572 1.459-.572h38.065z" fill="#707070"/>
        <path d="M504.7 74.775l-3.914 3.332h3.128v25H471.43l-3.916 3.333h37.16c1.291 0 2.597-1.152 2.597-2.447V77.24c0-1.297-1.289-2.449-2.57-2.465" fill="#3E3E3E"/>
        <path d="M464.272 103.995V77.241a2.531 2.531 0 010 .001v26.753c0 1.295 1.043 2.447 2.336 2.447h.906v-.001h-.906c-1.293 0-2.336-1.152-2.336-2.446" fill="#FFF"/>
        <path d="M467.53 103.105V78.107h33.256l3.913-3.333H466.607c-.556 0-1.059.223-1.46.571a2.542 2.542 0 00-.876 1.895v26.753c0 1.294 1.043 2.447 2.336 2.447h.906l3.916-3.335h-3.9z" fill="#707070"/>
        <path fill="#9FA0A1" d="M471.717 114.772h28.113v-2.618h-28.113z"/>
        <path d="M486.382 76.588c0 .34-.272.615-.61.615a.612.612 0 01-.61-.615.611.611 0 111.22 0" fill="#B7D332"/>
        <path fill="#0078D4" d="M488.111 85.522h12.738v-.866h-12.738zM488.111 90.311h12.738v-.866h-12.738zM488.111 95.1h12.738v-.866h-12.738z"/>
        <path d="M470.486 89.842c0 3.968 3.19 7.185 7.127 7.185 1.686 0 3.23-.593 4.451-1.58l-4.45-5.605h-7.128z" fill="#3C3C41"/>
        <path d="M477.613 89.842l4.451-5.606a7.06 7.06 0 00-4.45-1.578c-3.938 0-7.128 3.216-7.128 7.184h7.127z" fill="#75757A"/>
        <path d="M482.054 84.236l-4.45 5.605v.001l4.45 5.607a7.188 7.188 0 002.678-5.608 7.185 7.185 0 00-2.678-5.605" fill="#50E6FF"/>
        <path d="M871.402 91.465L853.61 73.637c-.789-.791-1.84-1.231-2.893-1.231-1.05 0-2.103.44-2.89 1.23l-17.794 17.829c-.789.79-1.228 1.844-1.228 2.897 0 1.055.44 2.109 1.228 2.899l17.88 17.917c.79.79 1.753 1.228 2.892 1.228 1.052 0 2.105-.438 2.893-1.228l17.881-17.917c.788-.79 1.226-1.757 1.226-2.9-.174-1.052-.613-2.106-1.402-2.896zm-20.686-14.843l5.786 5.796h-4.032v8.432h-3.419v-8.432h-4.119l5.784-5.796zM834.414 96.47v-3.426h7.888v-4.128l5.786 5.797-5.786 5.797v-4.04h-7.888zm16.302 16.335l-5.784-5.796h4.032v-8.256h3.418v8.256h4.12l-5.786 5.796zM867.02 96.47h-7.802v4.128l-5.785-5.796 5.785-5.798v4.04h7.802v3.426z" fill="#0072C6"/>
        <path d="M152.033 485.037h82.138" stroke="#185A97" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#185A97" d="M233.017 481.683l5.809 3.353-5.81 3.354z"/>
        <path d="M344.845 485.037h300.939" stroke="#185A97" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#185A97" d="M644.63 481.683l5.81 3.353-5.81 3.354z"/>
        <path d="M756.499 485.037h175.783" stroke="#185A97" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#185A97" d="M931.128 481.683l5.809 3.353-5.81 3.354z"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M1047.98 688.846v.5h-.5"/>
        <path d="M1044.477 689.346H925.864" stroke="#156AB3" stroke-dasharray="1.001,3.003" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M924.362 689.346h-.5v-.5"/>
        <path d="M923.862 685.854V196.822" stroke="#156AB3" stroke-dasharray="0.997,2.991" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M923.862 195.326v-.5h.5"/>
        <path d="M927.364 194.826h118.614" stroke="#156AB3" stroke-dasharray="1.001,3.003" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M1047.48 194.826h.5v.5"/>
        <path d="M1047.98 198.317V687.35" stroke="#156AB3" stroke-dasharray="0.997,2.991" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M903.475 688.846v.5h-.5"/>
        <path d="M899.972 689.346H781.359" stroke="#156AB3" stroke-dasharray="1.001,3.003" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M779.857 689.346h-.5v-.5"/>
        <path d="M779.357 685.854V196.822" stroke="#156AB3" stroke-dasharray="0.997,2.991" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M779.357 195.326v-.5h.5"/>
        <path d="M782.86 194.826h118.613" stroke="#156AB3" stroke-dasharray="1.001,3.003" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M902.975 194.826h.5v.5"/>
        <path d="M903.475 198.317V687.35" stroke="#156AB3" stroke-dasharray="0.997,2.991" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M761.48 688.846v.5h-.5"/>
        <path d="M757.976 689.346H639.363" stroke="#156AB3" stroke-dasharray="1.001,3.003" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M637.861 689.346h-.5v-.5"/>
        <path d="M637.361 685.854V196.822" stroke="#156AB3" stroke-dasharray="0.997,2.991" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M637.361 195.326v-.5h.5"/>
        <path d="M640.864 194.826h118.613" stroke="#156AB3" stroke-dasharray="1.001,3.003" stroke-linecap="round"/>
        <path stroke="#156AB3" stroke-linecap="round" d="M760.98 194.826h.5v.5"/>
        <path d="M761.48 198.317V687.35" stroke="#156AB3" stroke-dasharray="0.997,2.991" stroke-linecap="round"/>
        <path stroke="#156AB3" d="M351.017 705.12H30.377V121.212h320.64V392.34H618.48V9.99h453.41V709.196l-453.41-.931v-88.02H351.017z"/>
        <path d="M254.798 324.268l539.279-198.677" stroke="#CBCBCB" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#CBCBCB" d="M254.306 320.808l-3.904 5.454 6.675.656z"/>
        <path d="M698.445 260.478l97.236-105.544" stroke="#CBCBCB" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#CBCBCB" d="M696.463 257.6l-1.063 6.623 6.267-2.39z"/>
        <path d="M992.638 260.478l-97.235-105.544" stroke="#CBCBCB" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#CBCBCB" d="M994.621 257.6l1.063 6.623-6.267-2.39z"/>
        <path d="M703.559 426.45l82.613-66.719" stroke="#CBCBCB" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#CBCBCB" d="M702.05 423.297l-2.087 6.375 6.565-1.38z"/>
        <path d="M977.694 426.45l-82.613-66.719" stroke="#CBCBCB" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#CBCBCB" d="M979.202 423.297l2.088 6.375-6.565-1.38z"/>
        <path d="M121.464 547.915l39.096 32.68" stroke="#CBCBCB" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#CBCBCB" d="M119.956 551.068l-2.088-6.375 6.566 1.38z"/>
        <path d="M278.838 547.915l-39.096 32.68" stroke="#CBCBCB" stroke-linecap="round" stroke-width="1.5"/>
        <path fill="#CBCBCB" d="M280.346 551.068l2.088-6.375-6.566 1.38z"/>
        <path d="M535.509 104.298h256.595" stroke="#505055" stroke-width="1.5"/>
        <path fill="#505055" d="M790.948 100.943l5.81 3.354-5.81 3.355z"/>
        <a class="architecture-tooltip-trigger" href="#">
            <circle cx="385.5" cy="557.5" fill="#A5CE00" r="14.5"/>
            <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(381.491 563)">
                1
            </text>
        </a>
        <a class="architecture-tooltip-trigger" href="#">
            <circle cx="849.5" cy="164.5" fill="#A5CE00" r="14.5"/>
            <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(845.491 169)">
                2
            </text>
        </a>
        <a class="architecture-tooltip-trigger" href="#">
            <circle cx="385.5" cy="506.5" fill="#A5CE00" r="14.5"/>
            <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(382.491 511)">
                3
            </text>
        </a>
        <a class="architecture-tooltip-trigger" href="#">
            <circle cx="848.5" cy="508.5" fill="#A5CE00" r="14.5"/>
            <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(844.491 513)">
                4
            </text>
        </a>
        <path d="M971.592 603.75c-.754 0-1.592-.755-1.592-1.595v.002c0 .838.586 1.593 1.592 1.593h38.695c.838 0 1.592-.587 1.592-1.593v-27.778h-11.28l-27.248 29.371h-1.76z" fill="#A0A1A2"/>
        <path d="M971.592 568c-1.006 0-1.592.755-1.592 1.595 0-.84.838-1.595 1.592-1.595M1011.879 574.378v-4.784c0-.839-.586-1.594-1.592-1.594h-3.768l-5.917 6.378h11.277z" fill="#7A7A7A"/>
        <path fill="#FFF" d="M970 574.378v.001h30.6l.002-.001z"/>
        <path d="M970 575.804v26.352c0 .838.838 1.594 1.592 1.594h1.759l27.249-29.37H970v1.424z" fill="#A0A1A2"/>
        <path d="M970 575.804v26.352c0 .838.838 1.594 1.592 1.594h1.759l27.249-29.37H970v1.424z" fill="#B3B4B5"/>
        <path d="M1006.518 568h-34.927c-.754 0-1.592.755-1.592 1.595v4.783h30.602l5.917-6.378z" fill="#7A7A7A"/>
        <path d="M1006.518 568h-34.927c-.754 0-1.592.755-1.592 1.595v4.783h30.602l5.917-6.378z" fill="#959595"/>
        <path fill="#FFF" d="M985.746 583.524H996.3v-6.378h-10.554z"/>
        <path fill="#FCD116" d="M985.746 592.169H996.3v-6.378h-10.554zM998.308 592.169h10.554v-6.378h-10.554z"/>
        <path fill="#FFF" d="M998.308 583.524h10.554v-6.378h-10.554zM973.183 583.524h10.554v-6.378h-10.554zM973.183 592.169h10.554v-6.378h-10.554z"/>
        <path fill="#FCD116" d="M973.183 600.729h10.554v-6.378h-10.554zM985.746 600.729H996.3v-6.378h-10.554zM998.308 600.729h10.554v-6.378h-10.554z"/>
        <path d="M683.592 603.75c-.754 0-1.592-.755-1.592-1.595v.002c0 .838.586 1.593 1.592 1.593h38.695c.838 0 1.592-.587 1.592-1.593v-27.778H712.6l-27.249 29.371h-1.759z" fill="#A0A1A2"/>
        <path d="M683.592 568c-1.006 0-1.592.755-1.592 1.595 0-.84.838-1.595 1.592-1.595M723.88 574.378v-4.784c0-.839-.587-1.594-1.593-1.594h-3.768l-5.917 6.378h11.277z" fill="#7A7A7A"/>
        <path fill="#FFF" d="M682 574.378v.001h30.6l.002-.001z"/>
        <path d="M682 575.804v26.352c0 .838.838 1.594 1.592 1.594h1.76l27.249-29.37H682v1.424z" fill="#A0A1A2"/>
        <path d="M682 575.804v26.352c0 .838.838 1.594 1.592 1.594h1.76l27.249-29.37H682v1.424z" fill="#B3B4B5"/>
        <path d="M718.519 568h-34.927c-.754 0-1.592.755-1.592 1.595v4.783h30.602l5.917-6.378z" fill="#7A7A7A"/>
        <path d="M718.519 568h-34.927c-.754 0-1.592.755-1.592 1.595v4.783h30.602l5.917-6.378z" fill="#959595"/>
        <path fill="#FFF" d="M697.747 583.524H708.3v-6.378h-10.554z"/>
        <path fill="#FCD116" d="M697.747 592.169H708.3v-6.378h-10.554zM710.309 592.169h10.554v-6.378h-10.554z"/>
        <path fill="#FFF" d="M710.309 583.524h10.554v-6.378h-10.554zM685.184 583.524h10.554v-6.378h-10.554zM685.184 592.169h10.554v-6.378h-10.554z"/>
        <path fill="#FCD116" d="M685.184 600.729h10.554v-6.378h-10.554zM697.747 600.729H708.3v-6.378h-10.554zM710.309 600.729h10.554v-6.378h-10.554z"/>
    </g>
</svg>

<div class="architecture-tooltip-content" id="architecture-tooltip-1">
<p>Connect your Azure environment with your on-premises network via site-to-site VPN or ExpressRoute.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-2">
<p>Use Azure Load Balancer to migrate and balance traffic between the on-prem AppServer and your Azure AppServer.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-3">
<p>Use DataGuard to mark your OracleDB1 in Azure as your active stand-by.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-4">
<p>Switch your OracleDB1 in Azure as primary and set up your OracleDB2 in Azure as your standby to finish your migration. NOTE: This method only works when migrating to and from the same OS version and DB version. Assumption: customer is using DataGuard on-premises.</p>
</div>

## Data Flow
1. Connect your Azure environment with your on-premises network via site-to-site VPN or ExpressRoute.

1. Use Azure Load Balancer to migrate and balance traffic between the on-prem AppServer and your Azure AppServer.

1. Use DataGuard to mark your OracleDB1 in Azure as your active stand-by.

1. Switch your OracleDB1 in Azure as primary and set up your OracleDB2 in Azure as your standby to finish your migration. NOTE: This method only works when migrating to and from the same OS version and DB version. Assumption: customer is using DataGuard on-premises.

[!INCLUDE [js_include_file](../../_js/index.md)]
