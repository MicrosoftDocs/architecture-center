---
title: Forecast Energy and Power Demand
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/12/2019
description: Learn how Microsoft Azure can help accurately forecast spikes in demand for energy products and services to give your company a competitive advantage.
ms.custom: acom-architecture, energy demand, power forecast, energy forecast
---
# Forecast Energy and Power Demand

<div class="alert">
    <p class="alert-title">
        <span class="icon is-left" aria-hidden="true">
            <span class="icon docon docon-lightbulb" role="presentation"></span>
        </span>Solution Idea</p>
    <p>This is an example of a solution built on Azure. If you'd like to see this expanded with more detail, pricing information, code examples, or deployment templates, let us know in the <a href="#feedback">feedback</a> area.</p>
</div>

Learn how Microsoft Azure can help accurately forecast spikes in demand for energy products and services to give your company a competitive advantage.

This solution is built on the Azure managed services: [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/), [Event Hubs](https://azure.microsoft.com/services/event-hubs/), [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio/), [Azure SQL Database](https://azure.microsoft.com/services/sql-database/), [Data Factory](https://azure.microsoft.com/services/data-factory/) and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

<svg class="architecture-diagram" aria-labelledby="forecast-energy-power-demand" height="716.116" viewbox="0 0 1075.878 716.116" width="1075.878" xmlns="http://www.w3.org/2000/svg">
    <path d="M459.418 267.091l-26.568-44.143-.037-17.893h.478a5.53 5.53 0 10-.024-11.055l-28.886.06a5.531 5.531 0 10.023 11.054h.478l.037 17.891-26.384 44.253c-2.895 4.853-.511 8.815 5.3 8.8l70.325-.146c5.804-.012 8.171-3.98 5.258-8.821z" fill="#59b4d9"/>
    <path fill="#b8d432" d="M400.302 248.19l-10.888 18.26 59.12-.123-10.962-18.214-37.27.077z"/>
    <path d="M416.953 253.575a5.247 5.247 0 005.331-5.16 4.967 4.967 0 00-.549-2.251l-9.6.02a4.957 4.957 0 00-.54 2.253 5.25 5.25 0 005.358 5.138z" fill="#7fba00"/>
    <ellipse cx="426.994" cy="259.509" fill="#7fba00" rx="2.621" ry="2.526" transform="rotate(-.119 428.245 259.961)"/>
    <path d="M378.535 267.259L404.919 223l-.037-17.891h-.482a5.53 5.53 0 11-.023-11.053l12.447-.026.06 28.8-13.843 53.183-19.213.04c-5.804.021-8.188-3.941-5.293-8.794z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    <path d="M751.065 62.272l2.943-7.34 13.487-4.5V40.015l-1.471-.474-12.016-3.315-2.943-7.34 6.13-12.076-7.6-7.34-1.471.71-11.035 5.446-7.847-3.078L724.337 0H713.3l-.49 1.421-3.678 11.128-7.6 2.841-13-5.446-7.847 7.34.736 1.421 3.433 6.156a39.688 39.688 0 0119.372-4.735 40.308 40.308 0 0125.257 9.945 56.336 56.336 0 014.659 3.788 18.109 18.109 0 011.962 2.6c4.659 7.814 2.7 17.758-4.9 23.677a19.322 19.322 0 01-19.372 2.6c-.736-.474-1.226-.474-1.471-.71a25.478 25.478 0 01-4.169-2.841c-.49 0-.736-.474-1.471-.474a6.137 6.137 0 00-4.169 1.894l-.49.474a37.092 37.092 0 01-15.694 9.471l-2.207 4.5 7.357 7.1.49.474 1.471-.71 11.035-5.446 7.6 2.841 4.169 12.549h11.035l.49-1.421 3.923-11.128 7.6-2.841 13 5.446 7.357-7.814-.736-1.421z" fill="#7a7a7a"/>
    <path d="M685.347 43.8c-8.337 8.524-21.824 8.524-29.671-.474a2.1 2.1 0 00-3.433 0 2.637 2.637 0 00-.736 1.894 4.428 4.428 0 00.736 1.894c9.809 10.655 26.238 10.892 36.783.474 8.337-8.05 21.334-8.287 29.426.71 1.226 1.184 2.7 1.184 3.433 0a2.637 2.637 0 00.736-1.894 4.428 4.428 0 00-.736-1.894 25.267 25.267 0 00-36.538-.71z" fill="#48c8ef"/>
    <path d="M703.739 48.3a15.849 15.849 0 00-11.77 4.735l-.49.474-.49.474a28.143 28.143 0 01-21.334 8.524c-8.092 0-15.2-3.788-21.089-9.471-1.226-1.184-2.7-1.184-3.433 0-.245 0-.245.474-.245 1.184a3.164 3.164 0 001.226 2.131 32.9 32.9 0 0024.522 11.128c9.073.474 17.9-3.315 24.767-10.418l.49-.474.49-.474a11.315 11.315 0 018.092-3.315c2.943 0 5.64 1.421 8.092 3.788 1.226 1.184 2.7 1.184 3.433 0a2.637 2.637 0 00.736-1.894A4.428 4.428 0 00716 52.8a20.361 20.361 0 00-12.261-4.5z" fill="#00abec"/>
    <path d="M683.14 38.594a29.262 29.262 0 0121.334-8.761c7.847 0 15.2 3.788 20.6 9.471 1.226 1.184 2.7 1.184 3.433 0a2.637 2.637 0 00.736-1.894 4.428 4.428 0 00-.736-1.894 32.9 32.9 0 00-24.522-11.128 33.493 33.493 0 00-24.767 10.418l-.49.474-.49.474a11.315 11.315 0 01-8.092 3.315c-3.188 0-5.64-1.421-8.092-3.788-1.226-1.184-2.7-1.184-3.433 0a2.637 2.637 0 00-.736 1.894 4.428 4.428 0 00.736 1.894 16.131 16.131 0 0023.3.474l.49-.474z" fill="#84d6ef"/>
    <g opacity=".2" style="isolation:isolate" fill="#f1f1f1">
        <path d="M705.945 58.957c-.49 0-.736-.474-1.471-.474a6.137 6.137 0 00-4.169 1.894l-.49.474a37.092 37.092 0 01-15.694 9.471l-2.207 4.5 3.923 3.788 20.108-19.652zM685.1 25.1a39.688 39.688 0 0119.372-4.735 40.308 40.308 0 0125.257 9.945c1.226.947 2.207 1.657 3.433 2.6l20.353-19.652-4.169-4.025-1.471.71-11.032 5.447-7.6-2.841L724.337 0H713.3l-.49 1.421-3.678 11.128-7.6 2.841-13-5.446-7.847 7.34.736 1.421z"/>
    </g>
    <path d="M429.5 41.581a1.4 1.4 0 01-1.5 1.451h-11.721a1.4 1.4 0 01-1.5-1.451v-8.415a1.4 1.4 0 011.5-1.451H428a1.4 1.4 0 011.5 1.451zM450.541 50.287a1.4 1.4 0 01-1.5 1.451h-11.724a1.4 1.4 0 01-1.5-1.451v-8.415a1.4 1.4 0 011.5-1.451h11.721a1.4 1.4 0 011.5 1.451zM429.5 58.993a1.4 1.4 0 01-1.5 1.451h-11.721a1.4 1.4 0 01-1.5-1.451v-8.416a1.4 1.4 0 011.5-1.451H428a1.4 1.4 0 011.5 1.451zM408.465 32.875a1.4 1.4 0 01-1.5 1.451h-12.024a1.4 1.4 0 01-1.5-1.451v-8.706a1.4 1.4 0 011.5-1.451h11.721c1.2 0 1.8.58 1.8 1.451z" fill="#b8d432"/>
    <path d="M461.06 2.4h-84.152a1.4 1.4 0 00-1.5 1.451v17.417a1.4 1.4 0 001.5 1.451h9.016a1.4 1.4 0 001.5-1.451v-7.255h63.114v7.255c0 .871.6 1.451 1.8 1.451h8.716a1.4 1.4 0 001.5-1.451V3.856A1.4 1.4 0 00461.06 2.4zM461.06 69.44h-8.716a1.4 1.4 0 00-1.5 1.451v6.965h-63.417V70.6c0-.871-.6-1.451-1.8-1.451h-8.716c-.9 0-1.5.58-1.5 1.741v17.123a1.4 1.4 0 001.5 1.451h84.149a1.4 1.4 0 001.5-1.451V70.891a1.4 1.4 0 00-1.5-1.451z" fill="#0072c6"/>
    <path d="M408.465 50.287a1.4 1.4 0 01-1.5 1.451h-12.024a1.4 1.4 0 01-1.5-1.451v-8.706a1.4 1.4 0 011.5-1.451h11.721c1.2 0 1.8.58 1.8 1.451zM408.465 67.7a1.4 1.4 0 01-1.5 1.451h-12.024a1.4 1.4 0 01-1.5-1.451v-8.707a1.4 1.4 0 011.5-1.451h11.721c1.2 0 1.8.58 1.8 1.451z" fill="#b8d432"/>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="16.678" transform="matrix(1.036 0 0 1 346.585 704.544)">
        Azure Data Factory
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="16.678" transform="matrix(1.036 0 0 1 328.937 519.979)">
        Energy Demand Forecast<tspan x="67.614" y="22.568">(SQL)</tspan>
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="16.678" transform="matrix(1.036 0 0 1 328.938 296.499)">
        Energy Demand Forecast<tspan x="16.775" y="22.568">(Machine Learning)</tspan>
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="16.678" transform="matrix(1.036 0 0 1 660.608 305.394)">
        Geography Data<tspan x="7.659" y="22.568">(Blob Storage)</tspan>
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="16.678" transform="matrix(1.036 0 0 1 956.44 519.979)">
        Power BI
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="16.678" transform="matrix(1.036 0 0 1 37.927 316.512)">
        Sample Data
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="16.678" transform="matrix(1.036 0 0 1 334.765 111.934)">
        Raw event data queue<tspan x="38.685" y="22.568">(Event Hubs)</tspan>
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="16.678" transform="matrix(1.036 0 0 1 583.489 110.823)">
        Stream Analysis and Data Movement<tspan x="62.789" y="22.568">(Stream Analytics)</tspan>
    </text>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.043" d="M418.984 335.304v49.225"/>
    <path fill="#afafaf" d="M413.782 336.826l5.202-9.009 5.202 9.009h-10.404zM413.782 383.007l5.202 9.008 5.202-9.008h-10.404z"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width=".785" d="M418.984 585.475l.354-23.349"/>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.043" d="M601.42 42.898H497.723"/>
    <path fill="#afafaf" d="M599.898 37.696l9.008 5.202-9.008 5.202V37.696z"/>
    <g>
        <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.043" d="M903.284 462.061H491.052"/>
        <path fill="#afafaf" d="M901.762 456.859l9.008 5.202-9.008 5.202v-10.404z"/>
    </g>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.043" d="M792.991 42.822h196.72"/>
    <g>
        <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.079" d="M989.635 363.88l.076-320.982"/>
        <path fill="#afafaf" d="M995.017 362.307l-5.383 9.317-5.38-9.32 10.763.003z"/>
    </g>
    <g>
        <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.043" d="M721.756 192.997v-36.346"/>
        <path fill="#afafaf" d="M726.958 158.173l-5.202-9.008-5.201 9.008h10.403z"/>
    </g>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.079" d="M222.926 46.234l-1.109 414.715"/>
    <g>
        <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.489" d="M306.917 45.934h-84.548"/>
        <path fill="#afafaf" d="M304.744 38.507l12.861 7.427-12.861 7.426V38.507z"/>
    </g>
    <g>
        <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.489" d="M306.917 460.948h-84.548"/>
        <path fill="#afafaf" d="M304.744 453.522l12.861 7.426-12.861 7.427v-14.853z"/>
    </g>
    <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.043" d="M222.367 247.476h-70.601"/>
    <g>
        <path d="M675.615 277.749a3.47 3.47 0 003.322 3.507h85.454a3.5 3.5 0 003.507-3.507v-61.091h-92.283z" fill="#a0a1a2"/>
        <path d="M764.391 202.447h-85.454a3.47 3.47 0 00-3.322 3.507v10.52H767.9v-10.52a3.5 3.5 0 00-3.507-3.507" fill="#7a7a7a"/>
        <path fill="#0072c6" d="M682.444 222.934h37.651v23.993h-37.651zM682.444 250.249h37.651v23.993h-37.651z"/>
        <path fill="#fff" d="M723.418 222.934h37.467v23.993h-37.467z"/>
        <path fill="#0072c6" d="M723.418 250.249h37.467v23.993h-37.467z"/>
        <path d="M679.306 202.447a3.7 3.7 0 00-3.691 3.691v71.242a3.7 3.7 0 003.691 3.691h4.06l72.719-78.625z" fill="#fff" opacity=".2" style="isolation:isolate"/>
    </g>
    <g>
        <path d="M385.365 422.924l.135 64.643c.014 6.711 15.048 12.122 33.577 12.083l-.16-76.8z" fill="#0072c6"/>
        <path d="M418.617 499.648h.46c18.529-.039 33.541-5.508 33.527-12.221l-.135-64.643-34.012.071z" fill="#0072c6"/>
        <path d="M418.617 499.648h.46c18.529-.039 33.541-5.508 33.527-12.221l-.135-64.643-34.012.071z" fill="#fff" opacity=".15" style="isolation:isolate"/>
        <path d="M452.469 422.784c.014 6.711-15 12.183-33.527 12.221s-33.563-5.37-33.577-12.081 15-12.183 33.527-12.221 33.563 5.37 33.577 12.081" fill="#fff"/>
        <path d="M445.608 422.1c.009 4.431-11.934 8.043-26.676 8.073s-26.7-3.532-26.711-7.962 11.936-8.043 26.677-8.073 26.7 3.534 26.709 7.962" fill="#7fba00"/>
        <path d="M440.026 427.009c3.491-1.362 5.588-3.064 5.584-4.908-.009-4.431-11.967-7.995-26.711-7.964s-26.685 3.645-26.676 8.075c0 1.844 2.107 3.536 5.6 4.884 4.876-1.9 12.5-3.143 21.092-3.161s16.219 1.189 21.106 3.073" fill="#b8d432"/>
        <path d="M408.354 467.747a5.511 5.511 0 01-2.176 4.671 9.8 9.8 0 01-6.035 1.667 11.485 11.485 0 01-5.482-1.17l-.01-4.726a8.454 8.454 0 005.6 2.145 3.807 3.807 0 002.281-.6 1.848 1.848 0 00.8-1.568 2.191 2.191 0 00-.779-1.667 14.242 14.242 0 00-3.156-1.825q-4.849-2.262-4.857-6.191a5.6 5.6 0 012.1-4.575 8.616 8.616 0 015.607-1.732 14.017 14.017 0 015.141.8l.009 4.414a8.376 8.376 0 00-4.876-1.467 3.607 3.607 0 00-2.168.586 1.837 1.837 0 00-.793 1.559 2.224 2.224 0 00.646 1.646 10.391 10.391 0 002.638 1.582 13.056 13.056 0 014.238 2.841 5.308 5.308 0 011.272 3.61zM431.127 462.916a12.08 12.08 0 01-1.685 6.486 9.064 9.064 0 01-4.775 3.864l6.154 5.673-6.2.013-4.4-4.908a10.282 10.282 0 01-5.091-1.481 9.345 9.345 0 01-3.508-3.795 11.668 11.668 0 01-1.245-5.38 12.582 12.582 0 011.323-5.873 9.492 9.492 0 013.749-3.973 10.979 10.979 0 015.55-1.4 10.215 10.215 0 015.237 1.333 9.168 9.168 0 013.6 3.816 12.087 12.087 0 011.291 5.625zm-5.019.277a8.284 8.284 0 00-1.414-5.085 4.541 4.541 0 00-3.844-1.861 4.821 4.821 0 00-3.968 1.883 9.113 9.113 0 00-.01 9.944 4.7 4.7 0 003.887 1.845 4.762 4.762 0 003.909-1.8 7.61 7.61 0 001.44-4.926zM447.258 473.618l-12.609.026-.045-21.173 4.769-.01.036 17.305 7.841-.017.008 3.869z" fill="#fff"/>
    </g>
    <g>
        <path d="M462.2 648.29v-21l-23.779 20.655h-.521v-20.657l-23.779 20.655v-43.219c0-3.645-8.158-7.29-18.919-7.29s-19.614 3.471-19.614 7.29v79.149h86.786zm-67-40.095c-7.811 0-14.059-1.909-14.059-3.992s6.249-3.992 14.059-3.992 14.059 1.736 14.059 3.992c-.168 2.083-6.417 3.997-14.059 3.997zm40.963 61.618h-9.546v-9.546h9.546zm-16.836 0h-9.546v-9.546h9.546zm24.3 0v-9.546h9.546v9.546z" fill="#59b4d9"/>
        <path fill="#3999c6" d="M375.591 604.203h19.266v79.669h-19.266z"/>
        <path d="M413.951 604.2c0 3.819-8.679 6.943-19.266 6.943s-19.093-3.124-19.093-6.943 8.679-6.943 19.266-6.943 19.093 2.951 19.093 6.943" fill="#fff"/>
        <path d="M410.132 603.683c0 2.6-6.769 4.513-15.274 4.513s-15.274-1.909-15.274-4.513 6.769-4.513 15.274-4.513 15.274 2.083 15.274 4.513" fill="#7fba00"/>
        <path d="M406.834 606.46c2.083-.694 3.124-1.736 3.124-2.777 0-2.6-6.769-4.513-15.274-4.513s-15.274 2.083-15.274 4.513c.174 1.041 1.389 2.083 3.3 2.777a36.849 36.849 0 0112.15-1.736 36.461 36.461 0 0111.976 1.736" fill="#b8d432"/>
    </g>
    <g>
        <path d="M53.758 216.151v63.027c0 6.543 14.647 11.849 32.713 11.849v-74.876z" fill="#3999c6"/>
        <path d="M86.022 291.025h.449c18.066 0 32.713-5.3 32.713-11.847v-63.027H86.022z" fill="#59b4d9"/>
        <path d="M119.184 216.151c0 6.543-14.647 11.847-32.713 11.847s-32.713-5.3-32.713-11.847S68.4 204.3 86.471 204.3s32.713 5.3 32.713 11.847" fill="#fff"/>
        <path d="M112.5 215.468c0 4.32-11.652 7.817-26.025 7.817s-26.027-3.5-26.027-7.817 11.654-7.817 26.027-7.817 26.025 3.5 26.025 7.817" fill="#7fba00"/>
        <path d="M107.044 220.245c3.407-1.321 5.454-2.976 5.454-4.774 0-4.32-11.652-7.819-26.027-7.819s-26.025 3.5-26.025 7.819c0 1.8 2.047 3.452 5.454 4.774 4.758-1.847 12.193-3.039 20.571-3.039s15.811 1.192 20.573 3.039" fill="#b8d432"/>
    </g>
    <path d="M1026.271 490.456h-1.93V486.6h1.93a7.436 7.436 0 007.427-7.427v-39.429a7.436 7.436 0 00-7.427-7.428h-73.122a7.436 7.436 0 00-7.427 7.428v39.428a7.436 7.436 0 007.427 7.427h1.93v3.86h-1.93a11.3 11.3 0 01-11.286-11.287v-39.428a11.3 11.3 0 0111.287-11.287h73.121a11.3 11.3 0 0111.287 11.287v39.428a11.3 11.3 0 01-11.287 11.287"/>
    <path d="M965 477.534a5.237 5.237 0 015.237 5.237v12.077a5.238 5.238 0 01-5.237 5.238 5.237 5.237 0 01-5.239-5.235v-12.079a5.238 5.238 0 015.239-5.238zM981.476 500.087a5.239 5.239 0 01-5.239-5.238v-31a5.238 5.238 0 1110.477 0v31a5.239 5.239 0 01-5.238 5.239M1014.42 499.934a5.239 5.239 0 01-5.239-5.238V450.8a5.238 5.238 0 0110.477 0v43.9a5.239 5.239 0 01-5.238 5.239M997.948 500.087a5.239 5.239 0 01-5.239-5.238V471.82a5.238 5.238 0 0110.477 0v23.029a5.239 5.239 0 01-5.238 5.239"/>
</svg>

## Components
* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/): Stream Analytics aggregates energy consumption data in near real-time to write to Power BI.
* [Event Hubs](https://azure.microsoft.com/services/event-hubs/) ingests raw energy consumption data and passes it on to Stream Analytics.
* [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio/): Machine Learning forecasts the energy demand of a particular region given the inputs received.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database/): SQL Database stores the prediction results received from Azure Machine Learning. These results are then consumed in the Power BI dashboard.
* [Data Factory](https://azure.microsoft.com/services/data-factory/) handles orchestration and scheduling of the hourly model retraining.
* [Power BI](https://powerbi.microsoft.com) visualizes energy consumption data from Stream Analytics as well as predicted energy demand from SQL Database.

## Next Steps
* [Learn more about Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Event Hubs](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Machine Learning](/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn more about SQL Database](/azure/sql-database/)
* [Learn more about Data Factory](/azure/data-factory/data-factory-introduction)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)

[!INCLUDE [js_include_file](../../_js/index.md)]
