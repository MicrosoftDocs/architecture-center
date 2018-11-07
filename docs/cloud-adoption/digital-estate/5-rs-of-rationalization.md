---
title: "Enterprise Cloud Adoption: What options are available when rationalizing a digital estate?"
description: Descriptions of commonly used tools for assessing on-prem infrastructure
author: BrianBlanchard
ms.date: 10/11/2018
---

# Enterprise Cloud Adoption: What options are available when rationalizing a digital estate?

Cloud Rationalization is the process of evaluating assets to determine the best approach to hosting the asset in the cloud.
Once an [approach](approach.md) has been determined and [inventory](inventory.md) has been aggregated, Cloud Rationalization can begin.

## 5 Rs rationalization

Cloud Rationalization is an evolution of application rationalization, the process of removing duplicated applications in favor of standardized solutions. When the thought of application rationalization emerged in the early 2000s, there were originally only four or five options to rationalizing an inventory of applications.

As time progressed additional options have emerged, making the process slightly more complex. The [3 new Rs in Rationalization](#the-3-new-rs-in-rationalization) deal specifically with cloud compatibility and approaches to overcome current state limitations before a longer term rationalization decision can be made.

For assistance aligning rationalization options to specific transformation, see the article on [rationalization](rationalize.md).

### Retire

Processes and business needs change. Some applications or workloads no longer provide a business purposes. Detecting these applications can help reduce investments and operational costs associated with a transformation. 

When efficiency gains are important business outcomes, this R can't be over indexed. The choice of cloud vendor and future state architecture can significantly impact cost savings. However, one of the greatest cost savings in the cloud comes from the termination of unused/underused applications that can be retired in parallel to the cloud transformation effort.

### Replace

Solutions are generally implemented using the best technology and approach available at the time. In some cases, Software as a Service (SaaS) applications can meet all of the functionality required of the hosted application. In these scenarios, a workload could be slated for future replacement, effectively removing it from the transformation effort.

### Re-host

Also known as "Lift & Shift", a re-host effort moves the current state asset to the chosen cloud provider, with minimal change to current state.

### Refactor

Platform as a Service (PaaS) options can reduce operational costs associated with many applications. It can be prudent to slightly refactor an application to fit a PaaS based model.

Refactor also refers to the application development process of refactoring code to allow an application to deliver on new business opportunities.

### Rebuild

In some scenarios, the delta that must be overcome to carry forward an application can be too large to justify further investment. This is especially true for applications that used to meet the needs of the business, but are no unsupported &/or misaligned with how the business processes are executed today.

## The 3 new Rs in Rationalization

### Remediate

This is a common rationalization step for applications that are being moved to the cloud via a Re-host approach. 

Operating systems reach end of life, middleware platforms drops support for old versions. The cloud is no exception. When assets don't meet basic compatibility requirements, they may need an interim rationalization state called Remediation. During this process, the solution is brought up to more current standards before it can be fully rationalized.

### Re-architect

Some aging applications aren't compatible with cloud providers because of the architectural decisions made when the application was built. In these cases, the application may need to be re-architected prior to transformation. 

In other cases, applications that are cloud compatible, but not cloud native benefits, may produce costs & operational efficiencies by re-architecting the solution to be a cloud native application..

### Reconfigure

The options for configuration and deployment management has grown since the concept of application rationalization was coined. For many solutions, it could make more sense to change the deployment configuration of a solution by creating an automated devops deployment of the workload. In other cases, it may more sense to package the solution in a container prior to re-hosting.

When an application needs to be re-architected or assets require significant remediation, reconfiguration may produce a faster, lower cost alternative. If an investment is already being made in DevOps or Containers, Reconfigure is likely to be a more common decision during inventory rationalization.

## Next steps

These 8 Rs of Rationalization can be applied to a Digital Estate to make [rationalization](rationalize.md) decisions regarding the future state of each application.

> [!div class="nextstepaction"]
> [Rationalize the Digital Estate](rationalize.md)