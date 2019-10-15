---
title: App Design - Error Handling
description: Ensuring your application can recover from errors is critical when working in a distributed system
author: david-stanford
ms.date: 10/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you managing errors & failures? 
---

# App Design - Error Handling

<div id="banner-holder" class="has-default-focus has-overflow-hidden">
    <section data-dismissable="disappearing" class="uhf-container has-padding has-padding-top-small has-padding-bottom-small has-background-docs alert is-banner has-text-docs-invert" id="preview-banner" data-bi-name="preview-banner">
        <div class="level">
            <div class="level-left has-margin-left-medium has-margin-right-medium-mobile">
                <div class="level-item has-flex-justify-content-start-mobile">
                    <span class="learn-banner-heading has-padding is-size-3 is-title">
                        This is a preview of the Azure Architecture Framework.<br>
                        We're under active development and will be updating this often.
                    </span>
                </div>
            </div>
            <div class="level-right has-margin-right-medium has-flex-justify-content-start-mobile">  
                <a id="feedback-anchor" data-bi-name="CTA" class="button is-transparent has-inverted-border is-small" href="#feedback">
                    <span>Provide Feedback</span>
                </a>
                <button type="button" data-dismiss="" data-bi-name="close" class="is-inverted has-inverted-focus has-inner-focus delete is-large is-absolute-mobile has-top-zero-mobile has-right-zero-mobile has-margin-extra-small-mobile">
                    <span class="visually-hidden">Dismiss</span>
                </button>
            </div>
        </div>
    </section>
</div>

Ensuring your application can recover from errors is critical when working in a distributed system<!-- Retries for transient errors are impelmented and logged -->
[!include[3128430d-7c25-49da-97eb-643d29f1149c](../../../includes/aar_guidance/3128430d-7c25-49da-97eb-643d29f1149c.md)]

<!-- Request timeouts are configured -->
[!include[5c44424c-38f4-45a8-8d38-57cb34869f29](../../../includes/aar_guidance/5c44424c-38f4-45a8-8d38-57cb34869f29.md)]

<!-- Implemented the "Circuit Breaker" pattern to prevent cascading failures -->
[!include[2d348cc5-c6e0-4f9d-a29a-827f57527e5f](../../../includes/aar_guidance/2d348cc5-c6e0-4f9d-a29a-827f57527e5f.md)]

<!-- Application components are split with seperate health probes -->
[!include[309f1127-3a9e-4876-b5dd-91bade63f789](../../../includes/aar_guidance/309f1127-3a9e-4876-b5dd-91bade63f789.md)]

<!-- Command and Query Responsibility Segregation (CQRS) is implemented on data stores -->
[!include[c9dbb912-a194-4b28-9f04-1ebb17eb711c](../../../includes/aar_guidance/c9dbb912-a194-4b28-9f04-1ebb17eb711c.md)]

