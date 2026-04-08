This article describes a secure research environment that provides researchers access to sensitive data that requires a high level of control and protection. The architecture supports organizations that must adhere to regulatory compliance or other strict security requirements. The recommended approach uses Azure Machine Learning managed compute and Microsoft Fabric for data integration, which reduces infrastructure overhead and strengthens security compared to VM-based approaches.

## Architecture

:::image type="complex" source="_images/secure-compute-for-research.svg" lightbox="_images/secure-compute-for-research.svg" alt-text="Diagram that shows a secure research environment." border="false":::
The diagram shows a secure research environment that spans two resource groups. On the left, data owners upload datasets to a Azure Blob Storage account or to OneLake (step 1). Fabric Data Factory copies this data to a private Blob Storage account or a Fabric Lakehouse that is accessible only through private endpoints or trusted workspace access (step 2). Researchers access the secure environment through a browser by using Azure Machine Learning studio or the Microsoft Foundry portal for most workloads, or Azure Virtual Desktop for workloads that require strict data loss prevention controls (step 3). Within the secure zone, Azure Machine Learning compute instances and serverless compute provide the primary compute resources for data preparation and model training. Data science VMs remain for legacy tools only (step 4). Azure Machine Learning and Fabric Data Science connect to private storage through a managed virtual network with no public IP addresses (step 5). These services also connect to a firewall policy. An arrow extends from private Blob Storage to an approval workflow, which uses Power Automate or Azure Logic Apps, positioned outside the secure environment. The workflow sends notifications to an approver to start a manual review (step 6). After approval, Fabric Data Factory moves approved data back to public storage for external access (steps 7 and 8). Private Blob Storage connects to Azure Key Vault, which stores encryption keys and certificates. Microsoft Entra ID, Microsoft Sentinel, Microsoft Defender for Cloud, Azure Policy, Azure Monitor, and Microsoft Purview reside outside the main architecture and provide identity, security, governance, and observability services.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-compute-for-research.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Data owners upload datasets into a Azure Blob Storage account or into [OneLake](/fabric/onelake/onelake-overview). They use Microsoft-managed keys or customer-managed keys (CMK) to encrypt the data.

1. [Fabric](/fabric/data-factory/data-factory-overview) uses a trigger or a Copy job to move the uploaded dataset to a secure storage location. This location can be a private Blob Storage account that's accessible only through a private endpoint or trusted workspace access, or a [Fabric Lakehouse](/fabric/data-engineering/lakehouse-overview) in a workspace that's protected by managed private endpoints. A service principal or managed identity that has limited permissions accesses the account. Fabric Data Factory deletes the original copy, which makes the dataset immutable. Alternatively, you can use [OneLake shortcuts](/fabric/onelake/onelake-shortcuts-overview) for zero-copy access to data across workspaces.

1. Researchers access the secure environment through a browser. For most workloads, researchers use [Azure Machine Learning studio](https://ml.azure.com) or the [Microsoft Foundry portal](https://ai.azure.com) directly, which provides VS Code for the Web and Jupyter notebooks without a jump box. For workloads that require stricter data loss prevention (DLP) controls, such as blocking copy/paste and screen captures, researchers use [Azure Virtual Desktop](/azure/virtual-desktop) as a privileged jump box.

1. Azure Machine Learning [compute instances](/azure/machine-learning/concept-compute-instance) or [serverless compute](/azure/machine-learning/how-to-use-serverless-compute) provide the compute resources for data preparation and model training. Compute instances have auto-shutdown and no public IP by default. For legacy tools that require specific OS configurations, such as MATLAB or SAS, data science VMs in the secure network provide dedicated compute resources.

1. The secure environment includes Azure Machine Learning and [Fabric Data Science](/fabric/data-science/data-science-overview). They access the dataset through private endpoints or managed virtual network connections. You can use these platforms to train, deploy, automate, and manage machine learning models. At this stage, you can create models that meet regulatory guidelines. To de-identify all model data, remove personal information. Use the [Responsible AI dashboard](/azure/machine-learning/concept-responsible-ai-dashboard) to assess fairness, interpretability, and error analysis before you export models.

1. Models or de-identified data are saved to a separate location on the secure storage account, known as the *export path*. When you add new data to the export path, you trigger an approval workflow. You can use [Power Automate](/power-automate/getting-started) or [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) for this workflow. The workflow runs outside the secure environment because it doesn't receive data. Its only function is to send notifications and start the manual approval process.

    The workflow starts an approval process by requesting a review of data that's queued for export. The manual reviewers help ensure that sensitive data isn't exported. After the review process, reviewers either approve or deny the data. You can complement manual approval with [Microsoft Purview Data Loss Prevention](/purview/dlp-learn-about-dlp) policies for automated policy-based enforcement.

    > [!NOTE]
    > If you don't need to approve data exports, you can skip the approval workflow step.

1. If reviewers approve the de-identified data, the system sends it to Fabric Data Factory.

1. Fabric Data Factory moves the data to the public storage account in a separate container so that external researchers can access their exported data and models. Alternatively, you can set up another storage account in a lower security environment.

### Components

This architecture consists of several Azure services that scale resources according to your needs. The following sections describe these services and their roles.

#### Core workload components

The following core components move and process research data:

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a service that trains, deploys, automates, and manages machine learning models. In this architecture, it provides the primary compute and development environment for researchers. Key capabilities include:

  - [Compute instances](/azure/machine-learning/concept-compute-instance) are managed VMs with auto-shutdown and no public IP by default. They provide researchers with preconfigured development environments that include VS Code for the Web and Jupyter notebooks.
  - [Serverless compute](/azure/machine-learning/how-to-use-serverless-compute) provides on-demand, elastic compute for training jobs without managing infrastructure. Azure Machine Learning handles the lifecycle of these compute resources.
  - [Compute clusters](/azure/machine-learning/concept-compute-target#azure-machine-learning-compute-managed) are multi-node clusters for distributed training and batch inference.
  - [Model registry](/azure/machine-learning/concept-model-management-and-deployment) tracks model versions, lineage, and deployment history.
  - [Azure Machine Learning managed virtual network](/azure/machine-learning/how-to-managed-network) automates network isolation by creating private endpoints and enforcing outbound rules.

  You can also use the [Microsoft Foundry portal](https://ai.azure.com) alongside Machine Learning studio for scenarios that involve large language models.

- [Azure data science VMs](/azure/machine-learning/data-science-virtual-machine/overview) are VMs that you configure with tools for data analytics and machine learning. In this architecture, retain data science VMs only for legacy tools, such as MATLAB or SAS, that Azure Machine Learning compute doesn't support. For most workloads, use Machine Learning compute instances or serverless compute instead.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage solution that stores unstructured data in the cloud. In this architecture, it serves as the primary storage solution, and it has two instances. The public instance temporarily stores the data that data owners upload. It stores de-identified data after it models the data in a separate container. The private instance receives the training and test datasets from Machine Learning. The training scripts use those datasets. The system mounts storage as a virtual drive onto each node of a Machine Learning compute cluster.

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a unified analytics platform that combines data integration, engineering, warehousing, data science, and real-time analytics.

  - [OneLake](/fabric/onelake/onelake-overview) is a single, unified data lake for the entire organization. For new workloads, evaluate OneLake as an alternative to maintaining separate storage accounts. OneLake provides unified governance and supports [shortcuts](/fabric/onelake/onelake-shortcuts-overview) for zero-copy data access across workspaces and [mirroring](/fabric/database/mirrored-database/overview) for real-time data synchronization.
  - [Fabric Lakehouse](/fabric/data-engineering/lakehouse-overview) provides a combined data lake and warehouse experience for structured and semi-structured data, built on Delta Lake format.
  - [Fabric Data Science](/fabric/data-science/data-science-overview) supports Apache Spark workloads and integrates with Machine Learning for end-to-end model development.

- [Fabric Data Factory](/fabric/data-factory/data-factory-overview) is a cloud-based data integration service within Microsoft Fabric that orchestrates and operationalizes data movement and transformation workflows. Fabric Data Factory provides 170+ connectors, Copy jobs, and [Dataflow Gen2](/fabric/data-factory/dataflow-gen2-overview) for data transformation. In this architecture, it moves data between storage accounts that have different security levels, enforces separation of duties, and manages data flows throughout the secure environment.

- [Virtual Desktop](/azure/well-architected/azure-virtual-desktop/overview) is a desktop and app virtualization service that runs in the cloud. In this architecture, use Virtual Desktop when workloads require strict DLP controls, such as blocking copy/paste, preventing screen captures, or streaming legacy Windows applications. For most researcher workflows, direct browser access to Azure Machine Learning studio or Fabric replaces the need for Virtual Desktop.

   Alternatively, you can use [Azure Bastion](/azure/bastion/bastion-overview) for browser-based SSH or RDP to individual VMs. Azure Bastion is better suited for simpler deployments with fewer governance requirements and lower cost for small-scale, occasional access. However, Virtual Desktop provides advantages for secure research:

   - Application streaming for legacy Windows tools
   - Copy, paste, and screen capture restrictions
   - Microsoft Entra authentication with Conditional Access, MFA, and Privileged Identity Management (PIM)
   - Session recording and audit trail

- [Power Automate](/power-automate/getting-started) is a low-code automation service for building approval workflows. In this architecture, it can manage the trigger and release portions of the manual approval process. Power Automate integrates with Microsoft 365 services like Teams and Outlook for approval notifications. Alternatively, you can use [Azure Logic Apps](/azure/logic-apps/logic-apps-overview), which remains valid for organizations that already use it.

#### Security and governance components

The following components help secure your workload:

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a service that evaluates the overall security posture of the implementation and provides an attestation mechanism for regulatory compliance. In this architecture, it helps detect problems early, instead of during audits or assessments. Use features like the secure score and compliance score to track progress. These scores help check compliance. Defender for Cloud also provides [AI security posture management](/azure/defender-for-cloud/ai-security-posture) and [AI threat protection](/azure/defender-for-cloud/ai-threat-protection), which are relevant to machine learning research environments. You can access Defender for Cloud through the [unified Microsoft Defender portal](https://security.microsoft.com).

- [Microsoft Sentinel](/azure/sentinel/overview) is a security information and event management (SIEM) solution and a security orchestration, automation, and response (SOAR) solution. Microsoft Sentinel is part of the [unified security operations platform](/azure/sentinel/microsoft-sentinel-defender-portal) in the Microsoft Defender portal. In this architecture, it centralizes logs, detects threats, and automates security responses for the research environment. Use anomaly detection to identify suspicious data access or export activities.

- [Azure Monitor](/azure/azure-monitor/overview) is a monitoring solution that collects, analyzes, and responds to telemetry data from cloud and on-premises environments. In this architecture, it collects and visualizes metrics, activity logs, and diagnostics to support operational monitoring and incident detection. Configure query-based alerts for suspicious export patterns.

- [Azure Policy](/azure/governance/policy/overview) is a governance tool that enforces organizational standards and assesses compliance at scale. In this architecture, it helps ensure that resources and workloads adhere to security and configuration policies.

- [Microsoft Purview](/purview/purview) provides unified data governance across Fabric and Azure Machine Learning. Use Purview for [data loss prevention (DLP)](/purview/dlp-learn-about-dlp) policies that complement approval workflows, and apply [sensitivity labels](/purview/sensitivity-labels) for data classification across workspaces.

- [Responsible AI tools in Azure Machine Learning](/azure/machine-learning/concept-responsible-ai) include fairness assessment, error analysis, and model interpretability. Use the [Responsible AI dashboard](/azure/machine-learning/concept-responsible-ai-dashboard) and [scorecard](/azure/machine-learning/concept-responsible-ai-scorecard) to assess models before deployment and to communicate findings to stakeholders. These tools help meet EU AI Act and NIST AI Risk Management Framework requirements.

### Alternatives

- **Compute**: This solution uses Azure Machine Learning managed compute as the primary environment. If researchers need legacy scientific software (MATLAB, SAS, Stata) or Windows-only GUI applications, retain data science VMs for those specific workloads. For all other scenarios, Azure Machine Learning compute instances with custom environments or Docker containers replace VMs.

- **Data platform**: This solution uses Fabric Lakehouse with OneLake for data integration. If you require strict isolation for individual datasets, retain separate private Blob Storage accounts. Evaluate OneLake shortcuts and mirroring for zero-copy data access to reduce data duplication.

- **Data movement**: This solution uses Fabric Data Factory to move data between storage tiers. You can use Fabric Data Factory to transfer data to a public storage account in a separate container or set up another storage account in a lower security environment for the same purpose.

- **Access**: This solution uses browser-based access to Azure Machine Learning studio and Fabric for most researchers. If your organization requires strict DLP controls, such as blocking copy/paste and screen captures, use Virtual Desktop as a jump box. For occasional VM access without DLP requirements, Azure Bastion provides a lower-cost alternative. Also consider configuring a point-to-site virtual private network (VPN) to support local offline training.

- **Approval workflow**: This solution supports Power Automate or Azure Logic Apps. Power Automate integrates with Microsoft 365, including Teams-based approvals. Logic Apps is appropriate if you already have Logic Apps deployments. You can also use Fabric Data Factory pipeline approval activities as part of the orchestration.

- **Egress controls**: In addition to the managed virtual network's outbound rules, add [Microsoft Purview DLP](/purview/dlp-learn-about-dlp) policies for application-level data loss prevention. This combination provides defense in depth: network-level, application-level, and policy-level controls.

- **Encryption**: To secure data at rest, this solution encrypts all Azure Storage accounts with Microsoft-managed keys by using strong cryptography. For HIPAA and FedRAMP workloads, use customer-managed keys (CMK) via [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview) or Azure Key Vault Premium with HSM-backed keys. Enable [automatic key rotation](/azure/key-vault/keys/how-to-configure-key-rotation) in Key Vault.

## Scenario details

This scenario combines regulated and private data that individuals must access but aren't allowed to store or transmit. The following conditions apply:

- Data scientists outside your organization need full access to the data to train and export their models, but no proprietary or protected data can leave the environment.

- You must isolate access. Even the data owners and custodians can't access the data after it's uploaded into the environment.
- You must require an audit trail for exports to ensure that only the models are transferred out of the environment.

### Potential use cases

This architecture was originally created for higher education research institutions that have Health Insurance Portability and Accountability Act (HIPAA) requirements. You can use this design in any industry that requires data isolation for research purposes. For workloads that require the highest level of data confidentiality, consider [Azure confidential VMs](/azure/confidential-computing/confidential-vm-overview), which use hardware-based trusted execution environments to protect data in use, even from cloud operators. Consider the following examples:

- Industries that process regulated data in accordance with National Institute of Standards and Technology (NIST) requirements or the EU AI Act
- Medical centers that collaborate with internal or external researchers
- Banking and finance industries
- Organizations that must comply with ISO/IEC 42001 for AI management systems

Follow the guidance in this article to maintain full control of your research data, maintain separation of duties, and meet strict regulatory compliance standards. This approach also facilitates collaboration among key roles in a research-oriented environment, like data owners, researchers, and approvers.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Most research solutions consist of temporary workloads that don't need to remain available for extended periods. This architecture uses a single-region deployment with availability zones. If your business requirements demand higher availability, replicate this architecture in multiple regions. Add components, like a global load balancer and distributor, to route traffic to those regions. As part of your recovery strategy, use Azure VM Image Builder to capture and create a copy of the customized base image.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The main objective of this architecture is to provide a secure and trusted research environment that strictly limits data exfiltration from the secure area. This architecture uses defense in depth: network-level isolation, application-level DLP policies, and manual approval workflows combine to prevent unauthorized data export.

#### Network security

The recommended approach is to use [Azure Machine Learning managed virtual networks](/azure/machine-learning/how-to-managed-network). A managed virtual network automates network isolation for the workspace and managed computes, including automatic private endpoint creation for dependent resources (Storage, Key Vault, Container Registry). Configure the managed virtual network with the **Allow only approved outbound** mode for maximum data exfiltration protection. In this mode, you must explicitly approve each outbound connection through managed private endpoints or FQDN rules.

Key capabilities of managed virtual networks:

- No public IP addresses by default for compute instances and clusters.
- Automatic private endpoint provisioning for workspace resources.
- [Managed private endpoints](/azure/machine-learning/how-to-managed-network#configure-a-managed-virtual-network-to-allow-only-approved-outbound) for external Azure resources and on-premises resources (via VPN Gateway).
- Integration with Azure Policy for compliance enforcement.

If you use a custom virtual network instead of a managed virtual network, configure NSG rules to restrict access:

- Inbound and outbound access to the public internet and within the virtual network.

- Access to and from specific services and ports. For example, this architecture blocks all port ranges except the ones required for Azure services, like Azure Monitor. For a full list of service tags and the corresponding services, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).

    Access from the virtual network that includes Virtual Desktop is restricted to approved access methods on specific ports, but all other traffic is denied.

The main Blob Storage instance in the secure environment isn't exposed to the public internet. You can access it only within the virtual network through [private endpoint connections](/azure/storage/files/storage-files-networking-endpoints) and Storage firewalls. Use these controls to limit the networks that clients can use to connect to file shares in Azure Files.

When you use Fabric for data integration, enable [private links at the tenant or workspace level](/fabric/security/security-private-links-overview) and use [managed private endpoints](/fabric/security/security-managed-private-endpoints-overview) to secure connections between Fabric and Azure resources.

For compute instances and clusters, enable the **No public IP** setting. For more information, see [Compute instance and cluster or serverless compute with no public IP address](/azure/machine-learning/how-to-secure-training-vnet#compute-instancecluster-or-serverless-compute-with-no-public-ip).

You can configure Azure Firewall to control both inbound and outbound access to Machine Learning compute, which resides in a machine learning workspace. Use Azure Firewall or FQDN-based rules only when the managed virtual network's "allow only approved outbound" mode requires URL or domain filtering. For more information, see [Configure inbound and outbound network traffic](/azure/machine-learning/how-to-access-azureml-behind-firewall).

> [!IMPORTANT]
> Default outbound internet access for Azure VMs was retired on September 30, 2025. Configure an explicit outbound method, such as NAT Gateway or Azure Firewall, for any VMs that require internet access.

For more information, see [Network security overview for Azure Machine Learning](/azure/machine-learning/how-to-network-security-overview).

#### Identity management

This architecture implements multiple layers of identity-based security controls. You can access Blob Storage through Azure role-based access control (Azure RBAC). Virtual Desktop supports Microsoft Entra authentication with Conditional Access, MFA, and Privileged Identity Management (PIM), which adds an extra security layer for researcher access.

Fabric Data Factory uses [trusted workspace access](/fabric/security/security-trusted-workspace-access) to securely connect to data in Blob Storage accounts. This approach uses the workspace's managed identity to bypass firewall restrictions and access protected storage without requiring public network exposure.

Use identity-based data access where possible, rather than credential-based authentication. With identity-based access, use your Microsoft Entra account to confirm whether you have access to Storage, without saving authentication credentials. For more information, see [Create data stores](/azure/machine-learning/how-to-datastore).

#### Data security

To secure data at rest, Microsoft-managed keys encrypt all Storage accounts by using strong cryptography.

For HIPAA, FedRAMP, or other compliance frameworks that require customer-managed encryption, use customer-managed keys (CMK). Store the keys in [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview) for the highest assurance or Azure Key Vault Premium with HSM-backed keys. Enable [automatic key rotation](/azure/key-vault/keys/how-to-configure-key-rotation) to reduce operational risk. In this architecture, you deploy Azure Key Vault in the secure environment to store secrets like encryption keys and certificates. Resources in the secure virtual network access Key Vault through a private endpoint.

Apply [sensitivity labels](/purview/sensitivity-labels) from Microsoft Purview to classify datasets and models across Fabric and Azure Machine Learning workspaces. Enforce sensitivity label policies via Azure Policy.

### Governance considerations

Enable Azure Policy to enforce standards and provide automated remediation to make resources compliant with specific policies. You can apply the policies to a project subscription or at a management group level, either as a single policy or as part of a regulatory initiative.

For VMs that remain in the architecture, [Azure Machine Configuration](/azure/governance/machine-configuration/overview/01-overview-concepts) applies to all in-scope VMs. The policy can audit operating systems and machine configuration for the data science VMs.

Use the [Responsible AI framework in Azure Machine Learning](/azure/machine-learning/concept-responsible-ai) to govern model development:

- Generate [Responsible AI dashboards](/azure/machine-learning/concept-responsible-ai-dashboard) during model development. Assess fairness, interpretability, and error analysis before you approve models for export.
- Use [Responsible AI scorecards](/azure/machine-learning/concept-responsible-ai-scorecard) to communicate model assessments to stakeholders and regulatory reviewers as part of the approval workflow.
- Register models in the [Azure Machine Learning model registry](/azure/machine-learning/concept-model-management-and-deployment) with lineage tracking. Track model versions, deployment decisions, and approvals for audit purposes.

Use [Microsoft Purview](/purview/purview) for unified data governance across Fabric and Azure Machine Learning. Purview provides data catalog, classification, and lineage tracking. Apply sensitivity labels to datasets and models so that security policies travel with the data.

Enable [workspace monitoring](/fabric/admin/monitoring-workspace) in both Azure Machine Learning and Fabric. Track job execution, compute utilization, pipeline status, and data access patterns. Configure Azure Monitor alerts for critical events, such as export requests, model deployments, and anomalous access patterns. Integrate these signals with Microsoft Sentinel for unified security operations.

### Compute environments

For Azure Machine Learning compute instances and clusters, use [custom environments](/azure/machine-learning/how-to-manage-environments-v2) or Docker containers to define the software dependencies that researchers need. Custom environments are version-controlled and reproducible, and they don't require manual image management.

If you retain data science VMs for legacy tools, they run customized base images. To build the base image, use technologies like VM Image Builder. You can create a repeatable image to deploy when needed. The base image might need updates, like extra binaries. Upload those binaries to the public Blob Storage instance. They should flow through the secure environment, similar to how data owners upload the datasets.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This architecture reduces idle compute costs by using managed compute with built-in cost controls:

- **Serverless compute** charges only for the duration of training jobs, with no idle costs. Use serverless compute for workloads with variable or unpredictable demand.
- **Compute instance auto-shutdown** automatically stops instances after a configurable idle timeout. Set auto-shutdown policies for all compute instances.
- **Fabric capacity** offers pay-as-you-go and reserved capacity pricing. Reserved capacity provides discounts for committed usage. Dataflow Gen2 uses tiered pricing that reduces per-unit cost for longer-running jobs.
- **Managed virtual networks** incur no additional cost compared to custom virtual networks and reduce operational overhead.

If you retain data science VMs, their cost depends on the underlying VM series. Shut down VMs when not in use. For approval workflows, use the Consumption plan for Logic Apps or evaluate Power Automate licensing based on volume.

To estimate costs based on the estimated sizing of resources that you need, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Monitor costs by using Azure Cost Management and Fabric capacity metrics.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Azure Machine Learning managed compute provides elastic scaling that matches resource allocation to workload demand:

- **Compute clusters** automatically scale nodes based on the number of queued jobs. Set minimum and maximum node counts to control costs and performance.
- **Serverless compute** provides on-demand resources without capacity planning. Azure Machine Learning allocates and releases compute based on job requirements.
- **OneLake shortcuts** and **mirroring** provide zero-copy access to data, which reduces data movement latency and duplication.

If you retain data science VMs, choose the appropriate size and type for the style of work that researchers do. Some GPU VM series, such as NCv3, have been retired. Verify that you select a currently supported VM series for GPU workloads. For the latest list of supported VM series, see [Supported VM series and sizes](/azure/machine-learning/concept-compute-target#supported-vm-series-and-sizes).

This architecture supports a single research project. To achieve scalability, use Azure Machine Learning workspaces and Fabric workspaces to isolate projects and allocate compute resources independently.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Clayton Barlow](https://www.linkedin.com/in/clayton-b-barlow) | Senior Azure Specialist

Other contributor:

- [Tincy Elias](https://www.linkedin.com/in/tincy-elias/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Azure Machine Learning managed virtual network](/azure/machine-learning/how-to-managed-network)
- [Use serverless compute in Azure Machine Learning](/azure/machine-learning/how-to-use-serverless-compute)
- [What are compute targets in Machine Learning?](/azure/machine-learning/concept-compute-target)
- [Responsible AI overview for Azure Machine Learning](/azure/machine-learning/concept-responsible-ai)
- [What is Microsoft Fabric?](/fabric/fundamentals/microsoft-fabric-overview)
- [What is OneLake?](/fabric/onelake/onelake-overview)
- [What is Fabric Data Factory?](/fabric/data-factory/data-factory-overview)
- [Private links in Fabric](/fabric/security/security-private-links-overview)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Virtual Desktop?](/azure/virtual-desktop/overview)
- [Defender for Cloud documentation](/azure/defender-for-cloud)
- [What is Microsoft Sentinel SIEM?](/azure/sentinel/overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [What is Azure Policy?](/azure/governance/policy/overview)
- [Microsoft Purview documentation](/purview/purview)
- [What is the data science VM for Linux and Windows?](/azure/machine-learning/data-science-virtual-machine/overview)
- [Default outbound access for VMs in Azure](/azure/virtual-network/ip-services/default-outbound-access)

## Related resources

- [Compare Microsoft machine learning products and technologies](../guide/data-science-and-machine-learning.md)
- [Use the many-models architecture approach to scale machine learning models](../idea/many-models-machine-learning-azure-machine-learning.yml)
