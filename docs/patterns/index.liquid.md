---
title: Cloud Design Patterns
titleSuffix: Azure Architecture Center
description: Cloud Design Patterns for Microsoft Azure
author: martinekuan
ms.author: architectures
ms.date: 07/28/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: design-pattern
ms.custom:
  - design-pattern
keywords:
  - Azure
---

# Cloud Design Patterns

These design patterns are useful for building reliable, scalable, secure applications in the cloud.

Each pattern describes the problem that the pattern addresses, considerations for applying the pattern, and an example based on Microsoft Azure. Most of the patterns include code samples or snippets that show how to implement the pattern on Azure. However, most of the patterns are relevant to any distributed system, whether hosted on Azure or on other cloud platforms.

## Problem areas in the cloud

<!-- markdownlint-disable MD033 -->

<ul id="categories" class="panel">
{%- for category in categories %}
    <li>
    {% include 'pattern-category-card' %}
    </li>
{%- endfor %}
</ul>

<!-- markdownlint-enable MD033 -->

## Catalog of patterns

| Pattern | Summary |
|---------|---------|
|         |         |

{%- for pattern in patterns %}
| [{{ pattern.title }}](./{{ pattern.file }}) | {{ pattern.description }} |
{%- endfor %}
