---
title: Information Chatbot
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: This Informational Bot can answer questions defined in a knowledge set or FAQ using Cognitive Services QnA Maker and answer more open-ended questions using Azure Cognitive Search.
ms.custom: acom-architecture, bot service, luis, interactive-diagram, ai-ml, 'https://azure.microsoft.com/solutions/architecture/information-chatbot/'
---
# Information Chatbot

[!INCLUDE [header_file](../header.md)]

This Informational Bot can answer questions defined in a knowledge set or FAQ using Cognitive Services QnA Maker and answer more open-ended questions using Azure Cognitive Search.

## Architecture

<svg class="architecture-diagram" aria-labelledby="information-chatbot"  viewbox="0 0 974.039 494.675"  xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g data-name="Layer 2">
        <g data-name="Layer 1">
            <image height="473" opacity=".25" style="mix-blend-mode:multiply" transform="translate(515.889)" width="161" xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKEAAAHZCAYAAADuV1uuAAAACXBIWXMAAAsSAAALEgHS3X78AAAIJElEQVR4Xu3Xsapd1RaA4ZXEIJIg2IhIrLSysLOQqK+gtdgF9D6Az5A6jfoUvkCqgza+gZ2ilZ0QC8HgPXeO7HXUJCfZRwz3b74NX7E3a83d/Iw553Z6erqdZ30uwbP0xNaeEN/l3ZXlOfiXpqOzph6L8bzJNy9cXZ5fXliu7a7DP3TWznQ0PU1X09dDk/HRCK/sD88CLy0vL68uN3avwQWdNTP9TEfT03Q1fT0I8aEIt4cDfHF5ZXl9eWt5e3lnubm8Cxc0vUw30890ND1NV9PXQyGeRTh79YzK6/uDby7vLR8sHy+3lk+WT5f/wBHTyfQy3Uw/09H0NF1NX9PZ9HZ57+/Pi8jUOSPzjeX95aPls+X2cmf5fPkSLmh6mW6mn+loepqupq/pbHp7cFHZtr+24jk8zt49o/PD/cVZ6Kvl7nKyfL18A0dMJyfboZvpZzqanqar6Ws6m96ubH+LcK7Rc4uZQ+Ts4TNCb+8LfLt8t/yw/Lj8BEdMJ9PLdDP9TEfT03Q1fU1n09t091iEN7bDYfLWdhild/eFfl5+We4tv8IR08n0Mt1MP9PR9DRdTV/T2bkRzmFxrtZzq5lD5YzQk+X7fcHflt+X+3DEdDK9TDfTz8l26Gm6urkdOpvenhjhXK/nhvPFdtjbZ7Te2xf+Y/kvHDGdTC/TzfQzHU1P09X0deEI54Yzh8zZ42fE3t//4BSOmE6ml+lm+pmOpicR8n8jQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCcs8swi+Wr5cfl3vL78sf+x/A00wn08t0M/1MR9PThSO8uXyyfL6cLN8vvyy/7QvfhyOmk+llupl+TrZDT9PVze0pEV5bbizvLLeWO8vd5bvl533BKftXOGI6mV6mm+lnOpqepqvpazqb3s6N8NXl7eXj5fby1fLtvtAP22G0/gRHTCfTy3Qz/UxH09N0NX1NZ49FeGV5YXl5eWv5cPlsO4zQWWBKPtkOe/s3cMR0crIdupl+pqPpabqavqaz6e3K9rcILy/PLy8tbyzvLx/tL07Bd/aFvoQLml6mm+lnOpqepqvpazqb3qa7S9vp6dyoH3y5uh0Oi68sby7vLR9shxF6azscKj/dDjcceJrpZHqZbqaf6Wh6mq6mr+lserv8oL89wrMteep8cX/w9e0wOmcPn8Pk3GrehQuaXqab6Wc6mp6mq+lrOnuwFf8Z4TkhTqkzMmfvnkPkjd1rcEFnzUw/09H0NF09FOB5EZ6FeHV/eA6P13bX4R86a2c6mp6mq7PLyOMRPhLj5d288Bz8S9PRWVOXHmvu0R/OmYzwTDyptf8BoQcTpLwpGOIAAAAASUVORK5CYII="/>
            <path fill="#f4f4f4" d="M520.96 5.372h147.929V465H520.96z"/>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(356.323 267.704)">
                Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">Acti</tspan><tspan letter-spacing="-.006em" x="63.034" y="0">v</tspan><tspan x="69.658" y="0">e Di</tspan><tspan letter-spacing="-.013em" x="94.021" y="0">r</tspan><tspan x="98.704" y="0">ec</tspan><tspan letter-spacing="-.008em" x="112.492" y="0">t</tspan><tspan x="117.127" y="0">o</tspan><tspan letter-spacing=".04em" x="125.33" y="0">r</tspan><tspan x="130.758" y="0">y</tspan>
            </text>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(540.948 267.704)">
                Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">Bot Se</tspan><tspan letter-spacing=".04em" x="78.969" y="0">r</tspan><tspan x="84.396" y="0">vice</tspan>
            </text>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(734.843 269.704)">
                Language<tspan x="-15.555" y="16.8">Unde</tspan><tspan letter-spacing=".007em" x="17.551" y="16.8">r</tspan><tspan x="22.514" y="16.8">standing</tspan>
            </text>
            <image height="309" opacity=".25" style="mix-blend-mode:multiply" transform="translate(0 164.058)" width="163" xlink:href="data:image/png;base64,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"/>
            <path fill="#f4f4f4" d="M5.34 168.836h149.714v296.003H5.34z"/>
            <text fill="#525252" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(25.953 268.051)">
                Cus<tspan letter-spacing="-.008em" x="22.531" y="0">t</tspan><tspan x="27.166" y="0">omer mobile</tspan>
            </text>
            <path d="M50.97 187.629h21.439a3.695 3.695 0 013.695 3.695v45.592a3.693 3.693 0 01-3.693 3.693H50.969a3.694 3.694 0 01-3.694-3.694v-45.591a3.695 3.695 0 013.695-3.695z" fill="#454c50"/>
            <path fill="#505659" d="M58.491 235.539h6.397v2.134h-6.397z"/>
            <circle cx="61.691" cy="191.631" fill="#505659" r="1.067"/>
            <path fill="#fff" d="M49.366 195.638H74.01V232.6H49.366z"/>
            <path fill="#e6625c" d="M51.262 197.532h20.854v3.188H51.262z"/>
            <path fill="#e8e8e8" d="M51.262 227.362h20.854v1.049H51.262zM51.262 229.656h20.854v1.049H51.262z"/>
            <path fill="#b3e9ff" d="M51.262 209.779h20.854v16.337H51.262z"/>
            <path fill="#d4d6d8" d="M51.262 201.964h20.854v6.57H51.262z"/>
            <path d="M85.539 187.629h21.439a3.695 3.695 0 013.695 3.695v45.59a3.695 3.695 0 01-3.695 3.695h-21.44a3.694 3.694 0 01-3.694-3.694v-45.591a3.695 3.695 0 013.695-3.695z" fill="#454c50"/>
            <path fill="#505659" d="M93.06 235.539h6.397v2.134H93.06z"/>
            <circle cx="96.26" cy="191.631" fill="#505659" r="1.067"/>
            <path fill="#fff" d="M83.935 195.638h24.644V232.6H83.935z"/>
            <rect fill="#85c808" height="11.05" rx=".731" ry=".731" width="12.212" x="90.652" y="211.378"/>
            <path fill="#85c808" d="M90.641 211.378h12.235v5.036H90.641zM106.131 218.111a1.3 1.3 0 01-1.3 1.3 1.3 1.3 0 01-1.3-1.3v-5.847a1.3 1.3 0 011.3-1.3 1.3 1.3 0 011.3 1.3zM89.989 218.111a1.3 1.3 0 01-1.3 1.3 1.3 1.3 0 01-1.3-1.3v-5.847a1.3 1.3 0 011.3-1.3 1.3 1.3 0 011.3 1.3zM90.692 210.658s.135-5.178 6.067-5.16c5.876.018 6.067 5.16 6.067 5.16z"/>
            <circle cx="94.096" cy="208.015" fill="#fff" r=".73"/>
            <circle cx="99.421" cy="208.015" fill="#fff" r=".73"/>
            <path d="M93.895 206.194c.021.03.088.021.148-.022.06-.042.091-.1.07-.132l-1.133-1.6c-.022-.031-.088-.021-.148.022s-.092.1-.07.133zM99.622 206.194c-.021.03-.087.021-.148-.022-.06-.042-.091-.1-.07-.132l1.133-1.6c.022-.031.088-.021.148.022s.092.1.07.133zM100.571 225.679a1.3 1.3 0 01-1.3 1.3 1.3 1.3 0 01-1.3-1.3v-5.848a1.3 1.3 0 011.3-1.3 1.3 1.3 0 011.3 1.3zM95.549 225.679a1.3 1.3 0 01-1.3 1.3 1.3 1.3 0 01-1.3-1.3v-5.848a1.3 1.3 0 011.3-1.3 1.3 1.3 0 011.3 1.3z" fill="#85c808"/>
            <path d="M87.529 394.562h-13.6c1.634 5.768-.561 6.6-10.175 6.6v3.02H96.45v-3.02c-9.614 0-10.557-.824-8.921-6.6" fill="#7a7a7a"/>
            <path d="M102.083 358.028H57.821a2.828 2.828 0 00-2.717 2.847v30.866a2.812 2.812 0 002.717 2.823h44.262a3.09 3.09 0 003.021-2.823v-30.866a3.1 3.1 0 00-3.021-2.847" fill="#a0a1a2"/>
            <path d="M102.114 358.031H57.82a2.827 2.827 0 00-2.717 2.847v30.865a2.812 2.812 0 002.717 2.824h1.053z" fill="#fff" opacity=".2" style="isolation:isolate"/>
            <path fill="#59b4d9" d="M101.201 361.876v28.841H58.893v-28.841h42.308z"/>
            <path fill="#59b4d9" d="M58.893 390.717h.058v-28.84l38.68-.058h.002l-38.74.058v28.84z"/>
            <path fill="#a0a1a2" d="M63.758 401.156H96.45v3.021H63.758z"/>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(14.327 425.438)">
                Consume, PC, Mobile<tspan x="47.482" y="16.8">Cloud</tspan>
            </text>
            <g fill="#969696">
                <path d="M145.206 226.532h219.746v1.5H145.206z"/>
                <path d="M363.42 222.046l9.067 5.236-9.067 5.235v-10.471zM146.737 222.046l-9.066 5.236 9.066 5.235v-10.471z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="251.809" cy="227.095" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(247.762 232.798)">
                    1
                </text>
            </a>
            <path fill="#969696" d="M313.721 273.75H194.139v-46.388h1.5v44.888h116.582v-44.809h1.5v46.309z"/>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="251.889" cy="273" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(247.842 278.703)">
                    5
                </text>
            </a>
            <g>
                <path d="M425.089 243.47a4.575 4.575 0 01-3.261-1.352l-20.389-20.388a4.61 4.61 0 010-6.521l20.389-20.388a4.609 4.609 0 016.522 0l20.386 20.388a4.609 4.609 0 010 6.523l-20.386 20.386a4.578 4.578 0 01-3.261 1.352" fill="#59b4d9"/>
                <path d="M438.7 214.562a3.9 3.9 0 00-3.265 6.052l-7.744 7.744a4.55 4.55 0 00-.656-.373v-19.757a3.909 3.909 0 10-3.9 0v19.756a4.48 4.48 0 00-.632.353l-7.753-7.753a4.016 4.016 0 10-2.006 1.566l8.15 8.15a4.551 4.551 0 108.387.032l8.173-8.172a3.867 3.867 0 001.241.22 3.909 3.909 0 000-7.818z" fill="#fff"/>
                <path fill="#fff" opacity=".5" style="isolation:isolate" d="M424.155 205.62l1.783-1.784 14.623 14.618-1.784 1.784z"/>
                <path fill="#fff" opacity=".5" style="isolation:isolate" d="M409.634 218.466l14.62-14.62 1.785 1.784-14.62 14.621z"/>
                <path d="M427.753 232.083a2.709 2.709 0 11-2.71-2.709 2.71 2.71 0 012.71 2.709M427.262 204.858a2.174 2.174 0 11-2.174-2.174 2.174 2.174 0 012.174 2.174M413.651 218.47a2.174 2.174 0 11-2.174-2.174 2.175 2.175 0 012.174 2.174M440.876 218.47a2.174 2.174 0 11-2.176-2.17 2.175 2.175 0 012.175 2.174" fill="#b8d432"/>
                <path d="M428.35 194.821a4.608 4.608 0 00-6.521 0l-20.389 20.388a4.608 4.608 0 000 6.521l11.543 11.544 21.717-32.106z" fill="#fff" opacity=".1" style="isolation:isolate"/>
            </g>
            <g>
                <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(538.689 428.704)">
                    Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">App Se</tspan><tspan letter-spacing=".04em" x="83.487" y="0">r</tspan><tspan x="88.915" y="0">vice</tspan>
                </text>
                <path d="M588.957 400.969h-16.6v-16.5h3.4a8.808 8.808 0 01-.6-3.3v-.2h-6.3v23.5h23.6v-14h-3.5zM612.357 384.469h3v16.6h-16.6v-10.5h-3.5v13.9h23.6v-23.5h-7.4a7.045 7.045 0 01.9 3.3zM572.357 374.469v-16.5h16.6v9.6a9.278 9.278 0 013.5-1.6v-11.5h-23.6v23.5h6.8a9.49 9.49 0 012.2-3.4l-5.5-.1zM598.757 365.569v-7.6h16.6v16.6h-7.3a12.127 12.127 0 01.5 3.4v.1h10.3v-23.6h-23.6v10.9c.3 0 .5-.1.8-.1a24.77 24.77 0 012.7.3z" fill="#a0a1a2"/>
                <path d="M609.657 384.169a3.691 3.691 0 00-3.7-3.7h-.5a10.871 10.871 0 00.4-2.6 9.841 9.841 0 00-19.2-3.1 7.8 7.8 0 00-2.2-.4 6.8 6.8 0 000 13.6h21.8a3.8 3.8 0 003.4-3.8" fill="#59b4d9"/>
                <path d="M588.057 387.969a6.8 6.8 0 013.3-11.4 5.525 5.525 0 012.2-.1 9.919 9.919 0 015.5-8 9.427 9.427 0 00-3-.5 9.787 9.787 0 00-9.3 6.8 7.8 7.8 0 00-2.2-.4 6.8 6.8 0 000 13.6h3.5z" fill="#fff" opacity=".2" style="isolation:isolate"/>
            </g>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(536.809 107.704)">
                Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">App Insights</tspan>
            </text>
            <g>
                <path d="M610.112 49.041v-.3c0-7.7-6.6-14.1-14.7-14.2-.2-.3-4.8.1-4.8.1-7.3.9-13 7-13 14.1 0 .2-.8 5.8 4.9 10.5 2.6 2.3 5.3 8.5 5.7 10.3l.3.6h10.6l.3-.6c.4-1.8 3.2-8 5.7-10.2 5.7-4.8 5-10.1 5-10.3z" fill="#68217a"/>
                <path fill="#7a7a7a" d="M588.712 73.741h10.6v3.4h-10.6zM592.012 84.341h3.9l3.3-3.5h-10.5l3.3 3.5z"/>
                <path d="M596.612 69.641h-2v-12.7h-1.7v12.6h-2v-12.6h-1.7a3.757 3.757 0 01-3.7-3.7 3.7 3.7 0 017.4 0v1.7h1.7v-1.7a3.7 3.7 0 113.7 3.7h-1.7zm-7.4-18.1a1.685 1.685 0 00-1.7 1.7 1.752 1.752 0 001.7 1.7h1.7v-1.7a1.828 1.828 0 00-1.7-1.7zm9.1 0a1.752 1.752 0 00-1.7 1.7v1.7h1.7a1.752 1.752 0 001.7-1.7 1.685 1.685 0 00-1.7-1.7z" fill="#fff" opacity=".65"/>
                <path d="M595.412 34.541c-.2-.3-4.8.1-4.8.1-7.3.9-13 7-13 14.1a11.913 11.913 0 003.9 9.6l21.6-21.6a14.687 14.687 0 00-7.7-2.2z" fill="#fff" opacity=".15"/>
            </g>
            <g fill="#969696">
                <path d="M477.221 226.532h58.73v1.5h-58.73z"/>
                <path d="M534.419 222.046l9.067 5.236-9.067 5.235v-10.471zM478.753 222.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <g fill="#969696">
                <path d="M822.221 389.532h58.73v1.5h-58.73z"/>
                <path d="M879.419 385.046l9.067 5.236-9.067 5.235v-10.471zM823.753 385.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <g fill="#969696">
                <path d="M822.221 226.532h58.73v1.5h-58.73z"/>
                <path d="M879.419 222.046l9.067 5.236-9.067 5.235v-10.471zM823.753 222.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <g>
                <g fill="#0078d7">
                    <path d="M752.707 237.618a5.931 5.931 0 01-1-3.831V227.1c0-3.5-1.236-5.69-3.7-6.5l-.133-.051v-.349l.133-.051c2.452-.919 3.7-3.157 3.7-6.692v-6.743c0-3.075 1.43-4.751 4.1-4.832V198.3c-2.861.031-5.047.725-6.477 2.1-1.461 1.379-2.186 3.453-2.186 6.334v6.692c0 3.32-1.379 5.129-4.015 5.21v3.586c2.7.082 4.015 1.675 4.015 4.9v7.121c0 2.993.674 5.047 2.1 6.283 1.267 1.216 3.5 1.89 6.477 1.91v-.031h.112v-3.5a4.2 4.2 0 01-3.126-1.287zM786.584 213.313v-6.692c0-2.912-.7-4.986-2.186-6.365-1.461-1.349-3.617-2.074-6.477-2.1v3.617c2.666.082 4.1 1.757 4.1 4.832v6.773c0 3.555 1.216 5.772 3.7 6.692l.133.051v.347l-.133.051c-2.452.807-3.7 2.993-3.7 6.5v6.692a5.78 5.78 0 01-1 3.831 3.809 3.809 0 01-3.024 1.267v3.484c2.881-.031 5.047-.674 6.477-1.91 1.4-1.3 2.1-3.422 2.1-6.283v-7.151c0-3.126 1.379-4.832 4.015-4.9V218.5c-2.656-.058-4.005-1.815-4.005-5.187z"/>
                </g>
            </g>
            <g fill="#3f92cf">
                <path d="M595.088 195.879a22 22 0 11-22 22 22.025 22.025 0 0122-22m0-3a25 25 0 1025 25 25 25 0 00-25-25z"/>
                <circle cx="591.221" cy="217.879" r="2.25"/>
                <circle cx="598.846" cy="217.879" r="2.25"/>
                <path d="M591.221 206.86l-2.121-2.121-12.2 12.2a1.328 1.328 0 000 1.879l1.18 1.182 11.02 11.02 2.121-2.121L580.2 217.88zM598.564 228.9l2.121 2.121 12.2-12.2a1.328 1.328 0 000-1.879l-1.182-1.182-11.018-11.019-2.121 2.121 11.019 11.019z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="507.889" cy="227" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(503.842 232.703)">
                    2
                </text>
            </a>
            <g>
                <path d="M920.345 368.191V404.3c0 3.749 8.392 6.789 18.743 6.789v-42.9z" fill="#0072c6"/>
                <path d="M938.831 411.09h.257c10.351 0 18.743-3.038 18.743-6.788v-36.111h-19z" fill="#0072c6"/>
                <path d="M938.831 411.09h.257c10.351 0 18.743-3.038 18.743-6.788v-36.111h-19z" fill="#fff" opacity=".15" style="isolation:isolate"/>
                <path d="M957.831 368.191c0 3.749-8.392 6.788-18.743 6.788s-18.743-3.039-18.743-6.788 8.392-6.788 18.743-6.788 18.743 3.039 18.743 6.788" fill="#fff"/>
                <path d="M954 367.8c0 2.475-6.676 4.479-14.911 4.479s-14.912-2-14.912-4.479 6.677-4.479 14.912-4.479S954 365.326 954 367.8" fill="#7fba00"/>
                <path d="M950.875 370.537c1.952-.757 3.125-1.705 3.125-2.735 0-2.475-6.676-4.48-14.912-4.48s-14.911 2.005-14.911 4.48c0 1.03 1.173 1.978 3.125 2.735a40.768 40.768 0 0123.573 0" fill="#b8d432"/>
                <path d="M933.135 393.257a3.079 3.079 0 01-1.221 2.607 5.475 5.475 0 01-3.373.924 6.416 6.416 0 01-3.061-.66v-2.64a4.723 4.723 0 003.126 1.205 2.127 2.127 0 001.275-.33 1.032 1.032 0 00.45-.875 1.224 1.224 0 00-.433-.932 7.956 7.956 0 00-1.761-1.023q-2.706-1.269-2.706-3.464a3.127 3.127 0 011.18-2.553 4.813 4.813 0 013.134-.961 7.83 7.83 0 012.871.454v2.466a4.679 4.679 0 00-2.722-.825 2.015 2.015 0 00-1.212.325 1.026 1.026 0 00-.445.87 1.243 1.243 0 00.359.92 5.8 5.8 0 001.472.887 7.293 7.293 0 012.364 1.592 2.965 2.965 0 01.703 2.013zM945.862 390.585a6.748 6.748 0 01-.949 3.621 5.064 5.064 0 01-2.672 2.153l3.431 3.176h-3.464l-2.45-2.747a5.744 5.744 0 01-2.842-.833 5.221 5.221 0 01-1.955-2.124 6.518 6.518 0 01-.689-3.007 7.028 7.028 0 01.746-3.279 5.3 5.3 0 012.1-2.215 6.133 6.133 0 013.1-.775 5.706 5.706 0 012.924.751 5.122 5.122 0 012 2.136 6.752 6.752 0 01.72 3.143zm-2.8.149a4.628 4.628 0 00-.784-2.842 2.537 2.537 0 00-2.145-1.044 2.693 2.693 0 00-2.219 1.047 5.091 5.091 0 00-.017 5.555 2.625 2.625 0 002.169 1.035 2.66 2.66 0 002.186-1 4.251 4.251 0 00.806-2.751zM954.861 396.582h-7.044v-11.828h2.664v9.667h4.38v2.161z" fill="#fff"/>
            </g>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(907.137 433.083)">
                <tspan letter-spacing="-.032em">S</tspan><tspan x="6.986" y="0">tructu</tspan><tspan letter-spacing="-.013em" x="43.654" y="0">r</tspan><tspan x="48.337" y="0">ed</tspan>
            </text>
            <g>
                <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(725.049 433.083)">
                    Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e Sea</tspan><tspan letter-spacing="-.013em" x="61.004" y="0">r</tspan><tspan x="65.687" y="0">ch</tspan>
                </text>
                <path d="M784.087 375.447c0-.4.1-.9.1-1.3a12.869 12.869 0 00-13-12.8 12.621 12.621 0 00-10.5 5.2 9.309 9.309 0 00-5.2-1.5 9.8 9.8 0 00-9.8 9.7v.8a9.7 9.7 0 00-5.6 8.8c0 6 4.9 10.7 11.2 10.7h27.6c6.3 0 11.2-4.7 11.2-10.7a9.486 9.486 0 00-6-8.9z" fill="#59b4d9"/>
                <path d="M747.087 389.247c0-4.1 2.1-7.3 6-9.3v-.8a10.494 10.494 0 0115.9-8.8 13.828 13.828 0 0111.2-5.7 13.546 13.546 0 00-9-3.4 12.978 12.978 0 00-10.5 5.3 9.309 9.309 0 00-5.2-1.5 9.8 9.8 0 00-9.8 9.7v.8a9.7 9.7 0 00-5.6 8.8 10.6 10.6 0 008.4 10.4 11.236 11.236 0 01-1.4-5.5z" fill="#fff" opacity=".2" style="isolation:isolate"/>
                <path d="M774.387 392.247a8.654 8.654 0 01-8.4 6.6 7.612 7.612 0 01-2.1-.3 8.98 8.98 0 01-2.8-1.3 9.19 9.19 0 01-2.2-2.2 8.751 8.751 0 01-1.3-6.9 8.654 8.654 0 018.4-6.6 7.613 7.613 0 012.1.3 8.713 8.713 0 015.3 3.9 8.243 8.243 0 011 6.5" fill="#fff"/>
                <path d="M774.387 392.247a8.654 8.654 0 01-8.4 6.6 7.612 7.612 0 01-2.1-.3 8.98 8.98 0 01-2.8-1.3 9.19 9.19 0 01-2.2-2.2 8.751 8.751 0 01-1.3-6.9 8.654 8.654 0 018.4-6.6 7.613 7.613 0 012.1.3 8.713 8.713 0 015.3 3.9 8.243 8.243 0 011 6.5" fill="#59b4d9" opacity=".1" style="isolation:isolate"/>
                <path d="M770.687 382.947a8.486 8.486 0 00-2.6-1.1 7.612 7.612 0 00-2.1-.3 8.654 8.654 0 00-8.4 6.6 8.3 8.3 0 001.3 6.9 7.006 7.006 0 00.8 1 22.367 22.367 0 0111-13.1" fill="#59b4d9" opacity=".3" style="isolation:isolate"/>
                <path d="M776.587 383.847a12.352 12.352 0 00-7.6-5.6 15.438 15.438 0 00-3-.4 12.4 12.4 0 00-12 9.4 12.1 12.1 0 001.3 9.1l-9.4 9.5a3.263 3.263 0 000 4.5 3.389 3.389 0 004.6 0l9.4-9.5a12.66 12.66 0 003.2 1.3 15.438 15.438 0 003 .4 12.4 12.4 0 0012-9.4 12.614 12.614 0 00-1.5-9.3zm-2.2 8.4a8.654 8.654 0 01-8.4 6.6 7.612 7.612 0 01-2.1-.3 8.98 8.98 0 01-2.8-1.3 9.19 9.19 0 01-2.2-2.2 8.751 8.751 0 01-1.3-6.9 8.654 8.654 0 018.4-6.6 7.613 7.613 0 012.1.3 8.713 8.713 0 015.3 3.9 8.306 8.306 0 011 6.5z" fill="#3e3e3e"/>
                <path d="M758.987 400.347a12.174 12.174 0 01-3.2-3.2c-.2-.3-.3-.5-.5-.8l-.8.9-.1.1a2.092 2.092 0 00.4.6 14.963 14.963 0 003.5 3.6 2.389 2.389 0 00.7.3l.9-.9c-.4-.3-.6-.4-.9-.6z" fill="#1e1e1e" opacity=".5" style="isolation:isolate"/>
            </g>
            <g fill="#969696">
                <path d="M652.221 389.813h58.73v1.5h-58.73z"/>
                <path d="M709.419 385.328l9.067 5.236-9.067 5.235v-10.471zM653.753 385.328l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="679.889" cy="390.282" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(675.842 395.985)">
                    7
                </text>
            </a>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="850.889" cy="390" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(846.842 395.703)">
                    6
                </text>
            </a>
            <g fill="#969696">
                <path d="M652.221 226.813h58.73v1.5h-58.73z"/>
                <path d="M709.419 222.328l9.067 5.236-9.067 5.235v-10.471zM653.753 222.328l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="680.889" cy="227.282" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(676.842 232.985)">
                    3
                </text>
            </a>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="851.889" cy="227" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(847.842 232.703)">
                    4
                </text>
            </a>
            <g>
                <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(904.135 272.704)">
                    QnA Ma<tspan letter-spacing="-.02em" x="51.037" y="0">k</tspan><tspan x="57.716" y="0">er</tspan>
                </text>
                <path d="M961.488 227.1l-7.1-3.073c-.255.019-.509.029-.769.029h-.275a15.084 15.084 0 00-14.644-12.187h-8.666a11.1 11.1 0 0110.9-11.17h12.689a11.1 11.1 0 0110.9 11.231v.9a11.334 11.334 0 01-4.961 9.405zM938.7 239.29h-12.688c-.26 0-.514-.01-.769-.029l-7.1 3.073 1.93-4.87a11.332 11.332 0 01-4.962-9.405v-.9a11.1 11.1 0 0110.9-11.231H938.7a10.991 10.991 0 0110.465 8.127 11.484 11.484 0 01.435 3.1v.962a11.1 11.1 0 01-10.9 11.17zm25.692-15.873a15.451 15.451 0 004.184-10.591v-.9a15.16 15.16 0 00-14.957-15.293h-12.687a15.157 15.157 0 00-14.955 15.234 15.159 15.159 0 00-14.923 15.291v.9a15.451 15.451 0 004.184 10.591l-4.481 11.306 15.257-6.6H938.7a15.157 15.157 0 0014.953-15.216l15.22 6.587z" fill="#0063b1"/>
            </g>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(550.634 490.17)">
                Application bot
            </text>
        </g>
    </g>
</svg>

<div class="architecture-tooltip-content" id="architecture-tooltip-1">
<p>Employee starts the Application Bot</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-2">
<p>Azure Active Directory validates the employee’s identity</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-3">
<p>The employee can ask the bot what type of queries are supported</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-4">
<p>Cognitive Services returns a FAQ built with the QnA Maker</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-5">
<p>The employee defines a valid query</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-6">
<p>The Bot submits the query to Azure Cognitive Search which returns information about the application data</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-7">
<p>Application insights gathers runtime telemetry to help development with Bot performance and usage</p>
</div>

## Data Flow

1. Employee starts the Application Bot
1. Azure Active Directory validates the employee’s identity
1. The employee can ask the bot what type of queries are supported
1. Cognitive Services returns a FAQ built with the QnA Maker
1. The employee defines a valid query
1. The Bot submits the query to Azure Cognitive Search which returns information about the application data
1. Application insights gathers runtime telemetry to help development with Bot performance and usage


[!INCLUDE [js_include_file](../../_js/index.md)]
