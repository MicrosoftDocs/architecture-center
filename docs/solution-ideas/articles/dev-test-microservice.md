---
title: Dev-Test deployment for testing microservice solutions
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: This architecture represents how to configure your infrastructure for development and testing of a microservices-based system.
ms.custom: acom-architecture, devops, microservices, 'https://azure.microsoft.com/solutions/architecture/dev-test-microservice/'
---
# Dev-Test deployment for testing microservice solutions

[!INCLUDE [header_file](../header.md)]

This architecture represents how to configure your infrastructure for development and testing of a microservices-based system.

This solution is built on the Azure managed services: [Azure DevOps](https://azure.microsoft.com/services/devops/), [Service Fabric](https://azure.microsoft.com/services/service-fabric/) and [Azure SQL Database](https://azure.microsoft.com/services/sql-database/). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

<svg class="architecture-diagram" aria-labelledby="dev-test-microservice" height="591.775" viewbox="0 0 825.046 591.775"  xmlns="http://www.w3.org/2000/svg">
    <path fill="#ededed" opacity=".5" d="M280.048 150.108h265.376v441.667H280.048zM559.67 150.108h265.376v441.667H559.67z"/>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M303.888 35.631h60.759"/>
    <path fill="#b5b5b5" d="M363.448 39.726l7.093-4.095-7.093-4.096v8.191z"/>
    <path fill="#ededed" opacity=".5" d="M0 150.108h265.376v441.667H0z"/>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M132.688 144.712V123.65h559.67v21.062"/>
    <path fill="#b5b5b5" d="M136.783 143.514l-4.095 7.092-4.096-7.092h8.191zM688.263 143.514l4.095 7.092 4.096-7.092h-8.191z"/>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M510.333 476.825v28.955H378.76v-42.955M792.591 476.825v50.95h-38.855"/>
    <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(417.371 117.651)">
        ARM Infrastructure and<tspan x="0" y="20">Service Fabric Code Deployment</tspan>
    </text>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M412.867 100.775v43.439"/>
    <path fill="#b5b5b5" d="M408.771 143.015l4.096 7.093 4.095-7.093h-8.191z"/>
    <g fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" opacity=".5">
        <path d="M810.736 306.951v3h-3"/>
        <path stroke-dasharray="6.159 6.159" d="M801.577 309.951H582.92"/>
        <path d="M579.841 309.951h-3v-3"/>
        <path stroke-dasharray="5.971 5.971" d="M576.841 300.979v-92.552"/>
        <path d="M576.841 205.441v-3h3"/>
        <path stroke-dasharray="6.159 6.159" d="M586 202.441h218.657"/>
        <path d="M807.736 202.441h3v3"/>
        <path stroke-dasharray="5.971 5.971" d="M810.736 211.412v92.553"/>
    </g>
    <circle cx="644.432" cy="272.873" fill="#fcd116" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(638.4 277.915)">
        S1
    </text>
    <circle cx="709.42" cy="272.873" fill="#b8d432" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(703.384 277.915)">
        S2
    </text>
    <circle cx="774.407" cy="272.873" fill="#ff8c00" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(768.371 277.915)">
        S3
    </text>
    <g fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" opacity=".5">
        <path d="M531.126 306.951v3h-3"/>
        <path stroke-dasharray="6.159 6.159" d="M521.967 309.951H303.311"/>
        <path d="M300.231 309.951h-3v-3"/>
        <path stroke-dasharray="5.971 5.971" d="M297.231 300.979v-92.552"/>
        <path d="M297.231 205.441v-3h3"/>
        <path stroke-dasharray="6.159 6.159" d="M306.39 202.441h218.657"/>
        <path d="M528.126 202.441h3v3"/>
        <path stroke-dasharray="5.971 5.971" d="M531.126 211.412v92.553"/>
    </g>
    <circle cx="364.823" cy="272.873" fill="#fcd116" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(358.791 277.915)">
        S1
    </text>
    <circle cx="429.81" cy="272.873" fill="#b8d432" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(423.774 277.915)">
        S2
    </text>
    <circle cx="494.797" cy="272.873" fill="#ff8c00" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(488.761 277.915)">
        S3
    </text>
    <g fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" opacity=".5">
        <path d="M467.126 456.951v3h-3"/>
        <path stroke-dasharray="6.07 6.07" d="M458.056 459.951h-154.79"/>
        <path d="M300.231 459.951h-3v-3"/>
        <path stroke-dasharray="5.971 5.971" d="M297.231 450.979v-92.552"/>
        <path d="M297.231 355.441v-3h3"/>
        <path stroke-dasharray="6.07 6.07" d="M306.301 352.441h154.79"/>
        <path d="M464.126 352.441h3v3"/>
        <path stroke-dasharray="5.971 5.971" d="M467.126 361.412v92.553"/>
    </g>
    <circle cx="364.823" cy="422.873" fill="#fcd116" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(358.791 427.915)">
        S1
    </text>
    <circle cx="429.81" cy="422.873" fill="#b8d432" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(423.774 427.915)">
        S2
    </text>
    <g fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" opacity=".5">
        <path d="M745.965 456.951v3h-3"/>
        <path stroke-dasharray="6.07 6.07" d="M736.895 459.951h-154.79"/>
        <path d="M579.07 459.951h-3v-3"/>
        <path stroke-dasharray="5.971 5.971" d="M576.07 450.979v-92.552"/>
        <path d="M576.07 355.441v-3h3"/>
        <path stroke-dasharray="6.07 6.07" d="M585.14 352.441h154.79"/>
        <path d="M742.965 352.441h3v3"/>
        <path stroke-dasharray="5.971 5.971" d="M745.965 361.412v92.553"/>
    </g>
    <circle cx="643.661" cy="422.873" fill="#fcd116" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(637.629 427.915)">
        S1
    </text>
    <circle cx="708.649" cy="422.873" fill="#b8d432" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(702.613 427.915)">
        S2
    </text>
    <g fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" opacity=".5">
        <path d="M745.965 574.529v3h-3"/>
        <path stroke-dasharray="6.07 6.07" d="M736.895 577.529h-154.79"/>
        <path d="M579.07 577.529h-3v-3"/>
        <path stroke-dasharray="5.971 5.971" d="M576.07 568.558v-92.552"/>
        <path d="M576.07 473.02v-3h3"/>
        <path stroke-dasharray="6.07 6.07" d="M585.14 470.02h154.79"/>
        <path d="M742.965 470.02h3v3"/>
        <path stroke-dasharray="5.971 5.971" d="M745.965 478.991v92.553"/>
    </g>
    <circle cx="643.661" cy="540.452" fill="#fcd116" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(637.629 545.494)">
        S1
    </text>
    <circle cx="708.649" cy="540.452" fill="#b8d432" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(702.613 545.494)">
        S2
    </text>
    <g fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" opacity=".5">
        <path d="M249.517 306.951v3h-3"/>
        <path stroke-dasharray="6.159 6.159" d="M240.357 309.951H21.701"/>
        <path d="M18.621 309.951h-3v-3"/>
        <path stroke-dasharray="5.971 5.971" d="M15.621 300.979v-92.552"/>
        <path d="M15.621 205.441v-3h3"/>
        <path stroke-dasharray="6.159 6.159" d="M24.781 202.441h218.656"/>
        <path d="M246.517 202.441h3v3"/>
        <path stroke-dasharray="5.971 5.971" d="M249.517 211.412v92.553"/>
    </g>
    <circle cx="83.213" cy="272.873" fill="#fcd116" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(77.181 277.915)">
        S1
    </text>
    <circle cx="148.2" cy="272.873" fill="#b8d432" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(142.164 277.915)">
        S2
    </text>
    <circle cx="213.187" cy="272.873" fill="#ff8c00" r="24.849"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(207.151 277.915)">
        S3
    </text>
    <path fill="none" stroke="#b5b5b5" stroke-miterlimit="10" stroke-width="1.643" d="M132.044 312.086v24.998h78.27v28.741M413.066 312.086v24.998h98.27v28.741M694.087 312.086v24.998h98.271v28.741M745.965 405.379h17.771"/>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(236.464 79.655)">
            Visual Studio<tspan letter-spacing="-.098em" x="-2.558" y="14.4">Team Services</tspan>
        </text>
        <path d="M268.022 34.076l14.214-11v21.996zm-20.651 8.046V26.03l8.046 8.046zm34.865-34.865l-21.187 21.187-13.677-10.459-5.364 2.682v26.818l5.364 2.682 13.678-10.459 21.187 21.187 13.409-5.364v-42.91z" fill="#68217a"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(388.172 79.655)">
            Build and<tspan letter-spacing="-.029em" x="-12.592" y="14.4">Release Agent</tspan>
        </text>
        <path d="M422.363 49.911h-18.016c2.165 7.643-.743 8.739-13.483 8.739v4h43.32v-4c-12.74 0-13.989-1.092-11.821-8.739" fill="#7a7a7a"/>
        <path d="M441.648 1.5H383a3.747 3.747 0 00-3.6 3.773v40.9a3.726 3.726 0 003.6 3.741h58.652a4.094 4.094 0 004-3.741v-40.9a4.109 4.109 0 00-4-3.773" fill="#a0a1a2"/>
        <path d="M441.689 1.5H383a3.746 3.746 0 00-3.6 3.773v40.9a3.727 3.727 0 003.6 3.742h1.4z" fill="#fff" opacity=".2" style="isolation:isolate"/>
        <path fill="#59b4d9" d="M440.479 6.599v38.217h-56.062V6.599h56.062z"/>
        <path fill="#59b4d9" d="M384.417 44.816h.077V6.6l51.255-.077h.002l-51.334.077v38.216z"/>
        <path fill="#a0a1a2" d="M390.864 58.649h43.32v4.003h-43.32z"/>
        <path d="M413.209 4.276a.94.94 0 11-.941-.941.941.941 0 01.941.941" fill="#b8d432"/>
        <path d="M413.246 24.549a.368.368 0 01-.178-.05L401.4 17.764a.359.359 0 01-.175-.306.353.353 0 01.175-.3l11.6-6.69a.355.355 0 01.349 0l11.67 6.737a.354.354 0 010 .61L413.425 24.5a.357.357 0 01-.179.05" fill="#fff"/>
        <path d="M411.57 40.916a.333.333 0 01-.178-.048l-11.632-6.712a.345.345 0 01-.18-.306V20.379a.358.358 0 01.535-.306l11.63 6.71a.37.37 0 01.172.309v13.471a.36.36 0 01-.172.306.371.371 0 01-.176.048" fill="#fff" opacity=".7" style="isolation:isolate"/>
        <path d="M414.863 40.916a.381.381 0 01-.183-.048.359.359 0 01-.171-.306V27.176a.366.366 0 01.171-.306l11.63-6.71a.345.345 0 01.35 0 .349.349 0 01.179.3v13.39a.346.346 0 01-.179.306l-11.626 6.713a.313.313 0 01-.171.048" fill="#fff" opacity=".4" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(46.642 179.128)">
            Development Resource Group
        </text>
        <path d="M25.761 173.849a.233.233 0 01-.12-.035l-8-4.614a.242.242 0 01-.121-.211.238.238 0 01.121-.208l7.949-4.581a.246.246 0 01.24 0l8 4.617a.242.242 0 010 .418l-7.946 4.583a.238.238 0 01-.121.034" fill="#3999c6"/>
        <path d="M24.612 185.066a.241.241 0 01-.123-.032l-7.97-4.6a.237.237 0 01-.123-.21v-9.231a.245.245 0 01.123-.211.252.252 0 01.243 0l7.969 4.6a.245.245 0 01.118.21v9.233a.238.238 0 01-.238.242M26.867 185.066a.257.257 0 01-.123-.032.241.241 0 01-.12-.21v-9.173a.246.246 0 01.12-.21l7.968-4.6a.249.249 0 01.243 0 .246.246 0 01.12.209v9.173a.243.243 0 01-.12.21l-7.971 4.6a.218.218 0 01-.118.032" fill="#59b4d9"/>
        <path d="M26.867 185.066a.257.257 0 01-.123-.032.241.241 0 01-.12-.21v-9.173a.246.246 0 01.12-.21l7.968-4.6a.249.249 0 01.243 0 .246.246 0 01.12.209v9.173a.243.243 0 01-.12.21l-7.971 4.6a.218.218 0 01-.118.032" fill="#fff" opacity=".5" style="isolation:isolate"/>
        <path d="M17.343 186.091a.788.788 0 01-.395-.106l-3.72-2.148a2.288 2.288 0 01-1.08-1.871V168.29a2.286 2.286 0 011.08-1.87l3.72-2.148a.791.791 0 01.791 1.369l-3.72 2.148a.761.761 0 00-.289.5v13.677a.759.759 0 00.289.5l3.72 2.148a.791.791 0 01-.4 1.476zM34.129 164.165a.788.788 0 01.395.106l3.72 2.148a2.288 2.288 0 011.08 1.871v13.677a2.286 2.286 0 01-1.08 1.87l-3.72 2.148a.791.791 0 11-.791-1.369l3.72-2.148a.761.761 0 00.289-.5V168.29a.759.759 0 00-.289-.5l-3.72-2.148a.791.791 0 01.4-1.476z" fill="#7a7a7a"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(331.431 179.128)">
            QA Resource Group
        </text>
        <path d="M308.778 173.849a.233.233 0 01-.12-.035l-8-4.614a.242.242 0 01-.121-.211.238.238 0 01.121-.208l7.944-4.584a.246.246 0 01.24 0l8 4.617a.242.242 0 010 .418l-7.946 4.583a.238.238 0 01-.121.034" fill="#3999c6"/>
        <path d="M307.629 185.066a.241.241 0 01-.123-.032l-7.97-4.6a.237.237 0 01-.123-.21v-9.231a.245.245 0 01.123-.211.252.252 0 01.243 0l7.969 4.6a.245.245 0 01.118.21v9.233a.238.238 0 01-.238.242M309.884 185.066a.257.257 0 01-.123-.032.241.241 0 01-.12-.21v-9.173a.246.246 0 01.12-.21l7.968-4.6a.249.249 0 01.243 0 .246.246 0 01.12.209v9.173a.243.243 0 01-.12.21l-7.971 4.6a.218.218 0 01-.118.032" fill="#59b4d9"/>
        <path d="M309.884 185.066a.257.257 0 01-.123-.032.241.241 0 01-.12-.21v-9.173a.246.246 0 01.12-.21l7.968-4.6a.249.249 0 01.243 0 .246.246 0 01.12.209v9.173a.243.243 0 01-.12.21l-7.971 4.6a.218.218 0 01-.118.032" fill="#fff" opacity=".5" style="isolation:isolate"/>
        <path d="M300.36 186.091a.788.788 0 01-.395-.106l-3.72-2.148a2.288 2.288 0 01-1.08-1.871V168.29a2.286 2.286 0 011.08-1.87l3.72-2.148a.791.791 0 01.791 1.369l-3.72 2.148a.761.761 0 00-.289.5v13.677a.759.759 0 00.289.5l3.72 2.148a.791.791 0 01-.4 1.476zM317.145 164.165a.788.788 0 01.395.106l3.72 2.148a2.288 2.288 0 011.08 1.871v13.677a2.286 2.286 0 01-1.08 1.87l-3.72 2.148a.791.791 0 11-.791-1.369l3.72-2.148a.761.761 0 00.289-.5V168.29a.759.759 0 00-.289-.5l-3.72-2.148a.791.791 0 01.4-1.476z" fill="#7a7a7a"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(610.437 179.128)">
            Prod Resource Group
        </text>
        <path d="M587.991 173.849a.233.233 0 01-.12-.035l-8-4.614a.242.242 0 01-.121-.211.238.238 0 01.121-.208l7.944-4.584a.246.246 0 01.24 0l8 4.617a.242.242 0 010 .418l-7.946 4.583a.238.238 0 01-.121.034" fill="#3999c6"/>
        <path d="M586.841 185.066a.241.241 0 01-.123-.032l-7.97-4.6a.237.237 0 01-.123-.21v-9.231a.245.245 0 01.123-.211.252.252 0 01.243 0l7.969 4.6a.245.245 0 01.118.21v9.233a.238.238 0 01-.238.242M589.1 185.066a.257.257 0 01-.123-.032.241.241 0 01-.12-.21v-9.173a.246.246 0 01.12-.21l7.968-4.6a.249.249 0 01.243 0 .246.246 0 01.12.209v9.173a.243.243 0 01-.12.21l-7.971 4.6a.218.218 0 01-.118.032" fill="#59b4d9"/>
        <path d="M589.1 185.066a.257.257 0 01-.123-.032.241.241 0 01-.12-.21v-9.173a.246.246 0 01.12-.21l7.968-4.6a.249.249 0 01.243 0 .246.246 0 01.12.209v9.173a.243.243 0 01-.12.21l-7.971 4.6a.218.218 0 01-.118.032" fill="#fff" opacity=".5" style="isolation:isolate"/>
        <path d="M579.572 186.091a.788.788 0 01-.395-.106l-3.72-2.148a2.288 2.288 0 01-1.08-1.871V168.29a2.286 2.286 0 011.08-1.87l3.72-2.148a.791.791 0 01.791 1.369l-3.72 2.148a.761.761 0 00-.289.5v13.677a.759.759 0 00.289.5l3.72 2.148a.791.791 0 01-.4 1.476zM596.358 164.165a.788.788 0 01.395.106l3.72 2.148a2.288 2.288 0 011.08 1.871v13.677a2.286 2.286 0 01-1.08 1.87l-3.72 2.148a.791.791 0 01-.791-1.369l3.72-2.148a.761.761 0 00.289-.5V168.29a.759.759 0 00-.289-.5l-3.72-2.148a.791.791 0 01.4-1.476z" fill="#7a7a7a"/>
    </g>
    <g>
        <path d="M187.993 383.161v43c0 4.465 9.994 8.085 22.321 8.085v-51.09z" fill="#0072c6"/>
        <path d="M210.008 434.249h.306c12.327 0 22.321-3.618 22.321-8.084v-43h-22.627z" fill="#0072c6"/>
        <path d="M210.008 434.249h.306c12.327 0 22.321-3.618 22.321-8.084v-43h-22.627z" fill="#fff" opacity=".15" style="isolation:isolate"/>
        <path d="M232.636 383.161c0 4.465-9.994 8.084-22.321 8.084s-22.321-3.619-22.321-8.084 9.994-8.084 22.321-8.084 22.321 3.619 22.321 8.084" fill="#fff"/>
        <path d="M228.072 382.695c0 2.947-7.95 5.334-17.758 5.334s-17.759-2.387-17.759-5.334 7.952-5.334 17.759-5.334 17.758 2.388 17.758 5.334" fill="#7fba00"/>
        <path d="M224.352 385.954c2.325-.9 3.722-2.03 3.722-3.257 0-2.947-7.95-5.335-17.759-5.335s-17.758 2.388-17.758 5.335c0 1.227 1.4 2.356 3.722 3.257 3.246-1.26 8.32-2.073 14.036-2.073s10.788.813 14.037 2.073" fill="#b8d432"/>
        <path d="M203.225 413.012a3.666 3.666 0 01-1.454 3.1 6.52 6.52 0 01-4.017 1.1 7.641 7.641 0 01-3.645-.786v-3.144a5.624 5.624 0 003.723 1.435 2.533 2.533 0 001.518-.393 1.23 1.23 0 00.536-1.042 1.458 1.458 0 00-.516-1.11 9.475 9.475 0 00-2.1-1.218q-3.223-1.511-3.223-4.125a3.724 3.724 0 011.405-3.04 5.732 5.732 0 013.732-1.144 9.325 9.325 0 013.419.541v2.937a5.572 5.572 0 00-3.242-.982 2.4 2.4 0 00-1.443.387 1.222 1.222 0 00-.53 1.036 1.48 1.48 0 00.428 1.1 6.913 6.913 0 001.753 1.056 8.686 8.686 0 012.815 1.9 3.531 3.531 0 01.841 2.392zM218.382 409.83a8.037 8.037 0 01-1.13 4.312 6.03 6.03 0 01-3.182 2.564l4.086 3.782h-4.126l-2.918-3.271a6.841 6.841 0 01-3.385-.992 6.217 6.217 0 01-2.327-2.525 7.763 7.763 0 01-.821-3.581 8.37 8.37 0 01.888-3.9 6.315 6.315 0 012.5-2.638 7.3 7.3 0 013.694-.923 6.8 6.8 0 013.482.894 6.1 6.1 0 012.387 2.544 8.041 8.041 0 01.852 3.734zm-3.339.177a5.511 5.511 0 00-.934-3.385 3.021 3.021 0 00-2.554-1.243 3.207 3.207 0 00-2.643 1.247 6.063 6.063 0 00-.02 6.615 3.126 3.126 0 002.583 1.233 3.168 3.168 0 002.6-1.193 5.063 5.063 0 00.967-3.274zM229.099 416.972h-8.389v-14.086h3.172v11.512h5.217v2.574z" fill="#fff"/>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(174.894 451.739)">
            Development<tspan x="10.978" y="14.4">Database</tspan>
        </text>
    </g>
    <g>
        <path d="M489.015 383.161v43c0 4.465 9.994 8.085 22.321 8.085v-51.09z" fill="#0072c6"/>
        <path d="M511.03 434.249h.306c12.327 0 22.321-3.618 22.321-8.084v-43H511.03z" fill="#0072c6"/>
        <path d="M511.03 434.249h.306c12.327 0 22.321-3.618 22.321-8.084v-43H511.03z" fill="#fff" opacity=".15" style="isolation:isolate"/>
        <path d="M533.657 383.161c0 4.465-9.994 8.084-22.321 8.084s-22.321-3.619-22.321-8.084 9.994-8.084 22.321-8.084 22.321 3.619 22.321 8.084" fill="#fff"/>
        <path d="M529.094 382.695c0 2.947-7.95 5.334-17.758 5.334s-17.759-2.387-17.759-5.334 7.952-5.334 17.759-5.334 17.758 2.388 17.758 5.334" fill="#7fba00"/>
        <path d="M525.373 385.954c2.325-.9 3.722-2.03 3.722-3.257 0-2.947-7.95-5.335-17.759-5.335s-17.758 2.388-17.758 5.335c0 1.227 1.4 2.356 3.722 3.257 3.246-1.26 8.32-2.073 14.036-2.073s10.788.813 14.037 2.073" fill="#b8d432"/>
        <path d="M504.247 413.012a3.666 3.666 0 01-1.454 3.1 6.52 6.52 0 01-4.017 1.1 7.641 7.641 0 01-3.645-.786v-3.144a5.624 5.624 0 003.723 1.435 2.533 2.533 0 001.518-.393 1.23 1.23 0 00.536-1.042 1.458 1.458 0 00-.516-1.11 9.475 9.475 0 00-2.1-1.218q-3.223-1.511-3.223-4.125a3.724 3.724 0 011.405-3.04 5.732 5.732 0 013.732-1.144 9.325 9.325 0 013.419.541v2.937a5.572 5.572 0 00-3.242-.982 2.4 2.4 0 00-1.443.387 1.222 1.222 0 00-.53 1.036 1.48 1.48 0 00.428 1.1 6.913 6.913 0 001.753 1.056 8.686 8.686 0 012.815 1.9 3.531 3.531 0 01.841 2.392zM519.4 409.83a8.037 8.037 0 01-1.13 4.312 6.03 6.03 0 01-3.182 2.564l4.086 3.782h-4.125l-2.918-3.271a6.841 6.841 0 01-3.385-.992 6.217 6.217 0 01-2.328-2.529 7.763 7.763 0 01-.821-3.581 8.37 8.37 0 01.888-3.9 6.315 6.315 0 012.5-2.638 7.3 7.3 0 013.694-.923 6.8 6.8 0 013.482.894 6.1 6.1 0 012.387 2.544 8.041 8.041 0 01.852 3.738zm-3.339.177a5.511 5.511 0 00-.934-3.385 3.021 3.021 0 00-2.554-1.243 3.207 3.207 0 00-2.643 1.247 6.063 6.063 0 00-.02 6.615 3.126 3.126 0 002.583 1.233 3.168 3.168 0 002.6-1.193 5.063 5.063 0 00.971-3.274zM530.12 416.972h-8.388v-14.086h3.172v11.512h5.216v2.574z" fill="#fff"/>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(503.256 451.739)">
            QA<tspan x="-16.362" y="14.4">Database</tspan>
        </text>
    </g>
    <g>
        <path d="M770.037 383.161v43c0 4.465 9.994 8.085 22.321 8.085v-51.09z" fill="#0072c6"/>
        <path d="M792.052 434.249h.306c12.327 0 22.321-3.618 22.321-8.084v-43h-22.627z" fill="#0072c6"/>
        <path d="M792.052 434.249h.306c12.327 0 22.321-3.618 22.321-8.084v-43h-22.627z" fill="#fff" opacity=".15" style="isolation:isolate"/>
        <path d="M814.679 383.161c0 4.465-9.994 8.084-22.321 8.084s-22.321-3.619-22.321-8.084 9.994-8.084 22.321-8.084 22.321 3.619 22.321 8.084" fill="#fff"/>
        <path d="M810.115 382.695c0 2.947-7.95 5.334-17.758 5.334s-17.759-2.387-17.759-5.334 7.952-5.334 17.759-5.334 17.758 2.388 17.758 5.334" fill="#7fba00"/>
        <path d="M806.395 385.954c2.325-.9 3.722-2.03 3.722-3.257 0-2.947-7.95-5.335-17.759-5.335S774.6 379.75 774.6 382.7c0 1.227 1.4 2.356 3.722 3.257 3.246-1.26 8.32-2.073 14.036-2.073s10.788.813 14.037 2.073" fill="#b8d432"/>
        <path d="M785.268 413.012a3.666 3.666 0 01-1.454 3.1 6.52 6.52 0 01-4.017 1.1 7.641 7.641 0 01-3.645-.786v-3.144a5.624 5.624 0 003.723 1.435 2.533 2.533 0 001.518-.393 1.23 1.23 0 00.536-1.042 1.458 1.458 0 00-.516-1.11 9.475 9.475 0 00-2.1-1.218q-3.223-1.511-3.223-4.125a3.724 3.724 0 011.405-3.04 5.732 5.732 0 013.732-1.144 9.325 9.325 0 013.419.541v2.937a5.572 5.572 0 00-3.242-.982 2.4 2.4 0 00-1.443.387 1.222 1.222 0 00-.53 1.036 1.48 1.48 0 00.428 1.1 6.913 6.913 0 001.753 1.056 8.686 8.686 0 012.815 1.9 3.531 3.531 0 01.841 2.392zM800.425 409.83a8.037 8.037 0 01-1.13 4.312 6.03 6.03 0 01-3.182 2.564l4.086 3.782h-4.125l-2.918-3.271a6.841 6.841 0 01-3.385-.992 6.217 6.217 0 01-2.328-2.529 7.763 7.763 0 01-.821-3.581 8.37 8.37 0 01.888-3.9 6.315 6.315 0 012.5-2.638 7.3 7.3 0 013.694-.923 6.8 6.8 0 013.482.894 6.1 6.1 0 012.387 2.544 8.041 8.041 0 01.852 3.738zm-3.339.177a5.511 5.511 0 00-.934-3.385 3.021 3.021 0 00-2.554-1.243 3.207 3.207 0 00-2.643 1.247 6.063 6.063 0 00-.02 6.615 3.126 3.126 0 002.583 1.233 3.168 3.168 0 002.6-1.193 5.063 5.063 0 00.968-3.274zM811.142 416.972h-8.389v-14.086h3.173v11.512h5.216v2.574z" fill="#fff"/>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(763.465 451.739)">
            Production<tspan x="4.45" y="14.4">Database</tspan>
        </text>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(58.218 230.767)">
            Development Host 1
        </text>
        <path d="M36.8 216.152l9.264 7.691-3.124 10.586H30.463l-2.945-10.569 9.285-7.708m0-3.279l-12.154 10.09 3.9 13.988h16.28l4.128-13.988-12.157-10.09z" fill="#dd5900"/>
        <path d="M36.805 210.587a4.586 4.586 0 11-4.586 4.587 4.587 4.587 0 014.586-4.587zM46.9 218.383a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM43.455 230.767a4.586 4.586 0 11-4.586 4.586 4.586 4.586 0 014.586-4.586zM30.149 230.767a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM26.716 218.383a4.586 4.586 0 11-4.587 4.587 4.586 4.586 0 014.587-4.587z" fill="#ff8c00"/>
        <path d="M30.967 239.866l1.869-8.229a4.59 4.59 0 00-3.378-.817l-1-3.6a4.587 4.587 0 002.434-6.152l2.919-2.423a4.585 4.585 0 001.765.95l2.028-8.934a4.54 4.54 0 00-.794-.07 4.588 4.588 0 00-4.386 5.926l-3.171 2.633a4.586 4.586 0 10-3.339 8.338l1.229 4.411a4.585 4.585 0 003.011 8.044 4.692 4.692 0 00.813-.077z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(339.828 230.767)">
            QA Host 1
        </text>
        <path d="M318.413 216.152l9.264 7.691-3.124 10.586h-12.48l-2.945-10.569 9.285-7.708m0-3.279l-12.154 10.09 3.9 13.988h16.281l4.128-13.988-12.154-10.09z" fill="#dd5900"/>
        <path d="M318.415 210.587a4.586 4.586 0 11-4.586 4.587 4.587 4.587 0 014.586-4.587zM328.505 218.383a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM325.065 230.767a4.586 4.586 0 11-4.586 4.586 4.586 4.586 0 014.586-4.586zM311.759 230.767a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM308.325 218.383a4.586 4.586 0 11-4.587 4.587 4.586 4.586 0 014.587-4.587z" fill="#ff8c00"/>
        <path d="M312.577 239.866l1.869-8.229a4.59 4.59 0 00-3.378-.817l-1-3.6a4.587 4.587 0 002.434-6.152l2.919-2.423a4.585 4.585 0 001.765.95l2.028-8.934a4.54 4.54 0 00-.794-.07 4.588 4.588 0 00-4.386 5.926l-3.171 2.633a4.586 4.586 0 10-3.339 8.338l1.229 4.411a4.585 4.585 0 003.011 8.044 4.692 4.692 0 00.813-.077z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(339.828 380.767)">
            QA Host 2
        </text>
        <path d="M318.413 366.152l9.264 7.691-3.124 10.586h-12.48l-2.945-10.569 9.285-7.708m0-3.279l-12.154 10.09 3.9 13.988h16.281l4.128-13.988-12.154-10.09z" fill="#dd5900"/>
        <path d="M318.415 360.587a4.586 4.586 0 11-4.586 4.587 4.587 4.587 0 014.586-4.587zM328.505 368.383a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM325.065 380.767a4.586 4.586 0 11-4.586 4.586 4.586 4.586 0 014.586-4.586zM311.759 380.767a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM308.325 368.383a4.586 4.586 0 11-4.587 4.587 4.586 4.586 0 014.587-4.587z" fill="#ff8c00"/>
        <path d="M312.577 389.866l1.869-8.229a4.59 4.59 0 00-3.378-.817l-1-3.6a4.587 4.587 0 002.434-6.152l2.919-2.423a4.585 4.585 0 001.765.95l2.028-8.934a4.54 4.54 0 00-.794-.07 4.588 4.588 0 00-4.386 5.926l-3.171 2.633a4.586 4.586 0 10-3.339 8.338l1.229 4.411a4.585 4.585 0 003.011 8.044 4.692 4.692 0 00.813-.077z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(618.666 380.767)">
            QA Host 2
        </text>
        <path d="M597.251 366.152l9.264 7.691-3.124 10.586h-12.479l-2.945-10.569 9.285-7.708m0-3.279l-12.152 10.09 3.9 13.988h16.281l4.128-13.988-12.154-10.09z" fill="#dd5900"/>
        <path d="M597.254 360.587a4.586 4.586 0 11-4.586 4.587 4.587 4.587 0 014.586-4.587zM607.344 368.383a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM603.9 380.767a4.586 4.586 0 11-4.586 4.586 4.586 4.586 0 014.586-4.586zM590.6 380.767a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM587.164 368.383a4.586 4.586 0 11-4.587 4.587 4.586 4.586 0 014.587-4.587z" fill="#ff8c00"/>
        <path d="M591.416 389.866l1.869-8.229a4.59 4.59 0 00-3.378-.817l-1-3.6a4.587 4.587 0 002.434-6.152l2.919-2.423a4.585 4.585 0 001.765.95l2.028-8.934a4.54 4.54 0 00-.794-.07 4.588 4.588 0 00-4.386 5.926l-3.171 2.633a4.586 4.586 0 10-3.339 8.338l1.229 4.411a4.585 4.585 0 003.011 8.044 4.692 4.692 0 00.813-.077z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(618.666 498.346)">
            QA Host 3
        </text>
        <path d="M597.251 483.731l9.264 7.691-3.124 10.586h-12.479l-2.945-10.569 9.285-7.708m0-3.279l-12.152 10.09 3.9 13.988h16.281l4.128-13.988-12.154-10.09z" fill="#dd5900"/>
        <path d="M597.254 478.166a4.586 4.586 0 11-4.586 4.587 4.587 4.587 0 014.586-4.587zM607.344 485.962a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM603.9 498.345a4.586 4.586 0 11-4.586 4.586 4.586 4.586 0 014.586-4.586zM590.6 498.345a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM587.164 485.962a4.586 4.586 0 11-4.587 4.587 4.586 4.586 0 014.587-4.587z" fill="#ff8c00"/>
        <path d="M591.416 507.445l1.869-8.229a4.59 4.59 0 00-3.378-.817l-1-3.6a4.587 4.587 0 002.434-6.152l2.919-2.423a4.585 4.585 0 001.765.95l2.028-8.934a4.54 4.54 0 00-.794-.07 4.588 4.588 0 00-4.386 5.926l-3.171 2.633a4.586 4.586 0 10-3.339 8.338l1.229 4.411a4.585 4.585 0 003.011 8.044 4.692 4.692 0 00.813-.077z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    </g>
    <g>
        <text fill="#5d5d5d" font-family="SegoeUI, Segoe UI" font-size="12" opacity=".5" transform="translate(619.437 230.767)">
            Production Host 1
        </text>
        <path d="M598.022 216.152l9.264 7.691-3.124 10.586h-12.479l-2.945-10.569 9.285-7.708m0-3.279l-12.154 10.09 3.9 13.988h16.281l4.128-13.988-12.154-10.09z" fill="#dd5900"/>
        <path d="M598.025 210.587a4.586 4.586 0 11-4.586 4.587 4.587 4.587 0 014.586-4.587zM608.115 218.383a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM604.675 230.767a4.586 4.586 0 11-4.586 4.586 4.586 4.586 0 014.586-4.586zM591.369 230.767a4.586 4.586 0 11-4.587 4.586 4.586 4.586 0 014.587-4.586zM587.935 218.383a4.586 4.586 0 11-4.587 4.587 4.586 4.586 0 014.587-4.587z" fill="#ff8c00"/>
        <path d="M592.187 239.866l1.869-8.229a4.59 4.59 0 00-3.378-.817l-1-3.6a4.587 4.587 0 002.434-6.152l2.919-2.423a4.585 4.585 0 001.765.95l2.028-8.934a4.54 4.54 0 00-.794-.07 4.588 4.588 0 00-4.386 5.926l-3.171 2.633a4.586 4.586 0 10-3.339 8.338l1.229 4.411a4.585 4.585 0 003.011 8.044 4.692 4.692 0 00.813-.077z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    </g>
</svg>

## Components
* [Azure DevOps](https://azure.microsoft.com/services/devops/) manages the development process.
* The [Microsoft Release Management](https://www.visualstudio.com/docs/release/getting-started/configure-agents) build and release agents deploy the Azure Resource Manager template and associated code to the various environments.
* [Azure DevOps resource groups](https://www.visualstudio.com/docs/release/getting-started/configure-agents) are used to define all the services required to deploy the solution into a dev-test or production environment.
* [Service Fabric](https://azure.microsoft.com/services/service-fabric/) orchestrates all of the microservices used in the solution. In development, code is deployed directly from the development tools, while in test and production environments the code is deployed through the build and release agent using Resource Manager templates.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database/) maintains data for the website. Copies are deployed in the dev, test, and production environments.

## Next Steps
* [Set up AzureDevOps](https://www.visualstudio.com/docs/setup-admin/get-started)
* [Configure Microsoft Release Management agents](https://www.visualstudio.com/docs/release/getting-started/configure-agents)
* [Deploy using Azure Resource Groups](https://github.com/Microsoft/vsts-tasks/tree/master/Tasks/DeployAzureResourceGroup)
* [Create your first Azure Service Fabric application](/api/Redirect/documentation/articles/service-fabric-create-your-first-application-in-visual-studio/)
* [SQL Database tutorial: Create a SQL database in minutes by using the Azure portal](/api/Redirect/documentation/articles/sql-database-get-started/)

[!INCLUDE [js_include_file](../../_js/index.md)]
