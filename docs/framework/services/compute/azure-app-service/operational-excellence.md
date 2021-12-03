---
title: Azure App Service and operational excellence
description: Focuses on the Azure App Service used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to Service Operational Excellence.
author: v-stacywray
ms.date: 11/24/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-app-service
categories:
  - compute
  - management-and-governance
---

# Azure App Service and operational excellence

[Azure App Service](/azure/app-service/overview) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. This service adds the power of Microsoft Azure to your application, such as:

- Security
- Load balancing
- Autoscaling
- Automated management

To explore how Azure App Service can benefit the operational excellence of your application workload, reference key features in [Why use App Service?](/azure/app-service/overview#why-use-app-service)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure App Service.

## Design considerations

Microsoft guarantees that Azure App Service will be available `99.95%` of the time. However, no SLA is provided using either the Free or Shared tiers.

For more information, reference the [SLA for App Service](https://azure.microsoft.com/support/legal/sla/app-service/v1_4/).

## Checklist

**Have you configured Azure App Service while considering operational excellence?**
***

> [!div class="checklist"]
> - Create a deployment plan because redeploying the app service can reset the scaled units.
> - Review the App Service Advisor recommendations.
> - Ensure you configure the [App Service Environments (ASE) Network](/azure/app-service/environment/network-info) correctly.
> - Consider configuring [Upgrade Preference](/azure/app-service/environment/using-an-ase#upgrade-preference) if you're using multiple environments.
> - Plan for scaling out the ASE cluster.
> - Use [Deployment Slots](/azure/app-service/deploy-staging-slots) for resilient code deployments.
> - Avoid unnecessary worker restarts when deploying application code or configuration.
> - Use [Run From Package](/azure/app-service/deploy-run-package) to avoid deployment conflicts.
> - Use Basic or higher plans with two or more worker instances for high availability.
> - Evaluate the use of [TCP and SNAT ports](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors#cause) to avoid outbound connection errors.
> - Enable [Health check](/azure/app-service/monitor-instances-health-check#enable-health-check) to identify non-responsive workers.
> - Enable [Autoscale](/azure/azure-monitor/autoscale/autoscale-get-started) to ensure adequate resources are available to service requests.
> - Enable [Local Cache](/azure/app-service/overview-local-cache) to reduce dependencies on cluster file servers.
> - Enable [Diagnostic Logging](/azure/app-service/troubleshoot-diagnostic-logs) to provide insight into application behavior.
> - Enable [Application Insights Alerts](/azure/azure-monitor/app/azure-web-apps) to signal fault conditions.
> - Review [Azure App Service diagnostics](/azure/app-service/overview-diagnostics) to ensure common problems are addressed.
> - Evaluate [per-app scaling](/azure/app-service/manage-scale-per-app) for high density hosting on Azure App Service.

|ASE Recommendation|Description|
|------------------|-----------|
|Create a deployment plan because redeploying the app service can reset the scaled units.|Automatic scaling rules apply during operation of the environment, but redeploying the app service may cause the plan to reset to the default number of units. Customers should be aware of this behavior and plan for it during deployments. Deploy only during off-peak times or deploy maximum units with automatic scaling enabled to scale in and out to prevent website performance implications.|
|Review the App Service Advisor recommendations.|App Service Advisor gives you real-time recommendations in the portal on resource exhaustion and conditions related to CPU, memory, and connections.|
|Ensure you configure the **App Service Environments (ASE) Network** correctly.|One common ASE pitfall occurs when ASE is deployed into a subnet with an IP address space that is too small to support future expansion. In such cases, ASE can be left unable to scale without redeploying the entire environment into a larger subnet. We highly recommended that adequate IP addresses be used to support either the maximum number of workers or the largest number considered workloads will need. A single ASE cluster can scale to `201` instance, which would require a `/24` subnet.|
|Configure **Upgrade preference** if you're using multiple environments.|If lower environments are used for staging or testing, consider configuring these environments to receive updates sooner than the production environment. This will help to identify any conflicts or problems with an update, and provides a window to mitigate issues before they reach the production environment. If multiple load balanced (zonal) production deployments are used, *Upgrade preference* can be used to protect the broader environment against issues from platform upgrades.|
|Scale out the ASE cluster.|Scaling ASE instances vertically or horizontally takes `30` to `60` minutes as new private instances need to be provisioned. We highly recommend investing in up-front planning for scaling during spikes in load or transient failure scenarios.|
|Use **Deployment slots** for resilient code deployments.|*Deployment slots* allow for code to be deployed to instances that are *warmed-up* before serving production traffic. For more information, reference [Testing in production with Azure App Service](/shows/Azure-Friday/Testing-in-production-with-Azure-App-Service?term=Testing%20in%20production%20with%20Azure%20App%20Service&lang-en=true).|
|Avoid unnecessary worker restarts.|Many events can lead App Service workers to restart, such as content deployment, App Settings changes, and VNet integration configuration changes. A best practice is to make changes in a deployment slot other than the slot currently configured to accept production traffic. After workers are recycled and warmed up, a *swap* can be performed without unnecessary down time.|
|`Run From Package` to avoid deployment conflicts|`Run from Package` provides several advantages:<br>- Eliminates file lock conflicts between deployment and runtime.<br> - Ensures only fully deployed apps are running at any time. <br> - May reduce *cold-start* times, particularly for JavaScript functions with large `npm` package trees.|
|Use Basic or higher plans with two or more worker instances for high availability.|Azure App Service provides many configuration options that aren't enabled by default.|
|Evaluate the use of TCP and SNAT ports.|TCP connections are used for all outbound connections, but SNAT ports are used when making outbound connections to public IP addresses. SNAT port exhaustion is a common failure scenario that can be predicted by load testing while monitoring ports using Azure Diagnostics. For more information, reference [TCP and SNAT ports](#tcp-and-snat-ports).|
|Enable **Health check** to identify non-responsive workers.|Any health check is better than none at all. The logic behind endpoint tests should assess all critical downstream dependencies to ensure overall health. As a best practice, we highly recommend tracking application health and cache status in real time as this removes unnecessary delays before action can be taken.|
|Enable **Autoscale** to ensure adequate resources are available to service requests.|The default limit of App Service workers is `30`. If the App Service routinely uses `15` or more instances, consider opening a support ticket to increase the maximum number of workers to `2x` the instance count required to serve normal peak load.|
|Enable `Local_Cache` to reduce dependencies on cluster file servers.|Enabling local cache is always appropriate because it can lead to slower worker startup times. When coupled with **Deployment slots**, it can improve resiliency by removing dependencies on file servers and also reduces storage-related recycle events. Don't use local cache with a single worker instance or when shared storage is required.|
|Enable **Diagnostic Logging** to provide insight into application behavior.|*Diagnostic logging* provides the ability to ingest rich application and platform-level logs through Log Analytics, Azure Storage, or a third-party tool using Event Hub.|
|Enable **Application Insights alerts** to make you aware of fault conditions.|Application performance monitoring with Application Insights provides deep analyses into application performance. For Windows Plans, a *codeless deployment* approach is possible to quickly get a performance analysis without changing any code.|
|Review **Azure App Service diagnostics** to ensure common problems are addressed.|It's a good practice to regularly review service-related diagnostics and recommendations, and take action as appropriate.|
|Evaluate **per-app scaling** for high density hosting on Azure App Service.|Per-app scaling can be enabled at the App Service plan level to allow for scaling an app independently from the App Service plan that hosts it. This way, an App Service plan can be scaled to `10` instances, but an app can be set to use only five. Apps are allocated to available App Service plan using a best effort approach for an even distribution across instances. While an even distribution isn't guaranteed, the platform will make sure that two instances of the same app won't be hosted on the same App Service plan instance.|

### TCP and SNAT ports

If a load test results in SNAT errors, it's necessary to either scale across more or larger workers, or implement coding practices to help preserve and reuse SNAT ports, such as connection pooling and the lazy loading of resources. We don't recommend exceeding `100` simultaneous outbound connections to a public IP address per worker, and to avoid communicating with downstream services through public IP addresses when a private address (Private Endpoint) or Service Endpoint through vNet Integration could be used. TCP port exhaustion happens when the sum of connection from a given worker exceeds the capacity. The number of available TCP ports depend on the size of the worker.

The following table lists the current limits:

|TCP ports|Small (B1, S1, P1, I1)|Medium (B2, S2, P2, I2)|Large (B3, S3, P3, I3)|
|---------|----------------------|-----------------------|----------------------|
|TCP ports|1920|3968|8064|
|

Applications with many longstanding connections require ports to be left open for long periods of time, which can lead to TCP Connection exhaustion. TCP Connection limits are fixed based on instance size, so it's necessary to scale up to a larger worker size to increase the allotment of TCP connections, or implement code level mitigations to govern connection usage. Similar to SNAT port exhaustion, you can use Azure Diagnostics to identify if a problem exists with TCP port limits.

## Source artifacts

To identify App Service plans with only one instance, use the following query:

```sql
Resources
| where type == "microsoft.web/serverfarms" and properties.computeMode == `Dedicated`
| where sku.capacity == 1
```

### Learn more

[The Ultimate Guide to Running Healthy Apps in the Cloud](https://azure.github.io/AppService/2020/05/15/Robust-Apps-for-the-cloud.html)

## Next step

> [!div class="nextstepaction"]
> [Azure Batch and reliability](../azure-batch/reliability.md)
