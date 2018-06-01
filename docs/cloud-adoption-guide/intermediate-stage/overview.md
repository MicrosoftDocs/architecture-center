---
title: "Adopting Azure: Intermediate" 
description: Describes the intermediate level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Azure Cloud Adoption Guide: Intermediate Overview

In the foundational adoption stage, you were introduced to the basic concepts of Azure resource governance. The foundational stage was designed to get you started with your Azure adoption journey, and it walked you through how to deploy a simple workload with a single small team. In reality, most large organizations have many teams that are working on many different workloads at the same time. As you would expect, a simple governance model is not sufficient to manage more complex organizational and development scenarios.

The focus of the intermediate stage of Azure adoption is designing your governance model for multiple teams working on multiple new Azure development workloads.  

The audience for this stage of the guide is the following personas within your organization:
- *Finance:* owner of the financial commitment to Azure, responsible for developing policies and procedures for tracking resource consumption costs including billing and chargeback.
- *Central IT:* responsible for governing your organization's cloud resources including resource management and access, as well as workload health and monitoring.
- *Shared infrastructure owner*: technical roles responsible for network connectivity from on-premises to cloud.
- *Security operations*: responsible for implementing security policy necessary to extend on-premises security boundary to include Azure. May also own security infrastructure in Azure for storing secrets.
- *Workload owner:* responsible for publishing a workload to Azure. Depending on the structure of your organization's development teams, this could be a development lead, a program management lead, or build engineering lead. Part of the publishing process may include the deployment of resources to Azure.
  - *Workload contributor:* responsible for contributing to the publishing of a workload to Azure. May require read access to Azure resources for performance monitoring or tuning. Does not require permission to create, update, or delete resources.

## Section 1: Azure concepts for multiple workloads and multiple teams

In the foundational adoption stage, you learned some basics about Azure internals and how resources are created, read, updated, and deleted. You also learned about identity and that Azure only trusts Azure Active Directory (AD) to authenticate and authorize users who need access to those resources.

You also started learning about how to configure Azure's governance tools to manage your organization's use of Azure resources. In the foundational stage we looked at how to govern a single team's access to the resources necessary to deploy a simple workload. In reality, your organization is going to be made up of multiple teams working on multiple workloads simultaneously. 

Before we begin, let's take a look at what the term **workload** actually means. It's a term that is typically understood to define an arbitrary unit of functionality such as an application or service. We think about a workload in terms of the code artifacts that are deployed to a server as well as any other services, such as a database, that are necessary. This is a useful definition for an on-premises application or service but in the cloud we need to expand on it. 

In the cloud, a workload not only encompasses all the artifacts but also includes the cloud resources as well. We include cloud resources as part of our definition because of a concept known as **infrastructure-as-code**. As you learned in the "how does Azure work" explainer, resources in Azure are deployed by an orchestrator service. The orchestrator service exposes this functionality through a web API, and this web API can be called using several tools such as Powershell, the Azure command line interface (CLI), and the Azure portal. This means that we can specify our resources in a machine-readable file that can be stored along with the code artifacts associated with our application.

This enables us to define a workload in terms of code artifacts and the necessary cloud resources, and this further enables us to **isolate** our workloads. Workloads may be isolated by the way resources are organized, by network topology, or by other attributes. The goal of workload isolation is to associate a workload's specific resources to a team so the team can independently manage all aspects of those resources. This enables multiple teams to share resource management services in Azure while preventing the unintentional deletion or modification of each other's resources.

This isolation also enables another concept known as [DevOps](https://azure.microsoft.com/solutions/devops/). DevOps includes the software development practices that include both software development and IT operations above, but adds the use of automation as much as possible. One of the principles of DevOps is known as continuous integration and continuous delivery (CI/CD). Continuous integration refers to the automated build processes that are run each time a developer commits a code change, and continuous delivery refers to the automated processes that deploy this code to various **environments** such as a **development environment** for testing or a **production environment** for final deployment.

## Section 2: Governance design for multiple teams and multiple workloads

In the [foundational stage](/azure/architecture/cloud-adoption-guide/adoption-intro/overview) of the Azure cloud adoption guide, you were introduced to the concept of cloud governance. You learned how to design a simple governance model for a single team working on a single workload. 

In the intermediate stage, the [governance design guide](governance-design-guide.md) expands on the foundational concepts to add multiple teams, multiple workloads, and multiple environments. Once you've gone through the examples in the document you can apply the design principles to designing and implementing your organization's goverance model.

## Section 3: Implementing a resource management model

Your organization's cloud governance model represents the intersection between Azure's resource access management tools, your people, and the access management rules you've defined. 
In the goverance design guide, you learned about several different models for governing access to Azure resources. Now we'll walk through the steps necessary to implement the resource management model with one subscription for each of the **shared infrastructure**, **production**, and **development** environments from the design guide. We'll have one **subscription owner** for all three environments. Each workload will be isolated in a **resource group** with a **workload owner** added with the **contributor** role.

> [!NOTE] Read [understanding resource access in Azure][understand-resource-access-in-azure] to learn more about the relationship between Azure Accounts and subscriptions. 

Follow these steps:

1. Create an [Azure account](/azure/active-directory/sign-up-organization) if your organization doesn't already have one. The person who signs up for the Azure account becomes the Azure account administrator, and your organization's leadership must select an individual to assume this role. This individual will be responsible for:
  * creating subscriptions, and
  * creating and administering [Azure Active Directory (AD)](/azure/active-directory/active-directory-whatis) tenants that store user identity for those subscriptions.    
2. Your organization's leadership team decides which people are responsible for:
  * Management of user identity; an [Azure AD tenant](/azure/active-directory/develop/active-directory-howto-tenant) is created by default when your organization's Azure Account is created, and the account administrator is added as the [Azure AD global administrator](/azure/active-directory/active-directory-assign-admin-roles-azure-portal#details-about-the-global-administrator-role) by default. Your organization can choose another user to manage user identity by [assigning the Azure AD global administrator role to that user](/azure/active-directory/active-directory-users-assign-role-azure-portal). 
  * Subscriptions, which means these users:
    * manage costs associated with resource usage in that subscription,
    * implement and maintain least permission model for resource access, and
    * keep track of service limits.
  * Shared infrastructure services (if your organization decides to use this model), which means this user is responsible for:
    * on-premises to Azure network connectivity, and 
    * ownership of network connectivity within Azure through virtual network peering.
  * Workload owners. 
3. The Azure AD global administrator [creates the new user accounts](/azure/active-directory/add-users-azure-active-directory) for:
  * the person who will be the **subscription owner** for each subscription associated with each environment. Note that this is necessary only if the subscription **service administrator** will not be tasked with managing resource access for each subscription/environment.
  * the person who will be the **network operations user**, and
  * the people who are **workload owner(s)**.
4. The Azure account administrator creates the following three subscriptions using the [Azure account portal](https://account.azure.com):
  * a subscription for the **shared infrastructure** environment,
  * a subscription for the **production** environment, and 
  * a subscription for the **development** environment. 
5. The Azure account administrator [adds the subscription service owner to each subscription](/azure/billing/billing-add-change-azure-subscription-administrator#add-an-rbac-owner-admin-for-a-subscription-in-azure-portal).
6. Create an approval process for **workload owners** to request the creation of resource groups. The approval process can be implemented in many ways, such as over email, or you can using a process management tool such as [Sharepoint workflows](https://support.office.com/article/introduction-to-sharepoint-workflow-07982276-54e8-4e17-8699-5056eff4d9e3). The approval process can follow these steps:
  1. The **workload owner** prepares a bill of materials for required Azure resources in either the **development** environment, **production** environment, or both, and submits it to the **subscription owner**.
  2. The **subscription owner** reviews the bill of materials and validates the requested resources to ensure that the requested resources are appropriate for their planned use - for example, checking that the requested [virtual machine sizes](/azure/virtual-machines/windows/sizes) are correct.
  3. If the request is not approved, the **workload owner** is notified. If the request is approved, the **subscription owner** [creates the requested resource group](/azure/azure-resource-manager/resource-group-portal#manage-resource-groups) following your organization's [naming conventions](/azure/architecture/best-practices/naming-conventions), [adds the **workload owner**](/azure/role-based-access-control/role-assignments-portal#add-access) with the [**contributor** role](/azure/role-based-access-control/built-in-roles#contributor) and sends notification to the **workload owner** that the resource group has been created.
7. Create an approval process for workload owners to request a virtual network peering connection from the shared infrastructure owner. As with the previous step, this approval process can be implemented using email or a process management tool.

Now that you've implemented your governance model, you can deploy your shared infrastructure services.

## Section 4: deploy shared infrastructure services

There are several [hybrid network reference architectures](/azure/architecture/reference-architectures/hybrid-networking/) that your organization can use to connect your on-premises network to Azure. Each of these reference architectures includes a deployment that requires a subscription identifier. During deployment, specify the subscription identifier for the subscription associated with your **shared infrastructre** environment. You will also need to edit the template files to specify the resource group that is managed by your **network operations** user, or, you can use the default resource groups in the deployment and add the **network operations** user with the **contributor** role to them.

<!-- links -->
[understand-resource-access-in-azure]: /azure/role-based-access-control/rbac-and-directory-admin-roles