Secure and efficient management of health data is critical for healthcare organizations. [Azure Health Data Services](/azure/healthcare-apis/healthcare-apis-overview) provides a powerful platform that these organizations can use to store, process, and analyze sensitive data while adhering to stringent security and compliance standards. However, deploying Health Data Services in a complex enterprise environment can be challenging if you don't have a reference architecture and implementation guide.

This article provides a sample architecture, an accompanying sample implementation, and a blueprint for deploying Health Data Services with enhanced security and integrating it with other Azure services. Following the practices outlined in this guide can improve your ability to safeguard your health data.

## Architecture

:::image type="content" source="media/azure-health-data-services.svg" alt-text="Architecture diagram that shows how to deploy Health Data Services on Azure and integrate with other Azure services." lightbox="media/azure-health-data-services.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-health-data-services.vsdx) of this architecture.* 

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

- [Health Data Services](https://azure.microsoft.com/products/health-data-services) is a set of managed API services based on open standards and frameworks that enable workflows that improve healthcare and offer scalable, enhanced-security healthcare solutions. Health Data Services FHIR service is deployed with private endpoint to help ensure that it can be accessed only from your virtual network or by external users over the internet via Application Gateway.

- [FHIR Loader](https://github.com/microsoft/fhir-loader) is an Azure Functions solution that provides services for importing FHIR bundles (compressed and non-compressed) and NDJSON files into a FHIR service.

- [Azure Key Vault](https://azure.microsoft.com/products/key-vault) is an Azure service for storing and accessing secrets, keys, and certificates with improved security. Key Vault provides HSM-backed security and audited access via role-based access controls that are integrated with Azure AD. In this architecture, Key Vault stores jumpbox credentials, Application Gateway certificates, FHIR service details, and FHIR Loader details.

- [Container Registry](https://azure.microsoft.com/products/container-registry/) is a managed registry service that's based on the open-source Docker Registry 2.0. In this architecture, it's used to host [Liquid](https://shopify.github.io/liquid/) templates. You can use the $convert-data custom endpoint in the FHIR service to convert health data from HL7 v2 and C-CDA to FHIR. The $convert-data operation uses Liquid templates from [FHIR Converter](https://github.com/microsoft/FHIR-Converter) for FHIR data conversion.

- [FHIR to Synapse Sync Agent](https://github.com/microsoft/FHIR-Analytics-Pipelines/blob/main/FhirToDataLake/docs/Deploy-FhirToDatalake.md) is an [Azure container app](/azure/container-apps/) that extracts data from a FHIR server by using FHIR resource APIs, converts it to hierarchical Parquet files, and writes it to Data Lake Storage in near-real time. It also contains a script for creating external tables and views in Azure Synapse Analytics serverless SQL pool that point to the Parquet files. Although the architecture diagram shows FHIR to Synapse Sync Agent, Data Lake Storage, and Azure Synapse Analytics, the Bicep implementation doesn't currently include the code to deploy these services.

- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall) is a cloud-native intelligent network firewall service that provides threat protection for your cloud workloads in Azure. In this architecture, a route table is used to route egress traffic from the hub virtual network through Azure Firewall to help ensure data exfiltration doesn't occur. Similarly, you an create route table routes and attach them to spoke virtual network subnets as needed to help prevent exfiltration of public health information data.

- The jumpbox is an Azure VM running Linux or Windows that administrators and operators can connect to by using Remote Desktop Protocol (RDP) or Secure Shell (SSH). Because most of the services (Health Data Services, API Management, Key Vault, and others) in this architecture are deployed with private endpoint, you need a jumpbox VM to make configuration changes or test these services. The jumpbox can only be accessed via Azure Bastion.

- [Azure Bastion](https://azure.microsoft.com/products/azure-bastion/) enables you to connect to a VM by using a browser, the Azure portal, or via the native SSH/RDP client on your computer. In this implementation, Azure Bastion provides enhanced-security access to the jumpbox VM.

- [Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud/) and [HIPAA and HITRUST](/azure/governance/policy/samples/hipaa-hitrust-9-2) compliance policy initiatives ensure that the Azure infrastructure deployment adheres to Microsoft cloud security benchmark and Healthcare industry compliance requirements.

## Scenario details

This solution provides guidance on how to deploy Azure Health Data Services with enhanced security, ingest individual and bulk FHIR data, and persist the data into the Health Data Services FHIR service.

You can use the the solution to load FHIR messages, individually and in bulk, into the FHIR service by using an enhanced-security Application Gateway connection.

To analyze FHIR data and extract insights, you can deploy the FHIR to Synapse Sync Agent as shown in the diagram. Azure Synapse Analytics can connect to Data Lake Storage to query and analyze FHIR data.

You can extend the solution to receive data from medical and wearable devices by using the Health Data Services [MedTech service](/azure/healthcare-apis/iot/overview). You can use this service to transform data to FHIR format and persist it to the FHIR service so that you can extract insights by using Azure Synapse Analytics.

You can also extend the solution to ingest non-FHIR data (HL7 v2 and C-CDA), convert it to FHIR by using Liquid templates, which you can store in Container Registry, and persist it in the FHIR service.

## Deploy this solution

To deploy this solution, follow the steps in 
[Getting Started](https://github.com/Azure/ahds-reference-architecture#getting-started).

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal author:

- [Umar Mohamed Usman](https://www.linkedin.com/in/umarmohamed/) | Principal Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer 
- [Srini Padala](https://www.linkedin.com/in/srinivasa-padala/) | Senior Engineer
- [Sonalika Roy](https://www.linkedin.com/in/sonalika-roy-27138319/) | Senior Engineer
- [Victor Santana](https://www.linkedin.com/in/victorwelascosantana/) | Senior Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Health Data Services Workshop](https://github.com/microsoft/azure-health-data-services-workshop)
- [Get started with Azure Health Data Services](/azure/healthcare-apis/get-started-with-health-data-services)
- [FHIR-Bulk Loader & Export](https://github.com/microsoft/fhir-loader)
- [FHIR server Swagger generation for API Management](https://fhir2apim.azurewebsites.net/)
- [Use FHIR Converter to convert HL7 v2 and C-CDA data](https://github.com/microsoft/FHIR-Converter)

## Related resources

- [Solutions for the healthcare industry](../../industries/healthcare.md)
- [What is Azure Health Data Services?](/azure/healthcare-apis/healthcare-apis-overview?toc=https%3A%2F%2Freview.learn.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.learn.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)