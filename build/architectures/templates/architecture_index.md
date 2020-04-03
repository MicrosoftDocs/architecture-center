---
title: Solution Ideas
description: Architecture diagrams, reference architectures, example scenarios, and solutions for common workloads on Azure.
author: adamboeglin
ms.date: 10/18/2019
layout: LandingPage
ms.topic: landing-page
---

{% for topic, articles in topics %}
## {{ topic }}
<ul class="grid">

{% for article in articles %}
[!INCLUDE [{{ article['Title'] }}](../../includes/cards/{{ article['name'] }}.md)]
{% endfor %}

</ul>

{% endfor %}