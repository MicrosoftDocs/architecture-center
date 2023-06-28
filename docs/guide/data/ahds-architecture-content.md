In today's healthcare landscape, secure and efficient management of health data is paramount. Azure Health Data Services (AHDS) provides a powerful platform for healthcare organizations to store, process, and analyze their sensitive data while adhering to stringent security and compliance standards. However, deploying AHDS in a complex enterprise environment can be challenging without a clear reference architecture and implementation guide.

This solution provides [AHDS](/azure/healthcare-apis/healthcare-apis-overview) reference architecture and a comprehensive reference implementation. This aims to empower healthcare customers by providing them with a clear blueprint for deploying AHDS securely and integrating it with various Azure services. By following the recommended best practices outlined in this guide, organizations can gain confidence in their ability to safeguard their health data effectively.

## Architecture

:::image type="content" source="./media/ahds-reference-architecture.png" alt-text="Architecture diagram showing how to deploy Azure Health Data Services securely on Azure and integrate with various Azure services." border="false":::

## Workflow

1. Azure Application Gateway receives individual (single) Fast Healthcare Interoperability Resources (FHIR®) data (example patient data) over a secure TLS connection using client credentials flow and sends it to FHIR Service to persist via API Management.
1. Simultaneously a client can read same FHIR data (example: patient data) over a secure TLS connection via Application Gateway using tools like Postman.
1. For bulk data processing, Azure Application Gateway securely receives FHIR bundles over a TLS connection using client credentials flow and loads into storage account. VNet integrated [FHIR Loader](https://github.com/microsoft/fhir-loader) Function process FHIR bundles and loads it in to FHIR service.
1. Optionally Web Application Firewall(WAF) can be added to Application Gateway, but there are known limitations with WAF not recognizing FHIR objects and treating it as malicious code. If WAF is needed, then WAF ruleset needs to be manually tweaked to work with FHIR objects.
1. If the incoming data is in HL7 V2 or in C-CDA format, then it can be converted to FHIR format first using [$convert-data](/azure/healthcare-apis/fhir/convert-data) endpoint in the FHIR service then it can be posted to FHIR service via Application Gateway.
1. API Management can be used to authenticate/authorize incoming requests and throttle (rate-limit) calls, etc. as needed.
1. FHIR service under Azure Health Data Services with private endpoint is deployed to ensure no publicly accessible endpoint and to securely persist FHIR data.
1. Azure Container Registry (ACR) with private endpoint is used for securely storing customized liquid templates for converting HL7v2/C-CDA data to FHIR data. While ACR is shown in the architecture diagram, HL7v2/C-CDA to FHIR conversion using \$convert-data isn't implemented part of bicep reference implementation.
1. FHIR to Synapse Sync Agent extracts data from FHIR service, converts to hierarchical parquet files, and writes it to Azure Data Lake Gen2 (ADLS Gen2). While the data extraction shown in the architecture diagram, it's not implemented part of bicep reference implementation.
1. Azure Synapse uses serverless SQL/Spark pool to connect to ADLS Gen2 to query and analyze FHIR data. While Azure Synapse shown in the architecture diagram, it's not implemented part of bicep reference implementation.
1. Hub virtual network contains jumpbox VM along with Azure Bastion Host to securely access FHIR service configuration. Jumpbox VM is also used for testing FHIR service endpoints without Application Gateway and bulk loading FHIR data manually through Azure storage.
1. If on-premises network connectivity established over Site-to-Site VPN or Express Route then on-premises users/services can directly access FHIR service over this connection if needed, instead of connecting through Application Gateway.
1. Microsoft Defender for Cloud along [HIPAA & HITRUST](https://learn.microsoft.com/en-us/azure/governance/policy/samples/hipaa-hitrust-9-2) compliance policy initiatives ensures Azure infrastructure deployment adheres to Microsoft Security Benchmark and Healthcare industry compliance requirements.

## Components

- [Azure Active Directory (Azure AD)](/azure/active-directory/) is a multitenant cloud-based directory and identity management service. [Client applications are registered](/azure/healthcare-apis/register-application) in the Azure AD and can be used to access the Azure Health Data Services FHIR service.

- [Azure Application Gateway](/azure/application-gateway/overview) is a platform as a service (PaaS) component that acts as a Layer-7 load balancer. It acts as a reverse-proxy service and it makes FHIR APIs under API Management to be easily consumable by both internal consumers and external consumers.

- [Azure API Management (APIM)](/azure/api-management/api-management-key-concepts) is a hybrid, multicloud management platform for APIs across all environments. FHIR APIs are imported in to API Management using [Swagger API definition](https://fhir2apim.azurewebsites.net/). APIM can be used to throttle (rate-limit) inbound calls, authenticate/authorize, etc. as needed.

- [Azure Health Data Services](/azure/healthcare-apis/get-started-with-health-data-services) is a set of managed API services based on open standards and frameworks that enable workflows to improve healthcare and offer scalable and secure healthcare solutions. It's deployed securely with private endpoint to ensure it can only be access from your virtual network. It can be accessed over the internet via Application Gateway.

- [FHIR Loader](https://github.com/microsoft/fhir-loader) is an Azure Function App solution that provides services to import FHIR Bundles (compressed and non-compressed) and NDJSON files into a FHIR service.

- [Azure Key Vault](/azure/key-vault/general/overview) is an Azure service for storing and accessing secrets, keys, and certificates with improved security. Key Vault provides HSM-backed security and audited access through role-based access controls that are integrated with Azure AD. In this architecture, Key Vault stores all jumpbox credentials, application gateway certificate, FHIR service details, etc.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed registry service based on the open-source Docker Registry 2.0. In this architecture, it's used to host [Liquid](https://shopify.github.io/liquid/) templates. Using \$convert-data custom endpoint in the FHIR service, you can convert health data from various formats (HL7 V2, C-CDA) to FHIR. The \$convert-data operation uses Liquid templates from the [FHIR Converter](https://github.com/microsoft/FHIR-Converter) project for FHIR data conversion.

- [FHIR to Synapse sync agent](https://github.com/microsoft/FHIR-Analytics-Pipelines/blob/main/FhirToDataLake/docs/Deploy-FhirToDatalake.md) is an [Azure Container App](/azure/container-apps/) that extracts data from a FHIR server using FHIR Resource APIs, converts it to hierarchical parquet files, and writes it to Azure Data Lake in near real time. It also contains a script to create external tables and views in Synapse Serverless SQL pool pointing to the parquet files. While the architecture diagram shows FHIR to Synapse sync agent, Azure Data Lake Gen2 and Azure Synapse services, the bicep reference implementation doesn't include the code to deploy these services yet.

- [Azure Firewall](/azure/firewall/overview) is a cloud-native and intelligent network firewall security service that provides the best of breed threat protection for your cloud workloads running in Azure. In this architecture egress traffic from Hub virtual network (jumpbox VM subnet) is forced to go to Azure Firewall using route table to ensure data exfiltration doesn't happen. Similarly, route table routes can be created and attached to necessary Spoke virtual network subnets as well to prevent any PHI data exfiltration.

- Jumpbox VM is an Azure virtual machine (VM) that's running Linux or Windows and to which users can connect via the Remote Desktop Protocol (RDP) or Secure Shell (SSH). Given most services (AHDS, APIM, Key Vault, etc.) in this architecture are deployed using private endpoint, we need a jumpbox VM to make more configuration changes or test these services. Public IP address isn't assigned to jumpbox VM and it can be accessed via Azure Bastion service.

- [Azure Bastion](/azure/bastion/bastion-overview) lets you connect to a virtual machine using your browser, Azure portal, or via the native SSH/RDP client already installed on your computer. In this implementation, we use Azure Bastion service to securely access the jumpbox VM.

## Scenario details

This reference architecture provides guidance on how to securely deploy Azure Health Data Services, ingest individual & bulk FHIR data and persist in to FHIR service.

### Potential use cases

- Once the reference architecture deployed successfully, FHIR messages (individual/bulk) can be loaded in to FHIR service securely via Application Gateway.
- FHIR data can be retrieved securely via Application Gateway & API Management. APIM provides more capabilities to authenticate/authorize incoming calls and throttle requests as needed.
- To analyze FHIR data and extract insights, FHIR Sync Agent can be deployed as shown in the architecture diagram (not deployed part of Bicep script). It reads data from FHIR service, converts to parquet files and writes it to Azure Data Lake Gen2 (ADLS Gen2). Azure Synapse can connect to ADLS Gen2 to query and analyze FHIR data.
- This solution can be extended to receive medical devices/wearable data using MedTech service part of Azure Health Data Services and eventually persist in to FHIR service for extracting further insights using Synapse.
- This solution can be extended to ingest non FHIR data (HL7 V2 & C-CDA), convert to FHIR standard using Liquid templates (can be stored in Azure Container Registry) and persist in FHIR service.

## Deploy this solution

Follow the steps in the Getting Started section in GitHub to deploy this solution.
[AHDS Reference Architecture](https://github.com/Azure/ahds-reference-architecture)

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

**Principal authors:**

- [Umar Mohamed Usman](https://www.linkedin.com/in/umarmohamed/) | Principal Engineer

**Other contributors:**

- [Victor Santana](https://www.linkedin.com/in/victorwelascosantana/) | Senior Engineer
- [Sonalika Roy](https://www.linkedin.com/in/sonalika-roy-27138319/) | Senior Engineer
- [Srini Padala](https://www.linkedin.com/in/srinivasa-padala/) | Senior Engineer

## Next steps

- [Azure Health Data Services Workshop](https://github.com/microsoft/azure-health-data-services-workshop)

## Related resources

- [Get started with Azure Health Data Services](/azure/healthcare-apis/get-started-with-health-data-services)
- [FHIR-Bulk Loader & Export](https://github.com/microsoft/fhir-loader)
- [FHIR server Swagger generation for API Management](https://fhir2apim.azurewebsites.net/)
- [FHIR Converter to convert HL7 V2 & C-CDA to FHIR](https://github.com/microsoft/FHIR-Converter)
