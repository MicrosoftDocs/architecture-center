---
ms.custom:
  - devx-track-python
---
This reference architecture shows how to implement continuous integration (CI), continuous delivery (CD), and retraining pipeline for an AI application using [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) and [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning). The solution is built on the scikit-learn diabetes dataset but can be easily adapted for any AI scenario and other popular build systems such as Jenkins or Travis.

A reference implementation for this architecture is available on [GitHub][repo].

## Architecture

:::image type="content" border="false" source="./_images/ml-ops-python.png" alt-text="Diagram of the Machine Learning DevOps architecture." lightbox="./_images/ml-ops-python.png":::

*Download a [Visio file](https://arch-center.azureedge.net/mlops-python.vsdx) of this architecture.*

### Workflow

This architecture consists of the following services:

**[Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines)**. This build and test system is based on Azure DevOps and used for the build and release pipelines. Azure Pipelines breaks these pipelines into logical steps called tasks. For example, the [Azure CLI](/cli/azure/) task makes it easier to work with Azure resources.

**[Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning)** is a cloud service for training, scoring, deploying, and managing machine learning models at scale. This architecture uses the Azure Machine Learning [Python SDK](/azure/machine-learning/service/quickstart-create-workspace-with-python) to create a workspace, compute resources, the machine learning pipeline, and the scoring image. An Azure Machine Learning [workspace](/azure/machine-learning/service/concept-workspace) provides the space in which to experiment, train, and deploy machine learning models.

**[Azure Machine Learning Compute](/azure/machine-learning/service/how-to-set-up-training-targets)** is a cluster of virtual machines on-demand with automatic scaling and GPU and CPU node options. The training job is executed on this cluster.

**[Azure Machine Learning pipelines](/azure/machine-learning/service/concept-ml-pipelines)** provide reusable machine learning workflows that can be reused across scenarios. Training, model evaluation, model registration, and image creation occur in distinct steps within these pipelines for this use case. The pipeline is published or updated at the end of the build phase and gets triggered on new data arrival.

**[Azure Blob Storage](/azure/storage/blobs/storage-blobs-overview)**. Blob containers are used to store the logs from the scoring service. In this case, both the input data and the model prediction are collected. After some transformation, these logs can be used for model retraining.

**[Azure Container Registry](/azure/container-registry/container-registry-intro)**. The scoring Python script is packaged as a Docker image and versioned in the registry.

**[Azure Container Instances](/azure/container-instances/container-instances-overview)**. As part of the release pipeline, the QA and staging environment is mimicked by deploying the scoring webservice image to Container Instances, which provides an easy, serverless way to run a container.

**[Azure Kubernetes Service](/azure/aks/intro-kubernetes)**. Once the scoring webservice image is thoroughly tested in the QA environment, it is deployed to the production environment on a managed Kubernetes cluster.

**[Azure Application Insights](/azure/azure-monitor/app/app-insights-overview)**. This monitoring service is used to detect performance anomalies.

## MLOps Pipeline

This solution demonstrates end-to-end automation of various stages of an AI project using tools that are already familiar to software engineers. The machine learning problem is simple to keep the focus on the DevOps pipeline. The solution uses the [scikit-learn diabetes dataset](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.load_diabetes.html) and builds a ridge linear regression model to predict the likelihood of diabetes. See [Training of Python scikit-learn models](/azure/architecture/example-scenario/ai/training-python-models) for details.

This solution is based on the following three pipelines:

- **Build pipeline**. Builds the code and runs a suite of tests.
- **Retraining pipeline**. Retrains the model on a schedule or when new data becomes available.
- **Release pipeline**. Operationalizes the scoring image and promotes it safely across different environments.

The next sections describe each of these pipelines.

### Build pipeline

The CI pipeline gets triggered every time code is checked in. It publishes an updated Azure Machine Learning pipeline after building the code and running a suite of tests. The build pipeline consists of the following tasks:

- **Code quality.** These tests ensure that the code conforms to the standards of the team.

- **Unit test.** These tests make sure the code works, has adequate code coverage, and is stable.

- **Data test.** These tests verify that the data samples conform to the expected schema and distribution. Customize this test for other use cases and run it as a separate data sanity pipeline that gets triggered as new data arrives. For example, move the data test task to a *data ingestion pipeline* so you can test it earlier.

> [!NOTE]
> You should consider enabling DevOps practices for the data used to train the machine learning models, but this is not covered in this article. For more information about the architecture and best practices for CI/CD of a data ingestion pipeline, see [DevOps for a data ingestion pipeline](/azure/machine-learning/how-to-cicd-data-ingestion).

The following one-time tasks occur when setting up the infrastructure for Azure Machine Learning and the Python SDK:

- Create the workspace that hosts all Azure Machine Learning-related resources.
- Create the compute resources that run the training job.
- Create the machine learning pipeline with the updated training script.
- Publish the machine learning pipeline as a REST endpoint to orchestrate the training workflow. The next section describes this step.

### Retraining pipeline

The machine learning pipeline orchestrates the process of retraining the model in an asynchronous manner. Retraining can be triggered on a schedule or when new data becomes available by calling the published pipeline REST endpoint from the previous step.

This pipeline covers the following steps:

- **Train model.** The training Python script is executed on the Azure Machine Learning Compute resource to get a new [model](/azure/machine-learning/service/concept-azure-machine-learning-architecture#models) file which is stored in the [run history](/azure/machine-learning/service/concept-azure-machine-learning-architecture#runs). Since training is the most compute-intensive task in an AI project, the solution uses [Azure Machine Learning Compute](/azure/machine-learning/service/how-to-set-up-training-targets#amlcompute).

- **Evaluate model.** A simple evaluation test compares the new model with the existing model. Only when the new model is better does it get promoted. Otherwise, the model is not registered and the pipeline is canceled.

- **Register model.** The retrained model is registered with the [Azure ML Model registry](/azure/machine-learning/service/concept-azure-machine-learning-architecture). This service provides version control for the models along with metadata tags so they can be easily reproduced.

### Release pipeline

This pipeline shows how to operationalize the scoring image and promote it safely across different environments. This pipeline is subdivided into two environments, QA and production:

#### QA environment

- **Model Artifact trigger.** Release pipelines get triggered every time a new artifact is available. A new model registered to Azure Machine Learning Model Management is treated as a release artifact. In this case, a pipeline is triggered for each new model is registered.

- **Create a scoring image.** The registered model is packaged together with a scoring script and Python dependencies ([Conda YAML file](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html)) into an operationalization Docker image. The image automatically gets versioned through Azure Container Registry.

- **Deploy on Container Instances.** This service is used to create a non-production environment. The scoring image is also deployed here, and this is mostly used for testing. Container Instances provides an easy and quick way to test the Docker image.

- **Test web service.** A simple API test makes sure the image is successfully deployed.

#### Production environment

- **Deploy on Azure Kubernetes Service.** This service is used for deploying a scoring image as a web service at scale in a production environment.

- **Test web service.** A simple API test makes sure the image is successfully deployed.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability

A build pipeline on Azure DevOps can be scaled for applications of any size. Build pipelines have a maximum timeout that varies depending on the agent they are run on. Builds can run forever on self-hosted agents (private agents). For Microsoft-hosted agents for a public project, builds can run for six hours. For private projects, the limit is 30 minutes.

To use the maximum timeout, set the following property in your [Azure Pipelines YAML](/azure/devops/pipelines/process/phases?tabs=yaml#timeouts) file:

```yaml
jobs:
- job: <job_name>
  timeoutInMinutes: 0
```

Ideally, have your build pipeline finish quickly and execute only unit tests and a subset of other tests. This allows you to validate the changes quickly and fix them if issues arise. Run long-running tests during off-hours.

The release pipeline publishes a real-time scoring web service. A release to the QA environment is done using Container Instances for convenience, but you can use another Kubernetes cluster running in the QA/staging environment.

Scale the production environment according to the size of your Azure Kubernetes Service cluster. The size of the cluster depends on the load you expect for the deployed scoring web service. For real-time scoring architectures, throughput is a key optimization metric. For non-deep learning scenarios, the CPU should be sufficient to handle the load; however, for deep learning workloads, when speed is a bottleneck, GPUs generally provide better performance compared to CPUs. Azure Kubernetes Service supports both CPU and GPU node types, which is the reason this solution uses it for image deployment. For more information, see [GPUs vs CPUs for deployment of deep learning models.](https://azure.microsoft.com/blog/gpus-vs-cpus-for-deployment-of-deep-learning-models/)

Scale the retraining pipeline up and down depending on the number of nodes in your Azure Machine Learning Compute resource, and use the [autoscaling](/azure/machine-learning/service/how-to-set-up-training-targets#persistent) option to manage the cluster. This architecture uses CPUs. For deep learning workloads, GPUs are a better choice and are supported by Azure Machine Learning Compute.

### Management

- **Monitor retraining job.** Machine learning pipelines orchestrate retraining across a cluster of machines and provide an easy way to monitor them. Use the [Azure Machine Learning UI](https://ml.azure.com/) and look under the pipelines section for the logs. Alternatively, these logs are also written to blob and can be read from there as well using tools such as [Azure Storage Explorer](https://azure.microsoft.com/features/storage-explorer/).

- **Logging.** Azure Machine Learning provides an easy way to log at each step of the machine learning life cycle. The logs are stored in a blob container. For more information, see [Enable logging in Azure Machine Learning](/azure/machine-learning/service/how-to-enable-logging). For richer monitoring, configure [Application Insights](/azure/machine-learning/how-to-enable-app-insights#use-azure-machine-learning-studio-to-configure) to use the logs.

- **Security.** All secrets and credentials are stored in [Azure Key Vault](/azure/key-vault/) and accessed in Azure Pipelines using [variable groups](/azure/devops/pipelines/library/variable-groups?tabs=yaml#link-secrets-from-an-azure-key-vault).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Azure DevOps is [free](https://azure.microsoft.com/pricing/details/devops/azure-devops-services/) for open-source projects and small projects with up to five users. For larger teams, purchase a plan based on the number of users.

Compute is the biggest cost driver in this architecture and its cost varies depending on the use case. This architecture uses Azure Machine Learning Compute, but other [options](/azure/machine-learning/concept-compute-target#train) are available. Azure Machine Learning does not add any surcharge on top of the cost of the virtual machines backing your compute cluster. Configure your compute cluster to have a minimum of 0 nodes, so that when not in use, it can scale down to 0 nodes and not incur any costs. The compute cost depends on the node type, a number of nodes, and provisioning mode (low-priority or dedicated). You can estimate the cost for Machine Learning and other services using the Azure [pricing calculator](https://azure.microsoft.com/pricing/calculator/?service=machine-learning-service).

## Deploy this scenario

To deploy this reference architecture, follow the steps described in the [Getting Started](https://github.com/microsoft/MLOpsPython/blob/master/docs/getting_started.md) guide in the [GitHub repo][repo].

[repo]: https://github.com/Microsoft/MLOpsPython

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Praneet Singh Solanki](https://www.linkedin.com/in/praneetsolanki/) | Senior Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Want to learn more? Check out the related learning path, [Start the machine learning lifecycle with MLOps](/training/modules/start-ml-lifecycle-mlops/).
