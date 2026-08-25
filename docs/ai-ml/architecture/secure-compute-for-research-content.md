This article describes a secure research environment that gives researchers access to sensitive data that requires a high level of control and protection. The architecture supports organizations that must adhere to regulatory compliance or other strict security requirements. The recommended approach uses Azure Machine Learning managed compute paired with Microsoft Fabric Data Science for analytics, private Azure Blob Storage for governed data storage, and Azure Virtual Desktop as a privileged jump box for researcher access. Managed virtual networks and private endpoints keep all compute and analytics traffic private, and the architecture uses no public IP addresses on compute resources.

## Architecture

:::image type="complex" source="_images/secure-compute-for-research.svg" lightbox="_images/secure-compute-for-research.svg" alt-text="Diagram that shows a secure research environment." border="false":::
The diagram shows a secure research environment that spans two resource groups. On the left, in step 1, data owners upload datasets to an ingress Azure Blob Storage account. In step 2, Fabric Data Factory copies the data to a private Blob Storage account that you can access only through a private endpoint, then deletes the original copy. In step 3, researchers connect to the secure environment via Azure Virtual Desktop, which serves as a privileged jump box and enforces Conditional Access, MFA, and data loss prevention controls. In step 4, in the Azure Virtual Desktop session, Azure Machine Learning compute instances and serverless compute provide the primary compute resources for data preparation and model training. Data science VMs remain for legacy tools only. In step 5, Machine Learning and Fabric Data Science work together as the analytics platform and connect to the private Blob Storage account through managed private endpoints in the Machine Learning managed virtual network. Neither service uses a public IP address. In step 6, an arrow extends from private Blob Storage to an approval workflow, which uses Power Automate or Azure Logic Apps and is located outside the secure environment. The workflow sends notifications to an approver to start a manual review. After approval, in steps 7 and 8, Fabric Data Factory moves the de-identified data to a separate egress storage account that external consumers can access. Private Blob Storage and Azure Machine Learning connect to Azure Key Vault, which stores encryption keys and certificates. Microsoft Entra ID, Microsoft Sentinel, Microsoft Defender for Cloud, Azure Policy, Azure Monitor, and Microsoft Purview reside outside the main architecture and provide identity, security, governance, and observability services.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-compute-for-research.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Data owners upload datasets into an ingress Azure Blob Storage account. They use Microsoft-managed keys or customer-managed keys (CMK) to encrypt the data.

1. [Fabric Data Factory](/fabric/data-factory/data-factory-overview) uses a trigger or a Copy job to move the uploaded dataset to a private Azure Blob Storage account that can be accessed only through a private endpoint. A managed identity with limited permissions accesses the account. Data Factory deletes the original copy in the ingress account. This deletion makes the dataset immutable.

1. Researchers connect to the secure environment through [Azure Virtual Desktop](/azure/virtual-desktop), which serves as a privileged jump box. Azure Virtual Desktop enforces Microsoft Entra authentication with Conditional Access, multifactor authentication (MFA), and Privileged Identity Management (PIM). It also enforces data loss prevention (DLP) controls, like blocking copy/paste and screen captures, and provides session-level audit logs.

1. In the Azure Virtual Desktop session, researchers use [Azure Machine Learning studio](https://ml.azure.com). Azure Machine Learning [compute instances](/azure/machine-learning/concept-compute-instance) and [serverless compute](/azure/machine-learning/how-to-use-serverless-compute) provide the compute resources for data preparation and model training. By default, compute instances are configured with autoshutdown and don't have public IPs. For legacy tools that require specific OS configurations, such as MATLAB or SAS, data science VMs in the secure network provide dedicated compute resources.

1. Azure Machine Learning and [Data Science](/fabric/data-science/data-science-overview) work together as the analytics platform. Data Science provides the environment where researchers prepare research data for AI and machine learning. Azure Machine Learning provides the environment where researchers train, track, manage, and govern machine learning models by using the prepared datasets from Data Science. Both services access the private Blob Storage account through private endpoints. Azure Machine Learning connects through its [managed virtual network](/azure/machine-learning/how-to-managed-network), and Data Science connects through [Fabric managed private endpoints](/fabric/security/security-managed-private-endpoints-overview) configured at the workspace level. Neither service uses a public IP address. The storage account must approve both private endpoint connections. To de-identify all model data, remove personal information. Use the [Responsible AI dashboard](/azure/machine-learning/concept-responsible-ai-dashboard) to assess fairness, interpretability, and error analysis before you export models. Models or de-identified data are saved to a separate location on the private Blob Storage account. This location is known as the *export path*.

1. When you add new data to the export path, you trigger an approval workflow. You can use [Power Automate](/power-automate/getting-started) or [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) for this workflow. The workflow runs outside the secure environment because it doesn't receive data. Its only function is to send notifications and start the manual approval process.

    The workflow starts an approval process by requesting a review of data that's queued for export. Reviewers help ensure that sensitive data isn't exported. After the review process, reviewers either approve or deny the data export. You can complement manual approval with [Microsoft Purview Data Loss Prevention](/purview/dlp-learn-about-dlp) policies for automated policy-based enforcement.

    > [!NOTE]
    > If you don't need to approve data exports, you can skip the approval workflow step.

1. If reviewers approve the de-identified data, the system sends the de-identified data to Data Factory.

1. Data Factory moves the data to a separate egress Blob Storage account in a lower-security environment so that external researchers can access their exported data and models.

### Components

This architecture consists of several Azure services that scale resources according to your needs. The following sections describe these services and their roles.

#### Core workload components

The following core components move and process research data:

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a service that trains, deploys, automates, and manages machine learning models. In this architecture, it provides the primary compute and development environment for researchers. Key capabilities include:

  - [Compute instances](/azure/machine-learning/concept-compute-instance) are managed VMs that are configured with autoshutdown, by default. They also don't have public IP addresses, by default. They provide researchers with preconfigured development environments that include Visual Studio Code for the Web and Jupyter notebooks.

  - [Serverless compute](/azure/machine-learning/how-to-use-serverless-compute) provides on-demand, elastic compute that you can use to train jobs without managing infrastructure. Azure Machine Learning handles the lifecycle of these compute resources.
  - [Compute clusters](/azure/machine-learning/concept-compute-target#azure-machine-learning-compute-managed) are multinode clusters for distributed training and batch inference.
  - [Model registry](/azure/machine-learning/concept-model-management-and-deployment) tracks model versions, lineage, and deployment history.
  - [Azure Machine Learning managed virtual network](/azure/machine-learning/how-to-managed-network) automates network isolation by creating private endpoints and enforcing outbound rules.

- [Data Science](/fabric/data-science/data-science-overview) supports Apache Spark workloads and integrates with Azure Machine Learning for end-to-end model development. In this architecture, it works alongside Azure Machine Learning as a paired analytics platform. It provides a Spark-based environment for distributed data processing, and Azure Machine Learning provides compute, model registry, and Responsible AI tooling. Data Science accesses the private Blob Storage account via [Fabric managed private endpoints](/fabric/security/security-managed-private-endpoints-overview).

- [Data Science Virtual Machine (DSVM)](/azure/machine-learning/data-science-virtual-machine/overview) is a VM image that you configure with tools for data analytics and machine learning. In this architecture, retain DSVM images only for legacy tools, such as MATLAB or SAS, that Azure Machine Learning compute doesn't support. For most workloads, use Machine Learning compute instances or serverless compute instead.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage solution that stores unstructured data in the cloud. In this architecture, it serves as the primary storage solution and is deployed as three instances:

  - The **ingress instance** temporarily holds the data that data owners upload. Data Factory copies the data into the secure environment and deletes the original.

  - The **private instance** is the only storage that Azure Machine Learning and Data Science access. It's reachable only through private endpoints and stores both the training/test datasets and the de-identified models in the export path.
  - The **egress instance** is a separate, lower-security account in another resource group. Data Factory writes approved exports to this account through a private endpoint. External researchers retrieve their results through a private endpoint that's provisioned in their own virtual network.

  All three instances use private endpoints. Compute instances access the private instance through Azure Machine Learning datastores, which provide mount-based access to blob containers. Compute clusters access datasets as job inputs in mount or download mode during job execution.

- [Data Factory](/fabric/data-factory/data-factory-overview) is a cloud-based data integration service in Fabric that orchestrates and operationalizes data movement and transformation workflows. Data Factory provides more than 170 connectors, Copy jobs, and [Dataflow Gen2](/fabric/data-factory/dataflows-gen2-overview) for data transformation. In this architecture, it moves data between the ingress, private, and egress Blob Storage accounts, enforces separation of duties, and manages data flows throughout the secure environment.

- [Azure Virtual Desktop](/azure/well-architected/azure-virtual-desktop/overview) is a desktop and app virtualization service that runs in the cloud. In this architecture, Azure Virtual Desktop is the primary access path for researchers and serves as a privileged jump box into the secure environment. Azure Virtual Desktop provides:

   - Microsoft Entra authentication with Conditional Access, MFA, and PIM.
   - DLP controls, including copy and paste and screen capture restrictions.
   - Application streaming for legacy Windows tools.
   - Audit support via sign-in, connection, and monitoring logs.

- [Power Automate](/power-automate/getting-started) is a low-code automation service for building approval workflows. In this architecture, it manages the trigger and release portions of the manual approval process. Power Automate integrates with Microsoft 365 services like Teams and Outlook for approval notifications. Power Automate is a service in Microsoft Power Platform that doesn't provide virtual network integration. The approval workflow runs outside the secure environment because Power Automate can't access private network resources.

#### Security and governance components

The following components help secure your workload:

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a service that evaluates the overall security posture of the implementation and provides an attestation mechanism for regulatory compliance. In this architecture, it helps detect problems early, instead of during audits or assessments. Use features like the secure score and compliance score to track progress. These scores help check compliance. Defender for Cloud also provides [AI security posture management](/azure/defender-for-cloud/ai-security-posture) and [AI threat protection](/azure/defender-for-cloud/ai-threat-protection), which are relevant to machine learning research environments. You can access Defender for Cloud via the [unified Microsoft Defender portal](https://security.microsoft.com).

- [Microsoft Sentinel](/azure/sentinel/overview) is a security information and event management (SIEM) solution and a security orchestration, automation, and response (SOAR) solution. Microsoft Sentinel is part of the [unified security operations platform](/azure/sentinel/microsoft-sentinel-defender-portal) in the Microsoft Defender portal. In this architecture, it centralizes logs, detects threats, and automates security responses for the research environment. Use anomaly detection to identify suspicious data access or export activities.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring solution that collects, analyzes, and responds to telemetry data from cloud and on-premises environments. In this architecture, it collects and visualizes metrics, activity logs, and diagnostics to support operational monitoring and incident detection. Configure query-based alerts for suspicious export patterns.

- [Azure Policy](/azure/governance/policy/overview) is a governance tool that enforces organizational standards and assesses compliance at scale. In this architecture, it helps ensure that resources and workloads adhere to security and configuration policies.

- [Microsoft Purview](/purview/purview) provides unified data governance across Fabric and Azure Machine Learning. Use Microsoft Purview for [DLP](/purview/dlp-learn-about-dlp) policies that complement approval workflows, and apply [sensitivity labels](/purview/sensitivity-labels) for data classification across workspaces.

- [Responsible AI tools in Azure Machine Learning](/azure/machine-learning/concept-responsible-ai) include fairness assessment, error analysis, and model interpretability. Use the [Responsible AI dashboard](/azure/machine-learning/concept-responsible-ai-dashboard) and [scorecard](/azure/machine-learning/concept-responsible-ai-scorecard) to assess models before deployment and to communicate findings to stakeholders. These tools help meet EU AI Act and NIST AI Risk Management Framework requirements.

### Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and their trade-offs.

- **Data store:** The recommended path uses private blob storage. If your organization standardizes on Fabric, you can use [OneLake](/fabric/onelake/onelake-overview) and a [Fabric lakehouse](/fabric/data-engineering/lakehouse-overview) instead of Blob Storage. OneLake provides unified governance, [shortcuts](/fabric/onelake/onelake-shortcuts) for zero-copy access across workspaces, and [mirroring](/fabric/mirroring/overview) for real-time synchronization. Protect Fabric workspaces with [private links](/fabric/security/security-private-links-overview) and [managed private endpoints](/fabric/security/security-managed-private-endpoints-overview), and use [trusted workspace access](/fabric/security/security-trusted-workspace-access) when Fabric needs to read from firewalled blob storage.

    > [!NOTE]
    > OneLake shortcuts to Azure Data Lake Storage or Blob Storage don't currently support managed private endpoints.

- **AI platform:** The recommended path uses Azure Machine Learning paired with Data Science for traditional model training, experiment tracking, and compute management. For workloads that are centered on agent orchestration, retrieval-augmented generation, or large language model inferencing and tool calls, use the [Microsoft Foundry portal](https://ai.azure.com) instead. Foundry can be deployed in the same secure pattern with private endpoints and a managed virtual network.

- **Researcher access:** The recommended path uses Azure Virtual Desktop as a privileged jump box because the security model emphasizes DLP and audit. If your organization doesn't require copy/paste blocking, screen capture restrictions, or session-level audit, you can replace Azure Virtual Desktop with direct browser access to Azure Machine Learning studio over a private endpoint. For occasional VM access without DLP requirements, [Azure Bastion](/azure/bastion/bastion-overview) provides browser-based SSH or RDP at a lower cost. You can also configure a point-to-site VPN for network connectivity to workspace resources. Note that local training downloads data to the researcher's device, which removes all cloud-based exfiltration controls. Restrict this option to nonregulated workloads or managed devices with endpoint DLP.

- **Compute:** The recommended path uses Azure Machine Learning compute instances and serverless compute. Retain DSVM only for legacy scientific software (MATLAB, SAS, Stata) or Windows-only GUI applications that managed compute can't host.

- **Approval workflow:** The recommended path uses Power Automate for Microsoft 365 and Teams-based approvals. [Logic Apps](/azure/logic-apps/logic-apps-overview) is appropriate if your organization already standardizes on it. You can also use Data Factory pipeline approval activities as part of the orchestration.

- **Egress controls:** In addition to the managed virtual network's outbound rules, add [Microsoft Purview DLP](/purview/dlp-learn-about-dlp) policies for application-level data loss prevention. This combination provides defense in depth across network, application, and policy controls.

- **Encryption:** The recommended path encrypts all Azure Storage accounts with Microsoft-managed keys by using strong cryptography. For HIPAA, FedRAMP, or other compliance frameworks that require customer-managed encryption, use customer-managed keys (CMK) via [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview) or Key Vault Premium with HSM-backed keys. Enable [automatic key rotation](/azure/key-vault/keys/how-to-configure-key-rotation) in Key Vault.

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

The main objective of this architecture is to provide a secure and trusted research environment that strictly limits data exfiltration from the secure area. This architecture uses defense in depth to prevent unauthorized data export through network-level isolation, application-level DLP policies, and manual approval workflows.

#### Network security

The recommended approach is to use [Azure Machine Learning managed virtual networks](/azure/machine-learning/how-to-managed-network). A managed virtual network automates network isolation for the workspace and managed computes, including automatic private endpoint creation for dependent resources (Storage, Key Vault, Azure Container Registry). Configure the managed virtual network with the **allow only approved outbound** mode for maximum data exfiltration protection. In this mode, you must explicitly approve each outbound connection by using managed private endpoints or FQDN rules.

Key capabilities of managed virtual networks:

- No public IP addresses by default for compute instances and clusters.

- Automatic private endpoint provisioning for workspace resources.

- [Managed private endpoints](/azure/machine-learning/how-to-managed-network#configure-a-managed-virtual-network-to-allow-only-approved-outbound) for Private Link-capable Azure resources. For on-premises resources, expose the service through a [Private Link service](/azure/private-link/private-link-service-overview) fronted by a Standard Load Balancer, then create a managed private endpoint targeting the Private Link service. Alternatively, use a customer-managed virtual network with Azure VPN Gateway instead of the managed virtual network.

- Integration with Azure Policy for compliance enforcement.

If you use a custom virtual network instead of a managed virtual network, configure NSG rules to restrict access:

- Inbound and outbound access to the public internet and within the virtual network.

- Access to and from specific services and ports. For example, this architecture blocks all port ranges except the ones required for Azure services, like Azure Monitor. For a full list of service tags and the corresponding services, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).

    Access from the virtual network that includes Azure Virtual Desktop is restricted to approved access methods on specific ports, but all other traffic is denied.

The main Blob Storage instance in the secure environment isn't exposed to the public internet. You can access it only within the virtual network through [private endpoint connections](/azure/storage/files/storage-files-networking-endpoints) and Storage firewalls. Use these controls to limit the networks that clients can use to connect to file shares in Azure Files.

Enable [private links at the tenant or workspace level](/fabric/security/security-private-links-overview) for Fabric, and use [managed private endpoints](/fabric/security/security-managed-private-endpoints-overview) to secure connections between Data Science, Data Factory, and Azure resources.

For compute instances and clusters, enable the **No public IP** setting. For more information, see [Compute instance and cluster or serverless compute with no public IP address](/azure/machine-learning/how-to-secure-training-vnet#compute-instancecluster-or-serverless-compute-with-no-public-ip).

You can configure Azure Firewall to control both inbound and outbound access to machine learning compute, which resides in a machine learning workspace. Use Azure Firewall or FQDN-based rules only when the managed virtual network's **allow only approved outbound** mode requires URL or domain filtering. For more information, see [Configure inbound and outbound network traffic](/azure/machine-learning/how-to-access-azureml-behind-firewall).

> [!IMPORTANT]
> Default outbound internet access for Azure VMs was retired on September 30, 2025. Configure an explicit outbound method, such as Azure NAT Gateway or Azure Firewall, for any VMs that require internet access.

For more information, see [Network security overview for Azure Machine Learning](/azure/machine-learning/how-to-network-security-overview).

#### Identity management

This architecture implements multiple layers of identity-based security controls. You can access Blob Storage through Azure role-based access control (RBAC). Virtual Desktop supports Microsoft Entra authentication with Conditional Access, MFA, and PIM, which adds an extra security layer for researcher access.

Data Factory uses [trusted workspace access](/fabric/security/security-trusted-workspace-access) to securely connect to data in Blob Storage accounts. This approach uses the workspace identity (a service principal) to bypass firewall restrictions and access protected storage without requiring public network exposure.

Use identity-based data access where possible, rather than credential-based authentication. With identity-based access, use your Microsoft Entra account to confirm whether you have access to Storage, without saving authentication credentials. For more information, see [Create data stores](/azure/machine-learning/how-to-datastore).

#### Data security

To secure data at rest, Microsoft-managed keys encrypt all Storage accounts by using strong cryptography.

For HIPAA, FedRAMP, or other compliance frameworks that require customer-managed encryption, use CMK. Store the keys in [Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview) for the highest assurance, or use Key Vault Premium with HSM-backed keys. Enable [automatic key rotation](/azure/key-vault/keys/how-to-configure-key-rotation) to reduce operational risk. In this architecture, you deploy Key Vault in the secure environment to store secrets like encryption keys and certificates. Resources in the secure virtual network access Key Vault through a private endpoint.

Apply [sensitivity labels](/purview/sensitivity-labels) from Microsoft Purview to classify datasets and models across Fabric and Azure Machine Learning workspaces. Enforce sensitivity label policies via Azure Policy.

### Governance considerations

Enable Azure Policy to enforce standards and provide automated remediation to make resources compliant with specific policies. You can apply the policies to a project subscription or at a management group level, either as a single policy or as part of a regulatory initiative.

For VMs that remain in the architecture, [Azure Machine Configuration](/azure/governance/machine-configuration/overview/01-overview-concepts) applies to all in-scope VMs. The policy can audit operating systems and machine configuration for the data science VMs.

Use the [Responsible AI framework in Azure Machine Learning](/azure/machine-learning/concept-responsible-ai) to govern model development:

- Generate [Responsible AI dashboards](/azure/machine-learning/concept-responsible-ai-dashboard) during model development. Assess fairness, interpretability, and error analysis before you approve models for export.

- Use [Responsible AI scorecards](/azure/machine-learning/concept-responsible-ai-scorecard) to communicate model assessments to stakeholders and regulatory reviewers as part of the approval workflow.

- Register models in the [Azure Machine Learning model registry](/azure/machine-learning/concept-model-management-and-deployment) with lineage tracking. Track model versions, deployment decisions, and approvals for audit purposes.

Use [Microsoft Purview](/purview/purview) for unified data governance across Fabric and Azure Machine Learning. Microsoft Purview provides data catalog, classification, and lineage tracking. Apply sensitivity labels to datasets and models so that security policies travel with the data.

Enable [workspace monitoring](/fabric/admin/monitoring-workspace) in Fabric. For Azure Machine Learning, use its monitoring capabilities together with Azure Monitor to track job execution, compute utilization, pipeline status, and data access patterns. Configure Azure Monitor alerts for critical events, such as export requests, model deployments, and anomalous access patterns. Integrate these signals with Microsoft Sentinel for unified security operations.

### Compute environments

For Azure Machine Learning compute instances and clusters, use [custom environments](/azure/machine-learning/how-to-manage-environments-v2) or Docker containers to define the software dependencies that researchers need. Custom environments are version-controlled and reproducible, and they don't require manual image management.

If you retain data science VMs for legacy tools, they run customized base images. To build the base image, use technologies like VM Image Builder. You can create a repeatable image to deploy when needed. The base image might need updates, like extra binaries. Upload those binaries to the ingress Blob Storage account. They should flow through the secure environment, similar to how data owners upload the datasets.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This architecture reduces idle compute costs by using managed compute with built-in cost controls:

- **Serverless compute** charges only for the duration of training jobs, with no idle costs. Use serverless compute for workloads that have variable or unpredictable demand.

- **Compute instance autoshutdown** automatically stops instances after a configurable idle timeout. Set autoshutdown policies for all compute instances.

- **Fabric capacity** offers pay-as-you-go and reserved capacity pricing. Reserved capacity provides discounts for committed usage. Dataflow Gen2 uses tiered pricing that reduces per-unit cost for longer-running jobs.

- **Managed virtual networks** incur no additional cost over the cost of custom virtual networks and reduce operational overhead.

If you retain data science VMs, their cost depends on the underlying VM series. Shut down VMs when they're not in use. For approval workflows, evaluate Power Automate licensing based on volume. If you use Logic Apps instead, the Consumption plan is the most cost-effective starting point.

To estimate costs based on the estimated sizing of resources that you need, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Monitor costs by using Microsoft Cost Management and Fabric capacity metrics.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Azure Machine Learning managed compute provides elastic scaling that matches resource allocation to workload demand:

- **Compute clusters** automatically scale nodes based on the number of queued jobs. Set minimum and maximum node counts to control costs and performance.

- **Serverless compute** provides on-demand resources without capacity planning. Azure Machine Learning allocates and releases compute based on job requirements.

- **Data Science** scales Spark pools independently of Azure Machine Learning compute, which lets you size each engine to its workload.

If you retain data science VMs, choose the appropriate size and type for the style of work that researchers do. Some GPU VM series, such as NCv3, are retired. Verify that you select a currently supported VM series for GPU workloads. For the latest list of supported VM series, see [Supported VM series and sizes](/azure/machine-learning/concept-compute-target#supported-vm-series-and-sizes).

This architecture supports a single research project. To achieve scalability, use Azure Machine Learning workspaces and Fabric workspaces to isolate projects and allocate compute resources independently.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ananya Ghosh Chowdhury](https://www.linkedin.com/in/ananyaghoshchowdhury/) | Principal Cloud Solution Architect

Other contributors:

- [Clayton Barlow](https://www.linkedin.com/in/clayton-b-barlow) | Senior Azure Specialist
- [Tincy Elias](https://www.linkedin.com/in/tincy-elias/) | Senior Cloud Solution Architect
- [Brijesh Kachalia](https://www.linkedin.com/in/brijeshkachalia/) | Cloud Solution Architect
- [Kranthi Kumar Manchikanti](https://www.linkedin.com/in/kranthimanchikanti/) | Senior Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Azure Machine Learning managed virtual network](/azure/machine-learning/how-to-managed-network)
- [Use serverless compute in Azure Machine Learning](/azure/machine-learning/how-to-use-serverless-compute)
- [What are compute targets in Azure Machine Learning?](/azure/machine-learning/concept-compute-target)
- [Responsible AI overview for Azure Machine Learning](/azure/machine-learning/concept-responsible-ai)
- [What is Microsoft Fabric?](/fabric/fundamentals/microsoft-fabric-overview)
- [Fabric Data Science overview](/fabric/data-science/data-science-overview)
- [What is Fabric Data Factory?](/fabric/data-factory/data-factory-overview)
- [Private links in Fabric](/fabric/security/security-private-links-overview)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Azure Virtual Desktop?](/azure/virtual-desktop/overview)
- [Defender for Cloud documentation](/azure/defender-for-cloud)
- [What is Microsoft Sentinel SIEM?](/azure/sentinel/overview)
- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- [What is Azure Policy?](/azure/governance/policy/overview)
- [Microsoft Purview documentation](/purview/purview)
- [What is the data science VM for Linux and Windows?](/azure/machine-learning/data-science-virtual-machine/overview)
- [Default outbound access for VMs in Azure](/azure/virtual-network/ip-services/default-outbound-access)

## Related resources

- [Compare Microsoft machine learning products and technologies](../guide/data-science-and-machine-learning.md)
- [Use the many-models architecture approach to scale machine learning models](../idea/many-models-machine-learning-azure-machine-learning.yml)
