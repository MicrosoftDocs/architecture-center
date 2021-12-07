Quantum computers harness the unique behavior of quantum physics and apply it to computing. This approach promises massive speedup in compute time compared to classical computing especially in areas like optimization, simulation, or machine learning. However, quantum computing components have a different operating model compared to classical software. There are typically one or more classical compute components that orchestrate the execution of quantum components. This orchestration includes following activities:

* Preparation of input data
* Submission of quantum computing jobs to a target quantum environment
* Monitoring of the job execution
* Post-processing of job results

This orchestration functionality can be integrated to classical applications in one of two ways:

* **Integration via tight coupling** - logic for the orchestration is integrated into the classical component. Use the approach described in this article in following scenarios:
  * The quantum components are developed by the same team.
  * Quantum components share the same lifecycle as the classical components.
  * Use of the quantum components is limited to a single application.
* **Integration via loose coupling** - logic for the orchestration is exposed as an API that can be called by various classical software components. For more information about this integration approach, see [Loosely coupled quantum computing job](loosely-coupled-quantum-computing-job.md). Use the approach in following scenarios:
  * The quantum components are developed independently from any classical client application.
  * Quantum components should be reused by various applications.

## Potential use cases

Use this architecture where quantum computing jobs must be executed as part of a classical application. The tightly coupled approach should be used when only one client application needs the quantum functionality. Interaction with the quantum workspace can be implemented directly in the client application.

Following scenarios promise to benefit from quantum computing in near-term:

* Optimization challenges
* Simulation tasks
* Machine Learning

## Architecture

:::image type="content" source="media/tightly-coupled-quantum-computing-job-architecture.png" alt-text="Architecture of a hybrid app containing a tightly coupled quantum computing job":::

1. A signed-in user triggers quantum job execution via a classic application.
1. Classic client application puts input data into Azure Storage.
1. Client application submits the job to an Azure Quantum Workspace specifying the execution target(s). The client identifies the Quantum Workspace via data stored in Azure Key Vault and authenticates to the Quantum Workspace via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview).
1. A provider executes the job on a target environment.
1. Client application monitors job execution by polling job status.
1. As soon as the quantum job finishes, the client application gets the compute result from Azure Storage.

This workflow implements the * [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md) and the steps defined for the [Azure Quantum Job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle).

### Components

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) coordinates user authentication and protects access to the Azure Quantum Workspace.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets like Quantum Workspace name.
* [Azure Quantum](https://azure.microsoft.com/services/quantum) provides functionality for running quantum computing jobs on various target quantum environments.
* [Azure Storage](https://azure.microsoft.com/services/storage)

The [Azure Quantum Workspace](/azure/quantum/how-to-create-workspace) accessible via Azure Quantum is a collection of assets associated with running quantum or optimization applications on various targets. Depending on provisioned providers the jobs are executed on quantum simulators, quantum hardware, or optimization solvers.

### Alternatives

The architecture presented here assumes that the given business problem requires quantum computing resources for its compute tasks. For some compute challenges existing services built to perform [high-performance computing](https://azure.microsoft.com/solutions/high-performance-computing/) or provide [AI functionality](https://azure.microsoft.com/overview/ai-platform/) could be an alternative.

## Considerations

Some of the quantum targets (especially quantum hardware) will be a limited resource for the foreseeable future. Access to these resources is implemented via a queueing mechanism. This pattern leads to fluctuating runtime behavior of job executions. For getting the full response time, the time waiting for an available resource must be added to the job execution time.

### Availability

Availability of the quantum compute functionality is highly dependent on the availability and install base of the chosen [quantum computing providers](/azure/quantum/qc-target-list) and [optimization providers](/azure/quantum/qio-target-list). Depending on the selected compute targets, the classic client application should be prepared for longer waiting times and/or non-availability of the target.

For the surrounding Azure services, the usual availability considerations apply:

* Use redundancy options of [Azure Key Vault](/azure/key-vault/general/disaster-recovery-guidance).
* If necessary, consider using replication options in [Azure Storage](/azure/storage/common/storage-redundancy).

### Performance and Scalability

The application performance is dependent on the availability and performance of the underlying quantum computing targets. For the classical parts be aware of typical design patterns ([typical design patterns for scalability](/azure/architecture/framework/scalability/performance-efficiency-patterns), [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency)) available in the Azure Architecture Center.

### Security

Unlike in the [loosely coupled alternative](loosely-coupled-quantum-computing-job.md), the architecture presented here assumes only one client is accessing the quantum workspace. This scenario leads to following requirements:

* As the client is known, authentication can be implemented via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview) associated to the application.
* Throttling of requests and caching of results can be implemented in the client itself.

For general security aspects, consider applying the [typical design patterns for security](/azure/architecture/framework/security/security-patterns) where appropriate.

### Resiliency

Always respect that quantum target environments are limited resources. At some providers submitted jobs are first added to a queue before being processed. It is important to monitor job execution to give feedback to the user about the current status. For cases where job execution fails because of a transient error, a [retry pattern](/azure/architecture/patterns/retry) should be implemented for job submission. Submission should not happen via synchronous call but asynchronously instead with polling for the result.

### DevOps

For a description of how a CI/CD-approach for this architecture could look like, see [CI/CD for Quantum Computing Jobs](../../solution-ideas/articles/cicd-for-quantum-computing-jobs.md).

## Pricing

Overall cost of this solution depends on the quantum computing target selected for running the quantum job. Calculating estimated cost for the classic components is straightforward and can be easily done with the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

For the Azure Quantum service following points should be considered:

* Microsoft QIO solvers are billed via the Azure subscription bill. Cost depends on selected SKU and usage pattern. For details refer to the [Azure Quantum pricing](https://azure.microsoft.com/pricing/details/azure-quantum/) page.
* Other optimization providers are available on Azure Marketplace. For cost details have a look at respective reference page listed on [Optimization providers on Azure Quantum](https://docs.microsoft.com/azure/quantum/qio-target-list)
* Quantum computing providers can be consumed via Azure Marketplace offering. Cost depends on type of resource (simulator or hardware), SKU, and usage. For details see the reference page for the provider needed for your scenario referenced on [Quantum computing providers on Azure Quantum](https://docs.microsoft.com/azure/quantum/qc-target-list).

## Next steps

* To get an overview of Microsoft Quantum, the world's first full-stack, open cloud quantum computing ecosystem, see [Microsoft Quantum](https://azure.microsoft.com/solutions/quantum-computing/).
* For more information about the Azure Quantum service, see [Azure Quantum](https://azure.microsoft.com/services/quantum/).
* For general aspects of Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).

## Related resources

* [Operational excellence principles](../../framework/devops/principles.md)
* [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md)
