---
title: Training and procedural guidance powered by mixed reality
author: adamboeglin
ms.date: 12/12/2019
description: Enable your team and employees to learn new processes and materials faster, with fewer errors, and greater confidence by providing persistent holographic instructions mapped to precise locations in their physical workspace. Jumpstart employee comprehension with head-up, hands-free experiences using HoloLens devices. And with Azure Spatial Anchors, you can place directions on the procedure�s most important objects and return to this content over time.
ms.custom: acom-architecture, Azure Spatial Anchors, Azure Active Directory, Azure Cosmos DB, Azure App Service, Media Services, Microsoft HoloLens, Video Indexer, interactive-diagram
titleSuffix: Azure Solution Ideas
---
# Training and procedural guidance powered by mixed reality

<div class="alert">
    <p class="alert-title">
        <span class="icon is-left" aria-hidden="true">
            <span class="icon docon docon-lightbulb" role="presentation"></span>
        </span>Solution Idea</p>
    <p>This is an example of a solution built on Azure. If you'd like to see this expanded with more detail, pricing information, code examples, or deployment templates, let us know in the <a href="#feedback">feedback</a> area.</p>
</div>

Enable your team and employees to learn new processes and materials faster, with fewer errors, and greater confidence by providing persistent holographic instructions mapped to precise locations in their physical workspace. Jumpstart employee comprehension with head-up, hands-free experiences using HoloLens devices. And with Azure Spatial Anchors, you can place directions on the procedure�s most important objects and return to this content over time.

## Architecture

<svg class="architecture-diagram" aria-labelledby="training-and-procedural-guidance-powered-by-mixed-reality" height="1132" viewbox="0 0 857.38 1132.6" width="857" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <style>
            .cls-1{font-size:20px;fill:#6a6a6a;font-family:SegoeUI,Segoe UI}.cls-2,.cls-4{letter-spacing:-.01em}.cls-5{letter-spacing:.04em}.cls-7{fill:#59b3d8}.cls-9{fill:#b6deec}.cls-10{fill:#bde1ee}.cls-11{fill:#fff}.cls-12{fill:#b7d332}.cls-14{fill:#4099c1}.cls-16{fill:#7e4e94}.cls-26{fill:none;stroke:#dedede;stroke-miterlimit:10;stroke-width:1.5px}.cls-27{fill:#dedede}.cls-29{fill:#a4cd00}.cls-31{fill:#9fa0a1}.cls-34{fill:#1a1a1f}
        </style>
    </defs>
    <text class="cls-1" transform="translate(470.34 155.03)">
        Azu<tspan class="cls-2" x="33.26" y="0">r</tspan><tspan x="39.95" y="0">e Acti</tspan><tspan x="89.65" y="0" letter-spacing="-.01em">v</tspan><tspan x="99.11" y="0">e </tspan><tspan x="14.27" y="24">Di</tspan><tspan class="cls-2" x="33.14" y="24">r</tspan><tspan x="39.83" y="24">ec</tspan><tspan class="cls-4" x="59.53" y="24">t</tspan><tspan x="66.15" y="24">o</tspan><tspan class="cls-5" x="77.87" y="24">r</tspan><tspan x="85.62" y="24">y</tspan>
    </text>
    <text class="cls-1" transform="translate(467.71 399.59)">
        Azu<tspan class="cls-2" x="33.26" y="0">r</tspan><tspan x="39.95" y="0">e S</tspan><tspan class="cls-2" x="66.51" y="0">p</tspan><tspan x="78.01" y="0">atial </tspan><tspan x="21.38" y="24">Ancho</tspan><tspan x="77.87" y="24" letter-spacing=".01em">r</tspan><tspan x="84.96" y="24">s</tspan>
    </text>
    <path class="cls-7" d="M522.19 122.45a6.26 6.26 0 01-4.59-2l-29.05-28.88a6.4 6.4 0 01-1.95-4.59 6.22 6.22 0 011.95-4.59l29-28.93a6.44 6.44 0 014.59-2 6.26 6.26 0 014.6 2l28.98 28.93a6.44 6.44 0 012 4.59 6.26 6.26 0 01-2 4.59l-28.93 28.93a6.26 6.26 0 01-4.6 1.95z"/>
    <path d="M526.79 53.34a6.46 6.46 0 00-4.6-1.95 6.26 6.26 0 00-4.59 1.95l-29.05 28.93a6.42 6.42 0 00-1.95 4.6 6.22 6.22 0 001.95 4.59l16.41 16.41 30.74-45.51z" fill="#7bc3dd"/>
    <path class="cls-9" d="M544.24 86.98l-14.93-14.92-2.07 3 14.36 14.47z"/>
    <path class="cls-10" d="M523.34 66.2l-2.52 2.53 6.43 6.31 2.06-3z"/>
    <path class="cls-10" d="M500.23 86.99l20.78-20.78 2.54 2.52-20.8 20.78z"/>
    <path class="cls-11" d="M541.6 81.35a5.52 5.52 0 00-5.51 5.52 5.77 5.77 0 00.91 3.09l-11 11c-.34-.23-.57-.35-.91-.58v-28a5.61 5.61 0 002.75-4.82 5.51 5.51 0 10-11 0 5.76 5.76 0 002.71 4.84v28.13c-.34.11-.57.34-.91.46l-11-11a5.69 5.69 0 00.91-3 5.51 5.51 0 10-11 0 5.59 5.59 0 005.51 5.51 4.75 4.75 0 001.84-.34l11.56 11.63a6.17 6.17 0 00-.58 2.53 6.43 6.43 0 0012.86 0 8.94 8.94 0 00-.46-2.53l11.59-11.59a4.63 4.63 0 001.73.34 5.51 5.51 0 005.51-5.51 5.62 5.62 0 00-5.51-5.68z"/>
    <path class="cls-12" d="M526.55 106.41a4.29 4.29 0 11-4.29-4.28 4.41 4.41 0 014.29 4.28zM525.3 67.58a3.1 3.1 0 11-3.1-3.1 3.09 3.09 0 013.1 3.1zM505.9 86.98a3.1 3.1 0 11-3.1-3.1 3.09 3.09 0 013.1 3.1zM544.55 86.98a3.1 3.1 0 11-3.1-3.1 3.09 3.09 0 013.1 3.1z"/>
    <path fill="#bfe1ee" d="M498.21 337.22l24.51-16.93 24.18 16.93-24.18 17.73-24.51-17.73z"/>
    <path class="cls-14" d="M522.73 356.79l-27-19.56 27-18.66 26.66 18.66zm-22-19.5l22 15.92 21.7-15.92-21.7-15.19z"/>
    <path class="cls-14" d="M522.73 357.59l-28.18-20.42 28.21-19.49 27.79 19.49zm-20.82-20.34l20.81 15.06 20.52-15.06-20.52-14.37z"/>
    <circle cx="543.01" cy="336.76" r="7.55" fill="#419ac2"/>
    <circle class="cls-11" cx="543.01" cy="336.76" r="3.66"/>
    <circle class="cls-16" cx="521.84" cy="322.14" r="5.24"/>
    <circle class="cls-16" cx="521.84" cy="353.74" r="5.24"/>
    <circle class="cls-16" cx="500.07" cy="337.3" r="5.24"/>
    <path class="cls-16" d="M553.75 307.57c0 5.93-10.74 28.91-10.74 28.91s-10.73-23-10.73-28.91a10.74 10.74 0 1121.47 0z"/>
    <circle class="cls-11" cx="543.01" cy="307.57" r="5.9"/>
    <text class="cls-1" transform="translate(730.06 640.64)">
        Cosmos DB
    </text>
    <text class="cls-1" transform="translate(714.48 1126.16)">
        Media Se<tspan class="cls-5" x="81.78" y="0">r</tspan><tspan x="89.53" y="0">vices</tspan>
    </text>
    <path class="cls-7" d="M801.08 572.55a20.51 20.51 0 01-15.29 24.77 20.76 20.76 0 01-25-15.12 20.52 20.52 0 0115.29-24.78 20.68 20.68 0 0125 15z"/>
    <path class="cls-9" d="M777.98 585.58a5.48 5.48 0 00-5.53-5.44h-.83a5.42 5.42 0 00-4.05-6.54 5.9 5.9 0 00-1.33-.15h-5.69a20.14 20.14 0 005 17.57h6.94a5.48 5.48 0 005.49-5.44zM784.82 563.02a3.4 3.4 0 00.13.95h-2.4a5.67 5.67 0 100 11.33h19a20.07 20.07 0 00-10.73-15.94h-2.27a3.69 3.69 0 00-3.73 3.66zM801.55 579.51h-11.33a4.64 4.64 0 00-4.69 4.6 4.55 4.55 0 00.56 2.2 4.61 4.61 0 00-3.06 5.77 4.67 4.67 0 004.47 3.24h3.16a20.48 20.48 0 0010.89-15.81z"/>
    <path class="cls-12" d="M757.68 563.7a.62.62 0 01-.64-.62 7.22 7.22 0 00-7.26-7.16.63.63 0 110-1.25 7.22 7.22 0 007.26-7.14.64.64 0 011.27 0 7.22 7.22 0 007.26 7.15.63.63 0 110 1.25 7.22 7.22 0 00-7.26 7.15.63.63 0 01-.63.62z"/>
    <path d="M802.45 604.03a.37.37 0 01-.38-.37 4.31 4.31 0 00-4.35-4.27.38.38 0 01-.37-.37.37.37 0 01.37-.38 4.3 4.3 0 004.34-4.27.39.39 0 01.77 0 4.31 4.31 0 004.34 4.27.38.38 0 110 .75 4.31 4.31 0 00-4.34 4.27.37.37 0 01-.38.37z" fill="#0072c5"/>
    <path d="M811.14 558.9c-2-3.21-7-4-14.38-2.15a60 60 0 00-6.82 2.15 21.81 21.81 0 014 2.54c1.26-.41 2.5-.78 3.69-1.06a25.67 25.67 0 016-.85c2.43 0 3.77.59 4.22 1.32.74 1.19.06 4.32-4.26 9.26-.77.88-1.63 1.77-2.54 2.66a94.51 94.51 0 01-33.46 20.25c-7.52 2.42-12.65 2.37-13.8.51s1.15-6.4 6.76-11.92a20.19 20.19 0 01-.46-4.78c-8.93 8-11.82 14.91-9.52 18.64 1.21 2 3.85 3.06 7.71 3.06a39.75 39.75 0 0013.35-2.91 95.05 95.05 0 0015.82-7.83 93.79 93.79 0 0014.18-10.38 56.18 56.18 0 004.88-4.88c5.04-5.74 6.61-10.42 4.63-13.63z"/>
    <text class="cls-1" transform="translate(540.1 247.67)">
        trust
    </text>
    <text class="cls-1" transform="translate(444.75 637.35)">
        Azu<tspan class="cls-2" x="33.26" y="0">r</tspan><tspan x="39.95" y="0">e App Se</tspan><tspan class="cls-5" x="118.87" y="0">r</tspan><tspan x="126.62" y="0">vice</tspan>
    </text>
    <path fill="#f4f4f4" d="M0 0h226.41v692.68H0z"/>
    <text class="cls-1" transform="translate(65.27 393.13)">
        Mic<tspan class="cls-2" x="32.04" y="0">r</tspan><tspan x="38.73" y="0">os</tspan><tspan x="58.94" y="0" letter-spacing="-.02em">o</tspan><tspan x="70.29" y="0" letter-spacing=".02em">f</tspan><tspan x="76.91" y="0">t</tspan><tspan x=".77" y="24">HoloLens</tspan>
    </text>
    <text class="cls-1" transform="translate(87.89 611.32)">
        Client
    </text>
    <path d="M76.04 329.11l1 .3a71.29 71.29 0 0040.8.09 68.69 68.69 0 0018.63-8.84l.91-.59.7-.49a4.9 4.9 0 00-1.21-.69h-.1c-5.84-2.16-16.11-3.34-29.61-3.34-13.7 0-24 1.18-29.72 3.34a7.32 7.32 0 00-1.81 1.18 3 3 0 00-.91 2.16v6.39zm28.91-7.17h4.43v2h-4.43v-2z"/>
    <path d="M139.3 321.06l-1.75 1.17a72.5 72.5 0 01-19.14 9.14 73.59 73.59 0 01-42-.1l-1.68-.48v.59a16.24 16.24 0 005.14 11 17.91 17.91 0 0012.39 4.82h2.82a3.65 3.65 0 002.12-.69l4.53-3.44a8.23 8.23 0 0110.78.1l4.53 3.34a3.41 3.41 0 002.12.69h2.82a17.75 17.75 0 0012.39-4.82 16 16 0 005.18-11.7v-8.45a2.42 2.42 0 00-.25-1.17z" fill="#0078d7"/>
    <path d="M780.55 1024.44l-27.12 15.82v31.63l27.12 15.82 27.11-15.82v-31.63z" fill="#3e3e3e"/>
    <path d="M780.55 1087.71l27.11-15.82v-31.63s-22.39 17.23-27.11 47.45z" fill="#656565"/>
    <path class="cls-11" d="M793.11 1043.37a17.69 17.69 0 00-25.14 0 18.09 18.09 0 000 25.41 17.69 17.69 0 0025.14 0 18.11 18.11 0 000-25.41z"/>
    <path d="M790.67 1045.79a14.26 14.26 0 00-20.27 0 14.6 14.6 0 000 20.49 14.26 14.26 0 0020.27 0 14.6 14.6 0 000-20.49z" fill="#59b4d9"/>
    <path class="cls-11" d="M789.17 1056.06l-13.62-9.07v9.11h13.6z"/>
    <path d="M789.12 1056.1h-13.57v9.1z" fill="#ddf0f6"/>
    <path class="cls-26" d="M698.46 1088H106.58V699.38"/>
    <path class="cls-27" d="M696.93 1082.77l9.06 5.23-9.06 5.24v-10.47z"/>
    <path class="cls-26" d="M453.7 600.48H233.11"/>
    <path class="cls-27" d="M452.16 595.25l9.07 5.23-9.07 5.24v-10.47z"/>
    <path class="cls-26" d="M780.98 665.77v110.3"/>
    <path class="cls-27" d="M775.74 667.31l5.24-9.07 5.23 9.07h-10.47z"/>
    <path class="cls-26" d="M780.98 1009.98V899.69"/>
    <path class="cls-27" d="M786.21 1008.45l-5.23 9.07-5.24-9.07h10.47z"/>
    <path class="cls-26" d="M453.7 358.81H233.11"/>
    <path class="cls-27" d="M452.16 353.57l9.07 5.24-9.07 5.24v-10.48z"/>
    <path class="cls-26" d="M698.46 601.48h-93.39"/>
    <path class="cls-27" d="M696.93 596.25l9.06 5.23-9.06 5.24v-10.47zM606.6 596.25l-9.06 5.23 9.06 5.24v-10.47z"/>
    <path class="cls-26" d="M524.03 198.61v2"/>
    <path stroke-dasharray="3.99 3.99" fill="none" stroke="#dedede" stroke-miterlimit="10" stroke-width="1.5" d="M524.03 204.6v77.77"/>
    <path class="cls-26" d="M524.03 284.37v2"/>
    <path class="cls-27" d="M518.8 200.14l5.23-9.07 5.24 9.07H518.8zM518.8 284.83l5.23 9.07 5.24-9.07H518.8z"/>
    <path class="cls-26" d="M453.7 116.98H233.11"/>
    <path class="cls-27" d="M452.16 111.74l9.07 5.24-9.07 5.24v-10.48z"/>
    <circle class="cls-29" cx="343.4" cy="115.77" r="21.84"/>
    <path d="M345.17 123.65h-1.68v-12.76a4 4 0 01-.57.45 9.54 9.54 0 01-.85.5 9 9 0 01-1 .46 6 6 0 01-1 .34v-1.71a10.45 10.45 0 001.18-.41c.41-.18.82-.37 1.22-.59a12.7 12.7 0 001.14-.68 8.65 8.65 0 00.93-.69h.63z"/>
    <circle class="cls-29" cx="282.78" cy="599.56" r="21.84"/>
    <path d="M285.05 596.55a3.07 3.07 0 00-.21-1.18 2.33 2.33 0 00-.58-.84 2.38 2.38 0 00-.86-.5 3.38 3.38 0 00-1.07-.16 3.54 3.54 0 00-1 .13 4.78 4.78 0 00-.92.37 5.34 5.34 0 00-.86.57 6 6 0 00-.78.73v-1.81a5.09 5.09 0 011.59-1.06 5.69 5.69 0 012.15-.36 5 5 0 011.67.26 3.71 3.71 0 011.34.77 3.4 3.4 0 01.89 1.24 4.16 4.16 0 01.33 1.7 6.07 6.07 0 01-.2 1.59 5 5 0 01-.61 1.33 6.31 6.31 0 01-1 1.21 16.19 16.19 0 01-1.46 1.17c-.69.5-1.26.92-1.71 1.27a7.63 7.63 0 00-1.07 1 2.85 2.85 0 00-.56.92 3.36 3.36 0 00-.16 1h7.35v1.52h-9.11v-.73a6 6 0 01.21-1.67 4.09 4.09 0 01.68-1.37 7.8 7.8 0 011.24-1.3c.51-.43 1.14-.92 1.88-1.46a11.8 11.8 0 001.33-1.1 5.76 5.76 0 00.87-1 3.72 3.72 0 00.47-1.07 4.71 4.71 0 00.16-1.17z"/>
    <circle class="cls-29" cx="343.8" cy="599.02" r="21.84"/>
    <path d="M348.64 602.22a5.37 5.37 0 01-.35 2 4.76 4.76 0 01-1 1.56 4.36 4.36 0 01-1.48 1 4.53 4.53 0 01-1.85.37 4.2 4.2 0 01-2-.46 4.14 4.14 0 01-1.49-1.34 6.55 6.55 0 01-.94-2.12 11.66 11.66 0 01-.32-2.83 13.53 13.53 0 01.43-3.5 8.54 8.54 0 011.22-2.69 5.46 5.46 0 011.9-1.72 5 5 0 012.48-.61 6 6 0 012.45.42v1.6a5.23 5.23 0 00-2.41-.59 3.64 3.64 0 00-1.73.48 4.25 4.25 0 00-1.36 1.25 6 6 0 00-.87 2 10 10 0 00-.31 2.54h.05a3.53 3.53 0 013.36-1.84 4.44 4.44 0 011.75.33 3.8 3.8 0 011.33.93 4.35 4.35 0 01.85 1.43 5.76 5.76 0 01.29 1.79zm-1.73.21a4.67 4.67 0 00-.19-1.39 3.1 3.1 0 00-.56-1 2.56 2.56 0 00-.9-.66 3.19 3.19 0 00-2.38 0 2.94 2.94 0 00-.93.65 3 3 0 00-.61.95 2.93 2.93 0 00-.22 1.14 4.71 4.71 0 00.21 1.43 3.88 3.88 0 00.61 1.16 2.74 2.74 0 00.93.77 2.53 2.53 0 001.2.29 2.78 2.78 0 001.17-.24 2.58 2.58 0 00.89-.68 3.13 3.13 0 00.58-1 4.33 4.33 0 00.2-1.42z"/>
    <circle class="cls-29" cx="105.77" cy="653.11" r="21.84"/>
    <path d="M110.48 647.21c-.22.39-.5.87-.81 1.46s-.66 1.24-1 2-.72 1.51-1.09 2.35-.72 1.7-1 2.6-.61 1.79-.85 2.71a21.07 21.07 0 00-.53 2.7h-1.81a19.61 19.61 0 01.57-2.69q.39-1.38.87-2.7c.33-.88.68-1.73 1-2.55s.72-1.56 1.06-2.25.66-1.29.94-1.82l.72-1.23h-7.41v-1.52h9.39z"/>
    <circle class="cls-29" cx="404.82" cy="600.48" r="21.84"/>
    <path d="M400.07 604.25a4.08 4.08 0 01.18-1.18 4.47 4.47 0 01.53-1.1 4.24 4.24 0 01.86-.94 3.91 3.91 0 011.16-.67 4.52 4.52 0 01-1.53-1.37 3.33 3.33 0 01-.56-1.86 3.54 3.54 0 011.18-2.7 4 4 0 011.32-.79 4.69 4.69 0 011.65-.28 4.44 4.44 0 011.65.29 4 4 0 011.32.79 3.66 3.66 0 01.87 1.19 3.73 3.73 0 01.31 1.5 3.26 3.26 0 01-.57 1.86 4.61 4.61 0 01-1.5 1.37 4.07 4.07 0 011.14.67 4.19 4.19 0 01.85.94 4.14 4.14 0 01.53 1.1 4.08 4.08 0 01.18 1.18 4.24 4.24 0 01-.35 1.77 3.9 3.9 0 01-1 1.38 4.61 4.61 0 01-1.51.89 5.76 5.76 0 01-1.94.32 5.7 5.7 0 01-1.93-.32 4.71 4.71 0 01-1.51-.89 4 4 0 01-1-1.38 4.4 4.4 0 01-.33-1.77zm1.83-.14a3.47 3.47 0 00.21 1.24 2.66 2.66 0 00.6 1 2.61 2.61 0 00.94.6 3.36 3.36 0 001.22.21 3.27 3.27 0 001.19-.21 2.88 2.88 0 00.94-.61 2.7 2.7 0 00.62-1 3.24 3.24 0 00.22-1.23 3.19 3.19 0 00-.21-1.16 2.84 2.84 0 00-.6-.95 2.6 2.6 0 00-.94-.65 3 3 0 00-1.22-.24 3 3 0 00-1.18.22 2.9 2.9 0 00-.94.62 2.85 2.85 0 00-.62 1 3.14 3.14 0 00-.23 1.16zm.53-6.85a2.4 2.4 0 00.19 1 2.32 2.32 0 00.52.78 2.45 2.45 0 00.78.53 2.34 2.34 0 00.95.19 2.37 2.37 0 00.95-.19 2.69 2.69 0 00.78-.53 2.64 2.64 0 00.52-.79 2.39 2.39 0 00.2-1 2.64 2.64 0 00-.19-1 2.39 2.39 0 00-1.3-1.3 2.38 2.38 0 00-1-.19 2.48 2.48 0 00-1 .19 2.58 2.58 0 00-.77.53 2.41 2.41 0 00-.5.79 2.83 2.83 0 00-.13.99z"/>
    <circle class="cls-29" cx="314.76" cy="357.61" r="21.84"/>
    <path d="M318.89 361.32a4.36 4.36 0 01-.38 1.82 4 4 0 01-1.06 1.4 5.18 5.18 0 01-1.64.9 6.72 6.72 0 01-2.11.32 6.1 6.1 0 01-3.36-.81v-1.81a5.41 5.41 0 003.42 1.17 4.74 4.74 0 001.4-.19 3.14 3.14 0 001.07-.57 2.64 2.64 0 00.69-.89 2.84 2.84 0 00.24-1.19q0-2.9-4.12-2.89h-1.23v-1.43h1.17q3.65 0 3.64-2.72c0-1.68-.92-2.51-2.78-2.51a4.72 4.72 0 00-2.93 1.05v-1.64a6.43 6.43 0 013.35-.84 5.2 5.2 0 011.68.25 4.23 4.23 0 011.29.72 3.18 3.18 0 01.83 1.12 3.51 3.51 0 01.29 1.43 3.61 3.61 0 01-2.94 3.75 4.52 4.52 0 011.39.36 3.87 3.87 0 011.1.74 3.16 3.16 0 01.72 1.07 3.25 3.25 0 01.27 1.39z"/>
    <circle class="cls-29" cx="376.18" cy="357.61" r="21.84"/>
    <path d="M380.83 357.23a14.6 14.6 0 01-.4 3.61 8 8 0 01-1.17 2.68 5.16 5.16 0 01-1.89 1.66 5.33 5.33 0 01-2.53.58 6.11 6.11 0 01-2.57-.52v-1.62a5.13 5.13 0 002.61.69 3.72 3.72 0 001.79-.41 3.54 3.54 0 001.33-1.2 5.86 5.86 0 00.84-1.94 11.05 11.05 0 00.29-2.64h-.05a3.37 3.37 0 01-3.29 1.9 4.49 4.49 0 01-1.74-.33 4 4 0 01-1.37-.95 4.49 4.49 0 01-.9-1.46 5.26 5.26 0 01-.32-1.86 5.39 5.39 0 01.36-2 4.83 4.83 0 011-1.56 4.32 4.32 0 011.5-1 4.91 4.91 0 011.9-.36 4.3 4.3 0 012 .44 3.94 3.94 0 011.45 1.31 6.55 6.55 0 01.9 2.12 12.34 12.34 0 01.26 2.86zm-1.82-1.51a5.11 5.11 0 00-.22-1.56 4 4 0 00-.61-1.2 2.74 2.74 0 00-.93-.77 2.62 2.62 0 00-1.18-.27 2.71 2.71 0 00-1.14.24 2.75 2.75 0 00-.91.68 3.22 3.22 0 00-.6 1 3.72 3.72 0 00-.23 1.31 4.33 4.33 0 00.22 1.4 3 3 0 00.6 1.05 2.6 2.6 0 00.94.65 3.19 3.19 0 001.22.23 2.84 2.84 0 002-.82 2.77 2.77 0 00.61-.89 2.66 2.66 0 00.23-1.05z"/>
    <path d="M760.77 804.22v15.87h-3.56v-22l19.25 11.17-1.78 3.07zm19.42 26.87l13.46-7.8-13.46-7.8 1.79-3.08 18.75 10.88-18.75 10.88zm-19.42 11.27l13.91-8.07 1.78 3.07-19.25 11.17v-22h3.56z" fill="#0063b1"/>
    <text class="cls-1" transform="translate(716.46 884.66)">
        Video Inde<tspan class="cls-4" x="95.58" y="0">x</tspan><tspan x="104.6" y="0">er</tspan>
    </text>
    <circle class="cls-29" cx="835.54" cy="755.9" r="21.84"/>
    <path d="M839.83 759.28a5 5 0 01-.37 2 4.42 4.42 0 01-1 1.5 4.79 4.79 0 01-1.66 1 6.6 6.6 0 01-2.15.34 6 6 0 01-3.06-.62v-1.79a5.69 5.69 0 003.08 1 4.12 4.12 0 001.45-.24 3.36 3.36 0 001.1-.66 2.79 2.79 0 00.69-1 3.47 3.47 0 00.24-1.31 2.8 2.8 0 00-1-2.26 4.26 4.26 0 00-2.81-.82h-2.5l.51-7.41h6.82v1.53h-5.36l-.3 4.33H834.87a6.53 6.53 0 012.1.31 4.52 4.52 0 011.57.88 3.66 3.66 0 011 1.4 5 5 0 01.29 1.82z"/>
    <path class="cls-31" d="M517.02 598.97h-17.34v-17.24h3.55a9.15 9.15 0 01-.62-3.44v-.21h-6.58v24.54h24.65V588h-3.66zM541.46 581.73h3.09v17.34h-17.3v-11h-3.65v14.52h24.64v-24.51h-7.69a7.42 7.42 0 01.94 3.44zM499.68 571.29v-17.23h17.34v10a9.83 9.83 0 013.66-1.67v-12h-24.65v24.55h7.1a10 10 0 012.3-3.56zM527.25 561.99v-7.93h17.3v17.33h-7.62a13 13 0 01.52 3.56v.1h10.75V550.4h-24.6v11.39c.31 0 .52-.11.83-.11a26.43 26.43 0 012.82.31z"/>
    <path d="M538.64 581.42a3.85 3.85 0 00-3.85-3.86h-.54a11.42 11.42 0 00.42-2.72 10.28 10.28 0 00-20-3.24 7.9 7.9 0 00-2.3-.41 7.1 7.1 0 000 14.2h22.77a4 4 0 003.5-3.97z" fill="#61b3d4"/>
    <path d="M516.08 585.39a7.11 7.11 0 013.47-11.91 5.71 5.71 0 012.29-.1 10.38 10.38 0 015.75-8.36 10.12 10.12 0 00-3.13-.52 10.24 10.24 0 00-9.72 7.1 8.12 8.12 0 00-2.3-.41 7.1 7.1 0 000 14.2z" fill="#80c2dc"/>
    <circle class="cls-29" cx="161.93" cy="1088" r="21.84"/>
    <path class="cls-34" d="M164.32 1080.79V1091h2v1.61h-2v3.63h-1.77v-3.63h-7.27v-1.53c.68-.76 1.36-1.57 2.05-2.44s1.35-1.74 2-2.64 1.21-1.78 1.74-2.66a24.76 24.76 0 001.36-2.55zm-7 10.21h5.23v-7.57q-.81 1.41-1.53 2.52c-.48.74-.94 1.41-1.38 2s-.85 1.15-1.24 1.63z"/>
    <circle class="cls-29" cx="224.49" cy="1087.66" r="21.84"/>
    <path class="cls-34" d="M219.83 1095.33h-1.77v-13.36a3.93 3.93 0 01-.6.47 7.87 7.87 0 01-.88.52 10 10 0 01-1 .49 6.57 6.57 0 01-1.06.35v-1.79a9.69 9.69 0 001.24-.43c.43-.19.86-.39 1.28-.62a12.46 12.46 0 001.19-.71 9.41 9.41 0 001-.73h.67zM234.92 1087.53a15.37 15.37 0 01-.35 3.44 8 8 0 01-1 2.53 4.49 4.49 0 01-1.63 1.56 4.39 4.39 0 01-2.19.54 4.19 4.19 0 01-2.08-.51 4.41 4.41 0 01-1.54-1.5 7.58 7.58 0 01-.94-2.41 14.57 14.57 0 01-.33-3.27 17.34 17.34 0 01.34-3.58 8.25 8.25 0 011-2.6 4.5 4.5 0 011.63-1.59 4.66 4.66 0 012.24-.53q4.85 0 4.85 7.92zm-1.81.18q0-6.6-3.14-6.6c-2.2 0-3.31 2.24-3.31 6.71 0 4.18 1.09 6.27 3.25 6.27s3.2-2.13 3.2-6.38z"/>
</svg>

<div class="architecture-tooltip-content" id="architecture-tooltip-1">
<p>The user creating the training session authenticates using their Azure Active Directory credentials from HoloLens.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-2">
<p>The client application connects to its own web service to create a training session. Metadata about that training session is stored in Azure Cosmos DB.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-3">
<p>The user scans the environment and places a first anchor where the first step of the procedure needs to happen. Azure Spatial Anchors validates that the user has sufficient permissions to create anchors via Azure AD, and then stores the anchor.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-4">
<p>The user records a video of the procedure on HoloLens and uploads it to Azure</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-5">
<p>The video is encoded with Media Services and prepared for on-demand viewing, as well as processed with Video Indexer for better content search. Video Indexer stores the metadata on Azure Cosmos DB.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-6">
<p>The app saves against its web service the anchor ID for that first step, alongside a link to the video.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-7">
<p>The user, in the same session, then moves on to step 2, places an anchor there, and again records a video of the procedure and saves the resulting anchor ID and video link to its web service. That process is then repeated until all steps in the procedure are executed. As the user moves from step to step, previous anchors are still visible with their respective step number.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-8">
<p>A trainee comes in, selects the training session, retrieves anchor IDs and links to videos that are part of the procedure.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-9">
<p>The trainee scans the room to find the anchors indicating the real-world location of each step in the procedure. As soon as one is found, all anchors are retrieved and shown in the app.</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-10">
<p>The trainee can then retrace the exact steps of the expert who recorded the procedure, and view holographic videos of each step at the right location in the lab.</p>
</div>

## Data Flow
1. The user creating the training session authenticates using their Azure Active Directory credentials from HoloLens.
1. The client application connects to its own web service to create a training session. Metadata about that training session is stored in Azure Cosmos DB.
1. The user scans the environment and places a first anchor where the first step of the procedure needs to happen. Azure Spatial Anchors validates that the user has sufficient permissions to create anchors via Azure AD, and then stores the anchor.
1. The user records a video of the procedure on HoloLens and uploads it to Azure
1. The video is encoded with Media Services and prepared for on-demand viewing, as well as processed with Video Indexer for better content search. Video Indexer stores the metadata on Azure Cosmos DB.
1. The app saves against its web service the anchor ID for that first step, alongside a link to the video.
1. The user, in the same session, then moves on to step 2, places an anchor there, and again records a video of the procedure and saves the resulting anchor ID and video link to its web service. That process is then repeated until all steps in the procedure are executed. As the user moves from step to step, previous anchors are still visible with their respective step number.
1. A trainee comes in, selects the training session, retrieves anchor IDs and links to videos that are part of the procedure.
1. The trainee scans the room to find the anchors indicating the real-world location of each step in the procedure. As soon as one is found, all anchors are retrieved and shown in the app.
1. The trainee can then retrace the exact steps of the expert who recorded the procedure, and view holographic videos of each step at the right location in the lab.

## Components
* [Spatial Anchors](https://azure.microsoft.com/services/spatial-anchors/): Create multi-user, spatially aware mixed reality experiences
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory/): Synchronize on-premises directories and enable single sign-on
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/): Globally distributed, multi-model database for any scale
* [App Service](https://azure.microsoft.com/services/app-service/): Quickly create powerful cloud apps for web and mobile
* [Media Services](https://azure.microsoft.com/services/media-services/): Encode, store, and stream video and audio at scale
* [Video Indexer](https://azure.microsoft.com/services/media-services/video-indexer/): Make your media more discoverable and accessible

## Next Steps
* [Share Spatial Anchors across devices](/azure/spatial-anchors/tutorials/tutorial-share-anchors-across-devices/)
* [Create a new tenant in Azure Active Directory](/azure/active-directory/fundamentals/active-directory-access-create-new-tenant/)
* [Build a .NET web app with Azure Cosmos DB using the SQL API and the Azure portal](/azure/cosmos-db/)
* [Authenticate and authorize users end-to-end in Azure App Service](/azure/app-service/app-service-web-tutorial-auth-aad/)
* [Upload, encode, and stream videos using .NET](/azure/media-services/latest/stream-files-tutorial-with-api/)
* [What is Video Indexer?](/azure/media-services/latest/stream-files-tutorial-with-api/)

[!INCLUDE [js_include_file](../../_js/index.md)]
