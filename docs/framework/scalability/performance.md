---
title: Performance
description: 
author: david-stanford
ms.date: 10/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you thinking about Performance? 
---

# Performance

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

<!-- Have well defined performance goals (eg: throughput and latency) -->
[!include[91563675-7699-46b8-a60d-311e92aede83](../../../includes/aar_guidance/91563675-7699-46b8-a60d-311e92aede83.md)]

<!-- Using horizontal scaling when possible -->
[!include[17dbf926-0d77-459e-a44c-76895adcb2d4](../../../includes/aar_guidance/17dbf926-0d77-459e-a44c-76895adcb2d4.md)]

<!-- Have policies to scale in (down) when your load decreases? -->
[!include[1eab2007-a8bd-440d-87eb-09a42e320ad5](../../../includes/aar_guidance/1eab2007-a8bd-440d-87eb-09a42e320ad5.md)]

<!-- Understand your performance bottlenecks? (components or goals) -->
[!include[aebd1ae8-4d79-4ed5-a625-9c8dc270b18f](../../../includes/aar_guidance/aebd1ae8-4d79-4ed5-a625-9c8dc270b18f.md)]

<!-- Gracefully handle throttling -->
[!include[fa7fe27a-fb7a-47bf-84ec-ae009ed95a54](../../../includes/aar_guidance/fa7fe27a-fb7a-47bf-84ec-ae009ed95a54.md)]

<!-- Use idempotent operations -->
[!include[1bc6e483-efd2-41c8-8415-ad02c95caa97](../../../includes/aar_guidance/1bc6e483-efd2-41c8-8415-ad02c95caa97.md)]

<!-- Gracefully handle failures -->
[!include[e769b84e-1c9a-4e51-9ff1-3546acda036d](../../../includes/aar_guidance/e769b84e-1c9a-4e51-9ff1-3546acda036d.md)]

