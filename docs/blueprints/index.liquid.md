---
title: Azure | Architecture
description: Architectural Blueprints
layout: LandingPage
tocRel: toc.json
---
<link href="/azure/architecture/_css/hubCards.css" type="text/css" rel="stylesheet" />
<style type="text/css" >
.panel.x2 li {
    flex-basis: 25% !important;
}
</style>
# Architectural Blueprints
[!INCLUDE [header](../_includes/header.md)]

Our reference architectures are arranged by scenario, with multiple related architectures grouped together.
Each individual architecture offers recommended practices and prescriptive steps, as well as an executable component that embodies the recommendations.
Many of the architectures are progressive; building on top of preceding architectures that have fewer requirements.

{% for item in series -%}
<section class="series">
    <h2>{{ item.title }}</h2>
    {%- capture path -%}{{ item.path }}/{%- endcapture -%}
    {% include 'series' with item %}
    <p>{{ item.description }}</p>
    <div class="links">
        <a href="./{{ item.path }}/index.md" class="c-call-to-action c-glyph"><span>Series overview</span></a>
    </div>
</section>
{% endfor %}