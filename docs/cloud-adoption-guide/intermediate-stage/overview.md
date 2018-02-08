---
title: "Adopting Azure: Intermediate" 
description: Describes the intermediate level of knowledge that an enterprise requires to adopt Azure
author: petertay
---

# Adopting Azure: Intermediate

In the foundational adoption stage, you learned the basics about digital identity, subscription, and resource management. You used this knowledge to create your first resources in Azure. 

In the cloud, we call a set of resources that perform a particular function a **workload**. A workload can be any type of service or a part of a service. For example, all the discrete compute and software components that make up a website can be described as a workload. We'll describe the resources you deploy to Azure as a *workload* from now on.

You may have noticed that when you created your first Azure resource in the foundational adoption stage, you had to access your resources using one of Azure's public network endpoints - known in Azure as a **public IP addresss**. Does this mean that every resource in Azure is only accessible this way?

The answer is no, there is no requirement that a particular Azure resource must have a public IP address. The next logical question is how can we access a resource in Azure that has no public IP address? 

1. Understand managing multiple workloads in Azure
    - automation: cattle, not pets
    - managing cost across multiple teams
2. Understand availability and resiliency in the Cloud/Azure
    - Explainer: what is scaling?
    - Explainer: what is an availability set?
    - Explainer: what is a service level agreement?
    - Explainer: load balancing in Azure - 
3. Understand security in Azure
    - Explainer: what is an NSG?
2. Digital identity: reasons for multiple tenants, and how to manage multiple tenants
    - role-based-access-control: now that you have multiple teams, you have multiple people with the same responsibilities. How do you apply a universal policy to them to control what they do?
    - resource policy: even though you trust your users with "owner" to create a resource, you still want to restrict 
3. Subscriptions: now that you have multiple teams and multiple projects, understand how to use subscriptions to manage costs and limits by various criteria such as team, project, environment, etc.
4. Resource management: how to organize multiple workloads using resource groups
5. Resource management: introduction to Infrastructure as code
    - ARM templates
6. Operations: how to manage cost, 
7. Architecture: deploy an n-tier workload to Azure
    - Explainer: what is a public IP address, what is a Gateway subnet (seriously, what is it), what is the difference between them
    - networking: what is a hybrid network and what does it mean to extend the security boundary from on-premises to Azure
    - networking: routing in an Azure VNet
    - security: firewalling with network security groups
    - security: jumpbox
    - 
