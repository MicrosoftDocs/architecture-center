---
title: Principles of cost optimization
description: Understand cost optimization principles, which are a series of important considerations that can help achieve both business objectives and cost justification.
author: david-stanford
ms.date: 05/13/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - overview
products:
  - azure
categories:
  - management-and-governance
---

# Principles of cost optimization

A cost-effective workload is driven by business goals and the return on investment (ROI) while staying within a given budget. The principles of cost optimization are a series of important considerations that can help achieve both business objectives and cost justification.

To assess your workload using the tenets found in the Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

## Keep within the cost constraints

Every design choice has cost implications. Before choosing an architectural pattern, Azure service, or a price model for the service, consider the budget constraints set by the company. As part of design, identify acceptable boundaries on scale, redundancy, and performance against cost. After estimating the initial cost, set budgets and alerts at different scopes to measure the cost. One of cost drivers can be unrestricted resources. These resources typically need to scale and consume more cost to meet demand.

## Aim for scalable costs

A key benefit of the cloud is the ability to scale dynamically. The workload cost should scale linearly with demand. You can save cost through automatic scaling. Consider the usage metrics and performance to determine the number of instances. Choose smaller instances for a highly variable workload and scale out to get the required level of performance, rather than up. This choice will enable you to make your cost calculations and estimates granular.

## Pay for consumption

Adopt a leasing model instead of owning infrastructure. Azure offers many SaaS and PaaS resources that simplify overall architecture. The  cost of hardware, software, development, operations, security, and data center space included in the pricing model.

Also, choose pay-as-you-go over fixed pricing. That way, as a consumer, you're charged for only what you use.

## Right resources, right size

Choose the right resources that are aligned with business goals and can handle the performance of the workload. An inappropriate or misconfigured service can impact cost. For example, building a multi-region service when the service levels don't require high-availability or geo-redundancy will increase cost without any reasonable business justification.

Certain infrastructure resources are delivered as fix-sized building blocks. Ensure that these blocks are adequately sized to meet capacity demand, deliver expected performance without wasting resources.

## Monitor and optimize

Treat cost monitoring and optimization as a process, rather than a point-in-time activity. Conduct regular cost reviews and measure and forecast the capacity needs so that you can provision resources dynamically and scale with demand. Review the cost management recommendations and take action to optimize workload costs.  Use [Advisor Score](/azure/advisor/azure-advisor-score) to identify the greatest opportunities for cost optimization for your workload.

If you're just starting in this process review [enable success during a cloud adoption journey](/azure/cloud-adoption-framework/getting-started/enable).
