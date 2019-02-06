---
title: "Fusion: What is a Cloud Policy Review?"
description: What is Cloud Policy Review?
author: BrianBlanchard
ms.date: 12/10/2018
---

<!-- markdownlint-disable MD026 -->

# Fusion: What is a cloud policy review?

A **cloud policy review** is the first step toward [governance maturity](../overview.md) in the cloud. The objective of this process is to modernize existing corporate IT policies. When completed, the updated policies provide an equivalent level of risk mitigation for cloud-based resources. This article explains the cloud policy review process and its importance.

## Why perform a Cloud Policy Review?

Most businesses manage IT through the execution of processes which alignment with governing policies. In small businesses, these policies may anecdotal and processes loosely defined. As businesses grow into large enterprises, policies and processes tend to be more clearly documented & consistently executed.

As companies mature corporate IT policies, dependencies on past technical decisions have a tendency to seep into governing policies. For instance, its common to see disaster recovery processes include policy that mandates offsite tape backups. This inclusion assumes a dependency on one type of technology (tape backups), that may no longer be the most relevant solution.

Cloud Transformations create a natural inflection point to reconsider the legacy policy decisions of the past. Technical capabilities and default processes change considerably in the cloud, as do the inherit risks. Leveraging the prior example, the tape backup policy stemmed from the risk of a single point of failure by keeping data in one location and the business need to minimize the risk profile by mitigating this risk. In a cloud deployment, there are several options that deliver the same risk mitigation, with much lower recovery time objectives (RTO). For instance:

- A cloud-native solution could enable geo-replication of the SQL Azure database
- A hybrid solution could leverage Azure Site Recovery (ASR) to replicate an IaaS workload to multiple datacenters
- A Cloud Design Principle (CDP) compliant solution could ... @Vic to populate a quick reference for resiliency

The justification for a cloud policy review is often referred to as "pushing a mess uphill". When executing a cloud transformation, policies often govern many of the tools, services, and processes available to the cloud adoption teams. If those policies are based on legacy technologies, they may hinder the team's efforts to drive change. In the worst case, important policies are entirely ignored by the migration team to enable workarounds. Neither is an acceptable outcome.

## The cloud policy review process

Cloud policy reviews align existing IT governance and IT security policies with the [five disciplines of Cloud Governance](../overview.md): [Cost Management](../cost-management/overview.md), [Security Baseline](../security-baseline/overview.md), [Identity Baseline](../identity-baseline/overview.md), [Resource Consistency](../resource-consistency/overview.md), and [Deployment Acceleration](../deployment-acceleration/overview.md).

For each of these disciplines, the review process follows these steps:

1. Review existing on-premises policies related to the specific discipline, looking for two key data points: legacy dependencies and identified business risks.
2. Evaluate each business risk by asking a simple question: "Does the business risk still exist in a cloud model?"
3. If the risk still exists, re-write the policy by documenting the necessary mitigation, not the technical solution.
4. Review the updated policy with the cloud adoption teams to understand potential solutions to the required mitigation.

## Example of a policy review for a legacy policy

To provide an example of the process, let's again use the tape backup policy in the prior section:

- A corporate policy mandates offsite tape backups for all production systems. In this policy, you can see two data points of interest:
  - Legacy dependency on a tape backup solution
  - An assumed business risk associated with the storage of backups in the same physical location as the production equipment.
- Does the risk still exist? Yes. Even in the cloud, a dependence on a single facility does create some risk. There is a lower probability of this risk affecting the business than was present in the on-premises solution, but the risk still exists.
- Rewrite of the policy. In the case of a datacenter-wide disaster, there must exist a means of restoring production systems within 24 hours of the outage in a different datacenter and different geographic location.
- Review with the cloud adoption teams. Depending on the solution being implemented, there are multiple means of adhering to this Resource Consistency policy.

## Tools to help create modern policies

To help accelerate the creation of modern policies, a set of sample policies is available in each of the five disciplines of Cloud Governance. Those sample policies will each start with one of three design assumptions:

- **Cloud Native**: The solution being deployed is cloud native and can capitalize on default solutions found in Azure, with minimal configuration.
- **Enterprise**: The solution being deployed is complex and requires a hybrid cloud deployment model. This necessitates more complex implementations of certain governance disciplines.
- **Cloud design principle (CDP) compliant**: The solution being deployed must adhere to the architecture axes defined in CDP, requiring a much higher degree of governance.  

For each discipline, a sample policy needs to be created at each of these levels. Each sample is meant to trigger thoughts and conversations inside the corporate environment. Note that these samples are not intended to be used as an alternative to a properly constructed corporate IT policy.
