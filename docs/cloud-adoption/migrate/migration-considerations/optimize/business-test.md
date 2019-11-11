---
title: "Guidance for business testing (UAT) during migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: A process within cloud migration that focuses on the tasks of migrating workloads to the cloud.
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Guidance for business testing (UAT) during migration

Traditionally seen as an IT function, user acceptance testing during a business transformation can be orchestrated solely by IT. However, this function is often most effectively executed as a business function. IT then supports this business activity by facilitating the testing, developing testing plans, and automating tests when possible. Although IT can often serve as a surrogate for testing, there is no replacement for firsthand observation of real users attempting to take advantage of a new solution in the context of a real or replicated business process.

> [!NOTE]
> When available, automated testing is a much more effective and efficient means of testing any system. However, cloud migrations often focus most heavily on legacy systems or at least stable production systems. Often, those systems aren't managed by thorough and well-maintained automated tests. This article assumes that no such tests are available at the time of migration.

Second to automated testing is testing of the process and technology changes by power users. Power users are the people that commonly execute a real-world process that requires interactions with a technology tool or set of tools. They could be represented by an external customer using an e-commerce site to acquire goods or services. Power users could also be represented by a group of employees executing a business process, such as a call center servicing customers and recording their experiences.

The goal of business testing is to solicit validation from power users to certify that the new solution performs in line with expectations and does not impede business processes. If that goal isn't met, the business testing serves as a feedback loop that can help define why and how the workload isn't meeting expectations.

## Business activities during business testing

During business testing, the first iteration is manually driven directly with customers. This is the purest but most time-consuming form of feedback loop.

- **Identify power users.** The business generally has a better understanding of the power users who are most affected by a technical change.
- **Align and prepare power users.** Ensure that power users understand the business objectives, desired outcomes, and expected changes to business processes. Prepare them and their management structure for the testing process.
- **Engage in feedback loop interpretation.** Help the IT staff understand the impact of various points of feedback from power users.
- **Clarify process change.** When transformation could trigger a change to business processes, communicate the change and any downstream impacts.
- **Prioritize feedback.** Help the IT team prioritize feedback based on the business impact.

At times, IT may employ analysts or product owners who can serve as proxies for the itemized business testing activities. However, business participation is highly encouraged and is likely to produce favorable business outcomes.

## IT activities during business testing

IT serves as one of the recipients of the business testing output. The feedback loops exposed during business testing eventually become work items that define technical change or process change. As a recipient, IT is expected to aid in facilitation, collection of feedback, and management of resultant technical actions. The typical activities IT performs during business testing include:

- Provide structure and logistics for business testing.
- Aid in facilitation during testing.
- Provide a means and process for recording feedback.
- Help the business prioritize and validate feedback.
- Develop plans for acting on technical changes.
- Identify existing automated tests that could streamline the testing by power users.
- For changes that could require repeated deployment or testing, study testing processes, define benchmarks, and create automation to further streamline power user testing.

## Next steps

In conjunction with business testing, [optimization of migrated assets](./optimize.md) can refine cost and workload performance.

> [!div class="nextstepaction"]
> [Benchmark and resize cloud assets](./optimize.md)
