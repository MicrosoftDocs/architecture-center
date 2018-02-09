---
title: "Adopting Azure: Intermediate" 
description: Describes the intermediate level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Adopting Azure: Intermediate

In the foundational adoption stage, you learned the basics about digital identity, subscription, and resource management. You used this knowledge to create your first resources in Azure. The next stage in adopting Azure is the intermediate stage. The intermediate stage builds on the foundational stage by adding the management of multiple workloads and the architecture of more complex workloads.

The list below includes the tasks for completing the intermediate adoption stage.

* x. Understand Azure Internals: Software-defined networking
    - in the foundational stage of Azure adoption, you learned about virtualization. You were also introduced to the concept of a **virtual network**. You can imagine that any one time, there are a large number of virtual networks in any given Azure datacenter belonging to multiple customers. So how does software defined networking work?
* x. Understand workload isolation in Azure
    - Explainer: what is a workload, and what does it mean to have multiple workloads hosted in Azure?
        - now that you understand how software-defined networking works, you can see that one strategy for  segmenting the network space for multiple workloads is either by full network space (VNet) or by subnet space.
        - do you have multiple VNets and assign a VNet to team, or, a single Vnet with multiple subnets and assign a subnet to a team
* x. Understanding digital identity: intermediate
    - now that you understand what multiple workloads look like, and how multiple teams will be working concurrently, what are some of the scenarios in which you would want to have multiple AAD tenants?
    - reasons why you would have multiple tenants, and how to manage multiple tenants (i.e. teams in multiple regions, teams in different subsidiaries, etc.)
* x. Understand subscription management:
    - Explainer: internal technical issues about subscriptions, ie. now that you have multiple teams and multiple projects, understand how to use subscriptions to manage costs and limits by various criteria such as team, project, environment, etc.
    - Guidance: strategies for managing the work of multiple teams with subscriptions
* x. Understand resource management with multiple teams:
    - Explainer:  how to manage multiple workloads and the work of multiple teams using resource groups
* x. Understand infrastructure as code
    - Explainer: what is infrastructure as code; why should I care about infrastructure as coce; what is an ARM template; what other tools are available
* x. Operations: how to aggregate cost information
    - now that you understand all the different ways to define a workload, and you know how to associate cost and resource limits with subscriptions, you are going 
    - in the foundational adoption stage, you learned about naming resources. Now that you are managing multiple workloads in Azure, you can see that there are difficulties in tracking cost by workload. One of the ways to do this i s using resource tagging.
* x. Understand extending your on-premises security boundary to include Azure
    - How to: 
* x. Understand availability and resiliency in the Cloud/Azure
    - Explainer: what is scaling?
    - Explainer: what is an availability set? What is an availability set/zone
    - Explainer: what is a service level agreement?
    - Explainer: load balancing in Azure - 
* x. Understand security in Azure
    - Explainer: what is an NSG?
    - Explainer: extending the on-premises security boundary to Azure
    - How to: set up a jumpbox in Azure
* x. Understand DevOps in Azure
    - How to: strategies for multiple environments in Azure (PoC, dev, dev non-prod/canary/etc, prod)
    - DevOps tools in Azure: VSTS, Jenkins, Chef/Puppet/Ansible/etc
* x. Architecture: deploy an n-tier workload to Azure

