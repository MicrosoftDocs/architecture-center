---
title: Use Cobalt to create an extensible cloud framework
titleSuffix: Azure Example Scenarios
description: Cobalt is an extensible framework that uses templates to define the automated process of creating complex and enterprise-grade CI/CD implementations to deploy highly available applications to Web App for Containers.
author: doodlemania2
ms.author: pnp
ms.date: 7/31/2020
ms.topic: overview
ms.service: architecture-center
ms.subservice: example-scenario
ms.category: 
    - management-and-governance
ms.custom: 
    - fcp
    - cse
---

# Use Cobalt to create an extensible cloud framework

Standardizing and automating the process of building production-ready cloud native managed service solutions is an important need for major enterprise customers. The customers need to achieve higher productivity, higher efficiency, and easier compliance with security, governance, and privacy. The Microsoft commercial software engineering (CSE) team engaged with a Fortune 50 retailer.

The goal was to enable the customer's teams to build such solutions based on one or more specified patterns in an enterprise pattern library. There was a need to elevate this effort by creating a framework that can materialize such patterns. The CSE team leveraged the Cobalt framework to achieve that goal.

Cobalt is an extensible framework that uses templates. The templates define the automated process of creating complex and enterprise-grade continuous integration and continuous deployment (CI/CD) implementations. The system is used to deploy highly available applications to _Web App for Containers_. Developers deploy the infrastructure using versioned files containing the reusable templates. The templates contain the infrastructure and platform details and developers can customize or reuse them as needed.

Using Cobalt reduces the amount of time required to get apps through customers' security and compliance review process. With Cobalt, they can abstract the complexities of cloud-native computing away from app developer teams. The app developer teams can concentrate on rapidly building apps in a repeatable way that not only follows DevOps best practices, but are highly secure and resilient. Apps like this can take advantage of managed services and continuous delivery for better reliability. Cobalt also dramatically reduces time required to deploy complex applications.

## Use case

The customer for this solution needed a solution that would enable the migration of hundreds of their line of business (LOB) applications to cloud-based enterprise-grade production systems based on pre-approved architectures for Web App for Containers. Then, they needed to develop new applications in the cloud based on those architectures.

A security risk and compliance team needs to review and approve each solution before the development team could implement it. Automation would significantly reduce the time needed in the review process for applications and make migrations and new deployments take place faster. This automation would include the build of such solutions based on predefined patterns that address security and other concerns.

### Requirements and success criteria

The customer wanted a framework that provides high availability for multi-datacenter deployments using geo-based routing, robust health probes, and automated failover. That framework needed to include:

* A reliable DevOps solution comprised of CI builds and tests for new pull requests.

* A simple CD solution in which new pull requests were automatically deployed to a development environment.

* The capability for manual promotion to Quality Assurance (QA), staging, and production environments.

The customer wanted to have a working reference solution including all scoped components functioning, documented, and running on their Azure subscription. The customer also wanted to enable their teams to select from a library of pre-configured templates to create App Service-based applications. The reference solution and templates had to meet the customer's internal security team's technical compliance guidelines based on their regulations, policies, and standards.

They also had to provide for secure data with secrets stored in Key Vault to meet their security and compliance requirements. Only then would Cobalt gain approval at the platform level. After approval and adoption, publishing new apps to the cloud using Cobalt would be quicker and easier than in the past.

## Architecture

The team deployed the customer’s architecture using the [az-isolated-service-single-region](https://github.com/microsoft/cobalt/tree/master/infra/templates/az-isolated-service-single-region) template. The following diagram shows an overview of the architecture and what happens when the developer starts an Azure DevOps build pipeline:

:::image type="content" border="false" source="./media/single-region-architecture.png" alt-text="Diagram of Azure Isolated Service, Single Region Architecture.":::

> [!NOTE]
> All of the arrows in this diagram represent https/443 network traffic.

The diagram outlines the following steps:

1. A user in the customer network starts the Azure DevOps build pipeline.

1. The customer’s build agent retrieves the build task from Azure Pipelines.

1. Build tasks running on the build agent retrieve dependencies from Docker Hub, GitHub, and [Terraform](https://www.terraform.io/).

1. Build tasks running on the build agent provision resource groups and resources in Azure App Service environment.

1. Service endpoints configure network connectivity to the App Service environment.

### Technical scenario

At a high level, Cobalt leverages templates to automate the implementation of the technical tasks and services based on architectural patterns that a developer has predefined. A Cobalt infrastructure template is a *manifest*. It's made up of Terraform modules. The template groups the modules into various Azure resources.

Originally, the CSE team designed the template to be forked and coded so that developers could include the platform and infrastructure needs for applications. However, the customer found that approach to be too resource-intensive. So, the CSE team modified the process to a _version and go_ model.

After initializing and integrating Cobalt into their existing Azure DevOps pipeline, the customer only needed to point to a version file and make some changes to the configuration to use it in the deployment of an application. The developers categorized Cobalt's template module registry by cloud provider and then resource type. Each module represents an abstraction for a set of related cloud infrastructure objects that the module will manage.

This diagram shows the steps involved in using Cobalt to provision resources in Azure.  

:::image type="content" border="false" source="./media/cobalt-framework.png" alt-text="Overview diagram of Cobalt framework.":::

In general, the Cobalt process works like this:

1. Choose a DevOps provider workflow and set up Cobalt CI/CD pipelines.

1. Customize an existing Cobalt template or create a new one.

    The templates host reusable Terraform modules like virtual networks and traffic managers to scaffold various managed container services.

1. Code, test, and commit changes to the template to an upstream GitHub repository.

1. Finally, Cobalt automatically provisions and configures the cloud resources specified in the template.

### Prerequisites

Anyone using Cobalt needs to have the following prerequisites in place:

* Azure subscription with global admin role perms in Azure AD

* Azure resource groups, ACR, Key Vault, virtual networks set up

* Permissions to Azure DevOps organization and instance (means project?)

* Terraform

### Cobalt templates and provisioned infrastructure

The Microsoft CSE team worked with the customer to customize templates for provisioning a best practices implementation of App Services. Their goal was to create templates that application development teams could later use to migrate or build their own LOB applications. The developers organized the Cobalt templates to handle the provisioning of infrastructure and the setup of CI/CD pipelines.

Templates are the implementation of *advocated patterns*. The scope of a template typically covers most, if not all, of the infrastructure required to host an application and may provision resources in multiple cloud providers. Templates compose modules to create an advocated pattern. Developers implement them as [Terraform modules](https://www.terraform.io/docs/configuration/modules.html) (also sometimes known as *Cobalt modules*) so that developers can compose them if needed. It's more common that developers don't need to compose them.

The developers categorized Cobalt's module registry by cloud provider then resource type. Each module represents an abstraction for the set of related cloud infrastructure objects that the module will manage.

A module is a thin wrapper that enables simple common-sense configuration of related resources (typically 1-3 but sometimes more) within a cloud provider. The directory structure of [Cobalt](https://github.com/microsoft/cobalt) enables contributions for different cloud providers. Developers can find Cobalt infrastructure templates in the *infra/templates* folder. Each subfolder represents a unique deployment schema packaged with:

* A set of Terraform scripts.

* Overview and setup instructions.

* Automated unit and integration tests.

A good example of a simple template is [az-hello-world](https://github.com/microsoft/cobalt/tree/master/infra/templates/az-hello-world). The developers intended the **az-hello-world** template to be a reference for running a single public Linux container within an [Azure App Service Plan](https://azure.microsoft.com/pricing/details/app-service/plans/). This particular template creates an Azure environment with the smallest infrastructure footprint and is the recommended template highlighted in the [quickstart guide](https://github.com/microsoft/cobalt/blob/master/docs/2_QUICK_START_GUIDE.md). This screenshot shows a list of the files:

:::image type="content" source="./media/hello-world-template-set.png" alt-text="Screenshot of typical template structure.":::

Developers wrote the template files in HashiCorp Configuration Language (HCL). It's the Terraform configuration language. HCL files have the file extension `.tf`. Each template consists of Terraform modules that handle provisioning the services required by the deployed application including the services needed for:

* Scalable application deployments.

* Application and infrastructure observability and monitoring.

* Security and compliance.

* Other isolated application dependencies for things like:

  * [Storage](https://azure.microsoft.com/services/#storage)

  * [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) integration

  * [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/)

Here is the template structure for the [az-isolated-service-single-region](https://github.com/microsoft/cobalt/tree/master/infra/templates/az-isolated-service-single-region) template. It's a mapping of Cobalt modules to Azure services and features. Cobalt templates can use any of several Terraform modules. Cobalt uses them to provision services provided by Azure. The following diagram illustrates these modules and how they map to Azure services and features according to the topology discussed in the [Deployment Topology](#deployment-topology) section:

:::image type="content" border="false" source="./media/cobalt-module-mapping-azure.png" alt-text="Diagram of how Terraform modules map to Azure services and features.":::

Although developers could use [Azure Resource Manager (ARM)](https://azure.microsoft.com/features/resource-manager/) templates to deploy the infrastructure, the team selected Terraform for a number of reasons:

* Terraform uses HCL. Many consider HCL to be more human-readable than the JavaScript Object Notation (JSON) format that ARM templates use.

    To increase compatibility, developers made sure that Terraform can also consume machine-generated JSON files.

* Terraform provides excellent state management, allows [idempotent](https://www.restapitutorial.com/lessons/idempotency.html) updates, and minimizes the surface area that it touches when updating deployments.

* Terraform promotes modular reusability, reducing redundant infrastructure components, and improves ease of maintenance and readability.

* The customer preferred using a small number of recommended technologies. Since the CSE team had also recommended Terraform as the solution for deploying [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) clusters, it seemed sensible to use the same solution for Azure App Service.

### Deployment topology

The diagram in this section shows the targeted [az-isolated-service-single-region](https://github.com/microsoft/cobalt/tree/master/infra/templates/az-isolated-service-single-region) deployment topology needed by the enterprise customer. This deployment splits across three Azure subscriptions. The diagram partitions the resources to align with the different _personas_ within the customer organization. For example, Azure subscriptions 1 and 3 are where admin resources exist, but Azure subscription 2 hosts the application developer team resources.

:::image type="content" border="false" source="./media/deployment-single-region-topology.png" alt-text="diagram showing deployment topology if Azure isolated service single region":::

By leveraging a multi-subscription deployment via provider aliasing, the customer can use a single template to target multiple Azure subscriptions.

### Containerized CI/CD

The following diagram illustrates how a developer checks code into GitHub and triggers the CI Build process.

:::image type="content" border="false" source="./media/containerized-cicd.png" alt-text="Diagram of containerized CI/CD process flow.":::

When checked into GitHub, the system validates the code to ensure that newly added or modified Terraform templates are operating correctly when deployed to the development environment. Once registered in the ACR, the solution deploys the container to App Service so consumer applications can access it.

## Components

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory/)

* [Azure App Service](https://azure.microsoft.com/services/app-service/)

* [Web App for Containers](https://azure.microsoft.com/services/app-service/containers/)

* [Azure Container Registry (ACR)](https://azure.microsoft.com/services/container-registry/)

* [Azure DevOps](https://azure.microsoft.com/services/devops/)

* [Azure Key Vault](https://azure.microsoft.com/services/key-vault/)

* [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines/)

## Considerations

* Lessons Learned

  * When working with large organizations, find out if they require support for multiple Azure subscriptions or unusual Resource Group setups. They may also need to mitigate concerns about the creation of [managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview). If so, it’s important to build accommodations into Cobalt to account for those requirements.

  * The CSE team discovered an interesting quirk in the system. When managing the local state of Terraform resources and deployments, if another user tried to deploy the same resources, the deployment would either fail or overwrite the previous one. To avoid this scenario, they decided to use remote states. However, if everyone used the same remote state for deployments, whether for environments, apps, or both, the state would get polluted or corrupted. To prevent this issue, Cobalt generates individual states per template, per environment, to ensure a single state for each.

* Highlights

  * There's a huge benefit in the ability to point to a version file and only require the application development team to configure a couple of files to reference the platform and infrastructure for their applications. It simplifies the developers' efforts.

  * Cobalt is open source. Its developers encourage other developers to contribute new templates to the repository. Developers can find more information about creating new templates on GitHub.

* Recommendations

  * Make sure that Cobalt templates manage your resources. If developers manually create the resources, later Cobalt provisioning runs will destroy them. Consider adding locks on resource group so no processes can destroy them until developers remove the locks.

## Next steps

If you want to know more about Cobalt, here is where to go next:

* [Cobalt Project Repo](https://github.com/Microsoft/cobalt): The public repository for Cobalt. It contains more information on how to get started.

  * [Getting Started for Cobalt Developers](https://github.com/microsoft/cobalt/blob/master/docs/GETTING_STARTED_COBALT_DEV.md): Where to start if you want to contribute to the Cobalt repository to create new advocated pattern templates or pipelines.

  * [Getting Started - Advocated Pattern Owner](https://github.com/microsoft/cobalt/blob/master/docs/GETTING_STARTED_ADD_PAT_OWNER.md): Start here if you want to maintain advocated pattern templates from Cobalt templates. It will be the first step in leveraging Cobalt at your organization.

  * [Getting Started - Application Developer - Azure CLI](https://github.com/microsoft/cobalt/blob/master/docs/GETTING_STARTED_APP_DEV_CLI.md): If your organization already uses Cobalt and you want to deploy an advocated pattern to host your application, start with this one.

## Related resources

* [Azure Container Registry and Service Principals](https://github.com/ianphil/iphilpot.github.io/blob/master/_posts/2019-08-05-acr-pull-key-vault.md): This blog post by Ian Philpot describes a workaround for using a Managed Identity for the App Service rather than simply enabling admin access to the ACR.

* [Deploying App Service into ASE](https://github.com/microsoft/cobalt/blob/master/infra/templates/az-isolated-service-single-region/docs/design.md): A post that describes how customers can deploy to a single-tenant fleet of hosts running in a secure and isolated network that they can hook into internal client-owned networks without traversing the public internet.

* [Terraform website](https://www.terraform.io/)

* [HCL Reference](https://github.com/hashicorp/hcl)
