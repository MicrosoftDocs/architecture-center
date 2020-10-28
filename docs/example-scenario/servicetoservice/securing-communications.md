---
title: Securing inter-service communications
titleSuffix: Azure Example Scenarios
description: Secure communications between services on both the application and network layers
author: xstof
ms.date: 10/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
- fasttrack-new
---

# Secure inter-service communications

This example scenario how to secure and lock down communications between two backend services on both the application and network layers.  Communications can only flow between those services who have been explicitly configured to allow for this, adhering to the principle of least privilege.

<!-- The title is a noun phrase that describes the scenario.

> Example: "Insurance claim image classification on Azure"

Avoid naming the scenario after the Azure technologies that are used.

(Introductory section - no heading)

> This should be an introduction of the business problem and why this scenario was built to solve it.
>> What industry is the customer in?
>> What prompted them to solve the problem?
>> What services were used in building out this solution?
>> What does this example scenario show? What are the customer's goals?

> What were the benefits of implementing the solution described blow? -->

## Potential use cases

While this article provides a concrete example with services hosted in Azure App Service, the general principles outlined apply to other hosting platforms just as well.

<!-- > Are there any other use cases or industries where this would be a fit?
> How similar or different are they to what's in this article?

These other uses cases have similar design patterns:

- List of example use cases -->

## Architecture

![Architecture diagram](./media/svc-to-svc-solution-architecture.png "Solution Architecture")

The diagram outlines how Service A wants to communicate in a secured way with Service B, both running on Azure App Service.  

To do so, both services are registered with Azure Active Directory so they can use OAuth 2.0 token-based authorization between them.  

In addition, Service B is configured with App Service Access Restrictions to only allow communications from the integration subnet of Service A.  From a network point of view, this effectively restricts inbound connectivity to Service B to Service A which uses App Service Regional VNET integration to establish outbound communication from a private ip address in the Virtual Network.  Service Endpoints are configured to make sure Access Restrictions can be applied to the Web App hosting Service B.

<!--
> What does the solution look like at a high level?
> Why did we build the solution this way?
> What will the customer need to bring to this?  (Software, skills, etc?)
> Is there a data flow that should be described? -->

### Components

The following Azure services are used in this scenario:

- [App Service][appsvc] hosting both services and allowing autoscale and high availability without having to manage infrastructure.
- [Azure Active Directory][aad] (AAD) as the cloud-based identity and access management service taking care of authenticating services and enabling OAuth 2.0 based token-based authorization.
- [Azure Virtual Network (VNet)][vnet] is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks.
- [Azure Service Endpoints][svcep] providing secure and direct connectivity to Azure services over an optimized route over the Azure backbone network, while allowing App Service Access Restrictions to act upon the private source ip of inbound communications coming from within the integration vnet.

In addition to these services, the code making up our services is likely to make use of the [Microsoft Authentication Library (MSAL)][msal].  For Service A, MSAL allows for fetching access tokens from AAD using a client-credentials-flow.

#### Token-based Authorization

TODO

#### Access Restrictions leveraging Service Endpoints

TODO

<!-- A bullet list of components in the architecture (including all relevant Azure services) with links to the product documentation.

> Why is each component there?
> What does it do and why was it necessary?

- Example: [Resource Groups][resource-groups] is a logical container for Azure resources.  We use resource groups to organize everything related to this project in the Azure console. -->

### Alternatives

#### Managed Identity

Instead of registering as an application with AAD, Service A might consider to leverage a [Managed Identity][mi] to fetch an access token with.  This would work as long as other services don't need to request an access token towards Service A itself.  This would not be possible given the Managed Identity would not represent a valid audience to request a token for.

#### Private Endpoints

Instead of leveraging [Service Endpoints][svcep], one might consider the use of [Private Endpoints][privep] for App Service instead.  This lifts the need for enabling Service Endpoints as the endpoint for Service B would be a true private ip address within the Virtual Network.  Instead, this would come with requirements towards DNS.

> [!CAUTION]
> Filtering inbound traffic on Private Endpoints is neither supported through Network Security Groups (NSGs) or by using App Service Access Restrictions.  Every service with network line-of-sight will be able to communicate with the private endpoint of a web application.  This limits its use for locking down traffic on the network layer.

<!-- Use this section to talk about alternative Azure services or architectures that you might consider for this solution. Include the reasons why you might choose these alternatives. -->
<!-- 
> What alternative technologies were considered and why didn't we use them? -->

## Considerations

### App Service Regional VNet Integration restrictions

App Service [Regional VNet integration][regionalvnet] is limited to a single integration subnet per App Service Plan.  If multiple web apps are deployed on the same plan, they need to be integrated with the same subnet and all of those will share the same set of private outbound ip addresses.  As a consequence of this, the services to which these web apps communicate will not be able to distinguish from which web app the traffic originates from.  If this is a requirement, then web apps will need to be deployed on separate App Service Plans, each integrated to its own integration subnet.

<!-- > Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right? -->

### Availability, Scalability, and Security

Every worker instance of an App Service Plan will occupy a separate private ip address within the integration subnet.  When planning for scale, this needs to be taken into account and the size of the integration subnet should be large enough to accommodate the scale anticipated.

<!-- > How do I need to think about managing, maintaining, and monitoring this long term?

> Are there any size considerations around this specific solution?
> What scale does this work at?
> At what point do things break or not make sense for this architecture?

> Are there any security considerations (past the typical) that I should know about this? -->

<!-- ## Deploy this scenario

> (Optional if it doesn't make sense)
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
> Are there any reference architectures that help me build this? -->

## Related resources

<!-- > Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful?
> Are there product documents that go into more detail on specific technologies not already linked -->

The following resources will provide more information on the components used in this scenario:

- [Zero to Hero: multi-tier web apps][zerotohero]
- [AAD Client Credentials Flow][clientcredsflow]
- [Service Endpoints][svcep]
- [Microsoft Authentication Library][msal]
- [App Service Regional VNet Integration][regionalvnet]

<!-- links -->
[zerotohero]: https://azure.github.io/AppService/2020/10/05/zero_to_hero_pt7.html
[clientcredsflow]: https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow
[appsvc]: https://docs.microsoft.com/azure/app-service/overview
[aad]: https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis
[vnet]: https://docs.microsoft.com/azure/virtual-network/virtual-networks-overview
[svcep]: https://docs.microsoft.com/azure/virtual-network/virtual-network-service-endpoints-overview
[msal]: https://docs.microsoft.com/azure/active-directory/develop/msal-overview
[mi]: https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview
[privep]: https://docs.microsoft.com/azure/app-service/networking/private-endpoint
[regionalvnet]: https://docs.microsoft.com/azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration