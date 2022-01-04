Quantum computing applies the unique behavior of quantum physics to computing. This approach provides dramatically faster compute than classical computing, especially in areas like optimization, simulation, and machine learning. However, quantum computing components have a different operating model from that of classical software. There are typically one or more classical compute components that orchestrate the running of quantum components. This orchestration includes the following activities:

* Preparation of input data
* Submission of quantum computing [jobs](/azure/quantum/how-to-work-with-jobs) to a target quantum environment
* Monitoring of job execution
* Post-processing of job results

You can integrate this orchestration with classical applications in one of two ways:

* **Integration via loose coupling.** Logic for the orchestration is exposed as an API that can be called by various classical software components. Use this approach in the following scenarios:
  * Quantum components are developed independently of any classical client application.
  * Quantum components will be reused by various applications.

* **Integration via tight coupling.** Logic for the orchestration is integrated into the classical component. For more information about this integration approach, see [Tightly coupled quantum computing](tightly-coupled-quantum-computing-job.yml). Use this approach in following scenarios:
  * Quantum components are developed by the team that develops the classical components.
  * Quantum components share the same lifecycle as the classical components.
  * Use of the quantum components is limited to a single application.

This article describes how to implement quantum applications that use the loosely coupled model. The architecture described here uses Azure Quantum, Azure API Management, and Azure Functions.

## Potential use cases

Use this architecture when quantum computing jobs must be run as part of a classical application. 

The loosely coupled approach is preferred in these cases:

* You have a dedicated team of quantum specialists who centrally provide quantum functionality to other teams.
* The quantum job represents a generic solution (for example, job scheduling) that's required in multiple applications.

## Architecture

:::image type="content" border="false" source="media/loosely-coupled-quantum-computing-job-architecture.png" alt-text="Architecture diagram that shows a hybrid app that contains a loosely coupled quantum computing job.":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/loosely-coupled-quantum.pptx) of this architecture.*
### Dataflow 
1. A signed-in user triggers quantum job execution via a classical application.
1. The classical application calls the custom job API to submit the job.
1. The API gateway triggers the job submission Azure function, which passes job input data.
1. The function puts the input data into Azure Storage.
1. The function submits the job to an Azure Quantum workspace, specifying the execution target or targets. The function identifies the workspace via data stored in Azure Key Vault and authenticates to the workspace via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview).
1. A quantum provider runs the job on a target environment.
1. The client application monitors job execution by polling job status via API calls.
1. The API gateway monitors job execution by polling job status from the quantum provider.
1. When the job finishes, the compute results are stored in Azure Storage. The client application gets the results by using an API that's implemented via the Azure function.

This workflow implements the [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md) and the steps defined for the [Azure Quantum job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle).

### Components

* [Azure Quantum](https://azure.microsoft.com/services/quantum) provides a [workspace](/azure/quantum/how-to-create-workspace), accessible from the Azure portal, for assets associated with running quantum or optimization jobs on various targets. Jobs are run on quantum simulators, quantum hardware, or optimization solvers, depending on the provider you choose.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) coordinates user authentication and helps to protect access to the Azure Quantum workspace.
* [API Management](https://azure.microsoft.com/services/api-management) is the API gateway that centrally exposes the API endpoints for quantum job management.
* [Azure Functions](https://azure.microsoft.com/services/functions) is used to forward the client requests to appropriate quantum resources.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets, like the Azure Quantum workspace name.
* [Azure Storage](https://azure.microsoft.com/services/storage) provides storage for input data and results from the quantum provider. 

### Alternatives

The architecture presented here is for business problems that require quantum computing resources for their compute tasks. For some compute challenges, existing services built to perform [high-performance computing](https://azure.microsoft.com/solutions/high-performance-computing) or provide [AI functionality](https://azure.microsoft.com/overview/ai-platform) might be an alternative.

## Considerations

Some of the quantum targets (especially quantum hardware) will be a limited resource for the foreseeable future. Access to these resources is implemented via a queueing mechanism. This pattern leads to fluctuating job execution run times. To calculate the full response time, you need to add the time spent waiting for an available resource to the job execution time.

### Availability

Availability of the quantum compute functionality is highly dependent on the availability and install base of the [quantum computing provider](/azure/quantum/qc-target-list) and [optimization provider](/azure/quantum/qio-target-list). Depending on the compute target, the classical client application might experience long delays or unavailability of the target.

For the surrounding Azure services, the usual availability considerations apply:

* For high-availability, you can deploy [API Management](/azure/api-management/api-management-howto-deploy-multi-region) to multiple zones or regions.
* If you use geo-replication, you can provision [Azure Functions](/azure/azure-functions/functions-geo-disaster-recovery) in multiple regions.
* Use the [Key Vault](/azure/key-vault/general/disaster-recovery-guidance) redundancy options.
* If necessary, consider using the replication options in [Storage](/azure/storage/common/storage-redundancy).

### Performance and scalability

Application performance depends on the availability and performance of the underlying quantum computing targets. For information about the performance and scalability of the classical components, review the [typical design patterns for scalability](/azure/architecture/framework/scalability/performance-efficiency-patterns) and the [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency).

### Security

Unlike the architecture for the [tightly coupled alternative](tightly-coupled-quantum-computing-job.yml), the architecture presented here is based on the assumption that multiple clients access the Azure Quantum workspace via the API. This scenario leads to the following configurations:

* Clients must authenticate to the API. You can implement this authentication by using [authentication policies](/azure/api-management/api-management-authentication-policies).
* You can implement authentication of the Azure functions via [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) associated with the functions. You can use these identities to authenticate to the Azure Quantum workspace.
* Multiple clients access the API. You can implement request throttling by using [API Management request throttling](/azure/api-management/api-management-sample-flexible-throttling) to protect the quantum back end and limit the use of quantum resources.
* Depending on the request pattern, you might be able to implement the caching of quantum computing results by using [API Management caching policies](/azure/api-management/api-management-caching-policies).

In general, consider applying the [typical design patterns for security](/azure/architecture/framework/security/security-patterns) when appropriate.

### Resiliency

Keep in mind that quantum target environments are shared resources. Providers typically add submitted jobs to a queue. Jobs wait in the queue until previously submitted jobs finish. 

Monitor job execution so you can inform the user about job status. When job execution fails because of a transient error, implement a [retry pattern](/azure/architecture/patterns/retry). Submit the jobs via asynchronous calls, with polling for the result, to avoid unnecessary blocking of the calling client.

### DevOps

For a description of a continuous integration and continuous delivery (CI/CD) approach for this architecture, see [CI/CD for quantum computing jobs](../../solution-ideas/articles/cicd-for-quantum-computing-jobs.yml).

## Pricing

The overall cost of this solution depends on the quantum computing target that you select to run the quantum job. Calculating estimated costs for the classical components is straightforward. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

For the Azure Quantum service, consider these points:

* [Microsoft QIO](/azure/quantum/provider-microsoft-qio) solvers are billed via the Azure subscription bill. The cost depends on the SKU and your usage pattern. For details, see [Azure Quantum pricing](https://azure.microsoft.com/pricing/details/azure-quantum).
* Other optimization providers are available on Azure Marketplace. For pricing details, see the appropriate reference page listed in [Optimization providers on Azure Quantum](/azure/quantum/qio-target-list).
* Quantum computing providers can be consumed via an Azure Marketplace offering. Pricing depends on the type of resource (simulator or hardware), the SKU, and your usage. For details, see the reference page for the quantum computing provider needed for your scenario. These reference pages are listed in [Quantum computing providers on Azure Quantum](/azure/quantum/qc-target-list).

## Next steps

* To get an overview of Microsoft Quantum, a full-stack, open-cloud quantum computing ecosystem, see [Microsoft Quantum](https://azure.microsoft.com/solutions/quantum-computing) and complete the [Quantum computing foundations](/learn/paths/quantum-computing-fundamentals) learning path.
* For more information about the Azure Quantum service, see [Azure Quantum](https://azure.microsoft.com/services/quantum).
* For general information about Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).
* For information about running algorithms on quantum hardware, see the Microsoft Learn course [Run algorithms on quantum hardware by using Azure Quantum](/learn/modules/run-algorithms-quantum-hardware-azure-quantum).

## Related resources

* [Operational excellence principles](../../framework/devops/principles.md)
* [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md)
* [Tightly coupled quantum computing](tightly-coupled-quantum-computing-job.yml)
