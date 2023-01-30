This architecture shows a secure research environment intended to allow researchers to access sensitive data under a higher level of control and data protection. This article is applicable for organizations that are bound by regulatory compliance or other strict security requirements.

## Architecture

:::image type="content" source="./media/secure-research-env.svg" alt-text="Diagram of a secure research environment." lightbox="./media/secure-research-env.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/secure-compute-for-research.vsdx) of this architecture.*

### Dataflow

1. Data owners upload datasets into a public blob storage account. The data is encrypted by using Microsoft-managed keys.

2. [Azure Data Factory](/azure/data-factory) uses a trigger that starts copying of the uploaded dataset to a specific location (import path) on another storage account with security controls. The storage account can only be reached through a private endpoint. Also, it's accessed by a service principal with limited permissions. Data Factory deletes the original copy making the dataset immutable.

3. Researchers access the secure environment through a streaming application using [Azure Virtual Desktop](/azure/virtual-desktop) as a privileged jump box.

4. The dataset in the secure storage account is presented to the data science VMs provisioned in a secure network environment for research work. Much of the data preparation is done on those VMs.

5. The secure environment has [Azure Machine Learning](/azure/machine-learning) compute that can access the dataset through a private endpoint for users for AML capabilities, such as to train, deploy, automate, and manage machine learning models. At this point, models are created that meet regulatory guidelines. All model data is de-identified by removing personal information.

6. Models or de-identified data is saved to a separate location on the secure storage (export path). When new data is added to the export path, a Logic App is triggered. In this architecture, the Logic App is outside the secure environment because no data is sent to the Logic App. Its only function is to send notification and start the manual approval process.

    The app starts an approval process requesting a review of data that is queued to be exported.  The manual reviewers ensure that sensitive data isn't exported. After the review process, the data is either approved or denied.

    > [!NOTE]
    > If an approval step is not required on exfiltration, the Logic App step could be omitted.

7. If the de-identified data is approved, it's sent to the Data Factory instance.

8. Data Factory moves the data to the public storage account in a separate container to allow external researchers to have access to their exported data and models. Alternately, you can provision another storage account in a lower security environment.

### Components

This architecture consists of several Azure cloud services that scale resources according to need. The services and their roles are described below. For links to product documentation to get started with these services, see [Next steps](#next-steps).

#### Core workload components

Here are the core components that move and process research data.

- [**Azure Data Science Virtual Machine (DSVM):**](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines) VMs that are configured with tools used for data analytics and machine learning.

- [**Azure Machine Learning:**](https://azure.microsoft.com/free/machine-learning) Used to train, deploy, automate, and manage machine learning models and to manage the allocation and use of ML compute resources.

- **Azure Machine Learning Compute:** A cluster of nodes that are used to train and test machine learning and AI models. The compute is allocated on demand based on an automatic scaling option.

- [**Azure Blob storage:**](https://azure.microsoft.com/services/storage/blobs) There are two instances. The public instance is used to temporarily store the data uploaded by data owners. Also, it stores deidentified data after modeling in a separate container. The second instance is private. It receives the training and test data sets from Machine Learning that are used by the training scripts. Storage is mounted as a virtual drive onto each node of a Machine Learning Compute cluster.

- [**Azure Data Factory:**](https://azure.microsoft.com/services/data-factory) Automatically moves data between storage accounts of differing security levels to ensure separation of duties.

- [**Azure Virtual Desktop**](https://azure.microsoft.com/free/virtual-desktop) is used as a jump box to gain access to the resources in the secure environment with streaming applications and a full desktop, as needed. Alternately, you can use [Azure Bastion](https://azure.microsoft.com/services/azure-bastion). But, have a clear understanding of the security control differences between the two options. Virtual Desktop has some advantages:

  - Ability to stream an app like VSCode to run notebooks against the machine learning compute resources.
  - Ability to limit copy, paste, and screen captures.
  - Support for Azure Active Directory Authentication to DSVM.

- [**Azure Logic Apps**](https://azure.microsoft.com/services/logic-apps) provides automated low-code workflow to develop both the *trigger* and *release* portions of the manual approval process.

#### Posture management components

These components continuously monitor the posture of the workload and its environment. The purpose is to discover and mitigate risks as soon as they are discovered.

- [**Microsoft Defender for Cloud**](https://azure.microsoft.com/services/defender-for-cloud) is used to evaluate the overall security posture of the implementation and  provide an attestation mechanism for regulatory compliance. Issues that were previously found during audits or assessments can be discovered early. Use features to track progress such as secure score and compliance score.

- [**Microsoft Sentinel**](https://azure.microsoft.com/services/microsoft-sentinel) is Security Information and Event Management (SIEM) and security orchestration automated response (SOAR) solution. You can centrally view logs and alerts from various sources and take advantage of advanced AI and security analytics to detect, hunt, prevent, and respond to threats.

- [**Azure Monitor**](https://azure.microsoft.com/services/monitor) provides observability across your entire environment. View metrics, activity logs, and diagnostics logs from most of your Azure resources without added configuration. Management tools, such as those in Microsoft Defender for Cloud, also push log data to Azure Monitor.

#### Governance components

- [**Azure Policy**](https://azure.microsoft.com/services/azure-policy) helps to enforce organizational standards and to assess compliance at-scale.

### Alternatives

- This solution uses Data Factory to move the data to the public storage account in a separate container, in order to allow external researchers to have access to their exported data and models. Alternately, you can provision another storage account in a lower security environment.
- This solution uses Azure Virtual Desktop as a jump box to gain access to the resources in the secure environment, with streaming applications and a full desktop. Alternately, you can use Azure Bastion. But, Virtual Desktop has some advantages, which include the ability to stream an app, to limit copy/paste and screen captures, and to support AAC authentication. You can also consider configuring Point to Site VPN for offline training locally. This will also help save costs of having multiple VMs for workstations.
- To secure data at rest, this solution encrypts all Azure Storage with Microsoft-managed keys using strong cryptography. Alternately, you can use customer-managed keys. The keys must be stored in a managed key store.

## Scenario details

### Potential use cases

This architecture was originally created for higher education research institutions with HIPAA requirements. However, this design can be used in any industry that requires isolation of data for research perspectives. Some examples include:

- Industries that process regulated data as per NIST requirements
- Medical centers collaborating with internal or external researchers
- Banking and finance

By following the guidance you can maintain full control of your research data, have separation of duties, and meet strict regulatory compliance standards while providing collaboration between the typical roles involved in a research-oriented workload; data owners, researchers, and approvers.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The main objective of this architecture is to provide a secure and trusted research environment that strictly limits the exfiltration of data from the secure area.

#### Network security

Azure resources that are used to store, test, and train research data sets are provisioned in a secure environment. That environment is an Azure Virtual Network (VNet) that has network security groups (NSGs) rules to restrict access, mainly:

- Inbound and outbound access to the public internet and within the VNet.
- Access to and from specific services and ports. For example, this architecture blocks all ports ranges except the ones required for Azure Services (such as Azure Monitor). A full list of Service Tags and the corresponding services can be found [here](/azure/virtual-network/service-tags-overview).

    Also, access from VNet with Azure Virtual Desktop (AVD) on ports limited to approved access methods is accepted, all other traffic is denied. When compared to this environment, the other VNet (with AVD) is relatively open.

The main blob storage in the secure environment is off the public internet. It's only accessible within the VNet through [private endpoint connections](/azure/storage/files/storage-files-networking-endpoints) and Azure Storage Firewalls. It's used to limit the networks from which clients can connect to Azure file shares.

This architecture uses credential-based authentication for the main data store that is in the secure environment. In this case, the connection information like the subscription ID and token authorization is stored in a key vault. Another option is to create identity-based data access, where your Azure account is used to confirm if you have access to the Storage service. In an identity-based data access scenario, no authentication credentials are saved. For the details on how to use identity-based data access, see [Connect to storage by using identity-based data access](/azure/machine-learning/how-to-identity-based-data-access).

The compute cluster can solely communicate within the virtual network, by using the Azure Private Link ecosystem and service/private endpoints, rather than using Public IP for communication. Make sure you enable **No public IP**. For details about this feature, which is currently in preview (as of 3/7/2022), see [No public IP for compute instances](/azure/machine-learning/how-to-secure-training-vnet?tabs=azure-studio%2Cipaddress#no-public-ip).

The secure environment uses Azure Machine Learning compute to access the dataset through a private endpoint. Additionally, Azure Firewall can be used to control outbound access from Azure Machine Learning compute. To learn about how to configure Azure Firewall to control access to Azure Machine Learning compute, which resides in a machine learning workspace, see [Configure inbound and outbound network traffic](/azure/machine-learning/how-to-access-azureml-behind-firewall).

To learn one of the ways to secure an Azure Machine Learning environment, see the blog post, [Secure Azure Machine Learning Service (AMLS) Environment](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/secure-azure-machine-learning-service-amls-environment/ba-p/3162297).

For Azure services that cannot be configured effectively with private endpoints, or to provide stateful packet inspection, consider using Azure Firewall or a third-party network virtual appliance (NVA).

#### Identity management

The Blob storage access is through Azure Role-based access controls (RBAC).

Azure Virtual Desktop supports Azure AD authentication to DSVM.

Data Factory uses managed identity to access data from the blob storage. DSVMs also uses managed identity for remediation tasks.

#### Data security

To secure data at rest, all Azure Storage is encrypted with Microsoft-managed keys using strong cryptography.

Alternately, you can use customer-managed keys. The keys must be stored in a managed key store. In this architecture, Azure Key Vault is deployed in the secure environment to store secrets such as encryption keys and certificates. Key Vault is accessed through a private endpoint by the resources in the secure VNet.

### Governance considerations

Enable Azure Policy to enforce standards and  provide automated remediation to bring resources into compliance for specific policies. The policies can be applied to a project subscription or at a management group level as a single policy or as part of a regulatory Initiative.

For example, in this architecture Azure Policy Guest Configuration was applied to all VMs in scope. The policy can audit operating systems and machine configuration for the Data Science VMs.

### VM image

The Data Science VMs run customized base images. To build the base image, we highly recommend technologies like Azure Image Builder. This way you can create a repeatable image that can be deployed when needed.

The base image might need updates, such as additional binaries. Those binaries should be uploaded to the public blob storage and flow through the secure environment, much like the datasets are uploaded by data owners.

### Other considerations

Most research solutions are temporary workloads and don't need to be available for extended periods. This architecture is designed as a single-region deployment with availability zones. If the business requirements demand higher availability, replicate this architecture in multiple regions. You would need other components, such as global load balancer and distributor to route traffic to all those regions. As part of your recovery strategy, capturing and creating a copy of the customized base image with Azure Image Builder is highly recommended.

The size and type of the Data Science VMs should be appropriate to the style of work being performed. This architecture is intended to support a single research project and the scalability is achieved by adjusting the size and type of the VMs and the choices made for compute resources available to AML.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost of DSVMs depends on the choice of the underlying VM series. Because the workload is temporary,  the consumption plan is recommended for the Logic App resource. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs based on estimated sizing of resources needed.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Clayton Barlow](https://www.linkedin.com/in/clayton-b-barlow) | Senior Azure Specialist

## Next steps

- [Microsoft Data Science Virtual Machine (DSVM)](/azure/machine-learning/data-science-virtual-machine/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Azure Machine Learning Compute](/azure/machine-learning/service/concept-compute-target)
- [Introduction to Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)
- [Introduction to Azure Data Factory](/azure/data-factory/introduction)
- [Azure Virtual Desktop](/azure/virtual-desktop/overview)
- [Microsoft Defender for Cloud](/azure/security-center)
- [Microsoft Sentinel](/azure/sentinel/overview)
- [Azure Monitor](/azure/azure-monitor/overview)
- [Azure Policy](/azure/governance/policy/overview)
- [Azure Policy Guest Configuration](/azure/governance/policy/concepts/guest-configuration)

## Related resources

- [Compare the machine learning products and technologies from Microsoft](/azure/architecture/data-guide/technology-choices/data-science-and-machine-learning)
- [Machine learning at scale](/azure/architecture/data-guide/big-data/machine-learning-at-scale)
- [Azure Machine Learning architecture](/azure/architecture/solution-ideas/articles/azure-machine-learning-solution-architecture)
- [Scale AI and machine learning initiatives in regulated industries](/azure/architecture/example-scenario/ai/scale-ai-and-machine-learning-in-regulated-industries)
- [Many models machine learning (ML) at scale with Azure Machine Learning](/azure/architecture/example-scenario/ai/many-models-machine-learning-azure-machine-learning)
