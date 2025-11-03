[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article provides a [machine learning operations](../guide/machine-learning-operations-v2.md) architecture and process that uses Azure Databricks. Data scientists and engineers can use this standardized process to move machine learning models and pipelines from development to production.

This solution can take advantage of full automation, continuous monitoring, and robust collaboration. As a result, it targets level 4 of machine learning operations maturity. This architecture uses the *promote code that generates the model* approach rather than the *promote models* approach. The *promote code that generates the model* approach focuses on writing and managing the code that generates machine learning models. The recommendations in this article include options for automated or manual processes.

## Architecture

:::image type="complex" source="_images/orchestrate-machine-learning-azure-databricks.svg" alt-text="Diagram that shows a solution for using Azure Databricks for machine learning operations." lightbox="_images/orchestrate-machine-learning-azure-databricks.svg" border="false":::
  This diagram shows the 12 steps of the workflow. The lakehouse production data section includes the data table, feature table, and lakehouse table for model metrics. The source control section includes development, staging, and release environments and uses Azure DevOps and GitHub. In the main development environment, step 1 is exploratory data analysis that reads data from the data table. Step 2 is model training that reads data from the data table and feature table. Step 3 is committing code to the development environment in source control. Step 4 is merging a request to the staging environment. The source control staging environment initiates step 5 which runs unit and continuous integration tests in the main staging environment and reads data from the feature table and data table. After this, code changes merge to the source control staging environment. Step 6 builds a release branch in the release environment and an arrow from the release environment to the main production environment indicates Deploy machine learning Databricks jobs. In the main production environment, step 7 is feature table refresh which reads data from the data table and writes to the feature table. Step 8 is model training which uses data from drift detection and model retraining and pushes the model to Unity Catalog. Step 9 is model evaluation and promotion which loads the model from Unity Catalog for evaluation and then sends the model to staging and production in Unity Catalog. Step 10 is model deployment which loads the model for inferencing and reads data from the feature table. Step 11 is monitoring which reads data from the feature table and lakehouse table model metrics and writes data to the lakehouse table and Azure Monitor. Step 12 is model retraining which points to step 8 with an arrow labeled Trigger model retraining.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/orchestrate-mlops-azure-databricks.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram. Use source control and storage components to manage and organize code and data.

**Source control:** This project's code repository organizes the notebooks, modules, and pipelines. You can create development branches to test updates and new models. Develop code in Git-supported notebooks or integrated development environments (IDEs) that integrate with [Git folders](/azure/databricks/repos) so that you can sync with your Azure Databricks workspaces. Source control promotes machine learning pipelines from the development environment, to testing in the staging environment, and to deployment in the production environment.

**Lakehouse production data:** As a data scientist, you have read-only access to production data in the development environment. The development environment can have mirrored data and redacted confidential data. You also have read and write access in a dev storage environment for development and experimentation. We recommend that you use a [lakehouse](https://databricks.com/blog/2020/01/30/what-is-a-data-lakehouse.html) architecture for data in which you store [Delta Lake](/azure/databricks/delta)-format data in [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction). A lakehouse provides a robust, scalable, and flexible solution for data management. To define access controls, use [Microsoft Entra ID credential passthrough](/azure/databricks/security/credential-passthrough/adls-passthrough) or [table access controls](/azure/databricks/administration-guide/access-control/table-acl).

The following environments comprise the main workflow.

#### Development

In the development environment, you develop machine learning pipelines.

1. **Perform exploratory data analysis (EDA):** Explore data in an interactive, iterative process. You might not deploy this work to staging or production. Use tools like [Databricks SQL](/azure/databricks/sql/get-started), the [dbutils.data.summarize](/azure/databricks/dev-tools/databricks-utils#dbutils-data-summarize) command, and [Databricks AutoML](/azure/databricks/applications/machine-learning/automl).

1. **Develop [model training](/azure/databricks/applications/machine-learning/train-model) and other machine learning pipelines.** Develop machine learning pipelines modular code, and orchestrate code via Databricks Notebooks or an MLflow Project. In this architecture, the model training pipeline reads data from the feature store and other lakehouse tables. The pipeline trains and tunes log model parameters and metrics to the [MLflow tracking server](/azure/databricks/applications/mlflow/tracking). The [feature store API](/azure/databricks/applications/machine-learning/feature-store/python-api) logs the final model. These logs include the model, its inputs, and the training code.

1. **Commit code.** To promote the machine learning workflow toward production, commit the code for featurization, training, and other pipelines to source control. In the code base, place machine learning code and operational code in different folders so that team members can develop code at the same time. Machine learning code is code that's related to the model and data. Operational code is code that's related to Databricks jobs and infrastructure.

This core cycle of activities that you do when you write and test code are referred to as the *innerloop process*. To perform the innerloop process for the development phase, use Visual Studio Code in combination with the dev container CLI and the Databricks CLI. You can write the code and do unit testing locally. You should also submit, monitor, and analyze the model pipelines from the local development environment.

#### Staging

In the staging environment, continuous integration (CI) infrastructure tests changes to machine learning pipelines in an environment that mimics production.

1. **Merge a request.** When you submit a merge request or pull request against the staging (main) branch of the project in source control, a continuous integration and continuous delivery (CI/CD) tool like [Azure DevOps](/azure/devops/) runs tests.

1. **Run unit tests and CI tests.** Unit tests run in CI infrastructure, and integration tests run in end-to-end [workflows](/azure/databricks/jobs) on Azure Databricks. If tests pass, the code changes merge.

1. **Build a release branch.** When you want to deploy the updated machine learning pipelines to production, you can build a new release. A deployment pipeline in the CI/CD tool redeploys the updated pipelines as new [workflows](/azure/databricks/jobs).

#### Production

Machine learning engineers manage the production environment, where machine learning pipelines directly serve end applications. The key pipelines in production refresh feature tables, train and deploy new models, run inference or serving, and monitor model performance.

1. **Feature table refresh:** This pipeline reads data, computes features, and writes to [feature store](/azure/databricks/applications/machine-learning/feature-store) tables. You can configure this pipeline to either run continuously in streaming mode, run on a schedule, or run on a trigger.

1. **Model training:** In production, you can configure the model training or retraining pipeline to either run on a trigger or a schedule to train a fresh model on the latest production data. Models automatically register to [Unity Catalog](/azure/databricks/machine-learning/manage-model-lifecycle/).

1. **Model evaluation and promotion:** When a new model version is registered, the CD pipeline starts, which runs tests to ensure that the model performs well in production. When the model passes tests, Unity Catalog tracks its progress via model stage transitions. Tests include compliance checks, A/B tests to compare the new model with the current production model, and infrastructure tests. Lakehouse tables record test results and metrics. You can optionally require manual sign-offs before models transition to production.

1. **Model deployment:** When a model enters production, it's deployed for scoring or serving. The most common deployment modes include:

    - *Batch or streaming scoring:* For latencies of minutes or longer, [batch and streaming](/azure/databricks/applications/machine-learning/model-inference/#offline-batch-predictions) are the most cost-effective options. The scoring pipeline reads the latest data from the feature store, loads the latest production model version from Unity Catalog, and performs inference in a Databricks job. It can publish predictions to lakehouse tables, a Java Database Connectivity (JDBC) connection, flat files, message queues, or other downstream systems.

    - *Online serving (REST APIs):* For low-latency use cases, you generally need online serving. MLflow can deploy models to [Mosaic AI Model Serving](/azure/databricks/machine-learning/model-serving/), cloud provider serving systems, and other systems. In all cases, the serving system initializes with the latest production model from Unity Catalog. For each request, it fetches features from an online feature store and makes predictions.

1. **Monitoring:** Continuous or periodic [workflows](/azure/databricks/jobs) monitor input data and model predictions for drift, performance, and other metrics. You can use the [Delta Live Tables](/training/modules/build-data-pipeline-with-delta-live-tables/) framework to automate monitoring for pipelines, and store the metrics in lakehouse tables. [Databricks SQL](/azure/databricks/sql), [Power BI](/power-bi), and other tools can read from those tables to create dashboards and alerts. To monitor application metrics, logs, and infrastructure, you can also integrate Azure Monitor with Azure Databricks.

1. **Drift detection and model retraining:** This architecture supports both manual and automatic retraining. Schedule retraining jobs to keep models fresh. After a detected drift crosses a preconfigured threshold that you set in the monitoring step, the retraining pipelines analyze the drift and trigger retraining. You can configure pipelines to start automatically, or you can receive a notification and then run the pipelines manually.

### Components

- A **[data lakehouse](https://databricks.com/blog/2020/01/30/what-is-a-data-lakehouse.html)** architecture unifies the elements of data lakes and data warehouses. This architecture uses a lakehouse to get data management and performance capabilities that you typically find in data warehouses but with the low-cost, flexible object stores that data lakes provide.

  - **[Delta Lake](/azure/databricks/delta/)** is the recommended open-source data format for a lakehouse. In this architecture, Delta Lake stores all machine learning data in Data Lake Storage and provides a high-performance query engine.

- **[MLflow](https://www.mlflow.org)** is an open-source project for managing the end-to-end machine learning life cycle. In this architecture, MLflow tracks experiments, manages model versions, and facilitates model deployment to various inference platforms. MLflow has the following components:

  - The **[tracking feature](/azure/databricks/applications/mlflow/tracking)** tracks experiments, so you can record and compare parameters, metrics, and model artifacts.

    - **[Databricks autologging](/azure/databricks/applications/mlflow/databricks-autologging)** extends [MLflow automatic logging](https://mlflow.org/docs/latest/tracking.html#automatic-logging) to track machine learning experiments and automatically logs model parameters, metrics, files, and lineage information.

  - **[MLflow model](/azure/databricks/applications/mlflow/models)** is a format that you can use to store and deploy models from any machine learning library to various model-serving and inference platforms.

  - **[Unity Catalog](/azure/databricks/data-governance/unity-catalog/)** provides centralized access control, auditing, lineage, and data-discovery capabilities across Azure Databricks workspaces.

  - **[Mosaic AI Model Serving](/azure/databricks/machine-learning/model-serving/)** hosts MLflow models as REST endpoints.

- **[Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security)** is a managed platform for analytics and machine learning. In this architecture, Azure Databricks integrates with enterprise security, provides high availability, and connects MLflow and other machine learning components for end-to-end machine learning operations.

  - **[Databricks Runtime for Machine Learning](/azure/databricks/runtime/mlruntime#mlruntime)** automates the creation of a cluster that's optimized for machine learning and preinstalls popular machine learning libraries like TensorFlow, PyTorch, and XGBoost. It also preinstalls Azure Databricks for Machine Learning tools, like AutoML and feature store clients.

  - A **[feature store](/azure/databricks/applications/machine-learning/feature-store)** is a centralized repository of features. Use the feature store to discover and share features and help prevent data skew between model training and inference.

  - **[Databricks SQL](/azure/databricks/sql)** integrates with various tools so that you can author queries and dashboards in your favorite environments without adjusting to a new platform.

  - **[Git folders](/azure/databricks/repos)** provides integration with your Git provider in the Azure Databricks workspace, which improves notebook or code collaboration and IDE integration.

  - **[Workflows](/azure/databricks/data-engineering)** and **[jobs](/azure/databricks/jobs)** provide a way to run non-interactive code in an Azure Databricks cluster. For machine learning, jobs provide automation for data preparation, featurization, training, inference, and monitoring.

### Alternatives

You can tailor this solution to your Azure infrastructure. Consider the following customizations:

- Use multiple development workspaces that share a common production workspace.

- Exchange one or more architecture components for your existing infrastructure. For example, you can use [Azure Data Factory](/azure/data-factory/introduction) to orchestrate Databricks jobs.

- Integrate with your existing CI/CD tooling via Git and Azure Databricks REST APIs.

- Use [Microsoft Fabric](/fabric/data-science/machine-learning-model) or [Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/what-is-machine-learning) as alternative services for machine learning capabilities.

## Scenario details

This solution provides a robust machine learning operations process that uses Azure Databricks. You can replace all elements in the architecture, so you can integrate other Azure services and partner services as needed. This architecture and description are adapted from the e-book *[The Big Book of MLOps: Second Edition](https://www.databricks.com/p/ebook/the-big-book-of-mlops?itm_data=home-promocard3-bigbookmlops)*. The e-book explores this architecture in more detail.

Machine learning operations reduce the risk of failures in machine learning and AI systems and improve the efficiency of collaboration and tooling. For an introduction to machine learning operations and an overview of this architecture, see [Architect machine learning operations on the lakehouse](https://databricks.com/blog/2022/06/22/architecting-mlops-on-the-lakehouse.html).

Use this architecture to:

- **Connect your business stakeholders with machine learning and data science teams.** Use this architecture to incorporate notebooks and IDEs for development. Business stakeholders can view metrics and dashboards in Databricks SQL, all within the same lakehouse architecture.

- **Make your machine learning infrastructure data-centric.** This architecture treats machine learning data just like other data. Machine learning data includes data from feature engineering, training, inference, and monitoring. This architecture reuses tooling for production pipelines, dashboarding, and other general data processing for machine learning data processing.

- **Implement machine learning operations in modules and pipelines.**

  As with any software application, use the modularized pipelines and code in this architecture to test individual components and decrease the cost of future refactoring.

- **Automate your machine learning operations processes as needed.** In this architecture, you can automate steps to improve productivity and reduce the risk of human error, but you don't need to automate every step. Azure Databricks permits UI and manual processes in addition to APIs for automation.

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

### Foundation model fine-tuning in machine learning operations workflows

As more organizations use large language models for specialized tasks, adding foundation model fine-tuning to the machine learning operations process is important. You can use Azure Databricks to fine-tune foundation models with your data. This capability supports custom applications and a mature machine learning operations process. In the context of the machine learning operations architecture described in this article, fine-tuning aligns with several best practices:

- **Modularized pipelines and codes:** Fine-tuning tasks can be encapsulated as modular components within the training pipeline. This structure enables isolated evaluation and simplifies refactoring.

- **Experiment (fine-tuning run) tracking:** MLflow integration logs each fine-tuning run with specific parameters such as the number of epochs and learning rate, and with metrics such as loss and cross-entropy. This process improves reproducibility, auditability, and the ability to measure improvements.

- **Model registry and deployment:** Fine-tuned models are automatically registered in Unity Catalog. This automation streamlines deployment and governance.

- **Automation and CI/CD:** Fine-tuning jobs can be initiated via Databricks Workflows or CI/CD pipelines. This process supports continuous learning and model refresh cycles.

This approach allows teams to maintain high machine learning operations maturity while using the flexibility and power of foundation models. For more information, see [Foundation model fine-tuning on Azure Databricks](/azure/databricks/large-language-models/foundation-model-training).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b) | Senior Cloud Solution Architect
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/) | Principal Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AI and machine learning on Databricks](/azure/databricks/machine-learning)
- [Databricks machine learning product page and resources](https://databricks.com/product/machine-learning)
- [Train AI and machine learning models on Azure Databricks](/azure/databricks/machine-learning/train-model)

## Related resources

- [Machine learning operations maturity model](../../ai-ml/guide/mlops-maturity-model.yml)
- [Machine learning operations v2](../../ai-ml/guide/machine-learning-operations-v2.md)
