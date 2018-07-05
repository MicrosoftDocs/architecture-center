---
title: DevOps with Jenkins and Azure Kubernetes Service
description: Proven solution for building a DevOps pipeline for a Node.js web app that uses Jenkins, Azure Container Registry, Azure Kubernetes Service, Cosmos DB, and Grafana.
author: iainfoulds
ms.date: 06/22/2018
---
# Deploy a container-based DevOps pipeline for modern application development with Jenkins and Azure Kubernetes Service

This sample solution is applicable to businesses that have a need for modernizing application development by using containers and DevOps workflows. In this solution, a Node.js web app with is built and deployed by Jenkins into an Azure Container Registry and Azure Kubernetes Service. For a globally distributed database tier, Azure Cosmos DB is used. To monitor and troubleshoot application performance, Azure Monitor integrates with a Grafana instance and dashboard.

Example application scenarios include providing an automated development environment, validating new code commits, and pushing new deployments into staging or production environments. Traditionally, businesses had to manually build and compile applications and updates, and maintain a large, monolithic code base. With a modern approach to application development that uses continuous integration (CI) and continuous delivery (CD), you can more quickly build, test, and deploy services. This modern approach lets you release applications and updates to your customers faster, and respond to changing business demands in a more agile manner.

By leveraging Azure services such as Azure Kubernetes Service, Container Registry, and Cosmos DB, companies can use the latest in application development techniques and tools to simplify the process of implementing high availability.

## Potential use cases

You should consider this solution for the following use cases:

* Modernizing application development practices to a microservice, container-based approach.
* Speeding up application development and deployment lifecycles.
* Automating deployments to test or acceptance environments for validation.

## Architecture

![Architecture overview of the Azure components involved in a DevOps solution using Jenkins, Azure Container Registry, and Azure Kubernetes Service][architecture]

This solution covers a DevOps pipeline for a Node.js web application and database backend. The data flows through the solution as follows:

1. A developer makes changes to the Node.js web application source code.
2. The code change is committed to a source control respository, such as GitHub.
3. To start the continuous integration (CI) process, a GitHub webhook triggers a Jenkins project build.
4. The Jenkins build job uses a dynamic build agent in Azure Kubernetes Service to perform a container build process.
5. A container image is created from the code in source control, and is then pushed to an Azure Container Registry.
6. Through continuous deployment (CD), Jenkins deploys this updated container image to the Kubernetes cluster.
7. The Node.js web application uses Azure Cosmos DB as it's backend. Both Cosmos DB and Azure Kubernetes Service report metrics to Azure Monitor.
8. A Grafana instance provides visual dashboards of the application performance based on the data from Azure Monitor.

### Components

* [Jenkins][jenkins] is an open-source automation server that can integrate with Azure services to enable continuous integration (CI) and continuous delivery (CD). In this solution, Jenkins orchestrates the creation of new container images based on commits to source control, pushes those images to Azure Container Registry, then updates application instances in Azure Kubernetes Service.
* [Azure Linux Virtual Machines][azurevm-docs] are used to run the Jenkins and Grafana instances.
* [Azure Container Registry][azureacr-docs] stores and manages container images that are used by the Azure Kubernetes Service cluster. Images are securely stored, and can replicated to other regions by the Azure platform to speed up deployment times.
* [Azure Kubernetes Service][azureaks-docs] is a managed Kubernetes platform that lets you deploy and manage containerized applications without container orchestration expertise. As a hosted Kubernetes service, Azure handles critical tasks like health monitoring and maintenance for you.
* [Azure Cosmos DB][azurecosmosdb-docs] is a globally distributed, multi-model database that allows you to choose from various database and consistency models to suit your needs. With Cosmos DB, your data can be globally replicated, and there is no cluster management or replication components to deploy and configure.
* [Azure Monitor][azuremonitor-docs] helps you track performance, maintain security, and identify trends. Metrics obtained by Monitor can be used by other resources and tools, such as Grafana.
* [Grafana][grafana] is an open-source solution to query, visualize, alert, and understand metrics. A data source plugin for Azure Monitor allows Grafana to create visual dashboards to monitor the performance of your applications running in Azure Kubernetes Service and using Cosmos DB.

### Alternatives

Stuff goes here

## Considerations

### Availability

To monitor your application performance and report on issues, this solution combines Azure Monitor with Grafana for visual dashboards. These tools let you monitor and troubleshoot performance issues that may require code updates, which can all then be deployed with the CI/CD pipeline.

As part of the Azure Kubernetes Service cluster, a load balancer distributes application traffic to one or more containers (pods) that run your application. This approach to running containerized applications in Kubernetes provides a highly-available infrastructure for your customers.

For other scalability topics, see the [availability checklist][availability] available in the architecure center.

### Scalability

Azure Kubernetes Service lets you scale the number of cluster nodes to meet the demands of your applications. As your application increases, you can scale out the number of Kubernetes nodes that run your service.

Application data is stored in Azure Cosmos DB, a globally distributed, multi-model database that can scale globally. Cosmos DB abstracts the need to scale your  infrastructure as with traditional database components, and you can choose to replicate your Cosmos DB globally to meet the demands of your customers.

For other scalability topics, see the [scalability checklist][scalability] available in the architecure center.

### Security

To minimize the attack footprint, this solutions does not expose the Jenkins VM instance over HTTP. For any management tasks that require you to interact with Jenkins, you create a secure remote connection using an SSH tunnel from your local machine. Only SSH public key authentication is allowed for the Jenkins and Grafana VM instances. Password-based logins are disabled.

For separation of credentials and permissions, this solution uses a dedicated Azure Active Directory (AD) service principal. The credentials for this service principal are stored as a secure credential object in Jenkins so that they are not directly exposed and visible within scripts or the build pipeline.

For a deeper discussion on [security][], see the relevant article in the architecture center.

### Resiliency

This solution uses Azure Kubernetes Service for your application. Built in to Kubernetes are resiliency components that monitor and restart the containers (pods) if there is an issue. Combined with running multiple Kubernetes nodes, your application is able to tolerate a pod or node being unavailable.

For a deeper discussion on [resiliency][], see the relevant article in the architecture center.

## Deploy the solution

**Prerequisites.**

* You must have an existing Azure account. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.
* You need an SSH public key pair. For steps on how to create a public key pair, see [Create and use an SSH key pair for Linux VMs][sshkeydocs].
* You need an Azure Active Directory (AD) service principal for the authentication of service and resources. If needed, you can create a service principal with [az ad sp create-for-rbac][createsp]

    ```azurecli-interactive
    az ad sp create-for-rbac --name myDevOpsSolution
    ```

    Make a note of the *appId* and *password* in the output from this command. You provide these values to the template when you deploy the solution.

To deploy this solution with an Azure Resource Manager template, perform the following steps.

1. Select the **Deploy to Azure** button:<br><a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsolution-architectures%2Fmaster%2Fapps%2Fdevops-with-aks%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
2. Wait for the template deployment to open in the Azure portal, then complete the following steps:
   * Choose to **Create new** resource group, then provide a name such as *myAKSDevOpsSolution* in the text box.
   * Select a region from the **Location** drop-down box.
   * Enter your service principal app ID and password from the `az ad sp create-for-rbac` command.
   * Provide a username and secure password for the Jenkins instance and Grafana console.
   * Provide an SSH key to secure logins to the Linux VMs.
   * Review the terms and conditions, then check **I agree to the terms and conditions stated above**.
   * Select the **Purchase** button.

It can take 15-20 minutes for the deployment to complete.

## Pricing

To explore the cost of running this solution, all of the Azure service components are pre-configured in the following cost calculator links.  To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on the number of container images to store and Kubernetes nodes to run your applications.

* [Small][small-pricing]: this correlates to x container builds per month.
* [Medium][medium-pricing]: this correlates to x container builds per month.
* [Large][large-pricing]: this correlates to x container builds per month.

## Related Resources

This solution used Azure Container Registry and Azure Kubernetes Service to store and run your container-based applications. Azure Container Instances can also be used to run container-based applications, without having to provision any orchestration components. For more information, see [Azure Container Instances overview][azureaci-docs].

<!-- links -->
[architecture]: ./media/devops-with-aks/architecture-devops-with-aks.png
[autoscaling]: ../../best-practices/auto-scaling.md
[availability]: ../../checklist/availability.md
[azureaci-docs]: /azure/container-instances/container-instances-overview
[azureacr-docs]: /azure/container-registry/container-registry-intro
[azurecosmosdb-docs]: /azure/cosmos-db/introduction
[azureaks-docs]: /azure/aks/intro-kubernetes
[azuremonitor-docs]: /azure/monitoring-and-diagnostics/monitoring-overview
[azurevm-docs]: /azure/virtual-machines/linux/overview
[createsp]: /cli/azure/ad/sp#az-ad-sp-create
[grafana]: https://grafana.com/
[jenkins]: https://jenkins.io/
[resiliency]: ../../resiliency/index.md
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[security]: ../../patterns/category/security.md
[scalability]: ../../checklist/scalability.md
[sshkeydocs]: /azure/virtual-machines/linux/mac-create-ssh-keys

[small-pricing]: https://azure.com/e/841f0a75b1ea4802ba1ac8f7918a71e7
[medium-pricing]: https://azure.com/e/eea0e6d79b4e45618a96d33383ec77ba
[large-pricing]: https://azure.com/e/3faab662c54c473da55a1e93a27e0e64