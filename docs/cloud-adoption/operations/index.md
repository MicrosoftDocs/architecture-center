---
title: "Intro to the operational management"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Understand operational management within Cloud Adoption Framework.
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/19/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: operate
ms.custom: manage
---

# Establishing operational management practices in the cloud

Cloud adoption is a catalyst to enable business value. However, real business value is realized through on-going, stable operations of the technology assets deployed to the cloud. This section of the Cloud Adoption Framework, guides the reader through various transitions into operational management in the cloud.

## Actionable Best Practices

Modern operations management solutions create a multi-cloud view of operations. Assets managed through the following best practices may live in the cloud, in an existing data center, or even in a competing cloud provider. Currently, the framework includes two reference best practices to guide operations management maturity in the cloud:

* [Azure Server Management](./azure-server-management/index.md): On-boarding guide to incorporate the cloud-native tools and services needed to manage operations.
* [Hybrid monitoring](./monitor/index.md): Many customers have already made a substantial investment in System Center Operations Manager. For those customers, this guide to hybrid monitoring helps to compare and contrast the cloud-native reporting tools with Operations Manager tooling. This comparison will make it easier to decide which tools to use for operational management.

## Cloud Operations

Both of these best practices build towards a future state methodology for operations management.

![CAF Manage methodology](../_images/operate/caf-manage.png)

**Business Alignment:** In the Manage methodology, all workloads are classified by criticality and business value. That classification can then be measured through an impact analysis, which calculates the lost value associated with performance degradation or business interruptions. Using that tangible revenue impact, cloud operations teams can work with the business to establish a commitment that balances cost and performance.

**Cloud operations disciplines:** Once the business is aligned, it is much easier to track and report on the proper disciplines of cloud operations for each workload. Making decisions along each discipline can then be converted to commitment terms which can be easily understood by the business. This collaborative approach makes the business stakeholder a partner in finding the right balance of cost and performance.

* Inventory & visibility: At minimum, operations management requires a means of inventorying assets and creating visibility into the run state of each asset.
* Operational compliance: Regularly management of configuration, sizing, cost, and performance of assets is key to maintaining performance expectations.
* Protect & recover: Minimizing operational interruptions and expediting recovery each help to avoid performance losses and revenue impacts. Detection and recovery are essential aspects of this discipline.
* Platform operations: All IT environments contain a set of commonly used platforms. Those platforms could include data stores like SQL Server or HDInsights. Other common platforms could include container solutions like kubernetes or AKS. Regardless of the platforms, the platform operations maturity focuses on customizing operations based on how those common platforms are deployed, configured, and used by workloads.
* Workload operations: At the highest level of operational maturity, cloud operations teams are able tune operations for workloads that are crucial to the success of the business. For those high-criticality workloads, available data can aid in automating remediation, sizing, or protection of workloads based on their utilization.

Additional guidance like the [Design Review Framework (Codename: Cloud Design Principles)](/azure/architecture/reliability/) can aid in making detailed architectural decisions regarding each workload, within the disciplines above.

This section of the cloud adoption framework will build on each of these topics to mature cloud operations within your organization.
