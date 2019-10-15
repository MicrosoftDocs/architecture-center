---
title: Data Management
description: 
author: david-stanford
ms.date: 10/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you managing your data? 
---

# Data Management

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

<!-- Database's are architected for resiliency -->
[!include[a50d8886-9beb-493e-87da-fc752cf3cf23](../../../includes/aar_guidance/a50d8886-9beb-493e-87da-fc752cf3cf23.md)]

<!-- Databases are replicated geographically when appropriate -->
[!include[f7d4b058-15d1-42f5-9ee2-362b3b68ee0d](../../../includes/aar_guidance/f7d4b058-15d1-42f5-9ee2-362b3b68ee0d.md)]

<!-- Data consistency and concurrency are documented -->
[!include[69748949-e0f4-46bf-8b99-b49bbc2ebf07](../../../includes/aar_guidance/69748949-e0f4-46bf-8b99-b49bbc2ebf07.md)]

<!-- Storage is architected for resiliency -->
[!include[d9805b44-8d42-4009-8db5-227a5e249d1a](../../../includes/aar_guidance/d9805b44-8d42-4009-8db5-227a5e249d1a.md)]

<!-- Using seperate user accounts for production and backup databases -->
[!include[7d4dd0b4-6552-47e3-96c5-9b98aef3b50c](../../../includes/aar_guidance/7d4dd0b4-6552-47e3-96c5-9b98aef3b50c.md)]

<!-- Failover and fallback processes are orchestrated and tested -->
[!include[5b251e1d-3352-4f3f-8ac6-edbadb0c1471](../../../includes/aar_guidance/5b251e1d-3352-4f3f-8ac6-edbadb0c1471.md)]

