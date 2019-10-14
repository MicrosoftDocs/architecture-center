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

* [ARM Templates][arm]: ARM templates are declarative text files containing a description of Azure resources to be deployed. ARM templates are specific to Azure, and its most important advantage is the extensive coverage of Azure resource types and properties.
* [Terraform][terraform]: Terraform is a cloud-agnostic declarative framework that supports many private and public clouds, being Azure one of them. It has the main advantage of offering a cloud-agnostic framework: while Terraform configurations are specific to each cloud, the framework itself is the same for all of them.
* [Ansible][ansible]: Ansible is different from ARM templates and Terraform because it was created not to describe infrastructure, but to describe software configuration of Linux-based computer systems. Ansible has evolved to describe infrastructure in multiple clouds, such as Azure.
* Other: other declarative frameworks such as Chef or Puppet support as well deploying infrastructure to Azure.

Which of these frameworks is better for you will depend on factors such as whether your organization already has any experience in one of them. If you are open to choosing any one, the best option would probably be ARM Templates: first of all it has the best coverage for Azure resources and features. Besides, ARM templates can be used inside certain Azure services such as Azure Blueprints or Azure Policy.

### Imperative Frameworks for Azure Automation

On the other hand, you can use imperative frameworks to deploy infrastructure to Azure. Imperative frameworks do not simply describe what to deploy, but indicate a prescriptive order of operations to execute. Examples of imperative frameworks for Azure automation are the following:

* [Azure CLI][cli]: the Azure Command Line Interface is a multi-platform command line supported in Windows, Linux and Mac OS X. It offers a series of commands that can be used to create, modify and delete Azure resources.
* [Azure Powershell][psh]: the Azure Powershell module for Azure includes a series of commandlets to interact with Azure. The object-oriented character of Powershell gives this tool a high degree of versatility. Thanks to the advent of Powershell Core, the Azure Powershell module can be used not only on Windows systems, but on Linux and Mac OS X too.
* [Azure SDKs][sdks]: if you are writing an application that needs to interact with Azure, coding in the same programming language as the application itself would be more desirable than scripting frameworks such as the Azure CLI or Azure Powershell. Whether it is Python, Java, C# or Go, you can find Software Development Kits to manage Azure from many different languages.

## Configuration of Virtual Machines

Azure offers many managed compute offerings, such as the Azure App Services. However, some administrators prefer having the control and flexibility that Virtual Machines offer, at the expense of having to manage the Operating System as well as application dependencies. Automating these tasks is of paramount importance in order to minimize the chance for configuration errors, and to prevent discrepancies across different environments.

### Executing commands in Virtual Machines

The most intuitive way of configuring the Operating System of an Azure Virtual Machine, as well as installing additional packages, is through Azure Virtual Machine Extensions:

* [Azure Virtual Machine Extensions][extensions] offer the possibility of installing certain additional software in an Azure Virtual Machine, such as Docker, Configuration Management Tools or Security Agents. In particular the **Custom Script Extension** allows to download and execute arbitrary code to a Virtual Machine, effectively offering unlimited flexibility of customizing the Operating System of an Azure VM.
* [Cloudinit][cloudinit] is similar to the Azure Custom Script Extension, but with two major differences: it is simpler to use, and it is only available for Linux Virtual Machines.

Both Azure VM Extensions and cloud init are installed and executed only at VM creation time. That means if the Operating System gets configured incorrectly at a later stage, it will require a manual intervention to move it back to its correct state. Configuration Management Tools can be used to address this issue.

### Configuration Management for Virtual Machines

Configuration Management Tools such as Ansible, Puppet, Chef or Desired State Configuration (DSC) have been created in order to verify that Operating Systems are configured according to a certain desired state. Additionally, if the configuration of the Operating System deviates from that desired state, it will be corrected and remediated.

These tools are not Azure-specific, but have been used for years in both Linux and Windows Operating Systems. Azure Virtual Machines are no different, and you should use Configuration Management Tools to make sure that your VMs contain the right dependencies for your applications, and are configured correctly.

### Azure Managed Images

In some situations, instead of deploying an Azure Virtual Machine out of the Azure Marketplace and install the required application dependencies on the Operating System, you might want to build your own OS image with everything that your applications require already in it. This way, Virtual Machines will be created quicker, since nothing needs to be installed. Additionally this way of deploying Virtual Machines is very predictable, since the image contains every single software package in advance.

Azure offers the concept of Managed Images to achieve this. Azure Managed Images can be created in different ways: from another Azure Virtual Machine, from a virtual disk from an on-premises Virtual Machine or using an utility called Packer, from Hashicorp. The latest approach is recommended for Infrastructure-as-Code because Virtual Machines will be created with the information contained in text files, that Packer will compile into an Azure Managed Image. Those text files can be version-controlled in the same repositories as your applications, hence the recommendation for this approach.

Packer can be used to create Azure Managed Images for both [Linux][packer-linux] and [Windows][packer-windows] Virtual Machines.

## IaC, CI/CD Tooling and Azure DevOps

As seen in previous sections, it is recommended storing your templates and scripts to deploy Azure resources along your application code, so that if applications upgrades require infrastructure changes, those can be stored next to the new application code. There are many version control systems for source code, but [git][git] has become a de facto standard in the last few years. If you are already using a version control system you can continue using it with Azure. If you are looking for a new one, you might consider [Github][github] or [Azure Repos][repos], a component of the [Azure DevOps Services][azuredevops]. Both Github and Azure Repos offer a rich set of functionality, automation and security features.

Once you have your infrastructure deployment code such as ARM templates or Packer configurations stored in a version control systems, you can automate its deployment with Continuous Deployment tools. Once again, if you have automation tools that you use today to deploy application code, such as Jenkins, you can continue using them. If you are looking for a CI/CD tool with a high integration in the Azure ecosystem you might want to look at [Azure Pipelines][pipelines], the component of [Azure DevOps Services][azuredevops] that brings automation for application builds and deployments.

## Summary

No matter whether you are deploying your applications to Platform-as-a-Service or to Infrastructure-as-a-Service, there are many compelling reasons why your Azure infrastructure should be deployed automatically. While declarative approaches such as ARM Templates or Terraform are preferred, imperative approaches such as the Azure CLI or Azure Powershell offer great flexibility and ease of use for certain situations.

If you are deploying your application to Azure Virtual Machines, it is recommended using Configuration Management Tools to keep your Operating System configurations as you want them, or Packer to deploy from your own Azure Managed Images. If you are using Azure managed services such as Azure App Service, the OS-layer is taken care for you.

And lastly, do not forget to version-control your infrastructure code, and use consistent CI/CD tooling for Continuous Integration and Continuous Deployment of your application code and the platform it will run on.

<!-- iac -->
[arm]: https://docs.microsoft.com/azure/azure-resource-manager
[terraform]: https://docs.microsoft.com/azure/terraform
[ansible]: https://docs.microsoft.com/azure/ansible/ansible-overview
[cli]: https://docs.microsoft.com/cli/azure
[psh]: https://docs.microsoft.com/powershell/azure
[sdks]: https://docs.microsoft.com/azure/#pivot=sdkstools
[extensions]: https://docs.microsoft.com/azure/virtual-machines/extensions/overview
[cloudinit]: https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init
[packer_linux]: https://docs.microsoft.com/azure/virtual-machines/linux/build-image-with-packer
[packer-windows]: https://docs.microsoft.com/azure/virtual-machines/windows/build-image-with-packer
[azuredevops]: https://azure.microsoft.com/services/devops
[pipelines]: https://docs.microsoft.com/en-us/azure/devops/pipelines
[repos]: https://docs.microsoft.com/azure/devops/repos/?view=azure-devops
[git]: https://git-scm.com/
[github]: https://github.com