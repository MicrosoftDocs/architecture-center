The articles in this series describe an approach for designing a disaster recovery (DR) strategy for an Azure-based data platform. 

Every organization's data needs are different, but the guidance provided will act as starting point, enabling the design of a DR strategy that fits your business requirements.  

## Key terms glossary

**Term**|**Definition**|**Notes**
:-----:|:-----:|:-----:
Azure AD|Azure Active Directory|[Azure Active Directory](https://azure.microsoft.com/en-us/services/active-directory/)
ACL|Access Control Lists| 
ADLS|Azure Data Lake Storage|[Azure Data Lake Storage Gen2 Introduction](/azure/storage/blobs/data-lake-storage-introduction)
AKS|Azure Kubernetes Service|[Azure Kubernetes Service (AKS) documentation](/azure/aks/)
ARM|Azure Resource Manager|[ARM template documentation](/en-us/azure/azure-resource-manager/templates/)
BAU|Business As Usual| 
BC|Business Continuity|[Business continuity management program in Azure](/azure/availability-zones/business-continuity-management-program)
BCDR|Business Continuity and Disaster Recovery|[Business continuity management in Azure](/azure/reliability/business-continuity-management-program)
CI/CD|Continuous Integration & Continuous Deployment|[Azure DevOps - CI/CD Overview](/azure/devops/pipelines/apps/cd/azure/cicd-data-overview?view=azure-devops#what-is-cicd) 
DR|Disaster Recovery| 
DNS|Domain Name System| 
DSC|Desired State Configuration| 
E2E|End to End| 
GRS|Geo-redundant storage |[Storage Redundancy](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region)
HA|High Availability| 
HSM|Hardware Security Module|[Azure Managed HSM documentation](/azure/key-vault/managed-hsm/)
IAC|Infrastructure As Code| 
IAAS|Infrastructure As A Service|[What is IaaS? Infrastructure as a Service](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-iaas/#overview)
IOT|Internet of Things| 
ITIL|Information Technology Infrastructure Library|
KDD|Key Design Decision| 
LRS|Locally Redundant Storage|[Data redundancy - Azure Storage](/azure/storage/common/storage-redundancy)
MSEE|Microsoft Enterprise Edge| 
MTO|Maximum Tolerable Outage|The maximum acceptable amount of time that dependent business processes can tolerate the platform being unavailable. </br>*MTO = RTO + WRT*
MVP|Minimum Viable Product | 
NFR|Non-Functional Requirement|Requirements on a solution or system related to usability, scalability, security and accessibility rather than functionality.
NSG|Network Security Group|[Azure network security groups overview](/azure/virtual-network/network-security-groups-overview)
OPEX|Operational Expenditure| 
PaaS|Platform As A Service|[What is PaaS? Platform as a Service](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-paas/)
PIR|Post-Incident Review| 
RA-GZRS|Read-Access Geo-Zone-Redundant Storage|[Data redundancy - Azure Storage](/azure/storage/common/storage-redundancy)
RPO|Recovery Point Objective|The maximum acceptable amount of data/processing loss, measured in time.
RTO|Recovery Time Objective|The maximum acceptable amount of time needed to recover the Data platform service and bring it back online.
SaaS|Software As A Service|[What is SaaS? Software as a Service](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-saas/)
SDLC|Software Development Lifecycle| 
SME|Subject Mater Expert| 
SLA|Service Level Agreement| 
SSO|Single sign-on| 
UDR|User Defined Route|[Azure virtual network traffic routing](/azure/virtual-network/virtual-networks-udr-overview)
VM|Virtual Machine|[Virtual Machines (VMs) for Linux and Windows](https://azure.microsoft.com/en-us/services/virtual-machines/)
VNET|Azure – Virtual Network|[Azure Virtual Network](/azure/virtual-network/virtual-networks-overview)
WRT|Work Recovery Time|The maximum acceptable amount of time that is required to update the platform data/processing from the recovery point to the current period, enabling the business/solutions to use the service as BAU.
ZRS|Zone-Redundant Storage|[Data redundancy - Azure Storage](/azure/storage/common/storage-redundancy)

## Contributors

*Microsoft maintains this article. The following contributors originally wrote it.*

Principal authors:

- [Hajar Habjaoui](https://www.linkedin.com/in/hajar-habjaoui-36b10b97/) | Cloud Solution Architect
- [Justice Zisanhi](https://www.linkedin.com/in/justice-zisanhi/) | Cloud Solution Architect
- [Scott Mckinnon](https://www.linkedin.com/in/scott-mckinnon-96756a83) | Cloud Solution Architect

Other contributors:

- [Ananth Prakash](https://www.linkedin.com/in/ananthprakashj/) | Senior CSA Manager
- [Fabio Braga](https://www.linkedin.com/in/fabiohemylio/) | Chief Architect – Customer Success
- [Rolf Tesmer](https://www.linkedin.com/in/rolftesmer/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/secure/business-resilience)
- [Mission-critical workload](/azure/architecture/framework/mission-critical/mission-critical-overview)
- [Well-Architected Framework](/azure/architecture/framework/resiliency/)


## Related resources

- [DR for Azure Data Platform - Overview](dr-for-azure-data-platform-overview.yml)
- [DR for Azure Data Platform - Architecture](dr-for-azure-data-platform-architecture.yml)
- [DR for Azure Data Platform - Scenario details](dr-for-azure-data-platform-scenario-details.yml)
- [DR for Azure Data Platform - Recommendations](dr-for-azure-data-platform-recommendations.yml)
