---
title: "Adopting Azure: Intermediate" 
description: Describes the intermediate level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Governance design walkthrough: new development in Azure for multiple teams

In the foundational adoption stage, you were introduced to the basic concepts of Azure resource governance. The foundational stage was designed to get you started with your Azure adoption journey, and it walked you through how to deploy a simple workload with a single small team. In reality, most large organizations have many teams that are working on many different workloads at the same time. As you would expect, a simple governance model is not sufficient to manage more complex organziational and development scenarios.

The audience for this stage of the guide is the following personas within your organization:
- *Finance:* owner of the financial commitment to Azure, responsible for developing policies and procedures for tracking resource consumption costs including billing and chargeback.
- *Central IT:* responsible for governing your organization's cloud resources including resource management and access, as well as workload health and monitoring.
- *Shared infrastructure owner*: technical roles responsible for network connectivity from on-premises to cloud.
- *Security operations*: responsible for implementing security policy necessary to extend on-premises security boundary to include Azure. May also own security infrastructure in Azure for storing secrets.
- *Workload owner:* responsible for publishing a workload to Azure. Depending on the structure of your organization's development teams, this could be a development lead, a program management lead, or build engineering lead. Part of the publishing process may include the deployment of resources to Azure.
    - *Workload contributor:* responsible for contributing to the publishing of a workload to Azure. May require read access to Azure resources for performance monitoring or tuning. Does not require permission to create, update, or delete resources.

One of the most difficult things about planning your enterprise's journey to the cloud is determining an appropriate area to begin. For example, should your organization begin by deciding on how to re-structure on-premises roles and responsibilities to handle resource management in the cloud, or, should you begin by evaluating your on-premises workloads and designing the technical aspects of your cloud architecture to meet those needs first?

## Section 1: Azure concepts for multiple workloads and multiple teams

In the foundational adoption stage, you learned some basics about Azure internals and how resources are created, read, updated, and deleted. You also learned about identity and that Azure only trusts Azure Active Directory (AD) to authenticate and authorize users who need access to those resources.

You also started learning about how to configure Azure's governance tools to manage your organization's use of Azure resources. In the foundational stage we looked at how to govern a single team's access to the resources necessary to deploy a simple workload. In reality, your organization is going to be made up of multiple teams working on multiple workloads simultaneously. 

Before we begin, let's take a look at what the term **workload** actually means. It's a term that is typically understood to define an arbitrary unit of functionality such as an application or service. We think about a *workload* in terms of the artifacts that will be deployed to a server as well as any other services, such as a database, that are necessary. This is a useful definition for an on-premises application or service but in the Cloud we need to expand on it. 

In the cloud, a *workload* not only encompasses all the artifacts but also whatever *infrastructure* is necessary as well. We include the infrastructure elements because of a new concept known as **infrastructure-as-code**. *Infrastructure-as-code* allows us to specify resources in a machine readable file. The file is passed to the resource management service in the cloud, and the specified resources are created - either as part of the build and deployment process or as a separate provisioning process. 

This enables us to define a *workload* not only in terms of code artifacts and the necessary cloud resources, but also in terms of the environment for each stage of our *development lifecycle*. For example, we can define a **proof-of-concept** environment in our infrastructure-as-code file that is segmented from our other workloads, allowing for greater developer experimentation. We can define a **production** environment that has the highest governance and security standards for our tested and validated *workload*. 

## Section 2: Governance design for multiple teams and multiple workloads

## Section 3: Implementing a resource management model

* How to: set up and configure your organization's Azure Enterprise Agreement. 