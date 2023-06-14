---
ms.custom:
  - devx-track-jenkins
---
[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Containers make it easy for you to continuously build and deploy applications. By orchestrating the deployment of those containers using Azure Kubernetes Service (AKS), you can achieve replicable, manageable clusters of containers.

By setting up a continuous build to produce your container images and orchestration, you can increase the speed and reliability of your deployment.

*[Jenkins](https://www.jenkins.io) and [Grafana](https://grafana.com/oss/) are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

Jenkins can be deployed on an [Azure Virtual Machine](/azure/virtual-machines). Alternately, [Jenkins X](https://jenkins-x.io/) can be deployed on Azure Kubernetes Service. Jenkins X is Jenkins sub project that can be deployed directly to cloud native platforms.

Dynamic build agents for Jenkins can be provisioned on Azure Kubernetes Service. [The Jenkins agent](https://www.jenkins.io/doc/book/using/using-agents/) connects to the Jenkins controller. The Jenkins controller can provision tasks to run on Jenkins agents.

## Potential use cases

* Modernize application development practices to a microservice, container-based approach.
* Speeding up application development and deployment lifecycles.
* Automating deployments to test or acceptance environments for validation.

## Architecture

:::image type="content" source="../media/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.svg" lightbox="../media/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.svg" alt-text="Diagram showing the Delphix Continuous Compliance architecture.":::

*Download a [Visio file](https://arch-center.azureedge.net/container-cicd-jenkins-aks.vsdx) of this architecture.*

### Dataflow

1. Developer makes changes to the application source code.
1. Developer commits the code changes to GitHub.
1. Continuous integration triggers Jenkins.
1. Jenkins launches the build job using Azure Kubernetes Service (AKS) for a dynamic build agent.
1. Jenkins builds and pushes Docker container to Azure Container Registry.
1. Jenkins deploys your new containerized app to Kubernetes on Azure.
1. The app connects to Azure Cosmos DB.
1. Grafana displays visualization of infrastructure and application metrics via Azure Monitor.

### Components

* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service): Simplify the deployment, management, and operations of Kubernetes.
* [Container Registry](https://azure.microsoft.com/services/container-registry): Store and manage container images across all types of Azure deployments.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db): Globally distributed, multi-model database for any scale.
* [Azure Monitor](https://azure.microsoft.com/services/monitor): Highly granular and real-time monitoring data for any Azure resource.
* [Visual Studio Code](https://azure.microsoft.com/products/visual-studio): Build and deploy multi-platform apps to get the most from Azure services.

## Deploy this scenario

* [Deploy to Azure](https://azure.microsoft.com/resources/templates/jenkins-cicd-container)

## Next steps

* [Integrating Jenkins with Azure Container Service and Kubernetes](/azure/container-service/kubernetes/container-service-kubernetes-jenkins)
* [Pushing Docker images to Azure Container Registry](/azure/container-registry/container-registry-get-started-docker-cli)
* [Connect existing Node.js to Azure Cosmos DB using the MongoDB connector](/azure/cosmos-db/create-mongodb-nodejs)
* [Monitor your Azure services using Grafana](/azure/monitoring-and-diagnostics/monitor-send-to-grafana)
* [Get the Azure Extension Pack for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack)
