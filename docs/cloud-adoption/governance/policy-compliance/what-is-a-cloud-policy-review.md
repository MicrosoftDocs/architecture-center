---
title: "Enterprise Cloud Adoption: What is a Cloud Policy Review?"
description: What is Cloud Policy Review?
author: BrianBlanchard
ms.date: 10/10/2018
---

# Enterprise Cloud Adoption: What is Cloud Policy Review?

A Cloud Policy Review is the first step to prepare for [governance maturity](../overview.md) in the cloud. The objective of this process is to modernize existing corporate IT policies. When completed, the updated policies should provide an equivalent level of risk mitigation from within a cloud context. This article will explain the Cloud Policy Review process and it's importance.

## Why perform a Cloud Policy Review?

Most businesses manage IT through the execution of processes which alignment with governing policies. In small businesses, these policies may anecdotal and processes loosely defined. As businesses grow into large enterprises, policies and processes tend to be more clearly documented & consistently executed.

As companies mature corporate IT policies, dependencies on past technical decisions have a tendency to seep into governing policies. For instance, its common to see disaster recovery processes include a policy that mandates offsite tape backups. This inclusion assumes a dependency on one type of technology (Tape backups), that may no longer be the most relevant solution.

Cloud Transformations create a natural inflection point to reconsider the legacy policy decisions of the past. Technical capabilities and default processes change considerably in the cloud. As do the inherit risks. Leveraging the prior example, the Tape Backup policy steamed from the risk of a single point of failure by keeping data in one location & the business need to minimize the risk profile by mitigating this risk. In a cloud deployment, there are several options that deliver the same risk mitigation, with much lower Recovery Time Objectives (RTO). For instance:

* A cloud-native solution could simple enable geo-replication of the SQL Azure database
* A hybrid solution could leverage Azure Site Recovery (ASR) to replicate an IaaS workload to multiple datacenters
* A Cloud Design Principle (CDP) compliant solution could ... @Vic to populate a quick reference for resiliency

The justification for a Cloud Policy Review is often referred to as pushing a mess up hill. When executing a Cloud Transformation, policies will govern many of the tools, services, & processes available to the Cloud Migration team. If those policies are grounded in legacy technologies, they will hinder the teams ability to impact change. In the worst cases, important policies are entirely ignored by the migration team to enable workarounds. Neither is an acceptable outcome.

## Cloud Policy Review Process

Cloud policy reviews seek to align existing IT governance and IT security policies with the [Five Disciplines of Cloud governance](../overview.md): [Cost Management](../cost-management/overview.md), [Security Management](../security-management/overview.md), [Identity Management](../identity-management/overview.md), [Resource Management](../resource-management/overview.md), and [Configuration Management](../configuration-management/overview.md).

For each of these disciplines, this process calls for the following steps:

* Review existing on-premise policies related to the specific discipline, looking for two key data points: legacy dependencies & identified business risks.
* Evaluate each business risk by asking a simple question: "Does the business risk still exist in a cloud model?"
* If the risk still exists, re-write the policy by documenting the necessary mitigation, not the technical solution
* Review the updated policy with the Cloud Migration team to understand potential solutions to the required mitigation

## Example of a policy review for a legacy policy

To provide an example of the process, lets again leverage the Tape Backup policy in the prior section:

* A corporate policy mandates offsite tape backups for all production systems.In this policy, we can see the two data points of interest:
    * Legacy dependency on Tape Backup solution
    * An assumed business risk associated with the storage of backups in the same physical location as the production equipment.
* Does the risk still exist? Yes. Even in the cloud, a dependence on a single facility does create some risk. There is a lower probability of this risk impacting the business, then was present in the on-prem solution, but the risk still exists.
* Rewrite of the policy: In the case of a datacenter wide disaster, there must exist a means of restoring production systems within 24 hours of the outage in a different datacenter & different geographic location
* Review with the Cloud Migration team: Depending on the solution being implemented, there are multiple means of adhering to this resource management policy.

## Tools to help create modern policies

To help accelerate the creation of modern policies, a set of sample policies will be available in each of the Five Disciplines of Cloud Governance. Those sample policies will each start with one of three design assumptions:

* Cloud Native: The solution being deployed is cloud native and can capitalize on default solutions found in Azure, with minimal configuration.
* Enterprise: The solution being deployed is complex & requires a hybrid cloud deployment model. This necessitates more complex implementations of certain governance disciplines.
* Cloud Design Principle (CDP) compliant: The solution being deployed must adhere to the architecture axes defined in CDP, requiring a much higher degree of governance.  

For each discipline a sample policy will be created at each of these levels. That sample is meant to trigger thoughts and conversations inside of a corporate environment. Those samples are not intended to be used as an alternative to a properly constructed corporate IT policy.