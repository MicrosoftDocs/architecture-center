This article describes a secure research environment that allows researchers to access sensitive data that's under a high level of control and protection. This article applies to organizations that are bound by regulatory compliance or other strict security requirements.

## Architecture

[![A diagram that shows a secure research environment.](_images/secure-compute-for-research.svg)](_images/secure-compute-for-research.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/secure-compute-for-research.vsdx) of this architecture.*

### Dataflow

The following or dataflow corresponds to the above diagram:

1. Data owners upload datasets into a public blob storage account. They use Microsoft-managed keys to encrypt the data.

2. [Azure Data Factory](/azure/data-factory) uses a trigger that starts copying the uploaded dataset to a specific location, or import path, on another storage account that has security controls. You can reach the storage account only through a private endpoint. A service principal that has limited permissions can also access the account. Data Factory deletes the original copy, which makes the dataset immutable.

3. Researchers access the secure environment through a streaming application by using [Azure Virtual Desktop](/azure/virtual-desktop) as a privileged jump box.

4. The dataset in the secure storage account is presented to the data science virtual machines (VMs) that you provision in a secure network environment for research work. Much of the data preparation is done on those VMs.

5. The secure environment has [Azure Machine Learning](/azure/machine-learning) and [Azure Synapse Analytics](/azure/synapse-analytics), which can access the dataset through a private endpoint. You can use these platforms to train, deploy, automate, and manage machine learning models or use Azure Synapse Analytics. At this point, you can create models that meet regulatory guidelines. De-identify all model data by removing personal information.

6. Models or de-identified data are saved to a separate location on the secure storage, or export path. When you add new data to the export path, you trigger a logic app. In this architecture, the logic app is outside of the secure environment because no data is sent to the logic app. Its only function is to send notifications and start the manual approval process.

    The logic app starts an approval process by requesting a review of data that's queued to be exported. The manual reviewers ensure that sensitive data isn't exported. After the review process, the data is either approved or denied.

    > [!NOTE]
    > If an approval step isn't required on exfiltration, you can omit the logic app step.

7. If the de-identified data is approved, it's sent to the Data Factory instance.

8. Data Factory moves the data to the public storage account in a separate container to allow external researchers to access their exported data and models. Alternately, you can provision another storage account in a lower security environment.

### Components

This architecture consists of several Azure services that scale resources according to your needs. The following sections describe these services and their roles. For links to product documentation to get started with these services, see [Next steps](#next-steps).

#### Core workload components

Here are the core components that move and process research data.

- [**Azure data science VMs**](/azure/machine-learning/data-science-virtual-machine/overview) are VMs that you configure with tools for data analytics and machine learning. Use the data science VM when you need specific packages or tools, such as MATLAB or SAS, that platform as a service (PaaS) environments can't support. For security and ease of use, choose Machine Learning and other PaaS options when they're supported.

- [**Machine Learning**](/azure/well-architected/service-guides/azure-machine-learning) is a service that you can use to train, deploy, automate, and manage machine learning models. You can also use it to manage the allocation and use of machine learning compute resources. Machine Learning is the tool of choice for Jupyter notebooks for development.

- **Machine Learning compute** is a cluster of nodes that you can use to train and test machine learning and AI models. The compute is allocated on demand based on an automatic scaling option. You can deploy Visual Studio Code (VS Code) as a streaming application from Virtual Desktop and connect it to the Machine Learning compute for an alternative development environment.

- [**Azure Blob Storage**](/azure/well-architected/service-guides/azure-blob-storage) has two instances. The public instance temporarily stores the data that the data owners upload. The public instance also stores de-identified data after it models the data in a separate container. The second instance is private. It receives the training and test datasets from Machine Learning that are used by the training scripts. Storage is mounted as a virtual drive onto each node of a Machine Learning compute cluster.

- [**Data Factory**](/azure/data-factory/introduction) automatically moves data between storage accounts of differing security levels to ensure separation of duties.

- [**Azure Synapse Analytics**](/azure/synapse-analytics/overview-what-is) is an analytical tool for big data and pipelines for data integration and extract, transform, and load (ETL/ELT) workloads. Azure Synapse Analytics is also a preferred service to run Apache Spark workloads.

- [**Virtual Desktop**](/azure/well-architected/azure-virtual-desktop/overview) is a service that you can use as a jump box to gain access to the resources in the secure environment with streaming applications and a full desktop, as needed. Alternately, you can use [Azure Bastion](/azure/bastion/), but you should have a clear understanding of the security control differences between the two options. Virtual Desktop has some advantages, including:

  - The ability to stream an app like VS Code to run notebooks on the machine learning compute resources.
  - The ability to limit copy, paste, and screen captures.
  - Support for Microsoft Entra authentication to data science VMs.

- [**Azure Logic Apps**](/azure/logic-apps/logic-apps-overview) provides automated low-code workflows to develop the *trigger* and *release* portions of the manual approval process.

#### Posture management components

These components continuously monitor the posture of the workload and its environment. Their purpose is to discover and mitigate risks as soon as they're discovered.

- [**Microsoft Defender for Cloud**](/azure/defender-for-cloud/defender-for-cloud-introduction) is a service that you can use to evaluate the overall security posture of the implementation and provide an attestation mechanism for regulatory compliance. You can discover issues that you previously found during audits or assessments early. Use features to track progress such as the secure score and compliance score. These scores are important tools that help verify compliance.

- [**Microsoft Sentinel**](/azure/sentinel/overview) is a security information and event management (SIEM) solution and a security orchestration, automation, and response (SOAR) solution. You can centrally view logs and alerts from various sources and take advantage of advanced AI and security analytics to detect, hunt, prevent, and respond to threats. This capability provides valuable security insights to help you ensure that traffic and any activities associated with the workspace meet your expectations.

- [**Azure Monitor**](/azure/azure-monitor/overview) provides observability across your entire environment. View metrics, activity logs, and diagnostics logs from most of your Azure resources without added configuration. Management tools, such as those in Defender for Cloud, also push log data to Azure Monitor.

#### Governance components

- [**Azure Policy**](/azure/governance/policy/overview) helps you enforce organizational standards and assess compliance at scale.

### Alternatives

- This solution uses Data Factory to move data to the public storage account in a separate container to allow external researchers to have access to their exported data and models. Alternately, you can provision another storage account in a lower security environment.
- This solution uses Virtual Desktop as a jump box to gain access to the resources in the secure environment with streaming applications and a full desktop. Alternately, you can use Azure Bastion, but Virtual Desktop has some advantages. These advantages include the ability to stream an app, to limit copy/paste and screen captures, and to support Microsoft Entra authentication. You can also consider configuring a Point-to-Site VPN for offline training locally. This VPN also helps reduce the cost of having multiple VMs for workstations.
- To secure data at rest, this solution encrypts all Azure Storage with Microsoft-managed keys by using strong cryptography. Alternately, you can use customer-managed keys. You must store the keys in a managed key store.

## Scenario details

This scenario combines regulated and highly private data that must be accessed by individuals who needed access to use the data but are not allowed to store or transmit the data.

- Third-party data scientists need full access to the data to train their models and export the model without any proprietary or protected data leaving the environment.
- Access has to be isolated and even the data owners and custodians are not allowed access to the data once uploaded into the environment.
- An audit trail is required for any exports being transferred out of the environment to ensure only the models were exported.

### Potential use cases

This architecture was originally created for higher education research institutions with Health Insurance Portability and Accountability Act (HIPAA) requirements. However, this design can be used in any industry that requires isolation of data for research perspectives. Some examples include:

- Industries that process regulated data as per National Institute of Standards and Technology (NIST) requirements
- Medical centers collaborating with internal or external researchers
- Banking and finance

By following the guidance you can maintain full control of your research data, have separation of duties, and meet strict regulatory compliance standards while providing collaboration between the typical roles involved in a research-oriented workload; data owners, researchers, and approvers.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Most research solutions are temporary workloads and don't need to be available for extended periods. This architecture is designed as a single-region deployment with availability zones. If the business requirements demand higher availability, replicate this architecture in multiple regions. You would need other components, such as global load balancer and distributor to route traffic to all those regions. As part of your recovery strategy, capturing and creating a copy of the customized base image with Azure Image Builder is highly recommended.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The main objective of this architecture is to provide a secure and trusted research environment that strictly limits the exfiltration of data from the secure area.

#### Network security

Azure resources that are used to store, test, and train research data sets are provisioned in a secure environment. That environment is an Azure virtual network that has network security groups (NSGs) rules to restrict access, mainly:

- Inbound and outbound access to the public internet and within the virtual network.
- Access to and from specific services and ports. For example, this architecture blocks all ports ranges except the ones required for Azure Services (such as Azure Monitor). A full list of Service Tags and the corresponding services can be found in [Virtual network service tags](/azure/virtual-network/service-tags-overview).

    Also, access from virtual network with Virtual Desktop on ports limited to approved access methods is accepted, all other traffic is denied. When compared to this environment, the other virtual network (with Virtual Desktop) is relatively open.

The main blob storage in the secure environment is off the public internet. It's only accessible within the virtual network through [private endpoint connections](/azure/storage/files/storage-files-networking-endpoints) and Azure Storage Firewalls. It's used to limit the networks from which clients can connect to shares in Azure Files.

This architecture uses credential-based authentication for the main data store that is in the secure environment. In this case, the connection information like the subscription ID and token authorization is stored in a key vault. Another option is to create identity-based data access, where your Azure account is used to confirm if you have access to the Storage service. In an identity-based data access scenario, no authentication credentials are saved. For the details on how to use identity-based data access, see [Connect to storage by using identity-based data access](/azure/machine-learning/how-to-identity-based-data-access).

The compute cluster can solely communicate within the virtual network, by using the Azure Private Link ecosystem and service/private endpoints, rather than using public IP for communication. Make sure you enable **No public IP**. For details about this feature, which is currently in preview (as of 3/7/2022), see [No public IP for compute instances](/azure/machine-learning/how-to-secure-training-vnet?tabs=azure-studio%2Cipaddress#no-public-ip).

The secure environment uses Machine Learning compute to access the dataset through a private endpoint. Additionally, Azure Firewall can be used to control outbound access from Machine Learning compute. To learn about how to configure Azure Firewall to control access to Machine Learning compute, which resides in a machine learning workspace, see [Configure inbound and outbound network traffic](/azure/machine-learning/how-to-access-azureml-behind-firewall).

To learn one of the ways to secure a Machine Learning environment, see the blog post, [Secure Machine Learning service environment](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/secure-azure-machine-learning-service-amls-environment/ba-p/3162297).

For Azure services that cannot be configured effectively with private endpoints, or to provide stateful packet inspection, consider using Azure Firewall or a third-party network virtual appliance (NVA).

#### Identity management

The blob storage access is through Azure Role-based access controls (RBAC).

Virtual Desktop supports Microsoft Entra authentication to DSVM.

Data Factory uses managed identity to access data from the blob storage. DSVMs also uses managed identity for remediation tasks.

#### Data security

To secure data at rest, all Azure Storage is encrypted with Microsoft-managed keys using strong cryptography.

Alternately, you can use customer-managed keys. The keys must be stored in a managed key store. In this architecture, Azure Key Vault is deployed in the secure environment to store secrets such as encryption keys and certificates. Key Vault is accessed through a private endpoint by the resources in the secure virtual network.

### Governance considerations

Enable Azure Policy to enforce standards and provide automated remediation to bring resources into compliance for specific policies. The policies can be applied to a project subscription or at a management group level as a single policy or as part of a regulatory Initiative.

For example, in this architecture Azure Policy Guest Configuration was applied to all VMs in scope. The policy can audit operating systems and machine configuration for the data science VMs.

### VM image

The data science VMs run customized base images. To build the base image, we highly recommend technologies like Azure Image Builder. This way you can create a repeatable image that can be deployed when needed.

The base image might need updates, such as additional binaries. Those binaries should be uploaded to the public blob storage and flow through the secure environment, much like the datasets are uploaded by data owners.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of DSVMs depends on the choice of the underlying VM series. Because the workload is temporary,  the consumption plan is recommended for the logic app resource. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs based on estimated sizing of resources needed. Ensuring the environment is shut down when not in use is a key cost optimization and security consideration.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The size and type of the data science VMs should be appropriate to the style of work being performed. This architecture is intended to support a single research project and the scalability is achieved by adjusting the size and type of the VMs and the choices made for compute resources available to Machine Learning.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Clayton Barlow](https://www.linkedin.com/in/clayton-b-barlow) | Senior Azure Specialist

## Next steps

- [Azure data science VMs](/azure/machine-learning/data-science-virtual-machine/overview)
- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Machine Learning compute](/azure/machine-learning/service/concept-compute-target)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Introduction to Azure Data Factory](/azure/data-factory/introduction)
- [Azure Virtual Desktop](/azure/virtual-desktop/overview)
- [Defender for Cloud](/azure/security-center)
- [Microsoft Sentinel](/azure/sentinel/overview)
- [Azure Monitor](/azure/azure-monitor/overview)
- [Azure Policy](/azure/governance/policy/overview)
- [Azure Policy Guest Configuration](/azure/governance/policy/concepts/guest-configuration)

## Related resources

- [Compare the machine learning products and technologies from Microsoft](/azure/architecture/data-guide/technology-choices/data-science-and-machine-learning)
- [Scale AI and machine learning initiatives in regulated industries](/azure/architecture/example-scenario/ai/scale-ai-and-machine-learning-in-regulated-industries)
- [Many models machine learning at scale with Machine Learning](/azure/architecture/ai-ml/idea/many-models-machine-learning-azure-machine-learning)
