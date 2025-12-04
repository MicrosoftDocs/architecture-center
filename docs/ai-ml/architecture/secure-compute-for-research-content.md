This article describes a secure research environment that provides researchers access to sensitive data that requires a high level of control and protection. The architecture supports organizations that must adhere to regulatory compliance or other strict security requirements.

## Architecture

:::image type="complex" source="_images/secure-compute-for-research.svg" lightbox="_images/secure-compute-for-research.svg" alt-text="Diagram that shows a secure research environment." border="false":::
The diagram shows two resource groups. The resource group on the left contains a virtual network and a secure logical grouping of resources within the virtual network. The resource group on the right contains a virtual network. On the left, data owners upload datasets to a public Azure Blob Storage account (step 1). Fabric Data Factory copies this data to a private Blob Storage account (step 2). Researchers access the secure environment via Azure Virtual Desktop (step 3). Within the secure zone, the data science virtual machine (VM) cluster connects to private storage (step 4). Azure Machine Learning and Fabric Data Science link to the storage (step 5). These services also connect to a firewall policy. An arrow extends from private Blob Storage to a logic app positioned outside, to a message, and then to an approver. This process indicates the approval workflow initiation (step 6). After approval, Data Factory moves approved data back to public storage for external access (steps 7 and 8). Private Blob Storage also connects to Azure Key Vault. Microsoft Entra ID, Microsoft Sentinel, Microsoft Defender for Cloud, Azure Policy, and Azure Monitor reside outside the main architecture.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-compute-for-research.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Data owners upload datasets into a public Azure Blob Storage account. They use Microsoft-managed keys to encrypt the data.

1. [Fabric Data Factory](/fabric/data-factory/data-factory-overview) uses a trigger to copy the uploaded dataset to a specific location or import path on another storage account that has security controls. You can only reach the storage account through a private endpoint or trusted workspace access. A service principal that has limited permissions can also access the account. Data Factory deletes the original copy, which makes the dataset immutable.

1. Researchers access the secure environment through a streaming application by using [Azure Virtual Desktop](/azure/virtual-desktop) as a privileged jump box.

1. The secure storage account presents the dataset to the data science virtual machines (VMs) that you set up in a secure network environment for research work. Most data preparation occurs on those VMs.

1. The secure environment includes Azure Machine Learning and [Fabric Data Science](/fabric/data-science/data-science-overview). They can access the dataset through a private endpoint. You can use these platforms to train, deploy, automate, and manage machine learning models. At this stage, you can create models that meet regulatory guidelines. To de-identify all model data, remove personal information.

1. Models or de-identified data are saved to a separate location on the secure storage account, known as the *export path*. When you add new data to the export path, you trigger a logic app. In this architecture, the logic app runs outside the secure environment because it doesn't receive data. Its only function is to send notifications and start the manual approval process.

    The logic app starts an approval process by requesting a review of data that's queued for export. The manual reviewers help ensure that sensitive data isn't exported. After the review process, reviewers either approve or deny the data.

    > [!NOTE]
    > If you don't need to approve data exports, you can skip the logic app step.

1. If reviewers approve the de-identified data, the system sends it to Data Factory.

1. Data Factory moves the data to the public storage account in a separate container so that external researchers can access their exported data and models. Alternatively, you can set up another storage account in a lower security environment.

### Components

This architecture consists of several Azure services that scale resources according to your needs. The following sections describe these services and their roles.

#### Core workload components

The following core components move and process research data:

- [Azure data science VMs](/azure/machine-learning/data-science-virtual-machine/overview) are VMs that you configure with tools for data analytics and machine learning. In this architecture, they provide researchers with dedicated, secure compute resources for data preparation, analysis, and model training within the isolated environment. Data science VMs provide specific packages or tools, such as Matrix Laboratory (MATLAB) or Statistical Analysis System (SAS), that platform as a service (PaaS) environments can't support. For security and ease of use, choose Machine Learning and other PaaS options when supported.

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a service that trains, deploys, automates, and manages machine learning models. In this architecture, it facilitates model development and orchestration while maintaining security controls over data access and compute resources. It can also manage the allocation and use of machine learning compute resources. Machine Learning provides the preferred environment to run Jupyter notebooks during development.

- [Machine Learning compute](/azure/machine-learning/concept-compute-target#azure-machine-learning-compute-managed) is a cluster of nodes that can train and test machine learning and AI models. In this architecture, it provides automatically scalable, secure, and isolated compute resources for research. You can deploy Visual Studio Code (VS Code) as a streaming application from Virtual Desktop and connect it to the Machine Learning compute for an alternative development environment.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage solution that stores unstructured data in the cloud. In this architecture, it serves as the primary storage solution, and it has two instances. The public instance temporarily stores the data that data owners upload. It stores de-identified data after it models the data in a separate container. The private instance receives the training and test datasets from Machine Learning. The training scripts use those datasets. The system mounts storage as a virtual drive onto each node of a Machine Learning compute cluster.

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an analytical platform for big data and pipelines that provides data integration and extract, transform, load (ETL) capabilities. It serves as a preferred service to run Apache Spark workloads. In this architecture, Fabric enables advanced analytics and data integration for research datasets that you can access through secure, private endpoints.

- [Data Factory](/fabric/data-factory/data-factory-overview) is a cloud-based data integration service within Fabric that orchestrates and operationalizes data movement and transformation workflows. In this architecture, it moves data between storage accounts that have different security levels, enforces separation of duties, and manages data flows throughout the secure environment.

- [Virtual Desktop](/azure/well-architected/azure-virtual-desktop/overview) is a desktop and app virtualization service that runs in the cloud. In this architecture, it acts as a jump box that provides access to the resources in the secure environment. Researchers can use Virtual Desktop to connect to data science VMs through streaming applications and a full desktop as needed.

   Alternatively, you can use [Azure Bastion](/azure/bastion/bastion-overview), but understand the security control differences between the two options. Virtual Desktop has the following advantages:

   - Stream applications like VS Code to run notebooks on machine learning compute resources

   - Limit copy, paste, and screen captures
   - Support Microsoft Entra authentication to data science VMs

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a service that automates workflows and integrates apps, data, systems, and services across enterprises or organizations. In this architecture, it manages the trigger and release portions of the manual approval process.

#### Posture management components

The following components continuously monitor the posture of the workload and its environment. Use these components to discover risks and immediately mitigate them.

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a service that evaluates the overall security posture of the implementation and provides an attestation mechanism for regulatory compliance. In this architecture, it helps detect problems early, instead of during audits or assessments. Use features like the secure score and compliance score to track progress. These scores help check compliance.

- [Microsoft Sentinel](/azure/sentinel/overview) is a security information and event management (SIEM) solution and a security orchestration, automation, and response (SOAR) solution. In this architecture, it centralizes logs, detects threats, and automates security responses for the research environment. You can centrally view logs and alerts from various sources. Take advantage of advanced AI and security analytics to detect, investigate, prevent, and respond to threats. This capability provides valuable security insights to help ensure that traffic and activities associated with the workspace meet your expectations.

- [Azure Monitor](/azure/azure-monitor/overview) is a monitoring solution that collects, analyzes, and responds to telemetry data from cloud and on-premises environments. In this architecture, it collects and visualizes metrics, activity logs, and diagnostics to support operational monitoring and incident detection. Management tools, like tools in Defender for Cloud, also push log data to Azure Monitor.

#### Governance components

- [Azure Policy](/azure/governance/policy/overview) is a governance tool that enforces organizational standards and assesses compliance at scale. In this architecture, it helps ensure that resources and workloads adhere to security and configuration policies.

### Alternatives

- This solution uses Data Factory to move data to a public storage account in a separate container so that external researchers can access their exported data and models. Alternatively, you can use Data Factory to transfer data to a public storage account in a separate container or set up another storage account in a lower security environment for the same purpose.

- This solution uses Virtual Desktop as a jump box to gain access to the resources in the secure environment by providing streaming applications and a full desktop. Alternatively, you can use Azure Bastion, but Virtual Desktop has advantages. These advantages include the ability to stream an app, to limit copy and paste capabilities and screen captures, and to support Microsoft Entra authentication. Also consider configuring a point-to-site virtual private network (VPN) to support local offline training. This VPN helps reduce the cost of multiple VMs for workstations.
- To secure data at rest, this solution encrypts all Azure Storage accounts with Microsoft-managed keys by using strong cryptography. Alternatively, you can use customer-managed keys. You must store the keys in a managed key store.

## Scenario details

This scenario combines regulated and private data that individuals must access but aren't allowed to store or transmit. The following conditions apply:

- Data scientists outside your organization need full access to the data to train and export their models, but no proprietary or protected data can leave the environment.

- You must isolate access. Even the data owners and custodians can't access the data after it's uploaded into the environment.
- You must require an audit trail for exports to ensure that only the models are transferred out of the environment.

### Potential use cases

This architecture was originally created for higher education research institutions that have Health Insurance Portability and Accountability Act (HIPAA) requirements. You can use this design in any industry that requires data isolation for research purposes. Consider the following examples:

- Industries that process regulated data in accordance with National Institute of Standards and Technology (NIST) requirements

- Medical centers that collaborate with internal or external researchers
- Banking and finance industries

Follow the guidance in this article to maintain full control of your research data, maintain separation of duties, and meet strict regulatory compliance standards. This approach also facilitates collaboration among key roles in a research-oriented environment, like data owners, researchers, and approvers.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Most research solutions consist of temporary workloads that don't need to remain available for extended periods. This architecture uses a single-region deployment with availability zones. If your business requirements demand higher availability, replicate this architecture in multiple regions. Add components, like a global load balancer and distributor, to route traffic to those regions. As part of your recovery strategy, use Azure VM Image Builder to capture and create a copy of the customized base image.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The main objective of this architecture is to provide a secure and trusted research environment that strictly limits data exfiltration from the secure area.

#### Network security

Set up Azure resources in a secure environment. These resources store, test, and train research datasets. The environment resides in an Azure virtual network that has network security group (NSG) rules to restrict access. These rules apply to the following areas:

- Inbound and outbound access to the public internet and within the virtual network.

- Access to and from specific services and ports. For example, this architecture blocks all port ranges except the ones required for Azure services, like Azure Monitor. For a full list of service tags and the corresponding services, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).

    Access from the virtual network that includes Virtual Desktop is restricted to approved access methods on specific ports, but all other traffic is denied. Compared to this environment, the other virtual network that includes Virtual Desktop is relatively open.

The main Blob Storage instance in the secure environment isn't exposed to the public internet. You can access it only within the virtual network through [private endpoint connections](/azure/storage/files/storage-files-networking-endpoints) and Storage firewalls. Use these controls to limit the networks that clients can use to connect to file shares in Azure Files.

This architecture uses credential-based authentication for the main data store in the secure environment. In this setup, a key vault stores the connection information, like the subscription ID and token authorization. Alternatively, you can create identity-based data access, where you use your Azure account to confirm whether you have access to Storage, without saving authentication credentials. For more information, see [Create data stores](/azure/machine-learning/how-to-datastore).

The compute cluster can communicate only within the virtual network by using the Azure Private Link ecosystem and service or private endpoints. It doesn't use public IP addresses for communication. Enable the **No public IP** setting. For more information about this feature, see [Compute instance and cluster or serverless compute with no public IP address](/azure/machine-learning/how-to-secure-training-vnet#compute-instancecluster-or-serverless-compute-with-no-public-ip).

The secure environment uses Machine Learning compute to access the dataset through a private endpoint. You can also configure Azure Firewall to control both inbound and outbound access to Machine Learning compute, which resides in a machine learning workspace. For more information, see [Configure inbound and outbound network traffic](/azure/machine-learning/how-to-access-azureml-behind-firewall).

For more information, see [Secure a Machine Learning service environment](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/secure-azure-machine-learning-service-amls-environment/ba-p/3162297).

For Azure services that you can't configure effectively by using private endpoints, or to provide stateful packet inspection, consider using Azure Firewall or a non-Microsoft network virtual appliance (NVA).

#### Identity management

This architecture implements multiple layers of identity-based security controls. You can access Blob Storage through Azure role-based access control (Azure RBAC). Virtual Desktop supports Microsoft Entra authentication to data science VMs, which adds an extra security layer for researcher access.

Data Factory uses [trusted workspace access](/fabric/security/security-trusted-workspace-access) to securely connect to data in Blob Storage accounts. This approach uses the workspace's managed identity to bypass firewall restrictions and access protected storage without requiring public network exposure. Data science VMs also use managed identity for remediation tasks to ensure secure operations across the Fabric environment.

#### Data security

To secure data at rest, Microsoft-managed keys encrypt all Storage accounts by using strong cryptography.

Alternatively, you can use customer-managed keys. You must store the keys in a managed key store. In this architecture, you deploy Azure Key Vault in the secure environment to store secrets like encryption keys and certificates. Resources in the secure virtual network access Key Vault through a private endpoint.

### Governance considerations

Enable Azure Policy to enforce standards and provide automated remediation to make resources compliant with specific policies. You can apply the policies to a project subscription or at a management group level, either as a single policy or as part of a regulatory initiative.

For example, in this architecture, Azure machine configuration applies to all in-scope VMs. The policy can audit operating systems and machine configuration for the data science VMs.

### VM image

The data science VMs run customized base images. To build the base image, use technologies like VM Image Builder. You can create a repeatable image to deploy when needed.

The base image might need updates, like extra binaries. Upload those binaries to the public Blob Storage instance. They should flow through the secure environment, similar to how data owners upload the datasets.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of data science VMs depends on the underlying VM series. The workload is temporary, so use the Consumption plan for the logic app resource. To estimate costs based on the estimated sizing of resources that you need, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Shut down the environment when it's not in use to help optimize costs and improve security.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Choose the appropriate size and type of the data science VMs for the style of work that they do. This architecture supports a single research project. To achieve scalability, adjust the size and type of the VMs and choose compute resources that Machine Learning supports.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Clayton Barlow](https://www.linkedin.com/in/clayton-b-barlow) | Senior Azure Specialist

Other contributor:

- [Tincy Elias](https://www.linkedin.com/in/tincy-elias/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is the data science VM for Linux and Windows?](/azure/machine-learning/data-science-virtual-machine/overview)
- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Introduction to Data Science](/fabric/data-science/data-science-overview)
- [What are compute targets in Machine Learning?](/azure/machine-learning/service/concept-compute-target)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Data Factory in Fabric?](/fabric/data-factory/data-factory-overview)
- [What is Virtual Desktop?](/azure/virtual-desktop/overview)
- [Defender for Cloud documentation](/azure/security-center)
- [What is Microsoft Sentinel SIEM?](/azure/sentinel/overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [What is Azure Policy?](/azure/governance/policy/overview)
- [Understand Azure machine configuration](/azure/governance/policy/concepts/guest-configuration)

## Related resources

- [Compare Microsoft machine learning products and technologies](../guide/data-science-and-machine-learning.md)
- [Use the many-models architecture approach to scale machine learning models](../idea/many-models-machine-learning-azure-machine-learning.yml)
