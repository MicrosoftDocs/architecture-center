---
title: Security of infrastructure deployment in Azure
description: Security strategy for deploying Azure resources.
author: PageWriter-MSFT
ms.date: 03/26/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-devops
categories:
  - security
subject:
  - security
---

# Infrastructure provisioning considerations in Azure

Azure resources can be provisioned in through code or user tools such as the Azure portal or via Azure CLI. It's not recommended that resources are provisioned or configured manually. Those methods are error prone and can lead to security gaps. Even the smallest of changes should be through code. The recommended approach is Infrastructure as code (IaC). It's easy to track because the provisioned infrastructure can be fully reproduced and reversed.

## Key points

> [!div class="checklist"]
> - No infrastructure changes should be done manually outside of IaC.
> - Store keys and secrets outside of deployment pipeline in Azure Key Vault or in secure store for the pipeline.
> - Incorporate security fixes and patching to the operating system and all parts of the codebase, including dependencies (preinstalled tools, frameworks, and libraries).

## Infrastructure as code (IaC)

Make all operational changes and modifications through IaC. This is a key DevOps practice, and it's often used with continuous delivery. IaC manages the infrastructure - such as networks, virtual machines, and others - with a descriptive model, using a versioning system that is similar to what is used for source code. IaC model generates the same environment every time it's applied. Common examples of IaC are Azure Resource Manager or Terraform.

IaC reduces configuration effort and automates full environment deployment (production and pre-production). Also, IaC allows you to develop and release changes faster. All those factors enhance the security of the workload.

For detailed information about IaC, see [What is Infrastructure as code (IaC)](/devops/deliver/what-is-infrastructure-as-code).

## Pipeline secret management
**How are credentials, certificates, and other secrets used in the operations for the workload managed during deployment?**
***

Store keys and secrets outside of deployment pipeline in a managed key store, such as Azure Key Vault. Or, in a secure store for the pipeline. When deploying application infrastructure with Azure Resource Manager or Terraform, the process might generate credentials and keys. Store them in a managed key store and make sure the deployed resources reference the store. Do not hard-code credentials.

## Build environments

**Does the organization apply security controls (IP firewall restrictions, update management) to self-hosted build agents for this workload?**

Custom build agents add management complexity and can become an attack vector. Build machine credentials must be stored securely and the file system needs to be cleaned of any temporary build artifacts regularly. Network isolation can be achieved by only allowing outgoing traffic from the build agent, because it's using the pull model of communication with Azure DevOps.

As part of the operational lifecycle, incorporate security fixes and patching to the operating system and all parts of the codebase, including dependencies (preinstalled tools, frameworks, and libraries).

Apply security controls to self-hosted build agents in the same manner as with other Azure IaaS VMs. These should be minimalistic environments as a way to reduce the attack surface.

## Learn more

- [Azure Pipelines agents](/azure/devops/pipelines/agents/agents?view=azure-devops&tabs=browser&preserve-view=true)
- [I'm running a firewall and my code is in Azure Repos. What URLs does the agent need to communicate with?](/azure/devops/pipelines/agents/v2-windows?view=azure-devops#im-running-a-firewall-and-my-code-is-in-azure-repos-what-urls-does-the-agent-need-to-communicate-with&preserve-view=true)

## Next step

> [!div class="nextstepaction"]
> [Secure code deployments](./deploy-code.md)

## Related links

> Go back to the main article: [Secure deployment and testing in Azure](deploy.md)
