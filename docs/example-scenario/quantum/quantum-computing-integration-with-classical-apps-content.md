Classical computing is increasingly challenged with today's most complex compute problems - even at the scale of our most powerful supercomputers. Quantum computers hold the promise to dramatically extend our compute capabilities. By exploiting the properties of quantum physics to perform computations, they provide exponential speedups for certain types of problems. For example, quantum computers do exceptionally well with problems that require calculating a large number of possible combinations often found in optimization, simulation, or machine learning scenarios.

However, quantum computing components have a different operating model from that of classical software. There are typically one or more classical compute components that orchestrate the execution of quantum components. This orchestration includes the following activities:

* Preparation of input data
* Submission of quantum computing [jobs](/azure/quantum/how-to-work-with-jobs) to a target quantum environment
* Monitoring of job execution
* Post-processing of job results

You can integrate this orchestration with classical applications in one of two ways:

* **Integration via tight coupling.** Logic for the orchestration of quantum resources is integrated into the classical component or components.
* **Integration via loose coupling.** Logic for the orchestration of quantum resources is exposed as an API that can be called by various classical software components.

This article describes how to implement quantum applications in each of these designs. Each implementation utilizes Azure Quantum as the quantum computing engine but they differ slightly in other aspects as detailed below.

## Tightly coupled approach

### Potential use cases

The tightly coupled approach is preferred in these cases:

* One team owns both the quantum code and the classical code, and the code is integrated.
* Quantum components share the same lifecycle as the classical components.
* Use of the quantum components is limited to a single application or small set of related applications.
* The quantum job represents a specialized solution (for example, a molecular simulation) that will be used only by one specialized classical application.
* The implemented algorithm is hybrid quantum-classical by nature, for example, Variational Quantum Eigensolvers (VQE) and Quantum Approximate Optimization Algorithms (QAOA).

### Architecture

:::image type="content" alt-text="Architecture diagram that shows a hybrid app that contains a tightly coupled quantum computing job." source="media/tightly-coupled-quantum-computing-job-architecture.svg" lightbox="media/tightly-coupled-quantum-computing-job-architecture.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/tightly-coupled-quantum.pptx) of this architecture.*

### Dataflow

1. A signed-in user triggers quantum job execution via a classical client application.
1. The client application puts input data into Azure Storage.
1. The client application submits the job to an Azure Quantum workspace, specifying the execution target or targets. The client identifies the workspace via data that's stored in Key Vault and authenticates to the workspace via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview).
1. A quantum provider runs the job on a target environment.
1. The client application monitors job execution by polling job status.
1. As soon as the quantum job finishes, the client application gets the compute result from Storage.

This workflow implements the [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.yml) and the steps defined for the [Azure Quantum job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle).

### Components

* [Azure Quantum](https://azure.microsoft.com/services/quantum) provides a [workspace](/azure/quantum/how-to-create-workspace), accessible from the Azure portal, for assets associated with running quantum or optimization jobs on various targets. Jobs are run on quantum simulators, quantum hardware, or optimization solvers, depending on the provider you choose.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) coordinates user authentication and helps to protect access to the Azure Quantum workspace.
* [Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets, like the Azure Quantum workspace name.
* [Azure Storage](https://azure.microsoft.com/services/storage) provides storage for input data and results from the quantum provider.

### Availability

Availability of the quantum compute functionality depends highly on the availability and install base of the [quantum computing provider](/azure/quantum/qc-target-list) and [optimization provider](/azure/quantum/qio-target-list). Depending on the compute target, the classical client application might experience long delays or unavailability of the target.

For the surrounding Azure services, the usual availability considerations apply:

* Use the [Key Vault](/azure/key-vault/general/disaster-recovery-guidance) redundancy options.
* If necessary, consider using the replication options in [Storage](/azure/storage/common/storage-redundancy).

### Security

Unlike the architecture for the [loosely coupled alternative](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps), the architecture presented here is based on the assumption that only one client accesses the Azure Quantum workspace. This scenario leads to the following configurations:

* Because the client is known, you can implement authentication via [managed identity](/azure/active-directory/managed-identities-azure-resources/overview), associated to the application.
* You can implement throttling of requests and caching of results in the client itself.

In general, consider applying the [typical design patterns for security](/azure/architecture/framework/security/security-patterns) when appropriate.

## Loosely coupled approach

### Potential use cases

The loosely coupled approach is preferred in these cases:

* You have a dedicated team of quantum specialists who centrally provide quantum functionality to other teams and the quantum components are developed independently from any classical client components.
* The quantum job represents a generic solution (for example, job scheduling) that can be reused by multiple classical applications.

### Architecture

:::image type="content" alt-text="Architecture diagram that shows a hybrid app that contains a loosely coupled quantum computing job." source="media/loosely-coupled-quantum-computing-job-architecture.svg" lightbox="media/loosely-coupled-quantum-computing-job-architecture.svg":::

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

This workflow implements the [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.yml) and the steps defined for the [Azure Quantum job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle).

### Components

* [Azure Quantum](https://azure.microsoft.com/services/quantum) provides a [workspace](/azure/quantum/how-to-create-workspace), accessible from the Azure portal, for assets associated with running quantum or optimization jobs on various targets. Jobs are run on quantum simulators, quantum hardware, or optimization solvers, depending on the provider you choose.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) coordinates user authentication and helps to protect access to the Azure Quantum workspace.
* [API Management](https://azure.microsoft.com/services/api-management) is the API gateway that centrally exposes the API endpoints for quantum job management.
* [Azure Functions](https://azure.microsoft.com/services/functions) is used to forward the client requests to appropriate quantum resources.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets, like the Azure Quantum workspace name.
* [Azure Storage](https://azure.microsoft.com/services/storage) provides storage for input data and results from the quantum provider.

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

Unlike the architecture for the [tightly coupled alternative](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps), the architecture presented here is based on the assumption that multiple clients access the Azure Quantum workspace via the API. This scenario leads to the following configurations:

* Clients must authenticate to the API. You can implement this authentication by using [authentication policies](/azure/api-management/api-management-authentication-policies).
* You can implement authentication of the Azure functions via [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) associated with the functions. You can use these identities to authenticate to the Azure Quantum workspace.
* Multiple clients access the API. You can implement request throttling by using [API Management request throttling](/azure/api-management/api-management-sample-flexible-throttling) to protect the quantum back end and limit the use of quantum resources.
* Depending on the request pattern, you might be able to implement the caching of quantum computing results by using [API Management caching policies](/azure/api-management/api-management-caching-policies).

In general, consider applying the [typical design patterns for security](/azure/architecture/framework/security/security-patterns) when appropriate.

## Common features

The following features are common to both tightly coupled and loosely coupled implementation models

### Alternatives

The architectures presented here are for business problems that require quantum computing resources for their compute tasks. For some compute challenges, existing services built to perform [high-performance computing](https://azure.microsoft.com/solutions/high-performance-computing) or provide [AI functionality](https://azure.microsoft.com/overview/ai-platform) might be an alternative.

### Considerations

Some of the Azure quantum targets (especially quantum hardware) will be a limited resource for the foreseeable future. Access to these resources is implemented via a queueing mechanism. When you submit a quantum job to Azure Quantum, this job is added to a job queue. The job will be executed, once the target completes processing earlier queue entries. You can obtain the expected waiting time by [listing available targets](/azure/quantum/how-to-submit-jobs). To calculate the full response time, you need to add the time spent waiting for an available resource to the job execution time.

### Performance and scalability

Application performance depends on the availability and performance of the underlying quantum computing targets. For information about the performance and scalability of the classical components, review the [typical design patterns for scalability](/azure/architecture/framework/scalability/performance-efficiency-patterns) and the [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency).

### Resiliency

As quantum target environments like Azure Quantum typically provide limited error-correction (limited to the quantum processor in the case of Azure Quantum), other errors such as quantum machine timeout may still occur so it is recommended to monitor job execution so you can inform the user about job status. When job execution fails because of a transient error, implement a [retry pattern](/azure/architecture/patterns/retry). Submit the jobs via asynchronous calls, with polling for the result, to avoid unnecessarily blocking the calling client.

As quantum computing resources are typically limited, resiliency expectations should consider this factor.  As such, the suggestions offered in this article may provide additional measures of resiliency.

### DevOps

Incorporating quantum jobs into classical CI/CD pipelines can be accomplished using Azure DevOps with minor changes to a typical design. The design below illustrates a DevOps pipeline workflow that can be applied to the tightly coupled and loosely coupled architectures.

In-depth guidance for DevOps and quantum computing can be found at [DevOps for quantum computing](/azure/architecture/guide/quantum/devops-for-quantum-computing)

#### Architecture

:::image type="content" alt-text="Architecture diagram that shows a classical CI/CD pipeline with Azure Quantum incorporated into it." source=media/cicd-for-quantum-computing-jobs.svg" lightbox="media/cicd-for-quantum-computing-jobs.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/cicd-quantum.pptx) of this architecture.*

#### Dataflow

1. The developer changes the source code of the application components.
1. Changes are committed to the source code repository.
1. Changes to quantum code trigger the quantum build pipeline. The build pipeline checks out the code, compiles it, estimates required resources, and runs the algorithm on a simulator.
1. The compiled quantum algorithm is submitted to a quantum environment for testing.
1. Changes trigger a build pipeline for the classical components. The pipeline checks out the code, compiles it, and runs unit and integration tests.
1. Successful compilation and tests trigger a release pipeline. The pipeline first provisions the Azure environment by deploying the Azure Resource Manager templates that are stored in the repository (Infrastructure as Code).
1. Compiled classical application artifacts are deployed to Azure. The quantum jobs are submitted to a quantum workspace during runtime.
1. Application Insights monitors runtime behavior, health, performance, and usage information.
1. Backlog items are updated as needed, depending on monitoring results.
1. The developer uses Application Insights for application feedback and optimization.

#### Components

This solution uses the following DevOps tools:

* [Azure Repos](https://azure.microsoft.com/services/devops/repos) provides unlimited, cloud-hosted private Git repos. It's used here to store the quantum and classical code and the Azure Resource Manager templates that are used to provision the environment.
* [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) enables you to continuously build, test, and deploy to the cloud. Here, it's used to implement CI/CD, including the environment provisioning before code deployment.

As an alternative, you can use GitHub repositories and GitHub actions to implement the CI/CD processes.

The solution uses the following other components:

* A client application orchestrates the quantum job. You can implement integration by using a [tightly coupled](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps) or a [loosely coupled](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps) approach.
* [Azure Quantum](https://azure.microsoft.com/services/quantum) provides a [workspace](/azure/quantum/how-to-create-workspace) for assets that are associated with running quantum computing applications. Jobs are run on quantum simulators, quantum hardware, or optimization solvers, depending on the provider that you choose.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) coordinates user authentication and protects access to the Azure Quantum workspace.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets, like the quantum workspace name.
* [Azure Storage](https://azure.microsoft.com/services/storage) holds the input and output data of the quantum job.
* [Application Insights](/azure/azure-monitor/app/app-insights-overview) monitors the application, detects application anomalies like poor performance and failures, and sends telemetry to the Azure portal.

### Cost optimization

The overall cost of this solution depends on the quantum computing target that you select to run the quantum job. Calculating estimated costs for the classic components is straightforward. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

For the Azure Quantum service, consider these points:

* [Microsoft QIO](/azure/quantum/provider-microsoft-qio) solvers are billed via the Azure subscription bill. The cost depends on the SKU and your usage pattern. For details, see [Azure Quantum pricing](https://azure.microsoft.com/pricing/details/azure-quantum).
* Other optimization providers are available on Azure Marketplace. For pricing details, see the applicable reference page listed in [Optimization providers on Azure Quantum](/azure/quantum/qio-target-list).
* Quantum computing providers can be consumed via an Azure Marketplace offering. Pricing depends on the type of resource (simulator or hardware), the SKU, and your usage. For details, see the reference page for the provider needed for your scenario. These reference pages are listed in [Quantum computing providers on Azure Quantum](/azure/quantum/qc-target-list).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.* 

Principal author: 

 - [Holger Sirtl](https://www.linkedin.com/in/hsirtl) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.* 

## Next steps

* For an overview of Microsoft Quantum, a full-stack, open-cloud quantum computing ecosystem, see [Microsoft Quantum](https://azure.microsoft.com/solutions/quantum-computing) and complete the [Quantum computing foundations](/learn/paths/quantum-computing-fundamentals) learning path.
* For more information about the Azure Quantum service, see [Azure Quantum](https://azure.microsoft.com/services/quantum/).
* For general information about Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).
* For information about running algorithms on quantum hardware, see the module [Run algorithms on quantum hardware by using Azure Quantum](/learn/modules/run-algorithms-quantum-hardware-azure-quantum).

## Related resources

* [Operational excellence principles](/azure/architecture/framework/devops/principles)
* [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.yml)
* [Loosely coupled quantum computing](/azure/architecture/example-scenario/quantum/quantum-computing-integration-with-classical-apps)
