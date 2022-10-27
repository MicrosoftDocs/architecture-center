[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for predicting and preventing future health incidents by combining Internet of Things (IoT) data and intelligence to optimize treatments. The solution uses Azure services to remotely monitor patients and analyze the massive amount of data that medical devices generate.

## Potential use cases

This solution is ideal for the medical and healthcare industry.

## Architecture

![Architecture diagram that shows how medical data flows through a system that uses AI to predict health incidents.](../media/remote-patient-monitoring.png)
*Download an [SVG](../media/remote-patient-monitoring.svg) of this architecture.*

### Dataflow

1. Azure IoT Hub securely ingests medical sensor and device data.
1. Azure Cosmos DB securely stores sensor and device data.
1. A pre-trained Azure Cognitive Services API or a custom-developed Azure Machine Learning model analyzes sensor and device data.
1. Azure Cosmos DB stores AI and Machine Learning results.
1. Power BI displays AI and Machine Learning results while preserving role-based access control in Azure.
1. Azure Logic Apps integrates data insights with backend systems and processes.

### Components

- [IoT Hub](https://azure.microsoft.com/services/iot-hub) connects, monitors, and manages billions of IoT assets.
- [Defender for Cloud](https://azure.microsoft.com/services/security-center) provides unified security management and advanced threat protection across hybrid cloud workloads.
- [Cognitive Services](https://azure.microsoft.com/services/cognitive-services) provides AI functionality. Its REST APIs and client library SDKs can help you build cognitive intelligence into apps.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) safeguards and maintains control of keys and other secrets.
- [Logic Apps](https://azure.microsoft.com/services/logic-apps) automates workflows. With this service, you can connect apps and data across clouds without writing code.
- [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded) provides a way to embed fully interactive, stunning data visualizations in your applications.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database that elastically scales throughput and storage.
- [Machine Learning](https://azure.microsoft.com/services/machine-learning) is a cloud-based environment that you can use to train, deploy, automate, manage, and track machine learning models. You can use the models to forecast future behavior, outcomes, and trends.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) gives you full observability into your applications, infrastructure, and network by collecting and analyzing data on environments and Azure resources.
- Application Insights is a feature of Monitor that provides code-level monitoring of application usage, availability, and performance.

## Next steps

- [IoT Hub documentation](/azure/iot-hub)
- [Defender for Cloud documentation](/azure/security-center)
- [Get Started with Azure](/azure/guides/developer/azure-developer-guide)
- [What is Azure Key Vault?](/azure/key-vault/key-vault-overview)
- [Azure Logic Apps documentation](/azure/logic-apps)
- [Power BI Embedded documentation](/azure/power-bi-embedded)
- [Azure Cosmos DB documentation](/azure/cosmos-db)
- [Application Insights documentation](/azure/application-insights)
- [Azure Machine Learning documentation](/azure/machine-learning)
- [Azure Monitor documentation](/azure/monitoring-and-diagnostics)

## Related resources

- [Predict hospital readmissions with traditional and automated machine learning techniques](../../example-scenario/ai/predict-hospital-readmissions-machine-learning.yml)
- [Create personalized marketing solutions in near real time](./personalized-marketing.yml)
- [Build a real-time recommendation API on Azure](../../reference-architectures/ai/real-time-recommendation.yml)
- [Build a movie recommendation system using machine learning](../../example-scenario/ai/movie-recommendations-with-machine-learning.yml)