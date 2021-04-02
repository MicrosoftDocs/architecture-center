---
title: Secure deployment in Azure
description: DevOps considerations to ensure security and feature enhancements can be quickly deployed.
author: PageWriter-MSFT
ms.date: 03/26/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-devops
categories:
  - security
---
 
# Secure deployment in Azure

Have teams, processes, and tools that can quickly deploy security fixes. A _DevOps_ or multidisciplinary approach is recommended. Multiple teams work together with efficient practices and tools. Essential DevOps practices include change management of the workload through continuous integration, continuous delivery (CI/CD). 

Continuous integration (CI) is an automated process where code changes trigger the building and testing of the application. Continuous Delivery (CD) is an automated process to build, test, configure, and deploy the application from a build to production environment. 

Those processes allow you to rapidly address the security concerns without waiting for a longer planning and testing cycle. 

## Checklist

**Have you adopted a secure DevOps approach to ensure security and feature enhancements can be quickly deployed?**
***
> [!div class="checklist"]
> - Clearly define CI/CD roles and permissions and minimize the number of people who have access to secure information or resources.
> - Configure quality gate approvals in DevOps release process.
> - Integrate code scanning tools within CI/CD pipeline.
> - No infrastructure changes, provisioning or configuring, should be done manually outside of IaC.

## In this section
Follow these questions to assess the workload at a deeper level. 

|Assessment|Description|
|---|---|
|[**Do you clearly define CI/CD roles and permissions for this workload?**](deploy-governance.md)|Define CI/CD permissions such that only users responsible for production releases can start the process and that only developers can access the source code.|
|[**Can you roll back or forward code quickly through automated pipelines?**](deploy-code.md)|Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle.|
|[**Are any resources provisioned or operationally configured with user tools such as the Azure portal or via Azure CLI??**](monitor-test.md)|Always use Infrastructure as code (IaC) to make smallest of changes. This approach makes it easy to track code because the provisioned infrastructure is reproducible and reversible.|


## Azure security benchmark
The Azure Security Benchmark includes a collection of high-impact security recommendations. Use them to secure the services and processes you use to run the workload in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to the [Azure Security Benchmark controls](/azure/security/benchmarks/overview?branch=master).


## Next steps
We recommend monitoring activities that maintain the security posture. These activities can highlight, if the current security practices are effective or are there new requirements.

> [!div class="nextstepaction"]
> [Security monitoring](./monitor.md)


## Related link
> Go back to the main article: [Security](overview.md)
