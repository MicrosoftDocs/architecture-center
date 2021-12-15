---
title: Principles of the reliability pillar
description: Understand the principles of the reliability pillar. Review application framework tips to make the application more reliable.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - fasttrack-edit
  - overview
---

# Principles of the reliability pillar

Building a reliable application in the cloud is different from traditional application development. While historically you may have purchased levels of redundant higher-end hardware to minimize the chance of an entire application platform failing, in the cloud, we acknowledge up front that failures will happen. Instead of trying to prevent failures altogether, the goal is to minimize the effects of a single failing component.

## Application framework

These critical principles are used as lenses to assess the reliability of an application deployed on Azure. They provide a framework for the application assessment questions that follow.

To assess your workload using the tenets found in the Microsoft Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/).

- **Define and test availability and recovery targets:** Availability targets, such as Service Level Agreements (SLA) and Service Level Objectives (SLO), and Recovery targets, such as Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO), should be defined and tested to ensure application reliability aligns with business requirements.

- **Design applications to be resistant to failures:** Resilient application architectures should be designed to recover gracefully from failures in alignment with defined reliability targets.

- **Ensure required capacity and services are available in targeted regions:** Azure services and capacity can vary by region, so it's important to understand if targeted regions offer required capabilities.

- **Plan for disaster recovery:** Disaster recovery is the process of restoring application functionality in the wake of a catastrophic failure. It might be acceptable for some applications to be unavailable or partially available with reduced functionality for a period of time, while other applications may not be able to tolerate reduced functionality.

- **Design the application platform to meet reliability requirements:** Designing application platform resiliency and availability is critical to ensuring overall application reliability.

- **Design the data platform to meet reliability requirements:** Designing data platform resiliency and availability is critical to ensuring overall application reliability.

- **Recover from errors:** Resilient applications should be able to automatically recover from errors by leveraging modern cloud application code patterns.

- **Ensure networking and connectivity meets reliability requirements:** Identifying and mitigating potential network bottle-necks or points-of-failure supports a reliable and scalable foundation over which resilient application components can communicate.

- **Allow for reliability in scalability and performance:** Resilient applications should be able to automatically scale in response to changing load to maintain application availability and meet performance requirements.

- **Address security-related risks:** Identifying and addressing security-related risks helps to minimize application downtime and data loss caused by unexpected security exposures.

- **Define, automate, and test operational processes:** Operational processes for application deployment, such as roll-forward and roll-back, should be defined, sufficiently automated, and tested to help ensure alignment with reliability targets.

- **Test for fault tolerance:** Application workloads should be tested to validate reliability against defined reliability targets.

- **Monitor and measure application health:** Monitoring and measuring application availability is vital to qualifying overall application health and progress towards defined reliability targets.

## Next step

> [!div class="nextstepaction"]
> [Design](./design-checklist.md)
