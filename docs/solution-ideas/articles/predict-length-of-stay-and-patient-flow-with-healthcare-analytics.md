---
title: Predict Length of Stay and Patient Flow
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Learn how to predict capacity and patient flow for your hospital or healthcare facility to enhance the quality of care and improve operational efficiency.
ms.custom: acom-architecture, hospital length of stay, patient flow, length of stay, healthcare analytics, healthcare machine learning
---
# Predict Length of Stay and Patient Flow

<div class="alert">
    <p class="alert-title">
        <span class="icon is-left" aria-hidden="true">
            <span class="icon docon docon-lightbulb" role="presentation"></span>
        </span>Solution Idea</p>
    <p>If you'd like to see us expand this article with more information (implementation details, pricing guidance, code examples, etc), let us know with <a href="#feedback">GitHub Feedback</a>!</p>
</div>

For the people running a healthcare facility, length of stay—the number of days from patient admission to discharge—matters. However, that number can vary across facilities and across disease conditions and specialties, even within the same healthcare system, making it harder to track patient flow and plan accordingly.

This Azure solution helps hospital administrators use the power of machine learning to predict the length of stay for in-hospital admissions, to improve capacity planning and resource utilization. A Chief Medical Information Officer might use a predictive model to determine which facilities are overtaxed and which resources to bolster within those facilities, and a Care Line Manager might use it to determine if there will be adequate staff resources to handle the release of a patient.

Being able to predict length of stay at the time of admission helps hospitals provide higher quality care and streamline their operational workload. It also helps accurately plan for discharges, lowering other quality measures such as readmissions.

## Architecture

<svg class="architecture-diagram" aria-labelledby="predict-length-of-stay-and-patient-flow-with-healthcare-analytics" height="117.719" viewbox="0 0 915.875 117.719" width="915.875" xmlns="http://www.w3.org/2000/svg">
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="15" style="isolation:isolate" transform="matrix(1.036 0 0 1 838.422 112.892)">
        <tspan letter-spacing="-.037em">P</tspan><tspan x="7.845" y="0">o</tspan><tspan letter-spacing="-.005em" x="16.634" y="0">w</tspan><tspan letter-spacing="0em" x="27.4" y="0">er BI</tspan>
    </text>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="15" style="isolation:isolate" transform="matrix(1.036 0 0 1 420.004 112.892)">
        SQL Data<tspan letter-spacing="-.013em" x="61.311" y="0">b</tspan><tspan x="69.932" y="0">ase</tspan>
    </text>
    <path d="M436.963 10.222l.129 61.89c.013 6.425 14.407 11.606 32.148 11.569l-.153-73.526z" fill="#0072c6"/>
    <path d="M467.188 83.663h.44c17.74-.037 32.113-5.168 32.1-11.464l-.128-60.631-32.564.068z" fill="#0072c6"/>
    <path d="M467.188 83.713h.44c17.74-.037 32.113-5.171 32.1-11.472l-.128-60.673-32.564.068z" fill="#fff" opacity=".15" style="isolation:isolate"/>
    <path d="M499.6 11.567c.013 6.425-14.359 11.664-32.1 11.7s-32.131-5.141-32.145-11.567S449.714.037 467.454 0s32.134 5.142 32.146 11.567" fill="#fff"/>
    <path d="M493.033 10.911c.009 4.242-11.426 7.7-25.54 7.73s-25.565-3.381-25.573-7.623 11.428-7.7 25.541-7.73 25.563 3.383 25.572 7.623" fill="#7fba00"/>
    <path d="M487.689 15.613c3.343-1.3 5.35-2.933 5.346-4.7-.009-4.242-11.458-7.654-25.573-7.625s-25.549 3.49-25.54 7.731c0 1.765 2.017 3.386 5.366 4.676 4.668-1.823 11.967-3.009 20.194-3.026s15.529 1.138 20.208 2.942" fill="#b8d432"/>
    <path d="M457.363 54.616a5.276 5.276 0 01-2.083 4.472 9.383 9.383 0 01-5.778 1.6 11 11 0 01-5.249-1.12l-.009-4.525a8.094 8.094 0 005.362 2.054 3.645 3.645 0 002.184-.57 1.77 1.77 0 00.768-1.5 2.1 2.1 0 00-.745-1.6 13.634 13.634 0 00-3.022-1.747q-4.642-2.165-4.65-5.927a5.36 5.36 0 012.013-4.38 8.249 8.249 0 015.368-1.658 13.42 13.42 0 014.922.768l.009 4.226a8.02 8.02 0 00-4.668-1.4 3.453 3.453 0 00-2.076.561 1.759 1.759 0 00-.76 1.493 2.13 2.13 0 00.619 1.575 9.948 9.948 0 002.526 1.515 12.5 12.5 0 014.057 2.72 5.082 5.082 0 011.212 3.443zM479.168 49.991a11.566 11.566 0 01-1.614 6.209 8.679 8.679 0 01-4.572 3.7l5.892 5.431-5.937.012-4.209-4.7a9.845 9.845 0 01-4.874-1.418 8.947 8.947 0 01-3.358-3.633 11.171 11.171 0 01-1.192-5.151 12.046 12.046 0 011.267-5.622 9.088 9.088 0 013.59-3.8 10.512 10.512 0 015.314-1.339 9.78 9.78 0 015.014 1.277 8.778 8.778 0 013.442 3.654 11.573 11.573 0 011.237 5.38zm-4.8.265a7.932 7.932 0 00-1.354-4.868 4.348 4.348 0 00-3.68-1.782 4.616 4.616 0 00-3.8 1.8 7.464 7.464 0 00-1.418 4.781 7.448 7.448 0 001.408 4.739 4.5 4.5 0 003.721 1.766 4.559 4.559 0 003.743-1.725 7.286 7.286 0 001.375-4.711zM494.613 60.237l-12.072.025-.043-20.272 4.566-.01.035 16.569 7.506-.016.008 3.704z" fill="#fff"/>
    <g>
        <path d="M100.922 73.5L74.69 29.912l-.037-17.666h.469a5.563 5.563 0 005.651-5.469A5.562 5.562 0 0075.1 1.331l-28.519.059a5.563 5.563 0 00-5.651 5.47 5.563 5.563 0 005.67 5.445h.472l.037 17.665-26.047 43.692c-2.858 4.792-.5 8.7 5.23 8.691l69.436-.145c5.733-.008 8.072-3.933 5.194-8.708z" fill="#59b4d9"/>
        <path fill="#b8d432" d="M42.553 54.834L31.804 72.863l58.371-.122-10.823-17.984-36.799.077z"/>
        <path d="M58.994 60.151a5.181 5.181 0 005.264-5.094 4.9 4.9 0 00-.542-2.223l-9.476.02a4.894 4.894 0 00-.533 2.225 5.183 5.183 0 005.287 5.072z" fill="#7fba00"/>
        <ellipse cx="68.908" cy="66.01" fill="#7fba00" rx="2.588" ry="2.494" transform="rotate(-.119 68.783 66.034)"/>
        <path d="M21.062 73.662l26.051-43.694-.037-17.668H46.6a5.563 5.563 0 01-5.67-5.445 5.561 5.561 0 015.651-5.467l12.29-.026.059 28.438-13.668 52.514-18.97.04c-5.734.011-8.092-3.9-5.23-8.692z" fill="#fff" opacity=".25" style="isolation:isolate"/>
    </g>
    <text fill="#505050" font-family="SegoeUI, Segoe UI" font-size="15" style="isolation:isolate" transform="matrix(1.036 0 0 1 0 112.891)">
        Machine Lea<tspan letter-spacing="-.002em" x="83.13" y="0">r</tspan><tspan x="88.315" y="0">ning</tspan>
    </text>
    <g>
        <path d="M904.592 73.771h-1.93v-3.86h1.93a7.436 7.436 0 007.427-7.427V23.059a7.436 7.436 0 00-7.427-7.428H831.47a7.436 7.436 0 00-7.427 7.428v39.428a7.436 7.436 0 007.427 7.427h1.93v3.86h-1.93a11.3 11.3 0 01-11.286-11.287V23.059a11.3 11.3 0 0111.291-11.287H904.6a11.3 11.3 0 0111.279 11.287v39.428a11.3 11.3 0 01-11.287 11.287"/>
        <path d="M843.324 60.849a5.237 5.237 0 015.237 5.237v12.077a5.238 5.238 0 01-5.238 5.238 5.237 5.237 0 01-5.239-5.235V66.087a5.238 5.238 0 015.238-5.238zM859.8 83.4a5.239 5.239 0 01-5.239-5.238v-31a5.238 5.238 0 1110.477 0v31A5.239 5.239 0 01859.8 83.4M892.741 83.249a5.239 5.239 0 01-5.239-5.238v-43.9a5.238 5.238 0 0110.477 0v43.9a5.239 5.239 0 01-5.238 5.239M876.269 83.4a5.239 5.239 0 01-5.239-5.238V55.135a5.238 5.238 0 1110.477 0v23.029a5.239 5.239 0 01-5.238 5.239"/>
    </g>
    <g>
        <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.6" d="M139.951 48.641h258.773"/>
        <path fill="#afafaf" d="M141.702 54.625l-10.362-5.984 10.362-5.983v11.967zM396.974 54.625l10.362-5.984-10.362-5.983v11.967z"/>
    </g>
    <g>
        <path fill="none" stroke="#afafaf" stroke-miterlimit="10" stroke-width="1.6" d="M532.784 48.641h258.773"/>
        <path fill="#afafaf" d="M534.534 54.625l-10.362-5.984 10.362-5.983v11.967zM789.806 54.625l10.362-5.984-10.362-5.983v11.967z"/>
    </g>
</svg>

## Components
* [SQL Server R Services](https://www.microsoft.com/sql-server/sql-server-r-services): Stores the patient and hospital data. Provides training and predicted models and predicted results for consumption using R.
* [Power BI](https://powerbi.microsoft.com/) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.
* [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio/): Machine Learning helps you easily design, test, operationalize, and manage predictive analytics solutions in the cloud.

## Next Steps
* [Learn more about SQL Server](https://www.microsoft.com/sql-server/sql-server-r-services)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)
* [Learn more about Machine Learning](/azure/machine-learning/machine-learning-what-is-machine-learning)

[!INCLUDE [js_include_file](../../_js/index.md)]
