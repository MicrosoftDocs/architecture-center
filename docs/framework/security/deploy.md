---
title: Secure deployment and testing in Azure
description: DevOps considerations to ensure security and feature enhancements can be quickly deployed.
author: PageWriter-MSFT
ms.date: 03/26/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
product:
  - azure-devops
categories:
  - security
---
 
# Secure deployment and testing in Azure

Have teams, processes, and tools that can quickly deploy security fixes. A _DevOps_ or multidisciplinary approach is recommended. Multiple teams work together with efficient practices and tools. Essential DevOps practices include change management of the workload through continuous integration, continuous delivery (CI/CD). 

Continuous integration (CI) is an automated process where code changes trigger the building and testing of the application. Continuous Delivery (CD) is an automated process to build, test, configure, and deploy the application from a build to production environment. 

Those processes allow you to Frapidly address the security concerns without waiting for a longer planning and testing cycle. 

## Checklist
**Have you adopted a secure DevOps approach to ensure security and feature enhancements can be quickly deployed?**
***
> [!div class="checklist"]
> - Clearly define CI/CD roles and permissions and minimize the number of people who have access to secure information or resources.
> - Configure quality gate approvals in DevOps release process.
> - Integrate code scanning tools within CI/CD pipeline.
> - Include code scans into CI/CD process that also covers 3rd party dependencies and framework components.
> - No infrastructure changes, provisioning or configuring, should be done manually outside of IaC.
> - Implement branch policy strategy that makes sure that the code changes are reviewed.
> - Respond to incidents.
> - Simlulate attacks based on real incidents. 

## In this section
Follow these questions to assess the workload at a deeper level. The recommendations in this section are based on using Azure AD.

|Assessment|Description|
|---|---|
|[**Do you clearly define CI/CD roles and permissions for this workload?**](deploy-governance.md)|Define CI/CD permissions so that only users responsible for production releases are able to initiate the process and that only developers can access the source code.|
|[**How is the security of the workload validated?**](monitor-test.md)|Test the defense of the workload by simulating real-world attacks. Use penetration testing to simulate one-time attack and red teams to simulate long-term persistent attack groups.|


## Azure security benchmark
The Azure Security Benchmark includes a collection of high-impact security recommendations. Use them to secure the services and processes you use to run the workload in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to:
> - The [Azure Security Benchmarks Logging and threat detection](/azure/security/benchmarks/security-controls-v2-logging-threat-detection).
> - The [Azure Security Benchmarks Incident response](/azure/security/benchmarks/security-controls-v2-incident-response).
> 

## Next steps
We recommend applying as many best practices as early as possible, and then working to retrofit any gaps over time as you mature your security program. 

> [!div class="nextstepaction"]
> [ Optimize security investments](./governance.md?branch=master#prioritize-security-best-practices-investments)

Assign stakeholders to use [Secure Score](/azure/security-center/secure-score-security-controls) in Azure Security Center to monitor risk profile and continuously improve security posture. 

> [!div class="nextstepaction"]
> [Operationalize Azure Secure Score](./governance.md?branch=master#operationalize-azure-secure-score)

## Related link
> Go back to the main article: [Security](overview.md)





## Infrastructure provisioning and configuration

It's not recommended that resources get provisioned or operationally configured manually through user tools such as the Azure Portal or Azure CLI. Those methods are error prone and can lead to security gaps.

Make all operational changes and modifications through Infrastructure as code (IaC). IaC is a key DevOps practice, and it's often used in conjunction with continuous delivery. IaC manages the infrastructure - such as networks, virtual machines, and others - with a descriptive model, using a versioning system that is similar to what is used for source code. IaC model generates the same environment every time it is applied. Common examples of IaC are Azure Resource Manager or Terraform.

IaC reduces configuration effort and automates full environment deployment. Also, IaC allows you to develop and release changes faster. All those factors enhance the security of the workload.

**How are credentials, certificates, and other secrets used in the operations for the workload managed during deployment?**
***

Store keys and secrets outside of deployment pipeline in a managed key store, such as Azure Key Vault, or in a secure store for the pipeline. When deploying application infrastructure with Azure Resource Manager or Terraform, the process might generate credential and keys. Store them in a managed key store and make sure the deployed resources reference the store. Do not hard code credentials.


## Build environments

Does the organization apply security controls (e.g. IP firewall restrictions, update management, etc.) to self-hosted build agents for this workload?

When the organization uses their own build agents it adds management complexity and can become an attack vector. Build machine credentials must be stored securely and file system needs to be cleaned of any temporary build artifacts regularly. Network isolation can be achieved by only allowing outgoing traffic from the build agent, because it's using pull model of communication with Azure DevOps.

Apply security controls to self-hosted build agents in the same manner as with other Azure IaaS VMs.