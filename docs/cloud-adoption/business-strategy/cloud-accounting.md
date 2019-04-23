---
title: "CAF: What is cloud accounting"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of the concept of cloud accounting
author: BrianBlanchard
ms.date: 04/04/2019
---

<!-- markdownlint-disable MD026 -->

# CAF: What is cloud accounting?

As described in [Financial Models](financial-models.md), the cloud changes how IT accounts for costs. Various IT accounting models are much easier to support based on the way the Cloud allocates costs. As a result, it is important to understand how cloud costs should be accounted for prior to embarking on a cloud transformation journey. This article will outline the most common cloud accounting models for IT.

## Traditional IT accounting (cost center model)

Considering IT a cost center is often an accurate viewpoint. In the traditional IT accounting model, IT consolidates purchasing power for all IT assets. As discussed in [financial models](financial-models.md), that purchasing power consolidation may include software licenses, recurring charges for CRM licensing, purchase of employee desktops, and other large costs.

When IT serves as a cost center, the perceived value of IT is largely viewed through a procurement management lens. This makes it very difficult for the board or other executives to understand the true value IT provides. Procurement costs tends to taint the view of IT by outweighing any other value added by the organization. This view is why IT is often lumped into the CFO's or COO's responsibilities. This view of IT is very limited and can at times be very short sighted.

## Central IT accounting (profit center model)

To overcome the cost center view of IT, some CIOs opted for a Central IT model of accounting. In this type of model, IT is treated like a competing business unit and a peer to revenue producing business units. In some cases, this can be entirely logical. Organizations with a revenue producing services arm that drives tangible revenue streams through the sale of professional IT services, is a great example. Often times, Central IT models don't involve a heavy revenue generation function, making it very hard to justify the model.

Regardless of the revenue model, what makes Central IT accounting models unique is how the IT unit accounts for costs. In a traditional IT model, the IT team records costs and draws those costs from shared funds like Operations and Maintenance (O&M) or a dedicated Profit and Loss (P&L).

In a Central IT accounting model, the IT team marks up the services provided to account for overhead, management, and other estimated expenses. It then bills the competing business units for the marked up services. In this model, the CIO is expected to manage the P&L associated with the sale of those services. This can create inflated IT costs and contention between Central IT and business units, especially when IT needs to cut costs or isn't meeting agreed SLAs. During times of technology or market change, any new tech would cause a disruption to Central ITs P&L, which makes transformation very difficult.

## Chargeback

One of the common first steps towards breaking the cost center reputation is a chargeback model of accounting. This is especially common in smaller enterprises or highly efficient IT organizations. In the chargeback model, any IT costs that are associated with a specific business unit are treated like an operating expense in that business unit's budget. This reduces the cumulative costs effects on IT, allowing business values to show more clearly.

In a legacy on-premises model, chargeback is very difficult to realize because someone still has to carry the large capital expenses and depreciation. The ongoing conversion from capital expeditures to operating expenses associated with usage is a very difficult accounting exercise. It's a major reason for the creation of the traditional IT accounting model and central IT accounting model. The operating expenses model of cloud cost accounting is almost required to efficiently deliver a chargeback model.

However, this model should not be entered into lightly. The following are a few consequences that are unique to a chargeback model:

- Chargeback results in a massive reduction to the overall IT budget. For IT organizations that are inherently inefficient, or require a great deal of complex technical skills in operations or maintenance, this model can expose those expenses in an unhealthy way.
- Loss of control is a common consequence. In highly political environments, chargeback can result in loss of control and staff being reallocated to the business. This could create significant inefficiencies and reduce IT's ability to consistently meet SLAs or project requirements.
- Difficulty accounting for shared services is another common consequence. If the organization has grown through acquisition and is carrying technical debt as a result, there is likely a high percentage of shared services that have to be maintained to keep all of the systems working together effectively.

Cloud transformations include solutions to these and other consequences associated with a chargeback model. However, each of those solutions includes implementation and operating expenses. The CIO and CFO should carefully weigh the pros and cons of a chargeback model before considering this model.

## Showback or awareness-back

For larger enterprises, a showback or awareness-back model is a safer first step in the transition from cost center to value center. This model doesn't affect financial accounting. In fact, the P&Ls of each organization would be unchanged. The biggest shift is in mindset and awareness. In Show Back or Awareness Back model, IT manages the centralized, consolidated buying power as an agent for the business. In reports back to the business, IT would attribute any direct costs to the relevant business unit, thereby reducing the perceived budget consumed by IT directly. IT would also plan budgets based on the needs of the associated business units, allowing IT to more accurately account for costs associated to purely IT initiatives.

This model provides balance between a true chargeback model and more traditional models of IT accounting.

## Impact of cloud accounting models

The choice of accounting models is very important in system design. The choice of accounting model can affect subscription strategies, naming standards, tagging standards, and policy and blueprint designs.

Once the Cloud Accounting Model and [Global Markets](global-markets.md) decisions have been made with the business, enough information has been aggregated to [develop an Azure foundation](../ready/index.md).

> [!div class="nextstepaction"]
> [Develop an Azure foundation](../ready/index.md)
