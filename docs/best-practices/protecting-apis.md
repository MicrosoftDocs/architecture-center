---
title: Protecting APIs with Application Gateway and APIM
titleSuffix: How to protect APIs with APIM and Application Gateway
description: In this article you will be guided through a suggestive process of protecting APIs with API Management (APIM) and Application Gateway (AG).
author: fabriciosanchez
ms.date: 2/2/2021
ms.service = architecture-center
ms.topic = conceptual
ms.subservice = best-practice
---

# Protecting APIs with Application Gateway and APIM

As companies evolve their internal applications adhering the API-first approach, and also, considering the fast growing number of threats that web application over the internet are likely to face, it is critical than never before, to have a security strategy in place to protect APIs.

Being restrictive on "from where", "somebody" can access "what" into an given API is the very first step towards security. This article is going to guide you through a suggestive approach for that matter.

To address the points mentioned above, we're leveraging two different Azure services: **Application Gateway (AG)** and **API Management (APIM)**.

## Architecture

![Proposed architecture](./images/protecting-apis/apim-ag.jpg.png)

Considerations about the architecture:

* AG level, we’re going to set up a mechanism of URL redirection that makes sure the request goes to the proper [backend pool](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-components#backend-pools) depending on the “URL format” for the API's call.

* Basically, URLs formatted like `api.{somedomain}/external/*` will be able to reach out the backend to interact with the requested APIs. Calls formatted as `api.{somedomain}/*` will be redirected to a dead end (meaning, a backend pool with no target set up) by AG.

* Internal calls (the ones coming in from resources at the same Azure's VNet) will be accepted and properly mapped by APIM under `api.{somedomain}/internal/*`.

* Because this scenario assumes that developers must be able to manage APIs and its configurations both from internal and external environments, we are going to add a rule at the AG level to properly redirect users under `portal.{somedomain}/*`  to developer's portal.

Finally, at the APIM level, we will have our APIs set up to accept calls under the following patterns:

* `api.{somedomain}/external/*`
* `api.{somedomain}/internal/*`

### Components

- [Azure Resource Groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal) is a logical container for Azure resources.  We use resource groups to organize everything related to this project in the Azure console.
  
- [Azure Virtual Networl (VNet)](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks.

- [Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview) Azure Application Gateway is a web traffic load balancer that enables you to manage traffic to your web applications. Traditional load balancers operate at the transport layer (OSI layer 4 - TCP and UDP) and route traffic based on source IP address and port, to a destination IP address and port.

- [Azure API Management](https://azure.microsoft.com/en-us/services/api-management/) API Management (APIM) is a way to create consistent and modern API gateways for existing back-end services.

### Alternatives

WAF and Firewall-wise, the same level or protection could be delivered by different combination of services in Azure. 

[Azure Front Door](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-overview#:~:text=Azure%20Front%20Door%20is%20a,and%20widely%20scalable%20web%20applications.&text=Front%20Door%20provides%20a%20range,needs%20and%20automatic%20failover%20scenarios.), [Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/overview), third-part solutions like [Barracuda](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/barracudanetworks.waf?tab=overview), and others available in [Azure Marketplace](https://azure.microsoft.com/en-us/marketplace/), are some of the options.


## Implementation considerations

* **VNet**. In order to communicate with private resources in the backend, both Application Gateway and API Management must be sitting at the same virtual network. This solution assumes you already have a VNet set up with your own resources. Additionally, two subnets are being created to hold up both AG and APIM.
  
We have also created a new resource group (AUManager_Shared_Resources) to hold up services deployment.
Also, we were informed that the two certificates we would need were already in place. To generate both PFX and CER versions of them (format required by Azure services we’re deploying), I went through the process described by myself in another post here in the portal. You can see it here if you would like.
Finally, we informed AU’s IT team that we will need some (actually two) CNAME records added into the DNS manager for those custom domains we’re going to add to the APIM, so on the proper moment, they will make it happens for us.

### Availability, Scalability, and Security

> How do I need to think about managing, maintaining, and monitoring this long term?

> Are there any size considerations around this specific solution?
> What scale does this work at?
> At what point do things break or not make sense for this architecture?

> Are there any security considerations (past the typical) that I should know about this?

## Deploy this scenario

> (Optional, but greatly encouraged)
>
> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Pricing

> How much will this cost to run?
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit.  If it does not, why?
> What are the components that make up the cost?
> How does scale effect the cost?
>
> Link to the pricing calculator with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include a small/medium/large configurations.  Describe what needs to be changed as you move to larger sizes

## Next steps

> Where should I go next if I want to start building this?
> Are there any reference architectures that help me build this?

## Related resources

> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful?
> Are there product documents that go into more detail on specific technologies not already linked

<!-- links -->

[calculator]: https://azure.com/e/