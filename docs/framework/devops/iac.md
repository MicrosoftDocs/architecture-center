---
title: Infrastructure Deployment
description: Describes how to automate cloud deployments.
author: jose-moreno
ms.date: 10/21/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit
---

# Infrastructure Deployment

Whether your application is running on Azure Virtual Machines, on Azure Web App Services, or on Kubernetes, you need to deploy those services before actually being able to put your application on them. Creating VMs is a task performed daily in most organizations, however you should leverage automation so that the infrastructure deployment is consistent across different environments.

Consistency of infrastructure deployments will give you multiple benefits:

* The platform where developers test their applications will be identical to the platform where the applications will run in production, thus preventing the "but it runs on my machine" type of situation, where production systems differ from testing systems.
* If any of the stages (development, testing, staging, production) have an issue, it might be quicker to just redeploy the whole platform, instead of trying to fix the existing one.
* Automated deployments is a possible strategy to enable Business Continuity and Disaster Recovery, since you can deploy both the infrastructure and the application code quickly and reliably in any Azure region.
* By automating the creation of the application platform, you eliminate human errors from the equation. Every environment is created exactly the same without the risk of human administrators forgetting to set a property or tick a checkbox.

## Automation of Azure Deployments

No matter whether your application is running on Azure-managed services (such as Azure App Service), on Linux/Windows containers (for example on Azure Kubernetes Service) or on Linux/Windows Virtual Machines, there are different frameworks that you can use in order to automatically deploy those services to Azure.

### Declarative Frameworks for Azure Automation

A declarative automation framework is characterized for handling some of the details about the resource creation on behalf of the user. The user needs to define **what** should be created, and the declarative framework will figure out **how**.

* [Resource Manager templates][arm]: Resource Manager templates are declarative text files containing a description of Azure resources to be deployed. Resource Manager templates are specific to Azure, and its most important advantage is the extensive coverage of Azure resource types and properties.
* [Terraform][terraform]: Terraform is a cloud-agnostic declarative framework that supports many private and public clouds, being Azure one of them. It has the main advantage of offering a cloud-agnostic framework: while Terraform configurations are specific to each cloud, the framework itself is the same for all of them.
* [Ansible][ansible]: Ansible is an open-source software provisioning, configuration management, and application-deployment tool. It runs on many Unix-like systems, and can configure both Unix-like systems as well as Windows. Ansible is agentless, temporarily connecting remotely via SSH or remote PowerShell to do its tasks. Ansible’s language, despite being based on the declarative YAML language, is imperative. Ansible playbooks are a sequence of plays to be carried out on different groups of hosts. Plays are in turn sequences of tasks that invoke modules to commit changes to individual hosts. Ansible has evolved to describe infrastructure in multiple clouds, such as Azure.
* Other: other declarative frameworks such as Chef or Puppet support deploying infrastructure to Azure as well.

Which of these frameworks is better for you will depend on factors such as whether your organization already has any experience in one of them and if you plan on running workloads in multiple clouds now or in the future. For Azure, the best option would be Resource Manager templates: it has the best coverage for Azure resources and features and Resource Manager templates can be used to manage certain Azure services such as Azure Blueprints or Azure Policy. If you are planning on running workloads in multiple clouds, it is best to standardize on tools and frameworks that let you manage those deployments in a consistent manner.

### Imperative Frameworks for Azure Automation

You can use imperative frameworks to deploy infrastructure to Azure. Imperative frameworks do not describe what to deploy, but indicate a prescriptive order of operations to execute. Examples of imperative frameworks for Azure automation are the following:

* [Azure CLI][cli]: the Azure Command Line Interface is a multi-platform command line supported in Windows, Linux, and Mac OS X. It offers a series of commands that can be used to create, modify, and delete Azure resources.
* [Azure Powershell][psh]: the Azure Powershell module for Azure includes a series of commandlets to interact with Azure. The object-oriented character of Powershell gives this tool a high degree of versatility. Thanks to the advent of Powershell Core, the Azure Powershell module can be used not only on Windows systems, but on Linux and Mac OS X too.
* [Azure SDKs][sdks]: if you are writing an application that needs to interact with Azure, coding in the same programming language as the application itself would be more desirable than scripting frameworks such as the Azure CLI or Azure Powershell. Whether it is Python, Java, C# or Go, you can find Software Development Kits to manage Azure from many different languages.

## Configuration of Virtual Machines

Azure offers many managed compute offerings, such as the Azure App Services. However, some administrators prefer having the control and flexibility that Virtual Machines offer, at the expense of having to manage the Operating System as well as application dependencies. Automating these tasks is of paramount importance in order to minimize the chance for configuration errors, and to prevent discrepancies across different environments.

### Executing commands in Virtual Machines

The most intuitive way of configuring the Operating System of an Azure Virtual Machine, as well as installing additional packages, is through Azure Virtual Machine Extensions:

* [Azure Virtual Machine Extensions][extensions] offer the possibility of installing certain additional software in an Azure Virtual Machine, such as Docker, Configuration Management Tools, or Security Agents. In particular, the **Custom Script Extension** allows the download and execution of arbitrary code on a Virtual Machine, allowing unlimited customization of the Operating System of an Azure VM.
* [Cloudinit][cloudinit] is similar to the Azure Custom Script Extension, but with two major differences: it is simpler to use, and it is only available for Linux Virtual Machines.

Both Azure VM Extensions and cloud init are installed and executed only at VM creation time. That means if the Operating System gets configured incorrectly at a later stage, it will require a manual intervention to move it back to its correct state. Configuration Management Tools can be used to address this issue.

### Configuration Management for Virtual Machines

Configuration Management Tools such as Ansible, Puppet, Chef, or Desired State Configuration (DSC) have been created in order to verify that Operating Systems are configured according to a certain desired state. Additionally, if the configuration of the Operating System deviates from that desired state, it will be corrected and remediated.

These tools are not Azure-specific, but have been used for years in both Linux and Windows Operating Systems. Azure Virtual Machines are no different, and you should use Configuration Management Tools to make sure that your VMs contain the right dependencies for your applications and are configured correctly.

* [Ansible Dynamic Inventory][Ansible] supports the concept of dynamic inventory in which we have some python scripts and a .ini file through which we can provision machines dynamically without knowing its public or private address. Ansible Dynamic Inventory is fed by using external python scripts and .ini files provided by Ansible for cloud infrastructure platforms like Azure. It will dynamically use tags to enable the ability to quickly and easily work with subgroups of your virtual machines.

### Azure-Managed Images

In some situations, instead of deploying an Azure Virtual Machine out of the Azure Marketplace and install the required application dependencies on the Operating System, you might want to build your own OS image with everything that your applications require already in it. This way, Virtual Machines will be created quicker, since nothing needs to be installed. Additionally this way of deploying Virtual Machines is predictable, since the image contains every single software package in advance.

Azure offers the concept of Managed Images to achieve this. Azure-Managed Images can be created in different ways: from another Azure Virtual Machine, from a virtual disk from an on-premises Virtual Machine or using a utility called Packer, from Hashicorp. The latest approach is recommended for Infrastructure-as-Code because Virtual Machines will be created with the information contained in text files, that Packer will compile into an Azure-Managed Image. Those text files can be version-controlled in the same repositories as your applications, hence the recommendation for this approach.

Packer can be used to create Azure-Managed Images for both [Linux][packer-linux] and [Windows][packer-windows] Virtual Machines.

## IaC, CI/CD Tooling, and Azure DevOps

As seen in previous sections, it is recommended storing your templates and scripts to deploy Azure resources along your application code, so that if applications upgrades require infrastructure changes, those can be stored next to the new application code. There are many version control systems for source code, but [git][git] has become a de facto standard in the last few years. If you are already using a version control system, you can continue using it with Azure. If you are looking for a new one, you might consider [GitHub][github] or [Azure Repos][repos], a component of the [Azure DevOps Services][azuredevops]. Both GitHub and Azure Repos offer a rich set of functionality, automation and security features.

Once you have your infrastructure deployment code, such as Resource Manager templates or Packer configurations stored in a version control systems, you can automate its deployment with Continuous Deployment tools. If you have automation tools that you use today to deploy application code, such as Jenkins, you can continue using them. If you are looking for a CI/CD tool with a high integration in the Azure ecosystem you might want to look at [Azure Pipelines][pipelines], the component of [Azure DevOps Services][azuredevops] that brings automation for application builds and deployments.

### Best Practices for running Terraform in automation

When running Terraform in automation the main path is broadly the same as for CLI usage:

1. Initialize the Terraform working directory.
2. Produce a plan for changing resources to match the current configuration.
3. Have a human operator review that plan, to ensure it is acceptable.
4. Apply the changes described by the plan.

* After plan completes, archive the entire working directory, including the .terraform subdirectory created during init, and save it somewhere where it will be available to the apply step. A common choice is as a "build artifact" within the chosen orchestration tool.
* Before running apply, obtain the archive created in the previous step and extract it at the same absolute path. This re-creates everything that was present after plan, avoiding strange issues where local files were created during the plan step.
* Implement an interactive approval step between plan and apply. Different orchestration tools address this in different ways, but generally this is implemented via a build pipeline feature, where different steps can be applied in sequence, with later steps having access to data produced by earlier steps.

## Summary

No matter whether you are deploying your applications to Platform-as-a-Service or to Infrastructure-as-a-Service, there are many compelling reasons why your Azure infrastructure should be deployed automatically. While declarative approaches such as Resource Manager templates or Terraform are preferred, imperative approaches such as the Azure CLI or Azure Powershell offer great flexibility and ease of use for certain situations.

If you are deploying your application to Azure Virtual Machines, it is recommended using Configuration Management Tools to keep your Operating System configurations as you want them, or Packer to deploy from your own Azure-Managed Images. If you are using Azure-managed services such as Azure App Service, the OS-layer is taken care for you.

And lastly, do not forget to version-control your infrastructure code, and use consistent CI/CD tooling for Continuous Integration and Continuous Deployment of your application code and the platform it will run on.

<!-- iac -->
[arm]: /azure/azure-resource-manager
[terraform]: /azure/terraform
[ansible]: /azure/ansible/ansible-overview
[cli]: /cli/azure
[psh]: /powershell/azure
[sdks]: /azure/#pivot=sdkstools
[extensions]: /azure/virtual-machines/extensions/overview
[cloudinit]: /azure/virtual-machines/linux/using-cloud-init
[packer-linux]: /azure/virtual-machines/linux/build-image-with-packer
[packer-windows]: /azure/virtual-machines/windows/build-image-with-packer
[azuredevops]: /azure/devops
[pipelines]: /azure/devops/pipelines
[repos]: /azure/devops/repos/?view=azure-devops
[git]: https://git-scm.com/
[github]: https://github.com
