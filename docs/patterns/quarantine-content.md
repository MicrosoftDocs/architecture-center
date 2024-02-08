
Consume software artifacts in your supply chain only when it's verified and marked as safe-for-use, by well-defined processes. This pattern is an operational sidecar, to the development process, which is invoked to block the use of third-party software that could potentially introduce security vulnerabilities in your deployment.


## Context and problem

Cloud solutions often rely on third-party software that's obtained from external sources. Open source binaries, public container images, vendor OS images are some examples of these types of artifacts. All such external artifacts must be treated as _untrusted_. 

In a typical workflow, the artifact is retrieved from a store outside the solution's scope and then integrated into the deployment pipeline. There are some potential issues in this approach. The source might not be trusted, the artifact might contain vulnerabilities, or it might not be compatible in some developer environments. 

If these issues aren't addressed, data integrity and confidentiality guarantees of the solution might be compromised, or cause instability due to incompatibility with other components. 

Some of those security issues can be avoided by adding checks to each artifact. 

## Solution

Have a process that validates the software for security. During the process, each artifact undergoes thorough operational rigor that verifies it against specific conditions. Only after the artifact satisfies those conditions, the process marks it as _trusted_. 

> The process of quarantining is a security measure that makes sure that an artifact transitions from an untrusted status to a trusted status.

It's important to note that the quarantine process doesn't change the composition of the artifact. The process is independent of the software development cycle and is invoked by consumers, as needed. As a consumer of the artifact, block the use of artifacts until they've been quarantined and marked as trusted. 

Here's a typical quarantine workflow:

![This diagram shows the general quarantine pattern workflow.](./_images/quarantine.png)

1. The consumer signals their intent, specifies the input source of the artifact, and blocks its use. 

2. The quarantine process validates the origin of the request and gets the artifacts from the specified store. 

3. A custom verification process is performed as part of quarantine, which includes verifying the input constraints and checking the attributes, source, and type against established standards.

    Some of these security checks can be  vulnerability scanning, malware detection, and so on, on each submitted artifact.

    The actual checks depend on the type of artifact. Evaluating an OS image is different from evaluating a nugget package, for example.

4. If the verification process is successful, the artifact is published in a safe store with clear annotations. Otherwise, it's deleted to prevent  use. 

    The publishing process can include a cumulative report that shows proof of verification and the criticality of each check. Include expiration in the report beyond which the report should be invalid and the artifact is  considered unsafe.

5. The process marks the end of the quarantine by signaling an event with state information accompanied by a report.
    
    Based on the information, the consumers can choose to take actions to use the trusted artifact. Those actions are outside the scope of the quarantine pattern. 


## Issues and considerations

- As a team that consumes third-party artifacts, ensure that the artifact is obtained from a trusted source. Your organization must approve artifacts that are procured from third-party vendors. The vendors must be able to meet your security requirements and share a responsible disclosure plan. 

- Create segmentation between resources that stores trusted and untrusted artifacts. Use identity and network controls to restrict access to the authorized users.

- Have a reliable way to invoking the quarantine process. Make sure the artifact isn't consumed inadvertently to block its usage until marked as trusted. The signaling should be automated. For example, sending notification when an artifact is ingested into the developer environment, when a change is committed to GitHub repository, when an image is added to the private registry, and so on.  

-  An alternative to implementing your quarantine pattern is to outsource it. There are quarantine practitioners who specialize in public asset validation as their business model. You can trust them to perform this task for you. Instead of going to multiple registries, you can go to a single vendor who has already done the work. However, if your security requirements need more control, building your own process is recommended.

- Automate the artifact ingestion process and also the process of publishing the artifact. 

- The quarantine pattern can be implemented from both a centralized service perspective or an individual workload team. If there are many instances or variations of the quarantine process, these operations should be standardized and centralized by the organization.



## When to use this pattern

Use this pattern when: 

- The workload integrates artifacts developed outside the scope of the application team. Common examples include:

    - OCI artifacts from public registries such as DockerHub, GitHub Container registry, Microsoft container registry
    - Software libraries or packages from public sources such as the NuGet Gallery, developer registry, Python Package Index, and so on. 
    - External Infrastructure-as-Code (IaC) packages such as Terraform modules, Community Chef Cookbooks, Azure Verified Modules, 
    - Vendor-supplied OS Images. 
    
- Artifacts are considered as risks that you choose to mitigate. Integrating a compromised artifact can have negative consequences, such as a security breach or an outage. The quarantine pattern ensures that artifacts are tested and verified before integrating into a solution to reduce the risk of introducing vulnerabilities or other issues.

- The team has a clear and shared understanding of the validation rules that should be applied, to take it from untrusted to trusted. Without consensus on the input constraints and checks, the pattern might not be effective. For example, if validating every OS image differently can lead to inconsistencies in the verification process.

This pattern might not be useful when:

- When all assets used in the workload, are created by the workload team or a trusted partner team. 

- The risk associated with not verifying the external artifacts is less expensive than the cost of building and maintaining the workload.


## Example

This example applies the [solution workflow](#solution) to a scenario where the workload team wants to integrate OCI artifacts from public registries to an Azure Container Registry (ACR) instance owned by the workload team and treats it as a trusted artifact store. 

The workload environment uses Azure Policy for Kubernetes to enforce governance. It restricts container pulls only from their trusted registry instance. Additionally, Azure Monitor alerts are set up to detect any imports into that registry from unexpected sources.

![This image shows Azure Container Registry implementation of the quarantine pattern.](./_images/quarantine-example.png)

1. A request for an external image is made by the workload team through a custom application hosted on Azure Web Apps. The application collects the required information only from authorized users. 

    _Security checkpoint: The identity of requestor, the destination container registry, and the requested image source, are verified._

2. The request is stored in a Cosmos DB. 

    _Security checkpoint: An audit trail is maintained in the database, keeping track of access to the image. This trail is also used for historical reporting_.

3. The request is handled by a workflow orchestrator, which is a durable Azure Function. The orchestrator uses a scatter-gather approach for running all validations. 

    _Security checkpoint: The orchestrator has a managed identity with just-enough access to perform the validation tasks._

4. The orchestrator makes a request to import the image into the quarantine Azure Container Registry (ACR) that is deemed as an untrusted store. 

5. The import process on the quarantine registry gets the image from the untrusted external repository. If the import is successful, the quarantine registry has local copy of the image to execute validations. 

    _Security checkpoint: The quarantine registry protects against tampering during the validation process_.

6. The orchestrator runs all validation tasks on the local copy of the image. Tasks include checks such as, CVE detection, software bill of material (SBOM) evaluation, malware detection, image signing, and others. 

    The orchestrator decides the type of checks, the order of execution, and the time of execution. In this example, it uses Azure Container Instance as task runners and results are in the Cosmos DB audit database. All tasks can take a significant period of time and must be durable.

    _Security checkpoint: This step is the core of the quarantine process that performs all the validation checks. The type of checks could be custom, open-sourced, or vendor-purchased solutions._
    
7. The orchestrator makes a decision. If the image passes all validations, the event is noted in the audit database, the image is pushed to the trusted registry, and the local copy is deleted from the quarantine registry. Otherwise, the image is deleted from the quarantine registry to prevent its inadvertent use.

    _Security checkpoint: The orchestrator maintains segmentation between trusted and untrusted resource locations._

    > [!NOTE]
    > An alternative to the orchestrator making the decision, it can offload the decision making to the workload team. In this alternative, the orchestrator publishes the validation results through an API and keeps the image in the quarantine registry for a period of time. 
    >
    > The workload team makes the decision after reviewing results. If the results meet their risk tolerance, they pull  the image from the quarantine repository into their container instance. This pull model is more practical when this pattern is used to support multiple workload teams with different security risk tolerances.

All container registries are covered by Microsoft Defender for Containers, which continuously scans for newly found issues. These issues are shown in Microsoft Defender Vulnerability Management.

## Next steps

The following guidance might be relevant when implementing this pattern:

- [Recommendations for securing a development lifecycle](/azure/well-architected/security/secure-development-lifecycle) provides guidance on the hardening process through the stages of the development lifecycle and using trusted units of code aquired as part of the software supply chain.  

- [Best practices for a secure software supply chain](/nuget/concepts/security-best-practices) especially when you have NuGet dependencies in your application.  

- [Azure Artifacts documentation](/azure/devops/artifacts/) is a library of information related to managing software packages with Azure Artifacts.