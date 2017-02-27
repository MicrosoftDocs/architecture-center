---
title: Cloud Design Patterns
description: Cloud Design Patterns for Microsoft Azure
keywords: Azure
---
# Cloud Design Patterns

[!INCLUDE [header](../../_includes/header.md)]

These design patterns are useful for building reliable, scalable, secure applications in the cloud.

Each pattern describes the problem that the pattern addresses, considerations for applying the pattern, and an example based on Microsoft Azure. Most of the patterns include code samples or snippets that show how to implement the pattern on Azure. However, most of the patterns are relevant to any distributed system, whether hosted on Azure or on other cloud platforms.

## Problem areas in the cloud

<ul id="categories" class="panel">
{%- for category in categories %}
    <li>
    {% include 'pattern-category-card' %}
    </li>
{%- endfor %}
</ul>

## Catalog of patterns

| Pattern | Summary |
| ------- | ------- |
{%- for pattern in patterns %}
| [{{ pattern.title }}](./{{ pattern.file }}) | {{ pattern.description }} |
{%- endfor %}