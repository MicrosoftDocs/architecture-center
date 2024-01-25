
Consume software artifacts in your supply chain only when it's verified and marked as safe-for-use, by well-defined processes. This pattern is an operational sidecar, to the development process, which is invoked to block the use of third-party software that could potentially introduce security vulnerabilities in your deployment.


## Context and problem

Cloud solutions often rely on third-party software that's sourced externally. Open source binaries, public container images, vendor OS images are some examples of these types of artifacts. All such external artifacts must be treated as _untrusted_. 

In a typical workflow, the artifact is retrieved from a store outside the solution's scope and then integrated into the deployment pipeline. There are some potential issues in this approach. The source might not be trusted, the artifact might contain vulnerabilities, or it might not be compatible in some developer environments. 

If these issues are not addressed, data integrity and confidentiality guarantees of the solution might be compromised, or cause instability due to incompatibility with other components. 

Some of those security issues can be avoided by adding checks to each artifact. 

## Solution

Have a process that validates the software for security. During the process, each artifact undergoes thorough operational rigor that verifies it against specific conditions. Only after the artifact has satisfied those conditions, the process marks it as _trusted_. 

Therefore, the process of quarantining is a security measure that makes sure that an artifact transitions from an untrusted status to a trusted status.

It's important to note that the quarantine process doesn't change the composition of the artifact. The process is independent of the software development cycle and is invoked by consumers, as needed. As a consumer of the artifact, block the use of artifacts until they've been quarantined and marked as trusted. 

Here's a typical quarantine workflow:

1. The consumer signals their intent, specifies the input source of the artifact, and blocks its use. 

2. The quarantine process validates the origin of the request and gets the artifacts from the specified store. 

3. A custom verification process is performed as part of quarantine, which includes verifying the input constraints and checking the attributes, source, and type against established standards.

    Some of these security checks can be  vulnerability scanning, malware detection, and so on, on each submitted artifact.

    The actual checks will depend on the type of artifact. Evaluating an OS image is different from evaluating a nugget package, for example.

4. If the verification process is successful, the artifact is published in a safe store with clear annotations. Otherwise, it's deleted to prevent  use. 

    The publishing process can include a cumulative report that shows proof of verification and the criticality of each check. Include expiration in the report beyond which the report should be invalid and the artifact is  considered unsafe.

5. The process marks the end of the quarantine by signaling an event with state information accompanied by a report.
    
    Based on the information, the consumers can choose to take actions to use the trusted artifact. Those actions are outside the scope of the quarantine pattern. 


This image shows the flow of the quarantine process.

![Quarantine pattern workflow.](./_images/quarantine.png)

## Issues and considerations

- As a team that consumes third-party artifacts, ensure that the artifact is obtained from a trusted source. Your organization must approve artifacts that are procured from third-party vendors. The vendors must be able to meet your security requirements and share a responsible disclosure plan. 

- Have a reliable way to invoking the quarantine process. Make sure the artifact isn't consumed inadvertently to block its usage until marked as trusted. The signaling should be automated. For example, sending notification when an artifact is ingested into the developer environment, when a change is committed to GitHub repository, when an image is added to the private registry, and so on.  

-  An alternative to implementing your quarantine pattern is to outsource it. There are quarantine practitioners who specialize in public asset validation as their business model. You can trust them to perform this task for you. Instead of going to multiple registries, you can go to a single vendor who has already done the work. However, if your security requirements need more control, building your own process is recommended.

- Automate the artifact ingestion process. 

- Instance count. One or many instances of the quarantine process per team/organization. trusted source repos.



## When to use this pattern

Use this pattern when: 

- The workload integrates artifacts developed outside the scope of the application team. Common examples include:

    - OCI artifacts from public registries such as DockerHub, Github Container registry, Microsoft container registry
    - Software libraries or packages from public sources such as the NuGet Gallery, NPM registry, Python Package Index, and so on. 
    - External Infrastructure-as-Code (IaC) packages such as Terraform modules, Community Chef Cookbooks, Azure Verified Modules, 
    - Vendor-supplied OS Images. 
    
- Artifacts are considered as risks that are more expensive than the cost of building and maintaining the workload. Integrating a compromised artifact can have negative consequences, such as a security breach or an outage. The quarantine pattern ensures that artifacts are tested and verified before integrating into a solution to reduce the risk of introducing vulnerabilities or other issues.

- The team has a clear and shared understanding of the validation rules that should be applied, to take it from unstrusted to trusted. Without consensus on the input constraints and checks, the pattern might not be effective. For example, if validating every OS image differently can lead to inconsistencies in the verification process.

This pattern might not be useful when:

- When all assets used in the workload are created by the workload team or a trusted partner team. 

- Controlling external artifacts might not be worth mitigating the risks it poses to the workload.

## Example
ACR as an example.



