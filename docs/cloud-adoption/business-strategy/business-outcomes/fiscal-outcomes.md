---
title: "Examples of fiscal outcomes"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Examples of fiscal outcomes
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: strategy
ms.custom: governance
---

# Examples of fiscal outcomes

At the top level, fiscal conversations consist of three basic concepts:

- **Revenue**: Will more money come into the business as a result of the sales of goods or services.
- **Cost**: Will less money be spent in the creation, marketing, sales, or delivery of goods or services.
- **Profit**: Although they're rare, some transformations can both increase revenue and decrease costs. This is a profit outcome.

The remainder of this article explains these fiscal outcomes in the context of a cloud transformation.

> [!NOTE]
> The following examples are hypothetical and should not be considered a guarantee of returns when adopting any cloud strategy.

## Revenue outcomes

### New revenue streams

The cloud can help create opportunities to deliver new products to customers or deliver existing products in a new way. New revenue streams are innovative, entrepreneurial, and exciting for many people in the business world. New revenue streams are also prone to failure and are considered by many companies to be high risk. When revenue-related outcomes are proposed by IT, there will likely be resistance. To add credibility to these outcomes, partner with a business leader who's a proven innovator. Validation of the revenue stream early in the process helps avoid roadblocks from the business.

- **Example**: A company has been selling books for over a hundred years. An employee of the company realizes that the content can be delivered electronically. The employee creates a device that can be sold in the bookstore, which allows the same books to be downloaded directly, driving $X in new book sales.

### Revenue increases

With global scale and digital reach, the cloud can help businesses to increase revenues from existing revenue streams. Often, this type of outcome comes from an alignment with sales or marketing leadership.

- **Example**: A company that sells widgets could sell more widgets, if the salespeople could securely access the company’s digital catalog and stock levels. Unfortunately, that data is only in the company’s ERP system, which can be accessed only via a network-connected device. Creating a service façade to interface with the ERP and exposing the catalog list and nonsensitive stock levels to an application in the cloud would allow the salespeople to access the data they need while onsite with a customer. Extending on-premises Active Directory using Azure Active Directory (Azure AD) and integrating role-based access into the application would allow the company to help ensure that the data stays safe. This simple project could affect revenue from an existing product line by _x%_.

### Profit increases

Seldom does a single effort simultaneously increase revenue and decrease costs. However, when it does, align the outcome statements from one or more of the revenue outcomes with one or more of the cost outcomes to communicate the desired outcome.

## Cost outcomes

### Cost reduction

Cloud computing can reduce capital expenses for hardware and software, setting up datacenters, running on-site datacenters, and so on. The costs of racks of servers, round-the-clock electricity for power and cooling, and IT experts for managing the infrastructure add up fast. Shutting down a datacenter can reduce capital expense commitments. This is commonly referred to as "getting out of the datacenter business." Cost reduction is typically measured in dollars in the current budget, which could span one to five years depending on how the CFO manages finances.

- **Example #1**: A company's datacenter consumes a large percentage of the annual IT budget. IT chooses to conduct a cloud migration and transitions the assets in that datacenter to infrastructure as a service (IaaS) solutions, creating a three-year cost reduction.
- **Example #2**: A holding company recently acquired a new company. In the acquisition, the terms dictate that the new entity should be removed from the current datacenters within six months. Failure to do so will result in a fine of 1 million USD per month to the holding company. Moving the digital assets to the cloud in a cloud migration could allow for a quick decommission of the old assets.
- **Example #3**: An income tax company that caters to consumers experiences 70 percent of its annual revenue during the first three months of the year. The remainder of the year, its large IT investment sits relatively dormant. A cloud migration could allow IT to deploy the compute/hosting capacity required for those three months. During the remaining nine months, the IaaS costs could be significantly reduced by shrinking the compute footprint.

### Example: Coverdell

Coverdell modernizes their infrastructure to drive record cost savings with Azure. Coverdell’s decision to invest in Azure, and to unite their network of websites, applications, data, and infrastructure within this environment, led to more cost savings than the company could have ever expected. The migration to an Azure-only environment eliminated 54,000 USD in monthly costs for colocation services. With the company’s new, united infrastructure alone, Coverdell expects to save an estimated 1 million USD over the next two to three years.

> "Having access to the Azure technology stack opens the door for some scalable, easy-to-implement, and highly available solutions that are cost effective. This allows our architects to be much more creative with the solutions they provide."  
> Ryan Sorensen  
> Director of Application Development and Enterprise Architecture  
> Coverdell

### Cost avoidance

Terminating a datacenter can also provide cost avoidance, by preventing future refresh cycles. A refresh cycle is the process of buying new hardware and software to replace aging on-premises systems. In Azure, hardware and OS are routinely maintained, patched, and refreshed at no additional cost to customers. This allows a CFO to remove planned future spend from long-term financial forecasts. Cost avoidance is measured in dollars. It differs from cost reduction, generally focusing on a future budget that has not been fully approved yet.

- **Example**: A company’s datacenter is up for a lease renewal in six months. The datacenter has been in service for eight years. Four years ago, all servers were refreshed and virtualized, costing the company millions of dollars. Next year, the company plans to refresh the hardware and software again. Migrating the assets in that datacenter as part of a cloud migration would allow cost avoidance by removing the planned refresh from next year’s forecasted budget. It could also produce cost reduction by decreasing or eliminating the real estate lease costs.

### Capital expenses vs. operating expenses

Before you discuss cost outcomes, it's important to understand the two primary cost options: capital expenses and operating expenses.

The following terms will help you understand the differences between capital expenses and operating expenses during business discussions about a transformation journey.

- **Capital** is the money and assets owned by a business to contribute to a particular purpose, such as increasing server capacity or building an application.
- **Capital expenditures** generate benefits over a long period. These expenditures are generally nonrecurring and result in the acquisition of permanent assets. Building an application could qualify as a capital expenditure.
- **Operating expenditures** are ongoing costs of doing business. Consuming cloud services in a pay-as-you-go model could qualify as an operating expenditure.
- **Assets** are economic resources that can be owned or controlled to produce value. Servers, data lakes, and applications can all be considered assets.
- **Depreciation** is a decrease in the value of an asset over time. More relevant to the capital expense versus operating expense conversation, depreciation is how the costs of an asset are allocated across the periods in which they are used. For instance, if you build an application this year but it's expected to have an average shelf life of five years (like most commercial apps), the cost of the dev team and necessary tools required to create and deploy the code base would be depreciated evenly over five years.
- **Valuation** is the process of estimating how much a company is worth. In most industries, valuation is based on the company’s ability to generate revenue and profit, while respecting the operating costs required to create the goods that provide that revenue. In some industries, such as retail, or in some transaction types, such as private equity, assets and depreciation can play a large part in the company’s valuation.

It is often a safe bet that various executives, including the chief investment officer (CIO), debate the best use of capital to grow the company in the desired direction. Giving the CIO a means of converting contentious capital expense conversations into clear accountability for operating expenses could be an attractive outcome by itself. In many industries, chief financial officers (CFOs) are actively seeking ways of better associating fiscal accountability to the cost of goods being sold.

However, before you associate any transformation journey with this type of capital versus operating expense conversion, it's wise to meet with members of the CFO or CIO teams to see which cost structure the business prefers. In some organizations, reducing capital expenses in favor of operating expenses is a highly *undesirable* outcome. As previously mentioned, this approach is sometimes seen in retail, holding, and private equity companies that place higher value on traditional asset accounting models, which place little value on IP. It's also seen in organizations that had negative experiences when they outsourced IT staff or other functions in the past.

If an operating expense model is desirable, the following example could be a viable business outcome:

- **Example**: The company’s datacenter is currently depreciating at _x USD_ per year for the next three years. It is expected to require an additional _y USD_ to refresh the hardware next year. We can convert the capital expenses to an operating expense model at an even rate of _z USD_ per month, allowing for better management of and accountability for the operating costs of technology.

## Next steps

Learn more about [agility outcomes](./agility-outcomes.md).

> [!div class="nextstepaction"]
> [Agility outcomes](./agility-outcomes.md)
