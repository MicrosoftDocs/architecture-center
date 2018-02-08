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

Now, at the intermediate stage of organizational maturity, it's time to understand how to manage mu
The intermediate stage of organizational maturity for an enterprise encompasses deploying multiple projects and comple

The list below includes the tasks for completing the foundational adoption stage. The list is progressive so complete each task in order. If you have previously completed the task, move on the next task in the list. 

1. Understand managing multiple workloads in Azure
    - automation: cattle, not pets
    - managing cost across multiple teams
2. Digital identity: reasons for multiple tenants, and how to manage multiple tenants
3. Subscriptions: understand how to use subscriptions to manage costs and limits by various criteria such as project, environment, etc.
4. Resource management: how to organize multiple workloads using resource groups
5. Resource management: introduction to Infrastructure as code:
    - cattle, not pets: automate everything
