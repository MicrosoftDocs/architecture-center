---
title: "Ongoing management and security"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Ongoing management and security
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Phase 3: Ongoing management and security

Once you have onboarded Azure management services, you will need to focus on the operations and security configurations that will support your ongoing operations. We will start with securing your environment by reviewing the Azure Security Center, then configuring policies to keep servers in compliance and automating common tasks. This section covers:

- **[Address security recommendations](#address-security-recommendations).** Azure Security Center makes suggestions to improve your environment security assurance. By implementing the recommendations, you can see the impact through the security scores.
- **[Enable Guest Configuration policy](./guest-configuration-policy.md)**. Enable Azure Policy's Guest Configuration feature to audit the settings inside a virtual machine. For example, you can check if any certificates are about to expire.
- **[Track and alert on critical changes](./enable-tracking-alerting.md)**. When troubleshooting, the first question to consider is, "What has changed?" In this section, we show you how to track changes and create alerts to monitor critical components proactively.
- **[Create update schedules](./update-schedules.md)**. Schedule the installation of updates to ensure all the servers have the latest updates.
- **[Common Azure Policy examples](./common-policies.md)**. Provides examples of common management policies.  

## Address security recommendations

Azure Security Center is the central place to manage security for your environment. Once onboarded, you will not only see your overall assessment, but also recommendations targeted to your environment.

We recommend you review and implement the recommendations provided by this service. For more information about additional benefits of Azure Security Center, see [Follow Azure Security Center recommendations](/azure/migrate/migrate-best-practices-security-management#best-practice-follow-azure-security-center-recommendations).

## Next steps

Learn how to [enable Azure Policy's Guest Configuration](./guest-configuration-policy.md) feature.

> [!div class="nextstepaction"]
> [Guest Configuration policy](./guest-configuration-policy.md)
