---
title: Infrastructure Deployment
description: Describes how to best take advantage of the benefits of the cloud to minimize your cost.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit
ms.custom: 
---

# Infrastructure Deployment

Whether your application is running on Azure Virtual Machines, on Azure Web App Services or on Kubernetes, you need to deploy those services before actually being able to put your application on them. Creating VMs is a task performed daily in most organizations, however you should leverage automation so that the infrastructure deployment is consistent across different environments.

Consistency of infrastructure deployments will give you multiple benefits:

* The platform where developers test their applications will be identical to the platform where the applications will run in production, thus preventing the "but it runs on my machine" type of situation, where production systems differ from testing systems.
* If any of the stages (development, testing, staging, production) has an issue, it might be quicker to just redeploy the whole platform, instead of trying to fix the existing one.
* Automated deployments is one of the possible strategies for Business Continuity and Disaster Recovery, since you would be able to deploy both the infrastructure and the application code quickly and reliably in any Azure region
* By automating the creation of the application platform  you eliminate human errors from the equation: every environment is created exactly the same, without the risk of human administrators forgetting to set a property or tick a checkbox

## Automation of Azure Deployments

No matter whether your application is running on Azure managed services (such as Azure App Service), on Linux/Windows containers (for example on Azure Kubernetes Service) or on Linux/Windows Virtual Machines, there are different frameworks that you can use in order to automatically deploy those services to Azure.

### Declarative Frameworks for Azure Automation

A declarative automation framework is characterized for handling some of the details about the resource creation on behalf of the user. The user needs to define **what** should be created, and the declarative framework will figure out **how**.

* [ARM Templates][arm]: this is Azure specific, and its most important advantage is the extensive coverage of Azure resource types and properties.
* [Terraform][terraform]:
* [Ansible][ansible]: 
* Other: other declarative frameworks such as Chef or Puppet support as well deploying infrastructure to Azure.

Which of these frameworks is better for you will depend on factors such as whether your organization already has any experience in one of them. If you are open to choosing any one, the best option would probably be ARM Templates: first of all it has the best coverage for Azure resources and features

### Imperative Frameworks for Azure Automation



## Configuration Management for Virtual Machines


<!-- iac -->
[arm]: blahblah.html
[terraform]: blahblah.html
[ansible]: blahblah.html