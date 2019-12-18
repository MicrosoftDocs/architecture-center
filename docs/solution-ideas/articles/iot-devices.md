---
title: IoT devices
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Create seamless conversational interfaces with all of your internet-accessible devices—from your connected television or fridge to devices in a connected power plant. LUIS is able to integrate up to 500 intents to translate commands into smart actions.
ms.custom: acom-architecture, bot service, luis, interactive-diagram, iot, 'https://azure.microsoft.com/solutions/architecture/iot-devices/'
---
# IoT devices

[!INCLUDE [header_file](../header.md)]

Create seamless conversational interfaces with all of your internet-accessible devices—from your connected television or fridge to devices in a connected power plant. LUIS is able to integrate up to 500 intents to translate commands into smart actions.

## Architecture

<svg class="architecture-diagram" aria-labelledby="iot-devices" height="473.058" viewbox="0 0 800.333 473.058"  xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g data-name="Layer 2">
        <g data-name="Layer 1">
            <image height="473" opacity=".25" style="mix-blend-mode:multiply" transform="translate(343.889)" width="161" xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKEAAAHZCAYAAADuV1uuAAAACXBIWXMAAAsSAAALEgHS3X78AAAIJElEQVR4Xu3Xsapd1RaA4ZXEIJIg2IhIrLSysLOQqK+gtdgF9D6Az5A6jfoUvkCqgza+gZ2ilZ0QC8HgPXeO7HXUJCfZRwz3b74NX7E3a83d/Iw553Z6erqdZ30uwbP0xNaeEN/l3ZXlOfiXpqOzph6L8bzJNy9cXZ5fXliu7a7DP3TWznQ0PU1X09dDk/HRCK/sD88CLy0vL68uN3avwQWdNTP9TEfT03Q1fT0I8aEIt4cDfHF5ZXl9eWt5e3lnubm8Cxc0vUw30890ND1NV9PXQyGeRTh79YzK6/uDby7vLR8sHy+3lk+WT5f/wBHTyfQy3Uw/09H0NF1NX9PZ9HZ57+/Pi8jUOSPzjeX95aPls+X2cmf5fPkSLmh6mW6mn+loepqupq/pbHp7cFHZtr+24jk8zt49o/PD/cVZ6Kvl7nKyfL18A0dMJyfboZvpZzqanqar6Ws6m96ubH+LcK7Rc4uZQ+Ts4TNCb+8LfLt8t/yw/Lj8BEdMJ9PLdDP9TEfT03Q1fU1n09t091iEN7bDYfLWdhild/eFfl5+We4tv8IR08n0Mt1MP9PR9DRdTV/T2bkRzmFxrtZzq5lD5YzQk+X7fcHflt+X+3DEdDK9TDfTz8l26Gm6urkdOpvenhjhXK/nhvPFdtjbZ7Te2xf+Y/kvHDGdTC/TzfQzHU1P09X0deEI54Yzh8zZ42fE3t//4BSOmE6ml+lm+pmOpicR8n8jQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCciIkJ0JyIiQnQnIiJCdCcs8swi+Wr5cfl3vL78sf+x/A00wn08t0M/1MR9PThSO8uXyyfL6cLN8vvyy/7QvfhyOmk+llupl+TrZDT9PVze0pEV5bbizvLLeWO8vd5bvl533BKftXOGI6mV6mm+lnOpqepqvpazqb3s6N8NXl7eXj5fby1fLtvtAP22G0/gRHTCfTy3Qz/UxH09N0NX1NZ49FeGV5YXl5eWv5cPlsO4zQWWBKPtkOe/s3cMR0crIdupl+pqPpabqavqaz6e3K9rcILy/PLy8tbyzvLx/tL07Bd/aFvoQLml6mm+lnOpqepqvpazqb3qa7S9vp6dyoH3y5uh0Oi68sby7vLR9shxF6azscKj/dDjcceJrpZHqZbqaf6Wh6mq6mr+lserv8oL89wrMteep8cX/w9e0wOmcPn8Pk3GrehQuaXqab6Wc6mp6mq+lrOnuwFf8Z4TkhTqkzMmfvnkPkjd1rcEFnzUw/09H0NF09FOB5EZ6FeHV/eA6P13bX4R86a2c6mp6mq7PLyOMRPhLj5d288Bz8S9PRWVOXHmvu0R/OmYzwTDyptf8BoQcTpLwpGOIAAAAASUVORK5CYII="/>
            <path fill="#f4f4f4" d="M348.96 5.372h147.929V465H348.96z"/>
            <image height="309" opacity=".25" style="mix-blend-mode:multiply" transform="translate(0 164.058)" width="163" xlink:href="data:image/png;base64,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"/>
            <path fill="#f4f4f4" d="M5.34 168.836h149.714v296.003H5.34z"/>
            <text fill="#525252" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(25.953 268.051)">
                Cus<tspan letter-spacing="-.008em" x="22.531" y="0">t</tspan><tspan x="27.166" y="0">omer mobile</tspan>
            </text>
            <path d="M50.97 187.629h21.439a3.695 3.695 0 013.695 3.695v45.592a3.693 3.693 0 01-3.693 3.693H50.968a3.693 3.693 0 01-3.693-3.693v-45.592a3.695 3.695 0 013.695-3.695z" fill="#454c50"/>
            <path fill="#505659" d="M58.491 235.539h6.397v2.134h-6.397z"/>
            <circle cx="61.691" cy="191.631" fill="#505659" r="1.067"/>
            <path fill="#fff" d="M49.366 195.638H74.01V232.6H49.366z"/>
            <path fill="#e6625c" d="M51.262 197.532h20.854v3.188H51.262z"/>
            <path fill="#e8e8e8" d="M51.262 227.362h20.854v1.049H51.262zM51.262 229.656h20.854v1.049H51.262z"/>
            <path fill="#b3e9ff" d="M51.262 209.779h20.854v16.337H51.262z"/>
            <path fill="#d4d6d8" d="M51.262 201.964h20.854v6.57H51.262z"/>
            <path d="M85.539 187.629h21.439a3.695 3.695 0 013.695 3.695v45.592a3.693 3.693 0 01-3.693 3.693H85.538a3.694 3.694 0 01-3.694-3.694v-45.591a3.695 3.695 0 013.695-3.695z" fill="#454c50"/>
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
                <path d="M145.205 226.532h219.747v1.5H145.205z"/>
                <path d="M363.42 222.046l9.067 5.236-9.067 5.235v-10.471zM146.738 222.046l-9.067 5.236 9.067 5.235v-10.471z"/>
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
                    4
                </text>
            </a>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(731.844 428.704)">
                IoT devices
            </text>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(555.812 428.704)">
                Thi<tspan letter-spacing="-.013em" x="18.648" y="0">r</tspan><tspan x="23.331" y="0">d </tspan><tspan letter-spacing="-.013em" x="35.41" y="0">p</tspan><tspan x="43.456" y="0">a</tspan><tspan letter-spacing=".029em" x="50.579" y="0">r</tspan><tspan x="55.85" y="0">ty</tspan>
            </text>
            <g fill="#969696">
                <path d="M651.221 387.532h58.73v1.5h-58.73z"/>
                <path d="M708.419 383.046l9.067 5.236-9.067 5.235v-10.471zM652.753 383.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="679.889" cy="388" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(675.842 393.703)">
                    3
                </text>
            </a>
            <g fill="#969696">
                <path d="M481.221 387.532h58.73v1.5h-58.73z"/>
                <path d="M538.419 383.046l9.067 5.236-9.067 5.235v-10.471zM482.753 383.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="509.889" cy="388" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(505.842 393.703)">
                    5
                </text>
            </a>
            <g fill="#969696">
                <path d="M481.221 226.532h58.73v1.5h-58.73z"/>
                <path d="M538.419 222.046l9.067 5.236-9.067 5.235v-10.471zM482.753 222.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="509.889" cy="227" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(505.842 232.703)">
                    2
                </text>
            </a>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(368.948 267.704)">
                Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">Bot Se</tspan><tspan letter-spacing=".04em" x="78.969" y="0">r</tspan><tspan x="84.396" y="0">vice</tspan>
            </text>
            <g>
                <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(366.689 428.704)">
                    Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">App Se</tspan><tspan letter-spacing=".04em" x="83.487" y="0">r</tspan><tspan x="88.915" y="0">vice</tspan>
                </text>
                <path d="M416.957 400.969h-16.6v-16.5h3.4a8.808 8.808 0 01-.6-3.3v-.2h-6.3v23.5h23.6v-14h-3.5zM440.357 384.469h3v16.6h-16.6v-10.5h-3.5v13.9h23.6v-23.5h-7.4a7.045 7.045 0 01.9 3.3zM400.357 374.469v-16.5h16.6v9.6a9.278 9.278 0 013.5-1.6v-11.5h-23.6v23.5h6.8a9.49 9.49 0 012.2-3.4l-5.5-.1zM426.757 365.569v-7.6h16.6v16.6h-7.3a12.127 12.127 0 01.5 3.4v.1h10.3v-23.6h-23.6v10.9c.3 0 .5-.1.8-.1a24.77 24.77 0 012.7.3z" fill="#a0a1a2"/>
                <path d="M437.657 384.169a3.691 3.691 0 00-3.7-3.7h-.5a10.871 10.871 0 00.4-2.6 9.841 9.841 0 00-19.2-3.1 7.8 7.8 0 00-2.2-.4 6.8 6.8 0 000 13.6h21.8a3.8 3.8 0 003.4-3.8" fill="#59b4d9"/>
                <path d="M416.057 387.969a6.8 6.8 0 013.3-11.4 5.525 5.525 0 012.2-.1 9.919 9.919 0 015.5-8 9.427 9.427 0 00-3-.5 9.787 9.787 0 00-9.3 6.8 7.8 7.8 0 00-2.2-.4 6.8 6.8 0 000 13.6h3.5z" fill="#fff" opacity=".2" style="isolation:isolate"/>
            </g>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(364.809 107.704)">
                Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">App Insights</tspan>
            </text>
            <g>
                <path d="M438.112 49.041v-.3c0-7.7-6.6-14.1-14.7-14.2-.2-.3-4.8.1-4.8.1-7.3.9-13 7-13 14.1 0 .2-.8 5.8 4.9 10.5 2.6 2.3 5.3 8.5 5.7 10.3l.3.6h10.6l.3-.6c.4-1.8 3.2-8 5.7-10.2 5.7-4.8 5-10.1 5-10.3z" fill="#68217a"/>
                <path fill="#7a7a7a" d="M416.712 73.741h10.6v3.4h-10.6zM420.012 84.341h3.9l3.3-3.5h-10.5l3.3 3.5z"/>
                <path d="M424.612 69.641h-2v-12.7h-1.7v12.6h-2v-12.6h-1.7a3.757 3.757 0 01-3.7-3.7 3.7 3.7 0 017.4 0v1.7h1.7v-1.7a3.7 3.7 0 113.7 3.7h-1.7zm-7.4-18.1a1.685 1.685 0 00-1.7 1.7 1.752 1.752 0 001.7 1.7h1.7v-1.7a1.828 1.828 0 00-1.7-1.7zm9.1 0a1.752 1.752 0 00-1.7 1.7v1.7h1.7a1.752 1.752 0 001.7-1.7 1.685 1.685 0 00-1.7-1.7z" fill="#fff" opacity=".65"/>
                <path d="M423.412 34.541c-.2-.3-4.8.1-4.8.1-7.3.9-13 7-13 14.1a11.913 11.913 0 003.9 9.6l21.6-21.6a14.687 14.687 0 00-7.7-2.2z" fill="#fff" opacity=".15"/>
            </g>
            <g fill="#3f92cf">
                <path d="M423.088 195.879a22 22 0 11-22 22 22.025 22.025 0 0122-22m0-3a25 25 0 1025 25 25 25 0 00-25-25z"/>
                <circle cx="419.221" cy="217.879" r="2.25"/>
                <circle cx="426.846" cy="217.879" r="2.25"/>
                <path d="M419.221 206.86l-2.121-2.121-12.2 12.2a1.328 1.328 0 000 1.879l1.18 1.182 11.02 11.02 2.121-2.121L408.2 217.88zM426.564 228.9l2.121 2.121 12.2-12.2a1.328 1.328 0 000-1.879l-1.182-1.182-11.018-11.019-2.121 2.121 11.019 11.019z"/>
            </g>
            <g>
                <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(564.843 265.704)">
                    Language<tspan x="-15.555" y="16.8">Unde</tspan><tspan letter-spacing=".007em" x="17.551" y="16.8">r</tspan><tspan x="22.514" y="16.8">standing</tspan>
                </text>
                <g fill="#0078d7">
                    <path d="M582.707 233.618a5.931 5.931 0 01-1-3.831V223.1c0-3.5-1.236-5.69-3.7-6.5l-.133-.051v-.349l.133-.051c2.452-.919 3.7-3.157 3.7-6.692v-6.743c0-3.075 1.43-4.751 4.1-4.832V194.3c-2.861.031-5.047.725-6.477 2.1-1.461 1.379-2.186 3.453-2.186 6.334v6.692c0 3.32-1.379 5.129-4.015 5.21v3.586c2.7.082 4.015 1.675 4.015 4.9v7.121c0 2.993.674 5.047 2.1 6.283 1.267 1.216 3.5 1.89 6.477 1.91v-.031h.112v-3.5a4.2 4.2 0 01-3.126-1.287zM616.584 209.313v-6.692c0-2.912-.7-4.986-2.186-6.365-1.461-1.349-3.617-2.074-6.477-2.1v3.617c2.666.082 4.1 1.757 4.1 4.832v6.773c0 3.555 1.216 5.772 3.7 6.692l.133.051v.347l-.133.051c-2.452.807-3.7 2.993-3.7 6.5v6.692a5.78 5.78 0 01-1 3.831 3.809 3.809 0 01-3.024 1.267v3.484c2.881-.031 5.047-.674 6.477-1.91 1.4-1.3 2.1-3.422 2.1-6.283v-7.151c0-3.126 1.379-4.832 4.015-4.9V214.5c-2.656-.058-4.005-1.815-4.005-5.187z"/>
                </g>
            </g>
            <g>
                <path fill="#7fba00" d="M760.24 368.754l1.68-1.44 6.255 7.298-1.68 1.44zM751.429 382.096l13.658-1.954.313 2.19-13.658 1.954zM764.036 395.843l4.13-10.03 2.047.842-4.131 10.031zM774.11 386.799l1.91-1.115 7.528 12.906-1.912 1.115z"/>
                <path fill="#3c9be4" d="M779.368 361.522h8.853v8.853h2.213v-11.066h-11.066v2.213zM752.809 405.787h-8.853v-8.853h-2.213V408h11.066v-2.213z"/>
                <path d="M771.622 372.588a7.746 7.746 0 107.746 7.746 7.746 7.746 0 00-7.746-7.746zM758.342 359.309a5.533 5.533 0 105.533 5.533 5.532 5.532 0 00-5.533-5.533zM784.9 396.934a5.533 5.533 0 105.533 5.533 5.532 5.532 0 00-5.533-5.533zM748.383 379.228a4.426 4.426 0 104.426 4.426 4.425 4.425 0 00-4.426-4.426zM763.875 394.721a4.426 4.426 0 104.426 4.426 4.425 4.425 0 00-4.426-4.426z" fill="#0072c6"/>
            </g>
            <g fill="#0072c6">
                <path d="M562.111 363.178l1.237 1.966a1.36 1.36 0 01.03 1.655s.005 0 0 .014a8.223 8.223 0 00-.625 1.077 1.326 1.326 0 01-1.37.791L559 368.6a.914.914 0 00-.883.678l-.247 1.952a.921.921 0 00.674.878l2.27.515a1.373 1.373 0 011.17 1.062 9.182 9.182 0 00.4 1.456 1.353 1.353 0 01-.459 1.377l-1.744 1.63a.925.925 0 00-.142 1.109l1.2 1.554a.919.919 0 001.1.145l1.971-1.239a1.368 1.368 0 011.63-.04 9.022 9.022 0 001.1.628 1.323 1.323 0 01.807 1.378l-.078 2.388a.906.906 0 00.676.88l1.948.258a.941.941 0 00.887-.681l.509-2.267c.228-.862.663-1.108 1.158-1.192h.021a9.82 9.82 0 001.147-.314h.024a1.325 1.325 0 011.542.4l1.64 1.748a.915.915 0 001.1.141l1.557-1.2a.933.933 0 00.146-1.1l-1.235-1.97a1.349 1.349 0 01-.027-1.656c.01-.018.005-.029.017-.046a9.4 9.4 0 00.567-.985c.006-.016.02-.022.029-.038a1.332 1.332 0 011.381-.81l2.391.08a.909.909 0 00.875-.682l.249-1.952a.913.913 0 00-.675-.876l-2.267-.523c-.857-.221-1.111-.653-1.19-1.151a.231.231 0 00-.021-.055 10.049 10.049 0 00-.3-1.07.132.132 0 000-.06 1.325 1.325 0 01.4-1.549l1.74-1.636a.9.9 0 00.134-1.106L581 363.1a.908.908 0 00-1.1-.141l-1.977 1.238a1.358 1.358 0 01-1.652.025.307.307 0 00-.047-.025 9.192 9.192 0 00-.987-.561.152.152 0 00-.038-.027 1.346 1.346 0 01-.8-1.385l.074-2.384a.931.931 0 00-.676-.887l-1.949-.243a.918.918 0 00-.88.679l-.517 2.266c-.229.859-.662 1.11-1.156 1.191a.032.032 0 00-.028.009 8.728 8.728 0 00-1.14.308.119.119 0 00-.027 0 1.333 1.333 0 01-1.549-.406l-1.628-1.743a.922.922 0 00-1.107-.141l-1.553 1.2a.936.936 0 00-.152 1.105zm12.847 5.815a4.862 4.862 0 11-6.82-.877 4.855 4.855 0 016.821.876zM591.72 370.78l1.634 2.6a1.8 1.8 0 01.039 2.187s.007.006 0 .019a10.863 10.863 0 00-.826 1.422 1.751 1.751 0 01-1.81 1.045l-3.15-.1a1.207 1.207 0 00-1.166.9l-.327 2.578a1.216 1.216 0 00.89 1.16l3 .681a1.813 1.813 0 011.546 1.4 12.13 12.13 0 00.523 1.924 1.787 1.787 0 01-.606 1.82l-2.3 2.153a1.222 1.222 0 00-.188 1.465l1.59 2.053a1.214 1.214 0 001.453.191l2.6-1.637a1.808 1.808 0 012.154-.053 11.919 11.919 0 001.453.829 1.748 1.748 0 011.065 1.821l-.1 3.155a1.2 1.2 0 00.893 1.162l2.574.34a1.243 1.243 0 001.172-.9l.672-3c.3-1.139.876-1.464 1.529-1.575.008 0 .013 0 .028-.006a12.973 12.973 0 001.516-.415h.032a1.75 1.75 0 012.037.527l2.166 2.309a1.208 1.208 0 001.448.186l2.057-1.586a1.233 1.233 0 00.193-1.459l-1.631-2.6a1.783 1.783 0 01-.035-2.188c.013-.024.007-.038.023-.061a12.421 12.421 0 00.749-1.3c.007-.021.026-.029.038-.05a1.759 1.759 0 011.825-1.071l3.158.106a1.2 1.2 0 001.156-.9l.329-2.579a1.206 1.206 0 00-.891-1.158l-2.994-.691c-1.132-.293-1.468-.863-1.572-1.521a.3.3 0 00-.028-.073 13.275 13.275 0 00-.4-1.413.174.174 0 000-.08 1.75 1.75 0 01.532-2.046l2.3-2.161a1.189 1.189 0 00.177-1.461l-1.575-2.053a1.2 1.2 0 00-1.452-.186l-2.612 1.635a1.794 1.794 0 01-2.182.033.406.406 0 00-.062-.033 12.144 12.144 0 00-1.3-.741.2.2 0 00-.051-.036 1.778 1.778 0 01-1.063-1.829l.1-3.15a1.229 1.229 0 00-.893-1.172l-2.575-.322a1.213 1.213 0 00-1.162.9l-.683 2.993c-.3 1.135-.875 1.466-1.527 1.573a.043.043 0 00-.036.012 11.53 11.53 0 00-1.506.407.157.157 0 00-.035 0 1.761 1.761 0 01-2.046-.536l-2.151-2.3a1.218 1.218 0 00-1.462-.186l-2.052 1.588a1.237 1.237 0 00-.202 1.454zm16.973 7.682a6.423 6.423 0 11-9.01-1.159 6.415 6.415 0 019.01 1.158z"/>
            </g>
        </g>
    </g>
</svg>

<div class="architecture-tooltip-content" id="architecture-tooltip-1">
<p>User logs into Skype and accesses the IoT bot</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-2">
<p>Using voice, the user asks the bot to turn on the lights via the IoT device</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-3">
<p>The request is relayed to a third-party service that has access to the IoT device network</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-4">
<p>The results of the command are returned to the user</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-5">
<p>Application Insights gathers runtime telemetry to help development with bot performance and usage</p>
</div>

## Data Flow

1. User logs into Skype and accesses the IoT bot
1. Using voice, the user asks the bot to turn on the lights via the IoT device
1. The request is relayed to a third-party service that has access to the IoT device network
1. The results of the command are returned to the user
1. Application Insights gathers runtime telemetry to help development with bot performance and usage


[!INCLUDE [js_include_file](../../_js/index.md)]
