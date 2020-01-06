---
title: Defect prevention with predictive maintenance
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Learn how to use Azure Machine Learning to predict failures before they happen with real-time assembly line data.
ms.custom: acom-architecture, manufacturing control, quality control process, anomaly-detection, manufacturing quality control, 'https://azure.microsoft.com/solutions/architecture/defect-prevention-with-predictive-maintenance/'
---
# Defect prevention with predictive maintenance

[!INCLUDE [header_file](../header.md)]

Learn how to use Azure Machine Learning to predict failures before they happen with real-time assembly line data.

This solution is built on the Azure managed services: [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/), [Event Hubs](https://azure.microsoft.com/services/event-hubs/), [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio/), [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

<svg class="architecture-diagram" aria-labelledby="defect-prevention-with-predictive-maintenance" height="639.059" viewbox="0 0 1065.788 639.059"  xmlns="http://www.w3.org/2000/svg">
    <path d="M731.8 67.4l-24.5-40.7V10.2h.4c2.9 0 5.2-2.2 5.3-5.1-.1-2.9-2.4-5.1-5.3-5.1l-26.6.1c-2.9 0-5.2 2.2-5.3 5.1.1 2.9 2.4 5.1 5.3 5.1h.4v16.5l-24.3 40.8c-2.7 4.5-.5 8.1 4.9 8.1l64.8-.1c5.4-.1 7.6-3.8 4.9-8.2z" fill="#59B4D9"/>
    <path fill="#B8D432" d="M677.3 49.9l-10 16.9 54.5-.1-10.1-16.8z"/>
    <path d="M692.7 54.9c2.7 0 4.9-2.1 4.9-4.8 0-.7-.2-1.4-.5-2.1h-8.8c-.3.6-.5 1.4-.5 2.1 0 2.7 2.2 4.9 4.9 4.8z" fill="#7FBA00"/>
    <ellipse cx="701.9" cy="60.4" fill="#7FBA00" rx="2.4" ry="2.3" transform="translate(-.124 1.458)"/>
    <path d="M657.3 67.5l24.3-40.8V10.2h-.4c-2.9.1-5.2-2.2-5.3-5.1 0-2.9 2.4-5.1 5.3-5.1h11.5l.1 26.5-12.8 49h-17.7c-5.5.1-7.7-3.5-5-8z" fill="#FFF" opacity=".25"/>
    <path d="M735.9 293.9l2.7-6.8L751 283v-9.6l-1.4-.4-11.1-3.1-2.7-6.8 5.7-11.1-7-6.8-1.4.7-10.2 5-7.2-2.8-4.5-11.6H701l-.5 1.3-3.4 10.3-7 2.6-12-5-7.2 6.8.7 1.3 3.2 5.7c5.5-3 11.6-4.5 17.9-4.4 8.6.3 16.8 3.5 23.3 9.2 1.5 1.1 2.9 2.3 4.3 3.5.7.7 1.3 1.5 1.8 2.4 4.3 7.2 2.5 16.4-4.5 21.8-5.1 4-11.9 4.9-17.9 2.4-.7-.4-1.1-.4-1.4-.7-1.4-.7-2.7-1.6-3.8-2.6-.5 0-.7-.4-1.4-.4-1.5.1-2.8.7-3.8 1.7l-.5.4c-4 4.1-9 7.1-14.5 8.7l-2 4.1 6.8 6.5.5.4 1.4-.7 10.2-5 7 2.6L702 321h10.2l.5-1.3 3.6-10.3 7-2.6 12 5 6.8-7.2-.7-1.3-5.5-9.4z" fill="#7A7A7A"/>
    <path d="M675.3 276.8c-7.7 7.9-20.1 7.9-27.3-.4-.6-.9-1.8-1.1-2.7-.5-.2.1-.3.3-.5.5-.5.5-.7 1.1-.7 1.7.1.6.3 1.2.7 1.7 9 9.8 24.2 10 33.9.4 7.7-7.4 19.7-7.6 27.1.7 1.1 1.1 2.5 1.1 3.2 0 .5-.5.7-1.1.7-1.7-.1-.6-.3-1.2-.7-1.7-8.7-9.5-23.4-10.1-32.9-1.4-.3.2-.5.5-.8.7z" fill="#48C8EF"/>
    <path d="M692.3 281c-4.1-.1-8 1.5-10.8 4.4l-.5.4-.5.4c-5.1 5.3-12.3 8.2-19.7 7.9-7.5 0-14-3.5-19.4-8.7-1.1-1.1-2.5-1.1-3.2 0-.2 0-.2.4-.2 1.1.1.8.5 1.5 1.1 2 5.7 6.5 13.9 10.2 22.6 10.3 8.4.4 16.5-3.1 22.8-9.6l.5-.4.5-.4c2-2 4.7-3.1 7.5-3.1 2.7 0 5.2 1.3 7.5 3.5 1.1 1.1 2.5 1.1 3.2 0 .5-.5.7-1.1.7-1.7-.1-.6-.3-1.2-.7-1.7-3.3-2.8-7.3-4.3-11.4-4.4z" fill="#00ABEC"/>
    <path d="M673.3 272c5.2-5.3 12.3-8.2 19.7-8.1 7.2 0 14 3.5 19 8.7 1.1 1.1 2.5 1.1 3.2 0 .5-.5.7-1.1.7-1.7-.1-.6-.3-1.2-.7-1.7-5.7-6.5-13.9-10.2-22.6-10.3-8.6-.1-16.9 3.4-22.8 9.6l-.5.4-.5.4c-2 2-4.7 3.1-7.5 3.1-2.9 0-5.2-1.3-7.5-3.5-1.1-1.1-2.5-1.1-3.2 0-.5.5-.7 1.1-.7 1.7.1.6.3 1.2.7 1.7 5.6 6 15 6.4 21 .9.2-.1.3-.3.5-.4l.5-.4.7-.4z" fill="#84D6EF"/>
    <g opacity=".2" fill="#F1F1F1">
        <path d="M694.3 290.8c-.5 0-.7-.4-1.4-.4-1.5.1-2.8.7-3.8 1.7l-.5.4c-4 4.1-9 7.1-14.5 8.7l-2 4.1 3.6 3.5 18.6-18zM675.1 259.6c5.5-3 11.6-4.5 17.9-4.4 8.6.3 16.8 3.5 23.3 9.2 1.1.9 2 1.5 3.2 2.4l18.8-18.1-3.8-3.7-1.4.7-10.2 5-7-2.6-4.5-11.6h-10.2l-.5 1.3-3.4 10.3-7 2.6-12-5-7.2 6.8.7 1.3 3.3 5.8z"/>
    </g>
    <path d="M397.2 274.8c0 .7-.5 1.3-1.2 1.3h-11c-.7.1-1.3-.5-1.4-1.2V267c0-.7.5-1.3 1.2-1.3h11c.7-.1 1.3.5 1.4 1.2v7.9zM416.6 282.8c0 .7-.5 1.3-1.2 1.3h-11c-.7.1-1.3-.5-1.4-1.2v-8c0-.7.5-1.3 1.2-1.3h11c.7-.1 1.3.5 1.4 1.2v8zM397.2 290.8c0 .7-.5 1.3-1.2 1.3h-11c-.7.1-1.3-.5-1.4-1.2v-8c0-.7.5-1.3 1.2-1.3h11c.7-.1 1.3.5 1.4 1.2v8zM377.8 266.8c0 .7-.5 1.3-1.2 1.3H365.3c-.7.1-1.3-.5-1.4-1.2v-8.2c0-.7.5-1.3 1.2-1.3h11c1.1 0 1.7.5 1.7 1.3v8.1z" fill="#B8D432"/>
    <path d="M426.3 238.7h-77.6c-.7-.1-1.3.5-1.4 1.2v16.2c0 .7.5 1.3 1.2 1.3h8.5c.7.1 1.3-.5 1.4-1.2v-6.9h58.2v6.7c0 .8.6 1.3 1.7 1.3h8c.7.1 1.3-.5 1.4-1.2v-16.2c0-.7-.5-1.3-1.2-1.3-.1.1-.1.1-.2.1zM426.3 300.5h-8c-.7-.1-1.3.5-1.4 1.2V308.3h-58.5v-6.7c0-.8-.6-1.3-1.7-1.3h-8c-.8 0-1.4.5-1.4 1.6v15.8c0 .7.5 1.3 1.2 1.3h77.8c.7.1 1.3-.5 1.4-1.2v-16c0-.7-.5-1.3-1.2-1.3h-.2z" fill="#0072C6"/>
    <path d="M377.8 282.8c0 .7-.5 1.3-1.2 1.3H365.3c-.7.1-1.3-.5-1.4-1.2v-8.2c0-.7.5-1.3 1.2-1.3h11c1.1 0 1.7.5 1.7 1.3v8.1zM377.8 298.9c0 .7-.5 1.3-1.2 1.3H365.3c-.7.1-1.3-.5-1.4-1.2v-8.2c0-.7.5-1.3 1.2-1.3h11c1.1 0 1.7.5 1.7 1.3v8.1z" fill="#B8D432"/>
    <text fill="#505050" font-family="SegoeUI" font-size="15.372" transform="matrix(1.036 0 0 1 649.018 605.822)">
        Azure SQL DW
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="15.372" transform="matrix(1.036 0 0 1 632.033 101.647)">
        Machine Learning
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="15.372" transform="matrix(1.036 0 0 1 615.75 122.448)">
        (Real time predictions)
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="14.173" transform="matrix(1.036 0 0 1 958.093 343.504)">
        Power BI
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="15.372" transform="matrix(1.036 0 0 1 8.81 344.524)">
        ALS test measurements
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="15.372" transform="matrix(1.036 0 0 1 51.147 362.97)">
        (Telemetry)
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="15.372" transform="matrix(1.036 0 0 1 349.615 355.796)">
        Event Hub
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="15.372" transform="matrix(1.036 0 0 1 640.611 344.524)">
        Stream Analytics
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="15.372" transform="matrix(1.036 0 0 1 624.76 365.325)">
        (Real time analytics)
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="12.298" transform="matrix(1.036 0 0 1 799.277 532.521)">
        Dashboard of predictions/alerts
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="12.298" transform="matrix(1.036 0 0 1 791.438 254.802)">
        Realtime data stats,
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="12.298" transform="matrix(1.036 0 0 1 772.998 267.1)">
        Anomaliesand aggregates
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="12.298" transform="matrix(1.036 0 0 1 701.444 425.943)">
        Realtime event
    </text>
    <text fill="#505050" font-family="SegoeUI" font-size="12.298" transform="matrix(1.036 0 0 1 699.501 438.241)">
        and predictions
    </text>
    <path fill="none" stroke="#AFAFAF" stroke-miterlimit="10" stroke-width=".962" d="M694.5 155.9v53.5"/>
    <path fill="#AFAFAF" d="M689.7 157.3l4.8-8.3 4.8 8.3zM689.7 208l4.8 8.3 4.8-8.3z"/>
    <path fill="none" stroke="#AFAFAF" stroke-miterlimit="10" stroke-width=".962" d="M577 278.8h-86.4"/>
    <path fill="#AFAFAF" d="M575.6 274l8.3 4.8-8.3 4.8z"/>
    <path fill="none" stroke="#AFAFAF" stroke-miterlimit="10" stroke-width=".962" d="M694.5 468.7v-78.2"/>
    <path fill="#AFAFAF" d="M699.3 467.3l-4.8 8.3-4.8-8.3z"/>
    <path fill="none" stroke="#AFAFAF" stroke-miterlimit="10" stroke-width=".962" d="M985.6 380v170.4"/>
    <path fill="#AFAFAF" d="M980.8 381.4l4.8-8.3 4.8 8.3z"/>
    <path fill="none" stroke="#AFAFAF" stroke-miterlimit="10" stroke-width=".962" d="M909.8 278.8H774.2"/>
    <path fill="#AFAFAF" d="M908.4 274l8.3 4.8-8.3 4.8z"/>
    <path fill="none" stroke="#AFAFAF" stroke-miterlimit="10" stroke-width=".962" d="M277.6 278.8h-86.4"/>
    <path fill="#AFAFAF" d="M276.2 274l8.3 4.8-8.3 4.8z"/>
    <path d="M692.9 591.6h.5" fill="#0072C6"/>
    <path d="M692.9 591.6h.5" fill="#FFF" opacity=".15"/>
    <path d="M85.6 300.7c0 1.9-1.5 3.4-3.4 3.4H49.5c-1.9 0-3.4-1.5-3.4-3.4v-60.5c0-1.9 1.5-3.4 3.4-3.4h32.6c1.9 0 3.4 1.5 3.4 3.4v60.5h.1z" fill="#A0A1A2"/>
    <path d="M52 273.1c0-2.4 1.9-4.4 4.3-4.4H76c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H56.2c-2.4-.1-4.2-2-4.2-4.4z" fill="#1E1E1E" opacity=".6"/>
    <circle cx="56.4" cy="273.1" fill="#B8D432" r="2.9"/>
    <path d="M52 260.3c0-2.4 1.9-4.4 4.3-4.4H76c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H56.2c-2.4-.1-4.2-2-4.2-4.4z" fill="#1E1E1E" opacity=".6"/>
    <circle cx="56.4" cy="260.3" fill="#B8D432" r="2.9"/>
    <path d="M52 247.7c-.1-2.3 1.7-4.3 4-4.4h19.9c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H56.2c-2.3-.1-4.2-2-4.2-4.4z" fill="#1E1E1E" opacity=".6"/>
    <circle cx="56.4" cy="247.7" fill="#B8D432" r="2.9"/>
    <path d="M130.1 300.7c0 1.9-1.5 3.4-3.4 3.4H94c-1.9 0-3.4-1.5-3.4-3.4v-60.5c0-1.9 1.5-3.4 3.4-3.4h32.8c1.9 0 3.4 1.5 3.4 3.4l-.1 60.5z" fill="#A0A1A2"/>
    <path d="M96.5 273.1c0-2.4 1.9-4.4 4.3-4.4h19.8c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H100.8c-2.4-.1-4.3-2-4.3-4.4z" fill="#1E1E1E" opacity=".6"/>
    <circle cx="100.9" cy="273.1" fill="#B8D432" r="2.9"/>
    <path d="M96.5 260.3c0-2.4 1.9-4.4 4.3-4.4h19.8c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H100.8c-2.4-.1-4.3-2-4.3-4.4z" fill="#1E1E1E" opacity=".6"/>
    <circle cx="100.9" cy="260.3" fill="#B8D432" r="2.9"/>
    <path d="M96.5 247.7c0-2.4 1.9-4.4 4.3-4.4h19.8c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H100.8c-2.4-.1-4.2-2-4.3-4.4z" fill="#1E1E1E" opacity=".6"/>
    <circle cx="100.9" cy="247.7" fill="#B8D432" r="2.9"/>
    <path d="M109.3 317.5c0 1.9-1.5 3.4-3.4 3.4H73.3c-1.9 0-3.4-1.5-3.4-3.4V257c0-1.9 1.5-3.4 3.4-3.4h32.6c1.9 0 3.4 1.5 3.4 3.4v60.5z" fill="#3E3E3E"/>
    <path d="M75.7 289.9c0-2.4 1.9-4.4 4.3-4.4h19.8c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H80.1c-2.4 0-4.4-1.9-4.4-4.4z" fill="#1E1E1E"/>
    <circle cx="80.2" cy="289.9" fill="#B8D432" r="2.9"/>
    <path d="M75.7 277.1c0-2.4 1.9-4.4 4.3-4.4h19.8c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H80.1c-2.4 0-4.4-1.9-4.4-4.4 0 .1 0 0 0 0z" fill="#1E1E1E"/>
    <circle cx="80.2" cy="277.1" fill="#B8D432" r="2.9"/>
    <path d="M75.7 264.5c0-2.4 1.9-4.4 4.3-4.4h19.8c2.4 0 4.4 1.9 4.4 4.3v.1c0 2.4-1.9 4.4-4.3 4.4H80.1c-2.4-.1-4.4-2-4.4-4.4z" fill="#1E1E1E"/>
    <circle cx="80.2" cy="264.5" fill="#B8D432" r="2.9"/>
    <path fill="none" stroke="#AFAFAF" stroke-miterlimit="10" stroke-width=".962" d="M789.6 549.9h196.3"/>
    <path d="M1020 314h-1.9v-3.9h1.9c4.1 0 7.4-3.3 7.4-7.4v-39.4c0-4.1-3.3-7.4-7.4-7.4h-73.1c-4.1 0-7.4 3.3-7.4 7.4v39.4c0 4.1 3.3 7.4 7.4 7.4h1.9v3.9h-1.9c-6.2 0-11.3-5.1-11.3-11.3v-39.4c0-6.2 5.1-11.3 11.3-11.3h73.1c6.2 0 11.3 5.1 11.3 11.3v39.4c0 6.2-5 11.3-11.3 11.3"/>
    <path d="M958.8 301c2.9 0 5.2 2.3 5.2 5.2v12.1c0 2.9-2.3 5.2-5.2 5.2-2.9 0-5.2-2.3-5.2-5.2v-12.1c-.1-2.8 2.3-5.2 5.2-5.2zM975.3 323.6c-2.9 0-5.2-2.3-5.2-5.2v-31c0-2.9 2.3-5.2 5.2-5.2 2.9 0 5.2 2.3 5.2 5.2v31c0 2.8-2.4 5.2-5.2 5.2M1008.2 323.4c-2.9 0-5.2-2.3-5.2-5.2v-43.9c0-2.9 2.3-5.2 5.2-5.2 2.9 0 5.2 2.3 5.2 5.2v43.9c0 2.9-2.3 5.2-5.2 5.2M991.7 323.6c-2.9 0-5.2-2.3-5.2-5.2v-23c0-2.9 2.3-5.2 5.2-5.2 2.9 0 5.2 2.3 5.2 5.2v23c.1 2.8-2.3 5.2-5.2 5.2"/>
    <path fill="#7FBB42" d="M676.5 524.8h8.3v8.3h-8.3zM669.9 547.4h8.3v8.3h-8.3zM681.8 547.4h8.3v8.3h-8.3zM693.5 547.4h8.3v8.3h-8.3zM669.9 536.1h8.3v8.3h-8.3zM681.8 536.1h8.3v8.3h-8.3z"/>
    <path fill="#3999C6" d="M688.4 498.2l-32.9 17.5v5.1h6.7V556h5.6v-35.2h40.9v33h6.2v-33h6.1v-5.1z"/>
    <path fill="#B8D433" opacity=".8" d="M684.9 533.1h-1v-7.3h-7.4v-1h8.4z"/>
    <path fill="#B8D433" opacity=".5" d="M676.5 524.8h1v7.3h7.4v1h-8.4z"/>
    <path fill="#B8D433" opacity=".8" d="M678.2 544.4h-.9v-7.2h-7.4v-1.1h8.3z"/>
    <path fill="#B8D433" opacity=".5" d="M669.9 536.1h.9v7.3h7.4v1h-8.3z"/>
    <path fill="#B8D433" opacity=".8" d="M690.2 544.4h-1v-7.2h-7.4v-1.1h8.4z"/>
    <path fill="#B8D433" opacity=".5" d="M681.8 536.1h1v7.3h7.4v1h-8.4z"/>
    <path fill="#B8D433" opacity=".8" d="M678.2 555.7h-.9v-7.2h-7.4v-1.1h8.3z"/>
    <path fill="#B8D433" opacity=".5" d="M669.9 547.4h.9v7.3h7.4v1h-8.3z"/>
    <path fill="#B8D433" opacity=".8" d="M690.2 555.7h-1v-7.2h-7.4v-1.1h8.4z"/>
    <path fill="#B8D433" opacity=".5" d="M681.8 547.4h1v7.3h7.4v1h-8.4z"/>
    <path fill="#B8D433" opacity=".8" d="M701.9 555.7h-1v-7.2h-7.4v-1.1h8.4z"/>
    <path fill="#B8D433" opacity=".5" d="M693.5 547.4h1v7.3h7.4v1h-8.4z"/>
    <path fill="#B8D433" opacity=".8" d="M677.7 533.1h-1.2v-.9l7.2-7.4h1.2v.8zM683 544.4h-1.2v-.9l7.3-7.4h1.1v.8zM671.1 544.4h-1.2v-.9l7.2-7.4h1.1v.8zM671.1 555.7h-1.2v-.9l7.2-7.4h1.1v.8zM683 555.7h-1.2v-.9l7.3-7.4h1.1v.8zM694.8 555.7h-1.3v-.9l7.2-7.4h1.2v.8z"/>
    <path d="M705 539.8v36.3c0 3.7 8.5 6.8 18.9 6.8v-43.1H705z" fill="#3999C6"/>
    <path d="M723.5 583h.3c10.4 0 18.9-3.1 18.9-6.8v-36.3h-19.1V583h-.1z" fill="#5AB4D9"/>
    <path d="M742.7 539.8c0 3.7-8.5 6.8-18.9 6.8s-18.9-3.1-18.9-6.8c0-3.8 8.5-6.8 18.9-6.8s18.9 3 18.9 6.8" fill="#FFF"/>
    <path d="M738.8 539.4c0 2.5-6.7 4.5-15 4.5s-15-2-15-4.5 6.7-4.5 15-4.5c8.3-.1 15 2 15 4.5" fill="#7FBB42"/>
    <path d="M735.7 542.1c2-.8 3.1-1.7 3.1-2.7 0-2.5-6.7-4.5-15-4.5s-15 2-15 4.5c0 1.1 1.2 2 3.1 2.7 2.7-1.1 7.1-1.7 11.9-1.7 4.8-.1 9.1.7 11.9 1.7" fill="#B8D433"/>
    <path d="M709.6 565.8v-2.6c.4.4 1 .7 1.5.9.6.2 1.1.3 1.6.3.3 0 .6 0 .8-.1.2 0 .4-.1.6-.2s.3-.2.3-.4.1-.3.1-.4c0-.2 0-.4-.2-.6-.1-.2-.3-.3-.5-.5s-.5-.3-.8-.4c-.3-.1-.6-.3-1-.4-.9-.4-1.6-.8-2-1.3-.4-.6-.7-1.2-.7-2 0-.6.1-1.1.3-1.5.2-.4.6-.8 1-1.1.4-.3.9-.5 1.4-.6.6-.1 1.1-.2 1.7-.2.6 0 1.1 0 1.6.1.4 0 .9.2 1.3.3v2.4l-.6-.3c-.2-.1-.4-.2-.7-.2-.2 0-.5-.1-.7-.2h-1.5c-.2 0-.4.1-.6.2-.2.1-.3.2-.4.3-.1.2-.1.3-.1.4 0 .2 0 .3.2.5.1.2.2.3.4.4.2.1.4.3.7.4.3.1.6.3.9.4.4.2.9.4 1.2.6.4.2.7.4 1 .7.3.3.4.6.6 1 .1.3.2.7.2 1.2 0 .6-.1 1.2-.3 1.6-.2.4-.6.8-1 1.1-.4.3-.9.4-1.4.6-.6.1-1.1.2-1.7.2-.6 0-1.2 0-1.8-.2-.5 0-1-.2-1.4-.4zM724.1 566.5c-1.6 0-3-.6-4-1.6-1-1.1-1.6-2.5-1.6-4.2 0-1.8.5-3.2 1.6-4.4 1.1-1.1 2.4-1.7 4.1-1.7 1.6 0 3 .6 4 1.6s1.5 2.5 1.5 4.3c0 1.8-.5 3.2-1.6 4.4l-.1.1-.1.1 2.9 2.8h-3.6l-1.5-1.6c-.4.1-.9.2-1.6.2zm.2-9.6c-.9 0-1.6.3-2.2 1-.6.7-.8 1.6-.8 2.7s.3 2 .8 2.7c.6.7 1.2 1 2.1 1 .9 0 1.6-.3 2.1-1s.8-1.6.8-2.7c0-1.2-.3-2.1-.8-2.8-.5-.6-1.2-.9-2-.9zM738.5 566.3h-6.8v-11.5h2.6v9.3h4.3v2.2h-.1z" fill="#FFF"/>
</svg>

## Components
* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/): Stream Analytics provides near real-time analytics on the input stream from the Azure Event Hub. Input data is filtered and passed to a Machine Learning endpoint, finally sending the results to the Power BI dashboard.
* [Event Hubs](https://azure.microsoft.com/services/event-hubs/) ingests raw assembly-line data and passes it on to Stream Analytics.
* [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio/): Machine Learning predicts potential failures based on real-time assembly-line data from Stream Analytics.
* [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/): Synapse Analytics stores assembly-line data along with failure predictions.
* [Power BI](https://powerbi.microsoft.com) visualizes real-time assembly-line data from Stream Analytics and the predicted failures and alerts from Data Warehouse.

## Next Steps
* [Learn more about Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Event Hubs](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Machine Learning](/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn more about Synapse Analytics](/azure/sql-data-warehouse/sql-data-warehouse-overview-what-is)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)

[!INCLUDE [js_include_file](../../_js/index.md)]
