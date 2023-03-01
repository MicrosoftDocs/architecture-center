> [!Note]
> For general updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This series of articles provides guidance on using SWIFT components on Azure. This article discusses the basic components that the architecture examples in this series use.

The intended audience for the articles is program managers, architects, and engineers who are implementing SWIFT components on Azure. This documentation is organized into the following structure:

- A high-level overview of the Azure architecture to deploy SWIFT components (this article).
- A detailed reference architecture for each of the components (links in the [Related resources] section).

## Architecture

The following high-level reference architecture shows connectivity to the SWIFT network. For more information about the SWIFT components, see the [SWIFT glossary](https://developer.swift.com/glossary).

:::image type="content" alt-text="Diagram that shows a SWIFT architecture." source="./media/swift-alliance-connect-virtual.png" lightbox="./media/swift-alliance-connect-virtual.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/diagrams-swift-architecure-virtual-landing-page.vsdx) of this architecture.*

A SWIFT deployment on Azure contains various components. The key components are described in the next section.

### Customer datacenter or colocation

This solution area represents the on-premises site from which business users interact with SWIFT components. Any other business-processing applications that are running on-premises can also connect with SWIFT components. There must be network connectivity between this site and Azure, where SWIFT components are deployed.

#### SWIFT Hardware Security Module (HSM)

To comply with SWIFT's Customer Security Programme (CSP) - Customer Security Controls Framework (CSCF), the SWIFT Hardware Security Module (HSM) has to be physically hosted. It can either be on-premises or in a colocation datacenter. Network connectivity, between a site running HSM and Azure, is required for deployment of SWIFT components.

#### Alliance Connect Virtual (vSRX) in a high availability configuration

SWIFT Alliance Connect Virtual is the connectivity component that you need to connect, over the SWIFT Multi-Vendor Secure IP Network (MVSIPN), to SWIFT. Per the CSP-CSCF, Alliance Connect Virtual is a cloud-deployable connectivity solution that can be virtually hosted in Azure. The architecture diagram shows the deployment of Alliance Connect Virtual in a high-availability configuration. The vSRX appliance deployed in two nodes addresses high-availability requirements by providing resiliency.

### SWIFT network connectivity and messaging components

SWIFT offers various connectivity components for enhanced-security financial message transfers. For information about choosing a connectivity module, see SWIFT's guidelines. Your functional requirements, volume of transactions, and security requirements can influence that choice. The next section describes the key components that are available to institutions that process payment message transfers.

#### Alliance Connect Virtual network connectivity solution

SWIFT offers three Alliance virtual connectivity options. You can choose the option that's best suited to your message-traffic volumes and required level of resilience. For more information, see the specific messaging solution articles. 

- **Alliance Connect Virtual Bronze.** With this option, you connect one VPN instance by using a single internet service provider (ISP). You can improve resilience by using two VPN instances and two ISP connections. In this scenario, traffic flows over the primary connection, and the back-up connection is used if the main connection fails.

- **Alliance Connect Virtual Silver.** With this option, you use Azure ExpressRoute as your primary connection and the internet line as a backup. The dedicated ExpressRoute lines provide guaranteed bandwidths to SWIFT. Costs are significantly reduced when you use a local internet connection as the backup channel when you use two VPN instances.

- **Alliance Connect Virtual Gold.** This option provides the highest service level and resiliency of the Alliance Connect products. Connectivity to SWIFT uses two ExpressRoute connections of equal capacity. This option is designed for the customers that handle mor than 40,000 messages per day and require the highest levels of resiliency.

We recommend that you read more about these options on the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).
 
The next section describes the key components that are available to organizations that require SWIFT connectivity. 

#### Alliance Access

If your configuration is based on Alliance Access, you need these components:

- Alliance Access, Web Platform,  SWIFT Alliance Gateway (SAG) / SWIFTNet Link (SNL), and an Alliance Connect Virtual network connectivity solution.
- An on-premises HSM appliance to help secure messages that are sent via SWIFTNet.

#### Alliance Messaging Hub (AMH)

If your configuration is based on Alliance Messaging Hub (AMH), you need these components:

- AMH, Workbench, SAG/SNL, and an Alliance Connect Virtual network connectivity solution.
- An on-premises HSM appliance to help secure messages that are sent via SWIFTNet.

#### Alliance Lite2

If your configuration is based on Alliance Lite2, you need these components:

- An Alliance Lite2 AutoClient virtual machine and an Alliance Connect Virtual network connectivity solution.
- Physical token management from on-premises.

#### Alliance Cloud

If your configuration is based on Alliance Cloud, you need these components:

- A SWIFT Integration Layer (SIL) virtual machine and an Alliance Connect Virtual network connectivity solution.
- Physical token management from on-premises.

### Shared Azure services (optional)

This solution area includes services that complement all of SWIFT's components. Shared services can include monitoring, security, compliance, and other key management and operational services. Some of the key services are shown here:

image 
