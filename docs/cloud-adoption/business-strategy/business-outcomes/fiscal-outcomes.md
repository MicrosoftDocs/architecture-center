---
title: "CAF: Examples of fiscal outcomes"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
description: Examples of fiscal outcomes
author: BrianBlanchard
ms.date: 10/10/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Examples of fiscal outcomes

At the top level, fiscal conversations consist of three basic concepts:

* Revenue: Will more money come into the business as a result of the sales of goods or services.
* Cost: Will less money be spent in the creation, marketing, sales, or delivery of goods or services.
* Profit: While rare, some transformations can both increase revenue and decrease costs. This is a profit outcome.

The remainder of this article will explain these fiscal outcomes in the context of a cloud transformation.

> [!NOTE]
> The following examples are hypothetical and should not be seen as a guarantee of returns when adopting any cloud strategy.

## Revenue outcomes

### New revenue streams

The cloud allows for opportunities to deliver new products to customers or deliver existing products in a new way. New Revenue Streams are innovative, entrepreneurial, and exciting to many people in the business world. New revenue streams are also prone failure and are seen in many companies as high risk. When they are proposed by IT, there is a high likelihood of push back. To add credibility to these outcomes, partner with business leader who is a proven innovator. Validation of the revenue stream early in the process will help avoid roadblocks from the business.

* Example: A company has been selling books for over a hundred years. An employee of the company realizes that the content can be delivered electronically and creates a device that can be sold in the bookstore, which allows the same books to be downloaded directly, driving $X in new book sales.

### Revenue increases

With global scale and digital reach, the cloud allows businesses to increase revenue of existing revenue streams. Often times, this type of outcome would come from an alignment with sales or marketing leadership.

* Example: A company that sells widgets could sell more widgets, if the sales people had the ability to securely access the company’s digital catalog and stock levels. Unfortunately, that data is only in the company’s ERP system, which can only be accessed via a network connected device. Creating a service façade to interface with the ERP, exposing the catalog list and non-sensitive stock levels to an application in the cloud would allow the sales people to access the data they need while onsite with a customer. Extending AD using Azure AD and integrating role-based access into the application would allow the company to ensure the data stays safe. This simple project could impact revenue from an existing product line by X%.

### Profit increases

Seldom does a single effort simultaneously increase revenue and decrease costs. However, when it does, align the outcome statements from one or more of the revenue outcomes with one ore more of the cost outcomes to communicate the desired outcome.

## Cost outcomes

### Cost reduction

Cloud computing can reduce capital expenses (CapEx) related to buying hardware and software, setting up datacenters, running on-site datacenters, etc.… The racks of servers, round-the-clock electricity for power and cooling, and IT experts for managing the infrastructure adds up fast. Shutting down a datacenter can reduce CapEx commitments. This is sometimes referred to as "getting out of the datacenter business". Cost reduction is generally measured in dollars in the current budget, which could span one to five years depending on how the CFO manages finances.

* Example 1: A company’s datacenter accounts for a large percentage of the annual IT budget. IT chooses to execute an Operational Transformation an migrates the assets in that datacenter to infrastructure as a service (IaaS) solutions, creating a three-year cost reduction.
* Example 2: A holding company recently acquired a new company. In the acquisition, the terms dictate that the new entity be removed from the current datacenters within six months. Failure to do so will result in a $1M/month fine to the holding company. Moving the digital assets to the cloud in an Operational Transformation could allow for a quick decommission of the old assets.
* Example 3: An income tax company that caters to consumers experiences 70% of annual revenue during the first three months of the year. The remainder of the year, their large IT investment sits relatively dormant. An Operational Transformation would allow IT to deploy the compute/hosting capacity required for those three months. During the remaining nine months, the IaaS costs could be significantly reduced by shrinking the compute footprint.

### Coverdell

Coverdell modernizes their infrastructure to drive record cost savings with Azure. Coverdell’s decision to invest in Azure, and to unite their network of websites, applications, data, and infrastructure within this environment, led to more cost savings than the company could have ever expected. The migration to an Azure-only environment eliminated $54,000 USD in monthly costs for colocation services. With the company’s new, united infrastructure alone, Coverdell expects to save an estimated $1M USD over the next two to three years.
"Having access to the Azure technology stack opens the door for some scalable, easy-to-implement, and highly available solutions that are cost effective. This allows our architects to be much more creative with the solutions they provide."
Ryan Sorensen, Director of Application Development and Enterprise Architecture
Coverdell

### Cost avoidance

Terminating datacenters can also result in cost avoidance by preventing future refresh cycles. A refresh cycle is the process of buying new hardware and software to replace aging on-premises systems. In Azure, hardware and OS are routinely maintained, patched, and refreshed at no additional cost to customers. This allows a CFO to remove planned future spend from long term financial forecasts. Cost is avoidance is measured in dollars. It differs from Cost Reduction, in that it generally focuses on a future budget that has not been fully approved yet.

* Example: A company’s datacenter is up for a lease renewal in six months. That datacenter has been in service for eight years. Four years ago, all of the servers were refreshed and virtualized costing the company $ millions. Next year, the company plans on refreshing the hardware and software again. Migrating the assets in that datacenter, as part of an Operational Transformation, would create cost avoidance, by removing the planned refresh from next year’s forecasted budget. It could also produce cost reduction by decreasing or eliminating the real estate lease costs.

### CapEx versus OpEx

Before discussing Cost Outcomes, it is important to understand the two primary cost options: Capital Expenses (CapEx) and Operational Expenses (OpEx).

The following terms are intended to create an understanding of the differences between CapEx and OpEx when speaking with the business about your Transformation Journey.

* **Capital** is the money or assets owned by a business to contribute to a particular purpose, such as, increase server capacity or building an application.
* **Capital Expense (CapEx)** is an expense that that generates benefits over a long period. Such an expense is generally non-recurring and results in the acquisition of permanent assets. Building an application could qualify as a capital expense.
* **Operating Expense (OpEx)** is an expense that is an ongoing cost of doing business. Consuming cloud services in a pay as you go model could qualify as an operating expense.
* Asset is an economic resource that can be owned or controlled to produce value. Servers, Data Lakes, and Applications could all be considered assets.
* **Depreciation** is how the value of an asset decreases over time. More relevant to CapEx/OpEx conversation, it is how the costs of an asset are allocated across the periods in which they are used. For instance, if you build an application this year but it is expected to have an average shelf-life of five years (like most commercial applications), then the cost of the dev team and necessary tools required to create and deploy the code base would be depreciated evenly over five years.
* **Valuation** is the process of estimating how much a company is worth. In most industries, valuation is based on the company’s ability to generate revenue and profit, while respecting the operating costs required to create the goods that provide that revenue. In some industries like retail, or in some transaction types like private equity, Assets and depreciation can play a big part in the company’s valuation.

It is often a safe bet that various executives, including the CIO, debate the best use of capital to grow the company in the desired direction. Giving the CIO a means of converting highly competitive CapEx conversations into clear OpEx accountability could be an attractive outcome by itself. In many industries, chief financial officers (CFOs) are actively seeking ways of better associating fiscal accountability to the cost of goods being sold.

However, before associating any Transformation Journey with this type of CapEx to OpEx conversion, it is wise to meet with members of the CFO or CIO teams to see if the business prefers CapEx or OpEx cost structures. In some organizations, the though of reducing CapEx in favor of OpEx, is actually a highly undesirable outcome. As mentioned above, this is sometimes seen in retail, holding, and private equity companies that place higher value on traditional asset accounting models, which place little value on IP. It can also be seen in organizations that had negative experiences when outsourcing IT staff or other functions in the past.

If OpEx is desirable, the following example could be a viable business outcome:

* Example: The company’s datacenter is currently depreciating at $X per year for the next three years. It is expected to require an additional $Y to refresh the hardware next years. We can convert all of that CapEx to an OpEx model at an even rate of $Z/month, allowing for better management and accountability of the operating costs of technology.
