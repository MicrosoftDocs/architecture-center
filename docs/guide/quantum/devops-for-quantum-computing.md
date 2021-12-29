---
title: DevOps for quantum computing
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

* **People** - Designing, developing, and operating quantum algorithms requires skills that are different from those skills required for classical components. Designers and developers typically include quantum information scientists and similar roles. Operations staff must be familiar with specialized target systems (optimization solvers, quantum hardware).
* **Process** - The clear separation of classical and quantum components on one side, and need for integration of these components on the other requires an alignment of the quantum and the classical DevOps activities.
* **Products** - Lifecycle of the different execution environments must be considered as well. Specialized quantum computers are scarce resources, in general operated as central resources, and accessed by various classical clients.

These pillars must be brought together to form a unified approach that allows designing, developing, operating, and managing hybrid quantum software systems in a repeatable, reliable way. DevOps influences the application lifecycle throughout its plan, develop, deliver, and operate phases of quantum components.

* **Plan** - Today, [quantum computing targets](/azure/quantum/qc-target-list) still differ in their capabilities. These capabilities are described via [target profiles](/azure/quantum/quantum-computing-target-profiles). As choosing a target has influence on what code can be run, target-selection should happen early in the process.
* **Develop** - Azure Quantum provides flexibility in your development approach. You can write quantum components in [Q#](/azure/quantum/overview-what-is-qsharp-and-qdk), [Python](/azure/quantum/install-python-qdk) (using Qiskit or Cirq) using [Visual Studio](https://marketplace.visualstudio.com/items?itemName=quantum.DevKit), [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=quantum.quantum-devkit-vscode), or [Jupyter Notebooks](/azure/quantum/install-command-line-qdk).
* **Deliver** - Quantum components are delivered indirectly. Instead of installation on a quantum target system, you package them with classical software components. The classical parts [orchestrate quantum job submission and monitoring](/azure/quantum/how-to-work-with-jobs) on quantum systems.
* **Operate** - The operations model of quantum components is aligned with the [quantum job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle). Monitoring happens through the classical components that submit the quantum jobs to quantum targets.

## The inner and outer DevOps loops

In DevOps, we typically distinguish between the inner and outer loop.

:::image type="content" source="media/inner-and-outer-loop-in-quantum-devops.png" alt-text="The inner and outer loops in DevOps for quantum applications":::

### The outer loop

The **outer loop** involves activities typically associated with a full DevOps-cycle:

* Managing work items in a product backlog.
* Developing and testing software artifacts (via inner loops).
* Centrally building and deployment of these artifacts, which includes provisioning of the target environment.
* Monitoring the running application. Results might lead to new work items in the backlog.

These steps will be discussed in more detail in later sections.

### The inner loop

The **inner loop** is the iterative process a (quantum or classical) developer performs when writing, building, testing code. The inner loop mostly takes place on IT systems that an individual developer owns or holds responsibility for (for example the developer machine with programming tools, debugger, etc.).

The **inner loop for quantum components** involves following [activities enabled by the Quantum Development Kit](/azure/quantum/overview-azure-quantum#workflow-of-the-quantum-software-development). These activities are typically performed by team members specialized for quantum computing algorithm development (quantum engineers, quantum architects, and similar roles):

1. Write quantum code
1. Use libraries to keep code high level
1. Integrate with classical software
1. Run quantum code in simulation
1. Estimate resources
1. Run (test) code on quantum hardware

The last three steps are specific to quantum computing. For running and testing your code, there are two alternative execution environments available: [quantum simulators and quantum hardware](/azure/quantum/overview-understanding-quantum-computing#quantum-computers-vs-quantum-simulators). [Simulators](/azure/quantum/user-guide/machines/) are software programs that run on classical computers and can act as the target machine for a Q# program. They make it possible to run and test quantum programs in an environment that predicts how qubits will react to different operations as they offer access to the full state vector of qubit registers. These insights are a great tool for analyzing runtime behavior of quantum algorithms.

For verifying the simulation results and especially for those tests that exhibit the probabilistic behavior of quantum systems, you should execute your code on [quantum hardware](/azure/quantum/qc-target-list), which gives you real-time performance insights in your job's runtime behavior. Because quantum hardware is a scarce resource, developers typically don't own their own or have exclusive access. Instead, they use centrally operated environments - in most cases they access production hardware to test their development artifacts. There, the jobs are queued until jobs submitted before complete, which might delay the testing cycle a bit.

The **inner loop for classical components** includes typical development steps for building, running, and debugging code in a development environment. In context of hybrid quantum applications, there is an extra step of integrating the quantum components into the classical components. Complexity of this step depends on whether the quantum components are [tightly coupled](../../example-scenario/quantum/tightly-coupled-quantum-computing-job.yml) or [loosely coupled](../../example-scenario/quantum/loosely-coupled-quantum-computing-job.yml) with the classical ones. Developers don't need special quantum computing skills. The integration can typically be implemented with classical programming skills.

## Infrastructure as Code (IaC)

Like any other Azure environment, quantum workspaces and the classical environments can be automatically provisioned via [Azure Resource Manager templates](/azure/azure-resource-manager/templates/). These JavaScript Object Notation (JSON) files contain definitions for the two target environments:

* The **quantum environment** contains an Azure Quantum workspace with its associated Azure Storage account. This environment should be kept in its separate [resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal). Typically, the lifecycle of these resources is different from the classical resources, which often are recreated with each deployment cycle.
* The **classical environment** contains all other Azure resources that are needed for executing the classical software components. Types of resources are highly dependent on the selected compute model and the integration model.

:::image type="content" source="media/iac-in-quantum-devops.png" alt-text="Infrastructure as code in DevOps for quantum applications":::

If the [loosely coupled integration model](../../example-scenario/quantum/loosely-coupled-quantum-computing-job.yml) is chosen, the classical environment includes all resources needed for exposing the quantum functionality via API. If the [tightly coupled approach](../../example-scenario/quantum/tightly-coupled-quantum-computing-job.yml) is chosen, its components depend on the chosen [compute model](../technology-choices/compute-decision-tree.md).

## Continuous Integration (CI) and Automated Testing

Continuous Integration remains an important part of DevOps with hybrid quantum applications. As soon as code is ready and committed to the repository, it needs to be automatically tested and integrated into other parts of the software. For the pure classical parts of the application, [best practices for testing](../../checklist/dev-ops.md#testing) remain in place. The Microsoft Azure Well-Architected Framework also gives some [guidance on CI best practices](../../framework/devops/release-engineering-ci.md).

The quantum components require special treatment. The components themselves require special execution environments. In addition, the classical code where quantum components are managed (that is, submitted and monitored at the quantum workspace) needs to be tested.

Testing of quantum components includes following activities:

* Unit tests implemented via [test projects](/azure/quantum/user-guide/testing-debugging) and executed on a quantum simulator.
* [Estimation of required resources](/azure/quantum/user-guide/machines/resources-estimator) on quantum hardware.
* Tests being executed on quantum hardware - potentially the target production environment.

For testing purposes, the quantum jobs can either be submitted by the classical components used in production, or by components (for example CLI scripts) specially written for automated testing.

Because of its probabilistic nature, testing of the quantum components has some special requirements:

* Choose the execution environment for tests carefully. You can efficiently execute many tests on a quantum simulator (where there is access to the full state vector of qubit registers). However, you need quantum hardware for those tests that exhibit the probabilistic behavior.
* Run tests that cover these probabilistic portions of algorithms multiple times to make sure that a successful test will stay successful on subsequent runs.
* Results of program execution must be validated based on its nature, often using quantum-specific tools and tricks (some described in [part 1](https://devblogs.microsoft.com/qsharp/inside-the-quantum-katas-part-1/) and [part 2](https://devblogs.microsoft.com/qsharp/inside-the-quantum-katas-part-2-testing-quantum-programs/) of previous blogs titled "Inside the Quantum Katas"). Tests must validate, if results represent valid solutions and honor existing constraints.

During integration, the quantum components are bundled with the classical components. The result represents the deployment artifact that gets installed on the classical environment during subsequent steps.

## Continuous Delivery (CD)

Continuous Delivery involves [building, testing, configuring, and deploying the application](/devops/deliver/what-is-continuous-delivery). If your organization has a DevOps culture that supports it, you can automate these steps up to the deployment in production environments.

The build and test steps were already covered in the CI-phase. Configuring and deployment of the application involves following steps:

* **Provisioning of target environments**
  * Environment provisioning can be automated by deploying the ARM templates stored in the repository.
  * It is not necessary to reprovision the quantum components every time the code changes. As the quantum code doesn't persist on these components (the jobs are submitted on demand by the classical components) these components should be reprovisioned only on special occasions (for example a full, clean deployment).
  * The classical components can be reprovisioned with every code change. To minimize disruption during deployment, you can implement a [staged approach](../../framework/devops/release-engineering-cd.md#stage-your-workloads), and use features offered by many Azure compute services for [high availability](../../framework/devops/release-engineering-cd.md#high-availability-considerations).
* **Configuration of target environments**
  * As the classical components need to have permissions to submit quantum jobs, you should define [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) for the classical components (for example the job orchestrating Azure Function). With managed identities, you can properly restrict access to the quantum resources to only those components that need to access them for job orchestration purpose.
  * Grant the classical components access to the quantum workspace, so that they can submit and monitor quantum jobs. Add a contributor role assignment to the quantum workspace for the managed identity.
* **Shipping of application artifacts to the target environments**
  * Shipping involves deploying the classical application package (that includes the quantum job artifacts) to the chosen compute service.

## Application Monitoring

Once the classical component submitted a quantum job, it must [monitor the status](/azure/quantum/how-to-work-with-jobs#monitoring-jobs) of the job. The quantum workspace provides an API to query the status. The classical component can log the quantum status via [custom events in application insights](/azure/azure-monitor/app/api-custom-events-metrics) along with all the other application logging to be analyzed and visualized with [Azure Monitor](/azure/azure-monitor/).

## Next steps

* To get an overview of Microsoft Quantum, the world's first full-stack, open cloud quantum computing ecosystem, see [Microsoft Quantum](https://azure.microsoft.com/solutions/quantum-computing/) and work through the [Quantum Computing Foundations](/learn/paths/quantum-computing-fundamentals/) learning path.
* For more information about the Azure Quantum service, see [Azure Quantum](https://azure.microsoft.com/services/quantum/).
* For general aspects of Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).
* For more information about Azure DevOps, see the official [Azure DevOps documentation](/azure/devops/).

## Related resources

* [DevOps Checklist](/azure/architecture/checklist/dev-ops)
* [CI/CD for Quantum Computing jobs](../../solution-ideas/articles/cicd-for-quantum-computing-jobs.yml).
* [Tightly coupled quantum computing job](../../example-scenario/quantum/tightly-coupled-quantum-computing-job.yml).
* [Loosely coupled quantum computing job](../../example-scenario/quantum/loosely-coupled-quantum-computing-job.yml).
