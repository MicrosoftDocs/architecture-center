> [!Note]
> For general updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This series of articles provides guidance for using SWIFT components on Azure. This article discusses the basic components of the architecture examples in the series.

The intended audience for the articles is program managers, architects, and engineers who implement SWIFT components on Azure. This documentation is organized into the following structure:

- A high-level overview of the Azure architecture for deploying SWIFT components (this article)
- A detailed reference architecture for each of the components (links in the [Related resources](#related-resources) section)

## Architecture

The following high-level reference architecture shows connectivity to the SWIFT network. For more information about SWIFT components, see the [SWIFT glossary](https://developer.swift.com/glossary).

:::image type="content" alt-text="Diagram that shows a SWIFT architecture." source="./media/swift-alliance-connect-virtual.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-vSRX-GA-allModules.vsdx) of this architecture. See the **vSRX-HA** tab.*

A SWIFT deployment on Azure contains various components. The key components are described in the following sections.

### Customer datacenter or colocation

This part of the architecture represents the on-premises site from which business users interact with SWIFT components. Any other business-processing applications that run on-premises can also connect with SWIFT components. There must be network connectivity between this site and Azure, where SWIFT components are deployed.

#### SWIFT Hardware Security Module

To ensure compliance with SWIFT's Customer Security Programme (CSP) - Customer Security Controls Framework (CSCF), the SWIFT Hardware Security Module (HSM) must be physically hosted. It can either be on-premises or in a colocation datacenter. Network connectivity between Azure and a site that runs HSM is required for deployment of SWIFT components.

#### Alliance Connect Virtual (vSRX) in a high availability configuration

SWIFT Alliance Connect Virtual is the connectivity component that you must connect to SWIFT, over the SWIFT Multi-Vendor Secure IP Network (MVSIPN). Per the CSP-CSCF, Alliance Connect Virtual is a cloud-deployable connectivity solution that can be hosted virtually in Azure. The architecture diagram shows the deployment of Alliance Connect Virtual in a high-availability configuration. The vSRX appliance deployed in two nodes addresses high-availability requirements by providing resiliency.

### SWIFT network connectivity and messaging components

SWIFT offers various connectivity components for enhanced-security financial message transfers. For information about choosing a connectivity module, see SWIFT's guidelines. Your functional requirements, volume of transactions, and security requirements might influence your choice. The next section describes the key components that are available to organizations that process payment message transfers.

### Alliance Connect Virtual network connectivity solution

SWIFT offers three Alliance virtual connectivity options. You can choose the option that's best suited to your message-traffic volumes and required level of resilience. For more information, see the specific messaging solution articles.

- **Alliance Connect Virtual Bronze.** With this option, you connect one VPN instance by using a single internet service provider (ISP). You can improve resilience by using two VPN instances and two ISP connections. In this scenario, traffic flows over the primary connection, and the back-up connection is used if the main connection fails.

- **Alliance Connect Virtual Silver.** With this option, you use Azure ExpressRoute as your primary connection and the internet as a backup. The dedicated ExpressRoute connections provide guaranteed bandwidths to SWIFT. Costs are reduced when you use a local internet connection as the backup channel when you use two VPN instances.

- **Alliance Connect Virtual Gold.** This option provides the highest service level and resiliency of the Alliance Connect products. Connectivity to SWIFT uses two ExpressRoute connections of equal capacity. This option is designed for customers that handle more than 40,000 messages per day and require the highest levels of resiliency.

We recommend that you read more about these options on the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).

Additionally, see the [Visio file](https://arch-center.azureedge.net/swift-alliance-vSRX-GA-allModules.vsdx) for architectures that illustrate the use of these solutions with each of the three connectivity options: Gold, Silver, and Bronze.

The next section describes the key components that are available to organizations that require SWIFT connectivity.

#### Alliance Access

If your configuration is based on Alliance Access, you need these components:

- Alliance Access, Web Platform, SWIFT Alliance Gateway (SAG) / SWIFTNet Link (SNL), and an Alliance Connect Virtual network connectivity solution
- An on-premises HSM appliance to help secure messages that are sent via SWIFTNet

#### Alliance Messaging Hub

If your configuration is based on Alliance Messaging Hub (AMH), you need these components:

- AMH, Workbench, SAG/SNL, and an Alliance Connect Virtual network connectivity solution
- An on-premises HSM appliance to help secure messages that are sent via SWIFTNet

#### Alliance Lite2

If your configuration is based on Alliance Lite2, you need these components:

- An Alliance Lite2 AutoClient virtual machine and an Alliance Connect Virtual network connectivity solution
- Physical token management from on-premises

#### Alliance Cloud

If your configuration is based on Alliance Cloud, you need these components:

- A SWIFT Integration Layer (SIL) virtual machine and an Alliance Connect Virtual network connectivity solution
- Physical token management from on-premises

### Deploying SWIFT solutions on Azure confidential computing

Confidential computing protects data when in use, along with any existing methods of protecting data at rest and in transit, thanks to Trusted Execution Environments (TEEs). TEEs encrypt and isolate code and data in an environment that can be configured so that even Azure, as the cloud provider, isn't allowed access. With confidential computing, customers have verifiable assurance that their workload data and code are under their control from the time the data and code are created until they're destroyed.

Some workloads require that their cloud operating environment ensures that the data is protected at all times during its entire lifecycle, even during rare events such as lawful data access or against a rogue employee. [Azure confidential virtual machines](/azure/confidential-computing/confidential-vm-overview) with AMD processors and SEV-SNP technology are available. These VMs provide a strong, hardware-enforced boundary to help meet your security needs. You can migrate your workload to Azure confidential VMs without making changes to your code. The platform protects your virtual machine's state from being read or modified.

Azure confidential VMs (DCasv5/ECasv5) offer a new, hardware-based TEE that uses SEV-SNP, where VM memory is encrypted with integrity guaranteed. The memory encryption key is hardware generated and safeguarded to prevent a potential neighbor attack. It also has hardened guest protections to deny the hypervisor and other host management code from accessing VM memory and state, which helps protect against operator access. Customers in regulated industries, such as banking, healthcare, and the public sector, can migrate their sensitive workloads from on-premises environments to the cloud with minimal performance impact and without code changes.

Other key features, such as verifiable remote attestation, vTPM, secure boot, and full OS disk confidential encryption, provide an enhanced security posture to confidential systems such as SWIFT Messaging components.

Customers, including Microsoft's own Microsoft Treasury group, have used [Azure confidential computing](/azure/confidential-computing/) to host the SWIFT connectivity modules for meeting higher security requirements. For now, only the connectivity modules can be deployed using Azure confidential computing. An Alliance Connect Virtual (ACV) virtual appliance can't be hosted in Azure confidential computing.

### Shared Azure services (optional)

This section describes shared services that complement all SWIFT components. Shared services can include monitoring, security, compliance, and other key management and operational services. Some of the key services are shown here:

:::image type="content" alt-text="Diagram that shows shared Azure services." source="./media/swift-shared-services.png" border="false":::

- You can use [Azure Policy](https://azure.microsoft.com/services/azure-policy) to enforce other security controls and SWIFT CSP requirements.
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) supports native SWIFT messaging. It provides more than 400 connectors to help you natively process and transform messaging.
- You can use [Azure Monitor](https://azure.microsoft.com/services/monitor) to monitor the SWIFT infrastructure that's running on Azure.
- You can use [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory) to integrate authentication and access control for users who access SWIFT components.
- You can use [Azure Key Vault](https://azure.microsoft.com/services/key-vault) to store the keys and certificates that are used for SWIFT components. Key Vault is a required component when you run Alliance Connect Virtual.

The proposed architecture shows the use of native Azure services, but you can use other Azure or partner services that meet the requirements.

#### Azure policies

In response to the cyberthreat landscape, SWIFT introduced the CSP, a set of mandatory security controls. Microsoft offers a blueprint to help you assess controls in the CSP framework. [Azure Blueprints](/azure/governance/blueprints/overview) is a free service that simplifies and supports control implementation. It also enables continuous monitoring and audit. By using Azure Blueprints, you can define a repeatable set of Azure resources and policies that implement and adhere to standards, patterns, and control requirements. You can use Azure Blueprints to set up governed Azure environments at scale that can help you keep your production implementations secure and compliant. Consider using the latest implementation of SWIFT CSP controls, but first consult with the Microsoft team that you're working with.

For more information, see [Overview of the SWIFT CSP-CSCF v2020 blueprint sample](/azure/governance/blueprints/samples/swift-2020).

#### Logic Apps

Logic Apps is an Azure [integration platform as a service (iPaaS)](https://azure.microsoft.com/products/category/integration) offering. It's a flexible, containerized cloud-scale workflow engine. Logic Apps provides native processing of SWIFT messaging, which can help you modernize your payments infrastructure in the cloud. It provides hybrid integration capabilities to on-premises applications via a virtual network to help you integrate a wide array of Azure services. Logic Apps provides more than 400 [connectors](/connectors/connector-reference/connector-reference-logicapps-connectors) for intelligent automation, integration, data movement, and more. The SWIFT connectors transform SWIFT flat file messages into XML and vice versa, and they provide validation based on the document schemas.

You can use a Logic Apps service to process payment transactions quickly. For example, you can integrate your back-end SAP systems to SWIFT, via Logic Apps, to process payment transactions and business acknowledgments. As part of this processing, Logic Apps validates the transactions and checks for duplicates and anomalies.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Gansu Adhinarayanan](https://www.linkedin.com/in/ganapathi-gansu-adhinarayanan-a328b121) | Director - Partner Technology Strategist 
- [Mahesh Kshirsagar](https://uk.linkedin.com/in/mahesh-kshirsagar-msft) | Senior Cloud Solution Architect
- [Ravi Sharma](https://www.linkedin.com/in/ravisharma4sap) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [SWIFT Interfaces and Integration](https://www.swift.com/our-solutions/interfaces-and-integration)
- [What is Azure Policy?](/azure/governance/policy/overview)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [What is Microsoft Entra ID?](/azure/active-directory/fundamentals/active-directory-whatis)
- [About Azure Key Vault](/azure/key-vault/general/overview)

## Related resources

Explore the following Azure architectures for SWIFT messaging interfaces:

- [SWIFT Alliance Access with Alliance Connect Virtual](swift-alliance-access-vsrx-on-azure.yml) 
- [SWIFT Alliance Messaging Hub (AMH) with Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml) 
- [SWIFT Alliance Cloud on Azure](swift-alliance-cloud-on-azure.yml)
- [SWIFT Alliance Lite2 on Azure](swift-alliance-lite2-on-azure.yml)
