This article describes how to manage virtual machine (VM) compliance without disrupting DevOps practices. Use Azure VM Image Builder and Azure Compute Gallery to minimize risk from system images. The solution consists of the gold image publishing process and the VM compliance tracking process.

## Architecture

:::image type="complex" border="false" source="./media/virtual-machine-compliance-golden-image-publishing-architecture.svg" alt-text="Diagram that shows how the solution manages Microsoft Marketplace images for Azure." lightbox="./media/virtual-machine-compliance-golden-image-publishing-architecture.svg":::
   The diagram shows the golden image publishing process as a numbered workflow with seven steps. In step 1, an arrow points from the Marketplace icon to the Marketplace image. In step 2, an arrow points from the Marketplace image to VM Image Builder. In step 3, an arrow points from VM Image Builder to the image tattooing icon. In step 4, an arrow points from the automated tests to the image versions icon. In step 5, a feedback arrow points from the test icon back to the customization icon to indicate a return for repairs on failure. In step 6, an arrow points to the image versions. In step 7, an arrow points to the Compute Gallery icon.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-machine-compliance-golden-image-publishing-architecture.vsdx) of this architecture.*

### Data flow

The following sections describe the two processes in this solution.

#### Gold image publishing

The following data flow corresponds to the previous diagram:

1. Each month, the golden image publishing process captures a base image from the [Microsoft Marketplace](https://marketplace.microsoft.com).

1. VM Image Builder customizes the image.

1. The image tattooing process tracks image version information like the source and publish date.

1. Automated tests validate the image.

1. If the image fails any tests, it returns to the customization step for repairs.

1. The process publishes the finalized image.

1. Compute Gallery makes the image available to DevOps teams.

#### VM compliance tracking

:::image type="complex" border="false" source="./media/virtual-machine-compliance-track-compliance-architecture.svg" alt-text="Diagram that shows how the solution manages compliance by assigning policy definitions, evaluating machines, and displaying data in a dashboard" lightbox="./media/virtual-machine-compliance-track-compliance-architecture.svg":::
   The diagram shows a two-step workflow. In step 1, an arrow points from Azure Policy to a VM to indicate that Azure Policy assigns policy definitions to VMs and evaluates them for compliance. In step 2, an arrow points from Azure Policy to the dashboard which indicates that Azure Policy publishes compliance data for the VMs and other Azure resources to the Azure Policy dashboard.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-machine-compliance-track-compliance-architecture.vsdx) of this architecture.*

The following data flow corresponds to the previous diagram:

1. The VM compliance tracking process uses Azure Policy to assign policy definitions to VMs and evaluate the VMs for compliance.

1. Azure Policy publishes compliance data for the VMs and other Azure resources to the Azure Policy dashboard.

### Components

- [VM Image Builder][VM Image Builder] is a managed service for customizing system images. It builds and distributes the images that DevOps teams use. In this architecture, VM Image Builder captures monthly base images from the Marketplace, applies hardening and agent deployments, records image tattooing data, and publishes the finalized golden images to Compute Gallery.

- [Compute Gallery][Compute Gallery] is an Azure service for storing and organizing custom VM images. It centralizes image management and controls access for internal teams and any external tenants you authorize. In this architecture, Compute Gallery stores the golden images that DevOps teams must use. Azure Policy enforces that DevOps teams provision VMs only from images in this gallery.

- [Azure Policy][Azure Policy and the policy dashboard] is an Azure governance service that provides policy definitions. You can use these definitions to enforce your organization's standards and assess compliance at scale. The Azure Policy dashboard displays results from Azure Policy evaluations and keeps you informed about the compliance status of your resources. In this architecture, Azure Policy assigns policy definitions to VMs, evaluates them for compliance, publishes results to the Azure Policy dashboard, and restricts DevOps teams to using only Compute Gallery images.

- The [Azure machine configuration feature of Azure Policy][Azure machine configuration] provides a way to dynamically audit or assign configurations to machines through code. The configurations generally include environment or OS settings. In this architecture, Azure machine configuration audits the configuration settings that image customization establishes and marks VMs as non-compliant in the Azure Policy dashboard when configuration drift occurs.

### Alternatives

- You can use a non-Microsoft tool to manage compliance. With this type of tool, you usually need to install an agent on the target VM and might need to pay a licensing fee.

- You can use [custom script extensions][Custom Script Extensions] to install software on VMs or configure VMs after deployment. Each VM or Virtual Machine Scale Set supports only one custom script extension. If you use custom script extensions, you prevent DevOps teams from customizing their applications.

## Scenario details

Each enterprise has its own compliance regulations and standards. Each company has its own acceptable level of security risk. Security standards can vary across organizations and regions.

Differing standards can be harder to follow in dynamically scaling cloud environments than in on-premises systems. When teams use DevOps practices, they often place fewer restrictions on who can create Azure resources like VMs. This flexibility complicates compliance efforts.

Azure Policy and role-based access control (RBAC) assignments can help enterprises enforce standards on Azure resources. But for VMs, these controls apply only to the control plane, or the route to the VM. The system images that run on the VM pose a security threat. Some companies prevent developers from accessing VMs, which reduces agility and makes it difficult to follow DevOps practices.

This article presents a solution for managing VM compliance on Azure. The solution tracks compliance, minimizes the risk from system images that run on VMs, and is compatible with DevOps practices. Key components include VM Image Builder, Compute Gallery, and Azure Policy.

### Potential use cases

This solution applies to organizations that have Azure [landing zones][Azure landing zone overview] that complete these tasks:

- Supply *golden images* to DevOps teams. A golden image is the published version of a marketplace image.

- Test and validate images before you make them available to DevOps teams.

- Track which image each DevOps team uses.

- Enforce company standards without a loss of productivity.

- Ensure that DevOps teams use the latest image versions.

- Manage the compliance of *pet servers*, which are maintenance intensive, and *cattle servers*, which are easily replaceable.

### Approach

The following sections provide a detailed description of the solution's approach.

#### Identify pets and cattle

DevOps teams use a *pets and cattle* analogy to define service models. To track a VM's compliance, first determine whether it's a pet or a cattle server:

- Pets require significant attention and aren't easy to replace. Recovering a pet server takes considerable time and financial resources. For example, a server that runs SAP might be a pet. Beyond the software on the server, other considerations can determine the service model. Production servers in real-time and near real-time systems can also be pets when you have a low failure tolerance.

- Cattle servers are part of an identical group and easy to replace. For example, VMs that run in a Virtual Machine Scale Set are cattle. Test environment servers are another example of cattle when they meet the following conditions:

  - You use an automated procedure to create the servers from scratch.
  - After you finish running the tests, you decommission the servers.

An environment might contain only pet servers, or it might contain only cattle servers. In contrast, a set of VMs in an environment could be pets. A different set of VMs in that same environment could be cattle.

Compliance considerations differ for pet and cattle environments:

- Pet compliance can be more challenging to track than cattle compliance. Usually, only DevOps teams can track and maintain the compliance of pet environments and servers. This solution increases the visibility of each pet's status so that everyone in the organization can track compliance.

- For cattle environments, refresh the VMs and rebuild them from scratch regularly. Those steps should be sufficient for compliance. You can align this refresh cycle with your DevOps team's regular release cadence.

#### Restrict images

Don't allow DevOps teams to use Marketplace VM images. Only allow VM images that Compute Gallery publishes. This restriction is critical for VM compliance. Use a custom policy in Azure Policy to enforce this restriction. For a sample, see [Allow image publishers][Only allow certain image publishers from Marketplace].

As part of this solution, VM Image Builder should use a Marketplace image. It's crucial that you use the latest available image in Marketplace. Apply your customizations on top of that image. Marketplace images refresh often and include preset configurations that make your images secure by default.

#### Customize images

A golden image is a customized version of a Marketplace image that you publish to Compute Gallery for DevOps teams to use. You customize the image before you publish it. Customization activities are unique to each enterprise. Common activities include:

- OS hardening

- Deployment of custom agents for non-Microsoft software

- Installation of enterprise certificate authority (CA) root certificates

You can use VM Image Builder to customize images by adjusting OS settings and running custom scripts and commands. VM Image Builder supports Windows and Linux images. For more information, see [Azure Policy regulatory compliance controls for Azure Virtual Machines][Azure Policy regulatory compliance controls for Azure Virtual Machines].

> [!IMPORTANT]
> Azure virtual networks default to private subnets that lack outbound connectivity. If your VM Image Builder builds require outbound internet access, like to download updates, you must explicitly configure outbound access on the subnets that you specify.

#### Strengthen images by using Trusted Launch

Beyond application-level customizations, golden images should establish a hardware-rooted chain of trust from boot to runtime. Trusted Launch provides this foundation for Generation 2 VMs. Configure golden images with these Trusted Launch capabilities:

- **Secure Boot:** Ensures that only signed and trusted OS loaders, kernels, and drivers run during startup. This approach protects against bootkits and rootkits.

- **Virtual Trusted Platform Module (vTPM):** Emulates a hardware Trusted Platform Module (TPM) inside the VM and provides secure storage for encryption keys, certificates, and boot measurements. vTPM supports scenarios like BitLocker disk encryption and cryptographic guest attestation.

- **Boot Integrity Monitoring:** Measures the entire boot chain and surfaces telemetry to Microsoft Defender for Cloud.

> [!NOTE]
> Not all VM sizes and OS images support Trusted Launch. Verify compatibility during the image validation step described in [Validate golden images with automated tests](#validate-golden-images-with-automated-tests).

#### Track image tattoos

Image tattooing is the process of tracking all image versioning information that a VM uses. This information is invaluable during troubleshooting and includes:

- The original source of the image, like the name and version of the publisher

- The OS version string, which you need if there's an in-place upgrade

- The version of your custom image

- Your publish date

The amount and type of information that you track depends on your organization's compliance level.

For image tattooing on Windows VMs, set up a custom registry. Add all required information to this registry path as key-value pairs. On Linux VMs, input image tattooing data into environment variables or a file. Place the file in the `/etc/` folder where it doesn't conflict with developer work or applications. To use Azure Policy to track or report on the tattooing data, store each piece of data as a unique key-value pair. For more information, see [Find a Marketplace image version][Find a Marketplace image version].

#### Generate a software bill of materials for golden images

Image tattooing records metadata about the image, like its source, version, and publish date. A software bill of materials (SBOM) complements tattooing by recording what's inside the image, like all OS packages, agents, libraries, and patches. This inventory is essential for vulnerability response, compliance audits, and supply chain transparency.

An SBOM for golden images helps in the following ways:

- **Faster common vulnerabilities and exposures (CVE) response:** When a critical vulnerability is disclosed, an SBOM identifies which golden image versions contain the affected component.

- **Regulatory compliance:** Regulatory laws and standards often require SBOMs for software artifacts. VM images are part of that software supply chain.

- **Audit traceability:** When you pair image tattoos with SBOMs, auditors get a complete picture of which image a VM runs and exactly what software components the image contained at build time.

##### Generate the SBOM during the image build

Add SBOM generation as a step in the VM Image Builder pipeline immediately after customization and before validation.

Use the open-source [Microsoft SBOM tool](https://github.com/microsoft/sbom-tool) to generate SBOMs in [SPDX](https://spdx.dev) format. The tool enumerates installed OS packages, agents, and dependencies. Run the tool on the customized image as a VM Image Builder customization step or as a post-customization script in your pipeline. Cryptographically sign the generated SBOM to ensure its integrity.

Store the SBOM alongside the image. Upload the SBOM to an Azure Storage account or an artifact store linked to the Compute Gallery image version. Use a consistent naming convention that maps each SBOM file to its image definition, version, and build date. Keep the SBOM available for at least as long as the image version is in use.

#### Validate golden images with automated tests

Generally, you should refresh golden images monthly to remain current with the latest updates and changes in Marketplace images. Use a recurrent testing procedure for this purpose. As part of the image creation process, use an Azure pipeline or other automated workflow for testing. Set up the pipeline to deploy a new VM to run tests before the beginning of each month. The tests should confirm pared images before you publish it for consumption. Automate tests by using a test automation solution or running commands or batches on the VM.

Common test scenarios include:

- Validate the VM boot time.

- Confirm image customizations, like OS configuration settings or agent deployments.

A failed test should interrupt the process. Repeat the test after you address the root cause of the problem. If the tests run smoothly, automating the testing process reduces the effort that goes into maintaining an evergreen state.

#### Publish golden images

Publish final images in Compute Gallery as managed images that DevOps teams can use. Mark earlier images as aged. If you haven't set an end-of-life date for an image version in Compute Gallery, consider discontinuing the oldest image based on your company's policies.

> [!NOTE]
> The [soft delete feature (preview)](/azure/virtual-machines/soft-delete-gallery) in Compute Gallery provides a 7-day recovery window for accidentally deleted images. Consider enabling soft delete on your gallery to protect against unintended image loss.

For more information about limits that apply when you use Compute Gallery, see [Store and share images in a Compute Gallery][Store and share images in a Compute Gallery - Limits].

Publishing the latest images across different regions is a good practice. With [Compute Gallery][Store and share images in a Compute Gallery], you can manage the life cycle and replication of your images across different Azure regions.

#### Refresh golden images

When an application uses an image, the underlying OS image can be difficult to update with recent compliance changes. Strict business requirements can complicate the process of refreshing the underlying VM. Refreshing is also complex for business-critical VMs.

Cattle servers are dispensable, so you can coordinate with DevOps teams to refresh them in a planned maintenance window as a regular activity.

Pet servers are more challenging to refresh. Discontinuing an image can put applications at risk. In scale-out scenarios, Azure can't find the respective images, which results in failures.

Consider these guidelines when you refresh pet servers:

- For best practices, see the [Reliability pillar overview][Overview of the Reliability pillar] in the Azure Well-Architected Framework.

- To simplify the process, see the principles in the following articles:

  - [Deployment Stamps pattern][Deployment Stamps pattern]
  - [Geode pattern][Geode pattern]
  - [Bulkhead pattern][Bulkhead pattern]

- Tag each pet server as a pet. Configure a policy in Azure Policy to account for this tag during refreshes.

> [!NOTE]
> Azure Image Builder supports automatic image creation when your build pipeline meets certain criteria. Set up a trigger in Azure Image Builder to automatically refresh images monthly. For more information, see [Enable automatic image creation with Azure Image Builder triggers](/azure/virtual-machines/image-builder-triggers-how-to).

#### Emergency patching for critical vulnerabilities

The monthly golden image refresh cadence suits routine updates, but critical security vulnerabilities and CVEs require action before the next scheduled cycle. Establish an out-of-band (OOB) emergency patching process that runs independently of the monthly cadence and triggers on demand. Subscribe to [Azure Service Health](/azure/service-health/overview) and Microsoft Security Response Center (MSRC) notifications for CVE alerts that affect your base images.

When a critical CVE affects a published golden image, act immediately to prevent provisioning new VMs with the vulnerable version. Start by marking the affected image version as excluded from the image version that Azure selects when users or automation request the latest version. In Compute Gallery, set the [excludeFromLatest](/azure/virtual-machines/shared-image-galleries#image-versions) property to `true` on every affected image version. After this change, automation and users that request the latest available version no longer receive the vulnerable version. Use the Azure Policy assignment description to link to a runbook or internal wiki that lists the CVE, the affected image versions, and the required remediation actions.

##### Trigger an OOB image build

Use the same VM Image Builder pipeline that produces the monthly golden image, but trigger it on demand:

1. **Apply the security patch.** Add the critical fix to the image customization step as an OS update, a configuration change, or a script that remediates the specific vulnerability.

1. **Run the automated test suite.** Don't skip validation. The same tests that run during the monthly cycle should run for emergency builds.

1. **Publish the patched image.** Publish the new image version to Compute Gallery and replicate it to all required regions. The affected version is excluded from the latest version selection, so the patched version automatically becomes the version that new deployments use.

1. **Update the image tattoo.** Record the OOB nature of the update in the image tattoo and include the CVE identifier, the patch date, and a flag that distinguishes it from a scheduled monthly release. This data can be helpful for compliance audits.

> [!IMPORTANT]
> OOB patching complements the monthly cadence but doesn't replace it. Continue the regular monthly refresh to capture cumulative updates, and use your emergency process strictly for vulnerabilities that require immediate action.

#### Improve visibility

Generally, you should use Azure Policy to manage control-plane compliance activity. You can also use Azure Policy to do the following tasks:

- Track VM compliance.

- Install Azure agents. Use the [Azure Monitor agent](/azure/azure-monitor/agents/azure-monitor-agent-overview) for monitoring.

- Capture diagnostic logs.

- Improve the visibility of VM compliance.

Use Azure machine configuration to audit configuration changes that you make during image customization. When drift occurs, the Azure Policy dashboard lists the affected VM as non-compliant. Azure Policy can use image tattooing information to track when you use outdated images or operating systems.

Audit pet servers for each application. You can improve the visibility of these servers by using Azure Policies with an audit effect. Adjust the audit process according to your company's acceptable level of risk and internal risk management processes.

Each DevOps team can track its applications' compliance levels in the Azure Policy dashboard and take appropriate corrective actions. When you assign these policies to a management group or a subscription, include a URL in the assignment description that leads to a company-wide wiki. You can also use a short URL like `aka.ms/policy-21`. In the wiki, list the steps that DevOps teams should follow to make their VMs compliant.

IT risk managers and security officers can also use the Azure Policy dashboard to manage company risks according to their company's acceptable level of risk.

Azure machine configuration with remediation options automatically applies corrective actions. But frequent queries or modifications to a VM that you use for a business-critical application can affect performance. Plan remediation actions carefully for production workloads. Assign a DevOps team ownership of application compliance in all environments. This approach is essential for pet servers and environments, which are typically long-term Azure components.

#### Best practices for golden image hygiene

A well-structured image build process prevents common mistakes that lead to security incidents, configuration drift, and operational friction. Follow these guidelines when you customize and maintain golden images:

- **Never bake secrets into images.** Don't embed API keys, connection strings, passwords, certificates' private keys, or tokens in the image. If secrets are present in an image, you expose them to every VM that uses it and to anyone that has read access to Compute Gallery. Instead, retrieve secrets at runtime from [Azure Key Vault](/azure/key-vault/general/overview) by using a [managed identity](/entra/identity/managed-identities-azure-resources/overview).

- **Prefer external configuration over hardcoded values.** Externalize settings that might change between environments or before the next image build, like endpoints, feature flags, regional settings, or log levels. Reserve image customization for settings that are static and universal across all deployments.

- **Minimize the software footprint.** Only install components that every consumer of the image needs. Deploy extra tooling that's specific to a single use case or workload after provisioning by using extensions or configuration management. A smaller footprint reduces the attack surface and the number of components that require patching.

- **Don't store application code or deployment artifacts in the image.** Golden images should provide a secure, compliant OS foundation. Deploy application code separately through continuous integration and continuous delivery (CI/CD) pipelines. This separation keeps the image life cycle and the application life cycle independent.

- **Use deterministic, repeatable build scripts.** Pin package versions in your customization scripts. Avoid commands like `apt-get upgrade` or `yum update` which can produce different images on different build days.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This solution uses managed components that are automatically resilient at a regional level. For more information, see [Design resilient applications for Azure][Design resilient applications for Azure].

You can configure the number of replicas that Compute Gallery stores of each image. A higher number of replicas reduces the risk of throttling when you provision multiple VMs simultaneously. For more information, see [Scaling for Compute Gallery][Scaling for Compute Gallery].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Unless you use a non-Microsoft service like Ansible or Terraform, this approach is nearly free of charge. Storage and egress costs might apply. Other potential charges involve these components:

- Azure Policy and [Azure machine configuration][Azure machine configuration] are free of charge for Azure resources. If your company uses a hybrid approach, Azure Arc resources add extra charges.

- [VM Image Builder][VM Image Builder - pricing] uses a single compute instance type with 1 vCPU and 3.5 GB of RAM. Charges might apply for data storage and transfer.

- [Compute Gallery][Azure Shared Image Galleries] incurs charges only for replica storage and the network egress associated with image replication.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Yunus Emre Alpozen](https://www.linkedin.com/in/yemre) | Program Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure landing zone][Azure landing zone]
- [Introduction to cloud infrastructure][Introduction to cloud infrastructure: Describe Azure management and governance]
- [VM Image Builder][VM Image Builder]
- [Compute Gallery][Compute Gallery]
- [Azure Policy and the policy dashboard][Azure Policy and the policy dashboard]
- [Azure machine configuration][Azure machine configuration]

## Related resources

- [DevTest and DevOps for infrastructure as a service (IaaS) solutions][DevTest and DevOps for IaaS solutions]
- [DevSecOps on AKS][DevSecOps on AKS]

[Compute Gallery]: /azure/virtual-machines/shared-image-galleries
[VM Image Builder]: /azure/virtual-machines/image-builder-overview
[Azure landing zone]: /azure/cloud-adoption-framework/ready/landing-zone/
[Azure machine configuration]: /azure/governance/machine-configuration/overview/01-overview-concepts
[Azure Policy and the policy dashboard]: /azure/governance/policy/overview
[Azure Policy Regulatory Compliance controls for Azure Virtual Machines]: /azure/virtual-machines/security-controls-policy
[Azure Shared Image Galleries]: /azure/virtual-machines/azure-compute-gallery#billing
[VM Image Builder - pricing]: https://azure.microsoft.com/pricing/details/image-builder/
[Bulkhead pattern]: ../../patterns/bulkhead.md
[Introduction to cloud infrastructure: Describe Azure management and governance]: /training/paths/describe-azure-management-governance/
[Custom Script Extensions]: /azure/virtual-machines/extensions/custom-script-windows
[Deployment Stamps pattern]: ../../patterns/deployment-stamp.yml
[Design resilient applications for Azure]: /azure/well-architected/reliability/principles
[DevSecOps on AKS]: ../../guide/devsecops/devsecops-on-aks.yml
[DevTest and DevOps for IaaS solutions]: ../../solution-ideas/articles/dev-test-iaas.yml
[Geode pattern]: ../../patterns/geodes.yml
[Find a Marketplace image version]: /azure/virtual-machines/windows/cli-ps-findimage#view-purchase-plan-properties
[Only allow certain image publishers from Marketplace]: https://github.com/Azure/azure-policy/tree/master/samples/Compute/allowed-image-publishers
[Overview of the reliability pillar]: /azure/well-architected/reliability/
[Scaling for Compute Gallery]: /azure/virtual-machines/azure-compute-gallery#image-versioning
[Store and share images in a Compute Gallery]: /azure/virtual-machines/shared-image-galleries
[Store and share images in a Compute Gallery - Limits]: /azure/virtual-machines/azure-compute-gallery#limits
[Azure landing zone overview]: /azure/cloud-adoption-framework/ready/landing-zone/
