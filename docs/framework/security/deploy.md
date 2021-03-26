---
title: Secure deployment and testing in Azure
description: Security logging and monitoring are activities related to enabling, acquiring, and storing audit logs for Azure services.
author: PageWriter-MSFT
ms.date: 11/03/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---
 
# Secure deployment and testing in Azure

Have teams, processes, and tools that can quickly deploy security fixes. A _DevOps_ or multidisciplinary approach is recommended. Multiple teams work together with efficient practices and tools. Essential DevOps practices include change management of the workload through continuous integration, continuous delivery (CI/CD). 

Continuous integration (CI) is an automated process where code changes trigger the building and testing of the application. 

Continuous Delivery (CD) is an automated process to build, test, configure, and deploy the application from a build to production environment. 

Those processes allow you to rapidly address the security concerns without waiting for a longer planning and testing cycle. 

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
|[**Are any resources provisioned or operationally configured manually through user tools such as the Azure Portal or via Azure CLI?**]()||

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



## Code deployments

The automated pipelines should be able to update a workload to a new version seamlessly without breaking dependencies. If something goes wrong, the workload should rollback to a previous working version. N-1 and N+1 refer to rollback and roll-forward versions.

**Can N-1 or N+1 versions be deployed via automated pipelines where N is current deployment version in production?**
***

Because security updates are a high priority, design a pipeline that supports regular updates and critical security fixes. 

A release is typically associated with approval processes with multiple sign-offs, quality gates, and so on. If the workload deployment is small with minimal approvals, you can usually use the same process and pipeline to release a security fix.   
    
If the approval process is complex and takes a significant amount of time that could delay a fix, consider having an emergency pipeline that might not include all the gated approvals but is able to push out the fix quickly. The pipeline should allow for quick roll-forward and rollback deployments that address security fixes, critical bugs, and code updates outside of the regular deployment life cycle.

Involve the security team in the planning and design of the DevOps process. Ideally, design an automated pipeline with a degree of flexibility that supports regular and emergency deployments. 

**Are code scanning tools an integrated part of the continuous integration (CI) process for this workload?**
***
To prevent credentials from being stored in the source code or configuration files, integrate code scanning tools within the CI/CD pipeline. 
- During design time, use code analyzers to prevent credentials from getting pushed to the source code repository. For example, .NET Compiler Platform (Roslyn) Analyzers inspect your C# or Visual Basic code. 
- During the build process, use pipeline add-ons to catch credentials in the source code. An option is [Credential Scanner (CredScan)](https://secdevtools.azurewebsites.net/helpcredscan.html) that is part of Microsoft Security Code Analysis.
- Scan all dependencies, such as third-party libraries and framework components, as part of the CI process. Investigate vulnerable components that are flagged by the tool. Combine this task with other code scanning tasks that inspect code churn, test results, and coverage.

**Are branch policies used in source control management of this workload? How are they configured?**
***

Establish branch policies that provide an additional level of control over the code that is commited to the repository. It's a common practice to deny pushes to the main branch if the change isn't approved. For example, you can  require pull-request (PR) with code review before merging the changes by at least one reviewer, other than the change author. 

Having multiple branches is recommended where each branch has a purpose and access level. For example, feature branches are created by developers and are open to push, integration branch requires PR and code-review, and production branch requires additional approval from the team lead before merging.

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