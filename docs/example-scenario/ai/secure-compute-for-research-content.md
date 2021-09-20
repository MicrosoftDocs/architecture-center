This architecture shows a secure research environment. The architecture allows researchers to access sensitive data under a higher level of control and data protection. This article is intended for organizations that are bound by regulatory compliance or other security requirements. 

By following the guidance you can maintain full control of your data, have separation of duties, and meet strict regulatory compliance standards while providing a robust platform for collaboration. 

## Potential use cases 

We've deployed this architecture for Higher Education research institutions with HIPAA requirements. This design can be used in any industry that requires isolation of data for research perspectives. Some examples include: 
- Industries that process regulated data as per NIST requirements 
- Medical centers collaborating with internal or external researchers 
- Banking and finance 

## Architecture
:::image type="content" source="./media/secure-research-env.png" alt-text="Diagram of a secure research environment." :::

## Components 

This architecture consists of several Azure cloud services that scale resources according to need. The services and their roles are described below. For links to product documenation to help you get started with these services, see [Related links](#related-links). 
 
### Workflow components

Here are the core components that move and process research data. 

- **Microsoft Data Science Virtual Machine (DSVM)** is a VM image configured with tools used for data analytics and machine learning. 

- **Azure Machine Learning** is used to manage the allocation and use of the Azure resources described below. 

- **Azure Machine Learning Compute** is a cluster of nodes that are allocated on demand based on an automatic scaling option. 

- **Azure Blob storage** receives the training and test data sets from Machine Learning that are used by the training scripts. Storage is mounted as a virtual drive onto each node of a Machine Learning Compute cluster. 

- **Azure Data Factory** is used to programmatically move data between storage accounts of differing security levels to ensure separation of duties.

- **Azure Virtual Desktop** is used to gain access to the resources in the secure environment via streaming apps as well as a full desktop as needed.  All copy, paste, and screen capture controls should be employed. 

- **Azure Logic Apps** provides automated low-code workflow to develop both the _trigger_ and _release_ portions of the manual approval process.   

### Posture management components

**Azure Security Center** is used to evaluate the overall security posture of the implementation as well as providing an attestation mechanism for regulatory compliance. 

**Azure Sentinel** is Security Information and Event Management (SIEM) and security orchestration automated response (SOAR) solution that uses advanced AI and security analytics to help you detect, hunt, prevent, and respond to threats across your enterprise. 

**Azure Monitor** collects monitoring telemetry from a variety Azure sources. Management tools, such as those in Azure Security Center, also push log data to Azure Monitor. 

### Governance components

**Azure Policy** helps to enforce standards and to assess compliance at-scale as well as provide automated remediation to bring resources into compliance for specific policies. This can be applied to a project subscription or at a management group level as a single policy or as part of a regulatory Initiative.  

Azure Policy Guest Configuration can audit operating systems and machine configuration for the Data Science VMs. 

## Data flow

1. Data owners upload datasets into an Azure Blob storage account. The data is encyrpted by using Microsoft-managed keys.

2. Data Factory uses a trigger that starts copying of the uploaded dataset to another storage account with security controls. Network communication is only possible via a private endpoint. Also, it's accessed by a service principal with limited permissions. Data Factory deletes the original copy making the dataset immutable.

3. The dataset is housed in the secure storage account is presented to the Data Science Virtual Machine (DSVM) provisioned in a secure environment for research work. The environment is a virtual network that has limited internet connectivity through the use of network security groups (NSGs) and private endpoints. Much of the data preparation is done on the DSVM.  

4. Researchers access the secure environment through a streaming application using Azure Virtual Desktop as a privileged jump box.  

5. The secure enviroment has Azure Machine Learning compute that can access the the dataset through a private endpoint for users for AML capabilities, such as to train, deploy, automate, and manage machine learning models . 
6. Models or deidentified data are saved to a specific location on the secure storage. New data triggers a Logic App requesting a review of data that is queued to be exported.  The manual reviewers are the data owners and their job is ensure that no sensitive data is being exported. Once the data is reviewed to ensure no sensitive data is present, it's approved, and the export functionality is sent to Data Factory. The Logic App can be in a standard environment as no data is sent to the Logic App, it is simply a notification and approval function.  

7. Data Factory moves the data to lower security level storage account, allowing external researchers to have access to their exported data/models. 

## Network configuration

Network security groups. Use security groups to restrict network traffic within the virtual network. The green tier is a more open subnet while the blue tier limits inbound and outbound traffic to very specific hosts and virtual networks.  


Private endpoint connections and Azure Storage Firewalls are used to limit the networks from which clients can connect to Azure file shares. 


This has advantages over using Azure Bastion for the following reasons: 

- Ability to stream an app like VSCode to run notebooks against the AML compute resources.  
- Ability to limit copy, paste and screen captures. 
- Support for Azure Active Directory Authentication to DSVM. 


## Security

Private endpoint connections and Azure Storage Firewalls are used to limit the networks from which clients can connect to Azure file shares. 

Network security groups. Use security groups to restrict network traffic within the virtual network. The green tier is a more open subnet while the blue tier limits inbound and outbound traffic to very specific hosts and virtual networks.  

The main objective of this architecture is to provide a Secure/Trusted research environment that strictly limits the exfiltration of data from the secure area.  Network Security Group rules would be configured to block all ports and ranges except for required Azure Services (such as Azure Monitor) and traffic would be allowed from the AVD Virtual Network on ports limited to approved access methods.  A full list of Service Tags and the corresponding services can be found here. 

<1. Network security>

<2. Data at rest, in transit>

<3. VM image secure>

<4. identity?>

## Availability 

Most research solutions are meant to be more temporary workloads, where the DSVM is highly customized from the base image, a copy of the image should be created and technologies like Azure Image Builder could be employed.  This solution is currently designed as a single-region deployment, if higher availability is required, this architecture would need to change to support additional regions.  

## Performance and scalability

The size and type of the VM should be appropriate to the style of work being performed. 

This architecture is meant to support a single research project and the scalability would be limited to adjusting the size/type of the DSVM and the choices made for compute resources available to AML. 

## Cost considerations 

Use the Azure pricing calculator to estimate costs based on estimated sizing of resources needed. 

This reference assumes that the consumption plan is used to create a global Logic Apps resource. 


## Related links
- [Microsoft Data Science Virtual Machine (DSVM)](/azure/machine-learning/data-science-virtual-machine/overview)
- [Azure Machine Learning](/azure/machine-learning/service/overview-what-is-azure-ml)
- [Azure Machine Learning Compute](/azure/machine-learning/service/concept-compute-target)
- [Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)
- [Azure Data Factory](/azure/data-factory/introduction)
- [Azure Virtual Desktop](/azure/virtual-desktop/overview)
- [Azure Security Center](/azure/security-center/)
- [Azure Sentinel](/azure/sentinel/overview) 
- [Azure Monitor](/azure/azure-monitor/overview)
- [Azure Policy](/azure/governance/policy/overview)
- [Azure Policy Guest Configuration](/azure/governance/policy/concepts/guest-configuration)


   