---
title: Finance management apps using Azure Database for MySQL
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Securely store critical data and provide high-value analytics and insights over aggregated data to users, using in-built security and performance.
ms.custom: acom-architecture, mysql, analytics, use cases, azure, solutions, 'https://azure.microsoft.com/solutions/architecture/finance-management-apps-using-azure-database-for-mysql/'
---
# Finance management apps using Azure Database for MySQL

[!INCLUDE [header_file](../header.md)]

Securely store critical data and provide high-value analytics and insights over aggregated data to users, using in-built security and performance. 

## Architecture

<svg class="architecture-diagram" aria-labelledby="finance-management-apps-using-azure-database-for-mysql" height="388.214" viewbox="0 0 621 388.214"  xmlns="http://www.w3.org/2000/svg">
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M386.349 107.679V30.162H79.169"/>
    <path fill="#969696" d="M391.585 106.147l-5.236 9.067-5.235-9.067h10.471z"/>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(3.851 76.428)">
        Mobile App
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(149.406 366.413)">
        Financial data f
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(242.259 366.413)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(246.941 366.413)">
        om
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(159.841 383.213)">
        multiple sou
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(236.192 383.213)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(240.874 383.213)">
        ces
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(151.611 212.696)">
        Azu
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(174.894 212.696)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(179.577 212.696)">
        e App Se
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing=".04em" style="isolation:isolate" transform="translate(234.818 212.696)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(240.246 212.696)">
        vices
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(14.262 212.696)">
        B
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(22.287 212.696)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(26.97 212.696)">
        owser
    </text>
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M160.007 163.441H78.741"/>
    <path fill="#969696" d="M158.474 158.205l9.068 5.236-9.068 5.235v-10.471z"/>
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M333.007 163.441h-81.266"/>
    <path fill="#969696" d="M331.474 158.205l9.068 5.236-9.068 5.235v-10.471z"/>
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M500.007 163.441h-81.266"/>
    <path fill="#969696" d="M498.474 158.205l9.068 5.236-9.068 5.235v-10.471z"/>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.037em" style="isolation:isolate" transform="translate(528.214 212.696)">
        P
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(535.535 212.696)">
        o
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.005em" style="isolation:isolate" transform="translate(543.737 212.696)">
        w
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(553.786 212.696)">
        er BI
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(494.549 229.496)">
        (Financial Anal
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing=".003em" style="isolation:isolate" transform="translate(583.642 229.496)">
        y
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(590.458 229.496)">
        tics)
    </text>
    <path d="M575.466 177.3h-1.09v-2.18h1.09a4.2 4.2 0 004.2-4.195v-22.267a4.2 4.2 0 00-4.2-4.2h-41.3a4.2 4.2 0 00-4.2 4.2v22.269a4.2 4.2 0 004.2 4.195h1.09v2.18h-1.09a6.382 6.382 0 01-6.374-6.375v-22.269a6.382 6.382 0 016.375-6.375h41.3a6.382 6.382 0 016.375 6.375v22.269a6.382 6.382 0 01-6.375 6.375"/>
    <path d="M540.861 170a2.958 2.958 0 012.958 2.958v6.821a2.958 2.958 0 01-2.958 2.958 2.958 2.958 0 01-2.959-2.957v-6.82a2.958 2.958 0 012.958-2.96zM550.165 182.74a2.959 2.959 0 01-2.959-2.958v-17.51a2.959 2.959 0 115.917-.109V179.781a2.959 2.959 0 01-2.958 2.959M568.772 182.653a2.959 2.959 0 01-2.959-2.958V154.9a2.959 2.959 0 015.917-.109V179.7a2.959 2.959 0 01-2.958 2.959M559.469 182.74a2.959 2.959 0 01-2.957-2.959v-13.007a2.959 2.959 0 115.917-.109v13.116a2.959 2.959 0 01-2.958 2.959"/>
    <path d="M53.691 52.585a2.224 2.224 0 01-2.27 2.018H28.464a2.17 2.17 0 01-2.018-2.018V7.178a2.17 2.17 0 012.018-2.018H51.42a2.224 2.224 0 012.27 2.018z" fill="#333"/>
    <path fill="#505050" d="M52.177 47.54H27.708V12.223h24.469V47.54z"/>
    <path d="M47.384 8.439a.247.247 0 01-.242.252H32.753a.247.247 0 01-.252-.242v-.01c0-.252 0-.5.252-.5h14.375c.252 0 .252.252.252.5z"/>
    <path d="M30.483 51.072a.669.669 0 01-.757.757h-1.261a.669.669 0 01-.757-.757.805.805 0 01.757-.757h1.263a.805.805 0 01.757.757zM52.177 51.072a.805.805 0 01-.757.757h-1.261a.669.669 0 01-.757-.757.805.805 0 01.757-.757h1.261a1.137 1.137 0 01.757.757zM42.844 51.072a1.338 1.338 0 01-1.514 1.514h-2.775a1.454 1.454 0 01-1.514-1.391v-.123a1.628 1.628 0 011.514-1.514h2.773a1.454 1.454 0 011.514 1.391v.123z" fill="#737373"/>
    <path d="M10.467 184.064a2.354 2.354 0 002.345 2.347H66.8a2.354 2.354 0 002.347-2.347v-36.738h-58.68z" fill="#59b4d9"/>
    <path d="M66.8 136.411H12.812a2.354 2.354 0 00-2.347 2.347v8.92h58.687v-8.92a2.354 2.354 0 00-2.347-2.347" fill="#a0a1a2"/>
    <path d="M12.812 136.411a2.354 2.354 0 00-2.347 2.347v45.306a2.354 2.354 0 002.347 2.347h2.582l46.246-50z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path fill="#fff" d="M27.771 139.592h38.371v4.514H27.771z"/>
    <circle cx="18.367" cy="142.225" fill="#3999c6" r="2.633"/>
    <path d="M205.517 184.631h-17.928v-17.82h3.672a9.512 9.512 0 01-.649-3.564v-.216h-6.8v25.38H209.3v-15.12h-3.78zM230.789 166.811h3.24v17.928H216.1V173.4h-3.78v15.012h25.491v-25.38h-7.991a7.609 7.609 0 01.972 3.564zM187.589 156.011v-17.82h17.928v10.368a10.021 10.021 0 013.78-1.728v-12.42h-25.485v25.38h7.344a10.249 10.249 0 012.376-3.672l-5.94-.108zM216.1 146.4v-8.208h17.928v17.928h-7.884a13.1 13.1 0 01.54 3.672v.108h11.127v-25.489h-25.49v11.772c.324 0 .54-.108.864-.108a26.751 26.751 0 012.915.325z" fill="#a0a1a2"/>
    <path d="M227.873 166.487a3.987 3.987 0 00-3.974-4h-.566a11.739 11.739 0 00.432-2.808 10.628 10.628 0 00-20.736-3.348 8.425 8.425 0 00-2.376-.432 7.345 7.345 0 000 14.688H224.2a4.107 4.107 0 003.672-4.1" fill="#59b4d9"/>
    <path d="M204.545 170.591a7.341 7.341 0 013.567-12.312 5.967 5.967 0 012.376-.108 10.713 10.713 0 015.94-8.64 10.181 10.181 0 00-3.24-.54 10.57 10.57 0 00-10.044 7.344 8.425 8.425 0 00-2.376-.432 7.345 7.345 0 000 14.688h3.777z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(335.244 212.696)">
        Azu
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(358.527 212.696)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(363.21 212.696)">
        e Data
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(403.173 212.696)">
        b
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(411.219 212.696)">
        ase
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(352.734 229.496)">
        for MySQL
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(320.181 246.296)">
        (Financial Data
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.032em" style="isolation:isolate" transform="translate(414.449 246.296)">
        S
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.008em" style="isolation:isolate" transform="translate(421.435 246.296)">
        t
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(426.07 246.296)">
        o
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" letter-spacing="-.013em" style="isolation:isolate" transform="translate(434.273 246.296)">
        r
    </text>
    <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" style="isolation:isolate" transform="translate(438.955 246.296)">
        e)
    </text>
    <path d="M365.058 135.135v40.992c0 4.315 9.537 7.724 21.236 7.724v-48.716z" fill="#005f87"/>
    <path d="M386.066 183.846h.339c11.811 0 21.2-3.5 21.2-7.815v-41.02l-21.535.127z" fill="#0f80b0"/>
    <path d="M407.641 135.135c0 4.2-9.537 7.724-21.236 7.724s-21.347-3.525-21.347-7.724 9.536-7.724 21.236-7.724 21.347 3.545 21.347 7.724" fill="#fff"/>
    <path d="M403.326 134.679c0 2.841-7.6 5.11-16.921 5.11s-17.032-2.249-17.032-5.11 7.6-5.11 16.921-5.11 17.032 2.269 17.032 5.11" fill="#7fb900"/>
    <path d="M399.689 137.743c2.269-.907 3.545-1.93 3.545-3.064-.02-2.841-7.592-5.242-16.906-5.242s-16.956 2.4-16.956 5.242c0 1.134 1.362 2.269 3.545 3.064 3.044-1.246 7.962-1.722 13.411-1.722s10.3.587 13.366 1.722" fill="#b7d332"/>
    <path d="M403.042 164.411a4.281 4.281 0 01-4.016 4.531h-9.152V165.4h8.1c.506-.041.927-1.469.927-1.469l-.927.456h-5.062c-2.026 0-3.545-1.19-3.545-3.039v-5.571l-1.519-.506v9.623H383.8v-7.355l-2.32 5.13c-.587 1.362-1.2 2.223-2.745 2.223a3.626 3.626 0 01-3.414-2.223l-2.158-5.374v7.6h-4.047v-11.27c0-1.307.253-2.107 1.448-2.482a5.931 5.931 0 011.722-.294 3.191 3.191 0 013.094 1.98l3.358 6.488 2.7-6.488a3.2 3.2 0 013.089-1.98 6.432 6.432 0 011.7.273 2.382 2.382 0 011.621 2.623v1.4c0 .066-.066.116 0 .116h6.078v5.07a1.519 1.519 0 001.013.506h3.545v-5.571h4.558z" fill="#fff"/>
    <path d="M237.261 341.867h2.351v-52.456h-45.991c-1.469.147-4.555 3.82-4.555 4.261v50.693a2.79 2.79 0 002.788 2.792h41.881v-.882z" fill="#0072c6"/>
    <path d="M195.678 291.762a3.487 3.487 0 00-2.939 1.175c-2.5 2.2.588 2.2 1.763 2.2h39.232v51.134l3.526-4.555v-49.954z" fill="#e5e5e5"/>
    <path d="M195.678 320.562a2.009 2.009 0 01-1.96 2.057h-6.856a2.009 2.009 0 01-2.057-1.96v-.1a2.009 2.009 0 011.96-2.057h6.856a1.928 1.928 0 012.057 2.057zM195.678 305.427a2.009 2.009 0 01-1.96 2.057h-6.856a2.009 2.009 0 01-2.057-1.96v-.1a2.009 2.009 0 011.96-2.057h6.856a2.1 2.1 0 012.057 2.06zM195.678 335.549a2.009 2.009 0 01-1.96 2.057h-6.856a2.009 2.009 0 01-2.057-1.96v-.1a2.009 2.009 0 011.96-2.057h6.856a2.009 2.009 0 012.057 1.96v.1z" fill="#a0a1a2"/>
    <text fill="#fff" font-family="SegoeUI-Bold, Segoe UI" font-size="27.535" font-weight="700" style="isolation:isolate" transform="translate(204.682 329.874)">
        $
    </text>
    <path fill="none" stroke="#969696" stroke-miterlimit="10" stroke-width="1.5" d="M212.633 271.806v-42.73"/>
    <path fill="#969696" d="M217.868 270.274l-5.235 9.067-5.236-9.067h10.471zM217.868 230.608l-5.235-9.067-5.236 9.067h10.471z"/>
</svg>

[!INCLUDE [js_include_file](../../_js/index.md)]
