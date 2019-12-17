---
title: Enterprise Productivity Chatbot
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Azure Bot Service can be easily combined with Language Understanding to build powerful enterprise productivity bots, allowing organizations to streamline common work activities by integrating external systems, such as Office 365 calendar, customer cases stored in Dynamics CRM and much more.
ms.custom: acom-architecture, bot service, luis, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/enterprise-productivity-chatbot/'
---
# Enterprise Productivity Chatbot

[!INCLUDE [header_file](../header.md)]

Azure Bot Service can be easily combined with Language Understanding to build powerful enterprise productivity bots, allowing organizations to streamline common work activities by integrating external systems, such as Office 365 calendar, customer cases stored in Dynamics CRM and much more.

## Architecture

<svg class="architecture-diagram" aria-labelledby="enterprise-productivity-chatbot" height="473" viewbox="0 0 1193 473"  xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g data-name="Layer 2">
        <g data-name="Layer 1">
            <image height="473" opacity=".25" style="mix-blend-mode:multiply" transform="translate(516)" width="334" xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAU4AAAHZCAYAAADpMNKSAAAACXBIWXMAAAsSAAALEgHS3X78AAAJpElEQVR4Xu3Zsapd1RaA4ZXEIGIQbEQkVlpZ2FlI1FfQWuwCeh/AZ0idRn0KXyDVQRvfwE7Ryk6IhWDwnjtH9jpek5xc/OFWK9+Gr9ibtebufsacczs/P98usz5XAJ5lT+3jU4J5dXdteQ7gGTPtu+jgEwG9bMKcF64vzy8vLC/ubgAc3EXvpn3TwGnhNPGRCfTxcF7bH54FXl5eWV5bbu5eBzioi85N86Z908Bp4TTxYTwfCef2aDRfWl5d3ljeXt5Z3l1uLe8BHNQ0blo3zZv2TQOnhdPER+J5Ec7Zx89IemN/8K3l/eXD5ZPl9vLp8tnyL4CDmbZN46Z107xp3zRwWjhNnDZOI6/uzfzrMmiKOqPpm8sHy8fL58ud5e7yxfIVwEFN46Z107xp3zRwWjhNnDZOIx9eFm3bf7fpcxg6+/oZUT/aX5yFvl7uLWfLN8u3AAczbTvbTq2b5k37poHTwmnitHEaeW37Wzjn+n1ukuZQdPb3M6re2Rf4bvl++XH5afkZ4GCmbdO4ad00b9o3DZwWThOnjdPIaeUT4by5nQ5Hb2+nkfXevtAvy6/L/eU3gIOZtk3jpnXTvGnfNHBaOE2cNl4azjn8nCv5uVmaQ9IZVc+WH/YFf1/+WB4AHMy0bRo3rZvmnW2nBk4Lb22nNk4jnxrOuZafW6Yvt9O+f0bY+/vCfy7/BjiYads0blo3zZv2TQOnhdPEfxzOuWWaQ9PZ/88o+2D/g3OAg5m2TeOmddO8ad80UDgBnkI4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyASToBIOAEi4QSIhBMgEk6ASDgBIuEEiIQTIBJOgEg4ASLhBIiEEyD6v4Xzy+Wb5afl/vLH8uf+BwBHMm2bxk3rpnnTvmngPw7nreXT5YvlbPlh+XX5fV/4AcDBTNumcdO6ad7ZdmrgtPDW9j/C+eJyc3l3ub3cXe4t3y+/7AtOjX8DOJhp2zRuWjfNm/ZNA6eF08Rp4zTy0nC+tryzfLLcWb5evtsX+nE7jbA/AxzMtG0aN62b5k37poHTwmnitPGJcF5bXlheWd5ePlo+306j6iww9T3bTvv+bwEOZtp2tp1aN82b9k0Dp4XTxGnjNPLa9rdwXl2eX15e3lw+WD7eX5zq3t0X+grgoKZx07pp3rRvGjgtnCZOG6eR08or2/n53MQ//HJ9Ox1+vrq8tby/fLidRtXb2+mQ9LPtdMsEcCTTtmnctG6aN+2bBk4Lp4nTxmnk1YfN3MN5sV2for60P/jGdhpRZ38/h6Nzs/QewEFN46Z107xp3zRwWjhNnDY+3Kb/Fc5L4jl1ndF09vVzKHpz9zrAQV10bpo37ZsGTgsfieZl4byI5/X94TkMfXF3A+DgLno37ZsGTgsvLoSeDOdjAb26mxeeA3jGTPsuOnjliU4+/sMlEyjAM+lpffwPFlF3RfqSVvAAAAAASUVORK5CYII="/>
            <path fill="#f4f4f4" d="M521.071 5.372H842V465H521.071z"/>
            <image height="151" opacity=".25" style="mix-blend-mode:multiply" transform="translate(859 161)" width="334" xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAU4AAACXCAYAAAB6FbI6AAAACXBIWXMAAAsSAAALEgHS3X78AAAFcUlEQVR4Xu3ZsYpdVRiG4Z0Zg4SEgI2IxEori3QWIdFb0FrsAuoF5BpSp1GvIjeQatAmd5BOiZWdkBQBg47/N2cfdTIz4gdWO8+BpziHvdfpXv611nJ8fLycZz6XAF5nF/bxgmAerA7HGwCvmbRv38EzAT1vwswLl8eb48q4uroGsHH73qV9aWBamCaemkBfDefh+nAWeGu8Pd4dN1bvAWzUvnNpXtqXBqaFaeJJPE+FczkdzevjnfH+uDk+GrfG7XEHYKPSuLQuzUv70sC0ME08Fc99OLOPz0h6bX3ww/Hx+HR8Me6OL8dX42uAjUnb0ri0Ls1L+9LAtDBNTBvTyIO1mX9dBqWoGU0/GJ+Mz8e9cX88GN+M7wA2Ko1L69K8tC8NTAvTxLQxjTy5LFqWv7fpOQzNvj4j6mfri1no4Xg0jsb34weAjUnbjpZd69K8tC8NTAvTxLQxjTxc/hHOXL/nJimHotnfZ1S9vy7weDwZP42n42eAjUnb0ri0Ls1L+9LAtDBNTBvTyLTyTDhvLLvD0bvLbmR9tC70y/h1PBvPATYmbUvj0ro0L+1LA9PCNDFtPDecOfzMlXxulnJImlH1aPy4Lvhi/DZeAmxM2pbGpXVp3tGya2BaeHvZtTGNvDCcuZbPLdO3y27fnxH22brw7+MPgI1J29K4tC7NS/vSwLQwTfzP4cwtUw5Ns//PKPty/YNjgI1J29K4tC7NS/vSQOEEuIBwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdASTgBSsIJUBJOgJJwApSEE6AknAAl4QQoCSdA6X8L57fj+/F0PBu/jd/XPwDYkrQtjUvr0ry0Lw38z+G8Pb4c34yj8eP4dbxYF34JsDFpWxqX1qV5R8uugWnh7eVfwnl13Bi3xt3xYDwaT8Yv64Kp8XOAjUnb0ri0Ls1L+9LAtDBNTBvTyHPD+e74aHwx7o+H4/G60E/LboT9GWBj0rY0Lq1L89K+NDAtTBPTxjPhPBxXxtvj5vhs3Ft2o2oWSH2Plt2+/weAjUnbjpZd69K8tC8NTAvTxLQxjTxc/hHOg/HmeGt8MD4Zn68vproP1oW+A9ioNC6tS/PSvjQwLUwT08Y0Mq28tBwf5yb+5MvlZXf4+c74cHw8Pl12o+rdZXdI+tWyu2UC2JK0LY1L69K8tC8NTAvTxLQxjTw4aeYazv12PUW9vj74/rIbUbO/z+FobpbuAGxUGpfWpXlpXxqYFqaJaePJNv2vcJ4Tz9Q1o2n29TkUvbF6D2Cj9p1L89K+NDAtPBXN88K5j+fl9eEchl5dXQPYuH3v0r40MC3cXwidDecrAT1Y5YU3AF4zad++g5fOdPLVH86ZQAFeSxf18U+zJPCdvgWTzwAAAABJRU5ErkJggg=="/>
            <path fill="#f4f4f4" d="M864 166h321v138H864z"/>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(356.434 267.704)">
                Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">Acti</tspan><tspan letter-spacing="-.006em" x="63.034" y="0">v</tspan><tspan x="69.658" y="0">e Di</tspan><tspan letter-spacing="-.013em" x="94.021" y="0">r</tspan><tspan x="98.704" y="0">ec</tspan><tspan letter-spacing="-.008em" x="112.492" y="0">t</tspan><tspan x="117.127" y="0">o</tspan><tspan letter-spacing=".04em" x="125.33" y="0">r</tspan><tspan x="130.758" y="0">y</tspan>
            </text>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(541.059 267.704)">
                Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">Bot Se</tspan><tspan letter-spacing=".04em" x="78.969" y="0">r</tspan><tspan x="84.396" y="0">vice</tspan>
            </text>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(560.248 428.704)">
                QnA Ma<tspan letter-spacing="-.02em" x="51.037" y="0">k</tspan><tspan x="57.716" y="0">er</tspan>
            </text>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(734.954 428.704)">
                Language<tspan x="-15.555" y="16.8">Unde</tspan><tspan letter-spacing=".007em" x="17.551" y="16.8">r</tspan><tspan x="22.514" y="16.8">standing</tspan>
            </text>
            <image height="309" opacity=".25" style="mix-blend-mode:multiply" transform="translate(0 164)" width="163" xlink:href="data:image/png;base64,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"/>
            <path fill="#f4f4f4" d="M5.452 168.836h149.714v296.003H5.452z"/>
            <text fill="#525252" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(26.064 268.051)">
                Cus<tspan letter-spacing="-.008em" x="22.531" y="0">t</tspan><tspan x="27.166" y="0">omer mobile</tspan>
            </text>
            <path d="M51.081 187.629H72.52a3.695 3.695 0 013.695 3.695v45.592a3.693 3.693 0 01-3.693 3.693H51.079a3.693 3.693 0 01-3.693-3.693v-45.592a3.695 3.695 0 013.695-3.695z" fill="#454c50"/>
            <path fill="#505659" d="M58.602 235.539h6.397v2.134h-6.397z"/>
            <circle cx="61.802" cy="191.631" fill="#505659" r="1.067"/>
            <path fill="#fff" d="M49.477 195.638h24.644V232.6H49.477z"/>
            <path fill="#e6625c" d="M51.373 197.532h20.854v3.188H51.373z"/>
            <path fill="#e8e8e8" d="M51.373 227.362h20.854v1.049H51.373zM51.373 229.656h20.854v1.049H51.373z"/>
            <path fill="#b3e9ff" d="M51.373 209.779h20.854v16.337H51.373z"/>
            <path fill="#d4d6d8" d="M51.373 201.964h20.854v6.57H51.373z"/>
            <path d="M85.65 187.629h21.439a3.695 3.695 0 013.695 3.695v45.592a3.693 3.693 0 01-3.693 3.693H85.648a3.693 3.693 0 01-3.693-3.693v-45.592a3.695 3.695 0 013.695-3.695z" fill="#454c50"/>
            <path fill="#505659" d="M93.171 235.539h6.397v2.134h-6.397z"/>
            <circle cx="96.371" cy="191.631" fill="#505659" r="1.067"/>
            <path fill="#fff" d="M84.046 195.638h24.644V232.6H84.046z"/>
            <rect fill="#85c808" height="11.05" rx=".731" ry=".731" width="12.212" x="90.764" y="211.378"/>
            <path fill="#85c808" d="M90.752 211.378h12.235v5.036H90.752zM106.242 218.111a1.3 1.3 0 01-1.3 1.3 1.3 1.3 0 01-1.3-1.3v-5.847a1.3 1.3 0 011.3-1.3 1.3 1.3 0 011.3 1.3zM90.1 218.111a1.3 1.3 0 01-1.3 1.3 1.3 1.3 0 01-1.3-1.3v-5.847a1.3 1.3 0 011.3-1.3 1.3 1.3 0 011.3 1.3zM90.8 210.658s.135-5.178 6.067-5.16c5.876.018 6.067 5.16 6.067 5.16z"/>
            <circle cx="94.207" cy="208.015" fill="#fff" r=".73"/>
            <circle cx="99.533" cy="208.015" fill="#fff" r=".73"/>
            <path d="M94.006 206.194c.021.03.088.021.148-.022.06-.042.091-.1.07-.132l-1.133-1.6c-.022-.031-.088-.021-.148.022s-.092.1-.07.133zM99.733 206.194c-.021.03-.087.021-.148-.022-.06-.042-.091-.1-.07-.132l1.133-1.6c.022-.031.088-.021.148.022s.092.1.07.133zM100.682 225.679a1.3 1.3 0 01-1.3 1.3 1.3 1.3 0 01-1.3-1.3v-5.848a1.3 1.3 0 011.3-1.3 1.3 1.3 0 011.3 1.3zM95.66 225.679a1.3 1.3 0 01-1.3 1.3 1.3 1.3 0 01-1.3-1.3v-5.848a1.3 1.3 0 011.3-1.3 1.3 1.3 0 011.3 1.3z" fill="#85c808"/>
            <path d="M87.64 394.562h-13.6c1.634 5.768-.561 6.6-10.175 6.6v3.02h32.696v-3.02c-9.614 0-10.557-.824-8.921-6.6" fill="#7a7a7a"/>
            <path d="M102.194 358.028H57.932a2.828 2.828 0 00-2.717 2.847v30.866a2.812 2.812 0 002.717 2.823h44.262a3.09 3.09 0 003.021-2.823v-30.866a3.1 3.1 0 00-3.021-2.847" fill="#a0a1a2"/>
            <path d="M102.225 358.031H57.931a2.827 2.827 0 00-2.717 2.847v30.865a2.812 2.812 0 002.717 2.824h1.053z" fill="#fff" opacity=".2" style="isolation:isolate"/>
            <path fill="#59b4d9" d="M101.312 361.876v28.841H59.004v-28.841h42.308z"/>
            <path fill="#59b4d9" d="M59.004 390.717h.058v-28.84l38.68-.058h.002l-38.74.058v28.84z"/>
            <path fill="#a0a1a2" d="M63.869 401.156h32.692v3.021H63.869z"/>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(14.438 425.438)">
                Consume, PC, Mobile<tspan x="47.482" y="16.8">Cloud</tspan>
            </text>
            <g fill="#969696">
                <path d="M145.317 226.532h219.746v1.5H145.317z"/>
                <path d="M363.531 222.046l9.068 5.236-9.068 5.235v-10.471zM146.849 222.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="251.92" cy="227.095" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(247.873 232.798)">
                    1
                </text>
            </a>
            <path fill="#969696" d="M313.832 273.75H194.25v-46.388h1.5v44.888h116.582v-44.809h1.5v46.309z"/>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="252" cy="273" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(247.953 278.703)">
                    5
                </text>
            </a>
            <g>
                <path d="M425.2 243.47a4.575 4.575 0 01-3.261-1.352l-20.388-20.388a4.61 4.61 0 010-6.521l20.389-20.388a4.609 4.609 0 016.522 0l20.386 20.388a4.609 4.609 0 010 6.523l-20.385 20.386a4.578 4.578 0 01-3.261 1.352" fill="#59b4d9"/>
                <path d="M438.814 214.562a3.9 3.9 0 00-3.265 6.052l-7.744 7.744a4.55 4.55 0 00-.656-.373v-19.757a3.909 3.909 0 10-3.9 0v19.756a4.48 4.48 0 00-.632.353l-7.753-7.753a4.016 4.016 0 10-2.006 1.566l8.15 8.15a4.551 4.551 0 108.387.032l8.173-8.172a3.867 3.867 0 001.241.22 3.909 3.909 0 000-7.818z" fill="#fff"/>
                <path fill="#fff" opacity=".5" style="isolation:isolate" d="M424.266 205.62l1.784-1.785 14.622 14.618-1.784 1.784z"/>
                <path fill="#fff" opacity=".5" style="isolation:isolate" d="M409.745 218.467l14.62-14.621 1.786 1.785-14.621 14.62z"/>
                <path d="M427.865 232.083a2.709 2.709 0 11-2.71-2.709 2.71 2.71 0 012.71 2.709M427.374 204.858a2.174 2.174 0 11-2.174-2.174 2.174 2.174 0 012.174 2.174M413.763 218.47a2.174 2.174 0 11-2.174-2.174 2.175 2.175 0 012.174 2.174M440.988 218.47a2.174 2.174 0 11-2.175-2.174 2.175 2.175 0 012.175 2.174" fill="#b8d432"/>
                <path d="M428.462 194.821a4.608 4.608 0 00-6.521 0l-20.389 20.388a4.608 4.608 0 000 6.521l11.543 11.544 21.715-32.106z" fill="#fff" opacity=".1" style="isolation:isolate"/>
            </g>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(920.326 267.704)">
                Graph
            </text>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(1079.148 267.704)">
                Office 365
            </text>
            <g>
                <path d="M939.2 243.47a4.575 4.575 0 01-3.261-1.352l-20.388-20.388a4.61 4.61 0 010-6.521l20.389-20.388a4.609 4.609 0 016.522 0l20.386 20.388a4.609 4.609 0 010 6.523l-20.385 20.386a4.578 4.578 0 01-3.261 1.352" fill="#59b4d9"/>
                <path d="M952.814 214.562a3.9 3.9 0 00-3.265 6.052l-7.744 7.744a4.55 4.55 0 00-.656-.373v-19.757a3.909 3.909 0 10-3.9 0v19.756a4.48 4.48 0 00-.632.353l-7.753-7.753a4.016 4.016 0 10-2.006 1.566l8.15 8.15a4.551 4.551 0 108.387.032l8.173-8.172a3.867 3.867 0 001.241.22 3.909 3.909 0 000-7.818z" fill="#fff"/>
                <path fill="#fff" opacity=".5" style="isolation:isolate" d="M938.267 205.62l1.784-1.784 14.622 14.618-1.784 1.785z"/>
                <path fill="#fff" opacity=".5" style="isolation:isolate" d="M923.745 218.467l14.62-14.62 1.785 1.784-14.62 14.62z"/>
                <path d="M941.865 232.083a2.709 2.709 0 11-2.71-2.709 2.71 2.71 0 012.71 2.709M941.374 204.858a2.174 2.174 0 11-2.174-2.174 2.174 2.174 0 012.174 2.174M927.763 218.47a2.174 2.174 0 11-2.174-2.174 2.175 2.175 0 012.174 2.174M954.988 218.47a2.174 2.174 0 11-2.175-2.174 2.175 2.175 0 012.175 2.174" fill="#b8d432"/>
                <path d="M942.462 194.821a4.608 4.608 0 00-6.521 0l-20.389 20.388a4.608 4.608 0 000 6.521l11.543 11.544 21.715-32.106z" fill="#fff" opacity=".1" style="isolation:isolate"/>
            </g>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(892.729 428.704)">
                Dynamics CRM
            </text>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(733.634 267.704)">
                Speech API
            </text>
            <g>
                <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(711.8 107.704)">
                    Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">App Se</tspan><tspan letter-spacing=".04em" x="83.487" y="0">r</tspan><tspan x="88.915" y="0">vice</tspan>
                </text>
                <path d="M762.068 79.969h-16.6v-16.5h3.4a8.808 8.808 0 01-.6-3.3v-.2h-6.3v23.5h23.6v-14h-3.5zM785.468 63.469h3v16.6h-16.6v-10.5h-3.5v13.9h23.6v-23.5h-7.4a7.045 7.045 0 01.9 3.3zM745.468 53.469v-16.5h16.6v9.6a9.278 9.278 0 013.5-1.6v-11.5h-23.6v23.5h6.8a9.49 9.49 0 012.2-3.4l-5.5-.1zM771.868 44.569v-7.6h16.6v16.6h-7.3a12.127 12.127 0 01.5 3.4v.1h10.3v-23.6h-23.6v10.9c.3 0 .5-.1.8-.1a24.77 24.77 0 012.7.3z" fill="#a0a1a2"/>
                <path d="M782.768 63.169a3.691 3.691 0 00-3.7-3.7h-.5a10.871 10.871 0 00.4-2.6 9.841 9.841 0 00-19.2-3.1 7.8 7.8 0 00-2.2-.4 6.8 6.8 0 000 13.6h21.8a3.8 3.8 0 003.4-3.8" fill="#59b4d9"/>
                <path d="M761.168 66.969a6.8 6.8 0 013.3-11.4 5.525 5.525 0 012.2-.1 9.919 9.919 0 015.5-8 9.427 9.427 0 00-3-.5 9.787 9.787 0 00-9.3 6.8 7.8 7.8 0 00-2.2-.4 6.8 6.8 0 000 13.6h3.5z" fill="#fff" opacity=".2" style="isolation:isolate"/>
            </g>
            <text fill="#5b5b5b" font-family="SegoeUI, Segoe UI" font-size="14" transform="translate(536.92 107.704)">
                Azu<tspan letter-spacing="-.013em" x="23.283" y="0">r</tspan><tspan x="27.966" y="0">e</tspan><tspan x="39.402" y="0">App Insights</tspan>
            </text>
            <g>
                <path d="M610.223 49.041v-.3c0-7.7-6.6-14.1-14.7-14.2-.2-.3-4.8.1-4.8.1-7.3.9-13 7-13 14.1 0 .2-.8 5.8 4.9 10.5 2.6 2.3 5.3 8.5 5.7 10.3l.3.6h10.6l.3-.6c.4-1.8 3.2-8 5.7-10.2 5.7-4.8 5-10.1 5-10.3z" fill="#68217a"/>
                <path fill="#7a7a7a" d="M588.823 73.741h10.6v3.4h-10.6zM592.123 84.341h3.9l3.3-3.5h-10.5l3.3 3.5z"/>
                <path d="M596.723 69.641h-2v-12.7h-1.7v12.6h-2v-12.6h-1.7a3.757 3.757 0 01-3.7-3.7 3.7 3.7 0 017.4 0v1.7h1.7v-1.7a3.7 3.7 0 113.7 3.7h-1.7zm-7.4-18.1a1.685 1.685 0 00-1.7 1.7 1.752 1.752 0 001.7 1.7h1.7v-1.7a1.828 1.828 0 00-1.7-1.7zm9.1 0a1.752 1.752 0 00-1.7 1.7v1.7h1.7a1.752 1.752 0 001.7-1.7 1.685 1.685 0 00-1.7-1.7z" fill="#fff" opacity=".65"/>
                <path d="M595.523 34.541c-.2-.3-4.8.1-4.8.1-7.3.9-13 7-13 14.1a11.913 11.913 0 003.9 9.6l21.6-21.6a14.687 14.687 0 00-7.7-2.2z" fill="#fff" opacity=".15"/>
            </g>
            <g fill="#969696">
                <path d="M477.332 226.532h58.73v1.5h-58.73z"/>
                <path d="M534.53 222.046l9.068 5.236-9.068 5.235v-10.471zM478.864 222.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <g fill="#969696">
                <path d="M824.332 226.532h58.73v1.5h-58.73z"/>
                <path d="M881.53 222.046l9.068 5.236-9.068 5.235v-10.471zM825.864 222.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <path d="M617.6 383.1l-7.1-3.073c-.255.019-.509.029-.769.029h-.275a15.084 15.084 0 00-14.645-12.189h-8.666a11.1 11.1 0 0110.9-11.17h12.689a11.1 11.1 0 0110.9 11.231v.9a11.334 11.334 0 01-4.961 9.405zm-22.787 12.19h-12.689c-.26 0-.514-.01-.769-.029l-7.1 3.073 1.93-4.87a11.332 11.332 0 01-4.962-9.405v-.9a11.1 11.1 0 0110.9-11.231h12.689a10.991 10.991 0 0110.465 8.127 11.484 11.484 0 01.435 3.1v.962a11.1 11.1 0 01-10.9 11.17zm25.692-15.873a15.451 15.451 0 004.184-10.591v-.9a15.16 15.16 0 00-14.957-15.293h-12.688a15.157 15.157 0 00-14.955 15.234 15.159 15.159 0 00-14.923 15.291v.9a15.451 15.451 0 004.184 10.591l-4.481 11.306 15.257-6.6h12.686a15.157 15.157 0 0014.953-15.216l15.22 6.587z" fill="#0063b1"/>
            <g>
                <g fill="#0078d7">
                    <path d="M752.818 396.618a5.931 5.931 0 01-1-3.831V386.1c0-3.5-1.236-5.69-3.7-6.5l-.133-.051v-.349l.133-.051c2.452-.919 3.7-3.157 3.7-6.692v-6.743c0-3.075 1.43-4.751 4.1-4.832V357.3c-2.861.031-5.047.725-6.477 2.1-1.461 1.379-2.186 3.453-2.186 6.334v6.692c0 3.32-1.379 5.129-4.015 5.21v3.586c2.7.082 4.015 1.675 4.015 4.9v7.121c0 2.993.674 5.047 2.1 6.283 1.267 1.216 3.5 1.89 6.477 1.91v-.031h.112v-3.5a4.2 4.2 0 01-3.126-1.287zM786.7 372.313v-6.692c0-2.912-.7-4.986-2.186-6.365-1.461-1.349-3.617-2.074-6.477-2.1v3.617c2.666.082 4.1 1.757 4.1 4.832v6.773c0 3.555 1.216 5.772 3.7 6.692l.133.051v.347l-.133.051c-2.452.807-3.7 2.993-3.7 6.5v6.692a5.78 5.78 0 01-1 3.831 3.809 3.809 0 01-3.037 1.258v3.484c2.881-.031 5.047-.674 6.477-1.91 1.4-1.3 2.1-3.422 2.1-6.283v-7.151c0-3.126 1.379-4.832 4.015-4.9v-3.54c-2.648-.058-3.992-1.815-3.992-5.187z"/>
                </g>
            </g>
            <g fill="#0063b1">
                <path d="M756.181 210.525a3.365 3.365 0 013.491 3.49 3.485 3.485 0 01-.968 2.532 3.653 3.653 0 01-5.056-.032 3.463 3.463 0 01-1-2.5 3.34 3.34 0 011.008-2.511 3.477 3.477 0 012.525-.979zm12.038 0a3.365 3.365 0 013.491 3.49 3.485 3.485 0 01-.968 2.532 3.653 3.653 0 01-5.056-.032 3.463 3.463 0 01-1-2.5 3.34 3.34 0 011.014-2.515 3.477 3.477 0 012.52-.975zm12.038 0a3.365 3.365 0 013.491 3.49 3.485 3.485 0 01-.968 2.532 3.653 3.653 0 01-5.056-.032 3.463 3.463 0 01-1-2.5 3.34 3.34 0 011.008-2.511 3.477 3.477 0 012.526-.979z"/>
                <path d="M792.791 214.618a15.762 15.762 0 01-15.544 15.882h-18.093c-.369 0-.734-.015-1.1-.041l-10.121 4.341 2.752-6.887a15.993 15.993 0 01-7.075-13.3v-1.266a15.762 15.762 0 0115.543-15.88h18.093a15.763 15.763 0 0115.544 15.88zm-15.544-21.147h-18.094a19.761 19.761 0 00-19.544 19.88v1.266a20.017 20.017 0 006.264 14.561l-5.239 13.111 18.157-7.794h18.456a19.76 19.76 0 0019.543-19.881v-1.267a19.761 19.761 0 00-19.544-19.88z"/>
            </g>
            <g fill="#3f92cf">
                <path d="M595.2 195.879a22 22 0 11-22 22 22.025 22.025 0 0122-22m0-3a25 25 0 1025 25 25 25 0 00-25-25z"/>
                <circle cx="591.333" cy="217.879" r="2.25"/>
                <circle cx="598.958" cy="217.879" r="2.25"/>
                <path d="M591.333 206.86l-2.121-2.121-12.2 12.2a1.328 1.328 0 000 1.879l1.18 1.182 11.019 11.019 2.121-2.121-11.019-11.018zM598.676 228.9l2.121 2.121 12.2-12.2a1.328 1.328 0 000-1.879l-1.182-1.182-11.015-11.021-2.121 2.121 11.021 11.019z"/>
            </g>
            <path d="M1129.428 237.245v-37.436l-13.412-3.87-24.111 9.053-.061.012v27.068l8.228-3.22v-22.024l15.941-3.811v32.379l-24.153-3.325 24.153 8.919v.01l13.414-3.712v-.043z" fill="#ee3b00"/>
            <g fill="#17234e">
                <path d="M924.624 402.955l9.217-26.458-9.217-6.041v32.499z"/>
                <path d="M953.776 386.591v-15.019l-29.152 31.383 29.152-16.364zM924.624 355.637v12.68l19.024 9.33 8.843-7.194-27.867-14.816z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="510" cy="227" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(505.953 232.703)">
                    2
                </text>
            </a>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="853" cy="227" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(848.953 232.703)">
                    3
                </text>
            </a>
            <g fill="#969696">
                <path d="M824.332 387.532h58.73v1.5h-58.73z"/>
                <path d="M881.53 383.046l9.068 5.236-9.068 5.235v-10.471zM825.864 383.046l-9.067 5.236 9.067 5.235v-10.471z"/>
            </g>
            <a class="architecture-tooltip-trigger" href="#">
                <circle cx="853" cy="388" fill="#a5ce00" r="14"/>
                <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(848.953 393.703)">
                    6
                </text>
            </a>
            <g>
                <g fill="#969696">
                    <path d="M937.997 292.009h1.5v45.265h-1.5z"/>
                    <path d="M943.982 335.742l-5.235 9.067-5.236-9.067h10.471z"/>
                </g>
                <a class="architecture-tooltip-trigger" href="#">
                    <circle cx="939.2" cy="314.903" fill="#a5ce00" r="14"/>
                    <text fill="#303030" font-family="SegoeUI, Segoe UI" font-size="15" transform="translate(935.153 320.606)">
                        4
                    </text>
                </a>
            </g>
        </g>
    </g>
</svg>

<div class="architecture-tooltip-content" id="architecture-tooltip-1">
<p>Employee access Enterprise Productivity Bot</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-2">
<p>Azure Active Directory validates the employee’s identity</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-3">
<p>The Bot is able to query the employee’s Office 365 calendar via the Azure Graph</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-4">
<p>Using data gathered from the calendar, the Bot access case information in Dynamics CRM</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-5">
<p>Information is returned to the employee who can filter down the data without leaving the Bot</p>
</div>
<div class="architecture-tooltip-content" id="architecture-tooltip-6">
<p>Application insights gathers runtime telemetry to help the development with Bot performance and usage</p>
</div>

## Data Flow

1. Employee access Enterprise Productivity Bot
1. Azure Active Directory validates the employee’s identity
1. The Bot is able to query the employee’s Office 365 calendar via the Azure Graph
1. Using data gathered from the calendar, the Bot access case information in Dynamics CRM
1. Information is returned to the employee who can filter down the data without leaving the Bot
1. Application insights gathers runtime telemetry to help the development with Bot performance and usage


[!INCLUDE [js_include_file](../../_js/index.md)]
