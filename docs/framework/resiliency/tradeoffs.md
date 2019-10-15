---
title: Tradeoffs
description: 
author: david-stanford
ms.date: 10/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: What Resiliency trade-offs are you making? 
---

# Tradeoffs

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

<!-- Balanced alterting frequency with operations fatigue -->
[!include[6039de59-8907-4beb-a4a2-652a90d19d25](../../../includes/aar_guidance/6039de59-8907-4beb-a4a2-652a90d19d25.md)]

<!-- Balanced automation of failure handling with the ability to respond to transient failures -->
[!include[ae2bd1f4-8fe9-46ba-9e23-18c01d5b2e40](../../../includes/aar_guidance/ae2bd1f4-8fe9-46ba-9e23-18c01d5b2e40.md)]

<!-- Chosen a recovery point that aligns with our cost requirements -->
[!include[ce137ac6-4b7f-4934-9ba0-bc6a9b7fd8c7](../../../includes/aar_guidance/ce137ac6-4b7f-4934-9ba0-bc6a9b7fd8c7.md)]

<!-- Chosen a recovery time that aligns with our cost goals -->
[!include[9669fd68-3eeb-4d28-8af7-0516039e422e](../../../includes/aar_guidance/9669fd68-3eeb-4d28-8af7-0516039e422e.md)]

