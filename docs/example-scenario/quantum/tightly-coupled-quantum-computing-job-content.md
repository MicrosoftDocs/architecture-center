Quantum computers harness the unique behavior of quantum physics and apply it to computing. This approach promises massive speedup in compute time compared to classical computing especially in areas like optimization, simulation, or machine learning. However, quantum computing components have a different operating model compared to classical software. There are typically one or more classical compute components that orchestrate the execution of quantum components. This orchestration includes the following activities:

* Preparation of input data
* Submission of quantum computing jobs to a target quantum environment
* Monitoring of job execution
* Post-processing of job results

This orchestration functionality can be integrated to classical applications in one of two ways:

* **Integration via tight coupling** - logic for the orchestration is integrated into the classical component. Use the approach described in this article in following scenarios:
  * The quantum components are developed by the same team.
  * Quantum components share the same lifecycle as the classical components.
  * Use of the quantum components is limited to a single application.
* **Integration via loose coupling** - logic for the orchestration is exposed as an API that can be called by various classical software components. For more information about this integration approach, see [Loosely coupled quantum computing job](loosely-coupled-quantum-computing-job.yml). Use the approach in following scenarios:
  * The quantum components are developed independently from any classical client application.
  * Quantum components should be reused by various applications.

Independent from either coupling approach, following scenarios promise to benefit from quantum computing in near-term:

* Optimization challenges
* Simulation tasks
* Machine Learning
## Potential use cases

Use this architecture where quantum computing jobs must be executed as part of a classical application. 

The tightly coupled approach should be preferred in following cases:

* One team owns both the quantum and the classical code, and both are interwoven with each other.
* The quantum job represents a specialized solution (for example, a molecule simulation) that will only be used by one specialized classical application.
* The implemented algorithm is hybrid quantum-classical by nature (for example, Variational Quantum Eigensolvers (VQE), Quantum Approximate Optimization Algorithms (QAOA), and so on).

## Architecture

:::image type="content" source="media/tightly-coupled-quantum-computing-job-architecture.png" alt-text="Architecture of a hybrid app containing a tightly coupled quantum computing job":::

1. A signed-in user triggers quantum job execution via a classic client application.
1. The client application puts input data into Azure Storage.
1. The client application submits the job to an Azure Quantum workspace, specifying the execution target(s). The client identifies the workspace via data stored in Azure Key Vault and authenticates to the workspace via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview).
1. A quantum provider executes the job on a target environment.
1. The client application monitors job execution by polling job status.
1. As soon as the quantum job finishes, the client application gets the compute result from Azure Storage.

This workflow implements the [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md) and the steps defined for the [Azure Quantum Job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle).

### Components

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) coordinates user authentication and protects access to the Azure Quantum workspace.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets, such as the Azure Quantum workspace name.
* [Azure Quantum](https://azure.microsoft.com/services/quantum) provides functionality for running quantum computing jobs on various target quantum environments.
* [Azure Storage](https://azure.microsoft.com/services/storage) provides storage for input data and results from the quantum provider. 

The [Azure Quantum workspace](/azure/quantum/how-to-create-workspace), accessible via the Azure Portal, is a collection of assets associated with running quantum or optimization jobs on various targets. Depending on provisioned providers, the jobs are executed on quantum simulators, quantum hardware, or optimization solvers.

### Alternatives

The architecture presented here assumes that the given business problem requires quantum computing resources for its compute tasks. For some compute challenges, existing services built to perform [high-performance computing](https://azure.microsoft.com/solutions/high-performance-computing/) or provide [AI functionality](https://azure.microsoft.com/overview/ai-platform/) could be an alternative.

## Considerations

Some of the quantum targets (especially quantum hardware) will be a limited resource for the foreseeable future. Access to these resources is implemented via a queueing mechanism. This pattern leads to fluctuating runtime behavior of job executions. For calculating the full response time, the time waiting for an available resource must be added to the job execution time.

### Availability

Availability of the quantum compute functionality is highly dependent on the availability and install base of the chosen [quantum computing providers](/azure/quantum/qc-target-list) and [optimization providers](/azure/quantum/qio-target-list). Depending on the selected compute targets, the classic client application should be prepared for longer waiting times or non-availability of the target.

For the surrounding Azure services, the usual availability considerations apply:

* Use redundancy options of [Azure Key Vault](/azure/key-vault/general/disaster-recovery-guidance).
* If necessary, consider using replication options in [Azure Storage](/azure/storage/common/storage-redundancy).

### Performance and Scalability

The application performance is dependent on the availability and performance of the underlying quantum computing targets. For the classical parts be aware of [typical design patterns for scalability](/azure/architecture/framework/scalability/performance-efficiency-patterns) and the [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency)) available in the Azure Architecture Center.

### Security

Unlike in the [loosely coupled alternative](loosely-coupled-quantum-computing-job.yml), the architecture presented here assumes only one client is accessing the Azure Quantum workspace. This scenario leads to the following requirements:

* As the client is known, authentication can be implemented via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview) associated to the application.
* Throttling of requests and caching of results can be implemented in the client itself.

For general security aspects, consider applying the [typical design patterns for security](/azure/architecture/framework/security/security-patterns) where appropriate.

### Resiliency

Always respect that quantum target environments are shared resources. Providers typically put submitted jobs into a queue where they have to wait until previously submitted jobs complete. It is important to monitor job execution to inform the user about the current job status. For cases where job execution fails because of a transient error, you should implement a [retry pattern](/azure/architecture/patterns/retry). Furthermore, you should submit the jobs via asynchronous calls with polling for the result to avoid unnecessary blocking of the calling client.

### DevOps

For a description of what a CI/CD-approach for this architecture might look like, see [CI/CD for Quantum Computing Jobs](../../solution-ideas/articles/cicd-for-quantum-computing-jobs.yml).

## Pricing

Overall cost of this solution depends on the quantum computing target selected for running the quantum job. Calculating estimated cost for the classic components is straightforward and can be easily done with the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

For the Azure Quantum service, the following points should be considered:

* Microsoft QIO solvers are billed via the Azure subscription bill. Cost depends on selected SKU and usage pattern. For details, refer to the [Azure Quantum pricing](https://azure.microsoft.com/pricing/details/azure-quantum/) page.
* Other optimization providers are available on Azure Marketplace. For cost details, see the respective reference page listed in [Optimization providers on Azure Quantum](/azure/quantum/qio-target-list).
* Quantum computing providers can be consumed via Azure Marketplace offering. Cost depends on type of resource (simulator or hardware), SKU, and usage. For details, see the reference page for the provider needed for your scenario referenced in [Quantum computing providers on Azure Quantum](/azure/quantum/qc-target-list).

## Next steps

* To get an overview of Azure Quantum, the world's first full-stack, open cloud quantum computing ecosystem, see [Microsoft Quantum](https://azure.microsoft.com/solutions/quantum-computing/) and work through the [Quantum Computing Foundations](/learn/paths/quantum-computing-fundamentals/) learning path.
* For more information about the Azure Quantum service, see [Azure Quantum](https://azure.microsoft.com/services/quantum/).
* For general aspects of Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).
* For learning about [running algorithms on quantum hardware](/learn/modules/run-algorithms-quantum-hardware-azure-quantum/), see the corresponding learning module on MS learn.

## Related resources

* [Operational excellence principles](../../framework/devops/principles.md)
* [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md)
