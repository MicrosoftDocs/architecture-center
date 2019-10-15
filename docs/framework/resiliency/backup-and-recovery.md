---
title: Backup and Recovery
description: *Disaster recovery* is the process of restoring application functionality in the wake of a catastrophic loss.

Your tolerance for reduced functionality during a disaster is a business decision that varies from one application to the next. It might be acceptable for some applications to be completely unavailable or to be partially available with reduced functionality or delayed processing for a period of time. For other applications, any reduced functionality is unacceptable.
author: david-stanford
ms.date: 10/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you handling DR (Backup & Restore) for this workload? 
---

# Backup and Recovery

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

*Disaster recovery* is the process of restoring application functionality in the wake of a catastrophic loss.

Your tolerance for reduced functionality during a disaster is a business decision that varies from one application to the next. It might be acceptable for some applications to be completely unavailable or to be partially available with reduced functionality or delayed processing for a period of time. For other applications, any reduced functionality is unacceptable.<!-- You have a plan for dependency failures -->
[!include[33fe1493-7dbd-48de-ab6a-d6635c9c7c68](../../../includes/aar_guidance/33fe1493-7dbd-48de-ab6a-d6635c9c7c68.md)]

<!-- There is a response plan in place for network outages. -->
[!include[5be928fb-5256-48be-ae77-6c7c932a7371](../../../includes/aar_guidance/5be928fb-5256-48be-ae77-6c7c932a7371.md)]

<!-- You have manual responses defined where automation doesn't exist -->
[!include[2da87328-516c-4ff1-a653-3dcce115f12a](../../../includes/aar_guidance/2da87328-516c-4ff1-a653-3dcce115f12a.md)]

<!-- You understand what to do when data is corrupted or deleted -->
[!include[fdbbf0bc-5fba-4a7e-bbb2-a0dabc22f7e6](../../../includes/aar_guidance/fdbbf0bc-5fba-4a7e-bbb2-a0dabc22f7e6.md)]

<!-- You have a disaster recovery plan -->
[!include[78b95e10-acc0-4749-8f1f-efa8cfb5eb89](../../../includes/aar_guidance/78b95e10-acc0-4749-8f1f-efa8cfb5eb89.md)]

<!-- Backup strategy defined -->
[!include[c0f0af98-7b8f-49c1-823d-a7626f4abed8](../../../includes/aar_guidance/c0f0af98-7b8f-49c1-823d-a7626f4abed8.md)]

<!-- Virtual machines are protected from corruption and accidental deletion -->
[!include[15e506d4-11cb-476f-a1aa-e0d7699dcc76](../../../includes/aar_guidance/15e506d4-11cb-476f-a1aa-e0d7699dcc76.md)]

<!-- Resource management -->
[!include[569d1907-4e1b-47a4-9edf-d663534ef164](../../../includes/aar_guidance/569d1907-4e1b-47a4-9edf-d663534ef164.md)]

<!-- Backup & restore operations are automatically scheduled and tested -->
[!include[7e063160-cb53-46c1-b111-380f77a7c848](../../../includes/aar_guidance/7e063160-cb53-46c1-b111-380f77a7c848.md)]

<!-- Implementing and validating data backups -->
[!include[b7793fe8-b2c3-4d79-94a6-85b1f5248f4f](../../../includes/aar_guidance/b7793fe8-b2c3-4d79-94a6-85b1f5248f4f.md)]

<!-- We conduct outage retrospectives -->
[!include[19ddf9ff-e487-40ad-8446-ad14e3be1f91](../../../includes/aar_guidance/19ddf9ff-e487-40ad-8446-ad14e3be1f91.md)]

<!-- Regional failure plans are documented -->
[!include[4cce6ac5-3939-48e4-8ff1-fd9fbaa08252](../../../includes/aar_guidance/4cce6ac5-3939-48e4-8ff1-fd9fbaa08252.md)]

<!-- Backups are stored securely -->
[!include[780d5d6c-f8d9-48d6-bc8b-ed75e60fbc06](../../../includes/aar_guidance/780d5d6c-f8d9-48d6-bc8b-ed75e60fbc06.md)]

<!-- Have application configuration and installations archivied -->
[!include[0713135c-52c2-4ee3-94ba-63224f54b3d9](../../../includes/aar_guidance/0713135c-52c2-4ee3-94ba-63224f54b3d9.md)]

<!-- Data retention policies are defined -->
[!include[75fe27cc-08ce-44ab-bd0b-3843c2eeb0c9](../../../includes/aar_guidance/75fe27cc-08ce-44ab-bd0b-3843c2eeb0c9.md)]

<!-- Our backups are automated.  -->
[!include[4c3d21fa-90ec-4124-995d-08b8877a1cee](../../../includes/aar_guidance/4c3d21fa-90ec-4124-995d-08b8877a1cee.md)]

