---
title: {{ title }}
description: {{ description }}
layout: LandingPage
---
<link href="_css/pnp.css" type="text/css" rel="stylesheet" />
<div class="pnp">
    <div class="container">
        <h1>{{ title }}</h1>
        <div class="frontmatter">{{ frontmatter }}</div>
        <ul id="featured" class="cardsW panel">
            {%- for item in featured %}
            <li>
            {% include 'featured-card' %}
            </li>
            {%- endfor %}
        </ul>
        <hr />
        <ul class="cardsFTitle panel secondary">
        {%- for item in series %}
            <li>
            {% include 'two-column-card' %}
            </li>
        {%- endfor %}
        </ul>
    </div>
</div>