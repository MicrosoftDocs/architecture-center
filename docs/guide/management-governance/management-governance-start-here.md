# Management and governance architecture design

Management and governance includes tasks like: 
- The monitoring, auditing, and reporting of security and business requirements. 
- Implementing backup, disaster recovery, and high availability.
- Ensuring compliance with internal requirements and external regulations.
- The protection of sensitive data.

Azure provides a wide range of services to help you with management and governance. Here are a few examples:  

- [Azure Backup](https://azure.microsoft.com/services/backup). A centralized backup service and solution to help protect against ransomware.
- [Azure Stack](https://azure.microsoft.com/products/azure-stack). Azure Stack enables organizations to make technology placement decisions based on business needs. It can help with simplifying meeting custom compliance, sovereignty, and data gravity requirements.
- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery). Keep your business running with built-in disaster recovery service.
- [Azure Archive Storage](https://azure.microsoft.com/services/storage/archive). Industry leading price point for storing rarely accessed data.
- [Azure confidential ledger](https://azure.microsoft.com/services/azure-confidential-ledger) Store and process confidential data with confidence.
- [Azure Attestation](https://azure.microsoft.com/services/azure-attestation). A unified solution for remotely verifying the trustworthiness of a platform and the integrity of the binaries running inside it.
- [Azure Purview](https://azure.microsoft.com/services/purview). Govern, protect, and manage your data estate
- [azure policy](https://azure.microsoft.com/services/azure-policy)Achieve real-time cloud compliance at scale with consistent resource governance
- [Azure Advisor](https://azure.microsoft.com/services/advisor) A free, personalized guide to Azure best practices.
- [Azure Monitor](https://azure.microsoft.com/services/monitor). Full observability into your applications, infrastructure, and network.

## Introduction to management and governance on Azure

If you're new to management and governance on Azure, the best way to learn more is with [Microsoft Learn](/learn/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive training for Microsoft products and more.

Here are some resources to get you started:

- Learning path: [Manage information protection and governance](/learn/paths/m365-compliance-information) Microsoft solutions for information protection and governance help organizations achieve the right balance between keeping their data protected and their people productive.
- Module: [Design an enterprise governance strategy](/learn/modules/enterprise-governance). Learn to use RBAC and Azure Policy to limit access to your Azure solutions, and determine which method is right for your security goals.
- Module: [Design governance](/learn/modules/design-governance). Azure Architects design and recommend governance solutions.
- Module: [Design a solution for backup and disaster recovery](https://docs.microsoft.com/en-us/learn/modules/design-solution-for-backup-disaster-recovery)

## Path to production

Key aspects of management and governance include backup, disaster recovery, and high availability, gov, data protection... See the following architectures ...  

### Backup
- [Azure Backup architecture and components](/azure/backup/backup-architecture?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Support matrix for Azure Backup](/azure/backup/backup-support-matrix?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Backup cloud and on-premises workloads to cloud](/azure/backup/guidance-best-practices?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

### Disaster recovery

- [Azure to Azure disaster recovery architecture](/azure/site-recovery/azure-to-azure-architecture?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Support matrix for Azure VM disaster recovery between Azure regions](https://docs.microsoft.com/en-us/azure/site-recovery/azure-to-azure-support-matrix?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Integrate ExpressRoute with disaster recovery for Azure VMs](https://docs.microsoft.com/en-us/azure/site-recovery/azure-vm-disaster-recovery-with-expressroute?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Recover from a region-wide service disruption](/azure/architecture/resiliency/recovery-loss-azure-region)
- [Move Azure VMs to another Azure region](https://docs.microsoft.com/en-us/azure/site-recovery/azure-to-azure-move-overview?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Business continuity and disaster recovery (BCDR) for Azure VMware Solution enterprise-scale scenario](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-business-continuity-and-disaster-recovery?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Enterprise-scale disaster recovery](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/disaster-recovery-enterprise-scale-dr)
- [SMB disaster recovery with Azure Site Recovery](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/disaster-recovery-smb-azure-site-recovery)
- [SMB disaster recovery with Double-Take DR](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/disaster-recovery-smb-double-take-dr)
- [Disaster recovery for enterprise bots](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/enterprise-chatbot-disaster-recovery)
- [Use Azure Stack HCI stretched clusters for disaster recovery](https://docs.microsoft.com/en-us/azure/architecture/hybrid/azure-stack-hci-dr)

### High availability

- [Build high availability into your BCDR strategy](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/build-high-availability-into-your-bcdr-strategy)
- [High availability and disaster recovery scenarios for IaaS apps](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/infrastructure/iaas-high-availability-disaster-recovery)
- [High availability enterprise deployment using App Service Environment]()
- [Highly available multi-region web application](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/multi-region)
- [Deploy highly available NVAs](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/nva-ha)
- [Highly available SharePoint farm](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/highly-available-sharepoint-farm)
- [Run a highly available SharePoint Server 2016 farm in Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/sharepoint)
- [Build solutions for high availability using availability zones](https://docs.microsoft.com/en-us/azure/architecture/high-availability/building-solutions-for-high-availability)

### Compliance and governance
- [Manage virtual machine compliance](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/security/virtual-machine-compliance)
- [Custom data sovereignty and data gravity requirements](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/data-sovereignty-and-gravity)
- [End-to-end governance in Azure when using CI/CD](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/governance/end-to-end-governance-in-azure)
- [Introduction of an AKS regulated cluster for PCI-DSS 3.2.1](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks-pci/aks-pci-intro)

## Best practices

[Governance best practices](/security/compass/governance?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

[Regulatory compliance](/azure/architecture/framework/security/design-regulatory-compliance)

[Administrative account security](/azure/architecture/framework/security/design-admins)

## Management and government architectures 

### Updates 

- [Plan deployment for updating Windows VMs in Azure](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wsus)
- [Azure Automation update management](https://docs.microsoft.com/en-us/azure/architecture/hybrid/azure-update-mgmt)

### archive 

### Hybrid management

- [Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)
- [Azure Automation in a hybrid environment](/azure/architecture/hybrid/azure-automation-hybrid)
- [Azure Automation update management](/azure/architecture/hybrid/azure-update-mgmt)
- [Back up files and applications on Azure Stack Hub](/azure/architecture/hybrid/azure-stack-backup)
- [Disaster recovery for Azure Stack Hub virtual machines](https://docs.microsoft.com/en-us/azure/architecture/hybrid/azure-stack-vm-disaster-recovery)
- [Hybrid availability and performance monitoring](https://docs.microsoft.com/en-us/azure/architecture/hybrid/hybrid-perf-monitoring)
- [Manage configurations for Azure Arc-enabled servers](https://docs.microsoft.com/en-us/azure/architecture/hybrid/azure-arc-hybrid-config)
- [Manage hybrid Azure workloads using Windows Admin Center](https://docs.microsoft.com/en-us/azure/architecture/hybrid/hybrid-server-os-mgmt)


## Stay current with management and governance

## Additional resources

### Example solutions

### any other? 

### AWS or Google Cloud professionals

- [AWS to Azure services comparison - Management and governance](/azure/architecture/aws-professional/services#management-and-governance)
- [Google Cloud to Azure services comparison - Management](/azure/architecture/gcp-professional/services#management)