Some computational problems are impractical or intractable to solve on classical computers, even on large supercomputers. For some of these problems, a quantum algorithm can reach a solution using far fewer resources than the best known classical approach. A quantum computer uses quantum-mechanical effects, such as superposition and entanglement, to represent and process information in ways that a classical computer can't.

Quantum programs run on [quantum providers](/azure/quantum/qc-target-list) that you reach by submitting jobs. Quantum targets expose different [target profiles](/azure/quantum/quantum-computing-target-profiles). Some profiles allow only quantum operations, and the classical logic you can run on them is limited. Other profiles allow both quantum and classical operations to run together on the provider.

Regardless of the target profile, classical compute components handle the surrounding application integration. Even when a quantum target accepts classical operations, you reach the target by submitting a job and waiting for the results. This article describes and compares two orchestration models for integrating quantum work with classical applications.

In practice, running a quantum program is a service call. Your classical application or client code submits a job to a target, waits for it to run, and retrieves the results. One or more classical compute components orchestrate each quantum job by doing the following activities:

* Preparing input data
* Submitting quantum computing [jobs](/azure/quantum/how-to-work-with-jobs) to a target quantum environment
* Monitoring job execution
* Postprocessing job results

## Quantum integration models

You integrate quantum work with a classical application by using one of two orchestration patterns:

* [Direct quantum integration](#direct-quantum-integration). A client application or lightweight classical harness interacts directly with the Azure Quantum workspace. The client owns input preparation, job submission, monitoring, result handling, and the classical logic that surrounds the quantum execution.

* [Workflow-orchestrated quantum integration](#workflow-orchestrated-quantum-integration). A workflow orchestrator owns the overall state and transitions. Quantum execution occurs in workflow steps that run alongside steps running on high-performance computing (HPC) or graphics processing unit (GPU) compute.

For a given application integration boundary, these patterns are alternatives. Either the client integrates directly with the workspace, or a broader workflow owns the quantum step. This article describes the implementation of each pattern.

> [!NOTE]
> The architectures in this article run part of a compute task on a quantum target. For some compute challenges, existing services built to perform [high-performance computing](https://azure.microsoft.com/solutions/high-performance-computing) or provide [AI functionality](https://azure.microsoft.com/solutions/ai/) might be alternatives.

The integration choice is independent of where the classical computation runs. Depending on the target profile and workload, classical logic can run within the quantum program, in the client harness between quantum executions, in the workflow orchestrator, or in a classical workflow step on HPC or GPU compute.

### Decision matrix

Use the following decision matrix to guide your choice of integration patterns:

| If your workload has these characteristics | Use this approach |
| :---- | :---- |
| One application or lightweight harness owns the full quantum job lifecycle, and the input preparation and result processing fit inside that client. | [Direct quantum integration](#direct-quantum-integration) |
| You explore the properties of quantum hardware with handwritten quantum code, and one application or a small set of related applications consumes the results. | [Direct quantum integration](#direct-quantum-integration) |
| The classical side is heavyweight and consumes quantum as one step among many, in a multistage pipeline whose stages each run on the back end that fits them, such as HPC, GPU, or a quantum target. | [Workflow-orchestrated quantum integration](#workflow-orchestrated-quantum-integration) |
| Quantum executions repeat, and the result of one execution generates the next quantum program or determines its parameters. | [Workflow-orchestrated quantum integration](#workflow-orchestrated-quantum-integration) |

### Scenario details

Both workflows implement the [Asynchronous Request-Reply pattern](../../patterns/asynchronous-request-reply.md) and the steps defined for the [Azure Quantum job lifecycle](/azure/quantum/how-to-work-with-jobs#job-lifecycle).

Quantum targets, especially quantum hardware, are limited resources. Azure Quantum allocates these resources through a job queue. When you submit a job, the job enters the queue for the target that you select and runs after that target finishes the earlier entries. To see the expected wait time, [list the available targets](/azure/quantum/how-to-submit-jobs). Calculate your full response time as the queue wait plus the job execution time.

The capabilities of a quantum target also vary. Some targets accept quantum operations only, while others run classical logic with quantum operations in a single job. This model supports algorithms that adapt during execution. Before you commit to a target, confirm that it supports the operations that your algorithm needs. For more information about how classical and quantum instructions run together, see [Introduction to hybrid quantum computing](/azure/quantum/hybrid-computing-overview).

> [!NOTE]
> These patterns describe how you integrate quantum work into your application architecture. They're distinct from Azure Quantum *hybrid computing models*, which describe how classical and quantum computation interact within quantum jobs. Target profiles constrain what can run within these jobs. For more information, see [Introduction to hybrid quantum computing](/azure/quantum/hybrid-computing-overview). Application integration patterns are independent of within-job behavior and control whether a client or a workflow runs the quantum jobs.

## Direct quantum integration

The following sections describe the direct integration model for integrating quantum work with a classical application.

### Architecture

:::image type="complex" alt-text="Architecture diagram showing direct quantum integration, where a classical client submits a job to an Azure Quantum workspace." source="media/direct-quantum-integration.svg" lightbox="media/direct-quantum-integration.svg" border="false":::
  The diagram shows the workflow for direct quantum integration. At upper left, a User icon connects to a Microsoft Entra ID icon with a dashed line labeled Sign-in. An arrow labeled 1 goes from the user to a box labeled Front end that contains a Client app icon. The Front end box connects to the Microsoft Entra ID icon with a dashed line labeled Authentication. An arrow labeled 2 goes from the Front end box to a box labeled Storage that contains a Storage account icon. An arrow labeled 3 goes from the Front end box to a box labeled Azure Quantum workspace that contains a Provider icon. A line labeled 4 with bidirectional arrows goes between the Provider icon and a box labeled Quantum provider service that contains two Target icons. An arrow labeled 5 goes from the Front end box to the Azure Quantum workspace box. A dashed line with bidirectional arrows connects the Azure Quantum workspace box and the Storage box. An arrow labeled 6 goes from the Storage box back to the Front end box.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/quantum-hybrid-computing-diagrams.pptx) of this architecture.*

#### Data flow

The following data flow corresponds to the preceding diagram:

1. A signed-in user triggers quantum job execution via a classical client application.
1. The client application inputs data into Azure Storage.
1. The client application submits the job to an Azure Quantum workspace, specifying the execution target or targets.

   The client identifies the workspace from its configuration and authenticates to the workspace by using a Microsoft Entra identity. A client that runs on an Azure-hosted resource can use a [managed identity](/entra/identity/managed-identities-azure-resources/overview). A local client application authenticates with another Microsoft Entra identity, like a service principal or an interactive user sign-in.

1. A quantum provider runs the job on a target environment.
1. The client application monitors job execution by polling job status.
1. As soon as the quantum job finishes, the client application gets the compute result from Storage.

#### Components

* [Azure Quantum](/azure/quantum/overview-azure-quantum) provides a [workspace](/azure/quantum/how-to-create-workspace), accessible from the Azure portal, for assets associated with running quantum jobs on various targets. Jobs run on quantum simulators or quantum hardware, depending on the provider you choose.
* [Microsoft Entra ID](/entra/fundamentals/what-is-entra) coordinates user authentication and helps protect access to the Azure Quantum workspace.
* [Storage](/azure/storage/common/storage-introduction) provides storage for input data and results from the quantum provider.

### Direct integration potential use cases

The direct quantum integration pattern fits the following use cases:

* One client application or lightweight classical harness owns the complete quantum job lifecycle without a broader workflow.
* The client can run surrounding classical work, such as input preparation and result processing.
* You explore the properties of quantum hardware, so you typically handwrite the quantum code rather than generate it dynamically.
* Use of the quantum components is limited to a single application or a small set of related applications.
* The quantum job represents a specialized solution, such as a molecular simulation, that only one specialized classical application uses.

## Workflow-orchestrated quantum integration

The following sections describe the workflow-orchestrated model for integrating quantum work with a classical application.

### Architecture

The workflow logic doesn't depend on any specific host or provider. The following flowchart shows the state machine: a single input, a loop over the steps, and the per-step phases. The quantum branch can include an optional program generation and optimization phase that classical steps don't use.

:::image type="complex" alt-text="Flowchart of a workflow-orchestrated quantum integration state machine that shows a loop over steps, showing input preparation, a back-end selector, execution, and output processing." source="media/workflow-orchestrated-quantum-integration-workflow.svg" lightbox="media/workflow-orchestrated-quantum-integration-workflow.svg" border="false":::
  The flowchart shows the data flow for workflow-orchestrated quantum integration. An Input item flows to an Advance to next step item, which flows to a box labeled Step that contains the following steps: An Input preparation task leads to a Back end selector decision point, which either points up to an area labeled quantum or down to an area labeled classical. The quantum section contains a process labeled Quantum program generation and optimization (optional) followed by a process labeled Execution on quantum back end. The classical section contains a process labeled Execution on classical back end (HPC, GPU, local, or other). Both of the paths then lead to a process labeled Output processing. The flow then exits the Step box and points to a decision point labeled More steps? The path labeled yes points back to the Advance to the next step item. The path labeled no leads to a terminator labeled Final output.
:::image-end:::

The back-end selector in the preceding flowchart is a logical phase rather than a required component, and can be a configuration lookup that routes each step to a fixed back-end type.

You can host this workflow on Azure with a set of classical services that submit and monitor the quantum work. The following diagram shows an example topology:

:::image type="complex" alt-text="Architecture diagram that shows a workflow-orchestrated quantum integration topology on Azure." source="media/workflow-orchestrated-quantum-integration.svg" lightbox="media/workflow-orchestrated-quantum-integration.svg" border="false":::
  At upper left, a Client app box connects to a Microsoft Entra ID icon with a dashed line labeled Sign-in. An arrow labeled Authenticated request and 1 goes from the Client app box to a box labeled API Management. The API Management box connects to the Microsoft Entra ID icon with a dashed line. An arrow labeled 2 goes from the API Management box to an icon labeled Input API that's inside a box labeled Function apps. An arrow labeled 3 goes from an icon labeled Workflow orchestrator (Durable Functions) inside the Function app box to a box labeled Classical compute back ends, which contains boxes labeled Local compute, HPC cluster (Azure Batch), and GPU compute. An arrow labeled 4 goes from the Classical compute back ends box to a box labeled Results and state that contains an Azure Storage icon. An arrow labeled 5 goes from the Workflow orchestrator icon in the Function apps box to a box labeled Azure Quantum workspace that contains an Azure Quantum icon. An arrow labeled 6 goes from the Azure Quantum workspace box to a box labeled Quantum target that contains two icons labeled Targets. An arrow labeled 7 goes from the Quantum target box to the Results and state box. An arrow labeled 8 goes from the Results and state box back to the Function apps box. An arrow labeled 9 goes from the API Management box at left to an icon labeled Status API in the Function apps box.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/quantum-hybrid-computing-diagrams.pptx) of this architecture.*

#### Data flow

The following data flow corresponds to the deployment topology:

1. A client application submits a request through API Management, which authenticates the caller with Microsoft Entra ID and applies throttling before the request reaches the compute tier.
1. API Management forwards the request to the Input API, an HTTP-triggered function that validates it and starts the workflow orchestrator.
1. For a step that runs classically, the orchestrator routes the execution to a classical back end, such as an HPC cluster or GPU compute.
1. The classical back end writes its results and the updated pipeline state to Storage.
1. For a step that runs on quantum, the orchestrator routes the execution through the quantum path. The quantum path prepares the step's program, generating and optimizing it from the step's input or using a fixed implementation, and submits the job to the Azure Quantum workspace. The submission authenticates via [managed identity](/entra/identity/managed-identities-azure-resources/overview).
1. The workspace runs the job on the selected quantum target.
1. The quantum target writes its results to Storage.
1. The orchestrator reads the updated state Storage and evaluates the pipeline's transition logic. If a convergence or iteration condition requires another quantum execution, the orchestrator uses the result to determine parameters for the next quantum program or to provide inputs that generate the next program. The pipeline then loops back to the appropriate step.
1. The client polls the Status API through API Management to track progress and retrieve the final results when the pipeline reaches a terminal state.

#### Components

* [Durable Functions](/azure/durable-task/durable-functions/durable-functions-overview) acts as the workflow orchestrator to run the pipeline as a state machine, coordinate the steps, and select the quantum or other compute type back end for each step's execution. You can implement the orchestrator with Durable Functions or another workflow engine.
* [Azure HPC and GPU classical compute back ends](../../guide/compute/high-performance-computing.md) run the non-quantum steps.
* [Azure Functions](/azure/azure-functions/functions-overview) hosts the HTTP APIs that start and monitor the workflow, along with the orchestrator that runs it.
* [API Management](/azure/api-management/api-management-key-concepts) is the entry point for client requests. It authenticates callers and applies throttling. To prevent the function app from being called directly, use [Azure Functions networking options](/azure/azure-functions/functions-networking-options), such as inbound access restrictions or a private endpoint, so that it accepts traffic only from API Management.
* [Azure Quantum](/azure/quantum/overview-azure-quantum) provides a [workspace](/azure/quantum/how-to-create-workspace) for assets associated with running quantum jobs. Jobs run on quantum simulators or quantum hardware, depending on the target you choose.
* [Microsoft Entra ID](/entra/fundamentals/what-is-entra) coordinates authentication and helps protect access to the Azure Quantum workspace.
* [Storage](/azure/storage/common/storage-introduction) stores input data, intermediate pipeline state, and results.

#### Alternatives

The architectures in this article run part of a compute task on a quantum target. For some compute challenges, existing services built to perform [high-performance computing](https://azure.microsoft.com/solutions/high-performance-computing) or provide [AI functionality](https://azure.microsoft.com/solutions/ai/) might be alternatives.

For scientific R&D workloads, [Microsoft Discovery](/azure/microsoft-discovery/overview-what-is-microsoft-discovery) uses AI to orchestrate complex tasks across models, tools, and compute resources. Microsoft Discovery can coordinate various tools across multistep pipelines and is extensible, so you can connect your own tools and agents instead of building and operating the orchestration yourself. Integration with quantum capabilities, including running quantum steps, could use AI to take on the orchestration that this pattern builds by hand.

### Workflow-orchestrated scenario details

In this pattern, a workflow orchestrator runs the workload as a pipeline of steps. The orchestrator behaves like a state machine in which steps repeat and loop until a termination or convergence condition is met. Each step follows the same shape: It prepares its input, executes, and processes the output.

The orchestrator selects the back end that runs each step. This selection is part of orchestration logic, not a separate service, and can be as simple as reading the target back end for each step from configuration. A step runs on a quantum back end or on classical compute, such as an HPC cluster or GPU compute. A lightweight classical step can run in the orchestrator itself. When quantum steps repeat, the workflow processes the result of one quantum execution to determine parameters for the next quantum program or to provide inputs that generate the next program.

A step that runs on a quantum back end can add one phase that classical steps don't have. That phase generates and optimizes the quantum program before execution. This phase is optional. The program can generate dynamically from the step's input, or it can come from a fixed implementation that skips this phase. A step that's eligible for quantum might still run on a classical back end when that fits the input better.

Quantum chemistry is a representative example. A typical pipeline uses classical steps to prepare a molecular system: Geometry optimization, a self-consistent field calculation, and active-space selection. The pipeline then computes a target property, such as the ground-state energy of a molecule. The energy-computing step keeps the same intent whether it runs on a classical approximation or on a quantum algorithm. You choose the back end based on the accuracy you need and the size of the problem.

The [QDK/Chemistry](https://microsoft.github.io/qdk-chemistry/user/quickstart.html) library supports pipelines like these. The library provides modular components for the classical preparation steps and for generating a state-preparation circuit from the classically computed wavefunction, which a quantum back end then uses to estimate the energy with an algorithm such as quantum phase estimation. This circuit-generation capability is a concrete example of producing the quantum program dynamically from a step's input.

#### Potential use cases

The workflow-orchestrated quantum integration pattern fits these use cases:

* The classical side is heavyweight and problem-state-logic oriented, and it consumes the quantum capability as one step or several steps among many.
* The workload is a multistage pipeline that is often iterative, like a state machine. Each stage runs on the compute back end that best fits it: HPC, GPU, or a quantum target. Quantum computing is one option for one or more stages.
* A quantum step represents a well-defined building block, such as a scientific calculation that computes a molecular property. The precise quantum code might even be generated and optimized dynamically to fit the actual inputs.
* The workflow orchestrator owns multiple self-contained quantum executions and the classical processing between them. The result of one execution determines parameters for the next quantum program or provides inputs that generate the next program. [Iterative phase estimation](/azure/quantum/hybrid-computing-concepts#hybrid-algorithms) fits this structure, as do variational algorithms such as the Variational Quantum Eigensolver (VQE) and the Quantum Approximate Optimization Algorithm (QAOA).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Quantum jobs run on remote, shared targets, so job execution can fail from transient errors, such as a target timeout. Regardless of the integration pattern you choose, monitor job execution so that you can surface job status to the user. When a job fails because of a transient error, apply the [Retry pattern](/azure/architecture/patterns/retry). Submit jobs through asynchronous calls and poll for the result so that you don't block the calling client.

Availability of the quantum compute functionality depends highly on the availability and capacity characteristics of the [quantum computing provider](/azure/quantum/qc-target-list). Depending on the compute target, the classical client application might experience long delays or unavailability of the target.

For the surrounding Azure services, the usual availability considerations apply. If necessary, consider using the replication options in [Azure Storage redundancy](/azure/storage/common/storage-redundancy).

#### Reliability for workflow-orchestrated integration

* For high availability in workflow-orchestrated integration, deploy API Management across [availability zones](/azure/api-management/enable-availability-zone-support) or [multiple regions](/azure/api-management/api-management-howto-deploy-multi-region). Zone redundancy requires the Premium or Premium v2 tier, and multiregion deployment requires the Premium tier.

* If you implement the orchestrator with Durable Functions, plan its disaster recovery as a unit rather than treating the function app and its state as independent services. Durable functions persist all orchestration state in a task hub in a storage back end, which is Azure Storage by default. Because the runtime state and the compute are coupled through that task hub, provisioning the function app in a second region and replicating Storage separately doesn't define a safe failover. Orchestrations can pause, lose recent transactions, or read a cross-region task hub, depending on the topology.

  For a safe failover, use an active-passive configuration that fails over to a secondary region, fronted by a global load-balancing service such as [Azure Front Door](/azure/frontdoor/front-door-overview) or [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview). Confirm that the service health probes can reach the function app under your networking restrictions, because the same controls that limit the app to API Management traffic can also block those probes. Choose the topology that matches your tolerance for data loss and cross-region latency. For the coordinated options and their tradeoffs, see [Disaster recovery and geo-distribution in Durable Functions](/azure/durable-task/durable-functions/durable-functions-disaster-recovery-geo-distribution).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Apply the following hardening practices to the classical services that surround the quantum job, regardless of the integration pattern you choose:

* Authenticate to Azure Quantum and the surrounding services by using Microsoft Entra identities, and turn off local authentication where the service supports it. Use [managed identities](/entra/identity/managed-identities-azure-resources/overview) wherever the hosting environment supports them. For a client that can't use a managed identity, authenticate with another Microsoft Entra identity, such as a service principal or an interactive user sign-in.

* Grant each component that accesses Storage the data-plane access it needs through [Azure role-based access control (Azure RBAC) with Microsoft Entra ID](/azure/storage/blobs/authorize-access-azure-active-directory), scoped to that component. Don't embed storage account keys in application code.

In general, apply the [Well-Architected Framework security recommendations](/azure/well-architected/security/checklist) when appropriate.

#### Security for direct quantum integration

Unlike workflow-orchestrated quantum integration, this pattern assumes that a single client accesses the Azure Quantum workspace. The client is typically a lightweight classical harness that focuses on job submission and operation rather than broader workflow state. This scenario leads to the following configurations:

* Because the client is known, you can give it a fixed identity. When the client runs on an Azure-hosted resource, associate a [managed identity](/entra/identity/managed-identities-azure-resources/overview) with it. When the client runs outside Azure, use a service principal or an interactive user sign-in.

* You can implement request throttling and result caching in the client itself.

#### Security for workflow-orchestrated integration

Unlike direct quantum integration, this pattern puts a classical service tier in front of the quantum work. API Management is the front door for that tier, so the security configurations emphasize protecting the entry point and the path to the quantum workspace.

* Clients must authenticate to the API. Implement this authentication by using [authentication policies](/azure/api-management/api-management-policies#authentication-policies).

* You can implement authentication of the Azure functions via [managed identities](/entra/identity/managed-identities-azure-resources/overview) associated with the functions. You use those identities to authenticate outbound calls to the Azure Quantum workspace.

* API Management can apply request throttling to protect the quantum back end and limit the use of quantum resources. For more information, see [API Management request throttling](/azure/api-management/api-management-sample-flexible-throttling).

* Depending on the request pattern, you might be able to implement the caching of quantum computing results by using [API Management caching policies](/azure/api-management/api-management-policies#caching-policies).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The overall cost of this solution depends on the quantum computing target that you select to run the quantum job. The classical components are straightforward to estimate. For a representative deployment of the workflow-orchestrated pattern, see this [example cost estimate](https://azure.com/e/8bd79f99f4d242eabdeefce55b59d816), which covers the classical components, including API Management, Azure Functions, and Storage. The direct integration pattern is lighter, but its classical costs still include Storage and any hosting, networking, and monitoring that the client application uses.

You can consume quantum computing providers for Azure Quantum via a [Microsoft Marketplace](https://marketplace.microsoft.com/marketplace/apps?search=quantum) offering. Pricing depends on the type of resource (simulator or hardware), the SKU, and your usage. For more information, access the reference page for your scenario's provider from [Quantum computing providers on Azure Quantum](/azure/quantum/qc-target-list).

## Contributors

*Microsoft maintains this article. The following contributor wrote this article.*

Principal author: 

 - [Zander Chocron](https://www.linkedin.com/in/zander-chocron-b54a8717a) | Principal Software Engineer, Microsoft Quantum
 
*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* For an overview of the Microsoft quantum computing ecosystem, see the [Microsoft Quantum](https://quantum.microsoft.com/) website and complete the [Quantum computing foundations](/training/paths/quantum-computing-fundamentals/) learning path.
* For more information about the Azure Quantum service, see [What is Azure Quantum?](/azure/quantum/overview-azure-quantum).
* For general information about Azure Quantum job management, see [Work with Azure Quantum jobs](/azure/quantum/how-to-work-with-jobs).
* For information about combining classical and quantum instructions in a job, see [Introduction to hybrid quantum computing](/azure/quantum/hybrid-computing-overview).

## Related resources

* [Operational Excellence design principles](/azure/well-architected/operational-excellence/principles)
* [Asynchronous Request-Reply pattern](../../patterns/asynchronous-request-reply.md)
