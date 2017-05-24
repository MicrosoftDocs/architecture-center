---
title: Apply recommended email policies and configurations
description:  Describes general Microsoft recommendations about how to apply email policies and configurations.
author: jeffgilb
ms.service: guidance
ms.topic: article
ms.date: 05/24/2017
ms.author: pnp

pnp.series.title: Best Practices
---

# Apply recommended email policies and configurations
 
## Introduction

While there is no single best recommendation for all customer environments, the best practices in this document describe general Microsoft recommendations about how to apply email policies and configurations. These recommendations ensure that your employees are both secure and productive.  Specifically, this document focuses on protecting organizational email while minimizing the usability impact for your users.

### Intended audience

This document is intended for enterprise infrastructure architects and IT Pros familiar with [Exchange Online](https://technet.microsoft.com/library/jj200580.aspx) (Office 365) and [Microsoft Enterprise Mobility + Security](http://microsoft.com/ems) products which include but are not limited to, Azure Active Directory (identity), Microsoft Intune (device management), and Azure Information Protection (data protection). 

### Customer environment

The policies recommended in this document are applicable to enterprise organizations operating both entirely in the Microsoft cloud, and for customers with their infrastructure deployed both on-premises and in the Microsoft cloud. 

### Assumptions

Most recommendations in this document leverage services available only with Enterprise Mobility + Security (EMS) E5 subscriptions. Recommendations presented assume full EMS E5 subscription capabilities. 

This document outlines how to apply the recommended configuration for protected email to a newly deployed environment.  Future documents will provide additional guidance on how to migrate from existing policies and configurations to the ones outlined below.

### Caveats

Your organization may be subject to regulatory or other compliance requirements, including specific recommendations that may require you to apply policies that diverge from these recommended configurations.  These configurations recommended leverage controls that have not historically been available.  We recommend these controls, because we believe they represent a balance between security and productivity.  

We have done our best to account for a wide variety of organizational protection requirements. But, we cannot account for all possible requirements or for all the unique aspects of your organization. Use this document as a guide for how Microsoft and the secure productive enterprise team is thinking about how to correctly apply policy in your organization. 

>[!NOTE]
>For an overview of the core concepts necessary to understand the protection capabilities described in these recommendations, see [EMS and Office 365 Service Descriptions].
>

## Next Steps
End User Single Sign-on (SSO) Experience
