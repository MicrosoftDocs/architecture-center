---
title: "Enterprise Cloud Adoption: Operational Fundamentals"
description: Guidance on operational fundamentals
author: petertay
---

# Establishing a Fundamentals Process

## History
The learnings from building Azure. 
The difficulty of orchestrating work across lots of teams that are continously delivering.
This can be applied to help you dear customer.

## Understanding the problem
The business has goals. The services are supposed to support those goals.
*refer back to the getting started doc*
We often focus on service features (aka functional requirements) but neglect critical non-functional requirements.
* enumerate non-functional requirements 
* exacerabated by a lack of knowing what's deployed, what the architecture is, etc.

What are non-functional requirements even? *refer to the Design for Resiliency*

These non-functional requirements affect service continuity.
(We could borrow langauage from ITSDM/ITIL communities.)

## Introduce a Contoso example
This is to set a context to be used as an example throughout the doc.
We can build on the Drone Delivery example, perhaps?

Give an example of a problem that Consto needs to fix.

This leads to...

## Goals & Expected Outcomes

That Contosos's "business critical" services meet the the "continuity" expectations of the business (i.e., RPO, RTO, SLO, etc.)

## Process Summary

A description of the basic steps of a fundamentals process...

* identify their mission-critical business operations  .
* Map the business operations to the corresponding service operations.
* Understand the dependencies between their own services as well as with Azure services.
* Define scorecard metrics for service operations based on design pillars (i.e., availability, scalability, DR, etc.)
- after the health of the business operations is known, IT needs to express the cost and the business needs to decide if it is worth mitigating
* Create a supporting governance model
    * Roles and responsibilities that need to exist
    * Ensuring accountability for addressing missed metrics
    * Establishing a review rhythm for scorecards

> Business operations are the actual thing the business needs to do, as opposed to the service operation which is a particular function of an implemented service. For example, the business operation might be “a customer need to checkout with their shopping cart”. This could map to a number of implemented services (i.e., inventory stock service, payment processing service, shopping cart management service, etc.). In addition, each service likely has a number of operations, many of which are not likely to participate in the mission critical business operation. For example, the “reserve stock” operation of an inventory stock service could be considered critical for the customer checkout business operation, but the “add stock” operation may not be.

## Roles; the cast for this play

One key role is that of **Business Advocate**. This role is analogous to the one played by AzureCAT in Azure Fundamentals. In customer terms, this role understands the business operations and has some knowledge of service implementations as well.

**Engineering Owners** - people who can make engineering changes

## The Process Itself

The logical steps of the process.
Flesh out was in the summary above.

Talk about cadence; monthly/quarterly reviews.

---
1. What are the most important business operations? Create a prioritized list.
    - what are the (desried) non-functional requirements (NFR) for the business op?

2. Map the business operations to the IT service
  - understand the constituent components in the service
  - understand the depedency tree
  - this is about the **current state**; not the desired or target state
  - understand the critical path
3. Is monitoring in-place for the service - this is a critical blocker!
  - side bar about monitorigin and testing: production workload, synthetic loads, canary
4. Create a scorecard: do the inidividal component of the service hit the NFR targets?
5. What is the plan to improve the scorecard?
    - accounatiblity - who is the engineering owner?
    - plan - what is the cost? does the NFR target need to be revised in light of the cost?
    - implement - monitoring should show success of hitting the target
6. The review cadence
    - monthly or quarterly
    - new services should trigger the process
    - perhaps the business operation priorities are reviewed annually (less than the scorecards for services)

three roles
1. business owner - decides the NFR targets, decides which business operations are high priority "mission critical"
2. business advocate - a technical person that understand the buisiness; can map the IT services to the business operations, gets the bigger picture, can translate from business to technical
3. engineering owner/service owner - responsible for actually implementing NFRs and supporting montioring
---

## Assets

Score card
Checklists, other materials in the AAC

*refer back to A3G regarding transient failures in the cloud*