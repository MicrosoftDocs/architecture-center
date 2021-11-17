---
title: Backup and disaster recovery for apps
description: Explore backup and disaster recovery approaches in Azure. Disaster recovery is the process of restoring application functionality after a catastrophic loss.
author: v-aangie
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you handling DR (Backup & Restore) for this workload?
  - article
products:
  - azure
categories:
  - management-and-governance
---

# Backup and disaster recovery for Azure applications

*Disaster recovery* is the process of restoring application functionality in the wake of a catastrophic loss.

In the cloud, we acknowledge up front that failures will happen. Instead of trying to prevent failures altogether, the goal is to minimize the effects of a single failing component. Testing is one way to minimize these effects. Automate testing your applications where possible, but you need to be prepared for when they fail. When a failure happens, having backup and recovery strategies becomes important.

Your tolerance for reduced functionality during a disaster is a business decision that varies from one application to the next. It might be acceptable for some applications to be unavailable or to be partially available with reduced functionality or delayed processing for a while. For other applications, any reduced functionality is unacceptable.

## Key points

- Create and test a disaster recovery plan regularly using key failure scenarios.
- Design disaster recovery strategy to run most applications with reduced functionality.
- Design a backup strategy that is tailored to business requirements and circumstances of the application.
- Automate failover and failback steps and processes.
- Test and validate the failover and failback approach successfully at least once.

## Disaster recovery plan

Start by creating a recovery plan. The plan is considered complete after it has been fully tested. Include the people, processes, and applications needed to restore functionality within the service-level agreement (SLA) you've defined for your customers.

Consider the following suggestions when creating and testing your disaster recovery plan:

- Include the process for contacting support and for escalating issues. This information will help to avoid prolonged downtime as you work out the recovery process for the first time.
- Evaluate the business impact of application failures.
- Choose a cross-region recovery architecture for mission-critical applications.
- Identify a specific owner of the disaster recovery plan, including automation and testing.
- Document the process, especially any manual steps.
- Automate the process as much as possible.
- Establish a backup strategy for all reference and transactional data, and test backup restoration regularly.
- Set up alerts for the stack of the Azure services consumed by your application.
- Train operations staff to execute the plan.
- Perform regular disaster simulations to validate and improve the plan.

If you're using [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) to replicate virtual machines (VMs), create a fully automated recovery plan to fail over the entire application.

## Operational readiness testing

Perform an operational readiness test for failover to the secondary region and for failback to the primary region. Many Azure services support manual failover or test failover for disaster recovery drills. Instead, you can simulate an outage by shutting down or removing Azure services.

Automated operational responses should be tested frequently as part of the normal application lifecycle to ensure operational effectiveness.

## Failover and failback testing

Test failover and failback to verify that your application's dependent services come back up in a synchronized manner during disaster recovery. Changes to systems and operations may affect failover and failback functions, but the impact may not be detected until the main system fails or becomes overloaded. Test failover capabilities *before* they're required to compensate for a live problem. Also, be sure dependent services failover and failback in the correct order.

If you're using [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) to replicate VMs, run disaster recovery drills periodically by testing failovers to validate your replication strategy. A test failover doesn't affect the ongoing VM replication or your production environment. For more information, see [Run a disaster recovery drill to Azure](/azure/site-recovery/site-recovery-test-failover-to-azure).

## Dependent service outage

For each dependent service, you should understand the implications of service disruption and the way that the application will respond. Many services include features that support resiliency and availability, so evaluating each service independently is likely to improve your disaster recovery plan. For example, Azure Event Hubs supports [failing over](/azure/event-hubs/event-hubs-geo-dr#setup-and-failover-flow) to the secondary namespace.

## Network outage

When parts of the Azure network are inaccessible, you may not be able to access your application or data. In this situation, we recommend designing the disaster recovery strategy to run most applications with reduced functionality.

If reducing functionality isn't an option, the remaining options are application downtime or failover to an alternate region.

In a reduced functionality scenario:

- If your application can't access its data because of an Azure network outage, you can run locally with reduced application functionality by using cached data.
- You can store data in an alternate location until connectivity is restored.

## Recovery automation

The steps required to recover or failover the application to a secondary Azure region in failure situations should be codified, preferably in an automated manner, to ensure capabilities exist to respond effectively to an outage in a way that limits impact. Similar codified steps should also exist to capture the process required to failback the application to the primary region once a failover triggering issue has been addressed.

When automating failover procedures, ensure that the tooling used for orchestrating the failover is also considered in the failover strategy. For example, if you run your failover from Jenkins running on a VM, you'll be in trouble if that virtual machine is part of the outage. Azure DevOps Projects are scoped to a region too.

## Backup strategy

Many alternative strategies are available for implementing distributed compute across regions. These strategies must be tailored to the specific business requirements and circumstances of the application. At a high level, the approaches can be divided into the following categories:

- **Redeploy on disaster**: In this approach, the application is redeployed from scratch at the time of disaster. Redeploying from scratch is appropriate for non-critical applications that don't require a guaranteed recovery time.

- **Warm Spare (Active/Passive)**: Create a secondary hosted service in an alternate region, and deploy roles to guarantee minimal capacity. However, the roles don't receive production traffic. This approach is useful for applications that have not been designed to distribute traffic across regions.

- **Hot Spare (Active/Active)**: The application is designed to receive production load in multiple regions. The cloud services in each region might be configured for higher capacity than required for disaster recovery purposes. Instead, the cloud services might scale out as necessary at the time of a disaster and failover. This approach requires a large investment in application design, but it has significant benefits. These include low and guaranteed recovery time, continuous testing of all recovery locations, and efficient usage of capacity.

## Plan for regional failures

Azure is divided physically and logically into units called regions. A region consists of one or more data centers in close proximity. Many regions and services also support [availability zones](/azure/availability-zones/az-overview), which can be used to provide more resiliency against outages in a single data center. Consider using regions with availability zones to improve the availability of your solution.

Under rare circumstances, it's possible that facilities in an entire availability zone or region can become inaccessible, for example, because of network failures. Or, facilities can be lost entirely, for example, because of a natural disaster. Azure has capabilities for creating applications that are distributed across zones and regions. Such distribution helps to minimize the possibility that a failure in one zone or region could affect other zones or regions.

## Next step

> [!div class="nextstepaction"]
> [Automatic retry of failed backup jobs](./auto-retry.md)

## Related links

- For information on testing failovers, see [Run a disaster recovery drill to Azure](/azure/site-recovery/site-recovery-test-failover-to-azure).
- For information on Event Hubs, see [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/).

Go back to the main article: [Testing](test-checklist.md)
