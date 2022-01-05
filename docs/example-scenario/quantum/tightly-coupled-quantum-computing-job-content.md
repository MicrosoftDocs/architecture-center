Quantum computing applies the unique behavior of quantum physics to computing. This approach provides dramatically faster compute than classical computing, especially in areas like optimization, simulation, and machine learning. However, quantum computing components have a different operating model from that of classical software. There are typically one or more classical compute components that orchestrate the running of quantum components. This orchestration includes the following activities:

* Preparation of input data
* Submission of quantum computing [jobs](/azure/quantum/how-to-work-with-jobs) to a target quantum environment
* Monitoring of job execution
* Post-processing of job results

You can integrate this orchestration with classical applications in one of two ways:

* **Integration via tight coupling.** Logic for the orchestration is integrated into the classical component. Use this approach in the following scenarios:
  * Quantum components are developed by the team that develops the classical components.
  * Quantum components share the same lifecycle as the classical components.
  * Use of the quantum components is limited to a single application.
* **Integration via loose coupling.** Logic for the orchestration is exposed as an API that can be called by various classical software components. For more information about this integration approach, see [Loosely coupled quantum computing](loosely-coupled-quantum-computing-job.yml). Use this approach in the following scenarios:
  * Quantum components are developed independently from any classical client application.
  * Quantum components will be reused by various applications.

This article describes how to implement quantum applications that use the tightly coupled model. The architecture described here uses Azure Quantum, Azure Active Directory (Azure AD), and Azure Key Vault.

## Potential use cases

Use this architecture where quantum computing jobs must be run as part of a classical application. 

The tightly coupled approach is preferred in these cases:

* One team owns both the quantum code and the classical code, and the code is integrated.
* The quantum job represents a specialized solution (for example, a molecular simulation) that will be used only by one specialized classical application.
* The implemented algorithm is hybrid quantum-classical by nature, for example, Variational Quantum Eigensolvers (VQE) and Quantum Approximate Optimization Algorithms (QAOA).

## Architecture

:::image type="content" border="false" source="media/tightly-coupled-quantum-computing-job-architecture.png" alt-text="Architecture diagram that shows a hybrid app that contains a tightly coupled quantum computing job.":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/tightly-coupled-quantum.pptx) of this architecture.*

### Dataflow
1. A signed-in user triggers quantum job execution via a classical client application.
1. The client application puts input data into Azure Storage.
1. The client application submits the job to an Azure Quantum workspace, specifying the execution target or targets. The client identifies the workspace via data that's stored in Key Vault and authenticates to the workspace via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview).
1. A quantum provider runs the job on a target environment.
1. The client application monitors job execution by polling job status.
1. As soon as the quantum job finishes, the client application gets the compute result from Storage.

This workflow implements the [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md) and the steps defined for the [Azure Quantum job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle).

### Components
* [Azure Quantum](https://azure.microsoft.com/services/quantum) provides a [workspace](/azure/quantum/how-to-create-workspace), accessible from the Azure portal, for assets associated with running quantum or optimization jobs on various targets. Jobs are run on quantum simulators, quantum hardware, or optimization solvers, depending on the provider you choose.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) coordinates user authentication and helps to protect access to the Azure Quantum workspace.
* [Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets, like the Azure Quantum workspace name.
* [Azure Storage](https://azure.microsoft.com/services/storage) provides storage for input data and results from the quantum provider. 

### Alternatives

The architecture presented here is for business problems that require quantum computing resources for their compute tasks. For some compute challenges, existing services built to perform [high-performance computing](https://azure.microsoft.com/solutions/high-performance-computing) or provide [AI functionality](https://azure.microsoft.com/overview/ai-platform) might be an alternative.

## Considerations

Some of the quantum targets (especially quantum hardware) will be a limited resource for the foreseeable future. Access to these resources is implemented via a queueing mechanism. This implementation leads to fluctuating job execution run times. To calculate the full response time, you need to add the time spent waiting for an available resource to the job execution time.

### Availability

Availability of the quantum compute functionality depends highly on the availability and install base of the [quantum computing provider](/azure/quantum/qc-target-list) and [optimization provider](/azure/quantum/qio-target-list). Depending on the compute target, the classical client application might experience long delays or unavailability of the target.

For the surrounding Azure services, the usual availability considerations apply:

* Use the [Key Vault](/azure/key-vault/general/disaster-recovery-guidance) redundancy options.
* If necessary, consider using the replication options in [Storage](/azure/storage/common/storage-redundancy).

### Performance and scalability

Application performance depends on the availability and performance of the underlying quantum computing targets. For information about the performance and scalability of the classical components, review the [typical design patterns for scalability](/azure/architecture/framework/scalability/performance-efficiency-patterns) and the [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency).

### Security

Unlike the architecture for the [loosely coupled alternative](loosely-coupled-quantum-computing-job.yml), the architecture presented here is based on the assumption that only one client accesses the Azure Quantum workspace. This scenario leads to the following configurations:

* Because the client is known, you can implement authentication via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview), associated to the application.
* You can implement throttling of requests and caching of results in the client itself.

In general, consider applying the [typical design patterns for security](/azure/architecture/framework/security/security-patterns) when appropriate.

### Resiliency

Keep in mind that quantum target environments are shared resources. Providers typically add submitted jobs to a queue. Jobs wait in the queue until previously submitted jobs finish.

Monitor job execution so you can inform the user about job status. When job execution fails because of a transient error, implement a [retry pattern](/azure/architecture/patterns/retry). Submit the jobs via asynchronous calls, with polling for the result, to avoid unnecessarily blocking the calling client.

### DevOps

For a description of a continuous integration and continuous delivery (CI/CD) approach for this architecture, see [CI/CD for quantum computing jobs](../../solution-ideas/articles/cicd-for-quantum-computing-jobs.yml).

## Pricing

The overall cost of this solution depends on the quantum computing target that you select to run the quantum job. Calculating estimated costs for the classic components is straightforward. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

For the Azure Quantum service, consider these points:

* [Microsoft QIO](/azure/quantum/provider-microsoft-qio) solvers are billed via the Azure subscription bill. The cost depends on the SKU and your usage pattern. For details, see [Azure Quantum pricing](https://azure.microsoft.com/pricing/details/azure-quantum).
* Other optimization providers are available on Azure Marketplace. For pricing details, see the applicable reference page listed in [Optimization providers on Azure Quantum](/azure/quantum/qio-target-list).
* Quantum computing providers can be consumed via an Azure Marketplace offering. Pricing depends on the type of resource (simulator or hardware), the SKU, and your usage. For details, see the reference page for the provider needed for your scenario. These reference pages are listed in [Quantum computing providers on Azure Quantum](/azure/quantum/qc-target-list).

## Next steps

* For an overview of Microsoft Quantum, a full-stack, open-cloud quantum computing ecosystem, see [Microsoft Quantum](https://azure.microsoft.com/solutions/quantum-computing) and complete the [Quantum computing foundations](/learn/paths/quantum-computing-fundamentals) learning path.
* For more information about the Azure Quantum service, see [Azure Quantum](https://azure.microsoft.com/services/quantum/).
* For general information about Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).
* For information about running algorithms on quantum hardware, see the Microsoft Learn course [Run algorithms on quantum hardware by using Azure Quantum](/learn/modules/run-algorithms-quantum-hardware-azure-quantum).

## Related resources

* [Operational excellence principles](../../framework/devops/principles.md)
* [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md)
* [Loosely coupled quantum computing](loosely-coupled-quantum-computing-job.yml)
