This article describes a secure research environment that enables researchers to access sensitive data under a high level of control and protection. The environment supports organizations that must adhere to regulatory compliance or other strict security requirements.

## Architecture

:::image type="complex" source="_images/secure-compute-for-research.svg" lightbox="_images/secure-compute-for-research.svg" alt-text="Diagram that shows a secure research environment." border="false":::
The diagram shows two resource groups. The resource group on the left contains a virtual network and a subnet. The resource group on the right contains a virtual network. On the left, data owners upload datasets to a public Azure Blob Storage account (step 1). Fabric Data Factory copies this data to a private Blob Storage account (step 2). Researchers access the secure environment via Azure Virtual Desktop (step 3). Within the secure zone, a Data Science VM cluster connects to private storage (step 4). Azure Machine Learning and Microsoft Fabric service link to the storage (step 5). These services also connect to a Firewall policy. An arrow extends from private Blob Storage to Logic Apps positioned outside, to a message, and then to an approver. This process indicates the approval workflow initiation (step 6). After approval, Fabric Data Factory moves approved data back to public storage for external access (steps 7 and 8). Private Blob Storage also connects to Azure Key Vault. Microsoft Entra ID, Microsoft Sentinel, Microsoft Defender for Cloud, Azure Policy, and Azure Monitor reside outside the main architecture.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-compute-for-research.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Data owners upload datasets into a public Azure Blob Storage account. They use Microsoft-managed keys to encrypt the data.

1. Fabric Data Factory uses a trigger to copy the uploaded dataset to a specific location or import path on another storage account that has security controls. You can only reach the storage account through a private endpoint or trusted workspace access. A service principal that has limited permissions can also access the account. Data Factory deletes the original copy, which makes the dataset immutable.

1. Researchers access the secure environment through a streaming application by using [Azure Virtual Desktop](/azure/virtual-desktop) as a privileged jump box.

1. The dataset in the secure storage account is presented to the Data Science virtual machines (VMs) that you provision in a secure network environment for research work. Most data preparation occurs on those VMs.

1. The secure environment includes Azure Machine Learning and Microsoft Fabric. They can access the dataset through a private endpoint. You can use these platforms to train, deploy, automate, and manage machine learning models, or use Azure Synapse Analytics. At this stage, you can create models that meet regulatory guidelines. To de-identify all model data, remove personal information.

1. Models or de-identified data are saved to a separate location on the secure storage account, known as the *export path*. When you add new data to the export path, you trigger a logic app. In this architecture, the logic app runs outside the secure environment because it doesn't receive any data. Its only function is to send notifications and start the manual approval process.

    The logic app starts an approval process by requesting a review of data that's queued to be exported. The manual reviewers help ensure that sensitive data isn't exported. After the review process, the data is either approved or denied.

    > [!NOTE]
    > If an approval step isn't required on exfiltration, you can skip the logic app step.

1. If the de-identified data is approved, it's sent to the Data Factory instance.

1. Data Factory moves the data to the public storage account in a separate container to allow external researchers to access their exported data and models. Alternately, you can provision another storage account in a lower security environment.

### Components

This architecture consists of several Azure services that scale resources according to your needs. The following sections describe these services and their roles. For links to product documentation to get started with these services, see [Next steps](#next-steps).

#### Core workload components

Here are the core components that move and process research data.

- [Azure Data Science VMs](/azure/machine-learning/data-science-virtual-machine/overview) are VMs that you configure with tools for data analytics and machine learning. In this architecture, they provide researchers with dedicated, secure compute resources for data preparation, analysis, and model training within the isolated environment. Use the data science VM when you need specific packages or tools, such as MATLAB or SAS, that platform as a service (PaaS) environments can't support. For security and ease of use, choose Machine Learning and other PaaS options when they're supported.

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a service that trains, deploys, automates, and manages machine learning models. In this architecture, it facilitates model development and orchestration while maintaining security controls over data access and compute resources. You can also use it to manage the allocation and use of machine learning compute resources. Machine Learning is the tool of choice for Jupyter notebooks for development.

- Machine Learning compute is a cluster of nodes that you can use to train and test machine learning and AI models. In this architecture, it provides automatically scalable, secure, and isolated compute resources for research. You can deploy Visual Studio Code (VS Code) as a streaming application from Virtual Desktop and connect it to the Machine Learning compute for an alternative development environment.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage solution that stores unstructured data in the cloud. In this architecture, it serves as the primary storage solution, and it has two instances. The public instance temporarily stores the data that data owners upload. The public instance stores de-identified data after it models the data in a separate container. The second instance is private. It receives the training and test datasets from Machine Learning that the training scripts use. Storage is mounted as a virtual drive onto each node of a Machine Learning compute cluster.

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an analytical tool for big data and pipelines for data integration and extract, transform, load (ETL) workloads. Fabric is also a preferred service to run Apache Spark workloads. In this architecture, it enables advanced analytics and data integration for research datasets that can be accessed through secure, private endpoints.

- [Fabric Data Factory](/fabric/data-factory) is a cloud-based data integration service within Fabric that orchestrates and operationalizes data movement and transformation workflows. In this architecture, it moves data between storage accounts that have different security levels, enforces separation of duties, and manages data flows throughout the secure environment.

- [Virtual Desktop](/azure/well-architected/azure-virtual-desktop/overview) is a desktop and app virtualization service that runs on the cloud. In this architecture, it acts as a jump box that you can use to gain access to the resources in the secure environment. It enables researchers to connect to data science VMs by using streaming applications and a full desktop, as needed. 

   Alternatively, you can use [Azure Bastion](/azure/bastion/), but understand the security control differences between the two options. Virtual Desktop has the following advantages:

   - The ability to stream an app like VS Code to run notebooks on the machine learning compute resources
   - The ability to limit copy, paste, and screen captures
   - Support for Microsoft Entra authentication to data science VMs

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a service that automates workflows and integrates apps, data, systems, and services across enterprises or organizations. In this architecture, it manages the *trigger* and *release* portions of the manual approval process.

#### Posture management components

These components continuously monitor the posture of the workload and its environment. Use these components to discover risks and immediately mitigate them.

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a service that evaluates the overall security posture of the implementation and provides an attestation mechanism for regulatory compliance. In this architecture, it helps you discover problems early, instead of when you perform audits or assessments. Use features to track progress such as the secure score and compliance score. These scores help verify compliance.

- [Microsoft Sentinel](/azure/sentinel/overview) is a security information and event management (SIEM) solution and a security orchestration, automation, and response (SOAR) solution. In this architecture, it centralizes logs, detects threats, and automates security responses for the research environment. You can centrally view logs and alerts from various sources. Take advantage of advanced AI and security analytics to detect, hunt, prevent, and respond to threats. This capability provides valuable security insights to help ensure that traffic and activities associated with the workspace meet your expectations.

- [Azure Monitor](/azure/azure-monitor/overview) is a monitoring solution that collects, analyzes, and responds to telemetry data from cloud and on-premises environments. In this architecture, it collects and visualizes metrics, activity logs, and diagnostics to support operational monitoring and incident detection. Management tools, such as tools in Defender for Cloud, also push log data to Azure Monitor.

#### Governance components

- [Azure Policy](/azure/governance/policy/overview) is a governance tool for enforcing organizational standards and assessing compliance at scale. In this architecture, it helps ensure that resources and workloads adhere to security and configuration policies.

### Alternatives

- This solution uses Data Factory to move data to the public storage account in a separate container to allow external researchers to access their exported data and models. Alternatively, you can provision another storage account in a lower security environment.

- This solution uses Virtual Desktop as a jump box to gain access to the resources in the secure environment by providing streaming applications and a full desktop. Alternatively, you can use Azure Bastion, but Virtual Desktop has advantages. These advantages include the ability to stream an app, to limit copy and paste capbilities and screen captures, and to support Microsoft Entra authentication. Also consider configuring a point-to-site virtual private network (VPN) for offline training locally. This VPN helps reduce the cost of multiple VMs for workstations.
- To secure data at rest, this solution encrypts all Azure Storage accounts with Microsoft-managed keys by using strong cryptography. Alternatively, you can use customer-managed keys. You must store the keys in a managed key store.

## Scenario details

This scenario combines regulated and private data that individuals must access but aren't allowed to store or transmit. The following conditions apply:

- Data scientists outside your organization need full access to the data to train and export their models, but no proprietary or protected data can leave the environment.

- You must isolate access. Even the data owners and custodians can't access the data after it's uploaded into the environment.
- You must require an audit trail for exports to ensure that only the models are transferred out of the environment.

### Potential use cases

This architecture was originally created for higher education research institutions that have Health Insurance Portability and Accountability Act (HIPAA) requirements. But you can use this design in any industry that requires data isolation for research purposes. Consider the following examples:

- Industries that process regulated data in accordance with National Institute of Standards and Technology (NIST) requirements

- Medical centers that collaborate with internal or external researchers
- Banking and finance industries

Follow the guidance in this article to maintain full control of your research data, maintain separation of duties, and meet strict regulatory compliance standards. This approach also facilitates collaboration among key roles in a research-oriented environment, such as data owners, researchers, and approvers.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Most research solutions consist of temporary workloads that don't need to remain available for extended periods. This architecture uses a single-region deployment with availability zones. If your business requirements demand higher availability, replicate this architecture in multiple regions. Add components, such as a global load balancer and distributor, to route traffic to those regions. As part of your recovery strategy, use Azure VM Image Builder to capture and create a copy of the customized base image.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The main objective of this architecture is to provide a secure and trusted research environment that strictly limits the exfiltration of data from the secure area.

#### Network security

Provision Azure resources that store, test, and train research datasets in a secure environment. This environment resides in an Azure virtual network that has network security group rules to restrict access. These rules apply to the following areas:

- Inbound and outbound access to the public internet and within the virtual network.

- Access to and from specific services and ports. For example, this architecture blocks all port ranges except the ones required for Azure services, such as Azure Monitor. For a full list of service tags and the corresponding services, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).

    Access from the virtual network that includes Virtual Desktop is restricted to approved access methods on specific ports, but all other traffic is denied. When compared to this environment, the other virtual network that includes Virtual Desktop is relatively open.

The main blob storage in the secure environment isn't exposed to the public internet. You can access it only within the virtual network through [private endpoint connections](/azure/storage/files/storage-files-networking-endpoints) and Storage firewalls. Use it to limit the networks from which clients can connect to file shares in Azure Files.

This architecture uses credential-based authentication for the main data store in the secure environment. In this setup, the connection information, such as the subscription ID and token authorization, is stored in a key vault. Alternatively, you can create identity-based data access, where you use your Azure account to confirm whether you have access to Storage without saving authentication credentials. For more information, see [Create datastores](/azure/machine-learning/how-to-datastore).

The compute cluster can communicate only within the virtual network by using the Azure Private Link ecosystem and service or private endpoints. It doesn't use public IP addresses for communication. Enable the **No public IP** setting. For more information about this feature, which is currently in preview, see [Compute instance and cluster or serverless compute with no public IP address](/azure/machine-learning/how-to-secure-training-vnet#compute-instancecluster-or-serverless-compute-with-no-public-ip).

The secure environment uses Machine Learning compute to access the dataset through a private endpoint. You can also configure Azure Firewall to control access to Machine Learning compute, which resides in a machine learning workspace. Use Azure Firewall to control outbound access from Machine Learning compute. For more information, see [Configure inbound and outbound network traffic](/azure/machine-learning/how-to-access-azureml-behind-firewall).

For more information about how to secure a Machine Learning environment, see [Secure a Machine Learning service environment](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/secure-azure-machine-learning-service-amls-environment/ba-p/3162297).

For Azure services that you can't configure effectively by using private endpoints, or to provide stateful packet inspection, consider using Azure Firewall or a non-Microsoft network virtual appliance (NVA).

#### Identity management

Access blob storage through Azure role-based access control (RBAC).

Virtual Desktop supports Microsoft Entra authentication to data science VMs.

Fabric Data Factory uses workspace identity to access data from the blob storage. Data science VMs use managed identity for remediation tasks.

#### Data security

To secure data at rest, all Storage accounts are encrypted with Microsoft-managed keys that use strong cryptography.

Alternatively, you can use customer-managed keys. You must store the keys in a managed key store. In this architecture, you deploy Azure Key Vault in the secure environment to store secrets like encryption keys and certificates. Resources in the secure virtual network access Key Vault through a private endpoint.

### Governance considerations

Enable Azure Policy to enforce standards and provide automated remediation to make resources compliant with specific policies. You can apply the policies to a project subscription or at a management group level, either as a single policy or as part of a regulatory initiative.

For example, in this architecture, Azure machine configuration applies to all in-scope VMs. The policy can audit operating systems and machine configuration for the data science VMs.

### VM image

The data science VMs run customized base images. To build the base image, use technologies like VM Image Builder. You can create a repeatable image to deploy when needed.

The base image might need updates, such as extra binaries. Upload those binaries to the public blob storage. They should flow through the secure environment, much like how data owners upload the datasets.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of data science VMs depends on the choice of the underlying VM series. The workload is temporary, so we recommend the Consumption plan for the logic app resource. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs based on the estimated sizing of resources that you need. Shut down the environment when it's not in use to help optimize costs and improve security.

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
- [What are compute targets in Machine Learning?](/azure/machine-learning/service/concept-compute-target)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Data Factory in Microsoft Fabric?](/fabric/data-factory/data-factory-overview)
- [What is Virtual Desktop?](/azure/virtual-desktop/overview)
- [Defender for Cloud documentation](/azure/security-center)
- [What is Microsoft Sentinel?](/azure/sentinel/overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [What is Azure Policy?](/azure/governance/policy/overview)
- [Understand Azure machine configuration](/azure/governance/policy/concepts/guest-configuration)

## Related resources

- [Compare Microsoft machine learning products and technologies](../guide/data-science-and-machine-learning.md)
- [Many models machine learning at scale with Machine Learning](../idea/many-models-machine-learning-azure-machine-learning.yml)
