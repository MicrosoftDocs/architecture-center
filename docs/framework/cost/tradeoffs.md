---
title: Tradeoffs for cost
description: View tradeoffs you may decide to make when optimizing a workload for cost, such as with reliability, performance efficiency, security, or operational excellence.
author: david-stanford
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure
categories:
  - cost-optimization
ms.custom:
  - article
---

# Tradeoffs for cost

As you design the workload, consider tradeoffs between cost optimization and other aspects of the design, such as security, scalability, resilience, and operability.

**What is most important for the business: lowest cost, no downtime, high throughput?**
***
An optimal design doesn't equate to a low-cost design. There might be risky choices made in favor of a cheaper solution.

## Cost vs reliability
Cost has a direct correlation with reliability.

**Does the cost of high availability components exceed the acceptable downtime?**
***

Overall Service Level Agreement (SLA), Recovery Time Objective (RTO), and Recovery Point Objective (RPO) may lead to expensive design choices. If your service SLAs, RTOs, and RPOs times are short, then higher investment is inevitable for high availability and disaster recovery options.

For example, to support high availability, you choose to host the application across regions. This choice is costlier than single region because of the replication costs or the need provisioning extra nodes. Data transfer between regions will also add cost.

If the cost of high availability exceeds the cost of downtime, you can save by using Azure platform-managed replication and recover data from the backup storage.

For resiliency, availability, and reliability considerations, see the [Reliability](../resiliency/principles.md?branch=master) pillar.

## Cost vs performance efficiency

Boosting performance will lead to higher cost.

Many factors impact performance.

**Fixed or consumption-based provisioning**. Avoid cost estimation of a workload at consistently high utilization. Consumption-based pricing will be more expensive that the equivalent provisioned pricing. Smooth out the peaks to get a consistent flow of compute and data. Ideally, use manual and autoscaling to find the right balance. Scaling up is more expensive than scaling out.

**Azure regions**. Cost scales directly with number of regions. Locating resources in cheaper regions shouldn't negate the cost of network ingress and egress or by degraded application performance because of increased latency.

**Caching**. Every render cycle of a payload consumes both compute and memory. You can use caching to reduce load on servers and save with pre-canned storage and bandwidth costs, and the savings can be dramatic, especially for static content services.

While caching can reduce cost, there are some performance tradeoffs. For example, Azure Traffic Manager pricing is based on the number of DNS queries that reach the service. You can reduce that number through caching and configure how often the cache is refreshed. Relying on the cache that isn't frequently updated will cause longer user failover times if an endpoint is unavailable.

**Batch or real-time processing**. Using dedicated resources for batch processing long running jobs will increase the cost. You can lower cost by provisioning Spot VMs but be prepared for the job to be interrupted every time Azure evicts the VM.

For performance considerations, see the [Performance Efficiency](../scalability/overview.md) pillar.

## Cost vs security
Increasing security of the workload will increase cost.

As a rule, don't compromise on security. For certain workloads, you can't avoid security costs. For example, for specific security and compliance requirements, deploying to differentiated regions will be more expensive. Premium security features can also increase the cost. There are areas you can reduce cost by using native security features. For example, avoid implementing custom roles if you can use built-in roles.

For security considerations, see the [Security Pillar](../security/overview.md).

## Cost vs operational excellence

Investing in systems monitoring and automation might increase the cost initially but over time will reduce cost.
- IT operations processes like user or application access provisioning, incident response, and disaster recovery should be integrated with the workload.
- Cost of maintaining infrastructure is more expensive. With PaaS or SaaS services, infrastructure, platform management services, and additional operational efficiencies are included in the service pricing.

For operational considerations, see the [Operational Excellence](../devops/overview.md) pillar.
