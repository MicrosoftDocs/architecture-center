[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article provides a [machine learning operations (MLOps)](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-mlops) architecture and process that uses Azure Databricks. This process defines a standardized way to move machine learning models and pipelines from development to production, with options to include automated and manual processes.

## Architecture

:::image type="content" source="_images/orchestrate-mlops-azure-databricks-01.png" alt-text="Diagram that shows a solution for using Azure Databricks for MLOps." lightbox="_images/orchestrate-mlops-azure-databricks-01.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/orchestrate-mlops-azure-databricks-01.vsdx) of this architecture.*

### Workflow

This solution provides a robust MLOps process that uses Azure Databricks. All elements in the architecture are pluggable, so you can integrate other Azure and third-party services throughout the architecture as needed. This architecture and description are adapted from the e-book [The Big Book of MLOps](https://www.databricks.com/p/ebook/the-big-book-of-mlops?itm_data=home-promocard3-bigbookmlops). This e-book explores the architecture described here in more detail.

- **Source control**: This project's code repository organizes the notebooks, modules, and pipelines. Data scientists create development branches to test updates and new models. Code is developed in notebooks or in IDEs, backed by Git, with [Databricks Repos](/azure/databricks/repos) integration for syncing with your Azure Databricks workspaces. Source control promotes machine learning pipelines from development, through staging (for testing), to production (for deployment).

- **Lakehouse - production data**: Data scientists work in the development environment, where they have read-only access to production data. (Alternatively, data can be mirrored or redacted.) They also have read/write access to a dev storage environment for development and experimentation. We recommend a [Lakehouse](https://databricks.com/blog/2020/01/30/what-is-a-data-lakehouse.html) architecture for data, in which data is stored in [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) in [Delta Lake](/azure/databricks/delta) format. Access controls are defined with [Azure Active Directory credential passthrough](/azure/databricks/security/credential-passthrough/adls-passthrough) or [table access controls](/azure/databricks/administration-guide/access-control/table-acl).

#### Development

In the development environment, data scientists and engineers develop machine learning pipelines.

1. **Exploratory data analysis (EDA)**: Data scientists explore data in an interactive, iterative process. This ad hoc work might not be deployed to staging or production. Tools might include [Databricks SQL](/azure/databricks/sql/get-started), [dbutils.data.summarize](/azure/databricks/dev-tools/databricks-utils#dbutils-data-summarize), and [AutoML](/azure/databricks/applications/machine-learning/automl).

1. [**Model training**](/azure/databricks/applications/machine-learning/train-model) **and other machine learning pipelines**: Machine learning pipelines are developed as modular code in notebooks and/or IDEs. For example, the model training pipeline reads data from the Feature Store and other Lakehouse tables. Training and tuning log model parameters and metrics to the [MLflow tracking server](/azure/databricks/applications/mlflow/tracking). The [Feature Store API](/azure/databricks/applications/machine-learning/feature-store/python-api) logs the final model. These logs link the model, its inputs, and the training code.

1. **Commit code**: To promote the machine learning workflow toward production, the data scientist commits the code for featurization, training, and other pipelines to source control.

#### Staging

In the staging environment, CI infrastructure tests changes to machine learning pipelines in an environment that mimics production.

4. **Merge request**: When a merge (or pull) request is submitted against the staging (main) branch of the project in source control, a continuous integration and continuous delivery (CI/CD) tool like [Azure DevOps](/azure/devops/) runs tests.

5. **Unit and CI tests**: Unit tests run in CI infrastructure, and integration tests run end-to-end [workflows](/azure/databricks/jobs) on Azure Databricks. If tests pass, the code changes merge.

6. **Build a release branch**: When machine learning engineers are ready to deploy the updated machine learning pipelines to production, they can build a new release. A deployment pipeline in the CI/CD tool redeploys the updated pipelines as new [workflows](/azure/databricks/jobs).

#### Production

Machine learning engineers manage the production environment, where machine learning pipelines directly serve end applications. The key pipelines in production refresh feature tables, train and deploy new models, run inference or serving, and monitor model performance.

7. **Feature table refresh**: This pipeline reads data, computes features, and writes to [Feature Store](/azure/databricks/applications/machine-learning/feature-store) tables. It runs continuously in streaming mode, runs on a schedule, or is triggered.

1. **Model training**: In production, the model training or retraining pipeline is either triggered or scheduled to train a fresh model on the latest production data. Models are registered to the [MLflow Model Registry](/azure/databricks/applications/mlflow/model-registry).

1. **Continuous deployment**: Registering new model versions triggers the CD pipeline, which runs tests to ensure that the model will perform well in production. As the model passes tests, its progress is tracked in the Model Registry via model stage transitions. [Registry webhooks](/azure/databricks/applications/mlflow/model-registry-webhooks) can be used for automation. Tests can include compliance checks, A/B tests to compare the new model with the current production model, and infrastructure tests. Test results and metrics are recorded in Lakehouse tables. You can optionally require manual sign-offs before models are transitioned to production.

1. **Model deployment**: As a model enters production, it's deployed for scoring or serving. The most common deployment modes are:
    - [**Batch or streaming scoring**](/azure/databricks/applications/machine-learning/model-inference/#offline-batch-predictions): For latencies of minutes or longer, batch and streaming are the most cost-effective options. The scoring pipeline reads the latest data from the Feature Store, loads the latest production model version from the Model Registry, and performs inference in a Databricks job. It can publish predictions to Lakehouse tables, a Java Database Connectivity (JDBC) connection, flat files, message queues, or other downstream systems.
    - **Online serving (REST APIs)**: For low-latency use cases, online serving is generally necessary. MLflow can deploy models to [MLflow Model Serving on Azure Databricks](/azure/databricks/applications/mlflow/model-serving), cloud provider serving systems, and other systems. In all cases, the serving system is initialized with the latest production model from the Model Registry. For each request, it fetches features from an online Feature Store and makes predictions.

1. **Monitoring**: Continuous or periodic [workflows](/azure/databricks/jobs) monitor input data and model predictions for drift, performance, and other metrics. [Delta Live Tables](/azure/databricks/data-engineering/delta-live-tables) can simplify the automation of monitoring pipelines, storing the metrics in Lakehouse tables. [Databricks SQL](/azure/databricks/sql), [Power BI](/power-bi), and other tools can read from those tables to create dashboards and alerts.

1. **Retraining**: This architecture supports both manual and automatic retraining. Scheduled retraining jobs are the easiest way to keep models fresh.

### Components

- [**Data Lakehouse**](https://databricks.com/blog/2020/01/30/what-is-a-data-lakehouse.html). A Lakehouse architecture unifies the best elements of data lakes and data warehouses, delivering data management and performance typically found in data warehouses with the low-cost, flexible object stores offered by data lakes.
  - [**Delta Lake**](https://delta.io) is the recommended choice for an open-source data format for a lakehouse. Azure Databricks stores data in Data Lake Storage and provides a high-performance query engine.
- [**MLflow**](https://www.mlflow.org) is an open-source project for managing the end-to-end machine learning lifecycle. These are its main components:
  - [**Tracking**](/azure/databricks/applications/mlflow/tracking) allows you to track experiments to record and compare parameters, metrics, and model artifacts.
    - [**Databricks Autologging**](/azure/databricks/applications/mlflow/databricks-autologging) extends [MLflow automatic logging](https://mlflow.org/docs/latest/tracking.html#automatic-logging) to track machine learning experiments, automatically logging model parameters, metrics, files, and lineage information.
  - [**MLFlow Model**](/azure/databricks/applications/mlflow/models) allows you to store and deploy models from any machine learning library to various model serving and inference platforms.
  - [**Model Registry**](/azure/databricks/applications/mlflow/model-registry) provides a centralized model store for managing model lifecycle stage transitions from development to production.
  - [**Model Serving**](/azure/databricks/applications/mlflow/model-serving) enables you to host MLflow models as REST endpoints.
- [**Azure Databricks**](https://azure.microsoft.com/services/databricks). Azure Databricks provides a managed MLflow service with enterprise security features, high availability, and integrations with other Azure Databricks workspace features.
  - [**Databricks Runtime for Machine Learning**](/azure/databricks/runtime/mlruntime#mlruntime) automates the creation of a cluster that's optimized for machine learning, preinstalling popular machine learning libraries like TensorFlow, PyTorch, and XGBoost in addition to Azure Databricks for Machine Learning tools like AutoML and Feature Store clients.
  - [**Feature Store**](/azure/databricks/applications/machine-learning/feature-store) is a centralized repository of features. It enables feature sharing and discovery, and it helps to avoid data skew between model training and inference.
  - [**Databricks SQL**](/azure/databricks/sql). Databricks SQL provides a simple experience for SQL queries on Lakehouse data, and for visualizations, dashboards, and alerts.
  - [**Databricks Repos**](/azure/databricks/repos) provides integration with your Git provider in the Azure Databricks workspace, simplifying collaborative development of notebooks or code and IDE integration.
  - [**Workflows**](/azure/databricks/data-engineering) and [**jobs**](/azure/databricks/jobs) provide a way to run non-interactive code in an Azure Databricks cluster. For machine learning, jobs provide automation for data preparation, featurization, training, inference, and monitoring.

### Alternatives

You can tailor this solution to your Azure infrastructure. Common customizations include:

- Multiple development workspaces that share a common production workspace.
- Exchanging one or more architecture components for your existing infrastructure. For example, you can use [Azure Data Factory](https://azure.microsoft.com/services/data-factory) to orchestrate Databricks jobs.
- Integrating with your existing CI/CD tooling via Git and Azure Databricks REST APIs.

## Scenario details

MLOps helps to reduce the risk of failures in machine learning and AI systems and to improve the efficiency of collaboration and tooling. For an introduction to MLOps and an overview of this architecture, see [Architecting MLOps on the Lakehouse](https://databricks.com/blog/2022/06/22/architecting-mlops-on-the-lakehouse.html).

By using this architecture, you can:

- **Connect your business stakeholders with machine learning and data science teams.** This architecture allows data scientists to use notebooks and IDEs for development. It enables business stakeholders to view metrics and dashboards in Databricks SQL, all within the same Lakehouse architecture.
- **Make your machine learning infrastructure datacentric**. This architecture treats machine learning data (data from feature engineering, training, inference, and monitoring) just like other data. It reuses tooling for production pipelines, dashboarding, and other general data processing for machine learning data processing.
- **Implement MLOps in modules and pipelines**. As with any software application, the modularized pipelines and code in this architecture enable testing of individual components and decrease the cost of future refactoring.
- **Automate your MLOps processes as needed**. In this architecture, you can automate steps to improve productivity and reduce the risk of human error, but not every step needs to be automated. Azure Databricks permits UI and manual processes in addition to APIs for automation.

### Potential use cases

This architecture applies to all types of machine learning, deep learning, and advanced analytics. Common machine learning / AI techniques used in this architecture include:

- Classical machine learning, like linear models, tree-based models, and boosting.
- Modern deep learning, like TensorFlow and PyTorch.
- Custom analytics, like statistics, Bayesian methods, and graph analytics.

The architecture supports both small data (single machine) and large data (distributed computing and GPU-accelerated). In each stage of the architecture, you can choose compute resources and libraries to adapt to your data and problem dimensions.

The architecture applies to all types of industries and business use cases. Azure Databricks customers using this and similar architectures include small and large organizations in industries like these:

- Consumer goods and retail services
- Financial services
- Healthcare and life sciences
- Information technology

For examples, see the [Databricks website](https://databricks.com/customers).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b) | Senior Cloud Solution Architect

Other contributor:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [The Big Book of MLOps](https://databricks.com/p/ebook/the-big-book-of-mlops)
- [Need for Data-centric ML Platforms](https://databricks.com/blog/2021/06/23/need-for-data-centric-ml-platforms.html) (introduction to MLOps)
- [Databricks Machine Learning in-product quickstart](/azure/databricks/applications/machine-learning/ml-quickstart)
- [10-minute tutorials: Get started with machine learning on Azure Databricks](/azure/databricks/applications/machine-learning/tutorial)
- [Databricks Machine Learning documentation](/azure/databricks/scenarios/ml)
- [Databricks Machine Learning product page and resources](https://databricks.com/product/machine-learning)
- [MLOps on Databricks: A How-To Guide](https://databricks.com/dataaisummit/session/mlops-databricks-how-guide)
- [Automating the ML Lifecycle With Databricks Machine Learning](https://databricks.com/p/webinar/automating-the-ml-lifecycle-with-databricks-machine-learning)
- [MLOps on Azure Databricks with MLflow](https://www.youtube.com/watch?v=l36u1_9Gopk)
- [Machine Learning Engineering for the Real World](https://databricks.com/p/ebook/machine-learning-engineering-in-action)
- [Automate Your Machine Learning Pipeline](https://databricks.com/p/ebook/automate-your-machine-learning-pipeline)
- [Databricks Academy](https://databricks.com/learn/training/home)
- [Databricks Academy GitHub project](https://github.com/databricks-academy) (free training)
- [MLOps glossary](https://databricks.com/glossary/mlops)
- [Three Principles for Selecting Machine Learning Platforms](https://databricks.com/blog/2021/06/24/three-principles-for-selecting-machine-learning-platforms.html)
- [What is a Lakehouse?](https://databricks.com/blog/2020/01/30/what-is-a-data-lakehouse.html)
- [Delta Lake home page](https://delta.io)
- [Ingest data into the Azure Databricks Lakehouse](/azure/databricks/data)
- [Clusters](/azure/databricks/clusters)
- [Libraries](/azure/databricks/libraries)
- [MLflow Documentation](https://www.mlflow.org/docs/latest/index.html)
- [Azure Databricks MLflow guide](/azure/databricks/applications/mlflow)
- [Share models across workspaces](/azure/databricks/applications/machine-learning/manage-model-lifecycle/multiple-workspaces)
- [Notebooks](/azure/databricks/notebooks)
- [Developer tools and guidance](/azure/databricks/dev-tools)
- [Deploy MLflow models to online endpoints in Azure Machine Learning](/azure/machine-learning/how-to-deploy-mlflow-models-online-endpoints?tabs=endpoint%2Cstudio)
- [Deploy to Azure Kubernetes Service (AKS)](/azure/machine-learning/how-to-deploy-mlflow-models#deploy-to-azure-kubernetes-service-aks)

## Related resources

- [MLOps framework to upscale machine learning lifecycle with Azure Machine Learning](../../example-scenario/mlops/mlops-technical-paper.yml)
- [MLOps v2](../../data-guide/technology-choices/machine-learning-operations-v2.md)
- [MLOps maturity model](../../example-scenario/mlops/mlops-maturity-model.yml)
