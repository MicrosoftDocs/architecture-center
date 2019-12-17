---
title: SMB disaster recovery with Azure Site Recovery
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Small and medium businesses can inexpensively implement disaster recovery to the cloud by using Azure Site Recovery or a partner solution like Double-Take DR.
ms.custom: acom-architecture, bcdr, 'https://azure.microsoft.com/solutions/architecture/disaster-recovery-smb-azure-site-recovery/'
---
# SMB disaster recovery with Azure Site Recovery

[!INCLUDE [header_file](../header.md)]

Small and medium businesses can inexpensively implement disaster recovery to the cloud by using Azure Site Recovery or a partner solution like Double-Take DR.

This solution is built on the Azure managed services: [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/), [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) and [Virtual Network](https://azure.microsoft.com/services/virtual-network/). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

<svg class="architecture-diagram" aria-labelledby="disaster-recovery-smb-azure-site-recovery" height="443.187" viewbox="0 0 825.047 443.187"  xmlns="http://www.w3.org/2000/svg">
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M183.889 33.71h130.759"/>
    <path fill="#b5b5b5" d="M313.449 37.805l7.093-4.095-7.093-4.096v8.191z"/>
    <path fill="#ededed" opacity=".5" d="M463.047 128.187h362v315h-362zM.001 128.187h282v315h-282z"/>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M386.169 99.009v12.72H620.87v11.062"/>
    <path fill="#b5b5b5" d="M616.774 121.592l4.096 7.093 4.095-7.093h-8.191z"/>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M357.87 99.009v12.72H151.169v11.062"/>
    <path fill="#b5b5b5" d="M147.073 121.592l4.096 7.093 4.095-7.093h-8.191z"/>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M410.519 239.781h72.826"/>
    <path fill="#b5b5b5" d="M482.147 243.877l7.093-4.096-7.093-4.095v8.191z"/>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M219.126 239.781h110.219"/>
    <path fill="#b5b5b5" d="M328.147 243.877l7.093-4.096-7.093-4.095v8.191z"/>
    <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(727.851 121.207)">
        Azure <tspan letter-spacing="-.034em" x="33.691" y="0">F</tspan><tspan x="39.141" y="0">ailover Site</tspan>
    </text>
    <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(732.095 157.067)">
        <tspan letter-spacing="-.029em">R</tspan><tspan x="6.826" y="0">ecovery VMs</tspan>
    </text>
    <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(0 121.207)">
        Primary Site (On-Premise)
    </text>
    <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(210 105.207)">
        Before <tspan letter-spacing="-.034em" x="37.676" y="0">F</tspan><tspan x="43.125" y="0">ailover</tspan>
    </text>
    <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(459.518 105.207)">
        After <tspan letter-spacing="-.034em" x="29.297" y="0">F</tspan><tspan x="34.746" y="0">ailover</tspan>
    </text>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M197.519 326.637h21.607V169.711h-21.607M600.245 239.781h-36.114M615.958 169.712h-15.713v156.924h15.713"/>
    <path fill="#b5b5b5" d="M614.759 165.616l7.093 4.096-7.093 4.095v-8.191zM614.759 330.732l7.093-4.096-7.093-4.095v8.191z"/>
    <g fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" opacity=".5">
        <path d="M812.737 392.187v3h-3"/>
        <path stroke-dasharray="6.159 6.159" d="M803.578 395.187H584.922"/>
        <path d="M581.842 395.187h-3v-3"/>
        <path stroke-dasharray="6.041 6.041" d="M578.842 386.146V147.541"/>
        <path d="M578.842 144.52v-3h3"/>
        <path stroke-dasharray="6.159 6.159" d="M588.001 141.52h218.657"/>
        <path d="M809.737 141.52h3v3"/>
        <path stroke-dasharray="6.041 6.041" d="M812.737 150.561v238.606"/>
    </g>
    <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(744.758 272.644)">
        *VMs <tspan x="0" y="14.4">aren&apos;t </tspan><tspan x="0" y="28.8">created </tspan><tspan x="0" y="43.2">until </tspan><tspan x="0" y="57.6">failover </tspan><tspan x="0" y="72">occurs</tspan>
    </text>
    <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(136.325 215.479)">
        IIS VM
    </text>
    <path d="M159.867 190.7h-12.115c1.456 5.139-.5 5.876-9.066 5.876v2.691h29.13v-2.691c-8.566 0-9.407-.734-7.949-5.876" fill="#7a7a7a"/>
    <path d="M172.835 158.143H133.4a2.52 2.52 0 00-2.421 2.537v27.5a2.506 2.506 0 002.421 2.52h39.439a2.753 2.753 0 002.692-2.515v-27.5a2.763 2.763 0 00-2.692-2.537" fill="#a0a1a2"/>
    <path d="M172.862 158.146H133.4a2.519 2.519 0 00-2.421 2.537v27.5a2.506 2.506 0 002.421 2.517h.938z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path fill="#59b4d9" d="M172.049 161.572v25.698h-37.698v-25.698h37.698z"/>
    <path fill="#59b4d9" d="M134.351 187.27h.052v-25.697l34.465-.052h.002l-34.519.052v25.697z"/>
    <path fill="#a0a1a2" d="M138.686 196.571h29.13v2.692h-29.13z"/>
    <path d="M153.711 160.01a.632.632 0 11-.633-.633.633.633 0 01.633.633" fill="#b8d432"/>
    <path d="M153.736 173.641a.248.248 0 01-.119-.034l-7.845-4.528a.241.241 0 01-.118-.206.238.238 0 01.118-.2l7.8-4.5a.239.239 0 01.234 0l7.847 4.53a.238.238 0 010 .41l-7.795 4.5a.24.24 0 01-.12.034" fill="#fff"/>
    <path d="M152.609 184.647a.224.224 0 01-.119-.032l-7.821-4.514a.232.232 0 01-.121-.206v-9.058a.241.241 0 01.36-.206l7.821 4.512a.249.249 0 01.116.208v9.058a.242.242 0 01-.116.206.25.25 0 01-.119.032" fill="#fff" opacity=".7" style="isolation:isolate"/>
    <path d="M154.823 184.647a.256.256 0 01-.123-.032.241.241 0 01-.115-.206v-9a.246.246 0 01.115-.206l7.821-4.512a.232.232 0 01.235 0 .235.235 0 01.12.2v9a.233.233 0 01-.12.206l-7.818 4.514a.211.211 0 01-.115.032" fill="#fff" opacity=".4" style="isolation:isolate"/>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(124.776 363.669)">
            SQL Server<tspan x="4.992" y="14.4">2016 VM</tspan>
        </text>
        <path d="M154.228 333.807H143.8c1.253 4.424-.43 5.058-7.8 5.058v2.316h25.07v-2.316c-7.373 0-8.1-.632-6.842-5.058" fill="#7a7a7a"/>
        <path d="M165.39 305.788h-33.947a2.169 2.169 0 00-2.084 2.183v23.673a2.157 2.157 0 002.084 2.165h33.947a2.37 2.37 0 002.317-2.165v-23.673a2.378 2.378 0 00-2.317-2.183" fill="#a0a1a2"/>
        <path d="M165.414 305.79H131.443a2.168 2.168 0 00-2.084 2.183v23.672a2.157 2.157 0 002.084 2.166h.808z" fill="#fff" opacity=".2" style="isolation:isolate"/>
        <path fill="#59b4d9" d="M164.714 308.739v22.12h-32.448v-22.12h32.448z"/>
        <path fill="#59b4d9" d="M132.266 330.859h.044V308.74l29.666-.045h.001l-29.711.045v22.119z"/>
        <path fill="#a0a1a2" d="M135.997 338.865h25.073v2.317h-25.073z"/>
        <path d="M148.93 307.395a.544.544 0 11-.545-.545.545.545 0 01.545.545" fill="#b8d432"/>
        <path d="M148.951 319.128a.213.213 0 01-.1-.029l-6.752-3.9a.208.208 0 01-.1-.177.2.2 0 01.1-.176l6.712-3.872a.205.205 0 01.2 0l6.754 3.9a.205.205 0 010 .353l-6.709 3.872a.207.207 0 01-.1.029" fill="#fff"/>
        <path d="M147.981 328.6a.193.193 0 01-.1-.028l-6.732-3.885a.2.2 0 01-.1-.177v-7.8a.207.207 0 01.31-.177l6.731 3.884a.214.214 0 01.1.179v7.8a.208.208 0 01-.1.177.215.215 0 01-.1.028" fill="#fff" opacity=".7" style="isolation:isolate"/>
        <path d="M149.887 328.6a.22.22 0 01-.106-.028.208.208 0 01-.1-.177v-7.748a.212.212 0 01.1-.177l6.731-3.884a.2.2 0 01.2 0 .2.2 0 01.1.176v7.747a.2.2 0 01-.1.177l-6.729 3.885a.181.181 0 01-.1.028" fill="#fff" opacity=".4" style="isolation:isolate"/>
        <g>
            <path d="M154.025 320.633v21.325c0 2.214 4.956 4.009 11.068 4.009v-25.334z" fill="#0072c6"/>
            <path d="M164.941 345.966h.152c6.113 0 11.068-1.794 11.068-4.008v-21.325h-11.22z" fill="#0072c6"/>
            <path d="M164.941 345.966h.152c6.113 0 11.068-1.794 11.068-4.008v-21.325h-11.22z" fill="#fff" opacity=".15" style="isolation:isolate"/>
            <path d="M176.161 320.633c0 2.214-4.956 4.008-11.068 4.008s-11.068-1.795-11.068-4.008 4.956-4.008 11.068-4.008 11.068 1.795 11.068 4.008" fill="#fff"/>
            <path d="M173.9 320.4c0 1.462-3.942 2.645-8.805 2.645s-8.806-1.183-8.806-2.645 3.943-2.645 8.806-2.645 8.805 1.184 8.805 2.645" fill="#7fba00"/>
            <path d="M172.053 322.018c1.153-.447 1.845-1.007 1.845-1.615 0-1.462-3.942-2.646-8.806-2.646s-8.805 1.184-8.805 2.646c0 .608.693 1.168 1.845 1.615a24.074 24.074 0 0113.92 0" fill="#b8d432"/>
            <path d="M161.577 335.435a1.818 1.818 0 01-.721 1.54 3.233 3.233 0 01-1.992.546 3.789 3.789 0 01-1.808-.39v-1.559a2.789 2.789 0 001.846.712 1.256 1.256 0 00.753-.195.61.61 0 00.266-.517.723.723 0 00-.256-.55 4.7 4.7 0 00-1.04-.6 2.292 2.292 0 01-1.6-2.046 1.847 1.847 0 01.7-1.508 2.842 2.842 0 011.851-.567 4.624 4.624 0 011.7.268v1.456a2.763 2.763 0 00-1.607-.487 1.19 1.19 0 00-.716.192.606.606 0 00-.263.514.734.734 0 00.212.543 3.428 3.428 0 00.869.524 4.307 4.307 0 011.4.94 1.751 1.751 0 01.406 1.184zM169.093 333.857a3.985 3.985 0 01-.56 2.138 2.99 2.99 0 01-1.578 1.271l2.026 1.876h-2.046l-1.447-1.622a3.392 3.392 0 01-1.678-.492 3.083 3.083 0 01-1.154-1.254 3.849 3.849 0 01-.407-1.776 4.15 4.15 0 01.441-1.936 3.131 3.131 0 011.24-1.308 3.622 3.622 0 011.832-.458 3.37 3.37 0 011.727.443 3.024 3.024 0 011.182 1.261 3.987 3.987 0 01.422 1.857zm-1.656.088a2.733 2.733 0 00-.463-1.678 1.5 1.5 0 00-1.267-.617 1.59 1.59 0 00-1.31.618 3.006 3.006 0 00-.01 3.28 1.55 1.55 0 001.281.611 1.571 1.571 0 001.291-.592 2.51 2.51 0 00.478-1.622zM174.407 337.398h-4.159v-6.984h1.573v5.708h2.586v1.276z" fill="#fff"/>
        </g>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(479.773 431.273)">
            Virtual Network
        </text>
        <path d="M540.276 404.95a1.081 1.081 0 000-1.422l-1.9-1.9-8.532-8.295a.909.909 0 00-1.343 0 .939.939 0 000 1.422l8.927 8.769a1 1 0 010 1.422l-9.085 9.085a1 1 0 000 1.422.978.978 0 001.343 0l8.453-8.374.079-.079zM501.25 404.95a1.081 1.081 0 010-1.422l1.9-1.9 8.532-8.295a.909.909 0 011.343 0 .939.939 0 010 1.422l-8.769 8.769a1 1 0 000 1.422l8.927 9.085a1 1 0 010 1.422.978.978 0 01-1.343 0l-8.611-8.295-.079-.079z" fill="#3999c6"/>
        <path d="M515.391 404.239a2.629 2.629 0 01-2.607 2.607 2.891 2.891 0 01-2.765-2.607 2.667 2.667 0 012.765-2.607 2.578 2.578 0 012.607 2.607zM523.37 404.239a2.629 2.629 0 01-2.607 2.607 2.891 2.891 0 01-2.763-2.607 2.773 2.773 0 012.765-2.607 2.629 2.629 0 012.605 2.607z" fill="#7fba00"/>
        <circle cx="528.821" cy="404.239" fill="#7fba00" r="2.607"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(632.737 363.429)">
            SQL Server<tspan x="2.49" y="14.4">2016 VM*</tspan>
        </text>
        <path d="M662.171 334.029h-10.427c1.253 4.424-.43 5.058-7.8 5.058v2.313h25.073v-2.316c-7.373 0-8.1-.632-6.842-5.058" fill="#7a7a7a"/>
        <path d="M673.334 306.009h-33.947a2.169 2.169 0 00-2.084 2.183v23.673a2.157 2.157 0 002.084 2.165h33.947a2.37 2.37 0 002.317-2.165v-23.672a2.378 2.378 0 00-2.317-2.183" fill="#a0a1a2"/>
        <path d="M673.357 306.012H639.386a2.168 2.168 0 00-2.084 2.183v23.672a2.157 2.157 0 002.084 2.166h.808z" fill="#fff" opacity=".2" style="isolation:isolate"/>
        <path fill="#59b4d9" d="M672.657 308.96v22.12h-32.448v-22.12h32.448z"/>
        <path fill="#59b4d9" d="M640.209 331.08h.045v-22.119l29.665-.044h.002l-29.712.044v22.119z"/>
        <path fill="#a0a1a2" d="M643.94 339.086h25.073v2.317H643.94z"/>
        <path d="M656.873 307.616a.544.544 0 11-.545-.545.545.545 0 01.545.545" fill="#b8d432"/>
        <path d="M656.895 319.35a.213.213 0 01-.1-.029l-6.752-3.9a.208.208 0 01-.1-.177.2.2 0 01.1-.176l6.712-3.872a.205.205 0 01.2 0l6.754 3.9a.205.205 0 010 .353L657 319.32a.207.207 0 01-.1.029" fill="#fff"/>
        <path d="M655.925 328.823a.193.193 0 01-.1-.028l-6.732-3.885a.2.2 0 01-.1-.177v-7.8a.207.207 0 01.31-.177l6.731 3.884a.214.214 0 01.1.179v7.8a.208.208 0 01-.1.177.215.215 0 01-.1.028" fill="#fff" opacity=".7" style="isolation:isolate"/>
        <path d="M657.831 328.823a.22.22 0 01-.106-.028.208.208 0 01-.1-.177v-7.748a.212.212 0 01.1-.177l6.731-3.884a.2.2 0 01.2 0 .2.2 0 01.1.176v7.747a.2.2 0 01-.1.177l-6.726 3.891a.181.181 0 01-.1.028" fill="#fff" opacity=".4" style="isolation:isolate"/>
        <g>
            <path d="M661.968 320.854v21.325c0 2.214 4.956 4.009 11.068 4.009v-25.334z" fill="#0072c6"/>
            <path d="M672.885 346.187h.152c6.113 0 11.068-1.794 11.068-4.008v-21.325h-11.22z" fill="#0072c6"/>
            <path d="M672.885 346.187h.152c6.113 0 11.068-1.794 11.068-4.008v-21.325h-11.22z" fill="#fff" opacity=".15" style="isolation:isolate"/>
            <path d="M684.1 320.854c0 2.214-4.956 4.008-11.068 4.008s-11.068-1.795-11.068-4.008 4.956-4.008 11.068-4.008 11.068 1.795 11.068 4.008" fill="#fff"/>
            <path d="M681.842 320.623c0 1.462-3.942 2.645-8.805 2.645s-8.806-1.183-8.806-2.645 3.943-2.645 8.806-2.645 8.805 1.184 8.805 2.645" fill="#7fba00"/>
            <path d="M680 322.24c1.153-.447 1.845-1.007 1.845-1.615 0-1.462-3.942-2.646-8.806-2.646s-8.805 1.184-8.805 2.646c0 .608.693 1.168 1.845 1.615a24.074 24.074 0 0113.92 0" fill="#b8d432"/>
            <path d="M669.521 335.656a1.818 1.818 0 01-.721 1.54 3.233 3.233 0 01-1.992.546 3.789 3.789 0 01-1.808-.39v-1.559a2.789 2.789 0 001.846.712 1.256 1.256 0 00.753-.195.61.61 0 00.266-.517.723.723 0 00-.256-.55 4.7 4.7 0 00-1.04-.6 2.292 2.292 0 01-1.6-2.046 1.847 1.847 0 01.7-1.508 2.842 2.842 0 011.851-.567 4.624 4.624 0 011.7.268v1.456a2.763 2.763 0 00-1.607-.487 1.19 1.19 0 00-.716.192.606.606 0 00-.263.514.734.734 0 00.212.543 3.428 3.428 0 00.869.524 4.307 4.307 0 011.4.94 1.751 1.751 0 01.406 1.184zM677.037 334.078a3.985 3.985 0 01-.56 2.138 2.99 2.99 0 01-1.578 1.271l2.026 1.876h-2.046l-1.447-1.622a3.392 3.392 0 01-1.678-.492A3.083 3.083 0 01670.6 336a3.849 3.849 0 01-.407-1.776 4.15 4.15 0 01.441-1.936 3.131 3.131 0 011.24-1.308 3.622 3.622 0 011.832-.458 3.37 3.37 0 011.727.443 3.024 3.024 0 011.183 1.261 3.987 3.987 0 01.421 1.852zm-1.656.088a2.733 2.733 0 00-.463-1.678 1.5 1.5 0 00-1.267-.617 1.59 1.59 0 00-1.31.618 3.006 3.006 0 00-.01 3.28 1.55 1.55 0 001.281.611 1.571 1.571 0 001.291-.592 2.51 2.51 0 00.478-1.622zM682.351 337.62h-4.16v-6.985h1.573v5.709h2.587v1.276z" fill="#fff"/>
        </g>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(641.063 215.415)">
            IIS VM*
        </text>
        <path d="M667.931 190.7h-12.114c1.456 5.139-.5 5.876-9.066 5.876v2.691h29.13v-2.691c-8.566 0-9.407-.734-7.949-5.876" fill="#7a7a7a"/>
        <path d="M680.9 158.143h-39.44a2.52 2.52 0 00-2.421 2.537v27.5a2.506 2.506 0 002.421 2.515h39.44a2.753 2.753 0 002.692-2.515v-27.5a2.763 2.763 0 00-2.692-2.537" fill="#a0a1a2"/>
        <path d="M680.927 158.146H641.459a2.519 2.519 0 00-2.421 2.537v27.5a2.506 2.506 0 002.421 2.516h.938z" fill="#fff" opacity=".2" style="isolation:isolate"/>
        <path fill="#59b4d9" d="M680.113 161.572v25.698h-37.698v-25.698h37.698z"/>
        <path fill="#59b4d9" d="M642.415 187.27h.052v-25.697l34.465-.052h.002l-34.519.052v25.697z"/>
        <path fill="#a0a1a2" d="M646.75 196.571h29.13v2.692h-29.13z"/>
        <path d="M661.776 160.01a.632.632 0 11-.633-.633.633.633 0 01.633.633" fill="#b8d432"/>
        <path d="M661.8 173.641a.248.248 0 01-.119-.034l-7.845-4.528a.241.241 0 01-.118-.206.238.238 0 01.118-.2l7.8-4.5a.239.239 0 01.234 0l7.847 4.53a.238.238 0 010 .41l-7.795 4.5a.24.24 0 01-.12.034" fill="#fff"/>
        <path d="M660.674 184.647a.224.224 0 01-.119-.032l-7.821-4.514a.232.232 0 01-.121-.206v-9.058a.241.241 0 01.36-.206l7.821 4.512a.249.249 0 01.116.208v9.058a.242.242 0 01-.116.206.25.25 0 01-.119.032" fill="#fff" opacity=".7" style="isolation:isolate"/>
        <path d="M662.888 184.647a.256.256 0 01-.123-.032.241.241 0 01-.115-.206v-9a.246.246 0 01.115-.206l7.821-4.512a.232.232 0 01.235 0 .235.235 0 01.12.2v9a.233.233 0 01-.12.206L663 184.615a.211.211 0 01-.115.032" fill="#fff" opacity=".4" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(494.383 277.969)">
            Blob <tspan letter-spacing="-.032em" x="27.158" y="0">S</tspan><tspan x="33.146" y="0">torage</tspan>
        </text>
        <path d="M504.283 258.877a1.787 1.787 0 001.711 1.806h44.018a1.805 1.805 0 001.806-1.806v-31.468h-47.535z" fill="#a0a1a2"/>
        <path d="M550.012 220.088h-44.018a1.787 1.787 0 00-1.711 1.806v5.419h47.535v-5.419a1.805 1.805 0 00-1.806-1.806" fill="#7a7a7a"/>
        <path fill="#0072c6" d="M507.801 230.641h19.394V243h-19.394zM507.801 244.712h19.394v12.359h-19.394z"/>
        <path fill="#fff" d="M528.906 230.641h19.299V243h-19.299z"/>
        <path fill="#0072c6" d="M528.906 244.712h19.299v12.359h-19.299z"/>
        <path d="M506.184 220.088a1.907 1.907 0 00-1.9 1.9v36.7a1.907 1.907 0 001.9 1.9h2.092l37.458-40.5z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(120.121 77.733)">
            Customers
        </text>
        <path d="M164.228 30.007a8.158 8.158 0 11-8.159-8.158 8.158 8.158 0 018.159 8.158M162.034 40.961l-5.965 8.358-5.965-8.358h-6.207V61.57h24.345V40.961h-6.208zM139.71 43.7a4.584 4.584 0 11-4.584-4.583 4.582 4.582 0 014.584 4.583M138.477 49.993l-3.351 4.696-3.351-4.696h-3.487V61.57h13.676V49.993h-3.487z" fill="#59b4d9"/>
        <path d="M147.911 30.007a8.153 8.153 0 007.958 8.148l2.049-16.087a8.132 8.132 0 00-10.007 7.939M150.106 40.961h-6.21V61.57h9.029l1.801-14.132-4.62-6.477zM130.543 43.7a4.582 4.582 0 004.583 4.582c.16 0 .309-.03.465-.046l1.124-8.82a4.55 4.55 0 00-6.172 4.284M131.776 49.993h-3.488V61.57h5.643l.926-7.259-3.081-4.318z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(331.042 77.733)">
            <tspan letter-spacing="-.087em">T</tspan><tspan x="5.244" y="0">raffic Manager</tspan><tspan x="3.144" y="14.4">(DNS </tspan><tspan letter-spacing="-.029em" x="33.817" y="14.4">R</tspan><tspan x="40.644" y="14.4">outing)</tspan>
        </text>
        <path fill="#804998" d="M399.051 44.628V22.061l-15.79-15.742h-22.344l-15.823 16.218v22.011l15.79 15.727h22.377l15.79-15.647z"/>
        <path d="M382.365 8.477h-20.557L347.253 23.4v20.25l14.527 14.467h20.586l14.526-14.4V22.96zm-1.225 46.661h-.164L368.8 42.787l2.57-2.873h-8.82v9.045l2.889-3.11 9.57 9.289h-12l-12.778-12.727V24.61l3.585-3.676 9.528 8.584-5.427 5.634h17.33V17.936l-5.665 5.649-9.589-8.985 3.071-3.148h18.07l12.78 12.748v15.908l-6.067-5.717 4.444-4h-12.284v11.6l4.014-3.983 6.872 7.462z" fill="#fff" opacity=".8" style="isolation:isolate"/>
        <path fill="#fff" opacity=".2" style="isolation:isolate" d="M391.385 14.419l-8.124-8.1h-22.344l-15.823 16.218v22.012l8.097 8.063 38.194-38.193z"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(336.777 277.415)">
            Site <tspan letter-spacing="-.029em" x="22.91" y="0">R</tspan><tspan x="29.736" y="0">ecovery</tspan>
        </text>
        <path d="M375.694 230.174a12.262 12.262 0 0112.178 10.708 13.762 13.762 0 013.464 3.989 9.116 9.116 0 006.929-8.924 8.4 8.4 0 00-5.144-7.769v-1.155a11.2 11.2 0 00-11.128-11.123 11.384 11.384 0 00-9.134 4.619 8.51 8.51 0 00-12.913 6.3 13.385 13.385 0 012.1-.1c3.254 0 6.929.525 9.973 3.779z" fill="#59b4d9"/>
        <path d="M384.2 242.982v-.63a8.423 8.423 0 00-8.4-8.4 9.115 9.115 0 00-4.094 1.05c-.1.1-.315.1-.42.21l-.1-.1a9.3 9.3 0 00-3.569 7.454h3.674l-5.564 6.614-5.669-6.614h3.779a14.088 14.088 0 014.409-10.183 11.245 11.245 0 00-17.322 9.239v1.155a8.474 8.474 0 00-5.039 7.769c0 5.249 4.2 9.239 9.658 9.239h23.831a9.351 9.351 0 009.658-9.239 8.1 8.1 0 00-4.832-7.564z" fill="#0072c6"/>
    </g>
</svg>

## Components
* DNS traffic is routed via [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) which can easily move traffic from one site to another based on policies defined by your organization.
* [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) orchestrates the replication of machines and manages the configuration of the failback procedures.
* [Virtual Network](https://azure.microsoft.com/services/virtual-network/): The virtual network is where the failover site will be created when a disaster occurs.
* [Blob storage](https://azure.microsoft.com/services/storage/blobs/) stores the replica images of all machines that are protected by Site Recovery.

## Next Steps
* [Configure Failover routing method](/api/Redirect/documentation/articles/traffic-manager-configure-failover-routing-method/)
* [How does Azure Site Recovery work?](/api/Redirect/documentation/articles/site-recovery-components/)
* [Designing your network infrastructure for disaster recovery](/api/Redirect/documentation/articles/site-recovery-network-design/)
* [Introduction to Microsoft Azure Storage](/api/Redirect/documentation/articles/storage-introduction/)

[!INCLUDE [js_include_file](../../_js/index.md)]
