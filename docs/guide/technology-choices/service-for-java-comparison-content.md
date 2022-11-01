Azure offers many options for teams to build and deploy java applications. This article covers mainstream Java on Azure scenarios and provides high-level planning suggestions and considerations.

*Apache®, [Apache Kafka](https://kafka.apache.org), [Apache Struts](https://struts.apache.org), [Apache Tomcat](https://tomcat.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Platform

Before you select a cloud destination for your Java application, identify its platform type. Most Java applications use one of the following platform types:

- [JAR applications](#jar-applications)
- [Spring Cloud applications](#spring-cloud-applications)
- [Web applications](#web-applications)
- [Java EE applications](#java-ee-applications)

### JAR applications

JAR applications, including Spring Boot applications, are typically invoked directly from the command line. They handle web requests. Instead of relying on an application server to provide HTTP request handling, these applications incorporate HTTP communication and other dependencies directly into the application package. Such applications are frequently built with frameworks such as Spring Boot, Dropwizard, Micronaut, MicroProfile, and Vert.x.

These applications are packaged into archives with the .jar extension, known as JAR files.

### Spring Cloud applications

The microservice architectural style is an approach to developing a single application as a suite of small services. Each service runs in its own process and communicates by using lightweight mechanisms, often an HTTP resource API. These services are built around business capabilities. Automated deployment machinery independently deploys these microservices. There's a bare minimum of centralized management of these services, which might be written in different programming languages and use different data storage technologies. Such services are frequently built with frameworks such as Spring Cloud.

These services are packaged into multiple applications with the .jar extension.

### Web applications

Web applications run inside a servlet container. Some use servlet APIs directly, while many use other frameworks that encapsulate servlet APIs, such as Apache Struts, Spring MVC, JavaServer Faces (JSF), and others.

Web applications are packaged into archives with the .war extension, known as WAR files.

### Java EE applications

Java EE applications can contain some, all, or none of the elements of web applications. They can also contain and consume many more components as defined by the Java EE specification.

Java EE applications can be packaged as archives with the .ear extension (EAR files) or as archives with the .war extension.

Java EE applications must be deployed onto Java EE-compliant application servers, such as WebLogic, WebSphere, WildFly, GlassFish, and Payara.

Applications that rely only on features provided by the Java EE specification can be migrated from one compliant application server onto another. If your application is dependent on a specific application server, you might need to select an Azure service destination that permits you to host that application server.

Java EE applications are also referred to as *J2EE applications* or, more recently, *Jakarta EE applications*.

### Platform options

Use the following table to identify potential destinations for your application type. Azure Kubernetes Service (AKS) and Virtual Machines support all application types, but they require your team to take on more responsibilities, as shown in the next section.

| Destination&nbsp;→<br><br>Platform↓                         | Azure<br>Spring<br>Apps | App<br>Service<br>Java SE | App<br>Service<br>Tomcat | App<br>Service<br>JBoss EAP | Azure Container Apps | AKS          | Virtual<br>Machines |
|-------------------------------------------------------------------|-------------------------|---------------------------|--------------------------|-----------------------------|----------------------|--------------|---------------------|
| Spring Boot / JAR applications                                    | &#x2714;                | &#x2714;                  |                          |                             | &#x2714;             | &#x2714;     | &#x2714;            |
| Spring Cloud applications                                         | &#x2714;                |                           |                          |                             | &#x2714;             | &#x2714;     | &#x2714;            |
| Web applications                                                  | &#x2714;                |                           | &#x2714;                 | &#x2714;                    | &#x2714;             | &#x2714;     | &#x2714;            |
| Java EE applications                                              |                         |                           |                          | &#x2714;                    |                      | &#x2714;     | &#x2714;            |
| Azure region availability                                         | [Details][1]            | [Details][2]              | [Details][2]             | [Details][2]                | [Details][3]         | [Details][4] | [Details][5]        |

## Supportability

Besides the platform choices, modern Java applications might have other supportability needs such as:

- [Batch or scheduled jobs](#batch-or-scheduled-jobs)
- [Virtual network integration](#virtual-network-integration)
- [Serverless](#serverless)
- [Containerization](#containerization)

### Batch or scheduled jobs

Some applications are intended to run briefly, execute a particular workload, and then exit rather than wait for requests or user input. Sometimes such jobs need to run once or at regular, scheduled intervals. On premises, such jobs are often invoked from a server's cron table.

These applications are packaged into archives with the .jar extension.

> [!NOTE]
> If your application uses a scheduler, such as Spring Batch or Quartz, to run scheduled tasks, we strongly recommend that you run those tasks outside of the application. If your application scales to multiple instances in the cloud, the same job can run more than once. Furthermore, if your scheduling mechanism uses the host's local time zone, you might experience undesirable behavior when scaling your application across regions.

### Virtual network integration

When you deploy a java application in your virtual network, it has outbound dependencies on services outside of the virtual network. For management and operational purposes, your project must have access to certain ports and fully qualified domain names. With Azure virtual networks, you can place many of your Azure resources in a non-internet routable network. The VNet Integration feature enables your apps to access resources in or through a virtual network. Virtual network integration doesn't enable your apps to be accessed privately.

### Serverless

Serverless is a cloud-native development model that allows developers to build and run applications without having to manage servers. With serverless applications, the cloud service provider automatically provisions, scales, and manages the infrastructure required to run the code. Servers still exist in the serverless model. They're abstracted away from application development.

### Containerization

Containerization is the packaging together of software code with all its necessary components like libraries, frameworks, and other dependencies. The application is isolated in its own container.

### CI/CD

Continuous integration and continuous delivery (CI/CD) is a method to frequently deliver apps to customers by introducing automation into the stages of app development. The main concepts in CI/CD are continuous integration, continuous delivery, and continuous deployment. All of the Azure choices support most CI/CD tooling. For example, you might use Microsoft solutions such as [Azure Pipelines][6] or other solutions such as [Jenkins][7].

### Open-source search engine

Searches are integral parts of any application. Performing searches on terabytes and petabytes of data can be challenging when speed, performance, and high availability are core requirements. When you host Java applications on Azure, plan to host your related Solr and Elasticsearch instances. Alternatively, consider migrating to Azure Cognitive Search.

### Big data tooling

Big data tools enable the automation of data flowage among the software systems. They support scalable, robust, and streamlined data routing graphs along with system mediation logic. On the other hand, they're utilized to build live data flow pipelines and stream apps. Learn how [Nifi][8] and [Apache Kafka][9] on Azure maybe be suitable for your needs.

### Supportability options

Use the following table to identify potential destinations for your application type. AKS and Virtual Machines support all application types, but they require your team to take on more responsibilities.

| Destination&nbsp;→<br><br>Supportability↓                         | Azure<br>Spring<br>Apps | App<br>Service<br>Java SE | App<br>Service<br>Tomcat | App<br>Service<br>JBoss EAP | Azure Container Apps | AKS          | Virtual<br>Machines |
|-------------------------------------------------------------------|-------------------------|---------------------------|--------------------------|-----------------------------|----------------------|--------------|---------------------|
| Batch or scheduled jobs                                            | &#x2714;                |                           |                          |                             | &#x2714;             | &#x2714;     | &#x2714;            |
| VNet Integration                             | &#x2714;                | &#x2714;                  | &#x2714;                 | &#x2714;                    | &#x2714;             | &#x2714;     | &#x2714;            |
| Serverless                                                        | &#x2714;             |                          |                         |                            | &#x2714;                    | &#x2714;            | &#x2714;                   |
| Containerization                                                  | &#x2714;                | &#x2714;                         | &#x2714;                       |&#x2714;                            | &#x2714;             | &#x2714;            | &#x2714;                   |
| Azure region availability                                         | [Details][1]            | [Details][2]              | [Details][2]             | [Details][2]                | [Details][3]         | [Details][4] | [Details][5]        |

Also, refer to this decision tree.

:::image type="content" source="images/java-application-tree.png" alt-text="Diagram shows a decision tree for Java on Azure services." border="false":::


## Build or migrate Java apps

To build or migrate the Java apps, identify the java platform of your applications. The current popular platforms are Java SE, Jakarta EE, and MicroProfile.

### Java SE

Java Platform, Standard Edition (Java SE) is a computing platform for the development and deployment of portable code for desktop and server environments. Popular projects built on Java SE include Spring Boot, Spring Cloud, Spring Framework, and Tomcat.

### Jakarta EE

Jakarta Enterprise Edition (Jakarta EE, formerly Java EE) is the open source future of cloud native enterprise Java. It's a set of specifications that extend Java SE with specifications for enterprise features such as distributed computing and web services. Jakarta EE applications run reference runtimes. These runtimes can be microservices or application servers. They handle transactions, security, scalability, concurrency, and management of the components the application deploys.

### MicroProfile

The MicroProfile project provides a collection of specifications designed to help developers build Enterprise Java cloud-native microservices. Quarkus and Open Liberty are the most popular implementation of MicroProfile.

### Build or migrate summary

You can use the following table to find build or migration guidance by application type and targeted Azure service destination.

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

- [Hang Wang](https://www.linkedin.com/in/hang-wang-software/) | Product Manager
- [Xinyi Zhang](https://www.linkedin.com/in/xinyi-zhang-3030008/) | Principal PM Manager
- [Asir Vedamuthu Selvasingh](https://www.linkedin.com/in/asir-architect-javaonazure/) | Principal Program Manager

## Next steps

## Related resources

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
