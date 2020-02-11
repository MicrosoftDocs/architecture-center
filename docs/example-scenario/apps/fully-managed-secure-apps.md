---
title: Securely managed web applications
titleSuffix: Azure Example Scenarios
description: Securely deploy an expense application to Azure App Service Environment.
author: fmustaf
ms.date: 05/09/2019
ms.author: faisalm
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
    - fasttrack
    - security
    - web-apps
social_image_url: /azure/architecture/example-scenario/apps/media/ilb-ase-architecture.png
---

# Securely managed web applications

This scenario provides an overview of deploying secure applications using the [Azure App Service Environment (ASE)][intro-to-app-svc-env]. To restrict application access from the Internet, the Azure Application Gateway service and Web Application Firewall are used. This article also provides guidance about continuous integration and continuous deployment (CI/CD) for App Service Environments using Azure DevOps.

This scenario is commonly deployed in industries such as banking and insurance where customers are conscious of platform-level security in addition to application level security. To demonstrate these concepts, we'll use an application that allows users to submit expense reports.

## Relevant use cases

Consider this scenario for the following use cases:

- Building an Azure Web App where additional security is required.
- Providing dedicated tenancy, rather than shared tenant App Service Plans.
- Using Azure DevOps with an [internally load-balanced][create-ilb-ase] Application Service Environment (often called an ILB ASE).

## Architecture

![Sample scenario architecture for Secure ILB ASE Deployment][architecture]

Data flows through the scenario as follows:

1. HTTP/HTTPS requests first hit the Application Gateway.
2. Optionally (not shown in the diagram), you can have Azure Active Directory (Azure AD) authentication enabled for the Web App. After the traffic first hits the Application Gateway, the user is then prompted to supply credentials to authenticate with the application.
3. User requests flow through the internal load balancer (ILB) of the ASE, which in turn routes the traffic to the Expenses Web App.
4. The user then proceeds to create an expense report.
5. As part of creating the expense report, the deployed API App is invoked to retrieve the user's manager name and email.
6. The created expense report is stored in Azure SQL Database.
7. To facilitate continuous deployment, code is checked into the Azure DevOps instance.
8. The build VM has the Azure DevOps Agent installed, allowing the build VM to pull the bits for the Web App to deploy to the ASE (since the Build VM is deployed in a subnet inside the same virtual network).

### Components

- The [App Service Environment][intro-to-app-svc-env] provides a fully isolated, dedicated environment for securely running the application at high scale. In addition, since ASE and the workloads that run on it are behind a virtual network, it also provides an additional layer of security and isolation. The requirement of high scale and isolation drove the selection of ILB ASE.
- This workload is using the [isolated App Service pricing tier][isolated-tier-pricing-and-ase-pricing], so the application is running in a private dedicated environment in an Azure datacenter using Dv2-series VMs with faster processors, SSD storage, and double the memory-to-core ratio compared to Standard.
- Azure App Services [Web App][docs-webapps] and [API App][docs-apiapps] host web applications and RESTful APIs. These are hosted on the Isolated Pricing Tier plan that also offers autoscaling, custom domains, and so on, but in a dedicated tier.
- Azure [Application Gateway][docs-appgw] is a web traffic load balancer operating at Layer 7 that manages traffic to the web application. It offers SSL offloading, which removes additional overhead from the web servers hosting the web app to decrypt traffic again.
- [Web Application Firewall][docs-waf] (WAF) is a feature of Application Gateway. Enabling the WAF in the Application Gateway further enhances security. The WAF uses OWASP rules to protect the web application against attacks such as cross-site scripting, session hijacks, and SQL injection.
- [Azure SQL Database][docs-sql-database] was selected because the majority of the data in this application is relational data, with some data as documents and Blobs.
- [Azure Networking][azure-networking] provides a variety of networking capabilities in Azure, and the networks can be peered with other virtual networks in Azure Connectivity can also be established with on-premises datacenters via Express Route or site-to-site. In this case, a [service endpoint][sql-service-endpoint] is enabled on the virtual network to ensure the data is flowing only between the Azure virtual network and the SQL Database instance.
- [Azure DevOps][docs-azure-devops] is used to help teams collaborate during many sprints, using features of Azure DevOps that support Agile Development, and to create build and release pipelines.
- An Azure build [VM][docs-azure-vm] was created so that the installed agent can pull down the respective build, and deploy the web app to the ASE environment.

### Alternatives

ASE can run regular web apps on Windows or, as in this example, the web apps deployed inside the ASE are each running as Linux containers. ASE was selected to host these single-instance containerized applications. There are alternatives available&mdash;review the considerations below when designing your solution.

- [Azure Service Fabric][docs-service-fabric]: If your environment is predominantly Windows-based, and your workloads are primarily .NET Framework-based, and you are not yet considering rearchitecting to .NET Core, then use Service Fabric to support and deploy Windows Server Containers. Additionally, Service Fabric supports C# or Java programming APIs, and for developing native microservices, the clusters can be provisioned on Windows or Linux.
- [Azure Kubernetes Service][docs-kubernetes-service] (AKS) is an open source project and an orchestration platform more suited to hosting complex multicontainer applications that typically use a microservices-based architecture. AKS is a managed Azure service that abstracts away the complexities of provisioning and configuring a Kubernetes cluster. However, significant knowledge of the Kubernetes platform is still required to support and maintain it,so hosting a handful of single-instance containerized web applications may not be the best option.

Other options for the data tier include:

- [Azure Cosmos DB](/azure/cosmos-db/introduction): If the majority of the data is in non-relational format, Cosmos DB is a good alternative. This service provides a platform to run other data models such as Mongo DB, Cassandra, Graph data, or simple table storage.

## Considerations

There are certain considerations to be aware of when dealing with certificates on ILB ASE. The real trick here is generating a certificate that is chained up to a trusted root without requiring a Certificate Signing Request generated by the server on which the cert will be eventually placed. With IIS, for example, the first step is to generate a CSR from your IIS server and then send it to the SSL certificate issuing authority.

You cannot issue a CSR from the Internal Load Balancer (ILB) of an ASE. The way to handle this is to use [this procedure][create-wildcard-cert-letsencrypt].

The above allows you to use proof of DNS name ownership instead of a CSR. If you own a DNS namespace, you can put in special DNS TXT record, the above service checks that the record is there, and if found, knows that you own the DNS server because you have the right record. Based on that information, it issues a certificate that is signed up to a trusted root, which you can then upload to your ILB. You don’t need to do anything with the individual certificate stores on the Web Apps because you have a trusted root SSL certificate at the ILB.

Make self-signed or internally issued SSL cert work if we want to make secure calls between services running in ILB ASE
Another [solution to consider][ase-and-internally-issued-cert] on how to make ILB ASE work with internally issued SSL certificate and how to load the internal CA to the trusted root store.

While provisioning the ASE, consider the following limitations when choosing a domain name for the ASE. Domain names cannot be:

- net
- azurewebsites.net
- p.azurewebsites.net
- nameofthease.p.azurewebsites.net

Additionally, the custom domain name used for apps and the domain name used by the ILB ASE cannot overlap. For an ILB ASE with the domain name contoso.com, you can't use custom domain names for your apps like:

- www\.contoso.com
- abcd.def.contoso.com
- abcd.contoso.com

Choose a domain for the ILB ASE that won’t have a conflict with those custom domain names. You can use something like contoso-internal.com for the domain of your ASE for the example here, because that won't conflict with custom domain names that end in .contoso.com.

Another point to consider is regarding DNS. In order to allow applications within the ASE to communicate with each other, for instance a web application to talk to an API, you will need to have DNS configured for your virtual network holding the ASE. You can either [bring your own DNS][bring-your-own-dns] or you can use [Azure DNS private zones][private-zones]

### Availability

- Consider leveraging the [typical design patterns for availability][design-patterns-availability] when building your cloud application.
- Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
- For additional considerations concerning availability, see the [availability checklist][availability] in the Azure Architecture Center.

### Scalability

- Understand how [scale works][docs-azure-scale-ase] in ASE.
- Review best practices for [cloud apps autoscale][design-best-practice-cloud-apps-autoscale].
- When building a cloud application, be aware of the [typical design patterns for scalability][design-patterns-scalability].
- Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
- For other scalability topics, see the [scalability checklist][scalability] available in the Azure Architecture Center.

### Security

- Consider leveraging the [typical design patterns for security][design-patterns-security] where appropriate.
- Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
- Consider following a [secure development lifecycle][secure-development] process to help developers build more secure software and address security compliance requirements while reducing development cost.
- Review the blueprint architecture for [Azure PCI DSS compliance][pci-dss-blueprint].

### Resiliency

- Consider using [Geo Distributed Scale with ASE][design-geo-distributed-ase] for greater resiliency and scalability.
- Review the [typical design patterns for resiliency][design-patterns-resiliency] and consider implementing these where appropriate.
- You can find a number of [recommended practices for App Service][resiliency-app-service] in the Azure Architecture Center.
- Consider using active [geo-replication][sql-geo-replication] for the data tier and [geo-redundant][storage-geo-redudancy] storage for images and queues.
- For a deeper discussion on [resiliency][resiliency], see the relevant article in the Azure Architecture Center.

## Deploy the scenario

To deploy this scenario, you can follow this [step-by-step tutorial][end-to-end-walkthrough] demonstrating how to manually deploy each component. This tutorial also provides a .NET sample application that runs a simple Contoso expense reporting application.

## Pricing

Explore the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

- [Small][small-pricing]: This pricing example represents the components necessary to build the out for a minimum production level instance. Here we are assuming a small number of users, numbering only in a few thousand per month. The app is using a single instance of a standard web app that will be enough to enable autoscaling. Each of the other components is scaled to a basic tier that will allow for a minimum amount of cost but still ensure that there is SLA support and enough capacity to handle a production-level workload.
- [Medium][medium-pricing]: This pricing example represents the components indicative of a moderate size deployment. Here we estimate approximately 100,000 users using the system over the course of a month. The expected traffic is handled in a single app service instance with a moderate standard tier. Additionally, moderate tiers of cognitive and search services are added to the calculator.
- [Large][large-pricing]: This pricing example represents an application meant for high scale, at the order of millions of users per month moving terabytes of data. At this level of usage high performance, premium tier web apps deployed in multiple regions fronted by traffic manager is required. Data consists of the following components: storage, databases, and CDN, are configured for terabytes of data.

## Related resources

- [Integrate your ILB App Service Environment with the Azure Application Gateway][integrate-ilb-ase-with-appgw]
- [Integrate your Web Apps with the Azure Application Gateway][use-app-svc-web-apps-with-appgw]

<!-- links -->

[intro-to-app-svc-env]: /azure/app-service/environment/intro
[create-wildcard-cert-letsencrypt]: https://blogs.msdn.microsoft.com/mihansen/2018/03/15/creating-wildcard-ssl-certificates-with-lets-encrypt/
[ase-and-internally-issued-cert]: https://www.patrickob.com/2018/11/10/adding-ca-certs-to-the-trusted-root-store-for-web-apps-hosted-in-an-ase/
[isolated-tier-pricing-and-ase-pricing]: https://azure.microsoft.com/pricing/details/app-service/windows/
[bring-your-own-dns]: /azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#specify-dns-servers
[private-zones]: /azure/dns/private-dns-overview
[create-ilb-ase]: /azure/app-service/environment/create-ilb-ase
[azure-networking]: /azure/virtual-network/virtual-networks-overview
[sql-service-endpoint]: /azure/sql-database/sql-database-vnet-service-endpoint-rule-overview

[architecture]: ./media/ilb-ase-architecture.png
[small-pricing]: https://azure.com/e/22e2c9d300ee425a89a001726221c7b2
[medium-pricing]: https://azure.com/e/c280777e16bd4fd5bc9c23f3b8caf91f
[large-pricing]: https://azure.com/e/294d5b09fa064ced87d6422826f2a0fc
[app-service-reference-architecture]: ../../reference-architectures/app-service-web-app/basic-web-app.md
[availability]: /azure/architecture/patterns/category/availability

[design-patterns-availability]: /azure/architecture/patterns/category/availability
[design-patterns-resiliency]: /azure/architecture/patterns/category/resiliency
[design-patterns-scalability]: /azure/architecture/patterns/category/performance-scalability
[design-patterns-security]: /azure/architecture/patterns/category/security
[design-geo-distributed-ase]: /azure/app-service/environment/app-service-app-service-environment-geo-distributed-scale
[design-best-practice-cloud-apps-autoscale]: /azure/architecture/best-practices/auto-scaling

[docs-b2c]: /azure/active-directory-b2c/active-directory-b2c-overview
[docs-sql-database]: /azure/sql-database/sql-database-technical-overview
[docs-storage-blobs]: /azure/storage/blobs/storage-blobs-introduction
[docs-storage-queues]: /azure/storage/queues/storage-queues-introduction
[docs-traffic-manager]: /azure/traffic-manager/traffic-manager-overview
[docs-webapps]: /azure/app-service/app-service-web-overview
[docs-apiapps]: /azure/app-service/app-service-web-tutorial-rest-api
[docs-appgw]: /azure/application-gateway/overview
[docs-waf]: /azure/application-gateway/waf-overview
[docs-networking]: /azure/networking/networking-overview
[docs-azure-devops]: /azure/devops/?view=vsts
[docs-azure-vm]: /azure/virtual-machines/windows/overview
[docs-azure-scale-ase]: /azure/app-service/environment/intro
[docs-service-fabric]: /azure/service-fabric/
[docs-kubernetes-service]: /azure/aks/
[Azure Networking]: /azure/networking/networking-overview

[end-to-end-walkthrough]: https://github.com/Azure/fta-internalbusinessapps/blob/master/appmodernization/app-service-environment/ase-walkthrough.md
[use-app-svc-web-apps-with-appgw]: https://github.com/Azure/fta-internalbusinessapps/blob/webapp-appgateway/appmodernization/app-service/articles/app-gateway-web-apps.md
[integrate-ilb-ase-with-appgw]: /azure/app-service/environment/integrate-with-application-gateway
[pci-dss-blueprint]: /azure/security/blueprints/payment-processing-blueprint
[resiliency-app-service]: /azure/architecture/checklist/resiliency-per-service#app-service
[resiliency]: /azure/architecture/framework/resiliency/overview
[scalability]: /azure/architecture/checklist/scalability
[secure-development]: https://www.microsoft.com/SDL/process/design.aspx
[sql-geo-replication]: /azure/sql-database/sql-database-geo-replication-overview
[storage-geo-redudancy]: /azure/storage/common/storage-redundancy-grs
