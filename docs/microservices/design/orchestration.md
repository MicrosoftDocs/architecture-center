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
categories: containers
ms.custom:
  - microservices
  - guide
  - internal-intro
  - fcp
---

# Container orchestration for microservices

In a microservices architecture, each instance of a microservice is typically packaged and deployed to run inside a single container. Containers are lightweight and ephemeral, making them easy to create and destroy, but difficult to coordinate and network. This article discusses the challenges of running a microservice architecture in containers at production scale, and how container orchestration can help. The article presents several Azure container orchestration options.

## Containerized microservices architecture

Consider a three-tier web application running in an Azure Kubernetes Service (AKS) cluster:

1. One container hosts the front-end component.
2. Another container hosts the middle tier or REST API layer.
3. The middle tier communicates with a globally distributed database in a third container.

![Conceptual diagram of a simple containerized microservices web application.](images/orchestration/multi-container-cluster-with-orchestrator.png)

To manage the cluster, the DevOps team must:

- Run multiple container instances for each component.
- Load balance the traffic between the instances.
- Establish communication between dependent component instances.
- Maintain the desired AKS cluster state.

Running three containers on a single development machine might not be too hard. But a production environment has more containers running at scale. Managing a production cluster at scale in high-availability mode quickly becomes challenging.

With container orchestration, the DevOps team can represent the desired state of the cluster as a configuration. A container orchestration engine enforces the desired configuration and automates all the management tasks.

## Advantages of container orchestration

The following example shows how container orchestration can help manage cluster deployment, networking, and scaling. This capability is extremely useful in large and dynamic production environments.

![Diagram of an example microservices cluster showing container orchestrator scenarios.](images/orchestration/container-orchestrator-example.png)

The container orchestrator:

- Automatically scales the number of microservice instances, based on traffic or resource utilization. In the example, the orchestrator automatically adds another Microservice A instance in response to increased traffic.

- Manages the container to reflect the configured desired state. In the example, Microservice B is configured to have two instances. One instance has become unhealthy or stopped working, so the orchestrator has maintained the desired state by creating another instance.

- Wraps the containers for each microservice in a simple service layer. The service layer:
  
  - Abstracts out complexities like IP address, port, and number of instances.
  - Load balances traffic between microservice instances.
  - Allows easy orchestration of communication between dependent microservices.

- Can release a new version or roll back to an old version of a microservice or set of microservices, with no downtime.

- Provides flexibility and traffic control to enable side-by-side testing of different microservice versions.

## Choose an Azure container orchestrator technology

Here are some options for implementing microservices container orchestration in Azure:

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) is a fully managed [Kubernetes](https://kubernetes.io/)-based container orchestration service in Azure that simplifies deployment and management of containerized applications. AKS provides elastic provisioning, fast end to end deployment, and advanced identity and access management.

- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric/) is Microsoft's container orchestrator for deploying and managing microservices across a cluster of machines. Service Fabric comes with a lightweight run time that supports building stateless and stateful microservices.
  
  A key Service Fabric differentiator is its robust support for building stateful services.  You can use the built-in stateful services programming model, or run containerized stateful services written in any language or code.

- [Azure Container Instances (ACI)](https://azure.microsoft.com/services/container-instances/) is the fastest and simplest way to run a container in Azure. With ACI, you don't have to manage virtual machines or adapt any higher-level service offerings.
  
  With ACI, you can run Docker containers in a managed, serverless cloud environment. For simple orchestration scenarios, use [Docker Compose](https://docs.docker.com/compose/) to define and run a multi-container application locally. Then deploy the app as a container group on ACI. For full container orchestration scenarios, ACI integrates with AKS to create virtual nodes for AKS orchestration.

- [Azure Spring Cloud](https://azure.microsoft.com/services/spring-cloud/) is an enterprise-ready, fully managed service for [Spring Boot](https://spring.io/projects/spring-boot) apps. Spring Cloud lets you focus on building and running apps without having to manage infrastructure. Spring Cloud comes with built-in lifecycle management, ease of monitoring, and full integration with Azure.

- [Azure Red Hat OpenShift (ARO)](https://azure.microsoft.com/services/openshift/) service allows deployment of fully managed [OpenShift](https://www.openshift.com/) clusters on Azure. Running Kubernetes production containers requires image registries, storage management, monitoring, and integration with various tools and frameworks. ARO extends Kubernetes by combining all these tools into a single platform for easier operations.

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

