---
title: Azure Architecture
description: Architecture diagrams, reference architectures, example scenarios, and solutions for common workloads on Azure.
author: doodlemania2
ms.date: 10/18/2019
layout: LandingPage
ms.topic: landing-page
---

# Azure Architectures

Architecture diagrams, reference architectures, example scenarios, and solutions for common workloads on Azure.

{% for topic, articles in topics | sort %}<a href="#{{ topic |lower|replace(" ", "-")|replace("+","") }}">{{ topic }}</a> {% if not loop.last %} | {% endif %}{% endfor %}

{% for topic, articles in topics | sort %}

## {{ topic }}
<ul class="grid">

{% for article in articles %}
[!INCLUDE [{{ article['Title'] }}](../../includes/cards/{{ article['name'] }}.md)]
{% endfor %}

</ul>

||
|--:|
|<a href="#">back to top</a>|
{% endfor %}