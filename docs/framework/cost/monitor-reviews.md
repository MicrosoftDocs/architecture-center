---
title: Conduct cost reviews
description: Implement cost monitoring to review cloud spend with the intent of establishing cost controls and preventing any misuse.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Conduct cost reviews
The goal of cost monitoring is to review cloud spend with the intent of establishing cost controls and preventing any misuse. The organization should adopt both proactive and reactive review approaches for monitoring cost. Effective cost reviews must be conducted by accountable stakeholders at a regular cadence. The reviews must be complemented with reactive cost reviews, for example when a budget limit causes an alert.

**Who should be included in a cost review?**  
***

The financial stakeholders must understand cloud billing to derive business benefits using financial metrics to make effective decisions.

Also include members of the technical team. Application owners, systems administrators who monitor and back-up cloud systems, and business unit representatives must be aware of the decisions. They can provide insights because they understand cloud cost metering and cloud architecture. One way of identifying owners of systems or applications is through resource tags.

**What should be the cadence of cost reviews?**
***

Cost reviews can be conducted as part of the regular business reviews. It's recommended that such reviews are scheduled,

- During the billing period. This review is to create an awareness of the estimated pending billing. These reports can be based on [Azure Advisor](/azure/advisor/advisor-cost-recommendations), [Advisor Score](/azure/advisor/azure-advisor-score/), and [Azure Cost Management – Cost analysis](/azure/cost-management-billing/costs/).
- After the billing period. This review shows the actual cost with activity for that month. Use [Balance APIs](/azure/cost-management-billing/manage/consumption-api-overview#balances-api) to generate monthly reports. The APIs can query data  that gets information on balances, new purchases, Azure Marketplace service charges, adjustments, and overage charges.
- Because of a [budget alert](/azure/cost-management/cost-mgt-alerts-monitor-usage-spending) or Azure Advisor recommendations.

Web Direct (pay-as-you-go) and Cloud Solution Provider (CSP) billing occurs monthly. While Enterprise Agreement (EA) billing occurs annually, costs should still be reviewed monthly.
