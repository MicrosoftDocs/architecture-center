---
title: compliance
description: None
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How does compliance and governance impact your workload? 
---

# compliance

Organizations of all sizes are constrained by their available resources;
financial, people, and time. To achieve an effective return on investment (ROI)
organizations must prioritize where they will invest. Implementation of security
across the organization is also constrained by this, so to achieve an
appropriate ROI on security the organization needs to first understand and
define its security priorities.

**Governance** – How is the organization’s security going to be monitored,
audited, and reported? Design and implementation of security controls within
an organization is only the beginning of the story. How does the
organization know that things are actually working? Are they improving? Are
there new requirements? Is there mandatory reporting? Similar to compliance
there may be external industry, government or regulatory standards that need
to be considered.

**Risk** – What types of risks does the organization face while trying to
protect identifiable information, Intellectual Property
(IP), financial information? Who may be interested or could leverage this
information if stolen, including external and internal threats as well as
unintentional or malicious? A commonly forgotten but extremely important
consideration within risk is addressing Disaster Recovery and Business
Continuity.

**Compliance** – Are there specific industry, government, or regulatory requirements that dictate or provide recommendation on criteria that your organization’s security controls must meet? Examples of such standards, organizations, controls, and legislation are [ISO27001]( https://www.iso.org/isoiec-27001-information-security.html), [NIST]( https://www.nist.gov/), [PCI-DSS]( https://www.pcicomplianceguide.org/faq/).

The collective role of organization(s) is to manage the security standards of
the organization through their lifecycle:

-   **Define** - Set organizational standards and policies for practices,
    technologies, and configurations based on internal factors (organizational
    culture, risk appetite, asset valuation, business initiatives, etc.) and
    external factors (benchmarks, regulatory standards, threat environment, and
    more)

-   **Improve** – Continually push these standards incrementally forward towards
    the ideal state to ensure continual risk reduction.

-   **Sustain** – Ensure the security posture doesn’t degrade naturally over
    time by instituting auditing and monitoring compliance with organizational
    standards.<!-- You have appropriate emergency access accounts configured -->
[!include[85233643-0a2b-41d7-856c-b0bdbdfe5b0a](../../../includes/aar_guidance/85233643-0a2b-41d7-856c-b0bdbdfe5b0a.md)]

<!-- You prioritize security best practices -->
[!include[eb567f88-ce22-429e-a968-c2f040a5e9dd](../../../includes/aar_guidance/eb567f88-ce22-429e-a968-c2f040a5e9dd.md)]

<!-- You manage connected tenants -->
[!include[a93f2005-2b90-46be-9a5e-893971a81e82](../../../includes/aar_guidance/a93f2005-2b90-46be-9a5e-893971a81e82.md)]

<!-- There are clear lines of responsibility established -->
[!include[99b67f6d-3cac-49b1-a6de-dfda95e47dc4](../../../includes/aar_guidance/99b67f6d-3cac-49b1-a6de-dfda95e47dc4.md)]

<!-- There is an enterprise segmentation strategy in place -->
[!include[c764ffed-0f67-4390-9e1b-82b590575bfe](../../../includes/aar_guidance/c764ffed-0f67-4390-9e1b-82b590575bfe.md)]

<!-- The security team has read only access into all environments. -->
[!include[e40ad76d-13c4-46fc-8980-b418723e6095](../../../includes/aar_guidance/e40ad76d-13c4-46fc-8980-b418723e6095.md)]

<!-- You have established segmentation via management groups. -->
[!include[97ea30c2-be65-421c-9a47-d22772f87ec1](../../../includes/aar_guidance/97ea30c2-be65-421c-9a47-d22772f87ec1.md)]

<!-- You use the root management group carefully -->
[!include[55a41509-98e8-4676-9030-dcba98b7d993](../../../includes/aar_guidance/55a41509-98e8-4676-9030-dcba98b7d993.md)]

<!-- You have a policy in place to apply security updates to VMs and strong password requirements. -->
[!include[9ed6069b-137c-4a52-9581-22d1f4864eb5](../../../includes/aar_guidance/9ed6069b-137c-4a52-9581-22d1f4864eb5.md)]

<!-- You have assigned a security incident notification contact -->
[!include[56d9e553-a579-49a1-90dc-466b0e4d4734](../../../includes/aar_guidance/56d9e553-a579-49a1-90dc-466b0e4d4734.md)]

<!-- You regularly review critical access -->
[!include[f44bf7bc-ff4a-463b-b0d1-83aebdfa0556](../../../includes/aar_guidance/f44bf7bc-ff4a-463b-b0d1-83aebdfa0556.md)]

<!-- You discover and remediate common risks -->
[!include[b603c997-1f75-4494-abfa-d8757995ae72](../../../includes/aar_guidance/b603c997-1f75-4494-abfa-d8757995ae72.md)]

<!-- You use blueprints to consistently deploy environments that comply with organizational polcies -->
[!include[1cec5c2d-004a-451e-9bba-d1a6e1fcd600](../../../includes/aar_guidance/1cec5c2d-004a-451e-9bba-d1a6e1fcd600.md)]

<!-- You discover and replace insecure protocols -->
[!include[2a964c77-0ffa-4501-bd28-f465b7a5d356](../../../includes/aar_guidance/2a964c77-0ffa-4501-bd28-f465b7a5d356.md)]

<!-- You have considered whether or not you need elevated security capabilities -->
[!include[81a68bd5-a328-4a14-88d3-123fd75abff2](../../../includes/aar_guidance/81a68bd5-a328-4a14-88d3-123fd75abff2.md)]

<!-- Have you defined security policies according to your company’s security needs, and tailored it to the type of applications or sensitivity of the data -->
[!include[96ada3c0-19c1-4204-bb31-a989813d838a](../../../includes/aar_guidance/96ada3c0-19c1-4204-bb31-a989813d838a.md)]

<!-- You have assigned appropriate privalages for managing the environment -->
[!include[e227632b-6837-4fab-b4ef-405fd482e8a5](../../../includes/aar_guidance/e227632b-6837-4fab-b4ef-405fd482e8a5.md)]

<!-- Data residency -->
[!include[6bb1fb76-3fd7-42b3-b848-6571a620d7c2](../../../includes/aar_guidance/6bb1fb76-3fd7-42b3-b848-6571a620d7c2.md)]

<!-- Standards -->
[!include[250062ac-40b6-4bb5-bc0c-3e912261ac29](../../../includes/aar_guidance/250062ac-40b6-4bb5-bc0c-3e912261ac29.md)]

<!-- Usage and spending -->
[!include[510bcf15-1333-4dc6-a376-178643bf3555](../../../includes/aar_guidance/510bcf15-1333-4dc6-a376-178643bf3555.md)]

<!-- Custom policies -->
[!include[9356b8e9-27b4-4c5e-a679-add6e7b7d7fa](../../../includes/aar_guidance/9356b8e9-27b4-4c5e-a679-add6e7b7d7fa.md)]

<!-- Policy to resources at scale -->
[!include[545ca865-29d8-48c6-ba49-323f66fd14b2](../../../includes/aar_guidance/545ca865-29d8-48c6-ba49-323f66fd14b2.md)]

<!-- You audit and enforce policy compliance -->
[!include[690207f9-a387-4a00-90f5-52219f2d2c79](../../../includes/aar_guidance/690207f9-a387-4a00-90f5-52219f2d2c79.md)]

