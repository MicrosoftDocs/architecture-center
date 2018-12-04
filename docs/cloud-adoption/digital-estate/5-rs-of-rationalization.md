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

## Next steps

Collectively, these 8 Rs of Rationalization can be applied to a Digital Estate to make [rationalization](rationalize.md) decisions regarding the future state of each application.

> [!div class="nextstepaction"]
> [Rationalize the Digital Estate](rationalize.md)