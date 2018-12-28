---
title: "Fusion: What business risks are associated with a Cloud Transformation?"
description: Explanation of the business risks associated with a Cloud Transformation?
author: BrianBlanchard
ms.date: 10/10/2018
---

# Fusion: Evaluating risk tolerance

Every business decision creates new risks. Making an investment in anything creates risk of losses. New products or services create risks of market failure. Changes to current products or services could reduce market share. Cloud Transformation does not provide a magical solution to everyday business risk. To the contrary, connected solutions (Cloud or on-prem) open up new risks. Deploying assets to any network connected facility also expands the potential threat profile by exposing security weaknesses to a much broader, global community. Fortunately, Cloud Providers are aware of the changes, increases, and addition of risks. They invest heavily to mitigate those risks on the behalf of their customers.

This article is not focused on Cloud Risks. Instead it discusses the business risks associated with various forms of Cloud Transformation. Later in the article, the discussion shifts focus to discuss ways of understanding the business' tolerance for risk.

## What business risks are associated with a Cloud Transformation?

Sadly, the true business risks will be based on the what & how behind specific transformations. Fortunately, there are a number of very common risks that can be used as a conversation started to understand specific, personalized risks.

** Before reading the following, beware that each of these risks can be remediated. The goal of this article is to inform & prepare readers, such that mitigation conversations can be more effective at mitigating risks. **

* Data Protection Risk: The number one risk associated with any transformation, is the protection of data. In today's digital age of business, data is the new oil. It fuels the economy, it warms the office, it delights customers. However, when it leaks, the outcome is equally destructive. Any changes to the way data is stored, processed, or used creates risk. Cloud Transformations create a high degree of change regarding data management, so the risk should not be taken lightly. [Security Management](../governance/security-management/overview.md), [Data Classification](../governance/what-is-data-governance.md), and [Incremental Rationalization](../digital-estate/rationalize-incremental.md#incremental-rationalization-release-planning) can each help mitigate this risk.

* Operations & Customer Experience Risk: Business operations & customer experiences rely heavily on technical operations. Cloud Transformations will create change in technical operations (TechOps). In some organizations, that change is small & easily adjusted. In other organizations, changes to TechOps could require retooling, reskilling, or new approaches to support. The bigger the change, the bigger the potential impact on Business Operations and Customer Experience. Mitigation of this risk will come from the involvement of the business in transformation planning. Release planning and First workload selection in the [Incremental Rationalization](../digital-estate/rationalize-incremental.md#incremental-rationalization-release-planning) article discuss ways to choose workloads for transformation projects. The business' role in that activity, is to communicate the Business Operations risk from changes to prioritized workloads. Helping IT choose workloads that would have a reduced impact on operations, will reduce the overall risk.

* Cost Risk: Cost models change in the Cloud. This change can create risks associated with cost overruns or increases in Cost of Goods Sold (COGS), especially directly attributed operational expenses. When business works closely with IT, it is feasible to create transparency regarding costs and services consumed by various business units, programs, projects, etc... [Cost Management] provides examples of ways Business and IT can partner on this topic.

The above are a few of the most common risks mentioned by customers. The Cloud Governance Team and Cloud Adoption Team can begin to develop a risk profile, as workloads are migrated and readied for production release. Be prepared for conversations to define, refine, &/or mitigate risks based on the desired business outcomes and transformation effort.

# Understanding Risk Tolerance

Identifying risk is a fairly direct process. Risks are pretty standard across industries. However, tolerance for risk is extremely personalize. This is the point where business and IT conversations tend to get hung up. Each side of the conversation is essentially speaking a different language. The following comparisons and questions are designed to start conversations that help each party better understand and calculate risk tolerance.

## Simple Use Case for Comparison 

To help understand risk tolerance, lets examine customer data. If a company in any industry posts customer data on an unsecured server, the risk of that data being compromised or stolen is relatively the same. However, the nature of the data and the companies tolerance for that risk changes wildly.

* Companies in Healthcare and Finance in the United States, are governed by rigid, 3rd party compliance requirements. It is assumed that Personally Identifiable Information (PII) or healthcare related data is extremely confidential. There are severe consequences for these types of companies, if they are involved in the risks scenario above. Their tolerance will be extremely low. Any customer data published inside or outside of the network will need to be governed by those 3rd party compliance policies.
* A gaming company whose customer data is limited to a user name, play times, and high scores, is not as likely to suffer any significant consequences, if they engage in the risky behavior above. Will any unsecured data is at risk, the impact of that risk is small. Therefore the tolerance for risk in this case is high.
* A medium sized enterprise that provides carpet cleaning services to thousands of customers would fall in between these two tolerance extremes. There customer data may be more robust, containing details like address or phone number. Both could be considered PII & should be protected. However, there may not be any specific governance requirement mandating that the data be secured. From an IT perspective, the answer is simple, secure the data. From a business perspective, it may not be as simple. The business would need more details before they could determine a level of tolerance for this risk. 

The next section, shares a few sample questions that could help the business determine a level of risk tolerance for the use case above or others.

## Risk Tolerance Questions
This section lists conversation provoking questions in three categories: Loss Impact, Probability of Loss, & Mitigation Costs. When business and IT partner to address each of these areas, the decision to mitigate risk and the overall tolerance to a particular risk can easily be determined.

**Loss Impact**: Questions to determine the impact of a risk. These questions can be difficult (sometimes impossible) to answer. Quantifying the impact is best, but sometimes the conversation alone is enough to understand tolerance. Ranges are also acceptable, especially if they include assumptions that determined those ranges.

* Does this risk violate 3rd party compliance requirements?
* Does this risk violate internal corporate policies?
* Could this risk cost customers or market share? If so, can this impact be quantified?
* Could this risk create negative customer experiences? Are those experiences likely to impact sales or revenue realization?
* Could this risk create new legal liability? If so, is there a precedence for damage awards in these types of cases?
* Could this risk stop business operations? If so, how long would operations be down?
* Could this risk slow business operations? If so, how slow & how long?
* At this stage in the transformation, is this a one-off risk or will it repeat?
* Does the risk increase or decrease in frequency as the transformation progresses?
* Does the risk increase or decrease in probability over time?
* Is the risk time sensitive in nature? Will the risk pass or get worse, if not addressed?

These basic questions will lead to many more. After exploring a healthy dialogue, it is suggested that the relevant risks be recorded and when possible quantified.

**Mitigation costs**: Questions to determine the cost of mitigating or removing the risk. These questions can be fairly direct, especially when represented in a range.

* Is there a clear solution? What does it cost?
* Are there options to solving or mitigating this risk? What is the range of costs for those solutions?
* What is needed from the business to select the best, clear solution?
* What is needed from the business to validate costs?
* What other benefits can come from the solution that would mitigate this risk?

These questions over simplify the technical solutions needed to mitigate risks. However, these questions communicate those solutions in ways the business can quickly integrate into a decision process.

**Probability of Loss**: Questions to determine how likely it is that the risk will become a reality. This is the most difficult area to quantify. Instead it is suggested that the Cloud Governance Team create categories for communicating probability, based on the supporting data. The following questions can help create categories that are meaningful to the team.

* Has any research been done regarding the likelihood of this risk being realized?
* Can the vendor provide references or statistics on the likelihood of impact?
* Are there other companies in the relevant sector or vertical that have been hit by this risk?
* Look further, are there other companies in general that have been hit by this risk?
* Is this risk unique to something this company has done poorly?

After answering these questions & more questions as determined by the Cloud Governance Team, groupings of probability will likely emerge. The following are a few grouping samples to help get started:

* No indication: Not enough research has been completed to determine probability
* Low Risk: Current research suggests the risk is not likely to be realized
* Future risk: The current probability is Low Risk. However, continued adoption would trigger a fresh analysis
* Medium Risk: It's likely that the risk will impact the business
* High Risk: Overtime, it is increasing less likely that the business will avoid impact from this risk
* Declining Risk: The risk is Medium to High. However, actions in IT or business are reducing the likelihood of an impact.

**Determining Tolerance**

The three question sets above should fuel enough data to determine initial tolerances. When risk & probability are low, and mitigation cost is high, the business is unlikely to invest in remediation. When risk & probability are high, the business is likely to consider an investment, as long as the costs don't exceed the potential risks.

## Next Step

This type of conversation can help the business and IT evaluate tolerance more effectively.

These conversations can be used during the [creation of MVP policies and during incremental policy reviews](../governance/policy-compliance/understanding-business-risk.md).