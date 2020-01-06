---
title: Scalable web and mobile applications using Azure Database for MySQL
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Rapidly build engaging, performant and scalable cross-platform and native apps for iOS, Android, Windows, or Mac.
ms.custom: acom-architecture, mysql, use cases, azure, solutions
---
# Scalable web and mobile applications using Azure Database for MySQL

<div class="alert">
    <p class="alert-title">
        <span class="icon is-left" aria-hidden="true">
            <span class="icon docon docon-lightbulb" role="presentation"></span>
        </span>Solution Idea</p>
    <p>If you'd like to see us expand this article with more information (implementation details, pricing guidance, code examples, etc), let us know with <a href="#feedback">GitHub Feedback</a>!</p>
</div>

Rapidly build engaging, performant and scalable cross-platform and native apps for iOS, Android, Windows, or Mac. 

## Architecture

<svg class="architecture-diagram" aria-labelledby="scalable-web-and-mobile-applications-using-azure-database-for-mysql" height="278.39" viewbox="0 0 612 251" width="595.565" xmlns="http://www.w3.org/2000/svg">
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(15.977 85.064)">
        B
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(24.002 85.064)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(28.685 85.064)">
        owser
    </text>
    <path d="M11.213 57.1a2.354 2.354 0 002.347 2.347h53.992A2.354 2.354 0 0069.9 57.1V20.361H11.213z" fill="#59b4d9"/>
    <path d="M67.552 9.446H13.561a2.354 2.354 0 00-2.347 2.347v8.92H69.9v-8.92a2.354 2.354 0 00-2.347-2.347" fill="#a0a1a2"/>
    <path d="M13.561 9.446a2.354 2.354 0 00-2.347 2.347V57.1a2.354 2.354 0 002.347 2.347h2.582l46.244-50z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path fill="#fff" d="M28.518 12.627h38.371v4.514H28.518z"/>
    <circle cx="19.113" cy="15.26" fill="#3999c6" r="2.633"/>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(4.339 244.366)">
        Mobile App
    </text>
    <path d="M55.684 214.872a2.47 2.47 0 01-2.521 2.241h-25.5a2.41 2.41 0 01-2.241-2.241v-50.429a2.41 2.41 0 012.241-2.241h25.5a2.47 2.47 0 012.521 2.241z" fill="#333"/>
    <path fill="#505050" d="M54.003 209.269H26.828v-39.223h27.175v39.223z"/>
    <path d="M48.68 165.844a.274.274 0 01-.268.28H32.431a.274.274 0 01-.28-.268v-.012c0-.28 0-.56.28-.56H48.4c.28 0 .28.28.28.56z"/>
    <path d="M29.91 213.189a.743.743 0 01-.84.84h-1.4a.743.743 0 01-.84-.84.9.9 0 01.84-.84h1.4a.9.9 0 01.84.84zM54 213.189a.9.9 0 01-.84.84h-1.4a.743.743 0 01-.84-.84.9.9 0 01.84-.84h1.4a1.263 1.263 0 01.84.84zM43.638 213.189a1.486 1.486 0 01-1.681 1.681h-3.082a1.615 1.615 0 01-1.681-1.546v-.135a1.808 1.808 0 011.681-1.681h3.077a1.615 1.615 0 011.681 1.546v.135z" fill="#737373"/>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(177.077 85.398)">
        Azu
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(200.36 85.398)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(205.043 85.398)">
        e
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.086em" style="isolation:isolate" transform="translate(216.199 85.398)">
        T
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(222.317 85.398)">
        raffic
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(189.334 102.198)">
        Manager
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(326.93 84.731)">
        Azu
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(350.213 84.731)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(354.896 84.731)">
        e App Se
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing=".04em" style="isolation:isolate" transform="translate(410.137 84.731)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(415.565 84.731)">
        vices
    </text>
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M167.601 38.976H86.336"/>
    <path fill="#969696" d="M166.069 33.74l9.067 5.236-9.067 5.235V33.74z"/>
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M383.744 110.066v87.91H86.336"/>
    <path fill="#969696" d="M378.508 111.598l5.236-9.067 5.235 9.067h-10.471z"/>
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M329.601 38.976h-81.265"/>
    <path fill="#969696" d="M328.069 33.74l9.067 5.236-9.067 5.235V33.74z"/>
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M504.601 38.976h-73.73"/>
    <path fill="#969696" d="M503.069 33.74l9.067 5.236-9.067 5.235V33.74zM432.403 33.74l-9.067 5.236 9.067 5.235V33.74z"/>
    <path fill="#804998" d="M239.42 44.396V25.575l-13.169-13.129h-18.635L194.42 25.972v18.357l13.169 13.117h18.662l13.169-13.05z"/>
    <path d="M225.5 14.246h-17.141L196.22 26.69v16.888l12.116 12.067h17.169l12.115-12.006V26.325zm-1.021 38.916h-.137l-10.152-10.3 2.144-2.4h-7.359v7.544l2.409-2.594 7.981 7.747h-10L198.7 42.547V27.7l2.99-3.065 7.946 7.16-4.526 4.7h14.453V22.133l-4.725 4.711-8-7.491 2.561-2.625h15.071l10.659 10.626v13.271l-5.06-4.768 3.706-3.335h-10.237V42.2l3.348-3.322 5.731 6.223z" fill="#fff" opacity=".8" style="isolation:isolate"/>
    <path fill="#fff" opacity=".2" style="isolation:isolate" d="M233.027 19.201l-6.776-6.755h-18.635L194.42 25.972V44.33l6.753 6.725 31.854-31.854z"/>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(509.843 85.731)">
        Azu
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(533.126 85.731)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(537.809 85.731)">
        e Data
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(577.772 85.731)">
        b
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(585.818 85.731)">
        ase
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(527.333 102.531)">
        for MySQL
    </text>
    <path d="M538.649 10.169v40.993c0 4.315 9.537 7.724 21.236 7.724V10.169z" fill="#005f87"/>
    <path d="M559.657 58.881H560c11.811 0 21.2-3.5 21.2-7.815V10.043l-21.535.127z" fill="#0f80b0"/>
    <path d="M581.232 10.169c0 4.2-9.537 7.724-21.236 7.724s-21.347-3.525-21.347-7.724 9.537-7.724 21.236-7.724 21.347 3.545 21.347 7.724" fill="#fff"/>
    <path d="M576.917 9.714c0 2.841-7.6 5.11-16.921 5.11s-17.032-2.249-17.032-5.11 7.6-5.11 16.921-5.11 17.032 2.269 17.032 5.11" fill="#7fb900"/>
    <path d="M576.633 39.443a4.281 4.281 0 01-4.016 4.531h-9.152v-3.541h8.1c.506-.041.927-1.469.927-1.469l-.927.456H566.5c-2.026 0-3.545-1.19-3.545-3.039V30.81l-1.519-.506v9.623h-4.052v-7.354l-2.32 5.13c-.587 1.362-1.2 2.223-2.745 2.223a3.626 3.626 0 01-3.414-2.223l-2.158-5.374v7.6H542.7V28.66c0-1.307.253-2.107 1.448-2.482a5.931 5.931 0 011.722-.294 3.191 3.191 0 013.094 1.98l3.358 6.488 2.7-6.488a3.2 3.2 0 013.089-1.98 6.432 6.432 0 011.7.273 2.382 2.382 0 011.621 2.623v1.4c0 .066-.066.116 0 .116h6.078v5.065a1.519 1.519 0 001.013.506h3.545V30.3h4.558z" fill="#fff"/>
    <path d="M378.9 53.446h-17v-17h3.9a26.305 26.305 0 01-.9-3.3v-.7h-6v24h24v-14h-4zM401.9 36.446h4v17h-17v-11h-4v14h24v-24h-7.4c.5 1.5.9 2.5.4 3.8zM362.9 26.446v-16h16v9.1a9.63 9.63 0 014-1.6v-11.5h-24v24h6.8a8.177 8.177 0 012.2-3.9l-5.5-.1zM388.9 17.546v-8.1h17v17h-7.516a12.358 12.358 0 01.515 3.482v.518h10v-24h-24v10.9c.7 0 .9-.1 1.2-.1.901.1 1.801.1 2.801.3z" fill="#a0a1a2"/>
    <path d="M400.768 36.393a3.938 3.938 0 00-3.929-3.947h-.09l-.359-.421a10.476 10.476 0 00-20.155-5.661 8.321 8.321 0 00-2.347-.427 7.254 7.254 0 000 14.507h23.253a4.056 4.056 0 003.627-4.053" fill="#59b4d9"/>
    <path d="M378.1 40.446a6.8 6.8 0 013.3-11.4 5.525 5.525 0 012.2-.1 9.919 9.919 0 015.5-8 9.427 9.427 0 00-3-.5 9.787 9.787 0 00-9.3 6.8 7.8 7.8 0 00-2.2-.4 6.8 6.8 0 000 13.6h3.5z" fill="#fff" opacity=".2" style="isolation:isolate"/>
</svg>

[!INCLUDE [js_include_file](../../_js/index.md)]
