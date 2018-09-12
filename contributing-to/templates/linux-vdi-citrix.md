---
title: Linux Virtual Desktops with Citrix
description: Proven scenario for building a VDI environment for Linux Desktops using Citrix on Azure.
author: miguelangelopereira
ms.date: 09/12/2018
---
# Linux Virtual Desktops with Citrix

This sample scenario is aplicable to any industry that needs a Virtual Desktop Infrastructure (VDI) for Linux Desktops.

VDI refers to the process of running a user desktop inside a virtual machine that lives on a server in the datacenter. This sample scenario will be based on the Citrix Solution.

Some benifits for this sample solution include:
- Increased ROI with Hosted Shared Linux virtual desktops by giving more users access to the same infrastructure
- Provided access to Linux application to any device (including Non-Linux)
- Sensitive data can be secured in the Azure datacenter for all distributed employees
- 


## Potential use cases

Consider this scenario for the following use case:
- Provide secure access to mission-critical, specialized Linux VDI desktops from Linux or non-Linux devices



## Architecture

*Architecture Diagram goes here*


This sample solution will allow the corporate network access to Linux Virtual Desktops:
- An ExpressRoute is established between the On-Premises environment and Azure for fast and reliable connectivity to the Cloud
- TBD

> What does the solution look like at a high level?  
> Why did we build the solution this way?  
> What will the customer need to bring to this?  (Software, skills, etc?)  
> Is there a data flow that should be described?

### Components


* [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) allows resources such as VMs to securely communicate with each other, the Internet, and on-premises networks. Virtual networks provide isolation and segmentation, filter and route traffic, and allow connection between locations. One Virtual Network will be used  for all resources in the sample scenario.
* [Azure network security groups](/azure/virtual-network/security-overview) contain a list of security rules that allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. The virtual networks in this scenario are secured with network security group rules that restrict the flow of traffic between the application components.
* [Azure load balancer](/azure/application-gateway/overview) distributes inbound traffic according to rules and health probes. A load balancer provides low latency and high throughput, and scales up to millions of flows for all TCP and UDP applications. An internal load balancer is used in this scenario to distribute traffic on the Citrix Netscaler.
* [Azure Hybrid File Sync](https://github.com/MicrosoftDocs/azure-docs/edit/master/articles/storage/files/storage-sync-files-planning.md) will be used for all shared storage. The storage will replicate to two file servers using Hybrid File Sync.
* [Azure SQL Database](https://docs.microsoft.com/en-us/azure/sql-database/) is a relational database-as-a-service (DBaaS) based on the latest stable version of Microsoft SQL Server Database Engine. It will be used for hosting Citrix databases.
* [ExpressRoute](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-introduction) lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. 
* [Azure Active Directory Domain Services](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-overview) provides managed domain services such as domain join, group policy, LDAP, Kerberos/NTLM authentication that are fully compatible with Windows Server Active Directory.
* [Azure AD Connect](https://docs.microsoft.com/en-us/azure/active-directory/connect/active-directory-aadconnect) will integrate your on-premises directories with Azure Active Directory.
* [Azure Availabilty Sets](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-availability-sets) will ensure that the VMs you deploy on Azure are distributed across multiple isolated hardware nodes in a cluster. Doing this ensures that if a hardware or software failure within Azure happens, only a subset of your VMs are impacted and that your overall solution remains available and operational. 
* [Citrix Netscaler]() is an application delivery controller that performs application-specific traffic analysis to intelligently distribute, optimize, and secure Layer 4-Layer 7 (L4–L7) network traffic for web applications. 
* [Citrix Storefront](https://www.citrix.com/products/citrix-virtual-apps-and-desktops/citrix-storefront.html) is an enterprise app store that improves security and simplifies deployments, delivering a modern, unmatched near-native user experience across Citrix Receiver on any platform. StoreFront makes it easy to manage multi-site and multi-version Citrix Virtual Apps and Desktops environments. 
* [Citrix License Server](https://www.citrix.com/buy/licensing/overview.html) will manage the licenses for Citrix Products.
* [Citrix Desktop Workers]()
* [Citrix Delivery Controller](https://docs.citrix.com/en-us/xenapp-and-xendesktop/7-15-ltsr/manage-deployment/delivery-controllers.html) is the server-side component that is responsible for managing user access, plus brokering and optimizing connections. Controllers also provide the Machine Creation Services that create desktop and server images.
 

### Alternatives

> What alternative technologies were considered and why didn't we use them?

## Considerations

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?

### Availability, Scalability, and Security

> How do I need to think about managing, maintaining, and monitoring this long term?

> Are there any size considerations around this specific solution?  
> What scale does this work at?  
> At what point do things break or not make sense for this architecture?

> Are there any security considerations (past the typical) that I should know about this?

## Deploy this scenario

> (Optional if it doesn't make sense)
>
> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Pricing

> How much will this cost to run?  
> Are there ways I could save cost?  
> If it scales linearly, than we should break it down by cost/unit.  If it does not, why?  
> What are the components that make up the cost?  
> How does scale effect the cost  
> 
> Link to the pricing calculator with all of the components outlined.  If it makes sense, include a small/medium/large configurations.  Describe what needs to be changed as you move to larger sizes

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: describe what a small implementation is.
* [Medium][medium-pricing]: describe what a medium implementation is.
* [Large][large-pricing]: describe what a large implementation is.

## Next Steps

> Where should I go next if I want to start building this?  
> Are there any reference architectures that help me build this?

## Related Resources

> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful?  

<!-- links -->
[small-pricing]: https://azure.com/e/
[medium-pricing]: https://azure.com/e/
[large-pricing]: https://azure.com/e/
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
