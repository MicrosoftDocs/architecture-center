This series of articles provide guidance on using SWIFT components in Azure. This article discusses the basic components that the architecture examples use in this series.

The intended audiences for this article are program managers, architects, and engineers who are implementing SWIFT components in Azure. The article is organized into the following structure:

* A high-level overview of Azure architecture to deploy SWIFT components (this article).
* A detailed reference architecture for each of the components (links below).
* An automated Azure Resource Manager (ARM) template to customize and deploy the solution in Azure (referenced in the individual module pages).

## Architecture

The following diagram is a high-level Azure reference architecture of connectivity to the SWIFT network based on the Alliance Access and Alliance Messaging Hub (AMH) SWIFT messaging interfaces.
For more information on the SWIFT components, see [SWIFT Glossary](https://developer.swift.com/glossary).

![SWIFT Architecture](./media/swift-ref-arch.png)

*Download a [PowerPoint file](https://arch-center.azureedge.net/swift-ref-arch.pptx) of this architecture.*

SWIFT Azure architecture contains various components, and the key ones are explained in the next section.

### Customer data center or CoLo

This solution area represents the on-premises site from where business users will interact with SWIFT components securely. Any other business processing applications running on-premises can also connect with SWIFT components. There must be network connectivity between this site and Azure where SWIFT components are deployed.

#### SWIFT Hardware Security Module (HSM)

In accordance with SWIFT’s Customer Security Program (CSP) Control Framework (CSCF), the SWIFT HSM has to be physically hosted (on-premises or in a co-location data center). A network connectivity between site running HSMs and Azure is needed for SWIFT component deployment.

#### SWIFT VPN (SRX)

SWIFT VPN (SRX) is the connectivity component part of SWIFT's Alliance Connect offering required to connect to SWIFT. According to SWIFT's Customer Security Programme (CSP) Control Framework (CSCF), the SWIFT VPN needs to be physically hosted (on-premises or in a co-location data center).

### SWIFT messaging and connectivity components

SWIFT offers various connectivity components for secure payments and message transfers. Depending on the functional requirements, volume of transactions, and security requirements—customers can choose a specific connectivity module as per SWIFT guidelines. The next section describes the key components available for large banks processing payment message transfers.

#### Alliance Access

Customers with an Alliance Access based configuration will need the following:

* Alliance Access, Web Platform, and SAG (SWIFT Alliance Gateway)/SNL (SWIFTNet Link).
* On-premise SRX and HSM appliance to secure the message sent via SWIFTNet.

#### Alliance Messaging Hub (AMH)

Customers with an Alliance Messaging Hub (AMH) based configuration will the need following:

* Alliance Messaging Hub (AMH), Workbench and SAG (SWIFT Alliance Gateway)/SNL (SWIFTNet Link).
* On-premises SRX and HSM appliance to secure the message sent via SWIFTNet.

The Azure reference architecture described in this document uses Alliance Access and Alliance Messaging Hub (AMH).

### Customer's shared Azure services (optional)

This solution area includes services that compliment all SWIFT components. Shared services can include monitoring, security, compliance, and other key management/operational services. Some of the key services are as shown in following diagram:

![SWIFT Shared Services Architecture](./media/amh-on-azure-shared.png#lightbox)

* [Azure Policy](https://azure.microsoft.com/services/azure-policy) – can be used to enforce more security controls and SWIFT CSP requirements.
* [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) – supports native SWIFT messaging and can be used to natively process and transform messaging using 400+ connectors.
* [Azure Monitor](https://azure.microsoft.com/en-us/services/monitor) – can be used to monitor the SWIFT infrastructure running in Azure.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory) – can be used to integrate authentication and access control for users accessing SWIFT components.
* [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault) – can be used to store the keys and certificates securely to be used for various SWIFT components.  

While the proposed architecture recommends using native Azure services, customers can choose to use their existing Azure or partner services that meet the requirements.

#### Azure policies

In response to the rapidly increasing cyber threat landscape, SWIFT introduced the Customer Security Program (CSP) with a set of mandatory security controls. To simplify and support control implementation and enable continuous monitoring and audit, Microsoft has developed a blueprint for the CSP framework. Azure Blueprint is a free service that enables customers to define a repeatable set of Azure resources and policies that implement and adhere to standards, patterns, and control requirements.  Azure Blueprints allow customers to set up governed Azure environments at scale to aid secure and compliant production implementations. The [SWIFT CSP Blueprint](https://azure.microsoft.com/blog/new-azure-blueprint-enables-swift-connect) is now available in preview.

#### Logic Apps

Logic Apps is Microsoft Azure’s [integration platform as a service](https://argonsys.com/microsoft-cloud/glossary/platform-as-a-service) (iPaaS). It's a flexible, containerized, modern cloud-scale workflow engine you can run anywhere. Logic Apps now provides native understanding of SWIFT messaging, enabling customers to accelerate the modernization of their payments infrastructure by using the cloud. With hybrid VNet-connected integration capabilities to on-premises applications, including a wide array of Azure services, Logic Apps provides more than 400 [connectors](/connectors/connector-reference/connector-reference-logicapps-connectors) for intelligent automation, integration, data movement, and more. The SWIFT connectors transform SWIFT flat file messages into XML and vice versa and validates based on the document schemas.

Customers can use a Logic Apps service to process payment transactions quickly, reducing the implementation time from months to weeks. For example, customers can integrate their backend SAP systems via Logic Apps to SWIFT, to process payment transactions and business acknowledgments. As part of this processing, the transactions are validated and checked for duplicates or anomalies using the rich capabilities of Logic Apps.

## Next steps

* [SWIFT Interfaces and Integration](https://www.swift.com/our-solutions/interfaces-and-integration)
* [What is Azure Policy](/azure/governance/policy/overview)
* [What is Azure Logic Apps](/azure/logic-apps/logic-apps-overview)
* [Azure Monitor overview](/azure/azure-monitor/overview)
* [What is Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis)
* [About Azure Key Vault](/azure/key-vault/general/overview)

## Related resources

Explore each Azure Architecture for the various SWIFT messaging interfaces in detail as provided below.

* [Alliance Access](swift-alliance-access-on-azure.yml)
* [Alliance Messaging Hub (AMH)](swift-alliance-messaging-hub.yml)
