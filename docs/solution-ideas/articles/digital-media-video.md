---
title: Video-on-demand digital media
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: A basic video-on-demand solution that gives you the capability to stream recorded video content such as movies, news clips, sports segments, training videos, and customer support tutorials to any video-capable endpoint device, mobile application, or desktop browser. Video files are uploaded to Azure Blob storage, encoded to a multi-bitrate standard format, and then distributed via all major adaptive bit-rate streaming protocols (HLS, MPEG-DASH, Smooth) to the Azure Media Player client.
ms.custom: acom-architecture, media, 'https://azure.microsoft.com/solutions/architecture/digital-media-video/'
---
# Video-on-demand digital media

[!INCLUDE [header_file](../header.md)]

A basic video-on-demand solution that gives you the capability to stream recorded video content such as movies, news clips, sports segments, training videos, and customer support tutorials to any video-capable endpoint device, mobile application, or desktop browser. Video files are uploaded to Azure Blob storage, encoded to a multi-bitrate standard format, and then distributed via all major adaptive bit-rate streaming protocols (HLS, MPEG-DASH, Smooth) to the Azure Media Player client.

This solution is built on the Azure managed services: [Blob Storage](https://azure.microsoft.com/services/storage/blobs/), [Content Delivery Network](https://azure.microsoft.com/services/cdn/) and [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player/). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

<svg class="architecture-diagram" aria-labelledby="digital-media-video" height="348.129" viewbox="0 0 746.468 348.129"  xmlns="http://www.w3.org/2000/svg">
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M101.758 158.68H64.754"/>
    <path fill="#b5b6b6" d="M100.335 153.818l8.419 4.862-8.419 4.862v-9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M216.758 158.68h-37.004"/>
    <path fill="#b5b6b6" d="M215.335 153.818l8.419 4.862-8.419 4.862v-9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M327.758 158.68h-37.004"/>
    <path fill="#b5b6b6" d="M326.335 153.818l8.419 4.862-8.419 4.862v-9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M574.754 158.68h-45M574.148 102.177v137.006"/>
    <path fill="#b5b6b6" d="M569.287 103.599l4.861-8.419 4.862 8.419h-9.723zM569.287 237.761l4.861 8.419 4.862-8.419h-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M165.758 27.68h-22.004v84.919"/>
    <path fill="#b5b6b6" d="M164.335 22.818l8.419 4.862-8.419 4.862v-9.724zM138.893 111.176l4.861 8.42 4.862-8.42h-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M612.846 15.68h101.218v88.534"/>
    <path fill="#b5b6b6" d="M709.202 102.792l4.862 8.419 4.862-8.419h-9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M619.843 29.47h79.221v81.741"/>
    <path fill="#b5b6b6" d="M621.266 34.331l-8.42-4.861 8.42-4.862v9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M612.846 293.304h101.218v-62.919"/>
    <path fill="#b5b6b6" d="M718.926 231.807l-4.862-8.419-4.862 8.419h9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M619.843 278.304h79.221v-54.916"/>
    <path fill="#b5b6b6" d="M621.266 283.165l-8.42-4.861 8.42-4.862v9.723z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(629.007 8.501)">
        <tspan letter-spacing="-.098em">T</tspan><tspan x="4.263" y="0">oken</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(629.007 308.596)">
        <tspan letter-spacing="-.098em">T</tspan><tspan x="4.263" y="0">oken</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(631.584 47.096)">
        License/<tspan letter-spacing="-.013em" x="36.006" y="0">K</tspan><tspan x="41.675" y="0">ey</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(631.584 270.221)">
        License/<tspan letter-spacing="-.013em" x="36.006" y="0">K</tspan><tspan x="41.675" y="0">ey</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(114.399 197.149)">
        Azure Blob<tspan letter-spacing="-.032em" x="8.429" y="14.4">S</tspan><tspan x="14.417" y="14.4">torage</tspan>
    </text>
    <path d="M118.179 176.046a1.88 1.88 0 001.8 1.9h46.3a1.9 1.9 0 001.9-1.9v-33.1h-50z" fill="#9fa0a2"/>
    <path d="M166.279 135.246h-46.3a1.88 1.88 0 00-1.8 1.9v5.7h50v-5.7a1.9 1.9 0 00-1.9-1.9" fill="#7c7b7b"/>
    <path fill="#2272b9" d="M121.88 146.346h20.4v13h-20.4zM121.88 161.146h20.4v13h-20.4z"/>
    <path fill="#fff" d="M144.08 146.346h20.3v13h-20.3z"/>
    <path fill="#2272b9" d="M144.08 161.146h20.3v13h-20.3z"/>
    <path d="M120.179 135.246a2.006 2.006 0 00-2 2v38.6a2.006 2.006 0 002 2h2.2l39.4-42.6z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(229.326 197.149)">
        <tspan letter-spacing="-.032em">S</tspan><tspan x="5.988" y="0">treaming</tspan><tspan x="2.965" y="14.4">Endpoint</tspan>
    </text>
    <path d="M279.179 172.326a5.52 5.52 0 01-5.52 5.52h-34.96a5.52 5.52 0 01-5.52-5.52v-34.96a5.52 5.52 0 015.52-5.52h34.96a5.52 5.52 0 015.52 5.52z" fill="#5bb4da"/>
    <path d="M246.059 177.846h-7.36a5.52 5.52 0 01-5.52-5.52v-34.96a5.52 5.52 0 015.52-5.52h31.28z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path d="M247.899 167.115V142.58l19.6 12.279z" fill="#fff"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(321.163 197.149)">
        Multi-Protocol <tspan x="15.422" y="14.4">Dynamic </tspan><tspan letter-spacing="-.034em" x="10.749" y="28.8">P</tspan><tspan x="17.06" y="28.8">ackaging/</tspan><tspan x="10.711" y="43.2">Multi-DRM</tspan>
    </text>
    <path d="M375.032 154.159v-1.671a12.434 12.434 0 00-3.342-8.658c-1.975-2.278-6.379-3.721-9.645-3.721s-7.67 1.443-9.645 3.721a12.785 12.785 0 00-3.342 8.658v1.671l6 .683v-1.519a9.68 9.68 0 011.823-5.772c1.139-1.291 3.569-1.9 5.164-1.975a7.7 7.7 0 015.164 1.975 7.253 7.253 0 011.823 4.86v2.43z" fill="#3f3f3f"/>
    <path d="M349.06 154.159c-2.962 0-4.025 1.747-4.025 4.025v15.872c0 1.975 1.215 4.025 3.493 4.025h27.036c2.582 0 3.493-2.05 3.493-4.025v-15.872c0-2.05-.835-4.025-4.025-4.025H349.06z" fill="#5bb4da"/>
    <path fill="#fff" d="M359.29 159.855l8.354 5.556-8.354 5.556v-11.112z"/>
    <path d="M368.957 154.159h-19.9c-2.962 0-4.025 1.747-4.025 4.025v15.872c0 1.975 1.215 4.025 3.493 4.025h5.088z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M427.758 158.68h-38.004"/>
    <path fill="#b5b6b6" d="M426.335 153.818l8.419 4.862-8.419 4.862v-9.724z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(168.859 70.483)">
        Azure Encoder<tspan x="5.584" y="14.4">(</tspan><tspan letter-spacing="-.032em" x="9.205" y="14.4">S</tspan><tspan x="15.193" y="14.4">tandard or</tspan><tspan x="12.741" y="28.8">Premium)</tspan>
    </text>
    <path d="M216.869 44.697h-18.9a3.521 3.521 0 010-7.042h18.9a4.544 4.544 0 004.539-4.539V14.771a4.544 4.544 0 00-4.539-4.539h-18.9a3.521 3.521 0 010-7.042h18.9a11.594 11.594 0 0111.577 11.581v18.344a11.594 11.594 0 01-11.577 11.582zM192.224 48.96h19.056v1.76h-19.056zM198.232 50.72h7.042v2.47h-7.042z" fill="#3f3f3f"/>
    <path fill="#3f3f3f" d="M200.872 10.232h1.76v40.489h-1.76z"/>
    <path fill="#618dc9" d="M185.909 23.554h28.166v7.922h-28.166z"/>
    <path fill="#5bb4da" d="M191.19 15.633h19.364v7.922H191.19z"/>
    <path fill="#676767" d="M198.232 12.992h7.042v2.641h-7.042zM198.232 31.476h7.042v2.47h-7.042z"/>
    <path d="M548.846 44.349a2.007 2.007 0 002.007 2.007h45.986a2.007 2.007 0 002.007-2.007V13.015h-50z" fill="#5bb4da"/>
    <path d="M596.839 3.722h-45.986a2.006 2.006 0 00-2.007 2.007v10.627h50V5.729a2.007 2.007 0 00-2.007-2.007" fill="#9fa0a2"/>
    <path d="M550.86 3.722a2.007 2.007 0 00-2.007 2.007v38.62a2.008 2.008 0 002.007 2.007h2.186l39.42-42.634z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path fill="#fff" d="M561.703 8.501h33.671v3.942h-33.671z"/>
    <path d="M560.156 10.405a4.878 4.878 0 11-4.878-4.879 4.879 4.879 0 014.878 4.879" fill="#5bb4da"/>
    <path fill="#fff" d="M554.762 10.954l2.213 2.336h-1.201l-2.959-2.818 2.948-2.818h1.198l-2.199 2.322h5.393v.978h-5.393z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(522.852 70.596)">
        Azure Media Player<tspan x="23.408" y="14.4">in Browser</tspan>
    </text>
    <circle cx="574.148" cy="30.68" fill="#5bb4da" r="11.52"/>
    <path d="M566.002 38.826a11.52 11.52 0 0116.292-16.292z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path fill="#fff" d="M571.464 35.614l.018-9.867 7.864 4.938-7.882 4.929z"/>
    <path d="M574.146 20.902a9.778 9.778 0 11-9.778 9.778 9.778 9.778 0 019.778-9.778m0-2.222a12 12 0 1012 12 12.014 12.014 0 00-12-12z" fill="#3f3f3f"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(522.577 328.796)">
        Azure Media Player<tspan x="13.512" y="14.4">in Mobile App</tspan>
    </text>
    <path d="M591.068 305.574a3 3 0 01-3 3h-28.444a3 3 0 01-3-3v-44a3 3 0 013-3h28.445a3 3 0 013 3z" fill="#3f3f3f"/>
    <path fill="#5bb4da" d="M558.848 263.574h30v35.222h-30z"/>
    <path d="M576.735 303.684a2.889 2.889 0 11-2.889-2.889 2.889 2.889 0 012.89 2.889" fill="#fff"/>
    <path d="M575.741 303.684a1.894 1.894 0 11-1.9-1.894 1.9 1.9 0 011.9 1.894" fill="#b8d433"/>
    <path d="M558.846 298.796v-35.222h22.767l2.031-5h-24.02a3 3 0 00-3 3v44a3 3 0 003 3h3.695l3.974-9.778z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path d="M578.957 261.391a.737.737 0 01-.738.738h-8.744a.739.739 0 110-1.477h8.744a.738.738 0 01.738.739" fill="#1e1e1e"/>
    <path d="M578.957 261.391a.737.737 0 01-.738.738h-8.744a.739.739 0 110-1.477h8.744a.738.738 0 01.738.739" fill="#fff"/>
    <circle cx="574.148" cy="281.304" fill="#5bb4da" r="11.52"/>
    <path d="M566.002 289.449a11.52 11.52 0 0116.292-16.292z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path fill="#fff" d="M571.464 286.237l.018-9.867 7.864 4.939-7.882 4.928z"/>
    <path d="M574.146 271.526a9.778 9.778 0 11-9.778 9.778 9.778 9.778 0 019.778-9.778m0-2.222a12 12 0 1012 12 12.014 12.014 0 00-12-12z" fill="#3f3f3f"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(676.625 183.66)">
        Cloud DRM<tspan x="-.606" y="14.4">License/</tspan><tspan letter-spacing="-.013em" x="42.601" y="14.4">K</tspan><tspan x="49.403" y="14.4">ey</tspan><tspan x="-8.965" y="28.8">Delivery Server</tspan>
    </text>
    <path d="M729.464 146.146a22.453 22.453 0 00-8.8-17.8v.7a13.743 13.743 0 01-1.5 6.1 16.294 16.294 0 11-28.4 10.9 16.426 16.426 0 014.7-11.5 13.161 13.161 0 01-1.3-5.6 5.7 5.7 0 01.1-1.3 22.44 22.44 0 1035.2 18.5z" fill="#7fbb42"/>
    <path d="M707.364 118.546a10.31 10.31 0 00-2.9 20.2v10.2h-4.8v5.2h4.8v3.8h5.7v-19.3a10.23 10.23 0 007.4-9.9 10.115 10.115 0 00-10.2-10.2zm0 5.4a4.9 4.9 0 11-4.9 4.9 4.908 4.908 0 014.9-4.9z" fill="#fbd118"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(453.719 197.559)">
        Azure CDN
    </text>
    <path d="M496.699 155.182h-39.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h39.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3zM488.599 180.232h-36.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h36.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3zM484.246 168.082h-36.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h36.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3z" fill="#7c7b7b"/>
    <path d="M519.346 173.782a6.371 6.371 0 00-6.3-6.45h-.9a20.411 20.411 0 00.6-4.5 16.869 16.869 0 00-16.8-16.8 17.071 17.071 0 00-15.9 11.4 15.081 15.081 0 00-3.75-.6 11.7 11.7 0 000 23.4h37.05a6.626 6.626 0 006-6.45" fill="#3999c7"/>
    <path d="M482.299 180.082a10.682 10.682 0 01-3.15-5.7 11.275 11.275 0 0112.45-13.95 16.334 16.334 0 019.45-13.5 19.139 19.139 0 00-5.1-.9 17.071 17.071 0 00-15.9 11.4 15.081 15.081 0 00-3.75-.6 11.7 11.7 0 000 23.4l6-.15z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(1.461 197.149)">
        Mezzanine<tspan x="-.144" y="14.4">Video Files</tspan>
    </text>
    <path fill="#5bb4da" d="M52.246 149.046l-3.9-3.9-1.7-1.6h-28.8v38h36v-30.8l-1.6-1.7z"/>
    <path fill="#fff" opacity=".8" style="isolation:isolate" d="M45.846 145.546h-26v34h32v-28h-6v-6z"/>
    <path d="M24.846 170.646a.9.9 0 01.9-.9h12.4a.9.9 0 010 1.8h-12.4a.9.9 0 01-.9-.9M24.846 164.446a.9.9 0 01.9-.9h20.5a.9.9 0 110 1.8h-20.5a.9.9 0 01-.9-.9M24.846 158.646a.9.9 0 01.9-.9h20.5a.9.9 0 110 1.8h-20.5a.9.9 0 01-.9-.9M7.846 131.546h29v6h-29z" fill="#5bb4da"/>
    <path fill="#5bb4da" d="M5.846 131.546h6v40h-6z"/>
    <path fill="#fff" opacity=".8" style="isolation:isolate" d="M9.846 133.546h-2v36h4v-32h23v-4h-25z"/>
    <path fill="#5bb4da" d="M13.846 137.546h29v6h-29z"/>
    <path fill="#5bb4da" d="M11.846 137.546h6v38h-6z"/>
    <path fill="#fff" opacity=".8" style="isolation:isolate" d="M15.846 139.546h-2v34h4v-30h23v-4h-25z"/>
    <path d="M71.596 126.845v-1.1a8.186 8.186 0 00-2.2-5.7c-1.3-1.5-4.2-2.45-6.35-2.45s-5.05.95-6.35 2.45a8.417 8.417 0 00-2.2 5.7v1.1l3.95.45v-1a6.373 6.373 0 011.2-3.8 5.33 5.33 0 013.4-1.3 5.07 5.07 0 013.4 1.3 4.776 4.776 0 011.2 3.2v1.6z" fill="#3f3f3f"/>
    <path d="M54.496 126.845a2.372 2.372 0 00-2.65 2.65v10.45a2.44 2.44 0 002.3 2.65h17.8c1.7 0 2.3-1.35 2.3-2.65v-10.45a2.363 2.363 0 00-2.65-2.65h-17.1z" fill="#5bb4da"/>
    <path fill="#fff" d="M61.232 130.596l5.5 3.658-5.5 3.657v-7.315z"/>
    <path d="M67.596 126.845h-13.1a2.372 2.372 0 00-2.65 2.65v10.45a2.44 2.44 0 002.3 2.65h3.35z" fill="#fff" opacity=".15" style="isolation:isolate"/>
</svg>

## Components
* [Blob Storage](https://azure.microsoft.com/services/storage/blobs/): Stores large amounts of unstructured data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. You can use Blob storage to expose data publicly to the world, or to store application data privately.
* [Azure Encoder](https://azure.microsoft.com/services/media-services/encoding/): Encoding jobs are one of the most common processing operations in Media Services. You create encoding jobs to convert media files from one encoding to another.
* [Azure streaming endpoint](https://azure.microsoft.com/services/media-services/live-on-demand/): A streaming service that can deliver content directly to a client player application, or to a content delivery network (CDN) for further distribution.
* [Content Delivery Network](https://azure.microsoft.com/services/cdn/): Provides secure, reliable content delivery with broad global reach and a rich feature set.
* [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player/): Uses industry standards, such as HTML5 (MSE/EME), to provide a rich adaptive streaming experience. Regardless of the playback technology used, developers have a unified JavaScript interface to access APIs.
* [Multi-DRM content protection](https://azure.microsoft.com/services/media-services/content-protection/): Delivers content securely using multi-DRM (PlayReady, Widevine, FairPlay Streaming) or AES clear key encryption

## Next Steps
* [How to use Azure Blob storage](/api/Redirect/documentation/articles/storage-dotnet-how-to-use-blobs/)
* [How to encode an asset using Media Encoder](/api/Redirect/documentation/articles/media-services-dotnet-encode-with-media-encoder-standard/)
* [How to manage streaming endpoints](/azure/media-services/media-services-portal-manage-streaming-endpoints)
* [Using Azure Content Delivery Network](/api/Redirect/documentation/articles/cdn-create-new-endpoint/)
* [Develop video player applications](/api/Redirect/documentation/articles/media-services-develop-video-players/)
* [Deliver content securely](https://azure.microsoft.com/services/media-services/content-protection/)

[!INCLUDE [js_include_file](../../_js/index.md)]
