Secure and efficient management of health data is critical for healthcare organizations. [Azure Health Data Services](/azure/healthcare-apis/healthcare-apis-overview) provides a powerful platform that these organizations can use to store, process, and analyze sensitive data while adhering to stringent security and compliance standards. However, deploying Health Data Services in a complex enterprise environment can be challenging if you don't have a reference architecture and implementation guide.

This article provides a sample architecture, an accompanying sample implementation, and a blueprint for deploying Health Data Services with enhanced security and integrating it with other Azure services. Following the practices outlined in this guide can improve your ability to safeguard your health data.

## Architecture

:::image type="content" source="./media/ahds-reference-architecture.png" alt-text="Architecture diagram that shows how to deploy Health Data Services on Azure and integrate with other Azure services." border="false":::

link 

## Workflow

1. Azure Application Gateway receives individual Fast Healthcare Interoperability Resources (FHIR) messages (for example, patient data) over an enhanced-security TLS connection that uses a Client Credentials Flow. Application Gateway sends the data via Azure API Management to the [Health Data Services FHIR service](/azure/healthcare-apis/fhir/overview), where it's persisted.
1. Simultaneously, a client can read the same FHIR data over a TLS connection via Application Gateway and API Management by using a tool like Postman.
1. For bulk data processing, Application Gateway receives FHIR bundles over a TLS connection that uses a Client Credentials Flow and loads the data into a storage account. A [FHIR Loader](https://github.com/microsoft/fhir-loader) Azure function that's integrated with the virtual network processes FHIR bundles and loads the data into the FHIR service.
1. If the incoming data is in HL7 version 2 or C-CDA format, you can first convert it to the FHIR format  by using the [$convert-data](/azure/healthcare-apis/fhir/convert-data) endpoint in the FHIR service. You can then post the data to the FHIR service by using Application Gateway. Azure Container Registry, connected via private endpoint, is used to store, with enhanced security, customized Liquid templates for converting HL7 v2 or C-CDA data to FHIR data. Container Registry is shown in the architecture diagram, but HL7 v2 / C-CDA to FHIR conversion via $convert-data isn't implemented by the Bicep template.
1. FHIR to Synapse Sync Agent extracts data from the FHIR service (for data ingested via either the individual or bulk data flow), converts the extracted data to hierarchical Parquet files, and writes it to Azure Data Lake Storage. 
1. Azure Synapse Analytics uses a serverless SQL or Spark pool to connect to Data Lake Storage to query and analyze FHIR data. Azure Synapse Analytics is shown in the architecture diagram, but it's not implemented by the Bicep template.
1. The hub virtual network contains a jumpbox virtual machine (VM) and an Azure Bastion host to provide enhanced-security access to the FHIR service configuration. Admins and operators can also use the jumpbox VM to test FHIR service endpoints without passing through Application Gateway and to bulk load FHIR data manually via Azure storage, bypassing Application Gateway.
1. If you establish on-premises network connectivity via Azure ExpressRoute or site-to-site VPN, on-premises users and services can directly access the FHIR service over this connection.

> [!Note]
> You can optionally add Web Application Firewall (WAF) to Application Gateway, but there's a known issue of WAF misidentifying FHIR objects and treating them as malicious code. If you need WAF, you need to manually modify your WAF ruleset to enable WAF to work with FHIR objects.

## Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory) is a multitenant cloud-based directory and identity management service. [Client applications are registered](/azure/healthcare-apis/register-application) in the Azure AD and can be used to access the Azure Health Data Services FHIR service.

- [Application Gateway](https://azure.microsoft.com/products/application-gateway/) is a platform as a service (PaaS) layer-7 load balancer that can act as a reverse-proxy service. Internal and external users access the FHIR APIs through Application Gateway via API Management.

- [API Management](https://azure.microsoft.com/products/api-management/) is a hybrid multicloud  platform for managing APIs across all environments. You can import FHIR APIs into API Management by using the [Swagger API definition](https://fhir2apim.azurewebsites.net/). You can use API Management to throttle inbound calls, authenticate/authorize users, and perform other tasks.

- [Azure Health Data Services](https://azure.microsoft.com/products/health-data-services) is a set of managed API services based on open standards and frameworks that enable workflows that improve healthcare and offer scalable, enhanced-security healthcare solutions. Azure Health Data Services FHIR service is deployed with private endpoint to help ensure that it can be accessed only from your virtual network or by external users over the internet via Application Gateway.

- [FHIR Loader](https://github.com/microsoft/fhir-loader) is an Azure Functions solution that provides services for importing FHIR bundles (compressed and non-compressed) and NDJSON files into a FHIR service.

- [Azure Key Vault](https://azure.microsoft.com/products/key-vault) is an Azure service for storing and accessing secrets, keys, and certificates with improved security. Key Vault provides HSM-backed security and audited access via role-based access controls that are integrated with Azure AD. In this architecture, Key Vault stores jumpbox credentials, Application Gateway certificates, FHIR service details, and FHIR Loader details.

- [Azure Container Registry](https://azure.microsoft.com/products/container-registry/) is a managed registry service that's based on the open-source Docker Registry 2.0. In this architecture, it's used to host [Liquid](https://shopify.github.io/liquid/) templates. You can use the $convert-data custom endpoint in the FHIR service to convert health data from HL7 v2 and C-CDA to FHIR. The $convert-data operation uses Liquid templates from [FHIR Converter](https://github.com/microsoft/FHIR-Converter) for FHIR data conversion.

- [FHIR to Synapse Sync Agent](https://github.com/microsoft/FHIR-Analytics-Pipelines/blob/main/FhirToDataLake/docs/Deploy-FhirToDatalake.md) is an [Azure container app](/azure/container-apps/) that extracts data from a FHIR server by using FHIR resource APIs, converts it to hierarchical Parquet files, and writes it to Data Lake Storage in near-real time. It also contains a script for creating external tables and views in Azure Synapse Analytics serverless SQL pool that point to the Parquet files. Although the architecture diagram shows FHIR to Synapse Sync Agent, Data Lake Storage, and Azure Synapse Analytics, the Bicep implementation doesn't currently include the code to deploy these services.

- [Azure Firewall](/azure/firewall/overview) is a cloud-native intelligent network firewall service that provides threat protection for your cloud workloads in Azure. In this architecture, a route table is used to route egress traffic from the hub virtual network through Azure Firewall to help ensure data exfiltration doesn't occur. Similarly, you an create route table routes and attach them to spoke virtual network subnets as needed to help prevent exfiltration of public health information data.

- The jumpbox is an Azure VM running Linux or Windows that users can connect to using Remote Desktop Protocol (RDP) or Secure Shell (SSH). Given most services (Health Data Services, APIM, Key Vault, etc.) in this architecture are deployed using private endpoint, we need a jumpbox VM to make more configuration changes or test these services. The jumpbox VM can only be accessed through the Azure Bastion service.

- [Azure Bastion](/azure/bastion/bastion-overview) lets you connect to a virtual machine using your browser, Azure portal, or via the native SSH/RDP client already installed on your computer. In this implementation, we use Azure Bastion service to securely access the jumpbox VM.

- Microsoft Defender for Cloud along [HIPAA & HITRUST](/azure/governance/policy/samples/hipaa-hitrust-9-2) compliance policy initiatives ensures Azure infrastructure deployment adheres to Microsoft Security Benchmark and Healthcare industry compliance requirements.

## Scenario details

This solution provides guidance on how to securely deploy Azure Health Data Services, ingest individual & bulk FHIR data and persist the data into the Health Data Services FHIR service.

### Potential use cases

- Once the solution is deployed successfully, FHIR messages (individual/bulk) can be loaded into FHIR service securely via Application Gateway.
- FHIR data can be retrieved securely via Application Gateway & API Management. APIM provides more capabilities to authenticate/authorize incoming calls and throttle requests as needed.
- To analyze FHIR data and extract insights, the FHIR Sync Agent can be deployed as shown in the architecture diagram (not deployed part of Bicep script). The agent reads data from the FHIR service, converts that data to parquet files and writes it to Azure Data Lake Gen2 (ADLS Gen2) storage. Azure Synapse can connect to ADLS Gen2 to query and analyze FHIR data.
- This solution can be extended to receive medical devices/wearable data using [MedTech service](/azure/healthcare-apis/iot/overview) in Health Data Services, transform the data to FHIR format and persist into FHIR service for extracting further insights using Synapse.
- This solution can be extended to ingest non FHIR data (HL7 V2 & C-CDA), convert to FHIR standard using Liquid templates (can be stored in Azure Container Registry) and persist in FHIR service.

## Deploy this solution

Follow the steps in the Getting Started section in GitHub to deploy this solution.
[Health Data Services Reference Architecture](https://github.com/Azure/ahds-reference-architecture)

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal author:

- [Umar Mohamed Usman](https://www.linkedin.com/in/umarmohamed/) | Principal Engineer

Other contributors:

- [Srini Padala](https://www.linkedin.com/in/srinivasa-padala/) | Senior Engineer
- [Sonalika Roy](https://www.linkedin.com/in/sonalika-roy-27138319/) | Senior Engineer
- [Victor Santana](https://www.linkedin.com/in/victorwelascosantana/) | Senior Engineer

line

## Next steps

- [Azure Health Data Services Workshop](https://github.com/microsoft/azure-health-data-services-workshop)

## Related resources

- [Get started with Azure Health Data Services](/azure/healthcare-apis/get-started-with-health-data-services)
- [FHIR-Bulk Loader & Export](https://github.com/microsoft/fhir-loader)
- [FHIR server Swagger generation for API Management](https://fhir2apim.azurewebsites.net/)
- [FHIR Converter to convert HL7 V2 & C-CDA to FHIR](https://github.com/microsoft/FHIR-Converter)
