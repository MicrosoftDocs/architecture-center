---
title: "Adopting Azure: Intermediate" 
description: Describes the intermediate level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Adopting Azure: Intermediate

In the foundational adoption stage, you were introduced to the basic concepts of Azure resource governance. The foundational stage was designed to get you started with your Azure adoption journey, and it walked you through how to deploy a simple workload with a single small team. In reality, most large organizations have many teams that are working on many different workloads at the same time. As you would expect, a simple governance model is not sufficient to manage more complex organziational and development scenarios.

The audience for this stage of the guide is the following personas within your organization:
- *Finance:* owner of the financial commitment to Azure, responsible for developing policies and procedures for tracking resource consumption costs including billing and chargeback.
- *Central IT:* responsible for governing your organization's cloud resources including resource management and access, and workload health and monitoring.
- *Shared infrastructure owners*: technical roles responsible for managing networking connectivity from  on-premises to cloud, including implementing goverance policies as . 
- *Workload owners:* all development roles that are involved in deploying workloads to Azure, including developers, testers, and build engineers.
    - *Workload contributors*: development team members that report to the *workload owner* persona.

One of the most difficult things about planning your enterprise's journey to the cloud is determining an appropriate area to begin. For example, should your organization begin by deciding on how to re-structure on-premises roles and responsibilities to handle resource management in the cloud, or, should you begin by evaluating your on-premises workloads and designing the technical aspects of your cloud architecture to meet those needs first?

## Section 1: Azure concepts for multiple workloads and multiple teams

In the foundational adoption stage, you learned some basics about Azure internals and how resources are created, read, updated, and deleted. You also learned about identity and that Azure only trusts Azure Active Directory (AD) to authenticate and authorize users who need access to those resources.

You also started learning about how to configure Azure's governance tools to manage your organization's use of Azure resources. In the foundational stage we looked at how to govern a single team's access to the resources necessary to deploy a simple workload. In reality, your organization is going to be made up of multiple teams working on multiple workloads simultaneously. 

Before we begin, let's take a look at what the term **workload** actually means. It's a term that is typically understood to define an arbitrary unit of functionality such as an application or service. We think about a *workload* in terms of the artifacts that will be deployed to a server as well as any other services, such as a database, that are necessary. This is a useful definition for an on-premises application or service but in the Cloud we need to expand on it. 

In the cloud, a *workload* not only encompasses all the artifacts but also whatever *infrastructure* is necessary as well. We include the infrastructure elements because of a new concept known as **infrastructure-as-code**. *Infrastructure-as-code* allows us to specify resources in a machine readable file. The file is passed to the resource management service in the cloud, and the specified resources are created - either as part of the build and deployment process or as a separate provisioning process. 

This enables us to define a *workload* not only in terms of code artifacts and the necessary cloud resources, but also in terms of the environment for each stage of our *development lifecycle*. For example, we can define a **proof-of-concept** environment in our infrastructure-as-code file that is segmented from our other workloads, allowing for greater developer experimentation. We can define a **production** environment that has the highest governance and security standards for our tested and validated *workload*. 

Since our modern definition of a *workload* includes more elements, we now need a way to organize and manage all the different types of artifacts as a single unit. We also have multiple teams and multiple workloads, so there will also be some shared elements to be manage - such as virtual networking.  

Now that we understand the modern definition of a *workload*, let's take a closer look at the techical differences between platform-as-a-service (PaaS) and infrastructure-as-a-service (IaaS) and the effects these differences have on your governance model. 

The key distinction between IaaS and PaaS is that PaaS includes all the infrastructure elements as IaaS - such as virtual machines (VMs), virtual networking, and virtual storage - but adds a *managed* platform layer upon which applications are deployed. In an IaaS environment, the application developer is responsible for managing the configuration of the entire infrastucture.    

This means that the developer is not responsible for maintaining the underlying infrastructure in the cloud for PaaS offerings. There is a trade-off in that whatever applications are developed and deployed to a PaaS environment must be specifically written to run in that environment. 


You will have *something* running in the cloud. Your users will access the *something* from *somewhere*. Depending on what the something is, and where your users are, you will have to pick a place to put it.

If your *something* should fail for whatever reason, you can make it highly available by having a copy of it running *somewhere else*, and *failing over* to that *somewhere else* if *somewhere* becomes unavailable. 


Section 1: Understanding working with multiple teams and multiple workloads (workload isolation - deeper dive into Azure internals)

Section X: Understanding the impact of geography on Azure adoption



Regardless of your organization's adoption strategy, most organizations share the same basic core technical and organizational requirements. 

* aligning on-premise geographies with cloud regions for performance, business, and compliance reasons
* governing access to resources for cost, compliance, and security reasons
    * creating a curated catalog of approved VM images that are secure and compliant
* extending the on-premise network to include address spaces in the cloud
    * solution: hybrid networking
* aligning current on-premises development practices with cloud development practices
    * solution: infrastructure-as-code
    * solution: CI/CD pipelines 
* reducing technical complexity of ongoing infrastructure and workload maintenance
    * solution: shared services, hub-and-spoke, etc.

 


Every organization is associated with one or more *geographies*. A geography is the physical location where your organization's business centers are located. Your organization may have existing datacenters in these geographies and you are ready to begin planning the migration of *workloads* to Azure. Or, your organization may be considering adding Azure features such as machine learning to existing workloads. 





* software defined networking
    * regions

* 1. Understand Azure Internals: Software-defined networking
    - **Explainer:** [what is software defined networking?](sdn-explainer.md)
* x. Understand workload isolation in Azure
    - **Explainer:** what is a workload, and what does it mean to have multiple workloads hosted in Azure?
        - now that you understand how software-defined networking works, you can see that one strategy for segmenting the network space for multiple workloads is either by full network space (VNet) or by subnet space.
        - do you have multiple VNets and assign a VNet to team, or, a single Vnet with multiple subnets and assign a subnet to a team
* x. Understanding digital identity: intermediate
    - **Explainer:** now that you understand what multiple workloads look like, and how multiple teams will be working concurrently, what are some of the scenarios in which you would want to have multiple AAD tenants?
        - reasons why you would have multiple tenants, and how to manage multiple tenants (i.e. teams in multiple regions, teams in different subsidiaries, etc.)
    - **How to:** create an Azure tenant
    - **Guidance:** intermediate Azure tenant design
* x. Understand subscription management:
    - **Explainer:** internal technical issues about subscriptions, ie. now that you have multiple teams and multiple projects, understand how to use subscriptions to manage costs and limits by various criteria such as team, project, environment, etc.
    - **Guidance:** intermediate subscription design
        - strategies for managing the work of multiple teams with subscriptions
* x. Understand infrastructure as code
    - **Explainer:** what is infrastructure as code; why should I care about infrastructure as code; what is an ARM template; what other tools are available
* x. Understand resource management with multiple teams:
    - **Explainer:**  managing multiple workloads and the work of multiple teams using resource groups
    - **Guidance:** intermediate resource group design
* x. Understand resource access with multiple teams and multiple projects
    - **Explainer:** what is resource-based access control, what is resource policy, how does this work in ARM?
    - **How to:** create an rbac role and assign it to a user, and, how to create a resource policy
    - **Guidance:** best practices for rbac roles and resource policy in Azure
* x. Understand tracking cost information (intro to operations)
    - **Explainer:** introduction to tracking cost and resource usage in Azure
        - now that you understand all the different ways to define a workload, and you know how to associate cost and resource limits with subscriptions...
        - in the foundational adoption stage, you learned about naming resources. Now that you are managing multiple workloads in Azure, you can see that there are difficulties in tracking cost by workload. One of the ways to do this i s using resource tagging.
    - **How to:** track cost in Azure using Cloudyn
    - **Guidance:** best practices for tracking costs in Azure
        - finding unused or underused resources
* x. Understand extending your on-premises security boundary to include Azure
    - **Explainer**: hybrid networking in Azure
        - we want to deploy an n-tier workload that is only reachable from on-premises, and not the public internet
        - in preparation for deploying our n-tier architecture to Azure we need to set up a hybrid newtork with a VPN gateway to encrypt our traffic over the internet
        - difference between public and private cloud
        - public cloud means that the edge routers in Azure are exposed to the internet and what that means for services with public endpoints and what that means for VMs or load balancers with a PIP on them
    - **How to:** create a hybrid network with a VPN gateway
    - **Guidance:** best practices for provisioning a VPN gateway (may merge with how to) 
* x. Understand network security in Azure
    - now that you've connected your on-premises network to Azure, you need to consider network security
    - _Securing the network_
    - **Explainer:** what is an NSG?
    - **How to:** create an NSG and an NSG rule
    - **Guidance:** best practices for Azure network security using NSGs
    - _Restricting access to a secure network_
    - **Explainer:** what is a bastion host/jumpbox
        - what is a bastion host used for, why do I need a bastion host, how do I share use of a bastion host between teams
    - **How to:** create a bastion host/jumpbox
    - **Guidance:** best practices for implementing a bastion host/jumpbox
* x. Understand DevOps in Azure
    - **Explainer:** what is DevOps; what is a CI/CD pipeline; how does infrastructure as code fit into DevOps; 
    - **How to:** create a DevOps pipeline using Visual Studio Online
    - **Guidance**: DevOps in Azure best practices
        -strategies for multiple environments in Azure (PoC, dev, dev non-prod/canary/etc, prod)
        - DevOps tools in Azure: VSTS, Jenkins, Chef/Puppet/Ansible/etc
* x. Understand application monitoring in Azure (operations)
    - **Explainer:** how does application performance monitoring work in Azure?
        - what is OMS? What is app insights? what is log analytics?
* x. Architecture: deploy an n-tier workload to Azure
    - would be nice to have n-tier dialtone app to deploy here, nice to have:
        - set up multiple environments (dev and prod, for example)
        - set up DevOps pipeline to deploy to both environments, dev pipeline includes ARM template to stand up a test environment
        - set up OMS and app insights (possibly log analytics) for app running in prod
    - deploy an n-tier architecture to Azure
        - **How to:** deploy a hybrid network with a VPN gateway (RA)
        - **How to:** deploy a Windows VM n-tier architecture using ARM (RA)
        - **How to:** deploy a Linux VM n-tier architecture using ARM (RA)
        - **Guidance:** best practices for deploying an n-tier application (RA)


