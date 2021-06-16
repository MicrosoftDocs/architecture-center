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

### Stop Application Gateway instances when not in use

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

#### Take advantage of v2 SKU features for autoscaling and performance benefits

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
For Application Gateway v2 SKU, autoscaling takes six to seven minutes to scale out and provision additional set of instances ready to take traffic. Until then, if there are short spikes in traffic, your existing gateway instances might get overwhelmed and this may cause unexpected latency or loss of traffic.
It is recommended that you set your minimum instance count to an optimal level. Once you calculate the average approximate instance count, as well as you determine your Application Gateway autoscaling trends, you can define the minimum instance count based on your application patterns. 
As described in the Approximating Application Gateway Instance count section, check your Current Compute Units metric for the past one month. Compute unit metric is a representation of your gateway's CPU utilization and based on your peak usage divided by 10, you can set the minimum number of instances required. For example, if your Current Compute Units avg over the past month is 50, you would set the Application Gateway minimum instance count to 5.
Define the maximum instance count
We suggest having 125 as the maximum autoscale instance limit, so the gateway can be scaled out at any time. This maximum has no implications on billing, as the customer is always charged only for the capacity they actually consume. When setting the maximum instance count to 125, ensure that the subnet that the Application Gateway is deployed in has at enough available IP addresses in case Application Gateway does scales all the way up.
Define Application Gateway subnet size
An application gateway is a dedicated deployment in your virtual network. Within your virtual network, a dedicated subnet is required for the application gateway. You can have multiple instances of a given application gateway deployment in a subnet. You can also deploy other application gateways (of the same SKU: V1 or V2) in the subnet.
The following considerations will help you to define the correct size for the Application Gateway subnet based on your scenario:
	Application Gateway uses one private IP address per instance, plus another private IP address if a private front-end IP is configured.
	Azure also reserves five IP addresses in each subnet for internal use: the first four and the last IP addresses.
	Application Gateway (Standard or WAF) SKU can support up to 32 instances (32 instance IP addresses + 1 private front-end IP + 5 Azure reserved) – so a subnet size of /26 is recommended.
	Application Gateway (Standard_v2 or WAF_v2 SKU) can support up to 125 instances (125 instance IP addresses + 1 private front-end IP + 5 Azure reserved) – so a minimum subnet size of /24 is recommended 
	If you are intending to deploy additional Application Gateways in the same subnet, consider the additional IP addresses that will be required for their maximum instance count for both, Standard and Standard v2.




## Reliability
## Security