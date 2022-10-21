Quantum computing applies the unique behavior of quantum mechanics to information processing. This approach provides dramatically faster compute than classical computing, especially in areas like optimization, simulation, and machine learning. However, quantum computing components have a different development and operating model than that of classical software. They're not installed and run like classical applications (for example, on physical hardware or virtual machines). Instead, quantum applications are developed as *jobs*. A classical software component (running in a classical environment) orchestrates the [execution of quantum jobs](/azure/quantum/how-to-work-with-jobs) in a target environment at runtime.

A quantum computing application is in fact always a hybrid application that consists of classical (orchestration) and quantum (quantum algorithm) parts. DevOps has specific requirements for both parts. This article discusses the DevOps requirements for hybrid quantum applications. DevOps provides a repeatable, high-quality process for building, deploying, and monitoring software.

## DevOps and quantum computing 

DevOps can be defined as ["the union of people, process, and technology to continually provide value to customers"](https://azure.microsoft.com/overview/what-is-devops). This definition provides a great structure for discussing the requirements of hybrid quantum applications.

* **People**. Designing, developing, and operating quantum algorithms requires skills that are different from those required for classical components. Designers and developers typically include quantum information scientists and people in similar roles. Operations team members must be familiar with specialized target systems, including optimization solvers and quantum hardware.
* **Process**. The clear separation of classical and quantum components on the one hand, and the need to integrate them on the other, requires an alignment of the quantum and the classical DevOps activities.
* **Technology**. The lifecycles of the different execution environments must be considered as well. Quantum computers are scarce resources, typically operated as central resources and accessed by various classical clients.

These pillars must come together to form a unified approach for designing, developing, operating, and managing hybrid quantum software systems in a repeatable, reliable way. DevOps influences the application lifecycle throughout the plan, develop, deliver, and operate phases of quantum components.

* **Plan**. [Quantum computing targets](/azure/quantum/qc-target-list) differ in their capabilities. These capabilities are described via [target profiles](/azure/quantum/quantum-computing-target-profiles). Because the choice of target influences what code you can run, you should select a target early in the process.
* **Develop**. Azure Quantum provides flexibility for your development approach. You can write quantum components in [Q#](/azure/quantum/overview-what-is-qsharp-and-qdk) or [Python](/azure/quantum/install-python-qdk) (by using Qiskit or Cirq). You can use [Visual Studio](https://marketplace.visualstudio.com/items?itemName=quantum.DevKit), [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=quantum.quantum-devkit-vscode), or [Jupyter Notebooks](/azure/quantum/install-command-line-qdk).
* **Deliver**. Quantum components are delivered indirectly. Instead of installing them on a quantum target system, you package them with classical software components. The classical parts [orchestrate quantum job submission and monitoring](/azure/quantum/how-to-work-with-jobs) on quantum systems.
* **Operate**. The operations model of quantum components is aligned with the [quantum job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle). Monitoring is done by the classical components that submit the quantum jobs to quantum targets.

## The inner and outer DevOps loops

In DevOps, we typically distinguish between the inner and the outer loop.

:::image type="content" source="media/inner-and-outer-loop-in-quantum-devops.png" alt-text="Diagram that shows the DevOps inner and outer loops for quantum applications.":::

### The outer loop

The *outer loop* includes activities that are typically associated with a full DevOps cycle:

* Managing work items in a product backlog.
* Developing and testing software artifacts (via inner loops).
* Centrally building and deploying these artifacts, which includes provisioning of the target environment.
* Monitoring the running application. Results might lead to new work items in the backlog.

These steps are discussed in more detail later in this article.

### The inner loop

The *inner loop* is the iterative process a quantum or classical developer performs when writing, building, and testing code. The inner loop mostly takes place on IT systems that an individual developer owns or is responsible for. For example, the developer machine with programming tools and a debugger.

The **inner loop for quantum components** involves completing [activities enabled by the Quantum Development Kit](/azure/quantum/overview-azure-quantum#workflow-of-the-quantum-software-development). These activities are typically performed by team members who specialize in quantum computing algorithm development (quantum engineers, quantum architects, and similar roles):

1. Write quantum code.
1. Use libraries to keep code high level.
1. Integrate with classical software.
1. Run quantum code in simulation.
1. Estimate resources.
1. Run and test code on quantum hardware.

The last three steps are specific to quantum computing. For running and testing your code, there are two alternative execution environments available: [quantum simulators and quantum hardware](/azure/quantum/overview-understanding-quantum-computing#quantum-computers-vs-quantum-simulators). [Simulators](/azure/quantum/user-guide/machines/) are software programs that run on classical computers and that can be the target machine for a Q# program. Because they provide access to the full state vector of qubit registers, you can use them to run and test quantum programs in an environment that predicts how qubits will react to various operations. The resulting insights are great for analyzing the runtime behavior of quantum algorithms.

To verify the simulation results, especially for tests that exhibit the probabilistic behavior of quantum systems, run your code on [quantum hardware](/azure/quantum/qc-target-list). Doing so gives you real-time performance insights about your job's runtime behavior. Because quantum hardware is a scarce resource, developers typically don't have their own, or don't have exclusive access. Instead, they use centrally operated environments. They usually access production hardware to test their development artifacts. The jobs are queued until previously submitted jobs complete, which might delay the testing cycle.

The **inner loop for classical components** includes typical development steps for building, running, and debugging code in a development environment. In the context of hybrid quantum applications, there's an extra step: integrating the quantum components into the classical components. The complexity of this step depends on whether the quantum components are [tightly coupled](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps) or [loosely coupled](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps) with the classical ones. Developers don't need special quantum computing skills. The integration can typically be implemented with classical programming skills.

## Infrastructure as Code (IaC)

As with any other Azure environment, you can use [Azure Resource Manager templates](/azure/azure-resource-manager/templates/) to automatically provision quantum workspaces and the classical environments. These JavaScript Object Notation (JSON) files contain definitions for the two target environments:

* The **quantum environment** contains an Azure Quantum workspace with its associated Azure Storage account. Keep this environment in its own separate [resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal). Typically, the lifecycle of these resources is different from that of classical resources, which are often re-created with each deployment cycle.
* The **classical environment** contains all other Azure resources that are needed for running the classical software components. The types of resources that you need vary depending on the compute model and the integration model.

:::image type="content" source="media/iac-in-quantum-devops.png" alt-text="Diagram that shows deployment of Infrastructure as Code in DevOps for quantum applications.":::

If you use the [loosely coupled integration model](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps), the classical environment includes all the resources that you need to expose the quantum functionality via API. If you use the [tightly coupled approach](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps), the resources that you need vary depending on the [compute model](../technology-choices/compute-decision-tree.yml).

## Continuous integration (CI) and automated testing

As for other applications, continuous integration is an important part of DevOps for hybrid quantum applications. As soon as code is ready and committed to the repository, it needs to be automatically tested and integrated into other parts of the software. For the classical parts of the application, [best practices for testing](../../checklist/dev-ops.md#testing) still apply. The Microsoft Azure Well-Architected Framework provides [guidance on CI best practices](/azure/architecture/framework/devops/release-engineering-ci). 

The quantum components require special treatment. The components themselves require special execution environments. And the classical code where quantum components are managed (that is, submitted and monitored at the quantum workspace) needs to be tested.

Testing of quantum components includes:

* Unit tests implemented via [test projects](/azure/quantum/user-guide/testing-debugging) and run on a quantum simulator.
* [Estimation of required resources](/azure/quantum/user-guide/machines/resources-estimator) on quantum hardware.
* Tests run on quantum hardware, potentially the target production environment.

For testing, the quantum jobs can either be submitted by the classical components used in production or by components (for example, CLI scripts) specially written for automated testing.

Because of its probabilistic nature, testing of the quantum components has some special requirements:

* Choose the execution environment for tests carefully. You can efficiently run many tests on a quantum simulator, which has access to the full state vector of qubit registers. However, you need quantum hardware for tests that exhibit probabilistic behavior.
* Run tests that cover the probabilistic portions of algorithms multiple times to make sure that successful tests stay successful on later runs.
* Validate the results of program execution based on the nature of the program. You often need to use quantum-specific tools and techniques. (Some of these tools and techniques are described in [Inside the Quantum Katas, part 1](https://devblogs.microsoft.com/qsharp/inside-the-quantum-katas-part-1) and [part 2](https://devblogs.microsoft.com/qsharp/inside-the-quantum-katas-part-2-testing-quantum-programs).) Tests must verify that results represent valid solutions and honor constraints.

During integration, the quantum components are bundled with the classical components. The result represents the deployment artifact that's installed on the classical environment during subsequent steps.

## Continuous delivery (CD)

Continuous delivery includes [building, testing, configuring, and deploying the application](/devops/deliver/what-is-continuous-delivery). If your organization has a DevOps culture that supports it, you can automate these steps up to the deployment in production environments.

The build and test steps are described earlier in this article, in the CI section. Configuring and deploying the application includes these steps:

* **Provisioning target environments**
  * You can automate environment provisioning by deploying ARM templates that are stored in the source code repository.
  * You don't need to reprovision the quantum components every time the code changes. The quantum code doesn't persist in these components. The jobs are submitted on demand by the classical components. So the quantum components should be reprovisioned only on special occasions, like, for example, a full, clean deployment.
  * The classical components can be reprovisioned with every code change. To minimize disruption during deployment, you can implement a [staged approach](/azure/architecture/framework/devops/release-engineering-cd#stage-your-workloads) and use features offered by many Azure compute services for [high availability](/azure/architecture/framework/devops/release-engineering-cd#high-availability-considerations).
* **Configuring target environments**
  * The classical components need to have permissions to submit quantum jobs. (For example, you might use an Azure function to orchestrate the job.) Define [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) for these components. By using managed identities, you can restrict access to the quantum resources to only components that need to access them for job orchestration.
  * Grant the classical components access to the quantum workspace so that they can submit and monitor quantum jobs. Add a contributor role assignment to the quantum workspace for the managed identity.
* **Shipping application artifacts to the target environments**
  * Shipping involves deploying the classical application package (which includes the quantum job artifacts) to the chosen compute service.

## Application monitoring

After the classical component submits a quantum job, it must [monitor the status](/azure/quantum/how-to-work-with-jobs#monitoring-jobs) of the job. The quantum workspace provides an API to query the status. The classical component can log the quantum status via [custom events in Application Insights](/azure/azure-monitor/app/api-custom-events-metrics), along with all the other application logging to be analyzed and visualized via [Azure Monitor](/azure/azure-monitor).

## Next steps

* For an overview of Microsoft Quantum, a full-stack, open-cloud quantum computing ecosystem, see [Microsoft Quantum](https://azure.microsoft.com/solutions/quantum-computing) and complete the [Quantum computing foundations](/training/paths/quantum-computing-fundamentals) learning path.
* For more information about the Azure Quantum service, see [Azure Quantum](https://azure.microsoft.com/services/quantum).
* For general information about Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).
* For more information about Azure DevOps, see the [Azure DevOps documentation](/azure/devops).

## Related resources

* [DevOps Checklist](../../checklist/dev-ops.md)
* [CI/CD for quantum computing jobs](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps)
* [Tightly coupled quantum computing job](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps)
* [Loosely coupled quantum computing job](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps)