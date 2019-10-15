---
title: Testing
description: To test resiliency, you should verify how the end-to-end workload performs under intermittent failure conditions.

Run tests in production using both synthetic and real user data. Test and production are rarely identical, so it's important to validate your application in production using a [blue-green](https://martinfowler.com/bliki/BlueGreenDeployment.html) or [canary deployment](https://martinfowler.com/bliki/CanaryRelease.html). This way, you're testing the application under real conditions, so you can be sure that it will function as expected when fully deployed.

As part of your test plan, include:

- Automated predeployment testing
- Fault injection testing
- Peak load testing
- Disaster recovery testing
- Third-party service testing

Testing is an iterative process. Test the application, measure the outcome, analyze and address any failures that result, and repeat the process.
author: david-stanford
ms.date: 10/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How do you test your applications to ensure they're fault tolerant? 
---

# Testing

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

NoneTo test resiliency, you should verify how the end-to-end workload performs under intermittent failure conditions.

Run tests in production using both synthetic and real user data. Test and production are rarely identical, so it's important to validate your application in production using a [blue-green](https://martinfowler.com/bliki/BlueGreenDeployment.html) or [canary deployment](https://martinfowler.com/bliki/CanaryRelease.html). This way, you're testing the application under real conditions, so you can be sure that it will function as expected when fully deployed.

As part of your test plan, include:

- Automated predeployment testing
- Fault injection testing
- Peak load testing
- Disaster recovery testing
- Third-party service testing

Testing is an iterative process. Test the application, measure the outcome, analyze and address any failures that result, and repeat the process.<!-- SetMe -->
[!include[a34ec312-6e4a-408b-b9ef-be034541f7bd](../../../includes/aar_guidance/a34ec312-6e4a-408b-b9ef-be034541f7bd.md)]

<!-- You perform testing in small, real-life situations. -->
[!include[e251193a-37cb-4116-a001-1bb74c08649a](../../../includes/aar_guidance/e251193a-37cb-4116-a001-1bb74c08649a.md)]

<!-- You are testing your workload by injecting faults. -->
[!include[1e7674b5-00c7-4ff8-9c43-269cc7c29680](../../../includes/aar_guidance/1e7674b5-00c7-4ff8-9c43-269cc7c29680.md)]

<!-- Perform Load Testing -->
[!include[0b1b8335-a3a2-405c-91dc-526abd02d841](../../../includes/aar_guidance/0b1b8335-a3a2-405c-91dc-526abd02d841.md)]

