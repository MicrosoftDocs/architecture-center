[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Cloud and hybrid solutions from Microsoft help you manage medical data storage efficiently and cost effectively, while infusing intelligence and maintaining compliance.

## Architecture

![Architecture diagram](../media/medical-data-storage.png)
*Download an [SVG](../media/medical-data-storage.svg) of this architecture.*

### Data flow

1. Securely ingest medical image data using Azure Data Factory.
1. Securely store medical image data in Azure Data Lake Store and/or Azure Blob Storage.
1. Analyze medical image data using a pre-trained Azure Cognitive Services API or a custom developed Machine Learning model.
1. Store artificial intelligence (AI) and Machine Learning results in Azure Data Lake.
1. Interact AI and Machine Learning results using PowerBI, while preserving Azure role-based access control (Azure RBAC).
1. Securely interact with medical image data via a web based vendor neutral archive (VNA) image viewer.

### Components

- [Data Factory](https://azure.microsoft.com/services/data-factory): Hybrid data integration at enterprise scale, made easy
- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage): Hyperscale repository for big data analytics workloads
- [Cognitive Services](https://azure.microsoft.com/services/cognitive-services): Add smart API capabilities to enable contextual interactions
- [Web Apps](https://azure.microsoft.com/services/app-service/web): Quickly create and deploy mission critical web apps at scale
- [Defender for Cloud](https://azure.microsoft.com/services/security-center): Unify security management and enable advanced threat protection across hybrid cloud workloads
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory): Synchronize on-premises directories and enable single sign-on
- [Key Vault](https://azure.microsoft.com/services/key-vault): Safeguard and maintain control of keys and other secrets
- Application Insights: Detect, triage, and diagnose issues in your web apps and services
- [Azure Monitor](https://azure.microsoft.com/services/monitor): Full observability into your applications, infrastructure, and network
- [Machine Learning](/azure/machine-learning): Easily build, deploy, and manage predictive analytics solutions
- [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded): Embed fully interactive, stunning data visualizations in your applications

## Next steps

- [Azure Data Factory V2 Preview Documentation](/azure/data-factory)
- [Data Lake Store Documentation](/azure/data-lake-store)
- [Get started with Azure](/azure/guides/developer/azure-developer-guide)
- [Web Apps overview](/azure/app-service/app-service-web-overview)
- [Microsoft Defender for Cloud Documentation](/azure/security-center)
- [Get started with Azure AD](/azure/active-directory/get-started-azure-ad)
- [What is Azure Key Vault?](/azure/key-vault/key-vault-overview)
- [Application Insights Documentation](/azure/application-insights)
- [Azure Monitor Documentation](/azure/monitoring-and-diagnostics)
- [Azure Machine Learning Documentation](/azure/machine-learning)
- [Power BI Embedded Documentation](/azure/power-bi-embedded)
