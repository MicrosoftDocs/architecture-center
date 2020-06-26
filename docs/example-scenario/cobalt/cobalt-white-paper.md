---
title: Cobalt - An Extensible Cloud Infrastructure-as-Code Framework
titleSuffix: Technical White Paper
description: Cobalt is an extensible framework that uses templates to define the automated process of creating complex and enterprise-grade CI/CD implementations used to deploy highly available applications to Azure App Service for Containers.
author: danazlin
ms.date: 06/26/2020
ms.topic: overview
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---

# Cobalt - An Extensible Cloud Infrastructure-as-Code Framework

## Overview

### Background

Standardizing and automating the process of building production-ready cloud native managed service solutions is a very important need for major enterprise customers. They need to achieve higher productivity (such as time to deployment), higher efficiency, and easier compliance (for example, security, governance and privacy). Microsoft engaged with a fortune 50 retailer to enable their teams to build such solutions based on one or more specified patterns in an enterprise pattern library. The enterprise pattern library represented the specifications for each of the patterns. There was a need to take this effort to the next level by creating a framework that can “materialize” such patterns. Microsoft leveraged the Cobalt framework to achieve that goal.

Cobalt is an extensible framework that uses templates to define the automated process of creating complex and enterprise-grade CI/CD implementations to deploy highly available applications to Azure App Service for Containers. The infrastructure is deployed by utilizing versioned files containing the reusable templates. The templates contain the infrastructure and platform details and can be customized or reused as needed.

Leveraging Cobalt enables the customer to reduce the amount of time required to get apps through their security and compliance review and made available. With Cobalt, they can abstract the complexities of cloud-native computing away from application developer teams to more rapidly build apps in a repeatable way that not only follows DevOps best practices, but are highly secure and resilient. Such apps can take advantage of managed services and continuous delivery for better reliability. Cobalt also dramatically reduces time required to deploy complex applications.

### Customer Scenario

The customer, a major international retailer, needed a solution that would enable the migration of hundreds of their line-of-business (LOB) applications to cloud-based enterprise-grade production systems based on pre-approved architectures for Azure App Service for Containers. Then, they needed to developing new applications in the cloud based on those architectures. Each specific solution needs to be reviewed and approved by a security risk and compliance team before it could be implemented. Automation would significantly reduce the time needed in the review process for applications and make migrations and new deployments take place faster. This automation would include the build of such solutions based on predefined patterns that address security and other concerns.

### Requirements and Success Criteria

The customer wanted a framework that provides high availability for multi-datacenter deployments using geo-based routing, robust health probes, and automated failover. That framework needs to include a reliable DevOps solution comprised of continuous integration (CI) builds and tests for new pull requests. It also needs a simple continuous delivery (CD) solution in which new pull requests are automatically deployed to a development environment. It also needs the capability for manual promotion to Quality Assurance (QA), staging, and production environments.

The solution must follow the customer’s best security practices for protecting the infrastructure from attacks. It must also provide for secure data with secrets stored in Key Vault to meet their security and compliance requirements.

The customer also wanted to enable their teams to select from a library of pre-configured templates to create App Service-based applications. Each template must meet specific criteria for approval before becoming part of the template library.

The end-result sought by the customer was to have a working reference solution including all scoped components, functioning, documented, and running on their Azure subscription. The reference solution had to meet the customer's internal security team's technical compliance based on their regulations, policies, and standards. Only then would Cobalt gain approval at the platform level. At that point, any plans for new applications developed for or migrated to the cloud using Cobalt could be published more quickly than prior methods.

## Technical Scenario

At a high level, Cobalt leverages templates to automate the implementation of the technical tasks and services based on predefined architectural patterns. A Cobalt infrastructure template is a *manifest* made up of Terraform “modules,” which are grouped into various Azure resources. Originally, the template was designed to be forked and coded so that the platform and infrastructure needs for applications could be included. However, the customer found that approach to be more work than they wanted to do. So, the CSE team modified the process to a “version and go” model. This model means that, after initializing and integrating Cobalt into their existing Azure DevOps pipeline, the customer only needs to point to a “version” file containing the infrastructure and platform details and make some changes to the configuration to use it in the deployment of an application. Cobalt's template module registry is categorized by cloud provider and then resource type. Each module represents an abstraction for a set of related cloud infrastructure objects that the module will manage.

Figure 1 shows the steps involved in using Cobalt to provision resources in Azure.  

:::image type="content" border="true" source="./media/cobalt-framework.png" alt-text="overview diagram of Cobalt framework":::

<p style="text-align:center;font-style:italic;" role="caption">Figure 1 - Overview of Cobalt Solution Framework</p>

In general, the Cobalt process works like this:

1. The first step is to choose a DevOps provider workflow and set up Cobalt CI/CD pipelines.
1. In the second step, customize an existing Cobalt template or create a new one. The templates host reusable Terraform modules like virtual networks and traffic managers to scaffold various managed container services.
1. Third, code, test, and commit changes to the template to an upstream GitHub repository.
1. Finally, Cobalt automatically provisions and configures the cloud resources specified in the template.

### Prerequisites

The following prerequisites are required for anyone using Cobalt:

* One or more Azure subscriptions
* Azure DevOps organization
* Permissions to your organization's Azure DevOps account
* Global administrator role permissions in your organization's Azure Active Directory (AAD) tenant to set up service principals
* Azure Container Registry (ACR)
* Azure Key Vault specific to Cobalt
* Resource Groups
* VNets
* Azure DevOps instance
* Terraform

### Cobalt Templates and Provisioned Infrastructure

Microsoft's CSE team worked with the customer to customize templates for provisioning a best practices implementation of App Services that customer application development teams could later use to migrate and build their own LOB applications. Cobalt templates are organized to handle the provisioning of infrastructure and the setup of CI/CD pipelines.

Templates are the implementation of *Advocated Patterns*. The scope of a template typically covers most, if not all, of the infrastructure required to host an application and may provision resources in multiple cloud providers. Templates compose modules to create an advocated pattern. They are implemented as [Terraform Modules](https://www.terraform.io/docs/configuration/modules.html) (also sometimes known as *Cobalt Modules*) so that they can be composed if needed, though it is more commonly the case that they do not need to be composed.

Each template makes use of Terraform modules across both Bedrock and Cobalt. Cobalt's module registry is categorized by cloud provider then resource type. Each module represents an abstraction for the set of related cloud infrastructure objects that the module will manage (see [Figure 3](#figure3)). A module is a thin wrapper that enables simple common-sense configuration of related resources (typically 1-3 but sometimes more) within a cloud provider. The directory structure of [Cobalt](https://github.com/microsoft/cobalt) enables contributions for a variety of cloud providers. Cobalt infrastructure templates can be found in the *infra/templates* folder. From there, each subfolder represents a unique deployment schema and is packaged with a set of Terraform scripts, overview &amp; setup instructions, and automated unit &amp; integration tests.

A good example of a simple template is [az-hello-world](https://github.com/microsoft/cobalt/tree/master/infra/templates/az-hello-world). The az-hello-world template is intended to be a reference for running a single public Linux Container within an Azure Application Service Plan. This particular template creates an Azure environment with our smallest infrastructure footprint and is the recommended template highlighted in our [quickstart guide](https://github.com/microsoft/cobalt/blob/master/docs/2_QUICK_START_GUIDE.md). A list of the files is shown in Figure 2.

:::image type="content" source="./media/hello-world-template-set.png" alt-text="diagram of typical template structure":::

<p style="text-align:center;font-style:italic;" role="caption">Figure 2 - az-hello-world Template Set</p>

A template file is written in the Terraform configuration language HCL with the file extension `.tf`. Each template is made up of Terraform modules that handle provisioning the services required by the deployed application. These include such services as those needed for scalable application deployments, application and infrastructure observability (monitoring), security, and other isolated application dependencies for things like storage, VNet integration, and CosmosDB. The template structure for an Azure Isolated Service, Single Region is shown in the following diagram, which is a mapping of Cobalt Modules to Azure services and features.

Cobalt templates can use any of several Terraform modules that can be using in provisioning services provided by Azure. Figure 3 illustrates these modules and how they map to Azure services and features according to the topology discussed below in [Deployment Topology](#deployment-topology).

<a id="figure3"></a>

:::image type="content" source="./media/cobalt-module-mapping-azure.png" alt-text="diagram of how Terraform modules map to Azure services and features":::

<p style="text-align:center;font-style:italic;" role="caption">Figure 3 - Cobalt Modules Mapping to Azure Services & Features</p>

Although Azure Resource Management (ARM) templates could be used to deploy infrastructure, we selected Terraform for this solution for a number of reasons:

<!-- Editor Note: 1st bullet is technically inaccurate. Fix! -->

* Terraform uses the easy to read configuration language HCL (HashiCorp Configuration Language). HCL is considered to be significantly more human-readable than the JavaScript Object Notation (JSON) format templates used by ARM.
  * However, Terraform can also consume machine-generated JSON files for increased compatibility.
* Terraform provides excellent state management, allows idempotent<sup>1</sup> updates, and minimizes the surface area that it touches when updating deployments.
* Terraform promotes modular reusability, reducing redundant infrastructure components, and improves ease of maintenance and readability.
* The customer preferred using a small number of recommended technologies. Since we had also recommended Terraform as the solution for deploying Azure Kubernetes Service (AKS) clusters, it seemed sensible to use the same solution for Azure App Service.

> [!NOTE]
> <sup>1.</sup>  From a RESTful service standpoint, for an operation (or service call) to be __idempotent__, clients can make that same call repeatedly while producing the same result. In other words, making multiple identical requests has the same effect as making a single request.  
Credit: [https://www.restapitutorial.com/lessons/idempotency.html](https://www.restapitutorial.com/lessons/idempotency.html)

### Deployment Topology

The following diagram shows the targeted _Azure Isolated Service Single Region_ deployment topology needed by the enterprise customer. This deployment splits across 3 subscriptions. The resources are partitioned to align with the different personas within the customer organization. For example, subscriptions 1 and 3 are where admin resources exist, whereas subscription 2 hosts the application developer team resources.

:::image type="content" source="./media/deployment-single-region-topology.png" alt-text="diagram showing deployment topology if Azure isolated service single region":::

<p style="text-align:center;font-style:italic;" role="caption">Figure 4 - Deployment Topology of Azure Isolated Service Single Region</p>

Figure 3 [(above)](#figure3) outlines the topology of the terraform template that will deploy the topology described in Figure 4. By leveraging a multi-subscription deployment via provider aliasing, we can use a single template to target multiple Azure subscriptions.

### Architecture: Azure Isolated Service Single Region

The customer’s architecture was deployed using the Azure Isolated Service Single Region template. This template is just one of the available open-source Cobalt templates (see [Application to Other Scenarios](#application-to-other-scenarios)). An overview of the architecture and what happens when one of the customer’s developers starts an Azure DevOps build pipeline is shown in Figure 5.

:::image type="content" source="./media/single-region-architecture.png" alt-text="diagram of Azure Isolated Service, Single Region Architecture":::

<p style="text-align:center;font-style:italic;" role="caption">Figure 5 - Azure Isolated Service, Single Region Architecture</p>

> [!NOTE]
> In the deployment illustrated in Figure 5, all arrows represent https/443 network traffic.

The following steps are outlined in the diagram:

1. A user in the customer network starts the Azure DevOps build pipeline.
2. The customer’s build agent retrieves build task from Azure Pipelines.
3. Build tasks running on the build agent retrieve dependencies from Docker Hub, GitHub, and Terraform.
4. Build tasks running on the build agent provision Resource Groups and Resources in Azure App Service environment.
5. Network connectivity is configured to the App Service environment via service endpoints.

<!-- Editor Note: item 5 above does not agree with Fig 5. Fix the inconsistency. -->

### Containerized CI/CD

Figure 6 illustrates how a developer checks code into GitHub and triggers the CI Build process.

:::image type="content" source="./media/containerized-cicd.png" alt-text="diagram of containerized CI/CD process flow":::

<p style="text-align:center;font-style:italic;" role="caption">Figure 6 - Containerized CI/CD</p>

When checked into GitHub, the code is validated to ensure that newly added and/or modified Terraform templates are operating correctly when deployed to the development environment. Once registered in the Azure Container Repository (ACR), the container is deployed to App Service so it can be accessed by consumer applications.

### Application to Other Scenarios

The Cobalt solution is particularly useful for organizations looking to move or develop applications in the cloud. It is also useful for organizations who want to automate the process with reusable templates to handle new permutations of enterprise-grade CI/CD implementations. And, for deploying highly available application services in Azure Application Service Containers such as Application Gateway, API Management, CosmosDB, Datastore, and KeyVault.

<!-- Editor Note: rewrite para above. Break up long sentence. -->

Currently, there are 3 standard templates available on [GitHub](https://github.com/microsoft/cobalt/tree/master/infra/templates). Because Cobalt templates are open source, it is possible for the open-source community to contribute additional templates to this repo. At the time of this writing, the 3 standard templates available:

* __az-hello-world__: This template is a sample reference for running a single public Linux Container within an Azure Application Service Plan.
* __az-service-single-region__: This template is intended to be a reference for running a single region Linux Container Azure Application Service Plan. This template exposes the App Service containers to an external service endpoint through Application Gateway and Traffic Manager. With this template, it’s possible to be a tenant on a VM sharing network and compute resources with other tenants.
* __az-isolated-service-single-region__: This template implements admin components of the az-service-single-region template, isolated as the only tenant on its own VM, and isolates network traffic.

## Cobalt vs Bedrock

Cobalt hosts reusable Terraform modules to scaffold managed container services like [ACI](https://docs.microsoft.com/en-us/azure/container-instances/) and [Application Services](https://docs.microsoft.com/en-us/azure/app-service/) following a DevOps workflow. While [Bedrock](https://github.com/Microsoft/bedrock) targets Kubernetes based container orchestration workloads while following a [GitOps](https://medium.com/@timfpark/highly-effective-kubernetes-deployments-with-gitops-c7a0354f1446) workflow. Cobalt templates (manifests) reference Terraform modules like virtual networks, traffic manager, and so on, to define infrastructure deployments. Bedrock uses Terraform to pre-configure environment deployment, but also uses Fabrikate templates to define manifests for deployment automation.

## Conclusions

### Lessons Learned

When working with large organizations, it’s important to build accommodations into Cobalt if support is required for multiple Azure Subscriptions, unusual Resource Group setups, or to mitigate concerns about Identity (MSI) creation.

Support for Disaster Recovery (DR) has been documented but has not yet been implemented by the customer.

We discovered that when managing the local state of Terraform resources and deployments, if another user tried to deploy the same resources, the deployment would either fail or overwrite the previous one, which is why remote states are used. However, if everyone uses the same remote state for deployments, whether for environments, apps or both, the state would get polluted and/or corrupted. To prevent this issue, Cobalt generates individual states per template, per environment, to ensure a single state for each.

### Highlights

The ability to point to a version file and only require the application development team to configure a couple of files to reference the platform and infrastructure for their applications, “version and go,” is a huge benefit to simplify the developers' efforts.

Cobalt is open source and we encourage developers to contribute new templates for the repository. More information about creating new templates can be found on GitHub. A link to the web site is provided in the Resources section at the end of this document.

### Recommendations

Ensure that resources are managed via Cobalt templates and not manually created to prevent them being destroyed on subsequent Cobalt provisioning runs. Consider adding locks on resource group so that nothing is destroyed until you remove the locks.

### Identified Patterns

* az-isolated-service-single-region
* az-service-single-region

## Next Steps

If you want to know more about Cobalt, here is where to go next.

| Subject | Description |
|---|---|
| [Cobalt Project Repo](https://github.com/Microsoft/cobalt) | This is the public repository for Cobalt and contains more information on how to get started. |
| [Getting Started for Cobalt Developers](https://github.com/microsoft/cobalt/blob/master/docs/GETTING_STARTED_COBALT_DEV.md) | Start here if you want to contribute to the Cobalt repository to create new advocated pattern templates or pipelines. |
| [Getting Started for Advocated Pattern Owners](https://github.com/microsoft/cobalt/blob/master/docs/GETTING_STARTED_ADD_PAT_OWNER.md) | Start here if you want to maintain advocated pattern templates from Cobalt templates within your organization. Typically this will be the first step in leveraging Cobalt at your organization.
| [Getting Started for Application Developers](https://github.com/microsoft/cobalt/blob/master/docs/GETTING_STARTED_APP_DEV_CLI.md) | Start here if your organization already uses Cobalt and you want to deploy an advocated pattern to host your application. |

## Resources

* [Azure Container Registry and Service Principles](https://github.com/ianphil/iphilpot.github.io/blob/master/_posts/2019-08-05-acr-pull-key-vault.md): This blog post by Ian Philpot describes a workaround for using a Managed Identity for the App Service rather than simply enabling admin access to the Azure Container Registry (ACR).
* [Deploying App Service into ASE](https://github.com/microsoft/cobalt/blob/master/infra/templates/az-isolated-service-single-region/docs/design.md): This post describes how customers can deploy to a single-tenant fleet of hosts running in a secure and isolated network that can be hooked into internal client-owned networks without traversing the public internet.
* [Terraform website](https://www.terraform.io/)
* [HCL Reference](https://github.com/hashicorp/hcl)
* [Join the Cobalt community on Slack](https://publicslack.com/slacks/https-bedrockco-slack-com/invites/new)

## Credits

<!-- Ian Philpot, Erik Schlegel, Nick Iodice, Megan Meyer, Dexter Williams, Keith Rome, Stephen Henderson, James Nance -->

:::row:::
    :::column:::
        Ian Philpot  
        Erik Schlegel
    :::column-end:::
    :::column:::
        Nick Iodice  
        Megan Meyer
    :::column-end:::
    :::column:::
        Dexter Williams  
        Keith Rome
    :::column-end:::
    :::column:::
        Stephen Henderson  
        James Nance
    :::column-end:::
:::row-end:::
