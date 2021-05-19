---
title: Container orchestration for microservices
description: Learn how container orchestration makes it easy to manage complex multi-container microservice deployments, scaling, and cluster health.
author: veerashayyagari
ms.date: 05/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - web
  - developer-tools
products:
  - azure-kubernetes-service
  - azure-service-fabric
  - azure-container-instances
ms.custom:
  - microservices
  - guide
  - internal-intro
  - fcp
---

# Container orchestration for microservices

In a microservices architecture, each instance of a microservice is typically packaged and deployed to run inside a single container. Containers are lightweight and ephemeral, making them easy to create and destroy, but difficult to coordinate and network. This article discusses the challenges of running containers in a microservice architecture at production scale, and how container orchestration can help. The article presents several options for container orchestration on Azure.

Consider a simple three-tier web application:

1. One container hosts the front-end component.
2. Another container hosts the middle tier or REST API layer.
3. The middle tier communicates with a globally-distributed database in a third container.

![Conceptual diagram of a simple containerized microservices web application.](images/orchestration/multi-container-cluster-with-orchestrator.png)

Running three containers on a single development machine might not be hard, but a microservices architecture for a production environment has more containers running at scale. Running a production cluster at scale in high-availability mode quickly becomes challenging.

To manage the cluster, a DevOps team must run multiple container instances for each component, load balance the traffic between the instances, establish communication between instances of dependent components, and maintain the desired cluster state.

With container orchestration, the DevOps team can represent the desired state of the cluster as a configuration. A container orchestration engine enforces the desired configuration, and automates all the management tasks.

## Advantages of container orchestration

The following example shows how container orchestration can help manage cluster deployment, networking, and scaling. This management capability is extremely useful for maintaining large and dynamic production environments.

![Diagram of an example microservices cluster showing container orchestrator scenarios.](images/orchestration/container-orchestrator-example.png)

The container orchestrator:

- Automatically scales the number of instances for a microservice, based on traffic or resource utilization. In the example, the orchestrator automatically adds another instance for Microservice A.

- Manages the container to reflect the configured desired state. Microservice B is configured to have two instances. If one instance becomes unhealthy or stops working, the orchestrator maintains the desired state by creating another instance.

- Wraps microservice containers in simple service layers. The service layer:
  
  - Abstracts out complexities like IP address, port, and number of instances.
  
  - Load balances traffic between instances of each microservice.
  
  - Allows easy orchestration of communication between dependent microservices.

- Can release a new version or roll back to an old version of a microservice or set of microservices, with no downtime.

- Provides flexibility and additional traffic control to enable side-by-side testing of different microservice versions.

## Choose an Azure container orchestrator technology

Here are some options for implementing microservices container orchestration in Azure:

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) is a fully managed [Kubernetes](https://kubernetes.io/)-based container orchestration service in Azure that simplifies deployment and management of containerized applications. AKS provides elastic provisioning, fast end to end deployment, and advanced identity and access management.

- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric/) is Microsoft's container orchestrator for deploying and managing microservices across a cluster of machines. Service Fabric comes with a lightweight run time that supports building stateless and stateful microservices. A key differentiator of Service Fabric is its robust support for building stateful services, either with Service Fabric built-in programming models or containerized stateful services.

- [Azure Container Instances (ACI)](https://azure.microsoft.com/services/container-instances/) is the fastest and simplest way to run a container in Azure, without having to manage any virtual machines or adapt any higher-level service offering. ACI allows containers to run in a serverless mode. For simple orchestration scenarios, you can use [Docker Compose](https://docs.docker.com/compose/) to define and run a multi-container application locally, and then deploy it as a container group on ACI. For scenarios that require full container orchestration, ACI integrates with AKS to create virtual nodes to be orchestrated by Kubernetes.

- [Azure Spring Cloud](https://azure.microsoft.com/services/spring-cloud/) is an enterprise-ready, fully managed service for [Spring Boot](https://spring.io/projects/spring-boot) apps. Spring Cloud lets you focus on building and running apps without having to manage infrastructure. Spring Cloud comes with built-in lifecycle management, ease of monitoring, and full integration with the Azure ecosystem and services.

- [Azure Red Hat OpenShift (ARO)](https://azure.microsoft.com/services/openshift/) service allows deployment of fully managed [OpenShift](https://www.openshift.com/) clusters on Azure. Running containers in production with Kubernetes requires tools like image registries, storage management, monitoring, continuous integration and continuous deliver (CI/CD) tools, and integration with various frameworks. ARO extends Kubernetes by combining all these tools into a single platform for ease of operations.

## Next steps

- [Microservices architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)
- [Advanced Azure Kubernetes Service (AKS) microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)
- [Microservices with AKS and Azure DevOps](/azure/architecture/solution-ideas/articles/microservices-with-aks)
- [Monitor a microservices architecture in AKS](../logging-monitoring.md)
- [Microservices architecture on Azure Service Fabric](/azure/architecture/reference-architectures/microservices/service-fabric)
- [Azure Spring Cloud reference architecture](/azure/spring-cloud/reference-architecture)

## Related resources

- [Build microservices on Azure](/azure/architecture/microservices/)
- [Design a microservices architecture](/azure/architecture/microservices/design/)
- [Design patterns for microservices](/azure/architecture/microservices/design/patterns)
- [Microservices architectural style](/azure/architecture/guide/architecture-styles/microservices)
- [Azure Kubernetes Service solution journey](/azure/architecture/reference-architectures/containers/aks-start-here)

