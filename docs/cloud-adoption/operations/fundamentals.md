---
title: "Enterprise Cloud Adoption: Operational Fundamentals"
description: Guidance on operational fundamentals
author: petertay
---

# Establishing a Fundamentals Process

Once your enterprise is successfully operating a number of workloads in Azure, the next step is to establish a **cloud fundamentals** process to enumerate, implement, and iteratively review the **non-functional** requirements for these workloads. *Non-functional* requirements are those related to the expected operational behavior of the service. For example, availability, resiliency, and maintainability are all non-functional requirements of the workload.

Some of these non-functional requirements can be specified and implemented as the workload is developed. For example, features of the workload that are expected to have greater load requirements can be developed from the outset to be scalable by implementing [performance and scalability patterns](/azure/architecture/patterns/category/performance-scalability). However, some of these non-functional requirements can not be determined until the workload is in a production environment under normal user load. 

It is for this reason that your enterprise should undertake a cloud fundamentals process to fully understand the issues that result from running the workload in a production environment, determine how to remediate the issues, then resolve them. This article outlines a high level cloud fundamentals process that your enterpise can use to achieve this goal.

## Cloud fundamentals history

From the outset, the development of the Azure platform has been a continuous development and integration project undertaken by many teams across the company. It would be very difficult to ensure quality and consistency for a project of Azure's size and complexity without a robust process for enumerating and implementing the fundamental non-functional requirements on a regular basis. 

These processes followed by Microsoft form the basis for those outlined in this document.

## Understanding the problem

As you learned in [getting started](../getting-started/overview.md), the first step in an enterprise's digital transformation is identifying the business problems to be solved by adopting Azure. The next step is to determine a high level solution to the problem, such as migrating a workload to the cloud, or, adapting an existing on-premises service to include cloud functionality. Finally, the solution is designed and implemented.

During this process, the focus is on the *features* of the service. That is, there are a set of desired *functional* requirements for the service to perform. For example, a product delivery service requires features for determining the source and destination locations of the product, tracking the product during delivery, customer notifications, and others. 

In contrast, the *non-functional* requirements relate to properties such as the service's [availability](/azure/architecture/checklist/availability), [resiliency](/azure/architecture/resiliency/), and [scalability](/azure/architecture/checklist/scalability). These properties are not related to the functional requirements in that they do not directly affect the final function of any particular feature in the service. However, these non-functional requirements are related to the *performance* and *continuity* of the service.

Some non-functional requirements can be specified in terms of a service level agreement (SLA). For example, with regard to service continuity, an availability requirement for the service can be expressed as a percentage such as **available 99.99% of the time**.  Other non-functional requirements may be more difficult to define and may not be discoverable until the service is deployed to a production environment. For example, service logs from the production environment may reveal that a particular feature is behaving in an unplanned way that is adversely affecting scalability.

## Cloud fundamentals process

The key to maintaining the performance and continuity of an enterprise's services is to implement a *cloud fundamentals* process. At a high level, the process is as follows:

* Identify the enterprise's **mission-critical** business operations. Business operations are separate from any service functionality, and the *mission-critical* nature is related to the inability of the business to function if the operation can not be completed. For example, an online retailer may have a business operation such as "enable a customer to add an item to a shopping cart" or "process a credit card payment". If either of these operations were to fail, a customer would be unable to complete the transaction and the enterprise would fail to realize sales.
* Map these business operations to the services that support them. In the above shopping cart example, several services may be involved: an inventory stock management service, a shopping cart service, and others. In the credit card payment example above, an on-premises payment service may interact with a third-party payment processing service.
* Enumerate the dependencies between on-premises services and Azure services. In the above shopping cart example, the inventory stock management service may be hosted on-premises and ingest data input by employees from a physical warehouse but may store its data in an Azure service such as [Azure storage](/azure/storage/common/storage-introduction) or a database such as [Azure Cosmos DB](/azure/cosmos-db/introduction). 
* Define scorecard metrics for service operations and categorize these metrics in terms of non-functional design criteria such as availability, scalability, disaster recovery, and so on. Scorecard metrics are an expression of the desired criteria at which the service is expected to operate. These metrics can be expressed at any level of granularity that is appropriate for the service operation. For example, a scalability scorecard metric can be expressed as *green* for performing at the desired criteria, *yellow* for needing improvement to reach the desired criteria, and *red* for failing to meet the desired criteria.
* Once the scorecard metrics are defined, evaluate the operation of each mission-critical service. For each service operation with metrics that fall below an acceptable threshold, determine the cost of remediating the service to bring operation to an acceptable metric. If the cost of remediating the service is greater than the expected revenue generation of the service, move on to consider the non-tangible costs such as customer experience. For example, if customers have difficulty placing a succesful order using the service, they may choose a competitor instead. If the remediation passes each bar, move on to design and implement the remediation.

This process is iterative, and ideally your enterprise should have a team dedicated to owning it. This team should meet regularly to review existing remediation projects, kick off the fundamentals review of new workloads, and track the enterprise's overall scorecard. The team should have the authority to ensure accountability for remediation teams that are behind schedule or fail to meet metrics.

## Cloud fundamental team structure

The cloud fundamentals team is composed of three roles:
1. Business owner: this role requires sufficient knowledge of the business to identify and prioritize each "mission critical" business operation.
2. Business advocate: this role requires deep knowledge of the technology associated with each business operation. This role is responsible for breaking down business operations into discreet parts and mapping those parts to on-premises and cloud services and infrastructure. 
3. Engineering owner: the role or roles responsible for implmentation of the services associated with the business operation. These individuals may participate in the design, implementation, and deployment of any solutions for solving non-functional requirement issues uncovered by the cloud fundamentals team.
4. Service owner: the role or roles responsible for operating the business's applications and services. These individuals collect logging and usage data for these applications and services, and this logging and usage data is used both to identify issues and verify fixes once deployed.

## Fundamentals review example

Contoso is a online retailer that has recently added the sales of event tickets to their business. Contoso creates a new [e-commerce front-end on Azure](/azure/architecture/example-scenario/apps/ecommerce-scenario) to perform the following functions:
* Host the tickets sales web site front end. Users sign in to view concert details, order tickets, check the status of ordered tickets, and view and show tickets to gain entry to the concert venue. Images and other static content are served to the user through a content delivery network (CDN).
* Payments are made using a third party payment-processing system.
* Users input concert reviews after the event has occured, and machine learning is applied to the reviews to determine concert-goer sentiment which is provided to the concert promoter.

Contoso has recently sold tickets for several popular concerts, but has received complaints from customers that it's difficult to view concert details and order tickets once they go on sale. Several customers have also complained that they are randomly logged out of the site. Contoso has analyzed the performance of the application code and determined that there are no bugs in any feature that was cause the peformance degradations or issues with authentication. 

### Goals & Expected Outcomes

Contoso has made a large investment in the business relationship with concert promoters as well as the development of the concert ticket sales site. Selling concerts is a "mission critical" function for Contoso, so they prioritize fixing the issues with the site as its highest priority.

Contoso begins the fundamentals process by defining the service level objective (SLO) for the concert ticket sales application. The service level objective is comprised of the following objectives:
* recovery point objective (RPO), the maximum acceptable time period in which data might be lost during an incident. 
* recovery time objective (RTO), the maximum acceptable time period for the service to be unavailable.

The concert ticket sales application is very sensitive to data loss because user's ticket images are stored and would prevent a user being able to attend a concert they had paid for if the ticket image were unavailable. Contoso's customers are also very sensitive to the application being unavailable because the customers are not always able to discern between the application being down versus the site being available but too busy to serve them. In this case, a customer might feel that they are missing out on the opportunity to purchase tickets because other customers are able to buy them and the concert will soon be sold out. 

### Process

The cloud fundamentals team meets on a regular basis. The team meets on a monthly cadence and reports status and metrics to senior leadership on a quarterly basis.

Each time the team meets, they work through the following tasks:

1. The business owner and business advocate enumerate and determine the non-functional requirements for each of business operation with input from the engineering and service owners. For business operations that have been previously identified, the priority is reviewed and verified. For new business operations, a priority in the existing list is assigned. 
2. The engineering and service owners map the **current state** of business operations to the corresponding on-premises and cloud services. The mapping is composed of a list of the constituent components in each service oriented as a dependency tree. Once the list and dependency tree is generated, the **critical paths** through the tree are determined.
3. The engineering and service owners review the current state of operational logging and monitoring for the services listed in the previous step. Robust logging and monitoring are critical to identifying service components that are contributing to failures in meeting non-functional requirements. If sufficient logging and monitoring are not in place, a plan must be created and implemented to put it in place.
4. Scorecard metrics are created for new business operations. The scorecard is composed of the list of constituent components for each service identified in step 2 aligned with the non-functional requirements and a metric representing the how satisfactorily the component meets the requirement.
5. Next, for those constituent components that fail to meet non-functional requirements, a high-level solution is designed and an engineering owner is assigned. At this point the business owner and business advocate should establish a budget for the remediation work based on the expected revenue of the business operation. 
6. Finally, a review is conducted of the ongoing remediation work. Each of the scorecard metrics for work that is in flight is reviewed against the expected metrics. The service owner for those constituent components that are meeting metrics present logging and monitoring data to confirm that the metric is met. For those constituent components that are not meeting metrics, each engineering owner explains the issues that are preventing metrics from being reached and any new designs for remediation. 