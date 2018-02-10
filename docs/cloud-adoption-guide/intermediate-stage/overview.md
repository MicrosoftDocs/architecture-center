---
title: "Adopting Azure: Intermediate" 
description: Describes the intermediate level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Adopting Azure: Intermediate

In the foundational adoption stage, you learned the basics about digital identity, subscription, and resource management. You used this knowledge to create your first resources in Azure. The next stage in adopting Azure is the intermediate stage. The intermediate stage builds on the foundational stage by adding the management of multiple workloads and the architecture of more complex workloads.

The list below includes the tasks for completing the intermediate adoption stage.

* x. Understand Azure Internals: Software-defined networking
    - **Explainer:** in the foundational stage of Azure adoption, you learned about virtualization. You were also introduced to the concept of a **virtual network**. You can imagine that any one time, there are a large number of virtual networks in any given Azure datacenter belonging to multiple customers. So how does software defined networking work?
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
        - in preparation for deploying our n-tier architecture to Azure, we need to set u
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
        - what is OMS?
* x. Architecture: deploy an n-tier workload to Azure
    - deploy an n-tier architecture to Azure
        - **How to:** deploy a Windows VM n-tier architecture using ARM
            - uses the network created above
        - **How to:** deploy a Linux VM n-tier architecture using 
        - **Guidance:** best practices for deploying an n-tier application

