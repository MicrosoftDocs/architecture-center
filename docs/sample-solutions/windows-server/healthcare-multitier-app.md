---
title: Windows Server on Azure healthcare front-end application
description: Proven solution for building a secure, multi-tier web application with Windows Server on Azure that uses scale sets, Application Gateway, and load balancers.
author: iainfoulds
ms.date: 06/26/2018
---
# Deploy a secure and scalable multi-tier web application on Windows Server for a healthcare solution

This sample solution is applicable to healthcare organizations that have a need to secure multi-tier applications. In this solution, a front-end ASP.NET application securely connects to a protected back-end Microsoft SQL Server cluster.

Example application scenarios include running operating room applications, patient appointments and records keeping, or prescription refills and ordering. Traditionally, organizations had to maintain legacy on-premises applications and services for these scenarios. With a secure way and scalable way to deploy these Windows Server applications in Azure, organizations can modernize their deployments are reduce their on-premises operating costs and management overhead.

## Potential use cases

You should consider this solution for the following use cases:

* Modernizing application deployments in a secure cloud environment.
* Reducing legacy on-premises application and service management.
* Improving patient healthcare and experience with new application platforms.

## Architecture diagram

The solution diagram below is an example of this solution:

![Architecture overview of the Azure components involved in multi-tier Windows Server application for healthcare][architecture]

## Architecture

This solution covers a multi-tier healthcare application that uses ASP.NET and Microsoft SQL Server. The data flows through the solution as follows:

1. Users access the front-end ASP.NET healthcare application through an Azure Application Gateway.
2. The Application Gateway distributes traffic to VM instances within an Azure virtual machine scale set.
3. The ASP.NET application connects to Microsoft SQL Server cluster in a back-end tier via an Azure load balancer. These backend SQL Server instances are in a separate Azure virtual network, secured by network security group rules that limit traffic flow.
4. The load balancer distributes SQL Server traffic to VM instances in another virtual machine scale set.
5. A VM that runs Windows Server 2016 within the back-end tier virtual network acts as a file share witness for the SQL Server cluster.

### Components

* [Azure Application Gateway][appgateway-docs] is a layer 7 web traffic load balancer that is application-aware and can distribute traffic based on specific routing rules. App Gateway can also handle SSL offloading for improved web server performance.
* [Azure Virtual Network][vnet-docs] allows resources such as VMs to securely communicate with each other, the Internet, and on-premises networks. Virtual networks provide isolation and segmentation, filter and route traffic, and allow connection between locations. Two virtual networks are used in this solution to provide a common demilitarized zone (DMZ) and isolation of the application components.
* [Azure virtual machine scale set][scaleset-docs] let you create and manager a group of identical, load balanced, VMs. The number of VM instances can automatically increase or decrease in response to demand or a defined schedule. Two separate virtual machine scale sets are used in this solution - one for the frontend ASP.NET application instances, and one for the backend SQL Server cluster VM instances.
* [Azure network security groups][nsg-docs] contains a list of security rules that allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. The virtual networks in this solution are secured with network security group rules that restrict the flow of traffic between the application components.
* [Azure load balancer][loadbalancer-docs] distributes inbound traffic according to rules and health probes. A load balancer provides low latency and high throughput, and scales up to millions of flows for all TCP and UDP applications. An internal load balancer is used in this solution to distribute traffic from the frontend application tier to the backend SQL Server cluster.
* [Azure Windows virtual machines][vm-docs] provide core compute resources for Windows Server VM instances. A VM instance is deployed in the backend tier that acts as a fileshare witness for the SQL Server cluster.

### Availability

For other scalability topics, see the [availability checklist][availability] available in the architecure center.

### Scalability

For other scalability topics, see the [scalability checklist][scalability] available in the architecure center.

### Security

For a deeper discussion on [security][], see the relevant article in the architecture center.

### Resiliency

For a deeper discussion on [resiliency][], see the relevant article in the architecture center.

## Deploy the solution

**Prerequisites.**

* You must have an existing Azure account. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

To deploy this solution with an Azure Resource Manager template, perform the following steps.

1. Select the **Deploy to Azure** button:<br><a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fiainfoulds%2Farchitecture-center%2Fwindowsserver%2Fdocs%2Fsample-solutions%2Fwindows-server%2Ftemplates%2Fhealthcare-multitier-app%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
2. Wait for the template deployment to open in the Azure portal, then complete the following steps:
   * Choose to **Create new** resource group, then provide a name such as *myWindowsSolution* in the text box.
   * Select a region from the **Location** drop-down box.
   * Provide a username and secure password for the Jenkins instance and Grafana console.
   * Review the terms and conditions, then check **I agree to the terms and conditions stated above**.
   * Select the **Purchase** button.

It can take 15-20 minutes for the deployment to complete.

## Pricing

To explore the cost of running this solution, all of the Azure service components are pre-configured in the following cost calculator links.  To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on the number of scale set VM instances that run your applications.

* [Small][small-pricing]: this correlates to two frontend and two backend VM instances.
* [Medium][medium-pricing]: this correlates to 20 frontend and 5 backend VM instances.
* [Large][large-pricing]: this correlates to 100 frontend and 10 backend VM instances.

## Related Resources

This solution used a backend virtual machine scale set that runs a Microsoft SQL Server cluster. Azure Cosmos DB could also be used as a scalable and secure database tier for the application data. For more information, see [Azure Cosmos DB overview][azurecosmosdb-docs].

<!-- links -->
[appgateway-docs]: /azure/application-gateway/overview
[architecture]: ./media/healthcare-multitier-app/architecture-healthcare-multitier-app.png
[autoscaling]: ../../best-practices/auto-scaling.md
[availability]: ../../checklist/availability.md
[azurecosmosdb-docs]: /azure/cosmos-db/introduction
[loadbalancer-docs]: /azure/load-balancer/load-balancer-overview
[nsg-docs]: /azure/virtual-network/security-overview
[resiliency]: ../../resiliency/index.md
[security]: ../../patterns/category/security.md
[scalability]: ../../checklist/scalability.md
[scaleset-docs]: /azure/virtual-machine-scale-sets/overview
[vm-docs]: /azure/virtual-machines/windows/overview
[vnet-docs]: /azure/virtual-network/virtual-networks-overview

[small-pricing]: https://azure.com/e/841f0a75b1ea4802ba1ac8f7918a71e7
[medium-pricing]: https://azure.com/e/eea0e6d79b4e45618a96d33383ec77ba
[large-pricing]: https://azure.com/e/3faab662c54c473da55a1e93a27e0e64