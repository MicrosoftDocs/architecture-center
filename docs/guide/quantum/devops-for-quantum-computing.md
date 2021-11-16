---
title: DevOps for Quantum Computing
description: Learn about DevOps requirements of Quantum based apps leading to a repeatable, high-quality process for building, deploying, and monitoring software.
author: hsirtl
ms.author: hsirtl
ms.date: 11/30/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-quantum
  - azure-devops
  - azure-repos
  - azure-pipelines
categories:
  - devops
  - compute
  - hybrid
ms.custom: fcp
---

# DevOps for Quantum Computing

Quantum computing harnesses the unique behavior of quantum mechanics and applies it to information processing. This approach promises massive speedup in compute time compared to classical computing especially in areas like optimization, simulation, or machine learning. However, quantum computing components have a different development and operating model compared to pure classical software. They are not "installed" and "executed" like classical applications (for example on physical hardware or virtual machines). Instead, quantum applications are developed as "jobs". A classical software component (running in a classical environment) orchestrates the [execution of quantum jobs](/azure/quantum/how-to-work-with-jobs) in a target environment at runtime.

A quantum computing application is in fact always a hybrid application consisting of classical (orchestration) and quantum (quantum algorithm) parts. Both parts have their specific requirements regarding DevOps. This article discusses DevOps requirements of hybrid quantum applications leading to a repeatable, high-quality process for building, deploying, and monitoring software.

## Introduction

DevOps can be defined as ["the union of people, process, and products to enable continuous delivery of value to our end users"](https://azure.microsoft.com/overview/what-is-devops/). This definition gives a great structure for discussing requirements of hybrid quantum applications and their specifics.

* **People** - Designing, developing, and operating quantum algorithms requires skills that are different from those for classical components. Designers and developers typically include quantum information scientists and similar roles. Operations staff must be familiar with specialized target systems (optimization solvers, quantum hardware).
* **Process** - The clear separation of classical and quantum components on one side, and need for integration of these on the other requires an alignment of the quantum and the classical DevOps activities.
* **Products** - Lifecycle of the different execution environments must be considered as well. Specialized quantum computers are scarce resources, in general operated as central resources and accessed by various classical clients.

These pillars must be brought together to form a unified approach that allows designing, developing, operating, and managing hybrid quantum software systems in a repeatable, reliable way. DevOps influences the application lifecycle throughout its plan, develop, deliver, and operate phases of quantum components.

* **Plan** - Today, [quantum computing targets](/azure/quantum/qc-target-list) still differ in their capabilities. These capabilities are described via [target profiles](/azure/quantum/quantum-computing-target-profiles). As choosing a target has influence on what code can be run, target-selection should happen early in the process.
* **Develop** - Azure Quantum provides flexibility in your development approach. You can write quantum components in [Q#](/azure/quantum/overview-what-is-qsharp-and-qdk), [Python](/azure/quantum/install-python-qdk) (using Qiskit or Cirq) using [Visual Studio](https://marketplace.visualstudio.com/items?itemName=quantum.DevKit), [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=quantum.quantum-devkit-vscode), or [Jupyter Notebooks](/azure/quantum/install-command-line-qdk).
* **Deliver** - Quantum components are delivered indirectly. Instead of installation on a quantum target system, you package them with classical software components. The classical parts [orchestrate quantum job submission and monitoring](/azure/quantum/how-to-work-with-jobs) on quantum systems.
* **Operate** - The operations model of quantum components is aligned with the [quantum job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle). Monitoring happens through the classical components that submit the quantum jobs to quantum targets.

## The inner and outer DevOps loops

In DevOps, we typically distinguish between the inner and outer loop.

:::image type="content" source="media/inner-and-outer-loop-in-quantum-devops.png" alt-text="The inner and outer loops in DevOps for quantum applications":::

The outer loop involves activities typically associated with a full DevOps-cycle:

* Managing work items in a product backlog.
* Developing and testing software artifacts (via inner loops).
* Centrally building and deployment of these artifacts, which includes provisioning of the target environment.
* Monitoring the running application.
* Results might lead to new work items in the backlog. These steps will be discussed in more detail in later sections.

The inner loop is the iterative process a (quantum or classical) developer performs when writing, building, testing code. The inner loop mostly takes place on IT systems that an individual developer owns or holds responsibility for (for example the developer machine).

For quantum components, the inner loop involves following [activities enabled by the Quantum Development Kit](/azure/quantum/overview-azure-quantum#workflow-of-the-quantum-software-development):

1. Write quantum code
1. Use libraries to keep code high level
1. Integrate with classical software
1. Run quantum code in simulation
1. Estimate resources
1. Run (test) code on quantum hardware

The last step is a specialty of quantum computing. Because quantum hardware is a scarce resource, developers typically don't own their own hardware or have exclusive access. Instead, they use centrally operated hardware - in most cases they access production hardware to test their development artifacts.  

The inner loop for classical components includes typical development steps for building, running and debugging code in a development environment. In context of hybrid quantum applications there is an additional step of integrating the quantum components into the classical components. Complexity of this step depends on whether the quantum components are [tightly coupled](../../example-scenario/quantum/tightly-coupled-quantum-computing-job-content.yml) or [loosely coupled](../../example-scenario/quantum/loosely-coupled-quantum-computing-job-content.yml) with the classical ones.

## Infrastructure as Code (IaC)

Like any other Azure environment, quantum workspaces and the classical environments can be automatically provisioned via [Azure Resource Manager templates](/azure/azure-resource-manager/templates/). These JavaScript Object Notation (JSON) files contain definitions for the two target environments:

* The **quantum environment** contains an Azure Quantum workspace with its associated Azure Storage account. This environment should be kept in its separate [resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal). Typically, the lifecycle of these resources is different from the classical resources, which often are recreated with each deployment cycle.
* The **classical environment** contains all other Azure resources that are needed for executing the classical software components. Types of resources are highly dependent on the selected compute model and the integration model.

:::image type="content" source="media/iac-in-quantum-devops.png" alt-text="Infrastructure as code in DevOps for quantum applications":::

If the [loosely coupled integration model](../../example-scenario/quantum/loosely-coupled-quantum-computing-job-content.md) is chosen, the classical environment comprises all resources needed for exposing the quantum functionality via API.

## Continuous Integration (CI) and Automated Testing

## Continuous Delivery (CD)

## Release Management

## Application Monitoring

## Next steps

* Bulleted list of third-party and other Docs and Microsoft links.
* Links shouldn't include en-us locale unless they don't work without it.
* Docs links should be site-relative, for example (/azure/feature/article-name).
* Don't include trailing slash in any links.

## Related resources

* [DevOps Checklist](/azure/architecture/checklist/dev-ops)
* [CI/CD for Quantum Computing jobs](../../solution-ideas/articles/cicd-for-quantum-computing-jobs-content.md).
* [Tightly coupled quantum computing job](../../example-scenario/quantum/tightly-coupled-quantum-computing-job-content.md).
* [Loosely coupled quantum computing job](../../example-scenario/quantum/loosely-coupled-quantum-computing-job-content.md).
