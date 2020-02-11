---
title: Personalized marketing solutions
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Find essential technology to market your products with personalized offers. Individualize your marketing for greater customer response using big-data insights.
ms.custom: acom-architecture, personalized marketing, ai-ml, marketing personalization, targeted marketing, 'https://azure.microsoft.com/solutions/architecture/personalized-marketing/'
---
# Personalized marketing solutions

[!INCLUDE [header_file](../header.md)]

Personalized marketing is essential for building customer loyalty and remaining profitable. Reaching customers and getting them to engage is harder than ever, and generic offers are easily missed or ignored. Current marketing systems fail to take advantage of data that can help solve this problem.

Marketers using intelligent systems and analyzing massive amounts of data can deliver highly relevant and personalized offers to each user, cutting through the clutter and driving engagement. For example, retailers can provide offers and content based on each customer’s unique interests and preferences, putting products in front of the people most likely to buy them.

By personalizing your offers, you’ll deliver an individualized experience for every current or prospective customer, boosting engagement and improving customer conversion, lifetime value, and retention.

## Architecture

<svg class="architecture-diagram" aria-labelledby="personalized-marketing" height="632.636" viewbox="0 0 1079.374 632.636"  xmlns="http://www.w3.org/2000/svg">
    <path d="M0 314.01a3.55 3.55 0 003.609 3.49H86.44a3.55 3.55 0 003.61-3.489V259.52H0z" fill="#59b4d9"/>
    <path d="M86.44 243.4H3.62A3.55 3.55 0 000 246.84v18.48h90.06v-18.47a3.55 3.55 0 00-3.62-3.45" fill="#a0a1a2"/>
    <path d="M3.63 243.4A3.55 3.55 0 000 246.85v67.17a3.55 3.55 0 003.609 3.49H7.57l71-74.15z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    <path fill="#fff" d="M23.16 251.66h60.65v6.86H23.16z"/>
    <path d="M20.37 254.98a8.64 8.64 0 01-8.79 8.48 8.5 8.5 0 11-.57-17h.57a8.64 8.64 0 018.79 8.48" fill="#59b4d9"/>
    <path fill="#fff" d="M10.66 255.93l3.98 4.06h-2.16l-5.33-4.9 5.31-4.9h2.16l-3.96 4.04h9.71v1.7h-9.71z"/>
    <path d="M654.32 401.85l-25.15-42.05v-17h.45a5.263 5.263 0 10.37-10.52h-27.8a5.265 5.265 0 10-.48 10.52h.93v17l-25.14 42.05c-2.76 4.61-.5 8.39 5 8.39h66.79c5.53 0 7.79-3.78 5.03-8.39z" fill="#59b4d9"/>
    <path fill="#b8d432" d="M598.21 383.75l-10.38 17.35h56.16l-10.38-17.35h-35.4z"/>
    <path d="M614 388.91a5 5 0 005.07-4.9 4.73 4.73 0 00-.52-2.14h-9.12a4.72 4.72 0 00-.52 2.14 5 5 0 005.09 4.9z" fill="#7fba00"/>
    <ellipse cx="623.54" cy="394.57" fill="#7fba00" rx="2.49" ry="2.4"/>
    <path d="M577.5 401.85l25.15-42.05v-17h-.45a5.263 5.263 0 11-.37-10.52H614v27.41l-13.25 50.58h-18.24c-5.51-.03-7.77-3.81-5.01-8.42z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    <path d="M577.63 179.32V234c0 5.76 13.18 10.3 29.33 10.3v-65z" fill="#3999c6"/>
    <path d="M606.65 244.3h.47c16.32 0 29.33-4.54 29.33-10.3v-54.68h-29.8z" fill="#59b4d9"/>
    <path d="M636.46 179.32c0 5.6-13.18 10.3-29.33 10.3s-29.49-4.7-29.49-10.3 13.18-10.3 29.33-10.3 29.49 4.7 29.49 10.3" fill="#fff"/>
    <path d="M630.5 178.72c0 3.79-10.51 6.82-23.37 6.82s-23.53-3-23.53-6.82 10.51-6.82 23.37-6.82 23.53 3 23.53 6.82" fill="#7fba00"/>
    <path d="M625.48 182.8c3.14-1.21 4.86-2.57 4.86-4.09 0-3.79-10.51-6.82-23.37-6.82s-23.37 3-23.37 6.82c0 1.51 1.88 3 4.86 4.09 4.23-1.67 11-2.57 18.51-2.57s14.28 1.06 18.51 2.57" fill="#b8d432"/>
    <path d="M615 200.98v36.51c0 3.79 8.78 6.82 19.61 6.82v-43.33z" fill="#0072c6"/>
    <path d="M634.26 244.3h.31c10.82 0 19.61-3 19.61-6.82v-36.5h-19.92z" fill="#0072c6"/>
    <path d="M634.26 244.3h.31c10.82 0 19.61-3 19.61-6.82v-36.5h-19.92z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path d="M654.19 200.98c0 3.79-8.78 6.82-19.61 6.82s-19.61-3-19.61-6.82 8.78-6.82 19.61-6.82 19.61 3 19.61 6.82" fill="#fff"/>
    <path d="M650.11 200.53c0 2.42-7.06 4.54-15.53 4.54s-15.53-2-15.53-4.54c0-2.42 7.06-4.54 15.53-4.54s15.53 2.12 15.53 4.54" fill="#7fba00"/>
    <path d="M646.82 203.25c2-.76 3.29-1.67 3.29-2.73 0-2.42-7.06-4.54-15.53-4.54-8.63 0-15.53 2-15.53 4.54 0 1.06 1.26 2 3.29 2.73a42.09 42.09 0 0124.47 0" fill="#b8d432"/>
    <path fill="#fff" d="M645.24 223.09l-21.8 17.42 8.47-13.48h-7.37l21.8-17.27-8.47 13.33h7.37z"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 295.88 608.13)">
        Cosmos DB
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 281.81 627.87)">
        (Azu
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 311.95 627.87)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 317.08 627.87)">
        e Se
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing=".04em" style="isolation:isolate" transform="matrix(1.04 0 0 1 345.47 627.87)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 351.42 627.87)">
        vices)
    </text>
    <g style="isolation:isolate" fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81">
        <text style="isolation:isolate" transform="matrix(1.04 0 0 1 944.75 608.13)">
            Dashb
        </text>
        <text letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 987.682 608.13)">
            o
        </text>
        <text style="isolation:isolate" transform="matrix(1.04 0 0 1 996.5 608.13)">
            a
        </text>
        <text letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 1004.332 608.13)">
            r
        </text>
        <text style="isolation:isolate" transform="matrix(1.04 0 0 1 1009.479 608.13)">
            d
        </text>
    </g>
    <g style="isolation:isolate" fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81">
        <text style="isolation:isolate" transform="matrix(1.04 0 0 1 18.01 338.48)">
            B
        </text>
        <text letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 26.84 338.48)">
            r
        </text>
        <text style="isolation:isolate" transform="matrix(1.04 0 0 1 31.988 338.48)">
            owser
        </text>
    </g>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 883.5 109.91)">
        Azu
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 909.01 109.91)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 914.14 109.91)">
        e
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.029em" style="isolation:isolate" transform="matrix(1.04 0 0 1 926.36 109.91)">
        S
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 934.02 109.91)">
        t
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 939.21 109.91)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 944.34 109.91)">
        eam Anal
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 1007.67 109.91)">
        y
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 1015.14 109.91)">
        tics (Near
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.029em" style="isolation:isolate" transform="matrix(1.04 0 0 1 904.46 129.65)">
        R
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 913.21 129.65)">
        eal-Time Agg
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 1004.03 129.65)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 1009.16 129.65)">
        ega
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 1034.01 129.65)">
        t
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 1039.09 129.65)">
        es)
    </text>
    <path d="M626 37.77a1.34 1.34 0 01-1.277 1.4H613.31a1.34 1.34 0 01-1.45-1.4v-8.1a1.34 1.34 0 011.277-1.4H624.6a1.34 1.34 0 011.45 1.4zM646.29 46.16a1.34 1.34 0 01-1.277 1.4H633.56a1.34 1.34 0 01-1.45-1.4v-8.1a1.34 1.34 0 011.277-1.4h11.453a1.34 1.34 0 011.45 1.4zM626 54.54a1.34 1.34 0 01-1.277 1.4H613.31a1.34 1.34 0 01-1.45-1.4V46.4a1.34 1.34 0 011.277-1.4H624.6a1.34 1.34 0 011.4 1.277v.123zM605.78 29.4a1.34 1.34 0 01-1.277 1.4H592.75a1.34 1.34 0 01-1.45-1.4v-8.39a1.34 1.34 0 011.277-1.4H604c1.16 0 1.74.56 1.74 1.4z" fill="#b8d432"/>
    <path d="M656.42.05h-81a1.34 1.34 0 00-1.42 1.4v16.76a1.34 1.34 0 001.277 1.4h8.853a1.34 1.34 0 001.45-1.4v-7h60.72v7c0 .84.58 1.4 1.74 1.4h8.39a1.34 1.34 0 001.45-1.4V1.4A1.34 1.34 0 00656.6 0h-.173zM656.42 64.6H648a1.34 1.34 0 00-1.45 1.4v6.7h-61.03v-7c0-.84-.58-1.4-1.74-1.4h-8.38c-.87 0-1.45.56-1.45 1.68v16.5a1.34 1.34 0 001.277 1.4h81.193a1.34 1.34 0 001.45-1.4V66a1.34 1.34 0 00-1.277-1.4h-.173z" fill="#0072c6"/>
    <path d="M605.78 46.16a1.34 1.34 0 01-1.277 1.4H592.75a1.34 1.34 0 01-1.45-1.4v-8.39a1.34 1.34 0 011.277-1.4H604c1.16 0 1.74.56 1.74 1.4zM605.78 62.92a1.34 1.34 0 01-1.277 1.4H592.75a1.34 1.34 0 01-1.45-1.4v-8.38a1.34 1.34 0 011.277-1.4H604c1.16 0 1.74.56 1.74 1.4z" fill="#b8d432"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 574.24 109.91)">
        Input E
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 621.85 109.91)">
        v
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 629.11 109.91)">
        ents
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 581.03 129.65)">
        E
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 588.78 129.65)">
        v
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 596.04 129.65)">
        ent Hub
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 582.36 268.55)">
        Cold
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.029em" style="isolation:isolate" transform="matrix(1.04 0 0 1 617.79 268.55)">
        S
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 625.45 268.55)">
        ta
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing=".029em" style="isolation:isolate" transform="matrix(1.04 0 0 1 638.45 268.55)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 644.23 268.55)">
        t
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 563.25 288.3)">
        P
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 571.84 288.3)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 576.97 288.3)">
        oduct Affinity
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 555.2 432.39)">
        Maching Lea
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 641.22 432.39)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 646.52 432.39)">
        ning
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 558.64 452.13)">
        (P
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 571.85 452.13)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 576.98 452.13)">
        oduct Affinity)
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 923.85 432.39)">
        Raw
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.029em" style="isolation:isolate" transform="matrix(1.04 0 0 1 956.11 432.39)">
        S
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 963.771 432.39)">
        t
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 968.96 432.39)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 974.09 432.39)">
        eam Data
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing="-.04em" style="isolation:isolate" transform="matrix(1.04 0 0 1 273.03 347.82)">
        P
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 281.05 347.82)">
        e
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" letter-spacing=".01em" style="isolation:isolate" transform="matrix(1.04 0 0 1 289.07 347.82)">
        r
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 294.51 347.82)">
        sonalized Offer
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="14.81" style="isolation:isolate" transform="matrix(1.04 0 0 1 317.04 367.56)">
        Logic
    </text>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M132.8 285.26h85.24"/>
    <path fill="#afafaf" d="M134.26 290.27l-8.67-5.01 8.67-5.01v10.02zM216.58 290.27l8.67-5.01-8.67-5.01v10.02z"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M334.25 194.38V47.55M525.61 47.72H334.77"/>
    <path fill="#afafaf" d="M524.14 42.71l8.68 5.01-8.68 5.01V42.71z"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M890.38 47.6H682.69"/>
    <path fill="#afafaf" d="M888.92 42.59l8.67 5.01-8.67 5.01V42.59z"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M904.58 573.35l-493.8-.12"/>
    <path fill="#afafaf" d="M903.11 568.34l8.68 5.01-8.68 5v-10.01z"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M612.03 485.56v52.78M417.98 538.94h194.05"/>
    <path fill="#afafaf" d="M419.45 543.95l-8.67-5.01 8.67-5.01v10.02z"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M981.7 155.39v151.68"/>
    <path fill="#afafaf" d="M976.69 305.6l5.01 8.68 5.01-8.68h-10.02z"/>
    <path d="M382.06 281.16a2.69 2.69 0 000-3.43l-4.61-4.61-20.53-19.93a2.33 2.33 0 00-3.27 0 2.26 2.26 0 000 3.43l21.57 21.13a2.52 2.52 0 010 3.43l-22 21.87a2.52 2.52 0 000 3.43 2.49 2.49 0 003.27 0l20.38-20.23.15-.15zM288 281.16a2.69 2.69 0 010-3.43l4.61-4.61 20.53-19.94a2.33 2.33 0 013.27 0 2.26 2.26 0 010 3.43l-21.13 21.13a2.52 2.52 0 000 3.43l21.57 21.87a2.52 2.52 0 010 3.43 2.49 2.49 0 01-3.27 0l-20.83-19.95-.15-.15z" fill="#3999c6"/>
    <path fill="#fcd116" d="M358.25 236.67h-29.01l-15.62 44.04 19.04.14-14.87 43.6 41.06-58.18h-19.94l19.34-29.6z"/>
    <path fill="#ff8c00" opacity=".3" style="isolation:isolate" d="M338.91 266.27l19.34-29.6h-15.17l-16.07 36.6 19.04.15-28.26 51.03 41.06-58.18h-19.94z"/>
    <path fill="none" d="M938.88 328.73h85.64v85.64h-85.64z"/>
    <path d="M989.46 344.79l-2.46-4.28a5.52 5.52 0 00-4.55-2.68h-38.22a5.37 5.37 0 00-5.35 5.35v2.94h51.39c-.27-.52-.55-.79-.81-1.33z" fill="#3596c5"/>
    <path d="M1021.31 348.81h-82.43v51.12a5.37 5.37 0 005.35 5.35h74.94a5.37 5.37 0 005.35-5.35v-46.3a5.29 5.29 0 00-3.21-4.82zm-28.64 25.42l-15.26 21.68c0 .27-.27.27-.53.27h-.27c-.27-.27-.53-.54-.27-.8l4-12.85h-8.83a.93.93 0 01-.53-.27v-.8l14.72-21.41c0-.27.27-.27.53-.27h.27c.27.27.53.54.27.8L983 373.17h9.1a.86.86 0 01.8.8.26.26 0 00-.27.25v.01h.04z" fill="#5bafd5"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M488.39 252.72v124.19M526.15 252.72h-37.76"/>
    <path fill="#afafaf" d="M524.68 247.72l8.67 5-8.67 5.01v-10.01z"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M526.15 377.44h-37.76"/>
    <path fill="#afafaf" d="M524.68 372.43l8.67 5.01-8.67 5.01v-10.02z"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".94" d="M488.39 314.28h-67.98M335.04 495.2v-98.78"/>
    <path fill="#afafaf" d="M340.05 397.89l-5.01-8.67-5 8.67h10.01z"/>
    <path d="M1018.07 582.25h-1.93v-3.85h1.93a7.44 7.44 0 007.43-7.43v-39.43a7.44 7.44 0 00-7.43-7.43h-73.13a7.44 7.44 0 00-7.43 7.43v39.43a7.44 7.44 0 007.43 7.43h1.93v3.86h-1.93a11.3 11.3 0 01-11.29-11.29v-39.43a11.3 11.3 0 0111.29-11.29h73.12a11.3 11.3 0 0111.29 11.29v39.43a11.3 11.3 0 01-11.29 11.29"/>
    <path d="M956.8 569.33a5.24 5.24 0 015.24 5.24v12.08a5.24 5.24 0 01-5.24 5.24 5.24 5.24 0 01-5.24-5.23v-12.09a5.24 5.24 0 015.24-5.24zM973.27 591.88a5.24 5.24 0 01-5.24-5.24v-31a5.24 5.24 0 0110.48 0v31a5.24 5.24 0 01-5.24 5.24M1006.22 591.73a5.24 5.24 0 01-5.24-5.24v-43.9a5.24 5.24 0 0110.48-.02v43.92a5.24 5.24 0 01-5.24 5.24M989.74 591.88a5.24 5.24 0 01-5.24-5.24v-23a5.24 5.24 0 1110.48-.02v23.02a5.24 5.24 0 01-5.24 5.24"/>
    <path d="M362.76 546.08a28 28 0 11-33.82-20.68h.06a27.9 27.9 0 0133.729 20.474v.006z" fill="#59b4d9"/>
    <path d="M331.56 563.87a7.44 7.44 0 00-7.41-7.47H323a7.4 7.4 0 00-7.26-9.13H308a27.72 27.72 0 006.74 24h9.38a7.44 7.44 0 007.46-7.42v-.01zM340.8 533.08a5 5 0 00.2 1.32h-3.22a7.73 7.73 0 100 15.46h25.61a27.41 27.41 0 00-14.49-21.76h-3.05a5 5 0 00-5.05 4.95zM363.36 555.58h-15.28a6.31 6.31 0 00-6.33 6.29 6.25 6.25 0 00.76 3 6.29 6.29 0 001.91 12.3h4.26a27.92 27.92 0 0014.68-21.59z" fill="#fff" opacity=".5" style="isolation:isolate"/>
    <path d="M304.15 534.01a.86.86 0 01-.86-.85 9.79 9.79 0 00-9.8-9.77.86.86 0 110-1.71 9.79 9.79 0 009.8-9.75.86.86 0 011.72 0 9.79 9.79 0 009.8 9.77.86.86 0 110 1.71 9.79 9.79 0 00-9.8 9.76.86.86 0 01-.86.84z" fill="#b8d432"/>
    <path d="M364.6 589.06a.51.51 0 01-.51-.51 5.86 5.86 0 00-5.87-5.83.51.51 0 110-1 5.86 5.86 0 005.86-5.84.51.51 0 011 0 5.86 5.86 0 005.9 5.82h.02a.51.51 0 110 1 5.86 5.86 0 00-5.86 5.84.51.51 0 01-.51.51z" fill="#0072c6"/>
    <path d="M376.34 527.45c-2.67-4.38-9.39-5.39-19.42-2.94a79.909 79.909 0 00-9.21 2.94 28.249 28.249 0 015.43 3.47c1.71-.56 3.38-1.07 5-1.46a35 35 0 018.17-1.16c3.29 0 5.1.81 5.7 1.8 1 1.62.08 5.91-5.75 12.64-1 1.2-2.2 2.41-3.43 3.63a127.13 127.13 0 01-45.18 27.64c-10.15 3.31-17.08 3.24-18.63.7s1.55-8.74 9.13-16.28a27.731 27.731 0 01-.62-6.52c-12.06 10.9-16 20.34-12.85 25.45 1.63 2.67 5.2 4.17 10.41 4.17a53 53 0 0018-4 138.29 138.29 0 0040.42-24.84 79 79 0 006.59-6.66c6.76-7.76 8.9-14.21 6.24-18.58z"/>
    <path d="M1014.29 63.67l2.79-7.22 12.8-4.42V41.79l-1.4-.47-11.41-3.26-2.79-7.22 5.82-11.87-7.22-7.22-1.4.7-10.48 5.36-7.45-3-4.63-12.41h-10.47L978 3.85l-3.49 10.94-7.22 2.79-12.34-5.35-7.46 7.17.7 1.4 3.26 6.05a36.64 36.64 0 0118.39-4.66 37.55 37.55 0 0124 9.78 53.878 53.878 0 014.42 3.72 17.768 17.768 0 011.86 2.56 18.15 18.15 0 01-4.66 23.28 17.83 17.83 0 01-18.46 2.6c-.7-.47-1.16-.47-1.4-.7a24.168 24.168 0 01-4-2.79c-.47 0-.7-.47-1.4-.47a5.74 5.74 0 00-4 1.86l-.47.47A35 35 0 01951 71.82l-2.09 4.42 7 7 .47.47 1.4-.7 10.47-5.35 7.17 2.74 4 12.34h10.47l.47-1.4L994 80.4l7.22-2.79 12.34 5.35 7-7.68-.7-1.4z" fill="#7a7a7a"/>
    <path d="M951.91 45.51c-7.91 8.38-20.72 8.38-28.17-.47a2 2 0 00-3.26 0 2.64 2.64 0 00-.7 1.86 4.44 4.44 0 00.7 1.86c9.31 10.47 24.91 10.71 34.92.47 7.91-7.91 20.25-8.15 27.93.7 1.16 1.16 2.56 1.16 3.26 0a2.64 2.64 0 00.7-1.86 4.44 4.44 0 00-.7-1.86 23.42 23.42 0 00-33.043-2.272q-.856.746-1.637 1.572z" fill="#48c8ef"/>
    <path d="M969.37 49.93a14.78 14.78 0 00-11.17 4.66l-.47.47-.47.47A26.24 26.24 0 01937 63.9c-7.68 0-14.43-3.72-20-9.31-1.16-1.16-2.56-1.16-3.26 0-.23 0-.23.47-.23 1.16a3.13 3.13 0 001.16 2.09 30.77 30.77 0 0023.28 10.94c8.61.47 17-3.26 23.51-10.24l.47-.47.47-.47a10.55 10.55 0 017.67-3.2c2.79 0 5.35 1.4 7.68 3.72 1.16 1.16 2.56 1.16 3.26 0a2.64 2.64 0 00.7-1.86 4.441 4.441 0 00-.71-1.86 18.93 18.93 0 00-11.63-4.47z" fill="#00abec"/>
    <path d="M949.82 40.4a27.3 27.3 0 0120.25-8.61c7.45 0 14.43 3.72 19.55 9.31 1.16 1.16 2.56 1.16 3.26 0a2.64 2.64 0 00.7-1.86 4.44 4.44 0 00-.7-1.86A30.77 30.77 0 00969.6 26.4a31.26 31.26 0 00-23.51 10.24l-.47.47-.47.47a10.55 10.55 0 01-7.68 3.26c-3 0-5.35-1.4-7.68-3.72-1.16-1.16-2.56-1.16-3.26 0a2.64 2.64 0 00-.7 1.86 4.44 4.44 0 00.7 1.86 15 15 0 0021.17 1.372q.49-.43.941-.9l.47-.47z" fill="#84d6ef"/>
    <g opacity=".2" fill="#f1f1f1">
        <path d="M971.46 60.4c-.47 0-.7-.47-1.4-.47a5.74 5.74 0 00-4 1.86l-.47.47a35 35 0 01-14.9 9.31l-2.09 4.42 3.72 3.72zM951.68 27.12a36.64 36.64 0 0118.39-4.66 37.55 37.55 0 0124 9.78c1.16.93 2.09 1.63 3.26 2.56l19.32-19.32-4-4-1.4.7-10.47 5.35-7.22-2.79-4.64-12.34h-10.47L978 3.85l-3.49 10.94-7.22 2.79-12.34-5.35-7.46 7.17.7 1.4z"/>
    </g>
</svg>

## Components
* [Event Hubs](https://azure.microsoft.com/services/event-hubs/) ingests raw click-stream data from Functions and passes it on to Stream Analytics.
* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/): Stream Analytics aggregates clicks in near real-time by product, offer, and user to write to Azure Cosmos DB and also archives raw click-stream data to Azure Storage.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) stores aggregated data of clicks by user, product, and offer as well as user-profile information.
* [Storage Accounts](https://azure.microsoft.com/services/storage/): Azure Storage stores archived raw click-stream data from Stream Analytics.
* [Azure Functions](https://azure.microsoft.com/services/functions/) takes in user clickstream data from website and reads existing user history from Azure Cosmos DB. These data are then run through the Machine Learning web service or used along with the cold-start data in Azure Cache for Redis to obtain product-affinity scores. Product-affinity scores are used with the personalized-offer logic to determine the most relevant offer to present to the user.
* [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio/): Machine Learning helps you easily design, test, operationalize, and manage predictive analytics solutions in the cloud.
* [Azure Cache for Redis](https://azure.microsoft.com/services/cache/) stores pre-computed cold-start product affinity scores for users without history.
* [Power BI](https://powerbi.microsoft.com/) Visualizes user activity data as well as offers presented by reading in data from Cosmos DB.

## Next Steps
* [Learn more about Event Hubs](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [Learn how to use Azure Cosmos DB](/azure/cosmos-db)
* [Learn more about Azure Storage](/azure/storage/storage-introduction)
* [Learn how to create functions](/azure/azure-functions)
* [Learn more about machine learning](/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn how to use Azure Cache for Redis](/azure/redis-cache/cache-dotnet-how-to-use-azure-redis-cache)
* [Learn about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)

[!INCLUDE [js_include_file](../../_js/index.md)]
