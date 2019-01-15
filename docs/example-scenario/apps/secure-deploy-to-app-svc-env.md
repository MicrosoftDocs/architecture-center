# Secure Azure Web App Deployments to ILB ASE

This example scenario walks you through application deployment in your intranet environment using Azure App Service Environment service and securely connect to Azure SQL DB over VNet service endpoint. This scenario will also show how you can expose this application to internet in a secure manner using Azure Application Gateway service which includes Web Application Firewall. This will also show one of the best practices to setup continuous integration & continuous deployment to ILB ASE using Azure DevOps to automate build & release of an application.

## Relevant use cases

Consider this scenario for the following use cases:

* Building an Azure Web App where customer has additional security requirements to have additional layer of deployment protection behind 
an Azure VNET
* Customers desire a deployment to a dedicated tenant, rather than be in shared tenant App Service Plans
* Utilize Azure DevOps capabilities with the ILB ASE deployed inside a VNET

## Architecture

![Sample scenario architecture for Secure ILB ASE Deployment ][architecture]

The scenario covers the data flows as follows:

1. HTTP/HTTPs requests first hit the Application Gateway. 
2. Although not shown in the diagram, you can additionally have Azure AD Authentication enabled for the Web App as well. After the traffic ifirst hits Application Gateway, the use is then prompted to supply the credentials to authenticate with the application.
3. User request then flows through the ILB of the ASE, which in turn routes the traffic to the Contoso Expenses Web App.
4. User then proceeds to create an Expense Report
5. As part of the expense creation, the deployed API App is invoked to rereive user's manager name and email
6. The Created Expense Report is stored in Azure SQL Database
7. To facilitate continuous deployments, code gets checked into the Azure DevOps instance
8. The build VM has the Azure DevOps Agent installed
9. This allows the build VM to pull the bits for the Web App to deploy to the ASE (as the Build VM is deployed in a Subnet inside the same VNET)
10. The Application is deployed securely in an ILB ASE, fronted with an Application Gateway with WAF (Web Application Firewall) enableed. The build VM is also part of the VNET, securely deploying the web application bits to the ASE

### Components

* ILB [App Service Environment][intro-to-app-svc-env] The Azure App Service Environment is an Azure App Service feature that provides a fully isolated and dedicated environment for securely running App Service apps at high scale. 
* [Isolated App Service Plan Pricing Tier][isolated-tier-pricing-and-ase-pricing] The Isolated service plan is designed to run mission critical workloads, that are required to run in a virtual network. The Isolated plan allows customers to run their apps in a private, dedicated environment in an Azure datacenter using Dv2-series VMs with faster processors, SSD storage, and double the memory-to-core ratio compared to Standard
* Azure App Services [Web App][docs-webapps] and [API App][docs-apiapps] hosts web applications and RESTful APIs allowing autoscale and high availability without having to manage infrastructure.
* [Application Gateway][docs-appgw] Azure Application Gateway is a web traffic load balancer that enables you to manage traffic to your web applications.
* [Web Application Firewall][docs-waf] Web application firewall (WAF) is a feature of Application Gateway that provides centralized protection of your web applications from common exploits and vulnerabilities.
* [Azure SQL Database][docs-sql-database] Azure SQL Database is a relational database-as-a-service (DBaaS) based on the latest stable version of Microsoft SQL Server Database Engine.
* [Azure Networking] Azure provides a variety of networking capabilities that can be used together or separately
* [Azure DevOps][docs-azure-devops] Azure DevOps Services provides development collaboration tools including high-performance pipelines,
free private Git repositories, configurable Kanban boards, and extensive automated and cloud-based load testing
* [Build Azure VM][docs-azure-vm] In Azure Portal, create a Visual Studio Enterprise 2017 (latest release) on Windows Server 2016 (x64) VM that will be used as the build agent. 

### Alternatives
- [Service Fabric][docs-service-fabric] - A platform focused around building distributed components that benefit from being deployed and run across a cluster with a high degree of control. Service Fabric can also be used to host containers.
- [Azure Kubernetes Service][docs-kubernetes-service] - A platform for building and deploying container-based solutions that can be used as one implementation of a microservices architecture. This allows for agility of different components of the application to be able to scale independently on demand.

Other options for the data tier include:

* [Cosmos DB](/azure/cosmos-db/introduction): Microsoft's globally distributed, multi-model database. This service provides a platform to run other data models such as Mongo DB, Cassandra, Graph data, or simple table storage.

## Considerations
There are certain considerations to be aware of when dealing with certificates on ILB ASE. The real trick here is generating a certificate that chained up to a trusted root without requiring a Certificate Signing Request generated by the server on which the cert will be eventually placed. In other words, with IIS for example the first step is to generate a CSR from your IIS server and then send it to the SSL certificate issuing authority. 

You cannot issue a CSR from the Internal Load Balancer (ILB) of an ASE. The way to handle this is to use [this procedure][create-wildcard-cert-letsencrypt]

The above allows you to use proof of DNS name ownership instead of a CSR. If you own a DNS namespace, you can put in special DNS TXT record, the above service checks that the record is there, and if found, knows that you own the DNS server because you have the right record.
Based on that, it issues a certificate that is signed up to a trusted root, which you can then upload to your ILB. You don’t need to do anything with the individual certificate stores on the Web Apps because you have a trusted root SSL certificate at the ILB.

Make self-signed or internally issued SSL cert work if we want to make secure calls between services running in ILB ASE
Another [solution to consider][ase-and-internally-issued-cert] on how to make ILB ASE work with internally issued SSL certificate and how to load the internal CA to the trusted root store.

While provisioning the ASE consider the following limitations when choosing a domain name for the ASE. Domain Names cannot be:
* net
* azurewebsites.net
* p.azurewebsites.net
* nameofthease.p.azurewebsites.net

Additionally, the custom domain name used for apps and the domain name used by the ILB ASE cannot overlap. For an ILB ASE with the domain name contoso.com, you can't use custom domain names for your apps like:
* w<span>ww.</span>contoso.com
* abcd.def.contoso.com
* abcd.contoso.com

Choose a domain for the ILB ASE that won’t have a conflict with those custom domain names. You can use something like contoso-internal.com for the domain of your ASE for the example here, because that won't conflict with custom domain names that end in .contoso.com.

### Availability

* Consider leveraging the [typical design patterns for availability][design-patterns-availability] when building your cloud application.
* Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
* For additional considerations concerning availability, see the [availability checklist][availability] in the Azure Architecture Center.

### Scalability

* Understand how [scale works][docs-azure-scale-ase] in ASE
* Best Practices for [cloud apps auto scale][design-best-practice-cloud-apps-autoscale]
* When building a cloud application be aware of the [typical design patterns for scalability][design-patterns-scalability].
* Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture]
* For other scalability topics, see the [scalability checklist][scalability] available in the Azure Architecture Center.

### Security

* Consider leveraging the [typical design patterns for security][design-patterns-security] where appropriate.
* Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
* Consider following a [secure development lifecycle][secure-development] process to help developers build more secure software and address security compliance requirements while reducing development cost.
* Review the blueprint architecture for [Azure PCI DSS compliance][pci-dss-blueprint].

### Resiliency

* Consider using [Geo Distributed Scale with ASE][design-geo-distributed-ase] for greater resiliency and scalability.
* Review the [typical design patterns for resiliency][design-patterns-resiliency] and consider implementing these where appropriate.
* You can find a number of [recommended practices for App Service][resiliency-app-service] in the Azure Architecture Center.
* Consider using active [geo-replication][sql-geo-replication] for the data tier and [geo-redundant][storage-geo-redudancy] storage for images and queues.
* For a deeper discussion on [resiliency][resiliency], see the relevant article in the Azure Architecture Center.

## Deploy the scenario

To deploy this scenario, you can follow this [step-by-step tutorial][end-to-end-walkthrough] demonstrating how to manually deploy each component. This tutorial also provides a .NET sample application that runs a simple Contoso Expenses reporting application. 

## Pricing

Explore the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: This pricing example represents the components necessary to build the out for a minimum production level instance. Here we are assuming a small number of users, numbering only in a few thousand per month. The app is using a single instance of a standard web app that will be enough to enable autoscaling. Each of the other components are scaled to a basic tier that will allow for a minimum amount of cost but still ensure that there is SLA support and enough capacity to handle a production level workload.
* [Medium][medium-pricing]: This pricing example represents the components indicative of a moderate size deployment. Here we estimate approximately 100,000 users using the system over the course of a month. The expected traffic is handled in a single app service instance with a moderate standard tier. Additionally, moderate tiers of cognitive and search services are added to the calculator.
* [Large][large-pricing]: This pricing example represents an application meant for high scale, at the order of millions of users per month moving terabytes of data. At this level of usage high performance, premium tier web apps deployed in multiple regions fronted by traffic manager is required. Data consists of the following: storage, databases, and CDN, are configured for terabytes of data.

## Related resources

* [Integrate your ILB App Service Environment with the Azure Application Gateway][integrate-ilb-ase-with-appgw]
* [Integrate your Web Apps with the Azure Application Gateway][use-app-svc-web-apps-with-appgw]

<!-- links -->
[intro-to-app-svc-env]: /azure/app-service/environment/intro
[create-wildcard-cert-letsencrypt]: https://blogs.msdn.microsoft.com/mihansen/2018/03/15/creating-wildcard-ssl-certificates-with-lets-encrypt/
[ase-and-internally-issued-cert]: https://www.patrickob.com/2018/11/10/adding-ca-certs-to-the-trusted-root-store-for-web-apps-hosted-in-an-ase/
[isolated-tier-pricing-and-ase-pricing]: https://azure.microsoft.com/en-us/pricing/details/app-service/windows/

[architecture]: ./media/ilb-ase-with-architecture.png
[small-pricing]: https://azure.com/e/90fbb6a661a04888a57322985f9b34ac
[medium-pricing]: https://azure.com/e/38d5d387e3234537b6859660db1c9973
[large-pricing]: https://azure.com/e/f07f99b6c3134803a14c9b43fcba3e2f
[app-service-reference-architecture]: ../../reference-architectures/app-service-web-app/basic-web-app.md
[availability]: /azure/architecture/checklist/availability

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
[resiliency]: /azure/architecture/checklist/resiliency
[scalability]: /azure/architecture/checklist/scalability
[secure-development]: https://www.microsoft.com/SDL/process/design.aspx
[sql-geo-replication]: /azure/sql-database/sql-database-geo-replication-overview
[storage-geo-redudancy]: /azure/storage/common/storage-redundancy-grs
