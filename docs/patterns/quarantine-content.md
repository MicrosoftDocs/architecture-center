
Consume software artifacts in your supply chain only when it's verified and marked as safe-for-use, by well-defined processes. This pattern is an operational sidecar, to the development process, which is invoked to block the use of third-party software that could potentially introduce security vulnerabilities in your deployment.


## Context and problem

Cloud solutions often rely on third-party software that's obtained from external sources. Open source binaries, public container images, vendor OS images are some examples of these types of artifacts. All such external artifacts must be treated as _untrusted_. 

In a typical workflow, the artifact is retrieved from a store outside the solution's scope and then integrated into the deployment pipeline. There are some potential issues in this approach. The source might not be trusted, the artifact might contain vulnerabilities, or it might not be compatible in some developer environments. 

If these issues aren't addressed, data integrity and confidentiality guarantees of the solution might be compromised, or cause instability due to incompatibility with other components. 

Some of those security issues can be avoided by adding checks to each artifact. 

## Solution

Have a process that validates the software for security. During the process, each artifact undergoes thorough operational rigor that verifies it against specific conditions. Only after the artifact satisfies those conditions, the process marks it as _trusted_. 

Therefore, the process of quarantining is a security measure that makes sure that an artifact transitions from an untrusted status to a trusted status.

It's important to note that the quarantine process doesn't change the composition of the artifact. The process is independent of the software development cycle and is invoked by consumers, as needed. As a consumer of the artifact, block the use of artifacts until they've been quarantined and marked as trusted. 

Here's a typical quarantine workflow:

1. The consumer signals their intent, specifies the input source of the artifact, and blocks its use. 

2. The quarantine process validates the origin of the request and gets the artifacts from the specified store. 

3. A custom verification process is performed as part of quarantine, which includes verifying the input constraints and checking the attributes, source, and type against established standards.

    Some of these security checks can be  vulnerability scanning, malware detection, and so on, on each submitted artifact.

    The actual checks depend on the type of artifact. Evaluating an OS image is different from evaluating a nugget package, for example.

4. If the verification process is successful, the artifact is published in a safe store with clear annotations. Otherwise, it's deleted to prevent  use. 

    The publishing process can include a cumulative report that shows proof of verification and the criticality of each check. Include expiration in the report beyond which the report should be invalid and the artifact is  considered unsafe.

5. The process marks the end of the quarantine by signaling an event with state information accompanied by a report.
    
    Based on the information, the consumers can choose to take actions to use the trusted artifact. Those actions are outside the scope of the quarantine pattern. 


This image shows the flow of the quarantine process.

![Quarantine pattern workflow.](./_images/quarantine.png)

## Issues and considerations

- As a team that consumes third-party artifacts, ensure that the artifact is obtained from a trusted source. Your organization must approve artifacts that are procured from third-party vendors. The vendors must be able to meet your security requirements and share a responsible disclosure plan. 

- Create segmentation between resources that stores trusted and untrusted artifacts. Use identity and network controls to restrict access to the authorized users.

- Have a reliable way to invoking the quarantine process. Make sure the artifact isn't consumed inadvertently to block its usage until marked as trusted. The signaling should be automated. For example, sending notification when an artifact is ingested into the developer environment, when a change is committed to GitHub repository, when an image is added to the private registry, and so on.  

-  An alternative to implementing your quarantine pattern is to outsource it. There are quarantine practitioners who specialize in public asset validation as their business model. You can trust them to perform this task for you. Instead of going to multiple registries, you can go to a single vendor who has already done the work. However, if your security requirements need more control, building your own process is recommended.

- Automate the artifact ingestion process. //TODO

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

Let’s consider the integration of OCI artifacts from public registries to Azure Container Registry (ACR). Suppose the workload uses a container image in Docker Hub. The workload team signals their intent of integrating that image by importing the image from Docker Hub into a local container registry. This purpose of this registry is to hold the image during quarantine. At this point there's no state change between the image in Docker Hub and the local registry. The image in both those sources is untrusted.

The workload team has governance policies in place that only allows the workload to use images an ACR instance owned by the team. So any image pulled from the local container registry is blocked. 

Invoke security tooling - Microsoft Defender suite //TODO

ACR has the ability to push metadata onto images themselves. However, it may be necessary to augment the design with some external tracking, because ACR itself may not be able to support all of this natively. 

Keep a log of running the validation tests to track what happened and what didn’t happen. If the artifact was not found satisfactory, don't keep it for consumption.

