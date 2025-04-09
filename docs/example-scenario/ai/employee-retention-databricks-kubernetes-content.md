This solution demonstrates how a machine-learning team can use Azure Databricks and Azure Kubernetes Service to develop and deploy machine learning, as an API, to predict the likelihood of employee attrition. The API can be integrated with external applications that are used by the Human Resources team to provide additional insights into the likelihood of attrition for a given employee within the organization. This information can be used to retain high-impact employees who are likely to leave the organization by providing Human Resources with the ability to proactively incentivize such employees to stay.

*Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" alt-text="Diagram of the architecture in this article, showing development, deployment, exposure of the API, and monitoring of metrics and logs." source="media/employee-retention-databricks-kubernetes-design.svg" lightbox="media/employee-retention-databricks-kubernetes-design.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/employee-retention-databricks-kubernetes.pptx) for all architectures.*

### Workflow

At a high level, this solution design addresses each stage of the machine-learning lifecycle:

- *Data preparation*, which includes sourcing, cleaning, and transforming the data for processing and analysis. Data can live in a data lake or data warehouse and be stored in a feature store after it's curated.

- *Model development*, which includes core components of the process of model development, such as experiment tracking and model registration by using [MLflow](/azure/databricks/applications/mlflow).

- *Model deployment*, which includes implementing a continuous integration and continuous delivery (CI/CD) pipeline to containerize machine-learning models as API services. These services are deployed to Azure Kubernetes clusters for end users to consume.

- *Model monitoring*, which includes monitoring the API performance and model data drift by analyzing log telemetry with Azure Monitor.

After the machine-learning team has deployed the machine-learning model as an API for real-time inference, developers can easily integrate the API with external applications that are used by external teams, such as Human Resources. Telemetry is collected when an external team uses the model service. The machine-learning team can use this telemetry to determine when the model needs to be redeployed. This approach allows teams to work independently and allows external teams to benefit from the skills of the centralized machine-learning team.

> [!NOTE]
>
>- You can use various tools, such as Azure Pipelines and GitHub Actions, when implementing a [CI/CD pipeline](/azure/architecture/microservices/ci-cd).
>
>- The specific business requirements of your use case for analytics could require different services or features that aren't considered in this design.

### Components

The following components are used as part of this design:

- [Azure Databricks](/azure/databricks/introduction): An analytics service for big data that's easy to use, facilitates collaboration, and is based on Apache Spark. Azure Databricks is designed for data science and data engineering.

- [Azure Kubernetes Service](/azure/well-architected/service-guides/azure-kubernetes-service): A service that provides simplified deployment and management of Kubernetes by offloading the operational overhead to Azure.

- [Azure Container Registry](/azure/container-registry/container-registry-intro): A private registry service for managing container images and artifacts. This service is based on the open-source Docker.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction): A service that provides scalable storage that's optimized for massive amounts of unstructured data. Data Lake Storage Gen2 offers file system semantics, file-level security, and scale.

- [Azure Monitor](/azure/azure-monitor/overview): A comprehensive solution for collecting, analyzing, and acting on telemetry from your workloads.

- [MLflow](/azure/databricks/applications/mlflow): An open-source solution that's integrated within Databricks for managing the machine-learning lifecycle from end to end.

- [Azure API Management](/azure/api-management/api-management-key-concepts): A fully managed service that helps customers to publish, secure, transform, maintain, and monitor APIs.

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway): A load balancer for web traffic that enables you to manage traffic to your web applications.

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) or [GitHub](https://docs.github.com/en/get-started/start-your-journey/about-github-and-git): Solutions for implementing DevOps practices to enforce automation and compliance with your workload development and deployment pipelines.

## Scenario details

The problem of employee attrition has grown in prominence since the COVID-19 pandemic. This trend, in which employees voluntarily resign from their jobs en masse, is popularly known as *the Great Resignation*. The problem can also be magnified for certain departments in an organization that might lack dedicated teams that perform advanced analytics, such as Human Resources.

This example scenario illustrates an operating model of centralized machine learning. This  comprises a central team that's responsible for building and deploying machine-learning models for external teams across departments within an organization. This approach is useful when departments are too small to maintain a team that's dedicated to machine learning while the organization aims to infuse advanced analytics into all products and processes.

### Potential use cases

This scenario is focused on building a machine-learning model of employee attrition and integrating it with external applications that are used by Human Resources teams. However, the design can be generalized to many machine-learning workloads that are built by centralized and decentralized teams alike.

This generalized approach is best suited for:

- Machine-learning teams that have standardized on Databricks for data engineering or machine-learning applications.

- Machine-learning teams that have experience deploying and managing Kubernetes workloads and a preference for applying these skills for operationalizing machine-learning workloads.

- Integrating machine-learning workloads with external applications that require low latency and interactive model predictions (for example, real-time inference).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

Before you implement this solution, some factors you might want to consider include:

- This solution is designed for teams that require a high degree of customization and have extensive expertise in deploying and managing Kubernetes workloads. If your data science team doesn't have this expertise, consider deploying models to another service, such as [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning).

- [Machine learning DevOps (MLOps) best practices with Azure Machine Learning](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-mlops#machine-learning-devops-mlops-best-practices-with-azure-machine-learning) presents best practices and recommendations for adopting ML operations (MLOps) in the enterprise with machine learning.

- Follow the recommendations and guidelines defined in the [Azure Well-Architected Framework](/azure/well-architected/) to improve the quality of your Azure solutions.

- When implementing a CI/CD pipeline, you can use different tools than this example uses, such as Azure Pipelines and GitHub Actions. For more information about CI/CD, see [CI/CD for microservices architectures](/azure/architecture/microservices/ci-cd).

- Specific business requirements for your analytics use case could require the use of services or features that aren't considered in this design.

### Cost Optimization

Cost Optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

All services deployed in this solution use a consumption-based pricing model. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for a specific scenario. For other considerations, see [Cost optimization](/azure/architecture/framework/cost) in the Well-Architected Framework.

## Deploy this scenario

A proof-of-concept implementation of this scenario is available on GitHub at [Employee Retention with Databricks and Kubernetes](https://github.com/Azure/employee-retention-databricks-kubernetes-poc).

:::image type="content" alt-text="Diagram of the deployment of the architecture in this article, showing develop, build, deploy, and monitor." source="media/employee-retention-databricks-kubernetes-workflow.svg" lightbox="media/employee-retention-databricks-kubernetes-workflow.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/employee-retention-databricks-kubernetes.pptx) for all architecture.*

This proof of concept illustrates:

- How to train an MLflow model for employee attrition on Azure Databricks.
- How to package models as a web service by using open-source tools.
- How to deploy to Kubernetes via CI/CD by using GitHub Actions.
- How to monitor API performance and model data drift within Azure Monitor and Azure Log Analytics workspaces.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore/) | Cloud Solution Architect

## Next steps

Product documentation:

- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [MLflow guide](/azure/databricks/applications/mlflow)
- [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
- [Introduction to private Docker container registries in Azure](/azure/container-registry/container-registry-intro)
- [About API management](/azure/api-management/api-management-key-concepts)
- [What is Azure Application Gateway?](/azure/application-gateway/overview)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Azure DevOps documentation](/azure/devops)
- [Azure and GitHub integration](/azure/developer/github)

Microsoft Learn modules:

- [Perform data science with Azure Databricks](/training/paths/perform-data-science-azure-databricks)
- [Build and operate machine learning solutions with Azure Databricks](/training/paths/build-operate-machine-learning-solutions-azure-databricks)
- [Introduction to Kubernetes on Azure](/training/paths/intro-to-kubernetes-on-azure)
- [Develop and deploy applications on Kubernetes](/training/paths/develop-deploy-applications-kubernetes)
- [Automate your workflow with GitHub Actions](/training/paths/automate-workflow-github-actions)

## Related resources

You might also find these Architecture Center articles useful:

- [Machine Learning operations maturity model](../../ai-ml/guide/mlops-maturity-model.yml)
- [Modern analytics architecture with Azure Databricks](../../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml)
