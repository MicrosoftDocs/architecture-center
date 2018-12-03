---
title: "Fusion: What options are available when rationalizing a digital estate?"
description: Descriptions of commonly used tools for assessing on-prem infrastructure
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: What options are available when rationalizing a digital estate?

Cloud Rationalization is the process of evaluating assets to determine the best approach to hosting or modernizing each asset in the cloud. For more information on the process of rationalization, see the article [outlining the rationalization process](overview.md).

## 5 Rs rationalization

Cloud Rationalization is an evolution of application rationalization, the process of removing duplicated applications in favor of standardized solutions. Similarly, Cloud Rationalization deals specifically with cloud compatibility, business justifications associated with specific applications, and the value the cloud may provide related to those applications. For a visual reference of how applications flow through the Cloud Rationalization process, see the analogy on  [rationalization](rationalize.md).

To understand an individual rationalization option, Jump to: [Rehost](#rehost) | [Refactor](#refactor) | [Rearchitect](#rearchitect) | [Rebuild](#rebuild) | [Replace](#replace)

## Rehost

Also known as "Lift & Shift", a rehost effort moves the current state asset to the chosen cloud provider, with minimal change to current state.

Common drivers could include:

* Reduce Capex
* Free up datacenter space
* Quick cloud ROI

Quantitative Analysis factors:

* VM size (CPU, Memory, Storage)
* Dependencies (Network traffic)
* Asset compatibility

Qualitative Analysis Factors:

* Tolerance for change
* Business priorities
* Critical business events
* Process dependencies

## Refactor

Platform as a Service (PaaS) options can reduce operational costs associated with many applications. It can be prudent to slightly refactor an application to fit a PaaS based model.

Refactor also refers to the application development process of refactoring code to allow an application to deliver on new business opportunities.

Common drivers could include:

* Faster, shorter, updates
* Code portability
* Greater cloud efficiency (resources, speed, cost)

Quantitative Analysis factors:

* Application asset size (CPU, Memory, Storage)
* Dependencies (Network traffic)
* User Traffic (Page views, time on page, load time)
* Development platform (Languages, data platform, middle tier services)

Qualitative Analysis Factors:

* Continued business investments
* Bursting options/timelines
* Business process dependencies

## Rearchitect

Some aging applications aren't compatible with cloud providers because of the architectural decisions made when the application was built. In these cases, the application may need to be rearchitected prior to transformation.

In other cases, applications that are cloud compatible, but not cloud native benefits, may produce costs & operational efficiencies by rearchitecting the solution to be a cloud native application.

Common drivers could include:

* App scale and agility
* Easier adoption of new cloud capabilities
* Mix technology stacks

Quantitative Analysis factors:

* Application asset size (CPU, Memory, Storage)
* Dependencies (Network traffic)
* User Traffic (Page views, time on page, load time)
* Development platform (Languages, data platform, middle tier services)

Qualitative Analysis Factors:

* Growing business investments
* Operational costs
* Potential feedback loops and DevOps investments

## Rebuild

In some scenarios, the delta that must be overcome to carry forward an application can be too large to justify further investment. This is especially true for applications that used to meet the needs of the business, but are no unsupported &/or misaligned with how the business processes are executed today. In this case, a new code base is created to align with a cloud native approach.

Common drivers could include:

* Accelerate innovation
* Build apps faster
* Reduce operational cost

Quantitative Analysis factors:

* Application asset size (CPU, Memory, Storage)
* Dependencies (Network traffic)
* User Traffic (Page views, time on page, load time)
* Development platform (Languages, data platform, middle tier services)

Qualitative Analysis Factors:

* Declining end user satisfaction
* Business processes limited by functionality
* Potential cost, experience, or revenue gains

## Replace

Solutions are generally implemented using the best technology and approach available at the time. In some cases, Software as a Service (SaaS) applications can meet all of the functionality required of the hosted application. In these scenarios, a workload could be slated for future replacement, effectively removing it from the transformation effort.

Common drivers could include:

* Standardize around industry-best practices
* Accelerate adoption of business process driven approaches
* Reallocate development investments into applications that create competitive differentiation or advantages

Quantitative Analysis factors:

* VM size (CPU, Memory, Storage)
* Dependencies (Network traffic)
* Assets to be retired

Qualitative Analysis Factors:

* Business process maps
* Data schemas
* Custom, or automated processes

## Extended Rs of Cloud Rationalization

In some cases, there are decisions that must be made outside of the context of Cloud Rationalization. These Rs often dictate preceding actions that would need to be completed before any of the 5s of Cloud Rationalization could be applied. These Rs are not likely to be a focal point for Cloud vendors, as they are generally on-prem considerations that can't easily be address at the point of cloud adoption. However, it is important to be aware of these Rs during Cloud adoption, as they may impact timelines, costs, or effort required to complete cloud adoption efforts.

## Retire

Business needs and business process change constantly. Some applications or workloads have outlived their usefulness and can no longer meet the intended business need. Detecting these applications can help reduce investments and operational costs associated with a transformation.

When efficiency gains are important business outcomes, this R can't be over indexed. The choice of cloud vendor and future state architecture can significantly impact cost savings. In a traditional on-prem environment, there is little fiscal return from retiring workloads. Cloud transformation creates a unique pivot point that can demonstrate tangible value with every workload retired. One of the greatest cost savings in the cloud comes from the termination of unused/underused applications that can be retired in parallel to the cloud transformation effort.

Common drivers could include:

* Cost control
* Cost avoidance
* Re-prioritize technical assets

Quantitative Analysis factors:

* VM size (CPU, Memory, Storage)
* Dependencies (Validate absence of user traffic or identify remaining users)
* Assets to be retired

Qualitative Analysis Factors:

* Validate impact of retirement

## Remediate

This is a common rationalization step for applications that are being moved to the cloud via a Re-host approach.

Operating systems reach end of life, middleware platforms drop support for old versions. The cloud is no exception. When assets don't meet basic compatibility requirements, they may need an interim rationalization state called Remediation. During this process, the solution is brought up to more current standards before it can be fully rationalized or included in a Cloud Transformation.

Common drivers could include:

* Reduce security risks
* Modernize dependent assets
* Enable rehost efforts

Quantitative Analysis factors:

* VM size (CPU, Memory, Storage)
* Dependencies (Validate absence of user traffic or identify remaining users)
* Compatibility (Host OS version, Guest OS version, Middleware versions)

Qualitative Analysis Factors:

* Business testing plan during updates to assets
* Validate impact to users and business processes
* Establish critical events and on-prem black out dates
* Rationalize cost-benefit analysis of remediation against other application-focused options above or Reconfigure option below

## Reconfigure

The options for configuration and deployment management has grown since the concept of application rationalization was coined. For many solutions, it could make more sense to change the deployment configuration of a solution by creating an automated DevOps deployment pipeline. In other cases, it may more sense to package the solution in a container prior to re-hosting to avoid the need for costly remediation or re-build efforts.

When an application needs to be re-architected or assets require significant remediation, reconfiguration may produce a faster, lower cost alternative. If an investment is already being made in DevOps or Containers, Reconfigure is likely to be a more common decision during inventory rationalization.

Common drivers could include:

* Mitigate rehost costs
* Capitalize on existing DevOps investments
* Prepare for additional future evolutions of the application

Quantitative Analysis factors:

* VM size (CPU, Memory, Storage)
* Dependencies (Validate absence of user traffic or identify remaining users)
* Compatibility (Host OS version, Guest OS version, Middleware versions)
* Existing DevOps or Configuration Automation pipelines

Qualitative Analysis Factors:

* Rationalize cost-benefit analysis of reconfiguration against other application-focused options above

## Next steps

Collectively, these 8 Rs of Rationalization can be applied to a Digital Estate to make [rationalization](rationalize.md) decisions regarding the future state of each application.

> [!div class="nextstepaction"]
> [Rationalize the Digital Estate](rationalize.md)