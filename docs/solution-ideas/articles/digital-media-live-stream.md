---
title: Live streaming digital media
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: A live streaming solution allows you to capture video in real-time and broadcast it to consumers in real time, such as streaming interviews, conferences, and sporting events online.
ms.custom: acom-architecture, media, 'https://azure.microsoft.com/solutions/architecture/digital-media-live-stream/'
---
# Live streaming digital media

[!INCLUDE [header_file](../header.md)]

A live streaming solution allows you to capture video in real-time and broadcast it to consumers in real time, such as streaming interviews, conferences, and sporting events online. In this solution, video is captured by a video camera and sent to a channel input endpoint. The channel receives the live input stream and makes it available for streaming through a streaming endpoint to a web browser or mobile app. The channel also provides a preview monitoring endpoint to preview and validate your stream before further processing and delivery. The channel can also record and store the ingested content in order to be streamed later (video-on-demand).

This solution is built on the Azure managed services: [Media Services](https://azure.microsoft.com/services/media-services/) and [Content Delivery Network](https://azure.microsoft.com/services/cdn/). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

<svg class="architecture-diagram" aria-labelledby="digital-media-live-stream" height="353.645" viewbox="0 0 814.247 353.645"  xmlns="http://www.w3.org/2000/svg">
    <path fill="#ededee" opacity=".5" d="M129.255 103.645h156v124h-156z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M115.167 161.73H68.163"/>
    <path fill="#b5b6b6" d="M113.744 156.868l8.419 4.862-8.419 4.861v-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M214.167 161.73h-20.004"/>
    <path fill="#b5b6b6" d="M212.744 156.868l8.419 4.862-8.419 4.861v-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M327.259 291.028l-13.096.195V161.73h-22"/>
    <path fill="#b5b6b6" d="M325.765 286.188l8.49 4.736-8.346 4.987-.144-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M423.167 161.73h-20.004"/>
    <path fill="#b5b6b6" d="M421.744 156.868l8.419 4.862-8.419 4.861v-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M370.163 233.727v27.003"/>
    <path fill="#b5b6b6" d="M365.302 235.149l4.861-8.419 4.862 8.419h-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M504.167 161.73h-19.004"/>
    <path fill="#b5b6b6" d="M502.744 156.868l8.419 4.862-8.419 4.861v-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M628.163 161.73h-22M627.557 96.227v146.006"/>
    <path fill="#b5b6b6" d="M622.696 97.649l4.861-8.419 4.862 8.419h-9.723zM622.696 240.81l4.861 8.42 4.862-8.42h-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M666.255 15.73h101.218v98.919"/>
    <path fill="#b5b6b6" d="M762.611 113.226l4.862 8.419 4.862-8.419h-9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M673.252 30.73h79.221v90.915"/>
    <path fill="#b5b6b6" d="M674.675 35.591l-8.42-4.861 8.42-4.862v9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M666.255 296.353h101.218v-62.919"/>
    <path fill="#b5b6b6" d="M772.335 234.857l-4.862-8.419-4.862 8.419h9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M124.318 296.353h79.824v-62.919"/>
    <path fill="#b5b6b6" d="M209.004 234.857l-4.862-8.419-4.861 8.419h9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M34.721 216.818v79.824h39.633M673.252 281.353h79.221v-54.915"/>
    <path fill="#b5b6b6" d="M674.675 286.215l-8.42-4.862 8.42-4.861v9.723z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(682.417 10.551)">
        <tspan letter-spacing="-.098em">T</tspan><tspan x="4.263" y="0">oken</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(682.417 309.646)">
        <tspan letter-spacing="-.098em">T</tspan><tspan x="4.263" y="0">oken</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(684.993 44.146)">
        License/<tspan letter-spacing="-.013em" x="36.006" y="0">K</tspan><tspan x="41.675" y="0">ey</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(684.993 275.271)">
        License/<tspan letter-spacing="-.013em" x="36.006" y="0">K</tspan><tspan x="41.675" y="0">ey</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(189.709 117.646)">
        Channel
    </text>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M187.061 19.897h-32.004v81.939"/>
    <path fill="#b5b6b6" d="M185.638 15.035l8.419 4.862-8.419 4.862v-9.724z"/>
    <path d="M240.375 178.766a2.6 2.6 0 001.528 2.306l1.944-4.667a2.6 2.6 0 00-.944-.167 2.485 2.485 0 00-2.528 2.528z" fill="none"/>
    <path d="M240.375 178.766a2.5 2.5 0 012.528-2.528 2.6 2.6 0 01.944.167l1.306-3.139-.583-.25-.833-2.25h-1.778l-.111.25-.639 1.944-1.25.528-2.056-1-1.25 1.306.111.25.944 1.833-.528 1.25-2.194.778v1.833l.25.056 1.944.639.528 1.25-1 2.056 1.306 1.306.25-.111 1.833-.944.528.25 1.306-3.139a2.648 2.648 0 01-1.556-2.335z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    <path fill="#9fa0a2" d="M12.599 152.012h30.162v19.726H12.599z"/>
    <circle cx="18.581" cy="142.636" fill="#9fa0a2" r="8.753"/>
    <circle cx="36.78" cy="142.636" fill="#9fa0a2" r="8.753"/>
    <path fill="#9fa0a2" d="M56.709 171.229l-13.724-4.376v-10.791l13.724-4.377v19.544zM19.62 193.277h-2.626l5.106-20.6h4.814l-7.294 20.6zM36.433 193.277h2.626l-5.106-20.6h-4.814l7.294 20.6z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(0 212.609)">
        Live Source
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(706.787 200.2)">
        Cloud DRM License/<tspan letter-spacing="-.013em" x="5.282" y="14.4">K</tspan><tspan x="12.085" y="14.4">ey Delivery Serve</tspan>
    </text>
    <path d="M782.87 160.746a22.453 22.453 0 00-8.8-17.8v.7a13.743 13.743 0 01-1.5 6.1 16.294 16.294 0 11-28.4 10.9 16.426 16.426 0 014.7-11.5 13.161 13.161 0 01-1.3-5.6 5.7 5.7 0 01.1-1.3 22.44 22.44 0 1035.2 18.5z" fill="#7fbb42"/>
    <path d="M760.77 133.146a10.31 10.31 0 00-2.9 20.2v10.2h-4.8v5.2h4.8v3.8h5.7v-19.3a10.23 10.23 0 007.4-9.9 10.115 10.115 0 00-10.2-10.2zm0 5.4a4.9 4.9 0 11-4.9 4.9 4.908 4.908 0 014.9-4.9z" fill="#fbd118"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(341.735 200.199)">
        <tspan letter-spacing="-.032em">S</tspan><tspan x="5.988" y="0">treaming</tspan><tspan x="2.965" y="14.4">Endpoint</tspan>
    </text>
    <path d="M391.589 175.373a5.52 5.52 0 01-5.52 5.52h-34.96a5.52 5.52 0 01-5.52-5.52v-34.96a5.52 5.52 0 015.52-5.52h34.961a5.52 5.52 0 015.52 5.52z" fill="#5bb4da"/>
    <path d="M358.47 180.896h-7.36a5.52 5.52 0 01-5.52-5.52v-34.96a5.52 5.52 0 015.52-5.52h31.28z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path d="M360.309 170.163V145.63l19.6 12.279z" fill="#fff"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(418.216 200.199)">
        Multi-Protocol<tspan x="15.422" y="14.4">Dynamic</tspan><tspan letter-spacing="-.034em" x="9.105" y="28.8">P</tspan><tspan x="15.416" y="28.8">ackaging/</tspan><tspan x="9.067" y="43.2">Multi-DRM</tspan>
    </text>
    <path d="M470.442 157.209v-1.671a12.434 12.434 0 00-3.342-8.658c-1.975-2.278-6.379-3.721-9.645-3.721s-7.67 1.443-9.645 3.721a12.785 12.785 0 00-3.342 8.658v1.671l6 .683v-1.519a9.68 9.68 0 011.823-5.772c1.139-1.291 3.569-1.9 5.164-1.975a7.7 7.7 0 015.164 1.975 7.253 7.253 0 011.823 4.86v2.43z" fill="#3f3f3f"/>
    <path d="M444.47 157.209c-2.962 0-4.025 1.747-4.025 4.025v15.872c0 1.975 1.215 4.025 3.493 4.025h27.032c2.582 0 3.493-2.05 3.493-4.025v-15.872c0-2.05-.835-4.025-4.025-4.025H444.47z" fill="#5bb4da"/>
    <path fill="#fff" d="M454.699 162.905l8.354 5.556-8.354 5.555v-11.111z"/>
    <path d="M464.37 157.209h-19.9c-2.962 0-4.025 1.747-4.025 4.025v15.872c0 1.975 1.215 4.025 3.493 4.025h5.088z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(531.701 200.609)">
        Azure CDN
    </text>
    <path d="M574.681 158.232h-39.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h39.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3zM566.581 183.282h-36.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h36.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3zM562.231 171.132h-36.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h36.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3z" fill="#7c7b7b"/>
    <path d="M597.331 176.832a6.371 6.371 0 00-6.3-6.45h-.9a20.411 20.411 0 00.6-4.5 16.869 16.869 0 00-16.8-16.8 17.071 17.071 0 00-15.9 11.4 15.081 15.081 0 00-3.75-.6 11.7 11.7 0 000 23.4h37.05a6.626 6.626 0 006-6.45" fill="#3999c7"/>
    <path d="M560.281 183.132a10.682 10.682 0 01-3.15-5.7 11.275 11.275 0 0112.45-13.95 16.334 16.334 0 019.45-13.5 19.139 19.139 0 00-5.1-.9 17.071 17.071 0 00-15.9 11.4 15.081 15.081 0 00-3.75-.6 11.7 11.7 0 000 23.4l6-.15z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(341.327 331.527)">
        Azure Blob<tspan letter-spacing="-.032em" x="8.429" y="14.4">S</tspan><tspan x="14.417" y="14.4">torage</tspan>
    </text>
    <path d="M345.108 310.424a1.88 1.88 0 001.8 1.9h46.3a1.9 1.9 0 001.9-1.9v-33.1h-50z" fill="#9fa0a2"/>
    <path d="M393.208 269.624h-46.3a1.88 1.88 0 00-1.8 1.9v5.7h50v-5.7a1.9 1.9 0 00-1.9-1.9" fill="#7c7b7b"/>
    <path fill="#2272b9" d="M348.808 280.724h20.4v13h-20.4zM348.808 295.524h20.4v13h-20.4z"/>
    <path fill="#fff" d="M371.008 280.724h20.3v13h-20.3z"/>
    <path fill="#2272b9" d="M371.008 295.524h20.3v13h-20.3z"/>
    <path d="M347.108 269.624a2.006 2.006 0 00-2 2v38.6a2.006 2.006 0 002 2h2.2l39.4-42.6z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path d="M229.035 39.596h-13.6c1.6 5.8-.6 6.6-10.2 6.6v3h32.6v-3c-9.5 0-10.4-.8-8.8-6.6" fill="#7c7b7b"/>
    <path d="M243.635 1.896h-44.3a2.866 2.866 0 00-2.7 2.9v32a2.775 2.775 0 002.7 2.8h44.3a3.045 3.045 0 003-2.8v-32a3.134 3.134 0 00-3-2.9m-.8 3.9v29.9h-42.4v-29.9l42.4-.1z" fill="#9fa0a2"/>
    <path fill="#5bb4da" d="M242.835 35.695h-42.4v-29.9l42.4-.1v30z"/>
    <path d="M200.435 35.696v-29.9l38.7-.1 4.5-3.8h-44.3a2.866 2.866 0 00-2.7 2.9v32a2.775 2.775 0 002.7 2.8h1.1l4.6-3.8h-4.6z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path fill="#5bb4da" d="M200.435 35.695v-29.9l38.7-.1-38.7.1v29.9z"/>
    <path fill="#9fa0a2" d="M205.335 46.195h32.7v3h-32.7z"/>
    <path d="M215.223 21.096l-.5-.5a.446.446 0 010-.5l1.4-1.2c0-.1.1-.1.2-.1s.2 0 .2.1l3.7 4 6.4-8.1a.367.367 0 01.3-.1c.1 0 .1 0 .2.1l1.5 1c.1.1.1.1.1.2s0 .2-.1.2l-8.3 10.5z" fill="#fff"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(201.3 64.421)">
        Preview<tspan x="-9.384" y="14.4">Monitoring</tspan>
    </text>
    <path d="M602.256 44.399a2.007 2.007 0 002.007 2.007h45.986a2.007 2.007 0 002.007-2.007V13.073h-50z" fill="#5bb4da"/>
    <path d="M650.249 3.773h-45.986a2.006 2.006 0 00-2.007 2.007v10.626h50V5.779a2.007 2.007 0 00-2.007-2.006" fill="#9fa0a2"/>
    <path d="M604.27 3.773a2.007 2.007 0 00-2.007 2.007V44.4a2.008 2.008 0 002.007 2.007h2.188l39.418-42.634z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path fill="#fff" d="M615.112 8.551h33.671v3.942h-33.671z"/>
    <path d="M613.57 10.455a4.878 4.878 0 11-4.882-4.882 4.879 4.879 0 014.878 4.879" fill="#5bb4da"/>
    <path fill="#fff" d="M608.171 11.004l2.213 2.336h-1.201l-2.959-2.818 2.948-2.818h1.198l-2.199 2.322h5.393v.978h-5.393z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(576.261 64.646)">
        Azure Media Player<tspan x="23.408" y="14.4">in Browser</tspan>
    </text>
    <circle cx="627.557" cy="30.73" fill="#5bb4da" r="11.52"/>
    <path d="M619.412 38.873a11.52 11.52 0 1116.292-16.292z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path fill="#fff" d="M624.873 35.663l.018-9.867 7.864 4.939-7.882 4.928z"/>
    <path d="M627.558 20.953a9.778 9.778 0 11-9.778 9.778 9.778 9.778 0 019.778-9.778m0-2.222a12 12 0 1012 12 12.014 12.014 0 00-12-12z" fill="#3f3f3f"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(575.986 331.846)">
        Azure Media Player<tspan x="13.512" y="14.4">in Mobile App</tspan>
    </text>
    <path d="M644.478 308.624a3 3 0 01-3 3h-28.445a3 3 0 01-3-3v-44a3 3 0 013-3h28.445a3 3 0 013 3z" fill="#3f3f3f"/>
    <path fill="#5bb4da" d="M612.257 266.624h30v35.222h-30z"/>
    <path d="M630.145 306.734a2.889 2.889 0 11-2.89-2.889 2.889 2.889 0 012.89 2.889" fill="#fff"/>
    <path d="M629.15 306.734a1.894 1.894 0 11-1.9-1.894 1.9 1.9 0 011.9 1.894" fill="#b8d433"/>
    <path d="M612.256 301.846v-35.222h22.767l2.031-5h-24.021a3 3 0 00-3 3v44a3 3 0 003 3h3.695l3.974-9.778z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path d="M632.37 264.441a.737.737 0 01-.738.738h-8.744a.739.739 0 110-1.477h8.744a.738.738 0 01.738.739" fill="#1e1e1e"/>
    <path d="M632.37 264.441a.737.737 0 01-.738.738h-8.744a.739.739 0 110-1.477h8.744a.738.738 0 01.738.739" fill="#fff"/>
    <circle cx="627.557" cy="284.353" fill="#5bb4da" r="11.52"/>
    <path d="M619.412 292.5a11.52 11.52 0 0116.292-16.292z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path fill="#fff" d="M624.873 289.287l.018-9.867 7.864 4.939-7.882 4.928z"/>
    <path d="M627.558 274.573a9.778 9.778 0 11-9.778 9.778 9.778 9.778 0 019.778-9.778m0-2.222a12 12 0 1012 12 12.014 12.014 0 00-12-12z" fill="#3f3f3f"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(136.871 200.242)">
        Azure Live<tspan x="5.66" y="14.4">Encoder</tspan>
    </text>
    <path d="M173.696 174.457h-18.9a3.521 3.521 0 010-7.042h18.9a4.544 4.544 0 004.539-4.542v-18.342a4.544 4.544 0 00-4.539-4.539h-18.9a3.521 3.521 0 010-7.042h18.9a11.594 11.594 0 0111.581 11.581v18.342a11.594 11.594 0 01-11.581 11.584zM149.049 178.72h19.056v1.76h-19.056zM155.057 180.48h7.042v2.47h-7.042z" fill="#3f3f3f"/>
    <path fill="#3f3f3f" d="M157.697 139.992h1.76v40.489h-1.76z"/>
    <path fill="#618dc9" d="M142.734 153.314H170.9v7.922h-28.166z"/>
    <path fill="#5bb4da" d="M148.015 145.393h19.364v7.922h-19.364z"/>
    <path fill="#676767" d="M155.057 142.752h7.042v2.641h-7.042zM155.057 161.236h7.042v2.47h-7.042z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(76.792 308.222)">
        3rd <tspan letter-spacing="-.034em" x="20.994" y="0">P</tspan><tspan x="27.305" y="0">arty </tspan><tspan x="-8.382" y="14.4">On-Premises</tspan><tspan x="-8.036" y="28.8">Live Encoder</tspan>
    </text>
    <path d="M111.854 282.437h-18.9a3.521 3.521 0 010-7.042h18.9a4.544 4.544 0 004.539-4.539v-18.345a4.544 4.544 0 00-4.539-4.539h-18.9a3.521 3.521 0 010-7.042h18.9a11.594 11.594 0 0111.581 11.581v18.346a11.594 11.594 0 01-11.581 11.58zM87.207 286.7h19.056v1.76H87.207zM93.215 288.46h7.042v2.47h-7.042z" fill="#3f3f3f"/>
    <path fill="#3f3f3f" d="M95.855 247.972h1.76v40.489h-1.76z"/>
    <path fill="#618dc9" d="M80.892 261.294h28.166v7.922H80.892z"/>
    <path fill="#5bb4da" d="M86.173 253.373h19.364v7.922H86.173z"/>
    <path fill="#676767" d="M93.215 250.732h7.042v2.641h-7.042zM93.215 269.216h7.042v2.47h-7.042z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(224.204 200.242)">
        Program
    </text>
    <path d="M260.653 173.488a20.546 20.546 0 01-25-32.611 20.892 20.892 0 0112.5-4.194 20.507 20.507 0 0112.5 36.806" fill="#5bb4da"/>
    <path d="M264.458 159.682a4.243 4.243 0 00-.611-4.194 4.377 4.377 0 00-5.694-1.111c-2.111-1.889-4.389-4-6.806-6.389 7.306-4 12.5-3.611 12.806-3.611a19.151 19.151 0 00-3-3 21.688 21.688 0 00-13.694 2.611 85.863 85.863 0 01-5.694-6.306 27.582 27.582 0 00-2.694 1.111 41.75 41.75 0 005.5 7 34.415 34.415 0 00-5.722 4.889c-.194.306-.5.5-.694.806a6.687 6.687 0 00-3.389.194 14.964 14.964 0 01-1.391-8.809c-.694.889-1.389 1.806-2.111 2.694a12.841 12.841 0 00.806 8.194 6.168 6.168 0 000 7.5 1.436 1.436 0 00.5.5 32.219 32.219 0 00-1.195 7.112c.194.306.306.5.5.806a21.252 21.252 0 003.306 3.389 22.953 22.953 0 011.389-9.306 5.905 5.905 0 002.889-.5c.5.5 1.111.889 1.694 1.389a32.665 32.665 0 006 3.806 3.869 3.869 0 00.806 2.889 4.1 4.1 0 005.694.806 3.007 3.007 0 00.889-1 35.929 35.929 0 007.889.806 22.18 22.18 0 002.5-2.889c.111-.111.111-.194.194-.306a20.7 20.7 0 01-10.111-.694 4.651 4.651 0 00-.694-1.611 3.932 3.932 0 00-5.389-.889 39.708 39.708 0 01-5.5-3.694c-.389-.306-.806-.611-1.111-.889a6.237 6.237 0 00.306-6.194l.694-.694a58.042 58.042 0 015.444-4.306c2.583 2.389 5.278 4.583 7.778 6.583a4.125 4.125 0 00.5 4.5 4.453 4.453 0 006.194.806l.306-.306c1.806 1.306 3.306 2.306 4.111 2.806a14.583 14.583 0 00.5-1.806 34.491 34.491 0 01-3.695-2.693z" fill="#fff"/>
    <path d="M272.542 162.573l-.389.194-3.111 1.611-2.111-.889-1.306-3.694h-2.972l-.194.389-1.111 3.306-2.111.889-3.5-1.694-2.112 2.188.194.389 1.611 3.111-.889 2.111-3.694 1.306v3.111l.389.111 3.306 1.111.889 2.111-1.667 3.444 2.194 2.195.389-.194 3.111-1.611 2.111.889 1.306 3.694h3.111l.111-.389 1.111-3.306 2.111-.889 3.611 1.694 2.194-2.194-2-3.5.889-2.111 3.694-1.306v-2.972l-.389-.194-3.306-1.111-.889-2.111 1.5-3.194zm-8.278 15a4.306 4.306 0 114.306-4.306 4.274 4.274 0 01-4.306 4.306z" fill="#7c7b7b"/>
    <path d="M259.958 173.293a4.395 4.395 0 002.611 3.889l3.306-7.889a4.321 4.321 0 00-5.917 4z" fill="none"/>
    <path d="M259.958 173.293a4.321 4.321 0 015.917-4l2.194-5.306-1-.389-1.389-3.806h-3.028l-.194.389-1.111 3.306-2.111.889-3.5-1.694-2.111 2.191.194.389 1.611 3.111-.889 2.111-3.694 1.306v3.111l.389.111 3.306 1.111.889 2.111-1.667 3.444 2.194 2.195.389-.194 3.111-1.611.889.389 2.194-5.306a4.3 4.3 0 01-2.583-3.858z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    <path d="M247.819 172.432l-.25.111-1.833.944-1.25-.528-.778-2.194h-1.778l-.111.25-.639 1.944-1.25.528-2.056-1-1.25 1.306.111.25.944 1.833-.528 1.25-2.194.778v1.833l.25.056 1.944.639.528 1.25-1 2.056 1.306 1.306.25-.111 1.833-.944 1.25.528.778 2.194h1.833l.056-.25.639-1.944 1.25-.528 2.139 1 1.306-1.306-1.194-2.056.528-1.25 2.194-.778v-1.778l-.25-.111-1.944-.639-.528-1.25.889-1.889zm-4.917 8.861a2.528 2.528 0 112.528-2.528 2.5 2.5 0 01-2.527 2.528z" fill="#7c7b7b"/>
</svg>

## Components
* [Partner on-premises live encoder](/api/Redirect/documentation/articles/media-services-live-encoders-overview/): Outputs the live source for ingest into the cloud as RTMP, MPEG-Transport Stream, or fragmented mp4 formats.
* Stores large amounts of unstructured data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. You can use [Blob storage](https://azure.microsoft.com/services/storage/blobs/) to expose data publicly to the world, or to store application data privately.
* [Media Services](https://azure.microsoft.com/services/media-services/): Provides the ability to ingest, encode, preview, store, and deliver your live streaming content. Channels, programs, and streaming endpoints handle the live streaming functions, including ingestion, formatting, DVR, security, scalability, and redundancy.
* [Azure streaming endpoint](https://azure.microsoft.com/services/media-services/live-on-demand/): Represents a streaming service that can deliver content directly to a client player application, or to a content delivery network (CDN) for further distribution.
* [Content Delivery Network](https://azure.microsoft.com/services/cdn/): Provides secure, reliable content delivery with broad global reach and a rich feature set.
* [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player/): Uses industry standards such as HTML5 (MSE/EME) to provide an enriched adaptive streaming experience. Regardless of the playback technology used, developers have a unified JavaScript interface to access APIs.
* [Preview monitoring](/api/Redirect/documentation/articles/web-sites-monitor/): Provides the ability to preview and validate a live stream before further processing and delivery.
* [Multi-DRM content protection](https://azure.microsoft.com/services/media-services/content-protection/): Delivers content securely using multi-DRM (PlayReady, Widevine, FairPlay Streaming) or AES clear key encryption.

## Next Steps
* [Overview of live encoder](/api/Redirect/documentation/articles/media-services-live-encoders-overview/)
* [How to use Azure Blob storage](/api/Redirect/documentation/articles/storage-dotnet-how-to-use-blobs/)
* [Overview of live streaming](/api/Redirect/documentation/articles/media-services-manage-channels-overview/)
* [How to manage streaming endpoints](/api/Redirect/documentation/articles/media-services-manage-origins/)
* [Using Azure Content Delivery Network](/api/Redirect/documentation/articles/cdn-create-new-endpoint/)
* [Develop video player applications](/api/Redirect/documentation/articles/media-services-develop-video-players/)
* [How to monitor apps in Azure App Service](/api/Redirect/documentation/articles/media-services-develop-video-players/)
* [Deliver content securely](https://azure.microsoft.com/services/media-services/content-protection/)

[!INCLUDE [js_include_file](../../_js/index.md)]
