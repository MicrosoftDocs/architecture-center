[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Quantum computing applies the unique behavior of quantum physics to computing. This approach promises massive speedup in compute time compared to classical computing especially in areas like optimization, simulation, or machine learning. However, quantum computing components have a different development and operating model compared to pure classical software. Typically, one or more classical compute component orchestrates the [execution of quantum jobs](/azure/quantum/how-to-work-with-jobs) at runtime.

This combination of classical and quantum components must be reflected in the build process. This is true for both the [loosely](../../example-scenario/quantum/loosely-coupled-quantum-computing-job.yml) and the [tightly coupled](../../example-scenario/quantum/tightly-coupled-quantum-computing-job.yml) integration approach. The quantum components have special requirements for their [software development lifecycle](/azure/quantum/overview-what-is-qsharp-and-qdk#what-can-i-do-with-the-qdk). For quality assurance, quantum jobs should be run on simulators, sized on resource estimators and in some cases run on quantum hardware. After successful tests, the job artifacts can be integrated into the classical components that submit the job to quantum targets at runtime.

## Architecture

![Architecture diagram](../media/cicd-for-quantum-computing-jobs.png)

### Data flow

1. Developer changes the source code of the application components.
1. Changes are committed to the source code repository.
1. Changes to quantum code trigger the quantum build pipeline. The build pipeline checks out the code, compiles it, performs resource estimation, and runs the algorithm on a simulator.
1. The compiled quantum algorithm is submitted to a quantum environment for testing.
1. Changes trigger a build pipeline for the classical components. The pipeline checks out the code, compiles it, does unit and integration tests.
1. Successful compilation and tests trigger a release pipeline. The pipeline first provisions the Azure environment by deploying the Azure Resource Manager templates stored in the repository (Infrastructure as Code).
1. Compiled app classic artifacts are deployed to Azure. The quantum jobs are submitted to a quantum workspace during runtime.
1. Runtime behavior, health, performance, and usage information are monitored via Application Insights.
1. Backlog items are updated depending on monitoring results.
1. Application Developer leverages Application Insights for application feedback and optimization.

### Components

The DevOps tools included here:

* [Azure Repos](/azure/devops/repos/) for storing both the quantum and classic code and Azure Resource Manager templates for the environment provisioning.
* [Azure Pipelines](/azure/devops/pipelines/) for implementing the CI/CD-steps including environment provisioning before code deployment.

The CI/CD-processes can be implemented using GitHub repositories and GitHub actions instead.

The application components used:

* A client application that orchestrates the quantum job. Integration can be implemented in a [tightly coupled](../../example-scenario/quantum/tightly-coupled-quantum-computing-job.yml) or a [loosely coupled](../../example-scenario/quantum/loosely-coupled-quantum-computing-job.yml) approach.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) coordinates user authentication and protects access to the Azure Quantum Workspace.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets like Quantum Workspace name.
* [Azure Quantum](https://azure.microsoft.com/services/quantum) provides functionality for running quantum computing jobs on various target quantum environments.
* [Azure Storage](https://azure.microsoft.com/services/storage) holds input and output data of the quantum job.
* [Application Insights](/azure/azure-monitor/app/app-insights-overview) monitors the application, detects application anomalies such as poor performance and failures, and sends telemetry to the Azure portal.

The [Azure Quantum workspace](/azure/quantum/how-to-create-workspace) is a collection of assets associated with running quantum computing or optimization applications. Depending on provisioned providers, the jobs are executed on quantum simulators, quantum hardware, or optimization solvers.

## Next steps

* To get an overview of Azure Quantum, the world's first full-stack, open cloud quantum computing ecosystem, see [Microsoft Quantum](https://azure.microsoft.com/solutions/quantum-computing/) and work through the [Quantum Computing Foundations](/learn/paths/quantum-computing-fundamentals/) learning path.
* For more information about the Azure Quantum service, see [Azure Quantum](https://azure.microsoft.com/services/quantum/).
* For general aspects of Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).
* For more information about Azure DevOps, see the official [Azure DevOps documentation](/azure/devops/).

## Related resources

* [The operational excellence pillar](../../framework/devops/overview.md) of the Microsoft Azure Well-Architected Framework
* [DevOps Checklist](../../checklist/dev-ops.md)
* [Choose an Azure compute service for your application](../../guide/technology-choices/compute-decision-tree.md)
