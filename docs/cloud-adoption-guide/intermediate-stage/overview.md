---
title: "Adopting Azure: Intermediate" 
description: Describes the intermediate level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Adopting Azure: Intermediate

In the foundational adoption stage, you learned the basics about digital identity, subscription, and resource management. You used this knowledge to create your first resources in Azure. The next stage in adopting Azure is the intermediate stage. The intermediate stage builds on the foundational stage by adding the management of multiple workloads and the architecture of more complex workloads.

The list below includes the tasks for completing the intermediate adoption stage.

x. Understand multiple workloads in Azure
    - Explainer: what is a workload, and what does it mean to have multiple workloads hosted in Azure?
        - segmenting the network space for multiple workloads
        - do you have multiple VNets and assign a VNet to team, or, a single Vnet with multiple subnets and assign a subnet to a team
    - Explainer: what is meant by Azure "regions"?
x. Understanding digital identity: intermediate
    - now that you understand what multiple workloads look like in Azure
    - reasons why you would have multiple tenants, and how to manage multiple tenants (i.e. teams in multiple regions, teams in different subsidiaries, etc.)
x. Subscriptions: now that you have multiple teams and multiple projects, understand how to use subscriptions to manage costs and limits by various criteria such as team, project, environment, etc.
x. Resource management: how to manage multiple workloads and the work of multiple teams using resource groups
    - Explainer: what is role-based access control/what is resource policy?
x. Operations: how to manage cost
    - now that you understand all the different ways to define a workload, and you know how to associate cost and resource limits with subscriptions, you are going 
    - in the foundational adoption stage, you learned about naming resources. Now that you are managing multiple workloads in Azure, you can see that there are difficulties in tracking cost by workload. One of the ways to do this is using resource tagging. 
x. Understand availability and resiliency in the Cloud/Azure
    - Explainer: what is scaling?
    - Explainer: what is an availability set?
    - Explainer: what is a service level agreement?
    - Explainer: load balancing in Azure - 
x. Understand security in Azure
    - Explainer: what is an NSG?
    - Explainer: extending the on-premises security boundary to Azure
x. Architecture: deploy an n-tier workload to Azure
    - Explainer: what is a public IP address, what is a VPN gateway,  what is the difference between them
    - Explainer: what is devops; automating build and deployment; when is it appropriate to use infrastructure as code 
    - networking: what is a hybrid network and what does it mean to extend the security boundary from on-premises to Azure
    - networking: routing in an Azure VNet
    - security: firewalling with network security groups
    - security: jumpbox
