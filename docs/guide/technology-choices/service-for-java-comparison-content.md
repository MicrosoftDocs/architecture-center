---
ms.custom:
  - devx-track-extended-java
---
Azure offers many options for teams to build and deploy Java applications. This article covers mainstream scenarios for Java on Azure and provides high-level planning suggestions and considerations.

*Apache®, [Apache Kafka](https://kafka.apache.org), [Apache Struts](https://struts.apache.org), [Apache Tomcat](https://tomcat.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Platform

Before you select a cloud scenario for your Java application, identify its platform. Most Java applications use one of the following platforms:

- [Spring Boot JAR applications](#spring-boot-jar-applications)
- [Spring Cloud applications](#spring-cloud-applications)
- [Web applications](#web-applications)
- [Jakarta EE applications](#jakarta-ee-applications)

### Spring Boot JAR applications

Spring Boot JAR applications are typically invoked directly from the command line. They handle web requests. Instead of relying on an application server to handle HTTP requests, these applications incorporate HTTP communication and other dependencies directly into the application package. Such applications are often built with frameworks such as [Spring Boot](https://spring.io/projects/spring-boot), [Dropwizard](https://www.dropwizard.io), [Micronaut](https://micronaut.io), [MicroProfile](https://microprofile.io), and [Vert.x](https://vertx.io).

These applications are packaged into archives that have the *.jar* extension, known as JAR files.

### Spring Cloud applications

The *microservice architectural style* is an approach to developing a single application as a suite of small services. Each service runs in its own process and communicates by using lightweight mechanisms, often an HTTP resource API. These services are built around business capabilities.

Automated deployment machinery independently deploys these microservices. There's a minimum of centralized management, which might be written in different programming languages and use different data storage technologies. Such services are often built with frameworks such as [Spring Cloud](https://spring.io/projects/spring-cloud).

These services are packaged into multiple applications as JAR files.

### Web applications

Web applications run inside a servlet container. Some use servlet APIs directly, while others use other frameworks that encapsulate servlet APIs, such as [Apache Struts](https://struts.apache.org), [Spring MVC](https://spring.io), and [JavaServer Faces](https://www.oracle.com/java/technologies/javaserverfaces.html).

Web applications are packaged into archives that have the *.war* extension, known as WAR files.

### Jakarta EE applications

Jakarta Enterprise Edition (Jakarta EE) applications can contain some, all, or none of the elements of web applications. They can also contain and consume many more components, as defined by the Jakarta EE specification. Jakarta EE applications were formerly known as *Java EE applications* or *J2EE applications*.

Jakarta EE applications can be packaged as WAR files or as archives that have the *.ear* extension, known as EAR files.

Jakarta EE applications must be deployed onto application servers that are Jakarta EE compliant. Examples include [WebLogic](https://www.oracle.com/java/weblogic/editions), [WebSphere](https://www.ibm.com/products/websphere-application-server), [WildFly](https://www.wildfly.org), [GlassFish](https://glassfish.org), and [Payara](https://www.payara.org/home).

Applications that rely only on features provided by the Jakarta EE specification can be migrated from one compliant application server onto another. If your application is dependent on a specific application server, you might need to select an Azure service destination that permits you to host that application server.

### Platform options

Use the following table to identify potential platforms for your application type.

|   | Azure Spring Apps | App Service Java SE | App Service Tomcat | App Service JBoss EAP | Azure Container Apps | AKS | Virtual Machines |
|-------------------------------------|----------|---------|---------|----------|----------|------------|----------|
| **Spring Boot / JAR applications**  | &#x2714; | &#x2714; |          | &#x2714; | &#x2714; | &#x2714; | &#x2714; |
| **Spring Cloud applications**       | &#x2714; |          |          |          | &#x2714; | &#x2714; | &#x2714; |
| **Web applications**                | &#x2714; |          | &#x2714; | &#x2714; | &#x2714; | &#x2714; | &#x2714; |
| **Jakarta EE applications**         |          |          |          | &#x2714; |          | &#x2714; | &#x2714; |
| **Azure region availability**       | [Details][1] | [Details][2] | [Details][2] | [Details][2] | [Details][3] | [Details][4] | [Details][5] |

Azure Kubernetes Service (AKS) and Virtual Machines support all application types, but they require that your team to take on more responsibilities, as described in the next section.

## Supportability

Besides the platform choices, modern Java applications might have other supportability needs, such as:

- [Batch or scheduled jobs](#batch-or-scheduled-jobs)
- [Virtual network integration](#virtual-network-integration)
- [Serverless](#serverless-development-model)
- [Containerization](#containerization)

### Batch or scheduled jobs

Instead of waiting for requests or user input, some applications run briefly, run a particular workload, and then exit. Sometimes, such jobs need to run once or at regular, scheduled intervals. On-premises, such jobs are often invoked from a server's cron table.

These applications are packaged as JAR files.

> [!NOTE]
> If your application uses a scheduler, such as Spring Batch or Quartz, to run scheduled tasks, we strongly recommend that you run those tasks outside of the application. If your application scales to multiple instances in the cloud, the same job can run more than once. If your scheduling mechanism uses the host's local time zone, there might be undesired behavior when you scale an application across regions.

### Virtual network integration

When you deploy a Java application in your virtual network, it has outbound dependencies on services outside of the virtual network. For management and operations, your project must have access to certain ports and fully qualified domain names. With Azure Virtual Networks, you can place many of your Azure resources in a non-internet routable network. The *virtual network integration* feature enables your applications to access resources in or through a virtual network. Virtual network integration doesn't enable your applications to be accessed privately.

### Serverless development model

Serverless is a cloud-native development model that allows developers to build and run applications without having to manage servers. With serverless applications, the cloud service provider automatically provisions, scales, and manages the infrastructure required to run the code. Servers still exist in the serverless model. They're abstracted away from application development.

### Containerization

Containerization is the packaging together of software code with all its necessary components, like libraries, frameworks, and other dependencies. The application is isolated in its own container.

### CI/CD

Continuous integration and continuous delivery (CI/CD) is a method to frequently deliver applications to customers by introducing automation into the stages of application development. The main concepts in CI/CD are *continuous integration*, *continuous delivery*, and *continuous deployment*. All of the Azure choices support most CI/CD tooling. For example, you might use solutions such as [Azure Pipelines][6] or [Jenkins][7].

### Open-source search engine

Searches are integral parts of any application. If speed, performance, and high availability are critical, searches on terabytes and petabytes of data can be challenging. When you host Java applications on Azure, plan to host your related Solr and Elasticsearch instances. Alternatively, consider migrating to [Azure Cognitive Search](/azure/search).

### Big data tools

Big data tools enable the automation of data flow among the software systems. They support scalable, robust, and streamlined data routing graphs along with system mediation logic. They're utilized to build live data flow pipelines and stream applications. Learn how [Nifi][8] and [Apache Kafka][9] on Azure might be suitable for your needs.

### Supportability options

Use the following table to identify potential options for your application type. AKS and Virtual Machines support all application types, but they require your team to take on more responsibilities.

|          | Azure Spring Apps | App Service Java SE | App Service Tomcat | App Service JBoss EAP | Azure Container Apps | AKS | Virtual Machines |
|---------------------------------|----------|----------|----------|----------|----------|----------|----------|
| **Batch or scheduled jobs**     | &#x2714; |          |          |          | &#x2714; | &#x2714; | &#x2714; |
| **Virtual network integration** | &#x2714; | &#x2714; | &#x2714; | &#x2714; | &#x2714; | &#x2714; | &#x2714; |
| **Serverless**                  | &#x2714; |          |          |          | &#x2714; | &#x2714; | &#x2714; |
| **Containerization**            | &#x2714; | &#x2714; | &#x2714; | &#x2714; | &#x2714; | &#x2714; | &#x2714; |
| **Azure region availability**   | [Details][1] | [Details][2]  | [Details][2] | [Details][2] | [Details][3] | [Details][4] | [Details][5] |

Also, refer to this decision tree.

:::image type="content" source="images/java-application-tree.png" alt-text="Diagram shows a decision tree for Java on Azure services." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/java-application-tree.vsdx) of this diagram.*

## Build or migrate Java applications

To build or migrate the Java applications, identify the Java platform of your applications. Some popular platforms are [Java SE](#java-se), [Jakarta EE](#jakarta-ee), and [MicroProfile](#microprofile).

### Java SE

Java Platform, Standard Edition (Java SE) is a computing platform for the development and deployment of portable code for desktop and server environments. Popular projects built on Java SE include Spring Boot, Spring Cloud, [Spring Framework](https://spring.io/projects/spring-framework), and [Apache Tomcat](https://tomcat.apache.org).

### Jakarta EE

Jakarta EE is the open source future of cloud-native enterprise Java. It's a set of specifications that extend Java SE with enterprise features such as distributed computing and web services. Jakarta EE applications run reference runtimes. These runtimes can be microservices or application servers. They handle transactions, security, scalability, concurrency, and management of the components the application deploys.

### MicroProfile

The MicroProfile project provides a collection of specifications designed to help developers build Enterprise Java cloud-native microservices. [Quarkus](https://quarkus.io) and [Open Liberty](https://openliberty.io) are popular implementations of MicroProfile.

### Build or migrate summary

The following table provides build or migration information by application type and Azure service.

|                              | Type             | Java SE  | MicroProfile | JarkartaSE |
|------------------------------|------------------|----------|--------------|------------|
| **Virtual Machine**          | IaaS             | &#x2714; | &#x2714;     | &#x2714;   |
| **VMware Tanzu**             | IaaS             | &#x2714; |              |            |
| **Azure Kubernetes Service** | Container        | &#x2714; | &#x2714;     | &#x2714;   |
| **Red Hat OpenShift**        | Container        | &#x2714; | &#x2714;     | &#x2714;   |
| **Azure Container App**      | PaaS             | &#x2714; | &#x2714;     |            |
| **JBoss EAP**                | PaaS App Service | &#x2714; |              | &#x2714;   |
| **Apache Tomcat**            | PaaS App Service | &#x2714; |              |            |
| **Java SE**                  | PaaS App Service | &#x2714; | &#x2714;     |            |
| **Azure Spring Apps**        | PaaS             | &#x2714; |              |            |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Asir Vedamuthu Selvasingh](https://www.linkedin.com/in/asir-architect-javaonazure) | Principal Program Manager
- [Hang Wang](https://www.linkedin.com/in/hang-wang-software) | Product Manager
- [Xinyi Zhang](https://www.linkedin.com/in/xinyi-zhang-3030008) | Principal PM Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Container Apps overview](/azure/container-apps/overview)
- [Azure Kubernetes Service](/azure/aks)
- [Azure Spring Apps documentation](/azure/spring-apps)
- [Azure Virtual network integration](/windows-server-essentials/get-started/azure-virtual-network-integration)
- [Virtual machines in Azure](/azure/virtual-machines)

## Related resources

- [Expose Azure Spring Apps through a reverse proxy](../../reference-architectures/microservices/spring-cloud-reverse-proxy.yml)
- [Java CI/CD using Jenkins and Azure Web Apps](../../solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps.yml)
- [Microservices architecture design](../../microservices/index.yml)
- [Multicloud solutions with the Serverless Framework](../../example-scenario/serverless/serverless-multicloud.yml)
- [Virtual network integrated serverless microservices](../../example-scenario/integrated-multiservices/virtual-network-integration.yml)

<!-- reference links, for use with tables -->
[1]: https://azure.microsoft.com/global-infrastructure/services/?products=spring-apps
[2]: https://azure.microsoft.com/global-infrastructure/services/?products=app-service-linux
[3]: https://azure.microsoft.com/global-infrastructure/services/?products=container-apps
[4]: https://azure.microsoft.com/global-infrastructure/services/?products=kubernetes-service
[5]: https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines
[6]: /azure/devops/pipelines/?view=azure-devops
[7]: /azure/developer/jenkins
[8]: /azure/architecture/example-scenario/data/azure-nifi
[9]: /azure/hdinsight/kafka/apache-kafka-introduction
