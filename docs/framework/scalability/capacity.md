---
title: Capacity
description: 
author: david-stanford
ms.date: 10/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you ensuring you have sufficient Capacity? 
---

# Capacity

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

<!-- Using a Content Delivery Networks (CDN) if applicable -->
[!include[617f326b-536a-424d-8f64-789782d5fe7a](../../../includes/aar_guidance/617f326b-536a-424d-8f64-789782d5fe7a.md)]

<!-- Aware of any events that will cause spikes in user load -->
[!include[a38b7b87-7964-48e0-9ae3-a0ff9c6a2c7d](../../../includes/aar_guidance/a38b7b87-7964-48e0-9ae3-a0ff9c6a2c7d.md)]

<!-- Optimized resource choices (vm, database sizing, etc) to match the needs of your application -->
[!include[fe7458fa-7e8f-4fe5-a992-9f0c740e1430](../../../includes/aar_guidance/fe7458fa-7e8f-4fe5-a992-9f0c740e1430.md)]

<!-- Configured scaling policies using the appropriate metrics -->
[!include[0f4d6be8-a93d-4a8a-bf92-d801c26f427b](../../../includes/aar_guidance/0f4d6be8-a93d-4a8a-bf92-d801c26f427b.md)]

<!-- Automatically schedule autoscaling to add resources based on time of day trends -->
[!include[309d9359-996b-4959-9783-330c9899b770](../../../includes/aar_guidance/309d9359-996b-4959-9783-330c9899b770.md)]

