---
title: Deploy Drupal in Azure for greater operational resiliency - Azure Example Scenarios
description: Deploy the Drupal content management system on Azure for greater operational resiliency
author: richstep
ms.date: 11/28/2018
---

# Deploy Drupal in Azure for greater operational resiliency

Review this Azure example scenario to learn about deploying the Drupal content management system in Azure to achieve greater resiliency for content-based websites.

This scenario is based on a solution built by a [microgrid](https://www.energy.gov/articles/how-microgrids-work) electricity producer and grid operator. As the company's business accelerated, customers increasingly relied on critical electricity services. The company realized it needed a more reliable cloud provider to support their business.

As an early stage startup, the company could not afford a full-time software developer. They wanted a cloud provider with services usable by a tech-savvy end user. The founders decided to migrate to Azure and take advantage of Azure's platform as a service (PaaS) capabilities for their resilience and ease of use. The services chosen include Azure App Services for Linux, Azure DB for MySQL, Azure Application Gateway, Azure Container Registry, and Azure DevOps.

This architecture provides a number of benefits:
* Increased operational resilience by running Drupal on Azure App Services and Azure DB for MySQL instead of running on virtual machines, and by storing backups in separate geographic locations.
* Significantly increased operational agility, driving innovations and changes to market quickly with fewer mistakes.
* Increased security using Azure Application Gateway’s web application firewall.
* Optimized operations using Docker container technology for quick and accurate deployments.

## Relevant use cases

Other relevant use cases include:

* Optimizing operations by modernizing websites running on Linux. By switching from infrastructure as a service (IaaS) to platform as a service (PaaS), you can lower your operational costs and increase the agility of your developer and operations staff. That agility accelerates your product's time-to-market and helps your organization respond quickly to changing marketplace and customer demands.
* Empowering your employees with fast internal business apps, enabling them to provide better services to other departments and customers.
* Better engaging with your customers via a fast and reliable customer portal.

## Architecture

![Architecture for Drupal on Azure][architecture]

Part 1 (Customer Facing)

Maintaining the reliability of an electrical grid is a responsibility with life-and-death consequences. User web requests first hit an Azure Application Gateway. The gateway performs application-level (layer-7) load balancing, but in this customers case, the gateway is used as a web application firewall (WAF). The WAF is partially based on the OWASP Top 10 and helps prevent common web server attacks such as SQL injection and cross-site scripting.

The app gateway passes verified requests to the Azure App Service for Linux. This is merely a web server of your choice running in a Docker container. This customer choose Apache for their web server. Like most platforms, the Drupal platform depends on a database. In this case, Azure SQL DB for MySQL. 

Drupal communicates with its database, Azure DB for MySQL, using standard drivers and secured connection strings. The MySQL service is regionally fault-tolerate and can scale-up and scale-down, by adding or removing virtual cores and memory with no downtime.

Part 2 (DevOps)

All Azure App service web apps are automatically be backed up on a recurring schedule.

The Azure DB for MySQL services can make geo-redundant backups to better protect during a regional disaster. Transaction log backups occur every five minutes allowing a database to be restored to a point-in-time.

Using container technology, such as Docker, requires organizations to rethink their DevOps process. In this example, to-be-hired Drupal developers on Apple Macs or PC will run Microsoft's open source IDE Visual Studio Code. VS Code has a Docker extension that makes developing and deploying container-based apps a seamless experience. Developers will run Docker locally, write code, and test on their local workstations. They then commit their code changes to their source control repository.

Azure DevOps notices the commit and triggers a process that builds a new Docker image. The image is identical to the image running locally on the developer workstation (in this example, one of the founders is running Docker locally and makes minor code or Drupal component changes) The newly built image is pushed to the customer's Azure Container Registry. The registry securely stores container images similar to how Docker Hub operates.

Azure DevOps notices the new image and deploys a new container to a dev or staging slot in the Azure App Service. Devs and quality assurance professionals can test the code changes before the DevOps team "swaps" the slots: the staging slot becomes production and the old production website is moved to the staging slot. If mistakes are found in production, a simple click will swap the older production site back into production.

To implement this architecture, you should have staff who has container skills or is capable of learning Docker. Having staff that has familiarity with CI/CD also increases productivity and operational agility.

### Components

* [Web Application Firewall](/azure/application-gateway/waf-overview) protects your web application from web vulnerabilities and attacks without modification to backend code.
* [Azure App Service Web Apps](/azure/app-service/app-service-web-overview) is a service for hosting web applications, REST APIs, and mobile back ends. Web Apps lets your application take advantage of Azure capabilities such as security, load balancing, autoscaling, and automated management. You can also take advantage of its DevOps capabilities, such as continuous deployment from Azure DevOps, GitHub, Docker Hub, and other sources, package management, staging environments, custom domain, and SSL certificates.
* [Azure App Service plans](/azure/app-service/azure-web-sites-web-hosting-plans-in-depth-overview) defines a set of compute resources for running a web app. These compute resources are analogous to the server farm in conventional web hosting. One or more apps can be configured to run on the same computing resources (or in the same App Service plan).
* [Azure Database for MySQL](/azure/mysql/overview) is a relational database service in Azure based on the MySQL Community Edition database engine.
* [Azure Container Service](/azure/container-service/) allows you to quickly deploy a production ready Kubernetes, DC/OS, or Docker Swarm cluster. 
* [Azure DevOps Services](/azure/devops/user-guide) is a cloud service for collaborating on code development. It provides an integrated set of features including source control, build and release services for continuous integration and continuous delivery, work tracking, and testing.

### Alternatives

* The organization could have chosen to lift-and-shift their existing infrastructure to Azure virtual machines. Backup and disaster recovery operations would have been easier than on their old platform, but the customer would still require labor intensive management of their virtual machines, which is susceptible to security-related mistakes. Migrating web apps to Azure App Services eliminates the maintenance of virtual machines while still providing sufficient control during troubleshooting. For example, you can SSH into Azure instances where Drupal or Postgres is running.
* Similarly, the organization could have moved to Linux virtual machines running Postgres. Instead, the organization eliminated the management overhead of virtual machines by moving to Azure Database for MySQL. 
* A traditional LAMP stack or a container-based LAMP stack using Docker would provide another alternative. The options were not chosen because of the management overhead of virtual machines. For more information about running Docker on Linux virtual machines, see [Create a Docker environment in Azure using the Docker VM extension](/azure/virtual-machines/linux/dockerextension).
* Azure Container Services (ACS). Not chosen because of the complexity of ACS. We want to take advantage of the features for managing websites of Azure App Services. A more complex application might choose ACS.

## Considerations

* Azure documentation and the Azure Portal assume you are creating a new Drupal 8 site. However, many organizations are migrating from a different service that is running an existing Drupal 7 or Drupal 8 site on Linux. Also, App Services for Linux are more complex than their Windows counterparts because of Docker. Once you understand Docker, you will appreciate the flexibility and consistency it provides. App Services for Windows do not use Docker and are more mature.
* To SSH into an App Service for Linux, you must use the Azure Portal. This means you cannot SSH from a remote machine such as your laptop. However, once you SSH into your app service via a web browser, you can run the SSH command and connect to other internet connected devices. This is helpful if you need to pull files from another server into your app service's file system.
* To scale your app services running Drupal, please see [Drupal server scaling](https://www.drupal.org/docs/8/managing-site-performance-and-scalability/server-scaling) best practices.
* To maximize availablility, consider running your website in multiple geographic regions. For more information, see the reference architecture for [Running a web application in multiple Azure regions](/azure/architecture/reference-architectures/app-service-web-app/multi-region).
* Using a cache such as [Azure Redis Cache](/azure/redis-cache) can significantly increase the performance of your website. For more information, see [Drupal integration with Redis](https://www.drupal.org/project/redis).
* After creating a base Docker image and registering it in Azure Container Services, Drupal developers can easily pull the image to their local workstation, modify it, run it locally, or publish the changes to a development web server or app service slot. Because everything is Docker-based, you can be confident that your Drpual site will run the same on a dev laptop, a test server, or in production.

## Deploy this scenario

To deploy this scenario, follow the [deployment steps available on GitHub](https://github.com/richstep/Drupal-7-as-an-Azure-App-Service).

<!-- links -->

[architecture]: ./media/architecture-appservice-for-linux-drupal.png
