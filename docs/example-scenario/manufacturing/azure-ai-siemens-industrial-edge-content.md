This article shows you how to run Azure AI models on Siemens Industrial Edge IoT devices and monitor those devices from a central location in Azure. The architecture simplifies the integration process between Azure and Siemens Industrial AI services and focuses on two operational areas:

- **Deploy Azure AI models to Siemens Industrial Edge devices.** This operational area includes implementing Azure Machine Learning pipelines for automated model training, evaluation, and registration. It also includes automating the secure and approved deployment of AI models trained on Azure from the cloud to the on-premises Siemens AI Model Manager.

- **Centralize telemetry from Siemens Industrial Edge devices in Azure.** This operational area includes pushing inference logs and metrics to the cloud, which enables centralized monitoring of edge applications in Azure.

## Architecture

:::image type="content" source="media/azure-ai-siemens-industrial-edge.svg" alt-text="Diagram that shows the workflow of the data pipeline." lightbox="media/azure-ai-siemens-industrial-edge.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-ai-siemens-industrial-edge.vsdx) of this architecture.*

### Workflow

1. The data pipeline:

    a. Loads raw training data from a dedicated raw data store storage container. Then the pipeline processes raw training data and shapes it to the acceptable format for model training.

    b. Saves the processed data into the processed dataset storage container.

1. The model development pipeline is executed after the raw data is processed. The model development pipeline:

    a. Loads processed training data from processed dataset storage container and performs model training.

    b. Saves the resulting model into the model catalog.

1. The validate and packaging pipeline is executed after the model is trained. The validate and packaging pipeline:

    a. Loads the model from the model catalog and performs model validation.

    b. If the model passes validation, the pipeline uses the Siemens AI SDK library to package and save the model into the packaged models storage container.

1. The tagging and delivery pipeline is executed after the packaged model is saved. The tagging and delivery pipeline retrieves the trained model from the model catalog and tags it with more metadata, including pipeline version details and date created data version information. Then the pipeline saves the model in the container registry.

1. The delivery pipeline initiates an exchange of messages between the Machine Learning pipeline and the Siemens AI Model Manager (AIMM) through the IoT Hub and Event Hubs. This loop is crucial for managing and coordinating the deployment of a new model:

    a. The delivery pipeline sends a message through IoT Hub to inform Siemens AIMM that a new model is ready for deployment.

    b. Siemens AIMM receives this notification and assesses the current state of the edge devices to determine readiness for the new model. After it's ready, Siemens AIMM responds back to the IoT Hub with a request for the new model.

    c. The delivery pipeline generates a shared access signature (SAS) link for the model package in the packaged models storage container.  

    d. The delivery pipeline sends this SAS link back to Siemens AIMM through IoT Hub, which enables it to download the model.

1. After Siemens AIMM receives the SAS link from the delivery pipeline, it reaches out to the packaged models storage container and downloads the latest packaged model.

1. Siemens AIMM runs internal processes to deploy the latest packaged model to the Siemens AI Inference Server (AIIS).

1. Siemens AIIS uses OpenTelemetry Collector to send metrics to the Siemens AI Model Monitor.

1. Siemens AI Model Monitor aggregates all the logs and metrics from the edge devices and services and sends this information to Azure Monitor.

1. Data recycling includes the following steps:  

    a. The Data Collector collects inference data that's produced by the running model in the Siemens AIIS.  

    b. The Data Collector passes the data to the Data Collector Hub to pass on to Azure Storage.  

    c. The Data Collector Hub uploads the data into the data landing zone storage account for further retraining of the model.

## Observability architecture

:::image type="content" source="media/siemens-observability.svg" alt-text="Diagram that shows the workflow of the Siemens Observability architecture." lightbox="media/siemens-observability.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/siemens-observability.vsdx) of this architecture.*

To ensure the smooth transfer of logs and metrics from Siemens Industrial Edge devices to Azure, the architecture uses the Azure Monitor Exporter from OpenTelemetry Collector and the Authentication Proxy. Siemens AI Model Monitor deploys these components as integral parts. This setup enables you to export logs and metrics to Application Insights and an Azure Monitor workspace. It uses a managed identity from Microsoft Entra ID as the key authentication mechanism.

Telemetry data flows from the operational technology layer to an instance of the OpenTelemetry Collector in the information technology layer. This collector exports the data to Application Insights and uses the Authentication Proxy to acquire a Service Principal identity. This process strengthens the authentication from using a shared secret, or instrumentation key, to a fully certificate-backed Microsoft Entra ID identity. An Azure DevOps pipeline automates the generation and distribution of the certificates, service principals, and the association of relevant roles and permissions.

For a more generic solution, see [OpenTelemetry Collector for legacy IoT scenarios](https://techcommunity.microsoft.com/t5/azure-architecture-blog/opentelemetry-collector-for-legacy-iot-scenarios/ba-p/4082417).

## Components

The Siemens Industrial Edge components include:

- [AI Model Monitor](https://www.dex.siemens.com/edge/build-your-solution/ai-model-monitor) collects telemetry information, logs, metrics on model performance and edge devices.

- [AI Model Manager (AIMM)](https://www.dex.siemens.com/edge/build-your-solution/ai-model-manager?cclcl=de_DE) is a service that's responsible for the orchestration of edge devices and model distribution.

- [AI Inference Server](https://www.dex.siemens.com/edge/manufacturing-process-industries/ai-inference-server) runs on Siemens Industrial Edge devices and uses the built-in Python Interpreter to execute deployed AI models for inference purposes.

- The [AI Software Development Kit](https://www.siemens.com/global/en/products/automation/topic-areas/artificial-intelligence-in-industry/industrial-ai-enabled-operations/software-development-kit.html) enables you to package your model, including preprocessing logic and post-processing logic, into a standard inference pipeline that runs on the AI Inference Server. You can achieve this process by using our Python Software Development Kit while maintaining your existing coding and training environment.

- Siemens Data Collector collects inference data from Siemens AIIS for further processing.

- The Siemens Data Collector Hub collects inference data from all Data Collectors to pass to the cloud for further processing.

## Azure components

For each component in the architecture, use the relevant service guide in the Well-Architected Framework where available. For more information, see the [Well-Architected Framework service guides](/azure/well-architected/service-guides).

- [Azure IoT Hub](/azure/iot-hub/iot-hub-devguide) facilitates communication for model delivery between the cloud and Edge. Registering the AI Model Manager as an edge device enables the cloud service to send cloud-to-device messages.

- [Machine Learning workspace](/azure/machine-learning/concept-workspace) acts as a central hub that streamlines the creation, organization, and hosting of machine learning artifacts and tasks for teams. It covers jobs, pipelines, data assets, models, and endpoints.

- [Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource) is an Azure solution that provides insights into the performance and health of applications and resources. It provides tools to collect, analyze, and act on telemetry data.  

- [Storage](/azure/storage/) is a cloud-based container or repository that enables users to store and manage various types of data in a scalable and accessible manner.

- [Azure Key Vault](/azure/key-vault/general/overview) is a cloud service that securely manages and stores sensitive information such as secrets, encryption keys, and certificates. It provides centralized control over access and audit trails.

- [Azure Container Registry](/azure/aks/tutorial-kubernetes-prepare-acr?tabs=azure-cli) is a managed, private registry service that you can use to build, store, and manage container images and related artifacts. When you create a new Machine Learning workspace, it automatically creates a Container Registry. Container Registry stores Docker containers that you can use to train and deploy models. The Docker containers encapsulate the environment where your machine learning training happens. This process ensures a consistent, reproducible, and isolated environment, which is crucial for machine learning workflows.

## Alternatives

We recommend that you replace IoT Hub with [Azure Event Grid’s MQTT broker feature](/azure/event-grid/mqtt-overview) as the long-term solution. [Event Grid](/azure/event-grid/mqtt-overview) is a fully managed, highly scalable publish and subscribe message distribution service. It uses MQTT and HTTP protocols to support flexible message consumption patterns.

- Consider using the [Azure Monitor Edge pipeline](/azure/azure-monitor/essentials/edge-pipeline-configure) on Azure Arc for pushing logs and metrics to Azure, which replaces the OpenTelemetry components in your architecture. This approach offers seamless and secure connectivity to Azure. It also enhances the extensibility of Siemens factory IT to the Azure cloud, which simplifies identity management. This alternative results in:

  - Faster commissioning for the customer.
  - Reduced support from Siemens during commissioning.
  - Access to observability data lowers the cost of operation.

- You can use the [GitLab Accelerator](https://gitlab.com/rburteamicrosoft/gitlab-accelerator) to develop your machine learning pipelines and further develop extra functionalities in Azure with the examples provided in this implementation.

## Scenario details

This scenario addresses the challenge of integrating machine learning models developed in Azure with factory operations that Siemens Industrial Edge devices manages. The primary objective is to ensure efficient, secure, and automated deployment and monitoring of AI models in industrial environments.

The need for seamless and reliable deployment of AI-driven applications in manufacturing and strict operational requirements prompted the development of this architecture. This solution minimizes manual intervention, reduces production disruptions, and enhances the visibility of machine learning models on the shop floor.

## Potential use cases

This architecture builds a closed-loop environment for data collection, AI modeling, training, deployment, inference, and monitoring based on Siemens and Microsoft products. It enables the scalable implementation of AI use cases across various industries, such as electronics, consumer packaged goods, automotive, and batteries.  

The architecture reduces manual effort and costs by integrating cloud model preparation, cloud-to-edge model transfer, and field model execution. It also provides edge-to-cloud monitoring and creates a cost-effective solution with a low initial investment in AI hardware and software.  

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability  

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Use [Azure availability zones](https://azure.microsoft.com/explore/global-infrastructure/availability-zones/) for supported Azure services to improve reliability within the same Azure region.

- When you use Azure Blob storage, make sure to configure the appropriate redundancy and failover configurations for your [Storage Account](/azure/storage/common/storage-disaster-recovery-guidance).

- Use code level patterns to handle transient network issues and message persistence capabilities to protect against transient software and hardware failures.

  - [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) for Azure Architecture Center.
  - [Retry pattern](/azure/architecture/patterns/retry) for Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist). This architecture applied the following commonly used security principles:

- Use Microsoft Entra ID as your primary tool for managing identity and access control.

- Conduct a comprehensive Threat Modeling exercise during the planning phase of your solution to identify potential security risks and design mitigation strategies. For more information, see [Microsoft Security Development Lifecycle Threat Modeling](https://www.microsoft.com/securityengineering/sdl/threatmodeling).

- Use managed identities where supported and store all other secrets in Key Vault. Configure settings for soft delete, enable logging, and tighten access control to enhance the security of the Key Vault.

- Apply the principle of least privilege by using role-based access control (RBAC) to regulate access and permissions to resources. For more information, see [What is Azure RBAC?](/azure/role-based-access-control/overview).

- Use [virtual networks](/azure/virtual-network/virtual-networks-overview) and [private endpoints](/azure/private-link/private-endpoint-overview) to secure cloud services and cloud-to-edge communication.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Review and optimize the volume of data stored in Log Analytics regularly by adjusting retention periods and archive policies. This strategy can significantly reduce storage costs.

- Take advantage of the free 30-day retention period for ingested data. After this period, consider archiving less-critical data to lower cost storage or reduce retention periods to minimize ongoing expenses. For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/#pricing).

- Assess the necessity and usage of dependent resources such as Key Vault, Application Insights, Container Registry, and Storage accounts. Optimize their configurations to avoid unnecessary costs.  

- Review the size and scale of these resources regularly to ensure they match your current workload requirements, which reduce any excess capacity that could lead to higher costs.  

- Estimate the number of messages that your IoT Hub handles daily and select the most cost-effective tier. Avoid overprovisioning by choosing a tier that aligns closely with your actual usage.

- Implement strategies to reduce the number of messages sent, such as batching or optimizing data payloads, to minimize costs.  

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to simulate various workload scenarios and choose the most cost-efficient configurations for your architecture. This approach helps you anticipate costs and identify areas for potential savings.

- Revisit your cost estimates periodically and adjust configurations as your workloads evolve to ensure ongoing cost optimization. For more information, see [Azure pricing overview](https://azure.microsoft.com/pricing/).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Build and manage your infrastructure by using infrastructure as code tools such as Bicep, Terraform, or Azure Resource Manager templates. These tools ensure consistency, repeatability, and scalability in your infrastructure deployment.

- Integrate security practices early in the application lifecycle by applying DevOps security measures. This approach minimizes the effect of vulnerabilities and brings security considerations closer to the development team, which enables faster and more secure development.

- Use Azure pipelines to deploy your infrastructure through continuous integration and continuous delivery processes. This approach ensures efficient, automated, and reliable deployment of your resources, which reduces the risk of manual errors and increases deployment speed.

- Integrate secret detection tools into your CI pipelines to prevent committing secrets to your repository. This proactive measure safeguards your codebase and protects against potential security breaches.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Choose the appropriate IoT Hub tier based on the volume of messages exchanged daily:

  - For small to medium-scale projects with up to 5 million messages per day, select the S2 Standard tier.

  - For large-scale projects that require support for up to 300 million messages per day or an average of 3,400 messages per second, opt for the S3 Standard tier.
  
  - For more information, see [Azure IoT Hub pricing](https://azure.microsoft.com/pricing/details/iot-hub/).

- Use compute clusters, not compute instances, for production in Machine Learning. Compute clusters enable you to scale resources dynamically in response to varying traffic demands. This approach ensures optimal performance and cost efficiency.

- Enable diagnostic settings for Machine Learning to monitor and scale services according to business requirements. Regularly monitor the average utilization of compute instances or compute cluster nodes. As the number of experiments increases, adjust the node count of your compute cluster to ensure sufficient capacity and maintain performance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- Neelam Saxena | [LinkedIn profile](https://www.linkedin.com/in/neelam-saxena-5195b413/) | Senior Technical Program Manager

- Nick Sologoub | [LinkedIn profile](https://www.linkedin.com/in/ncksol/) | Principal Software Engineering Lead

- Colin Desmond | [LinkedIn profile](https://www.linkedin.com/in/colin-desmond-64b507a/) | Senior Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Siemens and Microsoft publish automation code examples to implement the proposed cloud-based reference architecture. For more information, see [Docs for Industrial AI](https://docs.industrial-operations-x.siemens.cloud/p/industrial-ai).

- [Azure IoT Hub concepts overview](/azure/iot-hub/iot-hub-devguide)

- [Get started with Machine Learning](/azure/machine-learning/tutorial-azure-ml-in-a-day?view=azureml-api-2)  

- [Create a Container Registry and build images](/azure/aks/tutorial-kubernetes-prepare-acr?tabs=azure-cli)

- [Storage Documentation Hub](/azure/storage)

- [Monitor Azure resources with Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource)

- [Siemens Industrial AI portfolio home](https://www.siemens.com/global/en/products/automation/topic-areas/artificial-intelligence-in-industry/industrial-ai-enabled-operations.html)

- [Industrial AI-enabled operations](https://www.siemens.com/global/en/products/automation/topic-areas/artificial-intelligence-in-industry/industrial-ai-enabled-operations.html)

- [Siemens Industrial Edge documentation](https://docs.eu1.edge.siemens.cloud/index.html)

- [Siemens Industrial AI reference with Electronic Works Amberg EWA](https://references.siemens.com/en/reference/siemens-ag?id=RMW659284bf-7eb0-4686-8a01-1e40a2866b14_1696503065533)
