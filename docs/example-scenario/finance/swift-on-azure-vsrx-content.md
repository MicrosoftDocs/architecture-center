This series of articles provides guidance on using SWIFT's components in Azure. This article discusses the basic components that the architecture examples use in this series.

The intended audiences for this article are program managers, architects, and engineers who are implementing SWIFT's components in Azure. The article is organized into the following structure:

* A high-level overview of the Azure architecture to deploy SWIFT's components (this article).
* A detailed reference architecture for each of the components (links below).

## Architecture

The following diagram is a high-level Azure reference architecture of connectivity to the SWIFT network.
For more information on the SWIFT's components, see [SWIFT Glossary](https://developer.swift.com/glossary).

![Diagram showing the SWIFT architecture.](./media/swift-ref-arch-vsrx.png)

*Download a [Visio file](https://arch-center.azureedge.net/swift-main-page-vsrx-mvp.vsdx) of this architecture.*

A SWIFT deployment in Azure contains various components, and the key ones are explained in the next section.

### Customer data center or CoLo

This solution area represents the on-premises site from where business users will interact with SWIFT's components securely. Any other business processing applications that are running on-premises can also connect with SWIFT's components. There must be network connectivity between this site and Azure, where SWIFT's components are deployed.

#### SWIFT's Hardware Security Module (HSM)

In accordance with SWIFT’s Customer Security Program (CSP) Control Framework (CSCF), the SWIFT's Hardware Security Module (HSM) has to be physically hosted (on-premises or in a co-location data center). A network connectivity, between a site running HSMs and Azure, is needed for SWIFT's component deployment.

#### Alliance Connect Virtual (vSRX)

SWIFT's Alliance Connect Virtual is the connectivity component that's required to connect to SWIFT, over the SWIFT MVSIPN (Multi-Vendor Secure IP Network). According to SWIFT's Customer Security Programme (CSP) Control Framework (CSCF), the Alliance Connect Virtual is a cloud deployable connectivity solution, which can be virtually hosted in Azure.

### SWIFT messaging and connectivity components

SWIFT offers various connectivity components for secure financial message transfers. Depending on the functional requirements, volume of transactions, and security requirements, customers can choose a specific connectivity module, as per SWIFT guidelines. The next section describes the key components that are available to banks that process payment message transfers.

#### Alliance Access

Customers with an Alliance Access based configuration will need the following:

* Alliance Access, Web Platform, SAG (SWIFT Alliance Gateway)/SNL (SWIFTNet Link), and an Alliance Connect Virtual network connectivity solution.
* On-premises HSM appliance to secure the messages sent via SWIFTNet.

#### Alliance Messaging Hub (AMH)

Customers with an Alliance Messaging Hub (AMH) based configuration will the need following:

* Alliance Messaging Hub (AMH), Workbench, SAG (SWIFT Alliance Gateway)/SNL (SWIFTNet Link) and Alliance Connect Virtual network connectivity solution.
* On-premises HSM appliance to secure the message sent via SWIFTNet.

#### Alliance Lite 2

An Alliance Lite 2 based configuration will the need following:

* Alliance Lite 2 AutoClient Virtual Machine and an Alliance Connect Virtual network connectivity solution.
* Physical token management from on-premises.

#### Alliance Cloud

An Alliance Cloud based configuration will the need following:

* SWIFT Integration Layer (SIL) Virtual Machine and an Alliance Connect Virtual network connectivity solution.
* Physical token management from on-premises.

### Customer's shared Azure services (optional)

This solution area includes services that compliment all of SWIFT's components. Shared services can include monitoring, security, compliance, and other key management/operational services. Some of the key services are as shown in following diagram:

[![Diagram showing the SWIFT shared services architecture.](./media/amh-on-azure-shared.png#lightbox)](./media/amh-on-azure-shared.png#lightbox)

* [Azure Policy](https://azure.microsoft.com/services/azure-policy) can be used to enforce more security controls and SWIFT CSP requirements.
* [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) supports native SWIFT messaging and can be used to natively process and transform messaging, by using 400+ connectors.
* [Azure Monitor](https://azure.microsoft.com/services/monitor) can be used to monitor the SWIFT infrastructure that's running in Azure.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) can be used to integrate authentication and access control, for users accessing SWIFT components.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault) can be used to store the keys and certificates securely, to be used for various SWIFT components. Azure Key Vault is a mandatory component for running Alliance Connect Virtual.

While the proposed architecture recommends using native Azure services, customers can instead choose to use their existing Azure or partner services that meet the requirements.

#### Azure policies

In response to the rapidly increasing cyber threat landscape, SWIFT introduced the Customer Security Program (CSP), with a set of mandatory security controls. To simplify and support control implementation and to enable continuous monitoring and auditing, Microsoft has developed a blueprint for the CSP framework. Azure Blueprint is a free service that enables customers to define a repeatable set of Azure resources and policies that implement and adhere to standards, patterns, and control requirements.  Azure Blueprints allow customers to set up governed Azure environments at scale, in order to aid secure and compliant production implementations. Consider using the latest implementation of SWIFT CSP controls in Azure, after consulting the Microsoft team working with you.

#### Logic Apps

Logic Apps is Microsoft Azure's [integration platform as a service](https://azure.microsoft.com/product-categories/integration) (iPaaS). It's a flexible, containerized, and modern cloud-scale workflow engine that you can run anywhere. Logic Apps now provides native understanding of SWIFT messaging, which enables customers to accelerate the modernization of their payments infrastructure by using the cloud. Hybrid VNet-connected integration capabilities are available to on-premises applications. These capabilities include a wide array of Azure services. Logic Apps provides more than 400 [connectors](/connectors/connector-reference/connector-reference-logicapps-connectors) for intelligent automation, integration, data movement, and more. The SWIFT connectors transform SWIFT flat file messages into XML and vice versa, and they validate based on the document schemas.

Customers can use a Logic Apps service to process payment transactions quickly, which can reduce the implementation time. For example, customers can integrate their backend SAP systems via Logic Apps to SWIFT, to process payment transactions and business acknowledgments. As part of this processing, the transactions are validated and checked for duplicates or anomalies, by using the rich capabilities of Logic Apps.

## Next steps

* [SWIFT Interfaces and Integration](https://www.swift.com/our-solutions/interfaces-and-integration)
* [What is Azure Policy](/azure/governance/policy/overview)
* [What is Azure Logic Apps](/azure/logic-apps/logic-apps-overview)
* [Azure Monitor overview](/azure/azure-monitor/overview)
* [What is Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis)
* [About Azure Key Vault](/azure/key-vault/general/overview)

## Related resources

Explore the following Azure architecture for the various SWIFT messaging interfaces in detail:

* [SWIFT Alliance Connect in Azure](swift-on-azure-srx.yml)
* [Alliance Access with Alliance Connect](swift-alliance-access-on-azure.yml)
* [Alliance Access with Alliance Connect Virtual](swift-alliance-access-vsrx-on-azure.yml)
* [Alliance Messaging Hub (AMH) with Alliance Connect](swift-alliance-messaging-hub.yml)
* [Alliance Messaging Hub (AMH) with Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml)
* [Alliance Lite2](swift-alliance-lite-2-on-azure.yml)
* [Alliance Cloud](swift-alliance-cloud-on-azure.yml)
