---
title:  Azure Well-Architected Framework review of Azure Application Gateway
titleSuffix: Azure Architecture Center
description: This guidance provides best practices for the Application Gateway v2 family of SKUs based on  five pillars of architecture excellence.
author: PageWriter-MSFT
ms.date: 02/01/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-application-gateway
categories:
  - networking
---

# Azure Well-Architected Framework review of Azure Application Gateway

This article provides architectural best practices for the Azure Application Gateway v2 family of SKUs. The guidance is based on the five pillars of architecture excellence: Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, and Security.

We assume that you have working knowledge of Azure Application Gateway and are well-versed with v2 SKU features. As a refresher on the full set of features, see [Azure Application Gateway features](/azure/application-gateway/features).


## Cost Optimization

Review and apply the [cost principles](/azure/architecture/framework/cost/overview) when making design choices. 

#### Review Application Gateway pricing

Familiarize yourself with Application Gateway pricing to help you identify the right deployment configuration for your environment. Ensure that these blocks are adequately sized to meet the capacity demand and deliver expected performance without wasting resources.

For information about Application Gateway pricing, see [Understanding Pricing for Azure Application Gateway and Web Application Firewall](/azure/application-gateway/understanding-pricing).

Use these resources to estimate cost based on units of consumption.

- [Azure Application Gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/)
- [Pricing calculator](https://azure.microsoft.com/pricing/calculator/)

#### Review underutilized resources

Identify and delete Application Gateway instances with empty backend pools.

#### Stop Application Gateway instances when not in use

You aren't billed when Application Gateway is in stopped state. 

Continuously running Application Gateway instances can incur extraneous costs. Evaluate usage patterns and stop instances when you don't need them. For example, usage after business hours in Dev/Test environments is expected to be low. 

See these articles for information about how to stop and start instances.

- [Stop-AzApplicationGateway](/powershell/module/az.network/stop-azapplicationgateway?view=azps-6.0.0&viewFallbackFrom=azps-5.2.0&preserve-view=true)
- [Start-AzApplicationGateway](/powershell/module/az.network/start-azapplicationgateway?view=azps-5.2.0&preserve-view=true)


#### Have a scale-in and scale-out policy

A scale-in policy ensures that there will be enough instances to handle the incoming traffic and  spikes. Also, have a scale-out policy that makes sure the number of instances are reduced when demand drops. Consider the choice of instance size. The size can significantly impact the cost.

For more information, see [Autoscaling and Zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#pricing).

#### Review consumption metrics across different parameters

You're billed based on metered instances of Application Gateway based on the metrics tracked by Azure. Here's an example of cost incurred view in [Azure Cost Management + Billing](https://azure.microsoft.com/services/cost-management/).

> The example is based on the current price and is subject to change. This is shown for information purposes only.

![Azure Application Gateway pricing Cost Review](../images/application-gateway-sample-cost.png)

Evaluate the various metrics and capacity units that can be cost drivers. 

These are key metrics for Application Gateway. This information can be used to validate that the provisioned instance count matches the amount of incoming traffic.

- **Estimated Billed Capacity Units**
- **Fixed Billable Capacity Units**
- **Current Capacity Units**

For more information, see [Application Gateway metrics](/application-gateway/application-gateway-metrics#application-gateway-metrics).


Make sure you account for bandwidth costs. For details, see [Traffic across billing zones and regions](/azure/architecture/framework/cost/design-regions#traffic-across-billing-zones-and-regions). 


## Operational Excellence


## Performance Efficiency

Take advantage of v2 SKU features for autoscaling and performance benefits. 

The v2 SKU offers autoscaling to ensure that your Application Gateway can scale up as traffic increases. When compared to v1 SKU, v2 has capabilities that enhance the performance of the workload. For example, significantly better TLS offload performance, quicker deployment and update times, zone redundancy, and more. For more information about autoscaling features, see [Autoscaling and Zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).

If you are running v1 SKU gateways, consider migrating to v2 SKU. For guidance about migration, see  
[Migrate Azure Application Gateway and Web Application Firewall from v1 to v2](/application-gateway/migrate-v1-v2).


#### Estimate the Application Gateway instance count
Application Gateway v2 scales out depending on a many aspects, such as CPU, memory, and network utilization. To determine the approximate instance count, factor in these metrics:
- **Current compute units**&mdash;Indicates CPU utilization. 1 Application Gateway instance is approximately 10 compute units.
- **Throughput**&mdash;Application Gateway instance can serve 60-75 MBps of throughput. This data depends on the type of payload.

Consider this equation when calulating instance counts.

![Approximate instance count](../images/autoscale-instance.svg)

After you've estimated the instance count, compare that value to the maximum instance count. This will indicate the proximity to the maximum available capacity. 


#### Define the minimum instance count
For Application Gateway v2 SKU, autoscaling takes some time (approximately six to seven minutes) before the additional set of instances are ready to serve traffic. During that time, if there are short spikes in traffic, expect transient latency or loss of traffic.

We recommend that you set your minimum instance count to an optimal level. After you estimate the average instance count and determine your Application Gateway autoscaling trends, define the minimum instance count based on your application patterns. For information, see [Application Gateway high traffic support](/azure/application-gateway/high-traffic-support).

Check the **Current Compute Units** for the past one month. This metric represents the gateway's CPU utilization. To define the minimum instance count, divide the peak usage by 10. For example, if your Current Compute Units average in the past month is 50, set the minimum instance count to 5.

#### Define the maximum instance count
We recommend 125 as the maximum autoscale instance count. Make sure the subnet that has the Application Gateway has sufficient available IP addresses to support the scale-up set of instances.

Setting the maximum instance count to 125 has no cost implications because you're billed only for the consumed capacity. 

#### Define Application Gateway subnet size
Application Gateway needs a dedicated subnet within a virtual network. The subnet can have multiple instances of the deployed Application Gateway resource. You can also deploy other Application Gateway resources in that subnet, v1 or v2 SKU.

Here are some considerations for defining the subnet size:
- Application Gateway uses one private IP address per instance and another private IP address if a private front-end IP is configured.
- Azure reserves five IP addresses in each subnet for internal use.
- Application Gateway (Standard or WAF SKU) can support up to 32 instances. Taking 32 instance IP addresses + 1 private front-end IP + 5 Azure reserved, a minimum subnet size of /26 is recommended. Because the Standard_v2 or WAF_v2 SKU can support up to 125 instances, using the same calculation, a subnet size of /24 is recommended.
- If you want to deploy additional Application Gateway resources in the same subnet, consider the additional IP addresses that will be required for their maximum instance count for both, Standard and Standard v2.

#### Monitor capacity metrics
Use these metrics as indicators of utilization of the provisioned Application Gateway capacity. We strongly recommend setting up alerts on capacity. For details, see [Application Gateway high traffic support](/azure/application-gateway/high-traffic-support) 
|Metric|Description|Use case|
|---|---|---|
|**Current Compute Units**|	CPU utilization of virtual machine running Application Gateway. One Application Gateway instance supports 10 Compute Units.|Helps detect issues when more traffic is sent than what Application Gateway instances can handle.   
|**Throughput**|Amount of traffic (in Bps) served by Application Gateway.	|This threshold is dependent on the payload size. For smaller payloads but more frequent connections, expect lower throughput limits and adjust alerts accordingly. 
|**Current Connections**| Active TCP connections on Application Gateway.| Helps detect issues where the connection count increases beyond the capacity of Application gateway. Look for a drop in capacity unit When the connection count increases, look for a simultaneous drop in capacity unit. This will indicate if Application Gateway is out of capacity.

#### Troubleshoot using metrics




## Reliability
## Security