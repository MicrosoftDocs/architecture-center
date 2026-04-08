This article describes how to manage virtual machine compliance without impairing DevOps practices. Use Azure VM Image Builder and Azure Compute Gallery to minimize risk from system images.

## Architecture

The solution consists of two processes:

- The golden image publishing process
- The process of tracking virtual machine (VM) compliance

:::image type="content" source="./media/virtual-machine-compliance-golden-image-publishing-architecture.svg" alt-text="Architecture diagram showing how the solution manages Microsoft Marketplace images for Azure. Illustrated steps include customization, tracking, testing, and publishing." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-machine-compliance-golden-image-publishing-architecture.vsdx) of this architecture.*

### Dataflow

The golden image publishing process runs monthly and contains these steps:

1. The process captures a base image from the [Microsoft Marketplace](https://marketplace.microsoft.com).
1. VM Image Builder customizes the image.
1. The process of image tattooing tracks image version information like the source and publish date.
1. Automated tests validate the image.
1. If the image fails any tests, it returns to the customization step for repairs.
1. The process publishes the finalized image.
1. Compute Gallery makes the image available to DevOps teams.

:::image type="content" source="./media/virtual-machine-compliance-track-compliance-architecture.svg" alt-text="Architecture diagram showing how the solution manages compliance by assigning policy definitions, evaluating machines, and displaying data in a dashboard." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-machine-compliance-track-compliance-architecture.vsdx) of this architecture.*
> [!NOTE]
> Azure Image Builder supports automatic image creation when certain criteria are met in your build pipline. Set up a trigger in Azure Image Builder to automatically refresh images on a monthly basis. See [How to enable Automatic Image Creation with Azure Image Builder triggers](/azure/virtual-machines/image-builder-triggers-how-to).

The process of tracking VM compliance contains these steps:

1. Azure Policy assigns policy definitions to VMs and evaluates the VMs for compliance.
1. Azure Policy publishes compliance data for the VMs and other Azure resources to the Azure Policy dashboard.

### Components

- [VM Image Builder][Azure VM Image Builder] is a managed service for customizing system images. This service builds and distributes the images that DevOps teams use.

- [Compute Gallery][Azure Compute Gallery] helps you structure and organize custom images. By storing images in repositories, this service provides controlled access to the images. Users can be within and outside your organization.

- [Azure Policy][Azure Policy and the policy dashboard] offers policy definitions. You can use these definitions to enforce your organization's standards and to assess compliance at scale. The Azure Policy dashboard displays results from Azure Policy evaluations. This data keeps you informed about the compliance status of your resources.

- The [Azure Machine Configuration feature of Azure Policy][Azure Machine configuration] provides a way to dynamically audit or assign configurations to machines through code. The configurations generally include environment or operating system settings.

### Alternatives

- You can use a non-Microsoft tool to manage compliance. But with this type of tool, you usually need to install an agent on the target VM. You also might have to pay a licensing fee.

- You can use [custom script extensions][Custom Script Extensions] for installing software on VMs or configuring VMs after deployment. But each VM or Virtual Machine Scale Set can only have one custom script extension. And if you use custom script extensions, you prevent DevOps teams from customizing their applications.

## Scenario details

Each enterprise has its own compliance regulations and standards. Regarding security, each company has its own risk appetite. Security standards can differ from one organization to another and from one region to another.

Following differing standards can be more challenging in dynamically scaling cloud environments than in on-premises systems. When teams use DevOps practices, there are usually fewer restrictions on who can create Azure resources like VMs. This fact complicates compliance challenges.

By using Azure Policy and role-based access control assignments, enterprises can enforce standards on Azure resources. But with VMs, these mechanisms only affect the control plane, or the route to the VM. The system images that run on a VM still pose a security threat. Some companies prevent developers from accessing VMs. This approach impairs agility, making it difficult to follow DevOps practices.

This article presents a solution for managing the compliance of VMs that run on Azure. Besides tracking compliance, the solution also minimizes the risk from system images that run on VMs. At the same time, the solution is compatible with DevOps practices. Core components include Azure VM Image Builder, Azure Compute Gallery, and Azure Policy.

### Potential use cases

This solution applies to organizations with Azure [landing zones][What is an Azure landing zone?] that complete these tasks:

- Supplying *golden images* to DevOps teams. A golden image is the published version of a marketplace image.
- Testing and validating images before making them available to DevOps teams.
- Tracking which image each DevOps team uses.
- Enforcing company standards without degrading productivity.
- Ensuring that DevOps teams use the latest image versions.
- Managing the compliance of *pet servers*, which are maintenance intensive, and *cattle servers*, which are easily replaceable.

### Approach

The following sections provide a detailed description of the solution's approach.

#### Identify pets and cattle

DevOps teams use an analogy called pets and cattle to define service models. To track a VM's compliance, first determine whether it's a pet or cattle server:

- Pets require significant attention. They're not easy to dispense. Recovering a pet server requires investing a considerable amount of time and financial resources. For example, a server that runs SAP might be a pet. Besides the software that runs on the server, other considerations can also determine the service model. If you have a low failure tolerance, production servers in real-time and near real-time systems can also be pets.
- Cattle servers are part of an identical group. You can replace them easily. For example, VMs that run in a Virtual Machine Scale Set are cattle. If there are enough VMs in the set, your system keeps running, and you don't need to know each VM's name. Testing environment servers that meet the following conditions provide another example of cattle:

  - You use an automated procedure to create the servers from scratch.
  - After you finish running the tests, you decommission the servers.

An environment might contain only pet servers, or it might contain only cattle servers. In contrast, a set of VMs in an environment could be pets. A different set of VMs in that same environment could be cattle.

To manage compliance:

- Pet compliance can be more challenging to track than cattle compliance. Usually, only DevOps teams can track and maintain the compliance of pet environments and servers. But this article's solution increases the visibility of each pet's status, making it easier for everyone in the organization to track compliance.
- For cattle environments, refresh the VMs and rebuild them from scratch regularly. Those steps should be adequate for compliance. You can align this refresh cycle with your DevOps team's regular release cadence.

#### Restrict images

Don't allow DevOps teams to use Microsoft Marketplace VM images. Only allow VM images that Compute Gallery publishes. This restriction is critical for ensuring VM compliance. You can use a custom policy in Azure Policy to enforce this restriction. For a sample, see [Allow image publishers][Only allow certain image publishers from the Marketplace].

As part of this solution, VM Image Builder should use a Microsoft Marketplace image. It's essential to use the latest image that's available in the Microsoft Marketplace. Apply any customizations on top of that image. Microsoft Marketplace images are refreshed often, and each image has certain preset configurations, ensuring your images are secure by default.

#### Customize images

A golden image is the version of a marketplace image that's published to Compute Gallery. Golden images are available for consumption by DevOps teams. Before the image is published, customization takes place. Customization activities are unique to each enterprise. Common activities include:

- Operating system hardening.
- Deploying custom agents for non-Microsoft software.
- Installing enterprise certificate authority (CA) root certificates.

You can use VM Image Builder to customize images by adjusting operating system settings and by running custom scripts and commands. VM Image Builder supports Windows and Linux images. For more information on customizing images, see [Azure Policy Regulatory Compliance controls for Azure Virtual Machines][Azure Policy Regulatory Compliance controls for Azure Virtual Machines].

> [!IMPORTANT]
> Azure virtual networks default to private subnets that don't have default outbound connectivity. If your VM Image Builder builds require outbound internet access, for example, to download updates, ensure the subnets you specify have outbound access explicitly configured.

#### Strengthen images with Trusted Launch
Beyond application-level customizations, golden images should establish a hardware-rooted chain of trust from boot to runtime. Trusted Launch provides this foundation for Generation 2 VMs at no additional cost. It is now the default for new Gen2 VM deployments and can be enabled in-place for existing VMs without redeployment. Configure golden images with the following Trusted Launch capabilities:

 - Secure Boot. Ensures only signed and trusted OS loaders, kernels, and drivers execute during startup. This protects against bootkits and rootkits — threats that traditional OS hardening cannot address because they load before the operating system.
 - Virtual Trusted Platform Module (vTPM). Emulates a hardware TPM inside the VM, providing secure storage for encryption keys, certificates, and boot measurements. vTPM enables scenarios such as BitLocker disk encryption and cryptographic guest attestation, which are often required for regulatory compliance (for example, FedRAMP, HIPAA, 
and PCI DSS).
 - Boot Integrity Monitoring. Measures the entire boot chain and surfaces telemetry to Microsoft Defender for Cloud. If a VM's boot integrity is compromised, administrators receive an alert — providing continuous validation that the golden image hasn't been tampered with after deployment.

When you build golden images, enable Secure Boot and vTPM as part of the image definition in Compute Gallery. This ensures every VM that DevOps teams provision inherits these protections by default, without requiring manual configuration. For existing VMs that predate Trusted Launch, use the in-place upgrade path to enable these capabilities without rebuilding the VM.

> [!NOTE]
> Not all VM sizes and OS images support Trusted Launch. Verify compatibility during the image validation step described in the Validate golden images with automated tests section.

#### Track image tattoos

Image tattooing is the process of keeping track of all image versioning information that a VM uses. This information is invaluable during troubleshooting and can include:

- The original source of the image, such as the name and version of the publisher.
- The operating system version string, which you need if there's an in-place upgrade.
- The version of your custom image.
- Your publish date.

The amount and type of information that you track depends on your organization's compliance level.

For image tattooing on Windows VMs, set up a custom registry. Add all required information to this registry path as key-value pairs. On Linux VMs, enter image tattooing data into environment variables or a file. Put the file in the `/etc/` folder, where it doesn't conflict with developer work or applications. If you'd like to use Azure Policy to track the tattooing data or report on it, store each piece of data as a unique key-value pair. For information on determining the version of a Marketplace image, see [How to find a Marketplace image version][How to find a Marketplace image version].

#### Generate a software bill of materials for golden images

Image tattooing records metadata *about* the image — its source, version, and publish date. A **software bill of materials (SBOM)** complements tattooing by recording what is *inside* the image: every operating system package, agent, library, and patch. This inventory is essential for vulnerability response, compliance audits, and supply chain transparency.

##### Why an SBOM matters for golden images

- **Faster CVE response.** When a critical vulnerability is disclosed, an SBOM lets you instantly identify which golden image versions contain the affected component — without manually inspecting each image.
- **Regulatory compliance.** Frameworks such as [US Executive Order 14028](https://www.nist.gov/itl/executive-order-14028-improving-nations-cybersecurity), the EU Cyber Resilience Act, and standards like FedRAMP and HIPAA increasingly require SBOMs for software artifacts that run in production. VM images are part of that software supply chain.
- **Audit traceability.** Pairing image tattoos with SBOMs gives auditors a complete picture: which image a VM runs, and exactly what software components were in that image at build time.

##### Generate the SBOM during the image build
Add SBOM generation as a step in the VM Image Builder pipeline, immediately after customization and before validation:
1. **Use the Microsoft SBOM Tool.** The open-source [Microsoft SBOM Tool](https://github.com/microsoft/sbom-tool) generates SBOMs in [SPDX 2.2 and 3.0](https://spdx.dev) format. It uses Microsoft's Component Detection libraries to enumerate installed operating system packages, agents, and dependencies. Run the tool on the customized image as a VM Image Builder customization step or as a post-customization script in your pipeline.
2. **Choose a standard format.** Use [SPDX](https://spdx.dev) or [CycloneDX](https://cyclonedx.org) — both are widely accepted industry standards. SPDX is the ISO/IEC 5962:2021 standard and is the format produced by the Microsoft SBOM Tool. Consistency across all golden images simplifies tooling and reporting.
3. **Sign the SBOM.** Cryptographically sign the generated SBOM to ensure its integrity. Use [Notation](https://notaryproject.dev) or a similar signing tool to prevent tampering after generation. A signed SBOM provides a verifiable chain of trust from the image build to the compliance audit.

##### Store and link the SBOM to the image version
- **Store the SBOM alongside the image.** Upload the SBOM to an Azure Storage account or an artifact store that is linked to the Compute Gallery image version. Use a consistent naming convention that maps each SBOM file to its image definition, version, and build date.
- **Reference the SBOM in the image tattoo.** Add the SBOM storage location and its hash to the image tattoo metadata. This creates a direct link from any running VM back to the exact SBOM that describes its contents.
- **Retain SBOMs for the image lifecycle.** Keep the SBOM available for at least as long as the image version is in use. Align retention with your organization's compliance and audit requirements.

##### Use the SBOM for ongoing governance
- **Query SBOMs during incident response.** When a new CVE is published, search across stored SBOMs to identify affected image versions. Use this data to trigger the [out-of-band emergency patching process](#emergency-patching-for-critical-vulnerabilities) and to set `excludeFromLatest` on affected versions in Compute Gallery.
- **Integrate with Microsoft Defender for Cloud.** [Defender for Cloud](/azure/defender-for-cloud/defender-for-containers-introduction) can generate and [query SBOMs](/azure/defender-for-cloud/query-software-bill-of-materials) across your environment, providing cross-repository visibility into software components and their vulnerabilities. Use [Cloud Security Explorer](/azure/defender-for-cloud/concept-attack-path) to answer questions like "which images contain a specific library version" across your organization.
- **Report on SBOM coverage.** Use Azure Policy with a custom policy definition to audit whether deployed VMs are running image versions that have an associated SBOM. Surface coverage gaps in the Azure Policy dashboard.

> [!NOTE]
> SBOM generation adds minimal time to the image build process and has no impact on the resulting image. The SBOM is a build artifact — it is stored externally, not embedded in the image itself.



#### Validate golden images with automated tests

Generally, you should refresh golden images monthly to stay current with the latest updates and changes in Microsoft Marketplace images. Use a recurrent testing procedure for this purpose. As part of the image creation process, use an Azure pipeline or other automated workflow for testing. Set up the pipeline to deploy a new VM for running tests before the beginning of each month. The tests should confirm pared images before publishing them for consumption. Automate tests by using a test automation solution or by running commands or batches on the VM.

Common test scenarios include:

- Validating the VM boot time.
- Confirming any customization of the image, such as operating system configuration settings or agent deployments.

A failed test should interrupt the process. Repeat the test after addressing the root cause of the problem. If the tests run without problem, automating the testing process reduces the effort that goes into maintaining an evergreen state.

#### Publish golden images

Publish final images in Azure Compute Gallery as managed images that DevOps teams can use. Mark any earlier images as aged. If you haven't set an end-of-life date for an image version in Compute Gallery, you might prefer to discontinue the oldest image. This decision depends on your company's policies.

> [!NOTE]
> Azure Compute Gallery supports [Soft Delete](/azure/virtual-machines/shared-image-galleries#soft-delete), which provides a 7-day recovery window for accidentally deleted images. Consider enabling Soft Delete on your gallery to protect against unintended image loss.

For information on limits that apply when you use Compute Gallery, see [Store and share images in an Azure Compute Gallery][Store and share images in an Azure Compute Gallery - Limits].

Another good practice is to publish the latest images across different regions. With Compute Gallery, you can manage the lifecycle and replication of your images across different Azure regions.

For more information on Compute Gallery, see [Store and share images in an Azure Compute Gallery][Store and share images in an Azure Compute Gallery].

#### Refresh golden images

When an image is used for an application, it can be hard to update the underlying operating system image with recent compliance changes. Strict business requirements can complicate the process of refreshing the underlying VM. Refreshing is also complex when the VM is critical to the business.

Because cattle servers are dispensable, you can coordinate with DevOps teams to refresh these servers in a planned maintenance window as a business-as-usual activity.

It's more challenging to refresh pet servers. Discontinuing an image can put applications at risk. In scale-out scenarios, Azure can't find the respective images, resulting in failures.

Consider these guidelines when refreshing pet servers:

- For best practices, see [Overview of the reliability pillar][Overview of the reliability pillar] in the Azure Well-Architected Framework.
- To streamline the process, see the principles that these documents discuss:

  - [Deployment Stamps pattern][Deployment Stamps pattern]
  - [Geode pattern][Geode pattern]
  - [Bulkhead pattern][Bulkhead pattern]

- Tag each pet server as a pet. Configure a policy in Azure Policy to take this tag into account during refreshes.

#### Emergency patching for critical vulnerabilities
The monthly golden image refresh cadence works well for routine updates, but critical security vulnerabilities and CVEs can't wait for the next scheduled cycle. Establish an **out-of-band emergency patching process** that runs independently of the monthly cadence and can be triggered on demand.

##### Discontinue affected images
When a critical CVE affects a published golden image, act immediately to prevent DevOps teams from provisioning new VMs with the vulnerable version:
1. **Mark the affected image version as excluded from latest.** In Compute Gallery, set the [`excludeFromLatest`](/azure/virtual-machines/shared-image-galleries#image-versions) property to `true` on every affected image version. This ensures that any automation or user requesting the "latest" image no longer receives the vulnerable version. You can apply this at the region level for staggered responses.
2. **Set an end-of-life date.** Configure the end-of-life property on the affected image version to formally deprecate it. Use the [`blockDeletionBeforeEndOfLife`](/azure/virtual-machines/compute-gallery-whats-new) property to prevent premature deletion if retention policies or audit requirements apply.
3. **Notify DevOps teams.** Use the Azure Policy assignment description to link to a runbook or internal wiki that lists the CVE, the affected image versions, and the required remediation actions.

##### Trigger an out-of-band image build
Use the same VM Image Builder pipeline that produces the monthly golden image, but trigger it on demand:
1. **Apply the security patch.** Add the critical fix to the image customization step — either as an operating system update, a configuration change, or a script that remediates the specific vulnerability.
2. **Run the automated test suite.** Don't skip validation. The same tests that run during the monthly cycle should run for emergency builds. If the CVE is time-sensitive, consider running a reduced test set that covers boot validation, Trusted Launch attestation, and the specific fix, then follow up with the full suite.
3. **Publish the patched image.** Publish the new image version to Compute Gallery and replicate it to all required regions. Because the affected version is already excluded from latest, the patched version automatically becomes the version that new deployments use.
4. **Update the image tattoo.** Record the out-of-band nature of the update in the image tattoo — include the CVE identifier, the patch date, and a flag that distinguishes it from a scheduled monthly release. This data is essential for compliance audits.

##### Refresh running VMs
Publishing a patched image prevents new VMs from being vulnerable, but existing VMs still run the affected version. Handle cattle and pet servers differently:

- **Cattle servers.** Coordinate with DevOps teams to trigger a rolling reimage or scale-set update using the patched golden image. In Virtual Machine Scale Sets, [set the upgrade policy](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-upgrade-policy) to apply the new image automatically or during the next maintenance window.
- **Pet servers.** Apply the patch directly by using the [Azure Automanage Machine Configuration](/en-us/azure/governance/machine-configuration) feature of Azure Policy or [Run Command](/azure/virtual-machines/run-command-overview). Use Azure Policy with an audit effect to flag pet servers that haven't been remediated. Track compliance in the Azure Policy dashboard until all affected VMs are patched.

##### Automate the trigger
To minimize response time, integrate the out-of-band process into your operational workflow:
- Subscribe to [Azure Service Health](/en-us/azure/service-health/overview) and Microsoft Security Response Center (MSRC) notifications for CVE alerts that affect your base images.
- Use an Azure DevOps or GitHub Actions pipeline with a manual or webhook trigger that initiates the emergency image build, test, and publish cycle.
- Define a severity threshold in your runbook. Not every CVE warrants an out-of-band response — reserve it for critical and high-severity vulnerabilities that affect your published images.

> [!IMPORTANT]
> The goal of out-of-band patching is not to replace the monthly cadence but to complement it. Continue the regular monthly refresh to capture cumulative updates, and use the emergency process strictly for vulnerabilities that cannot wait.

#### Improve visibility

Generally, you should use Azure Policy to manage any control-plane compliance activity. You can also use Azure Policy for:

- Tracking VM compliance.
- Installing Azure agents. Use the [Azure Monitor Agent (AMA)](/azure/azure-monitor/agents/azure-monitor-agent-overview) for monitoring.
- Capturing diagnostic logs.
- Improving the visibility of VM compliance.

Use the Machine Configuration feature of Azure Policy to audit the configuration changes that you make during image customization. When drift occurs, the Azure Policy dashboard lists the affected VM as non-compliant. Azure Policy can use image tattooing information to track when you use outdated images or operating systems.

Audit pet servers for each application. By using Azure Policies with an audit effect, you can improve the visibility of these servers. Adjust the audit process according to your company's risk appetite and internal risk management processes.

Each DevOps team can track its applications' compliance levels in the Azure Policy dashboard and take appropriate corrective actions. When you assign these policies to a management group or a subscription, give the assignment description a URL that leads to a company-wide wiki. You can also use a short URL like `aka.ms/policy-21`. In the wiki, list the steps that DevOps teams should take to make their VMs compliant.

IT risk managers and security officers can also use the Azure Policy dashboard to manage company risks according to their company's risk appetite.

By using the Machine configuration feature of Azure Policy with remediation options, you can apply corrective actions automatically. But interrogating a VM frequently or making changes on a VM that you use for a business-critical application can degrade performance. Plan remediation actions carefully for production workloads. Give a DevOps team ownership of application compliance in all environments. This approach is essential for pet servers and environments, which are usually long-term Azure components.

#### Best practices for golden image hygiene

A well-structured image build process prevents common mistakes that lead to security incidents, configuration drift, and operational friction. Follow these guidelines when you customize and maintain golden images:
- **Never bake secrets into images.** Don't embed API keys, connection strings, passwords, certificates' private keys, or tokens in the image. Secrets that are baked into an image are exposed to every VM that uses it and to anyone with read access to Compute Gallery. Instead, retrieve secrets at runtime from [Azure Key Vault](/azure/key-vault/general/overview) by using a [managed identity](/azure/active-directory/managed-identities-azure-resources/overview). This approach keeps secrets rotatable and auditable without rebuilding the image.
- **Prefer external configuration over hardcoded values.** Any setting that might change between environments or before the next image build — such as endpoints, feature flags, regional settings, or log levels — should be externalized. Use [Azure App Configuration](/azure/azure-app-configuration/overview), environment variables injected at deployment time, or the [Machine Configuration feature of Azure Policy](/azure/governance/machine-configuration) to apply configuration after the VM boots. Reserve image customization for settings that are truly static and universal across all deployments.
- **Minimize the software footprint.** Only install components that every consumer of the image needs. Additional tooling that's specific to a single DevOps team or workload should be deployed after provisioning, using extensions or configuration management. A smaller footprint reduces the attack surface and the number of components that require patching.
- **Don't store application code or deployment artifacts in the image.** Golden images should provide a secure, compliant operating system foundation — not a pre-packaged application. Application code should be deployed separately through CI/CD pipelines. This separation ensures the image lifecycle and the application lifecycle can move independently.
- **Use deterministic, repeatable build scripts.** Pin package versions in your customization scripts. Avoid commands like `apt-get upgrade` or `yum update` without version constraints, which can produce different images on different build days. Deterministic builds make it easier to reproduce issues and ensure that the SBOM accurately reflects the image contents.
- **Tag images with their intended scope.** Use Compute Gallery metadata and tags to clearly indicate which image is for which purpose — for example, operating system type, target workload family, or compliance tier. This metadata helps DevOps teams select the correct image and helps governance teams audit usage.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This solution uses managed components that are automatically resilient at a regional level. For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][Designing resilient applications for Azure].

You can configure the number of replicas that Compute Gallery stores of each image. A higher number of replicas minimizes the risk of throttling when you provision multiple VMs simultaneously. For general guidance on scaling and configuring an appropriate number of replicas, see [Scaling for Azure Compute Gallery][Scaling for Azure Compute Gallery].

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Unless you use a non-Microsoft service such as Ansible or Terraform, this approach is nearly free of charge. Storage and egress costs might apply. Other potential charges involve these components:

- Azure Policy and [Azure Machine configuration][Azure Machine configuration] are free of charge for Azure resources. If your company uses a hybrid approach, there are extra charges for Azure Arc resources.
- [VM Image Builder][Azure VM Image Builder - pricing] uses a single compute instance type with 1 vCPU and 3.5 GB of RAM. Charges might apply for data storage and transfer.
- [Compute Gallery][Azure Shared Image Galleries] has no charges except:

  - The cost of storing replicas.
  - Network egress charges for replicating images.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Yunus Emre Alpozen](https://www.linkedin.com/in/yemre) | Program Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure landing zone][Azure landing zone]
- [Control and audit your resources by using Azure Policy][Control and audit your resources by using Azure Policy]
- [Azure VM Image Builder][Azure VM Image Builder]
- [Azure Compute Gallery][Azure Compute Gallery]
- [Azure Policy and the policy dashboard][Azure Policy and the policy dashboard]
- [Azure Machine Configuration][Azure Machine configuration]

## Related resources

- [DevTest and DevOps for IaaS solutions][DevTest and DevOps for IaaS solutions]
- [DevSecOps on AKS][DevSecOps on AKS]

[Azure Compute Gallery]: /azure/virtual-machines/shared-image-galleries
[Azure VM Image Builder]: /azure/virtual-machines/image-builder-overview
[Azure landing zone]: /azure/cloud-adoption-framework/ready/landing-zone
[Azure Machine configuration]: /azure/governance/machine-configuration
[Azure Policy and the policy dashboard]: /azure/governance/policy/overview
[Azure Policy Regulatory Compliance controls for Azure Virtual Machines]: /azure/virtual-machines/security-controls-policy
[Azure Shared Image Galleries]: /azure/virtual-machines/shared-image-galleries#billing
[Azure VM Image Builder - pricing]: https://azure.microsoft.com/pricing/details/image-builder
[Bulkhead pattern]: ../../patterns/bulkhead.md
[Control and audit your resources by using Azure Policy]: /training/modules/build-cloud-governance-strategy-azure/6-control-audit-resources-azure-policy
[Custom Script Extensions]: /azure/virtual-machines/extensions/custom-script-windows
[Deployment Stamps pattern]: ../../patterns/deployment-stamp.yml
[Designing resilient applications for Azure]: /azure/well-architected/reliability/principles
[DevSecOps on AKS]: ../../guide/devsecops/devsecops-on-aks.yml
[DevTest and DevOps for IaaS solutions]: ../../solution-ideas/articles/dev-test-iaas.yml
[Geode pattern]: ../../patterns/geodes.yml
[How to find a Marketplace image version]: /azure/virtual-machines/windows/cli-ps-findimage#view-purchase-plan-properties
[Only allow certain image publishers from the Marketplace]: https://github.com/Azure/azure-policy/tree/master/samples/Compute/allowed-image-publishers
[Overview of the reliability pillar]: /azure/well-architected/reliability/
[Scaling for Azure Compute Gallery]: /azure/virtual-machines/shared-image-galleries#scaling
[Store and share images in an Azure Compute Gallery]: /azure/virtual-machines/shared-image-galleries
[Store and share images in an Azure Compute Gallery - Limits]: /azure/virtual-machines/shared-image-galleries#limits
[What is an Azure landing zone?]: /azure/cloud-adoption-framework/ready/landing-zone
