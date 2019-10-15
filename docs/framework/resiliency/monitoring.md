---
title: Monitoring
description: Monitoring and diagnostics are crucial for resiliency. If something fails, you need to know *that* it failed, *when* it failed &mdash; and *why*.

*Monitoring* is not the same as *failure detection*. For example, your application might detect a transient error and retry, avoiding downtime. But it should also log the retry operation so that you can monitor the error rate to get an overall picture of application health.

Think of the monitoring and diagnostics process as a pipeline with four distinct stages: Instrumentation, collection and storage, analysis and diagnosis, and visualization and alerts.
author: david-stanford
ms.date: 10/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you ensuring failures are resolved quickly? 
---

# Monitoring

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

Monitoring and diagnostics are crucial for resiliency. If something fails, you need to know *that* it failed, *when* it failed &mdash; and *why*.

*Monitoring* is not the same as *failure detection*. For example, your application might detect a transient error and retry, avoiding downtime. But it should also log the retry operation so that you can monitor the error rate to get an overall picture of application health.

Think of the monitoring and diagnostics process as a pipeline with four distinct stages: Instrumentation, collection and storage, analysis and diagnosis, and visualization and alerts.<!-- You have an early warning system for workloads where that makes sense. -->
[!include[4e396a34-d281-498a-aa04-7e568c0302fa](../../../includes/aar_guidance/4e396a34-d281-498a-aa04-7e568c0302fa.md)]

<!-- You track and act on your remote call statistics -->
[!include[ba131573-d162-41ae-b7b3-965b756c4b8c](../../../includes/aar_guidance/ba131573-d162-41ae-b7b3-965b756c4b8c.md)]

<!-- You monitor your long-running workflows for failures. -->
[!include[e1c866fc-2813-4dd8-9cb1-6e3994725f48](../../../includes/aar_guidance/e1c866fc-2813-4dd8-9cb1-6e3994725f48.md)]

<!-- You have built visualization and alerts so your monitoring is actionable. -->
[!include[0b2db038-ce56-4969-839c-52eff60d43ca](../../../includes/aar_guidance/0b2db038-ce56-4969-839c-52eff60d43ca.md)]

<!-- You have validated that your monitoring system is functional. -->
[!include[cdd26956-73b7-4c13-843c-744a5a7de41d](../../../includes/aar_guidance/cdd26956-73b7-4c13-843c-744a5a7de41d.md)]

<!-- The process to contact Azure support is documented and understood -->
[!include[8e97698d-b6ed-45d0-bf98-89f5cd7e6fb1](../../../includes/aar_guidance/8e97698d-b6ed-45d0-bf98-89f5cd7e6fb1.md)]

<!-- Azure subscription/service limits are documented and known -->
[!include[c910bad6-cd8f-42ce-8076-edca3f197bd6](../../../includes/aar_guidance/c910bad6-cd8f-42ce-8076-edca3f197bd6.md)]

<!-- Multiple people are trained for monitoring -->
[!include[91777c9f-832f-4380-8167-8d952eadef81](../../../includes/aar_guidance/91777c9f-832f-4380-8167-8d952eadef81.md)]

<!-- Operators are assigned for system alerts -->
[!include[1f5ab437-af5d-45b0-8954-ad5843769e00](../../../includes/aar_guidance/1f5ab437-af5d-45b0-8954-ad5843769e00.md)]

<!-- You have implemented the necessary instrumentation to monitor your workload. -->
[!include[0c294da9-897f-4e40-9eb9-e683ebf3b548](../../../includes/aar_guidance/0c294da9-897f-4e40-9eb9-e683ebf3b548.md)]

<!-- Monitoring tools are used to collect and view historical statistics -->
[!include[b06b8e73-1ed8-491f-ab1d-32b7e429f958](../../../includes/aar_guidance/b06b8e73-1ed8-491f-ab1d-32b7e429f958.md)]

<!-- Health probes are implemented to validate application functionality -->
[!include[f8d28ca2-bf0a-43a5-bd1b-e801bb6537ff](../../../includes/aar_guidance/f8d28ca2-bf0a-43a5-bd1b-e801bb6537ff.md)]

<!-- Errors and failures are captured and reported -->
[!include[59fb1292-709c-469a-a57c-68760210f30c](../../../includes/aar_guidance/59fb1292-709c-469a-a57c-68760210f30c.md)]

<!-- Telemetric information is captured -->
[!include[df688b67-0f2e-4d32-9f07-2748a48829cd](../../../includes/aar_guidance/df688b67-0f2e-4d32-9f07-2748a48829cd.md)]

<!-- Log information is collected and correlated across all tiers -->
[!include[4aeb4f36-445d-43cb-9e7c-57bc716c0712](../../../includes/aar_guidance/4aeb4f36-445d-43cb-9e7c-57bc716c0712.md)]

