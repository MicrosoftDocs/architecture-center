---
title: Keyword search/speech-to-text/OCR digital media
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/12/2019
description: A speech-to-text solution allows you to identify speech in static video files so you can manage it as standard content, such as allowing employees to search within training videos for spoken words or phrases, and then enabling them to quickly navigate to the specific moment in the video. This solution allows you to upload static videos to an Azure website. The Azure Media Indexer uses the Speech API to index the speech within the videos and stores it in SQL Azure. You can search for words or phrases by using Azure Web Apps and retrieve a list of results. Selecting a result enables you to see where in the video the word or phrase is mentioned.
ms.custom: acom-architecture
---
# Keyword search/speech-to-text/OCR digital media

<div class="alert">
    <p class="alert-title">
        <span class="icon is-left" aria-hidden="true">
            <span class="icon docon docon-lightbulb" role="presentation"></span>
        </span>Solution Idea</p>
    <p>If you'd like to see us add more information to this article, let us know with <a href="#feedback">GitHub Feedback</a>!</p>
    <p>Based on your feedback, this solution idea could be expanded to include implementation details, pricing guidance, code examples, and deployment templates.</p>
</div>

A speech-to-text solution allows you to identify speech in static video files so you can manage it as standard content, such as allowing employees to search within training videos for spoken words or phrases, and then enabling them to quickly navigate to the specific moment in the video. This solution allows you to upload static videos to an Azure website. The Azure Media Indexer uses the Speech API to index the speech within the videos and stores it in SQL Azure. You can search for words or phrases by using Azure Web Apps and retrieve a list of results. Selecting a result enables you to see where in the video the word or phrase is mentioned.

This solution is built on the Azure managed services: [Content Delivery Network](https://azure.microsoft.com/services/cdn/) and [Azure Cognitive Search](https://azure.microsoft.com/services/search/). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

<svg class="architecture-diagram" aria-labelledby="digital-media-speech-text" height="387.693" viewbox="0 0 721.972 387.693" width="721.972" xmlns="http://www.w3.org/2000/svg">
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="10" transform="translate(249.756 287.984)">
        <tspan letter-spacing=".02em">T</tspan><tspan x="5.435" y="0">TML, </tspan><tspan letter-spacing="-.039em" x="29.268" y="0">W</tspan><tspan x="38.218" y="0">eb</tspan><tspan letter-spacing=".019em" x="49.326" y="0">VT</tspan><tspan x="61.162" y="0">T</tspan><tspan letter-spacing="-.013em" x="11.985" y="12">K</tspan><tspan x="17.654" y="12">eywords</tspan>
    </text>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M108.534 145.49H61.531"/>
    <path fill="#b5b6b6" d="M107.112 140.628l8.419 4.862-8.419 4.861v-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M150.531 264.493v-59.525"/>
    <path fill="#b5b6b6" d="M155.393 263.07l-4.862 8.42-4.861-8.42h9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M233.534 145.49h-47.003"/>
    <path fill="#b5b6b6" d="M232.112 140.628l8.419 4.862-8.419 4.861v-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M354.534 145.49h-47.003"/>
    <path fill="#b5b6b6" d="M353.112 140.628l8.419 4.862-8.419 4.861v-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M464.534 145.49h-48.003"/>
    <path fill="#b5b6b6" d="M463.112 140.628l8.419 4.862-8.419 4.861v-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M172.534 24.49h-22.003v74.919"/>
    <path fill="#b5b6b6" d="M171.112 19.628l8.419 4.862-8.419 4.861v-9.723zM145.67 97.986l4.861 8.419 4.862-8.419h-9.723z"/>
    <path d="M424.096 325.175a12.174 12.174 0 01-3.2-3.2c-.2-.3-.3-.5-.5-.8l-.8.9-.1.1a2.092 2.092 0 00.4.6 14.963 14.963 0 003.5 3.6 2.389 2.389 0 00.7.3l.9-.9c-.4-.3-.6-.4-.9-.6z" fill="#1e1e1e" opacity=".5" style="isolation:isolate"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M655.627 203.901v82.158H469.009"/>
    <path fill="#b5b6b6" d="M650.765 205.324l4.862-8.419 4.861 8.419h-9.723z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M672.048 205.246V329.26h-195.41"/>
    <path fill="#b5b6b6" d="M667.186 206.669l4.862-8.419 4.862 8.419h-9.724zM478.06 324.398l-8.419 4.862 8.419 4.862v-9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M382.492 307.784H191.573"/>
    <path fill="#b5b6b6" d="M381.07 302.922l8.419 4.862-8.419 4.862v-9.724z"/>
    <path fill="none" stroke="#b5b6b6" stroke-miterlimit="10" stroke-width="1.5" d="M611.534 145.49h-45.003"/>
    <path fill="#b5b6b6" d="M610.112 140.628l8.419 4.862-8.419 4.861v-9.723z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(121.175 183.959)">
        Azure Blob<tspan letter-spacing="-.032em" x="8.429" y="14.4">S</tspan><tspan x="14.417" y="14.4">torage</tspan>
    </text>
    <path d="M124.956 162.856a1.88 1.88 0 001.8 1.9h46.3a1.9 1.9 0 001.9-1.9v-33.1h-50z" fill="#9fa0a2"/>
    <path d="M173.056 122.056h-46.3a1.88 1.88 0 00-1.8 1.9v5.7h50v-5.7a1.9 1.9 0 00-1.9-1.9" fill="#7c7b7b"/>
    <path fill="#2272b9" d="M128.656 133.156h20.4v13h-20.4zM128.656 147.956h20.4v13h-20.4z"/>
    <path fill="#fff" d="M150.856 133.156h20.3v13h-20.3z"/>
    <path fill="#2272b9" d="M150.856 147.956h20.3v13h-20.3z"/>
    <path d="M126.956 122.056a2.006 2.006 0 00-2 2v38.6a2.006 2.006 0 002 2h2.2l39.4-42.6z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(246.103 183.959)">
        <tspan letter-spacing="-.032em">S</tspan><tspan x="5.988" y="0">treaming</tspan><tspan x="2.965" y="14.4">Endpoint</tspan>
    </text>
    <path d="M295.957 159.136a5.52 5.52 0 01-5.52 5.52h-34.96a5.52 5.52 0 01-5.52-5.52v-34.96a5.52 5.52 0 015.52-5.52h34.96a5.52 5.52 0 015.52 5.52z" fill="#5bb4da"/>
    <path d="M262.837 164.656h-7.36a5.52 5.52 0 01-5.52-5.52v-34.96a5.52 5.52 0 015.52-5.52h31.28z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path d="M264.677 153.922V129.39l19.6 12.279z" fill="#fff"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(349.584 183.959)">
        Multi-Protocol<tspan x="15.422" y="14.4">Dynamic</tspan><tspan letter-spacing="-.034em" x="9.105" y="28.8">P</tspan><tspan x="15.416" y="28.8">ackaging/</tspan><tspan x="9.067" y="43.2">Multi-DRM</tspan>
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(549.315 379.293)">
        <tspan letter-spacing="-.039em">W</tspan><tspan x="10.74" y="0">eb Apps</tspan>
    </text>
    <path d="M401.81 140.969v-1.671a12.434 12.434 0 00-3.342-8.658c-1.975-2.278-6.379-3.721-9.645-3.721s-7.67 1.443-9.645 3.721a12.785 12.785 0 00-3.342 8.658v1.671l6 .683v-1.519a9.68 9.68 0 011.823-5.772c1.139-1.291 3.569-1.9 5.164-1.975a7.7 7.7 0 015.164 1.975 7.253 7.253 0 011.823 4.86v2.43z" fill="#3f3f3f"/>
    <path d="M375.837 140.969c-2.962 0-4.025 1.747-4.025 4.025v15.872c0 1.975 1.215 4.025 3.493 4.025h27.036c2.582 0 3.493-2.05 3.493-4.025v-15.872c0-2.05-.835-4.025-4.025-4.025h-25.972z" fill="#5bb4da"/>
    <path fill="#fff" d="M386.067 146.665l8.354 5.556-8.354 5.555v-11.111z"/>
    <path d="M395.734 140.969h-19.9c-2.962 0-4.025 1.747-4.025 4.025v15.872c0 1.975 1.215 4.025 3.493 4.025h5.094z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(492.068 184.369)">
        Azure CDN
    </text>
    <path d="M535.049 141.992h-39.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h39.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3zM526.949 167.042h-36.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h36.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3zM522.596 154.892h-36.9a3.009 3.009 0 01-3-3 3.009 3.009 0 013-3h36.9a3.009 3.009 0 013 3 3.009 3.009 0 01-3 3z" fill="#7c7b7b"/>
    <path d="M557.696 160.592a6.371 6.371 0 00-6.3-6.45h-.9a20.411 20.411 0 00.6-4.5 16.869 16.869 0 00-16.8-16.8 17.071 17.071 0 00-15.9 11.4 15.081 15.081 0 00-3.75-.6 11.7 11.7 0 000 23.4h37.05a6.626 6.626 0 006-6.45" fill="#3999c7"/>
    <path d="M520.649 166.892a10.682 10.682 0 01-3.15-5.7 11.275 11.275 0 0112.45-13.95 16.334 16.334 0 019.45-13.5 19.139 19.139 0 00-5.1-.9 17.071 17.071 0 00-15.9 11.4 15.081 15.081 0 00-3.75-.6 11.7 11.7 0 000 23.4l6-.15z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path d="M223.647 41.507h-18.9a3.521 3.521 0 010-7.042h18.9a4.544 4.544 0 004.539-4.539V11.581a4.544 4.544 0 00-4.539-4.539h-18.9a3.521 3.521 0 010-7.042h18.9a11.594 11.594 0 0111.581 11.581v18.346a11.594 11.594 0 01-11.581 11.58zM199.001 45.77h19.056v1.76h-19.056zM205.009 47.53h7.042V50h-7.042z" fill="#3f3f3f"/>
    <path fill="#3f3f3f" d="M207.649 7.042h1.76v40.489h-1.76z"/>
    <path fill="#618dc9" d="M192.686 20.364h28.166v7.922h-28.166z"/>
    <path fill="#5bb4da" d="M197.967 12.443h19.364v7.922h-19.364z"/>
    <path fill="#676767" d="M205.009 9.802h7.042v2.641h-7.042zM205.009 28.286h7.042v2.47h-7.042z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(8.53 183.959)">
        Source<tspan x="-5.004" y="14.4">A/V Files</tspan>
    </text>
    <path fill="#5bb4da" d="M49.023 135.856l-3.9-3.9-1.7-1.6h-28.8v38h36v-30.8l-1.6-1.7z"/>
    <path fill="#fff" opacity=".8" style="isolation:isolate" d="M42.623 132.356h-26v34h32v-28h-6v-6z"/>
    <path d="M21.623 157.456a.9.9 0 01.9-.9h12.4a.9.9 0 110 1.8h-12.4a.9.9 0 01-.9-.9M21.623 151.256a.9.9 0 01.9-.9h20.5a.9.9 0 010 1.8h-20.5a.9.9 0 01-.9-.9M21.623 145.456a.9.9 0 01.9-.9h20.5a.9.9 0 110 1.8h-20.5a.9.9 0 01-.9-.9M4.623 118.356h29v6h-29z" fill="#5bb4da"/>
    <path fill="#5bb4da" d="M2.623 118.356h6v40h-6z"/>
    <path fill="#fff" opacity=".8" style="isolation:isolate" d="M6.623 120.356h-2v36h4v-32h23v-4h-25z"/>
    <path fill="#5bb4da" d="M10.623 124.356h29v6h-29z"/>
    <path fill="#5bb4da" d="M8.623 124.356h6v38h-6z"/>
    <path fill="#fff" opacity=".8" style="isolation:isolate" d="M12.623 126.356h-2v34h4v-30h23v-4h-25z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(116.546 353.959)">
        Azure Media<tspan x="-2.039" y="14.4">Indexer/OCR </tspan><tspan x="-10.362" y="28.8">Media Processor</tspan>
    </text>
    <path d="M169.861 299.582a12.953 12.953 0 01-12.572 9.874 11.406 11.406 0 01-3.143-.449 13.447 13.447 0 01-4.191-1.946 13.745 13.745 0 01-3.293-3.293 13.1 13.1 0 01-1.946-10.327 12.953 12.953 0 0112.572-9.878 11.406 11.406 0 013.143.449 13.041 13.041 0 017.933 5.837 12.339 12.339 0 011.5 9.729" fill="#fff"/>
    <path d="M169.861 299.582a12.953 12.953 0 01-12.572 9.874 11.406 11.406 0 01-3.143-.449 13.447 13.447 0 01-4.191-1.946 13.745 13.745 0 01-3.293-3.293 13.1 13.1 0 01-1.946-10.327 12.953 12.953 0 0112.572-9.878 11.406 11.406 0 013.143.449 13.041 13.041 0 017.933 5.837 12.339 12.339 0 011.5 9.729" fill="#5bb4da" opacity=".1" style="isolation:isolate"/>
    <path d="M164.323 285.662a12.694 12.694 0 00-3.891-1.646 11.406 11.406 0 00-3.143-.449 12.951 12.951 0 00-12.572 9.878 12.418 12.418 0 001.946 10.327 10.461 10.461 0 001.2 1.5 33.472 33.472 0 0116.463-19.607" fill="#5bb4da" opacity=".3" style="isolation:isolate"/>
    <path d="M173.154 287.009a18.489 18.489 0 00-11.375-8.382 23.132 23.132 0 00-4.49-.6 18.565 18.565 0 00-17.961 14.069 18.111 18.111 0 001.946 13.62l-14.07 14.22a4.883 4.883 0 000 6.735 5.071 5.071 0 006.884 0l14.069-14.215a18.948 18.948 0 004.79 1.946 23.132 23.132 0 004.49.6 18.565 18.565 0 0017.959-14.073 18.88 18.88 0 00-2.242-13.92zm-3.293 12.573a12.953 12.953 0 01-12.572 9.874 11.406 11.406 0 01-3.143-.449 13.447 13.447 0 01-4.191-1.946 13.745 13.745 0 01-3.293-3.293 13.1 13.1 0 01-1.946-10.327 12.953 12.953 0 0112.572-9.878 11.406 11.406 0 013.143.449 13.041 13.041 0 017.933 5.837 12.433 12.433 0 011.497 9.733z" fill="#3f3f3f"/>
    <path d="M146.811 311.705a18.23 18.23 0 01-4.79-4.79c-.3-.449-.449-.748-.748-1.2l-1.292 1.305-.084.085a3.73 3.73 0 00.627 1 22.4 22.4 0 005.239 5.388 2.546 2.546 0 00.914.449l1.481-1.5a13.338 13.338 0 00-1.347-.737z" fill="#1e1e1e" opacity=".5" style="isolation:isolate"/>
    <path fill="#5bb4da" d="M152.954 289.065l11 7.316-11 7.315v-14.631z"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(396.155 353.959)">
        Azure Search
    </text>
    <path d="M449.196 300.275c0-.4.1-.9.1-1.3a12.869 12.869 0 00-13-12.8 12.621 12.621 0 00-10.5 5.2 9.309 9.309 0 00-5.2-1.5 9.8 9.8 0 00-9.8 9.7v.8a9.7 9.7 0 00-5.6 8.8c0 6 4.9 10.7 11.2 10.7h27.6c6.3 0 11.2-4.7 11.2-10.7a9.486 9.486 0 00-6-8.9z" fill="#5bb4da"/>
    <path d="M412.196 314.075c0-4.1 2.1-7.3 6-9.3v-.8a10.494 10.494 0 0115.9-8.8 13.828 13.828 0 0111.2-5.7 13.546 13.546 0 00-9-3.4 12.978 12.978 0 00-10.5 5.3 9.309 9.309 0 00-5.2-1.5 9.8 9.8 0 00-9.8 9.7v.8a9.7 9.7 0 00-5.6 8.8 10.6 10.6 0 008.4 10.4 11.236 11.236 0 01-1.4-5.5z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path d="M439.496 317.075a8.654 8.654 0 01-8.4 6.6 7.612 7.612 0 01-2.1-.3 8.98 8.98 0 01-2.8-1.3 9.19 9.19 0 01-2.2-2.2 8.751 8.751 0 01-1.3-6.9 8.654 8.654 0 018.4-6.6 7.613 7.613 0 012.1.3 8.713 8.713 0 015.3 3.9 8.243 8.243 0 011 6.5" fill="#fff"/>
    <path d="M439.496 317.075a8.654 8.654 0 01-8.4 6.6 7.612 7.612 0 01-2.1-.3 8.98 8.98 0 01-2.8-1.3 9.19 9.19 0 01-2.2-2.2 8.751 8.751 0 01-1.3-6.9 8.654 8.654 0 018.4-6.6 7.613 7.613 0 012.1.3 8.713 8.713 0 015.3 3.9 8.243 8.243 0 011 6.5" fill="#5bb4da" opacity=".1" style="isolation:isolate"/>
    <path d="M435.796 307.775a8.486 8.486 0 00-2.6-1.1 7.612 7.612 0 00-2.1-.3 8.654 8.654 0 00-8.4 6.6 8.3 8.3 0 001.3 6.9 7.006 7.006 0 00.8 1 22.367 22.367 0 0111-13.1" fill="#5bb4da" opacity=".3" style="isolation:isolate"/>
    <path d="M441.696 308.675a12.352 12.352 0 00-7.6-5.6 15.438 15.438 0 00-3-.4 12.4 12.4 0 00-12 9.4 12.1 12.1 0 001.3 9.1l-9.4 9.5a3.263 3.263 0 000 4.5 3.389 3.389 0 004.6 0l9.4-9.5a12.66 12.66 0 003.2 1.3 15.438 15.438 0 003 .4 12.4 12.4 0 0012-9.4 12.614 12.614 0 00-1.5-9.3zm-2.2 8.4a8.654 8.654 0 01-8.4 6.6 7.612 7.612 0 01-2.1-.3 8.98 8.98 0 01-2.8-1.3 9.19 9.19 0 01-2.2-2.2 8.751 8.751 0 01-1.3-6.9 8.654 8.654 0 018.4-6.6 7.613 7.613 0 012.1.3 8.713 8.713 0 015.3 3.9 8.306 8.306 0 011 6.5z" fill="#3f3f3f"/>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(619.878 184.406)">
        Azure Media Player
    </text>
    <text fill="#5e5e5e" font-family="SegoeUI, Segoe UI" font-size="12" transform="translate(171.088 67.293)">
        Azure Encoder<tspan x="5.584" y="14.4">(</tspan><tspan letter-spacing="-.032em" x="9.205" y="14.4">S</tspan><tspan x="15.193" y="14.4">tandard or</tspan><tspan x="12.741" y="28.8">Premium)</tspan>
    </text>
    <path d="M591.657 359.864a24.995 24.995 0 114.656-35.03 24.9 24.9 0 01-4.656 35.03" fill="#5bb4da"/>
    <path d="M587.064 344.403a5.385 5.385 0 007.541 1c.123-.094.218-.208.33-.309 2.409 1.7 4.082 2.817 5.025 3.459a21.566 21.566 0 00.67-2.142c-1-.741-2.343-1.778-4.29-3.356a5.34 5.34 0 00-7.666-6.548 222.638 222.638 0 01-8.293-7.833c9.165-4.929 15.676-4.207 15.676-4.207a25.109 25.109 0 00-3.606-3.7 26.627 26.627 0 00-16.729 3.119q-3.429-3.589-6.983-7.712a23.264 23.264 0 00-3.312 1.347 53.84 53.84 0 006.754 8.565l.017.017a46.293 46.293 0 00-6.944 6.015c-.29.309-.569.62-.842.931a7.546 7.546 0 00-4.117.282 18.265 18.265 0 01-1.724-10.832 26.353 26.353 0 00-2.692 3.267 16.016 16.016 0 00.985 10.1 7.538 7.538 0 00-.005 9.153 7.743 7.743 0 00.559.645 37.87 37.87 0 00-1.46 8.761c.237.322.237.582.472.9a25.375 25.375 0 004.16 4.008 27.556 27.556 0 011.714-11.372 7.507 7.507 0 003.483-.566c.64.563 1.31 1.132 2.025 1.711a41.672 41.672 0 007.285 4.643 4.941 4.941 0 007.951 4.437 4.918 4.918 0 001.108-1.216 44.6 44.6 0 009.806 1.019c.386 0 2.177-2.436 3.2-3.946a26.373 26.373 0 01-12.3-.84 4.913 4.913 0 00-7.516-3.113 46.853 46.853 0 01-6.758-4.49q-.707-.559-1.359-1.118a7.578 7.578 0 00.318-7.55c.286-.286.567-.573.871-.857a54.887 54.887 0 016.519-5.274c-.082-.076-.156-.156-.236-.233.081.075.157.152.239.227 3.121 2.886 6.43 5.621 9.564 8.065a5.348 5.348 0 00.56 5.543z" fill="#fff"/>
    <circle cx="661.22" cy="148.168" fill="#5bb4da" r="24"/>
    <path d="M644.249 165.139a24 24 0 1133.941-33.941z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path fill="#fff" d="M655.627 158.446l.038-20.556 16.383 10.289-16.421 10.267z"/>
    <path d="M661.22 127.798a20.37 20.37 0 11-20.37 20.37 20.37 20.37 0 0120.37-20.37m0-4.63a25 25 0 1025 25 25.028 25.028 0 00-25-25z" fill="#3f3f3f"/>
</svg>

## Components
* Stores large amounts of unstructured data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. You can use [Blob storage](https://azure.microsoft.com/services/storage/blobs/) to expose data publicly to the world, or to store application data privately.
* [Azure encoding](https://azure.microsoft.com/services/media-services/encoding/): Encoding jobs are one of the most common processing operations in Media Services. You create encoding jobs to convert media files from one encoding to another.
* [Azure streaming endpoint](https://azure.microsoft.com/services/media-services/live-on-demand/): Represents a streaming service that can deliver content directly to a client player application, or to a content delivery network (CDN) for further distribution.
* [Content Delivery Network](https://azure.microsoft.com/services/cdn/): Provides secure, reliable content delivery with broad global reach and a rich feature set.
* [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player/): Uses industry standards, such as HTML5 (MSE/EME) to provide an enriched adaptive streaming experience. Regardless of the playback technology used, developers have a unified JavaScript interface to access APIs.
* [Azure Cognitive Search](https://azure.microsoft.com/services/search/): Delegates search-as-a-service server and infrastructure management to Microsoft, leaving you with a ready-to-use service that you can populate with your data, and then use to add search to your web or mobile application.
* [Web Apps](https://azure.microsoft.com/services/app-service/web/): Hosts the website or web application.
* [Azure Media Indexer](https://azure.microsoft.com/services/media-services/media-indexer/): Enables you to make the content of your media files searchable and to generate a full-text transcript for closed-captioning and keywords. You can process one media file or multiple media files in a batch.

## Next Steps
* [How to use Azure Blob storage](/api/Redirect/documentation/articles/storage-dotnet-how-to-use-blobs/)
* [How to encode an asset using Media Encoder](/api/Redirect/documentation/articles/media-services-dotnet-encode-with-media-encoder-standard/)
* [How to manage streaming endpoints](/api/Redirect/documentation/articles/media-services-manage-origins/)
* [Using Azure Content Delivery Network](/api/Redirect/documentation/articles/cdn-create-new-endpoint/)
* [Develop video player applications](/api/Redirect/documentation/articles/media-services-develop-video-players/)
* [Create an Azure Cognitive Search service](/api/Redirect/documentation/articles/search-create-service-portal/)
* [Run Web Apps in the cloud](/api/Redirect/documentation/articles/app-service-web-overview/)
* [Indexing media files](/api/Redirect/documentation/articles/media-services-index-content/)

[!INCLUDE [js_include_file](../../_js/index.md)]
