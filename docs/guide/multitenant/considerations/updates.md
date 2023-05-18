---
title: Considerations for updating a multitenant solution
titleSuffix: Azure Architecture Center
description: This article describes considerations for updating your multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 02/28/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-devops
  - azure-pipelines
  - github
categories:
  - management-and-governance
  - devops
ms.category:
  - fcp
ms.custom:
  - guide
---

# Considerations for updating a multitenant solution

One of the benefits of cloud technology is continuous improvement and evolution. As a service provider, you need to apply updates to your solution: you might need to make changes to your Azure infrastructure, your code/applications, your database schemas, or any other component. It's important to plan how you update your environments. In a multitenant solution, it's particularly important to be clear about your update policy because some of your tenants might be reluctant to allow changes to their environments, or they might have requirements that limit the conditions under which you can update their service.

When planning a strategy to update your solution, you need to:

* Identify your tenants' requirements.
* Clarify your own requirements to operate your service.
* Find a balance that both you and your tenants can accept.
* Communicate your strategy clearly to your tenants and other stakeholders.

In this article, we provide guidance for technical decision-makers about the approaches you can consider to update your tenants' software, and the tradeoffs involved.

## Your customers' requirements

Consider the following questions:

- **Expectations and requirements:** Do your customers have expectations or requirements about when they can be updated? These might be formally communicated to you in contracts or service-level agreements, or they might be informal.
- **Maintenance windows:** Do your customers expect service-defined or even self-defined maintenance windows? They might need to communicate to their own customers about any potential outages.
- **Regulations:** Do your customers have any regulatory concerns that require additional approval before updates can be applied? For example, if you provide a health solution that includes IoT components, you might need to get approval from the United States Food and Drug Administration (FDA) before applying an update.
- **Sensitivity:** Are any of your customers particularly sensitive or resistant to having updates applied? Try to understand why. For example, if they run a physical store or a retail website, they might want to avoid updates around Black Friday, because the risks are higher than potential benefits.
- **History:** What's your track record of successfully completing updates without any impact to your customers? You should follow good DevOps, testing, deployment, and monitoring practices to reduce the likelihood of outages, and to ensure that you quickly identify any issues that updates introduce. If your customers know that you're able to update their environments smoothly, they're less likely to object.
- **Rollback:** Will customers want to roll back updates if there's a breaking change?

## Your requirements

You also need to consider the following questions from your own perspective:

- **Control you're willing to provide:** Is it reasonable for your customers to have control over when updates are applied? If you're building a solution used by large enterprise customers, the answer might be yes. However, if you're building a consumer-focused solution, it's unlikely you'll give any control over how you upgrade or operate your solution.
- **Versions:** How many versions of your solution can you reasonably maintain at one time? Remember that if you find a bug and need to hotfix it, you might need to apply the hotfix to all of the versions in use.
- **Consequences of old versions:** What's the impact of letting customers fall too far behind the current version? If you release new features on a regular basis, will old versions become obsolete quickly? Also, depending on your upgrade strategy and the types of changes, you might need to maintain separate infrastructures for each version of your solution. So, there might be both operational and financial costs, as you maintain support for older versions.
- **Rollback:** Can your deployment strategy support rollbacks to previous versions? Is this something you want to enable?

> [!NOTE]
> Consider whether you need to take your solution offline for updates or maintenance. Generally, outage windows are seen as an outdated practice, and modern DevOps practices and cloud technologies enable you to avoid downtime during updates and maintenance. However, you need to design for zero-downtime deployments, so it's important to consider your update process when you plan your solution architecture.
>
> Even if you don't plan for outages during your update process, you might still consider defining a regular maintenance window. A window can help to communicate to your customers that changes happen during specific times.
>
> For more information on achieving zero-downtime deployments, see [Eliminate downtime through versioned service updates](/devops/operate/achieving-no-downtime-versioned-service-updates).

## Find a balance

If you leave cadence of your service updates entirely to your tenants' discretion, they might choose to never update. It's important to allow yourself to update your solution, while factoring in any reasonable concerns or constraints that your customers might have. For example, if a customer is particularly sensitive to updates on a Friday because that's their busiest day of the week, then can you just as easily defer updates to Mondays, without impacting your solution?

One approach that can work well is to roll out updates on a tenant-by-tenant basis, using [one of the approaches described below](#deployment-strategies-to-support-updates). Give your customer notice of planned updates. Allow customers to temporarily opt out, but not forever; put a reasonable limit on when you will require the update to be applied.

Also, consider allowing yourself the ability to deploy security patches, or other critical hotfixes, with minimal or no advance notice.

Another approach can be to allow tenants to initiate their own updates, at a time of their choosing. Again, you should provide a deadline, at which point you apply the update on their behalf.

> [!WARNING]
> Be careful about enabling tenants to initiate their own updates. This is complex to implement, and it will require significant development and testing effort to deliver and maintain.

Whatever you do, ensure you have a process to monitor the health of your tenants, especially before and after updates are applied. Often, critical production incidents (also called _live-site incidents_) happen after updates to code or configuration. Therefore, it's important you proactively monitor for and respond to any issues to retain customer confidence. For more information about monitoring, see [Monitoring for DevOps](/azure/architecture/framework/devops/checklist).

## Communicate with your customers

Clear communication is key to building your customers' confidence. It's important to explain the benefits of regular updates, including new features, bug fixes, resolving security vulnerabilities, and performance improvements. One of the benefits of a modern cloud-hosted solution is the ongoing delivery of features and updates.

Consider the following questions:

- Will you notify customers of upcoming updates?
- If you do, will you implicitly request permission by providing an opt-out process, and what are the limits on opting out?
- Do you have a scheduled maintenance window that you use when you apply updates?
- What if you have an emergency update, like a critical security patch? Can you force updates in those situations?
- If you can't proactively notify customer of upcoming updates, can you provide retrospective notifications? For example, can you update a page on your website with the list of updates that you've applied?
- How many separate versions of your system will you maintain in production?

## Communicate with your customer support team

It's important that your own support team has full visibility into updates that have been applied to each tenant. Customer support representatives should be able to easily answer the following questions:

- Have updates recently been applied to a tenant's infrastructure?
- What was the nature of those updates?
- What was the previous version?
- How frequently are updates applied to this tenant?

If one of your customers has a problem because of an update, you need to ensure your customer support team has the information necessary to understand what's changed.

## Deployment strategies to support updates

Consider how you will deploy updates to your infrastructure. This is heavily influenced by the [tenancy model](tenancy-models.yml) that you use. Three common approaches for deploying updates are deployment stamps, feature flags, and deployment rings. You can use these approaches independently, or you can combine them together to meet more complex requirements.

In all cases, ensure that you have sufficient reporting and visibility, so that you know what version of infrastructure, software, or feature each tenant is on, what they are eligible to migrate to, and any time-related data associated with those states.

### Deployment Stamps pattern

Many multitenant applications are a good fit for the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml), in which you deploy multiple copies of your application and other components. Depending on your isolation requirements, you might deploy a stamp for each tenant, or shared stamps that run multiple tenants' workloads.

Stamps are a great way to provide isolation between tenants. They also provide you with flexibility for your update process, because you can roll out updates progressively across stamps, without affecting others.

### Feature flags

[Feature flags](/devops/operate/progressive-experimentation-feature-flags) enable you to add functionality to your solution, while only exposing that functionality to a subset of your customers or tenants.

Consider using feature flags if either of these situations apply to you:

- You deploy updates regularly but want to avoid showing new functionality until it's fully implemented.
- You want to avoid applying changes in behavior until a customer opts in.

You can embed feature flag support into your application by writing code yourself, or by using a service like [Azure App Configuration](/azure/azure-app-configuration/overview).

### Deployment rings

[Deployment rings](/azure/devops/migrate/phase-rollout-with-rings) enable you to progressively roll out updates across a set of tenants or deployment stamps. You can assign a subset of tenants to each ring.

You can determine how many rings to create and what each ring means for your own solution. Commonly, organizations use the following rings:

- **Canary:** A canary ring includes your own test tenants and customers who want to have updates as soon as they are available, with the understanding that they may receive more frequent updates, and that updates might not have been through as comprehensive a validation process as in the other things.
- **Early adopter:** An early adopter ring contains tenants who are slightly more risk-averse, but who are still prepared to receive regular updates.
- **Users:** Most of your tenants will belong to the _users_ ring, which receives less frequent and more highly tested updates.

### API versions

If your service exposes an external API, consider that any updates you apply might affect the way that customers or partners integrate with your platform. In particular, you need to be conscious of breaking changes to your APIs. Consider using [an API versioning strategy](../../../best-practices/api-design.md#versioning-a-restful-web-api) to mitigate the risk of updates to your API.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

 * [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer
 * [Daniel Scott-Raynsford](http://linkedin.com/in/dscottraynsford) | Partner Technology Strategist
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Consider when you would [map requests to tenants, in a multitenant solution](map-requests.yml).
- Review the [DevOps checklist](../../../checklist/dev-ops.md) in Azure Well-Architected Framework.
