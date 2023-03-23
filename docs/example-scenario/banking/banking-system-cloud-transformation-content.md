This article summarizes the process and components the Microsoft Commercial Software Engineering (CSE) team used to build a solution for a banking customer. For the sake of anonymity, the article refers to the customer as Contoso Bank. It's a major international financial services industry (FSI) organization that wanted to modernize one of its financial transaction systems.

## Architecture

:::image type="content" border="false" source="./images/banking-system-solution-arch.png" alt-text="Diagram showing a full solution architecture for a banking system cloud transformation." lightbox="./images/banking-system-solution-arch.png":::

*Download a [Visio file](https://arch-center.azureedge.net/banking-system-solution-arch.vsdx) of this architecture.*

Three main blocks make up the solution: back-end services, load testing, and monitoring with Event Autoscaler.

The actual Contoso microservices containers were manually pushed through Docker to the Kubernetes cluster. This cluster was:

* Azure Red Hat OpenShift (ARO) in the Kubernetes/OpenShift Horizontal Pod Autoscaler (HPA) for:

  * Channel Holder.

  * Scalability and Performance for Transaction Simulation deliverables.

* Azure Kubernetes Services (AKS) for the node autoscaler for Channel Holder.

 The CSE team created the other microservices as stubs to specifically isolate the actual Contoso microservices from other external mainframe services that the solution pushed through Azure Pipelines.

### Workflow

At the core, the backend services provide the necessary logic for an EFT to happen:

1. A new EFT starts with an HTTP request received by the Channel Holder service.

    The service provides synchronous responses to requesters using a _publish-subscribe_ pattern through an Azure Cache for Redis and waits for a backend response.

1. The solution validates this initial request using the EFT Pilot Password service.

    Besides carrying out validations, the service also enriches the data. The data enrichment helps the backend decide if the solution should use a legacy microservice system or a new one to process the EFT.

1. The Channel Holder service then starts the asynchronous flow.

    The service calls the EFT Controller, which is a reactive orchestrator that coordinates a transaction flow. It does so by producing commands and consuming events from other microservices through Azure Event Hubs/Kafka.

1. One of these services is the EFT Processor, where the solution effectuates the actual transaction, carrying out credit and debit operations.

    The CSE team used [KEDA](https://keda.sh). It's a framework that automatically scales applications based on the load of messages the solution processed. In the solution, it was used to scale the EFT Processor as the solution processed new EFTs.

    KEDA is only supported on AKS.

1. Next is load testing. It contains a custom solution based on JMeter, Azure Container Instances (ACI), and Terraform.

    The team used the Load Testing block of the solution to provision the necessary integration with Azure Pipelines. This solution generated enough load on the backend services to validate that the autoscaling mechanisms were in place, creating thousands of EFT transactions per second.

1. Finally, monitoring was responsible for integrating load testing results, infrastructure, and application metrics.

    The team correlated a load testing run with the side effects caused by microservices on the storage and container orchestration layer. It allowed a quick feedback cycle for application tuning. Prometheus, Grafana, and Application Insights in Azure Monitor were the core components that allowed this monitoring and observability capability. The Event Autoscaler supported the validation of a scenario where applications scale based on the message loading received. To implement this behavior the CSE team adapted KEDA to support the Java applications scaling.

### Solution capabilities

The solution involves three major capabilities:

* Horizontal Pod Autoscaler for Channel Holder

* Node autoscaling for Channel Holder

* Scalability and performance for transaction simulation deliverables

#### Horizontal Pod Autoscaler for Channel Holder

In this solution, the team used a Kubernetes/OpenShift HPA mechanism. HPA automatically scales the number of pods based on a selected metric. Doing so provides an efficient _scale in and out_ mechanism for containers. Given the CPU-bound nature of the Channel Holder REST API, the team opted for using HPA with CPU so that the service replicas can grow as new EFTs occur.

This component runs a service called Channel Holder on Azure Red Hat OpenShift. It carries out pod autoscaling tests on this service. The component had to achieve the following capabilities:

* Provide a DevOps pipeline from on-premises to Azure for the Channel Holder service.

* Provide OpenShift cluster monitoring through a Grafana dashboard.

* Execute horizontal pod autoscaling tests for the Channel Holder service.

* Provide observability on the Channel Holder by activating metrics capture (for example, usage) with Prometheus and Grafana.

* Provide a detailed report about the tests executed, the applications' behavior, and the Kafka partitioning strategies, if any.

#### Node autoscaling for Channel Holder

First HPA scales the replicas up to a point where it saturates the cluster infrastructure. Then a scale in and out mechanism for the nodes keeps the applications receiving and processing new requests. For that mechanism, the team used Kubernetes node autoscaling, which allowed the cluster to grow even when all nodes were close to their full capacity.

This component focuses on running the Channel Holder service on AKS to allow node autoscaling tests. It had to achieve the following capabilities:

* Provide AKS cluster monitoring through a Grafana dashboard.

* Execute node autoscaling tests for the Channel Holder service.

* Provide observability on the Channel Holder by activating metrics capture with Prometheus and Grafana.

* Provide a detailed report about the tests executed, the applications' behavior, and the Kafka partitioning strategies, if any.

#### Scalability and performance for transaction simulation deliverables

Using the load testing framework, the CSE team generated enough load to trigger both HPA and node autoscaling mechanisms. When the solution triggered the components, it generated infrastructure and application metrics for the team to validate Channel Holder scaling response times and the application behavior under high load.

This component focuses on running Channel Holder, EFT Controller, and EFT Processor services on ARO and AKS. Also, it carries out pod and node autoscaling and performance tests on all services. It had to achieve the following capabilities:

* Execute performance tests over the microservices until it reaches or surpasses 2000 transactions per second.

* Execute horizontal pod/node autoscaling tests over the microservices.

* Provide observability on the Channel Holder by activating metrics capture with Prometheus and Grafana.

* Provide a detailed report about the tests executed, the applications' behavior and the Kafka partitioning strategies adopted.

### Components

The list below summarizes the technologies that the CSE team used to create this solution:

* Azure

  * [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines)

  * [Azure Kubernetes Services (AKS)](https://azure.microsoft.com/services/kubernetes-service)

  * [Azure Red Hat OpenShift](https://azure.microsoft.com/services/openshift)

  * [Azure SQL Database](https://azure.microsoft.com/services/sql-database)

  * [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) - [(Kafka)](/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview)

  * [Azure Monitor](https://azure.microsoft.com/services/monitor)

  * [Azure Container Registry](https://azure.microsoft.com/services/container-registry)

  * [Azure Container Instances (ACI)](https://azure.microsoft.com/services/container-instances)

  * [Azure Cache for Redis](https://azure.microsoft.com/services/cache)

* Third-party

  * Contoso Bank back-end services

  * [Docker](https://www.docker.com)

  * [Grafana](https://grafana.com)

  * [Prometheus](https://prometheus.io)

* Open-source

  * [Jenkins](https://www.jenkins.io)

  * [KEDA](https://keda.sh)

  * [Apache JMeter](https://jmeter.apache.org)

  * [Redis](https://redis.io)

## Scenario details

Contoso Bank is a major international financial services industry (FSI) organization that wanted to modernize one of its financial transaction systems.

Contoso Bank wanted to use simulated and actual applications and existing workloads to monitor the reaction of the solution infrastructure for scalability and performance. The solution had to be compatible with the requirements of the existing payment system.

### Potential use cases

Contoso Bank wanted to use a set of simulations to:

* Determine the impact of infrastructure scalability.

* Determine the reaction to failures in the existing architectural design of specific mainframe software.

The proposed solution would use a virtual application to simulate functional scenarios. Its purpose would be to monitor the performance and scalability of the infrastructure. The aim was to determine the impact of failures in the mainframe Electronic Funds Transfer (EFT) system workloads through this set of simulations.

There was also a requirement to propose a smooth DevOps transition from on-premises to the cloud. The transition had to include the bank's process and methodology, and it had to  use Contoso Bank's existing tools. Using existing technologies would reduce the up-skill impact for the developers. The transition would assist Contoso Bank in reviewing current and future design decisions. The transition would also provide confidence that Azure is an environment robust enough to host the new distributed systems.

## Considerations

### Success criteria

The Contoso team and CSE team defined the following success criteria for this engagement:

#### General criteria

Contoso Bank considered the following general points as successful criteria on all components:

* Provide the Contoso technical team with the ability to apply digital transformation and cloud adoption. The CSE team:

  * Provided the necessary tools and processes in Azure.

  * Demonstrated how the Contoso technical team could continue using their existing tools.

* Each component would come with a document covering:

  * Scalability and performance tests results.

  * Parameters and metrics considered on each test.

  * Any code or infrastructure change if needed during each test.

  * Lessons learned on performance tweaks, performance tuning, and parameters considered for each test.

  * Lessons learned and guidance on Kafka partitioning strategies.

  * General architecture recommendations/guidance based on the learnings over the deliverables.

#### Deliverables criteria

| Metric | Value (range) |
| ------ | ------------- |
| Ability to run pod autoscaling tests on Channel Holder | Target: The system automatically creates a new Channel Holder pod replica after achieving 50% CPU usage. |
| Ability to run node autoscaling based on Channel Holder | Target: The system creates new Kubernetes nodes because of resource constraints on pods (for example, CPU usage). Kubernetes restricts the number of nodes that the system can create. The node limit is three nodes. |
| Ability to run pod/node autoscaling and performance tests on EFT simulation | Target: The system automatically creates new pod replicas for all services. The replication occurs after achieving 50% CPU usage and the creation of a new Kubernetes node related to CPU resource constraints. The solution must support 2000 transactions per second. |

### Technical solution

The solution provided by the team included cross-cutting concerns and specific implementations to achieve the target deliverables. It also had to adhere to some design constraints based on Contoso Bank's policies.

It's worth noting that because of a feature constraint on Azure Red Hat OpenShift 3.11,  Contoso requested the use of Azure Kubernetes Service for testing node autoscaling scenarios.

There were a number of design constraints that the CSE team had to consider:

* Because of internal requirements, Contoso Bank requested the use of the following technologies:

  * OpenShift 3.11 as the container orchestration platform.

  * Java and Spring Boot for microservice development.

  * Kafka as the event streaming platform with Confluent Schema Registry feature.

* The solution had to be cloud agnostic.

* DevOps and monitoring tools had to be the same ones that Contoso already used in their on-premises development environment.

* The solution couldn't share the source code that Contoso hosts in the on-premises environment to external environments. Contoso policy only allows moving container images from on-premises to Azure.

* Contoso policy restricts the ability for a constant integration (CI) pipeline to work between both on-premises environments and any cloud. Contoso manually deployed all source code hosted in the on-premises environment, as container images, to Azure Container Registry. The deployment on the on-premises side was Contoso's responsibility.

* The simulated scenario for tests had to use a subset of mainframe EFT workloads as a flow reference.

* Contoso Bank had to do all HPA and performance tests on ARO.

### Cross-cutting concerns of the solution

#### Message streaming

The CSE team decided to use Apache Kafka as the distributed message streaming platform for microservices. For better scalability, the team thought about using one consumer group per microservice. In that configuration, each microservice instance is a scale unit to split and parallelize events processing.

They used a formula to calculate the estimated ideal number of partitions per topic to support the estimated throughput. For more information about the formula, see [How to choose the number of topics or partitions in a Kafka cluster](https://www.confluent.io/blog/how-choose-number-topics-partitions-kafka-cluster/).

#### CI/CD velocity

For DevOps, Contoso Bank already used an on-premises instance of GitLab for their code repository. They created continuous integration/continuous delivery (CI/CD) pipelines for development environments using a custom Jenkins-based solution that they developed internally. It wasn't providing an optimal DevOps experience.

To deliver an improved DevOps experience for Contoso, the CSE team used Azure Pipelines on [Azure DevOps](https://azure.microsoft.com/services/devops/) to manage the application lifecycle. The CI pipeline runs on every pull request, while the CD pipeline runs on every successful merge to the main branch. Each member of the development team was responsible for managing the repositories and pipelines for each service. They also  had to enforce code reviews, unit tests and linting (static source code analysis).

The CSE team deployed services concurrently with no interdependency and used Jenkins agents as requested by Contoso Bank.

They incorporated Prometheus as part of the solution to monitor the services and the cluster. Besides generating meaningful data for the solution, Contoso Bank can use Prometheus in the future to enhance the products based on daily usage. A Grafana dashboard displays these metrics.

#### Rollout strategy

The team rolled out the solution to the development environment through Azure Pipelines. Each service had its own build and deployment pipeline. They used a deployment pipeline that can be manually triggered. It should force a full deployment of the environment and the containers in a specific branch version.

The CSE team created release branches that generated stable versions for deployment. Merging branches into the main branch only occurs when the team is sure that they're ready to deploy the solution. A rollback strategy, beyond deploying the previous stable version, was out of scope for this engagement. Approval gates exist for each stage. Each gate requests deployment approval.

#### Disaster recovery

The solution uses Terraform scripts and Azure Pipelines for all the services. If a disaster occurs, Contoso Bank can re-create the entire environment by using Terraform scripts or by running the release pipeline again. Terraform understands that the environment has changed and recreates it. The solution dynamically provisions and destroys the infrastructure on Azure as needed. Storage accounts are zone-redundant storage (ZRS). A backup strategy was out of scope for this engagement.

#### Security and privacy

* A private registry (Azure Container Registry) stored all container images.

* The solution uses ARO and AKS secrets to inject sensitive data into pods, such as connection strings and keys.

* Access to Kubernetes API server require authentication through [Azure Active Directory](https://azure.microsoft.com/services/active-directory/) for ARO and AKS.

* Access to Jenkins requires authentication through Azure Active Directory.

## Conclusions

At the end of the project, the CSE team shared the following insights:

* Solution and engagement outcome

  * The team observed a high level of compatibility between AKS and ARO for services deployment.

  * [Application Insights Codeless](/azure/azure-monitor/app/codeless-overview) makes it easier to create observability, collaborating to the cloud adoption on lift-and-shift migrations.

  * Load testing is an important part of large scale intended solutions and requires previous analysis and planning to consider the microservice specificities.

  * The load testing potential to find microservices side effects is frequently underestimated by customers.

  * Creating a test environment might require an infrastructure disposal strategy to avoid unnecessary infrastructure cost.

* Key learnings

  * There's a smooth application migration from ARO to AKS.

  * The node autoscaling feature wasn't available on Red Hat OpenShift version 3.11, which was the version used during the engagement. As such, the CSE team carried out node autoscaling testing scenarios through AKS.

  * A product's end-of-life might require creative customizations. A preparation phase plays an important role when the team delivers a successful solution.

  * The CSE team recommended the use of the [Cloud Load Testing (CLT)](/rest/api/azure/devops/clt) functionality in [Azure Test Plans](https://azure.microsoft.com/services/devops/test-plans) with Apache JMeter tests. Unfortunately, during the investigation phase, the team identified that the Azure Test Plans team deprecated this functionality. The team had to create a new solution integrating ACI and JMeter in the pipeline.

  * The team recommended the use of the Azure Event Hubs for Kafka, but for Contoso Bank, schema registry was an important feature. To attend to Contoso Bank in the requested time frame, the team had to consider the use of schema registry in another instance of AKS.

  * The Kafka protocol with Schema Registry was not supported by Event Hubs Scaler in KEDA.

## Next steps

* [Load Testing Pipeline with JMeter, ACI, and Terraform](https://github.com/Azure-Samples/jmeter-aci-terraform): GitHub project site

* [Autoscaling Java applications with KEDA using Azure Event Hubs](https://github.com/Azure-Samples/keda-eventhub-kafka-scaler-terraform): KEDA for Java sample

* [Pattern: Saga](https://microservices.io/patterns/data/saga.html): Information about the Saga pattern on Microservices.io

## Related resources

For more detail about the processes and technologies used to create this solution, see the following articles:

* [Patterns and implementations](patterns-and-implementations.yml)

* [JMeter implementation reference for load testing pipeline solution](jmeter-load-testing-pipeline-implementation-reference.yml)
