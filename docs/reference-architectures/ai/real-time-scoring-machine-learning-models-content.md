This reference architecture shows how to deploy Python models as web services to make real-time predictions using [Azure Kubernetes Service][aml-aks]. Machine learning models deployed on Azure Kubernetes are good for high-scale production deployments. Two scenarios are covered in this article: deploying regular Python models, and the specific requirements of deploying deep learning models. Both scenarios use the architecture shown. In addition, two reference implementations for these scenarios are available on GitHub, one for [regular Python models][github-python] and one for [deep learning models][github-dl].

## Architecture

:::image type="content" alt-text="Architecture diagram for real-time scoring of Python models on Azure." source="./_images/python-model-architecture.png" lightbox="./_images/python-model-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/python-model-architecture.vsdx) of this architecture.*

### Scenario: Stack Overflow FAQ matching

This scenario shows how to deploy a frequently asked questions (FAQ) matching model as a web service to provide predictions for user questions. For this scenario, "Input Data" in the architecture diagram refers to text strings containing user questions to match with a list of FAQs. This scenario is designed for the [scikit-learn][scikit] machine learning library for Python, but can be generalized to any scenario that uses Python models to make real-time predictions.

This scenario uses a subset of Stack Overflow question data that includes original questions tagged as JavaScript, their duplicate questions, and their answers. It trains a scikit-learn pipeline to predict the match probability of a duplicate question with each of the original questions. These predictions are made in real time using a REST API endpoint.

#### Workflow

The application flow for this architecture is as follows:

1. The trained model is registered to the machine learning model registry.
2. Azure Machine Learning creates a Docker image that includes the model and scoring script.
3. Azure Machine Learning deploys the scoring image on Azure Kubernetes Service (AKS) as a web service.
4. The client sends an HTTP POST request with the encoded question data.
5. The web service created by Azure Machine Learning extracts the question from the request.
6. The question is sent to the scikit-learn pipeline model for featurization and scoring.
7. The matching FAQ questions with their scores are returned to the client.

Here is a screenshot of the example app that consumes the results:

![Screenshot of an example FAQ matching application using a subset of Stack Overflow question data.](./_images/python-faq-matches.png)

### Scenario: Image classification with a Convolutional Neural Network

This scenario shows how to deploy a Convolutional Neural Network (CNN) model as a web service to provide predictions on images. For this scenario, "Input Data" in the architecture diagram refers to image files. CNNs are effective in computer vision for tasks such as image classification and object detection. This scenario is designed for the frameworks TensorFlow, Keras (with the TensorFlow back end), and PyTorch. However, it can be generalized to any scenario that uses deep learning models to make real-time predictions.

This scenario uses a pre-trained ResNet-152 model trained on ImageNet-1K (1,000 classes) dataset to predict which category (see figure below) an image belongs to. These predictions are made in real time using a REST API endpoint.

![Example of image classification predictions using a Convolutional Neural Network (CNN) model as a web service.](./_images/python-example-predictions.png)

#### Workflow

The application flow for the deep learning model is as follows:

1. The deep learning model is registered to the machine learning model registry.
2. Azure Machine Learning creates a docker image including the model and scoring script.
3. Azure Machine Learning deploys the scoring image on Azure Kubernetes Service (AKS) as a web service.
4. The client sends an HTTP POST request with the encoded image data.
5. The web service created by Azure Machine Learning preprocesses the image data and sends it to the model for scoring.
6. The predicted categories with their scores are returned to the client.

### Components

This architecture consists of the following components.

**[Azure Machine Learning][aml]** is a cloud service that is used to train, deploy, automate, and manage machine learning models, all at the broad scale that the cloud provides. It is used in this architecture to manage the deployment of models and authentication, routing, and load balancing of the web service.

**[Virtual machine][vm]** (VM). The VM is shown as an example of a device—local or in the cloud—that can send an HTTP request.

**[Azure Kubernetes Service][aks]** (AKS) is used to deploy the application on a Kubernetes cluster. AKS simplifies the deployment and operations of Kubernetes. The cluster can be configured using CPU-only VMs for regular Python models or GPU-enabled VMs for deep learning models.

**[Azure Container Registry][acr]** enables storage of images for all types of Docker container deployments including DC/OS, Docker Swarm and Kubernetes. The scoring images are deployed as containers on Azure Kubernetes Service and used to run the scoring script. The image used here is created by Machine Learning from the trained model and scoring script, and then is pushed to the Azure Container Registry.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

For real-time scoring architectures, throughput performance becomes a dominant consideration. For regular Python models, CPUs are sufficient to handle the workload.

However for deep learning workloads, when speed is a bottleneck, GPUs generally provide better [performance][gpus-vs-cpus] compared to CPUs. To match GPU performance using CPUs, a cluster with large number of CPUs is typically needed.

You can use CPUs for this architecture in either scenario, but for deep learning models, GPUs provide higher throughput values compared to a CPU cluster of similar cost. AKS supports the use of GPUs, which is one advantage of using AKS for this architecture. Also, deep learning deployments typically use models with a high number of parameters. Using GPUs prevents contention for resources between the model and the web service, which is an issue in CPU-only deployments.

### Scalability

For regular Python models, where the AKS cluster is provisioned with CPU-only VMs, take care when [scaling out the number of pods][manually-scale-pods]. The goal is to fully utilize the cluster. Scaling depends on the CPU requests and limits defined for the pods. Machine Learning through Kubernetes also supports [pod autoscaling][autoscale-pods] based on CPU utilization or other metrics. The [cluster autoscaler][autoscaler] can scale agent nodes based on the pending pods.

For deep learning scenarios, using GPU-enabled VMs, resource limits on pods are such that one GPU is assigned to one pod. Depending on the type of VM used, you must [scale the nodes of the cluster][scale-cluster] to meet the demand for the service. You can do this easily using the [Azure CLI][azure-cli-kubernetes] and [kubectl][kubectl].

### Monitoring and logging

#### AKS monitoring

For visibility into AKS performance, use the [Azure Monitor container insights][monitor-containers] feature. It collects memory and processor metrics from controllers, nodes, and containers that are available in Kubernetes through the Metrics API.

While deploying your application, monitor the AKS cluster to make sure it's working as expected, all the nodes are operational, and all pods are running. Although you can use the [kubectl][kubectl] command-line tool to retrieve pod status, Kubernetes also includes a web dashboard for basic monitoring of the cluster status and management.

![A screenshot of the Kubernetes dashboard for basic monitoring of the cluster status and management.](./_images/python-kubernetes-dashboard.png)

To see the overall state of the cluster and nodes, go to the **Nodes** section of the Kubernetes dashboard. If a node is inactive or has failed, you can display the error logs from that page. Similarly, go to the **Pods** and **Deployments** sections for information about the number of pods and status of your deployment.

#### AKS logs

AKS automatically logs all stdout/stderr to the logs of the pods in the cluster. Use kubectl to see these and also node-level events and logs. For details, see the deployment steps.

Use [Azure Monitor container insights][monitor-containers] to collect metrics and logs through a containerized version of the Log Analytics agent for Linux, which is stored in your Log Analytics workspace.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Use [Microsoft Defender for Cloud][security-center] to get a central view of the security state of your Azure resources. Defender for Cloud monitors potential security issues and provides a comprehensive picture of the security health of your deployment, although it doesn't monitor AKS agent nodes. Defender for Cloud is configured per Azure subscription. Enable security data collection as described in [Enable Defender for Cloud on your subscriptions][get-started]. When data collection is enabled, Defender for Cloud automatically scans any VMs created under that subscription.

**Operations**. To sign in to an AKS cluster using your Azure Active Directory (Azure AD) authentication token, configure AKS to use Azure AD for [user authentication][aad-auth]. Cluster administrators can also configure Kubernetes role-based access control (Kubernetes RBAC) based on a user's identity or directory group membership.

Use [Azure RBAC][rbac] to control access to the Azure resources that you deploy. Azure RBAC lets you assign authorization roles to members of your DevOps team. A user can be assigned to multiple roles, and you can create custom roles for even more fine-grained [permissions].

**HTTPS**. As a security best practice, the application should enforce HTTPS and redirect HTTP requests. Use an [ingress controller][ingress-controller] to deploy a reverse proxy that terminates SSL and redirects HTTP requests. For more information, see [Create an HTTPS ingress controller on Azure Kubernetes Service (AKS)][https-ingress].

**Authentication**. This solution doesn't restrict access to the endpoints. To deploy the architecture in an enterprise setting, secure the endpoints through API keys and add some form of user authentication to the client application.

**Container registry**. This solution uses Azure Container Registry to store the Docker image. The code that the application depends on, and the model, are contained within this image. Enterprise applications should use a private registry to help guard against running malicious code and to help keep the information inside the container from being compromised.

**DDoS protection**. Consider enabling [Azure DDoS Network Protection][ddos]. Although basic DDoS protection is enabled as part of the Azure platform, DDoS Network Protection provides mitigation capabilities that are tuned specifically to Azure virtual network resources.

**Logging**. Use best practices before storing log data, such as scrubbing user passwords and other information that could be used to commit security fraud.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the  [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Here are some other considerations.

For more information, see the Microsoft Azure Well-Architected Framework article [Principles of cost optimization][aaf-cost].

#### Azure Machine Learning

In this reference architecture, a large portion of cost is driven by compute resources. For the purposes of experimentation and training, Azure Machine Learning is free. You are only charged for the compute used by the web service. Use the [Azure pricing calculator][azure-pricing-calculator] to estimate your compute costs.

#### Azure Container Registry

Azure Container Registry offers **Basic**, **Standard**, and **Premium**. Choose a tier depending on the storage you need. Choose **Premium**  if you need geo replication, or you enhanced throughput for docker pulls across concurrent nodes. In addition, standard networking charges apply. For more information, see Azure [Container Registry pricing][az-container-registry-pricing].

#### Azure Kubernetes Service

You only pay for the virtual machines instances, storage, and networking resources consumed by your Kubernetes cluster. To estimate the cost of the required resources, see the [Container Services calculator][aks-Calculator].

For more information, see the Microsoft Azure Well-Architected Framework article [Principles of cost optimization][aaf-cost].

### DevOps

In this architecture, the scoring images are created by the Machine Learning model and deployed as containers on AKS. You can integrate the entire architecture into a release pipeline for model management and operationalization. The pipeline can include DevOps tasks for data sanity test, model training on different compute targets, model version management, model deployment as a real-time web service, staged deployment to QA/production environments, integration testing, and functional testing. The [Machine learning operationalization (MLOps) for Python models using Azure Machine Learning][mlops-ra] reference architecture shows how to implement a continuous integration (CI), continuous delivery (CD), and retraining pipeline for an AI application using Azure DevOps and Azure Machine Learning.

## Deploy this scenario

To deploy this reference architecture, follow the steps described in the GitHub repos:

- [Regular Python models][github-python]
- [Deep learning models][github-dl]

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

 - [Mathew Salvaris](https://www.linkedin.com/in/drmathewsalvaris) | Principal Data Scientist Lead
 - [Fidan Boylu Uz](https://www.linkedin.com/in/fidan-boylu-uz-ph-d-mba-3a6b782) | Principal Data Scientist Manager
 - [Yan Zhang](https://www.linkedin.com/in/yanzhangmicrosoft) | Senior Data Scientist
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Read the product documentation:

- [Deploy a model to an Azure Kubernetes Service cluster][aml-aks]
- [Introduction to private Docker container registries in Azure][registry-intro]

Try these learning paths:

- [Introduction to Kubernetes on Azure][mslearn-aks-intro]
- [Develop and deploy applications on Kubernetes][mslearn-aks-deploy]

## Related resources

- [Azure Machine Learning architecture](/azure/architecture/solution-ideas/articles/azure-machine-learning-solution-architecture)
- [Many models machine learning (ML) at scale with Azure Machine Learning](/azure/architecture/example-scenario/ai/many-models-machine-learning-azure-machine-learning)
- [Deploy machine learning models to multiple data sources](/azure/architecture/example-scenario/ai/multiline-model-deployment)
- [Scale AI and machine learning initiatives in regulated industries](/azure/architecture/example-scenario/ai/scale-ai-and-machine-learning-in-regulated-industries)
- [Predictive marketing with machine learning](/azure/architecture/solution-ideas/articles/predictive-marketing-campaigns-with-machine-learning-and-spark)
- [Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](/azure/architecture/example-scenario/mlops/mlops-technical-paper)

<!-- links -->

[aad-auth]: /azure/aks/managed-aad
[aaf-cost]: /azure/architecture/framework/cost/overview
[acr]: /azure/container-registry
[aks]: /azure/aks/intro-kubernetes
[aks-Calculator]: https://azure.microsoft.com/pricing/calculator/?service=kubernetes-service
[aml]: /azure/machine-learning/overview-what-is-azure-machine-learning
[aml-aks]: /azure/machine-learning/how-to-deploy-azure-kubernetes-service
[autoscaler]: /azure/aks/autoscaler
[autoscale-pods]: /azure/aks/tutorial-kubernetes-scale#autoscale-pods
[az-container-registry-pricing]: https://azure.microsoft.com/pricing/details/container-registry
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[azure-cli-kubernetes]: /azure/aks/kubernetes-walkthrough
[ddos]: /azure/virtual-network/ddos-protection-overview
[get-started]: /azure/security-center/security-center-get-started
[github-python]: https://github.com/Microsoft/MLAKSDeployAML
[github-dl]: https://github.com/Microsoft/AKSDeploymentTutorial_AML
[gpus-vs-cpus]: https://azure.microsoft.com/blog/gpus-vs-cpus-for-deployment-of-deep-learning-models/
[https-ingress]: /azure/aks/ingress-tls
[ingress-controller]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[manually-scale-pods]: /azure/aks/tutorial-kubernetes-scale#manually-scale-pods
[mlops-ra]: ./mlops-python.yml
[monitor-containers]: /azure/monitoring/monitoring-container-insights-overview
[mslearn-aks-deploy]: /training/paths/develop-deploy-applications-kubernetes/
[mslearn-aks-intro]: /training/paths/intro-to-kubernetes-on-azure/
[permissions]: /azure/aks/concepts-identity
[rbac]: /azure/role-based-access-control/overview
[registry-intro]: /azure/container-registry/container-registry-intro
[scale-cluster]: /azure/aks/scale-cluster
[scikit]: https://pypi.org/project/scikit-learn/
[security-center]: /azure/security-center/security-center-intro
[vm]: /azure/virtual-machines/
