[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article provides a [machine learning operations (MLOps)](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-mlops) architecture and process that uses Azure Databricks. Data scientists and engineers can use this standardized process to move machine learning models and pipelines from development to production, with options to include automated and manual processes.

## Architecture

:::image type="content" source="_images/orchestrate-mlops-azure-databricks-01.png" alt-text="Diagram that shows a solution for using Azure Databricks for MLOps." lightbox="_images/orchestrate-mlops-azure-databricks-01.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/orchestrate-mlops-azure-databricks-01.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram. Use source control and storage components to manage and organize code and data.

**Source control:** This project's code repository organizes the notebooks, modules, and pipelines. Data scientists create development branches to test updates and new models. Code is developed in Git-supported notebooks or integrated development environments (IDEs) that integrate with [Databricks repos](/azure/databricks/repos) so that you can sync with your Azure Databricks workspaces. Source control promotes machine learning pipelines from the development environment, to testing in the staging environment, and to deployment in the production environment.

**Lakehouse production data:** Data scientists have read-only access to production data in the development environment. You can mirror data to the development environment and redact confidential data. Data scientists also have read and write access in a dev storage environment for development and experimentation. We recommend that you use a [lakehouse](https://databricks.com/blog/2020/01/30/what-is-a-data-lakehouse.html) architecture for data in which you store [Delta Lake](/azure/databricks/delta)-format data in [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction). A lakehouse provides a robust, scalable, and flexible solution for data management. To define access controls, use [Microsoft Entra ID credential passthrough](/azure/databricks/security/credential-passthrough/adls-passthrough) or [table access controls](/azure/databricks/administration-guide/access-control/table-acl).

The following environments comprise the main components of the workflow.

#### Development

In the development environment, data scientists and engineers develop machine learning pipelines.

1. **Perform exploratory data analysis (EDA):** Data scientists explore data in an interactive, iterative process. You might not deploy this work to staging or production. You can use tools like [Databricks SQL](/azure/databricks/sql/get-started), the [`dbutils.data.summarize`](/azure/databricks/dev-tools/databricks-utils#dbutils-data-summarize) command, and [Databricks AutoML](/azure/databricks/applications/machine-learning/automl).

1. **Develop [model training](/azure/databricks/applications/machine-learning/train-model) and other machine learning pipelines:** You can develop machine learning pipelines modular code, and orchestrate code via Databricks Notebooks or an MLFlow Project. For example, the model training pipeline reads data from the feature store and other lakehouse tables. Training and tuning log model parameters and metrics to the [MLflow tracking server](/azure/databricks/applications/mlflow/tracking). The [feature store API](/azure/databricks/applications/machine-learning/feature-store/python-api) logs the final model. These logs link the model, its inputs, and the training code.

1. **Commit code:** To promote the machine learning workflow toward production, the data scientist commits the code for featurization, training, and other pipelines to source control. In the code base, place machine learning code and operational code in different folders so that team members can develop code at the same time. Machine learning code is code that's related to the model and data. Operational code is code that's related to Databricks jobs and infrastructure.

This core cycle of activities that data scientists and engineers do when they write and test code are referred to as the *innerloop process*. To perform the innerloop process for the development phase, use Visual Studio Code in combination with the dev container CLI and the Databricks CLI. Data scientists can write the code and do unit testing locally. They can also submit, monitor, and analyze the model pipelines from the local development environment.

#### Staging

In the staging environment, continuous integration (CI) infrastructure tests changes to machine learning pipelines in an environment that mimics production.

4. **Merge a request:** When a merge request or pull request is submitted against the staging (main) branch of the project in source control, a continuous integration and continuous delivery (CI/CD) tool like [Azure DevOps](/azure/devops/) runs tests.

5. **Run unit tests and CI tests:** Unit tests run in CI infrastructure, and integration tests run end-to-end [workflows](/azure/databricks/jobs) on Azure Databricks. If tests pass, the code changes merge.

6. **Build a release branch:** When machine learning engineers are ready to deploy the updated machine learning pipelines to production, they can build a new release. A deployment pipeline in the CI/CD tool redeploys the updated pipelines as new [workflows](/azure/databricks/jobs).

#### Production

Machine learning engineers manage the production environment, where machine learning pipelines directly serve end applications. The key pipelines in production refresh feature tables, train and deploy new models, run inference or serving, and monitor model performance.

7. **Feature table refresh:** This pipeline reads data, computes features, and writes to [feature store](/azure/databricks/applications/machine-learning/feature-store) tables. It either runs continuously in streaming mode, runs on a schedule, or is triggered.

1. **Model training:** In production, the model training or retraining pipeline is either triggered or scheduled to train a fresh model on the latest production data. Models are registered to the [MLflow Model Registry](/azure/databricks/applications/mlflow/model-registry).

1. **Model evaluation and promotion:** Registering new model versions triggers the CD pipeline, which runs tests to ensure that the model will perform well in production. When the model passes tests, the Model Registry tracks its progress via model stage transitions. You can use [registry webhooks](/azure/databricks/applications/mlflow/model-registry-webhooks) for automation. Tests can include compliance checks, A/B tests to compare the new model with the current production model, and infrastructure tests. Test results and metrics are recorded in lakehouse tables. You can optionally require manual sign-offs before models transition to production.

1. **Model deployment:** When a model enters production, it's deployed for scoring or serving. The most common deployment modes include:
    - *Batch or streaming scoring:* For latencies of minutes or longer, [batch and streaming](/azure/databricks/applications/machine-learning/model-inference/#offline-batch-predictions) are the most cost-effective options. The scoring pipeline reads the latest data from the feature store, loads the latest production model version from the Model Registry, and performs inference in a Databricks job. It can publish predictions to lakehouse tables, a Java Database Connectivity (JDBC) connection, flat files, message queues, or other downstream systems.
    
    - *Online serving (REST APIs):* For low-latency use cases, you generally need online serving. MLflow can deploy models to [MLflow Model Serving on Azure Databricks](/azure/databricks/applications/mlflow/model-serving), cloud provider serving systems, and other systems. In all cases, the serving system is initialized with the latest production model from the Model Registry. For each request, it fetches features from an online feature store and makes predictions.

1. **Monitoring:** Continuous or periodic [workflows](/azure/databricks/jobs) monitor input data and model predictions for drift, performance, and other metrics. You can use the [Delta Live Tables](/azure/databricks/data-engineering/delta-live-tables) framework to automate monitoring for pipelines and store the metrics in lakehouse tables. [Databricks SQL](/azure/databricks/sql), [Power BI](/power-bi), and other tools can read from those tables to create dashboards and alerts. To monitor application metrics, logs, and infrastructure, you can also integrate Azure Monitor with Azure Databricks.

1. **Drift detection and model retraining:** This architecture supports both manual and automatic retraining. Scheduled retraining jobs are the easiest way to keep models fresh. After a detected drift crosses a preconfigured threshold that you set in the monitoring step, the retraining pipelines analyze the drift and trigger the retraining. You can configure pipelines to trigger automatically, or the data scientist can receive a notification and then run the pipelines manually.

### Components

- [**Data lakehouse**](https://databricks.com/blog/2020/01/30/what-is-a-data-lakehouse.html). A lakehouse architecture unifies the best elements of data lakes and data warehouses. Use a lakehouse to get data management and performance capabilities that are typically found in data warehouses but with the low-cost, flexible object stores that data lakes offer.

  - [**Delta Lake**](https://delta.io) is the recommended open-source data format for a lakehouse. Azure Databricks stores data in Data Lake Storage and provides a high-performance query engine.

- [**MLflow**](https://www.mlflow.org) is an open-source project for managing the end-to-end machine learning lifecycle. MLflow has the following components:
  - [**Tracking**](/azure/databricks/applications/mlflow/tracking) allows you to track experiments to record and compare parameters, metrics, and model artifacts.
    - [**Databricks autologging**](/azure/databricks/applications/mlflow/databricks-autologging) extends [MLflow automatic logging](https://mlflow.org/docs/latest/tracking.html#automatic-logging) to track machine learning experiments and automatically logs model parameters, metrics, files, and lineage information.
    
  - [**MLflow Model**](/azure/databricks/applications/mlflow/models) allows you to store and deploy models from any machine learning library to various model serving and inference platforms.
  - [**Model Registry**](/azure/databricks/applications/mlflow/model-registry) provides a centralized model store to manage model lifecycle stage transitions from development to production.
  - [**Model Serving**](/azure/databricks/applications/mlflow/model-serving) enables you to host MLflow models as REST endpoints.
- [**Azure Databricks**](https://azure.microsoft.com/services/databricks). Azure Databricks provides a managed MLflow service that has enterprise security features, high availability, and integrations with other Azure Databricks workspace features.
  - [**Databricks Runtime for Machine Learning**](/azure/databricks/runtime/mlruntime#mlruntime) automates the creation of a cluster that's optimized for machine learning and preinstalls popular machine learning libraries like TensorFlow, PyTorch, and XGBoost. It also preinstalls Azure Databricks for Machine Learning tools, like AutoML and feature store clients.
  
  - [**A feature store**](/azure/databricks/applications/machine-learning/feature-store) is a centralized repository of features. Use the feature store to discover and share features and help prevent data skew between model training and inference.
  - [**Databricks SQL**](/azure/databricks/sql) integrates with a variety of tools so that data scientists can author queries and dashboards in their favorite environments without adjusting to a new platform.
  - [**Databricks repos**](/azure/databricks/repos) provides integration with your Git provider in the Azure Databricks workspace, which improves notebook or code collaboration and IDE integration.
  - [**Workflows**](/azure/databricks/data-engineering) and [**jobs**](/azure/databricks/jobs) provide a way to run non-interactive code in an Azure Databricks cluster. For machine learning, jobs provide automation for data preparation, featurization, training, inference, and monitoring.

### Alternatives

You can tailor this solution to your Azure infrastructure. Consider the following customizations:

- Use multiple development workspaces that share a common production workspace.

- Exchange one or more architecture components for your existing infrastructure. For example, you can use [Azure Data Factory](https://azure.microsoft.com/services/data-factory) to orchestrate Databricks jobs.
- Integrate with your existing CI/CD tooling via Git and Azure Databricks REST APIs.

## Scenario details

This solution provides a robust MLOps process that uses Azure Databricks. All elements in the architecture are replaceable, so you can integrate other Azure and partner services throughout the architecture as needed. This architecture and description are adapted from the e-book [The Big Book of MLOps](https://www.databricks.com/p/ebook/the-big-book-of-mlops?itm_data=home-promocard3-bigbookmlops). The e-book explores this architecture in more detail.

MLOps helps to reduce the risk of failures in machine learning and AI systems and to improve the efficiency of collaboration and tooling. For an introduction to MLOps and an overview of this architecture, see [Architect MLOps on the lakehouse](https://databricks.com/blog/2022/06/22/architecting-mlops-on-the-lakehouse.html).

Use this architecture to:

- **Connect your business stakeholders with machine learning and data science teams.** Data scientists can use this architecture to incorporate notebooks and IDEs for development. Business stakeholders can view metrics and dashboards in Databricks SQL, all within the same lakehouse architecture.

- **Make your machine learning infrastructure datacentric.** This architecture treats machine learning data just like other data. Machine learning data includes data from feature engineering, training, inference, and monitoring. This architecture reuses tooling for production pipelines, dashboarding, and other general data processing for machine learning data processing.
- **Implement MLOps in modules and pipelines.** As with any software application, the modularized pipelines and code in this architecture enable testing of individual components and decrease the cost of future refactoring.
- **Automate your MLOps processes as needed.** In this architecture, you can automate steps to improve productivity and reduce the risk of human error, but you don't need to automate every step. Azure Databricks permits UI and manual processes in addition to APIs for automation.

### Potential use cases

This architecture applies to all types of machine learning, deep learning, and advanced analytics. Common machine learning and AI techniques in this architecture include:

- Classical machine learning, like linear models, tree-based models, and boosting.
- Modern deep learning, like TensorFlow and PyTorch.
- Custom analytics, like statistics, Bayesian methods, and graph analytics.

The architecture supports both small data (single machine) and large data (distributed computing and GPU-accelerated). In each stage of the architecture, you can choose compute resources and libraries to adapt to your scenario's data and problem dimensions.

The architecture applies to all types of industries and business use cases. Azure Databricks customers that use this architecture include small and large organizations in the following industries:

- Consumer goods and retail services
- Financial services
- Healthcare and life sciences
- Information technology

For examples, see [Databricks customers](https://databricks.com/customers).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AI and machine learning on Databricks](/azure/databricks/machine-learning)
- [Databricks Academy](https://databricks.com/learn/training/home)
- [Databricks Academy GitHub project](https://github.com/databricks-academy)
- [Databricks machine learning product page and resources](https://databricks.com/product/machine-learning)
- [Deploy MLflow models to online endpoints in Azure Machine Learning](/azure/machine-learning/how-to-deploy-mlflow-models-online-endpoints)
- [Developer tools and guidance](/azure/databricks/dev-tools)
- [Introduction to MLOps: The need for datacentric machine learning platforms](https://databricks.com/blog/2021/06/23/need-for-data-centric-ml-platforms.html)
- [Libraries](/azure/databricks/libraries)
- [MLOps glossary](https://databricks.com/glossary/mlops)
- [Notebooks](/azure/databricks/notebooks)
- [Share models across workspaces](/azure/databricks/machine-learning/manage-model-lifecycle/multiple-workspaces)
- [eBook: Machine learning engineering for the real world](https://databricks.com/p/ebook/machine-learning-engineering-in-action)
- [eBook: Automate your machine learning pipeline](https://databricks.com/p/ebook/automate-your-machine-learning-pipeline)
- [Tutorial: Get started with AI and machine learning](/azure/databricks/machine-learning/ml-tutorials)
- [Video: MLOps on Azure Databricks with MLflow](https://www.youtube.com/watch?v=l36u1_9Gopk)
- [Webinar: Automate the machine learning lifecycle with Databricks Machine Learning](https://databricks.com/p/webinar/automating-the-ml-lifecycle-with-databricks-machine-learning)

## Related resources

- [MLOps maturity model](../../ai-ml/guide/mlops-maturity-model.yml)
- [MLOps v2](../../ai-ml/guide/machine-learning-operations-v2.md)

