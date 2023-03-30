---
title: Open-source scenarios on Azure
description: Review a list of architectures and solutions that use open-source technologies.
author: martinekuan
ms.author: martinek
ms.date: 07/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-netapp-files
  - azure-database-mariadb
  - azure-database-mysql
  - azure-database-postgresql
categories:
  - ai-machine-learning
  - databases
  - hybrid
  - analytics
  - web
  - iot
  - migration 
  - containers
  - integration 
  - media
  - compute
  - devops
  - management-and-governance
  - blockchain
  - storage
  - mobile
  - security
  - networking
  - windows-virtual-desktop
ms.custom:
  - fcp
  - devx-track-terraform
---

# Open-source scenarios on Azure

Microsoft is proud to support open-source projects, initiatives, and foundations and contribute to thousands of open-source communities. By using open-source technologies on Azure, you can run applications your way while optimizing your investments. 

This article provides a summary of architectures and solutions that use Azure together with open-source technologies.

For Apache scenarios, see the dedicated article, [Apache scenarios on Azure](/azure/architecture/guide/apache-scenarios).

## BeeGFS

|Architecture|Summary|Technology focus|
|--|--|--|
|[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure infrastructure as a service (IaaS) by following the architecture and design guidance in an example scenario. BeeGFS can be used for back-end storage.|Media|
|[Run reservoir simulation software on Azure](../example-scenario/infrastructure/reservoir-simulation.yml)|Run OPM Flow reservoir simulation and ResInsight visualization software on an Azure HPC compute cluster and visualization VM. BeeGFS is used as an orchestrated parallel file service.|Compute|

## Chef

|Architecture|Summary|Technology focus|
|--|--|--|
|[Building blocks for autonomous-driving simulation environments](../industries/automotive/building-blocks-autonomous-driving-simulation-environments.yml)|Simulate the behavior of autonomous-driving vehicles. Chef is used to create reusable images that serve as building blocks in the simulation.|Containers|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-baseline.yml)|Build a continuous integration and deployment pipeline for a two-tier .NET web application. In this scenario, you can use Chef to implement infrastructure as code or infrastructure as a service.|DevOps
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)|When you use CI/CD pipelines to automate deployments, apply RBAC not just on the Azure Resource Manager side but also earlier in the process when developers check in code. In this scenario, you can use Chef to implement infrastructure as code.|Management|

## CNCF

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure Arc hybrid management and deployment for Kubernetes clusters](../hybrid/arc-hybrid-kubernetes.yml)|Learn how Azure Arc extends Kubernetes cluster management and configuration across datacenters, edge locations, and multiple cloud environments. This architecture uses CNCF-certified Kubernetes clusters.|Hybrid|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS.|Containers|
|[Multicloud blockchain distributed ledger technology (DLT)](../example-scenario/blockchain/multi-cloud-blockchain.yml)|See how the open-source Blockchain Automation Framework (BAF) and Azure Arc-enabled Kubernetes work with multiparty DLTs to build a cross-cloud blockchain solution. This architecture uses CNCF-certified Kubernetes clusters.|Blockchain|

## Elastic

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to Elasticsearch deployments.|Containers|
|[Choose a search data store](../data-guide/technology-choices/search-options.md)|Learn about the capabilities of search data stores in Azure, including Elasticsearch.|Databases|
|[Elastic Workplace Search on Azure](../solution-ideas/articles/elastic-workplace-search.yml)|Learn how to deploy Elastic Workplace Search to streamline search for your documents and data.|Integration|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)|Learn about the infrastructure and DevOps considerations of deploying and running a microservices architecture on AKS. In this architecture, you can use Elasticsearch for cluster monitoring.|Containers|
|[Monitor a microservices app in AKS](../microservices/logging-monitoring.yml)|Learn best practices for monitoring a microservices application that runs on AKS, including using Elasticsearch.|Containers|
|[Monitoring and diagnostics guidance](../best-practices/monitoring.yml)|Learn about storing instrumentation data by using technologies like Elasticsearch.|Management|
|[Processing free-form text for search](../data-guide/scenarios/search.yml)|Learn how free-form text processing can support search by producing useful, actionable data from large amounts of text. Includes information about using Elasticsearch to create a search index.|Databases|

## GlusterFS

|Architecture|Summary|Technology focus|
|--|--|--|
|[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure IaaS by following the architecture and design guidance in an example scenario. GlusterFS can be used as a storage solution.|Media|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/guide/sap/sap-s4hana)|Review proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability. GlusterFS is implemented for a highly available file share.|SAP|

## Grafana

|Architecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](../guide/data/monitor-apache-nifi-monitofi.yml)|Monitor deployments of Apache NiFi on Azure by using MonitoFi. Grafana is used to display data and send alerts.|Analytics|
|[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Use interactive analytics in Azure Data Explorer. Examine structured, semi-structured, and unstructured data with improvised, interactive, fast queries. Use Grafana to build near real-time analytics dashboards.|Analytics|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Grafana is a core component for providing monitoring and observability in this solution.|Migration|
|[Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster. Grafana is recommended as a platform for logging and metrics.|Containers|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF. Grafana provides a dashboard for application metrics.|Containers|
|[CI/CD pipeline for container-based workloads](../example-scenario/apps/devops-with-aks.yml)|Build a DevOps CI/CD pipeline for a Node.js web app with Jenkins, Azure Container Registry, AKS, Azure Cosmos DB, and Grafana.|Containers|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS. Grafana displays visualization of infrastructure and application metrics.|DevOps|
|[Content Delivery Network analytics](../solution-ideas/articles/content-delivery-network-azure-data-explorer.yml)|View an architecture pattern that demonstrates low-latency high-throughput ingestion for large volumes of Azure Content Delivery Network logs for building near real-time analytics dashboards. Grafana can be used to build the dashboards.|Analytics|
|[Enterprise monitoring with Azure Monitor](../example-scenario/monitoring/enterprise-monitoring.yml)|See an enterprise monitoring solution that uses Azure Monitor to collect and manage data from cloud, on-premises, and hybrid resources. Grafana can be used to build a dashboard for exploring and sharing the data.|DevOps|
|[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)|Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices. Use Grafana to build analytics dashboards.|Analytics|
|[JMeter implementation for a load-testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline. The implementation supports use of Grafana for observability on solution components.|Migration|
|[Long-term security log retention with Azure Data Explorer](../example-scenario/security/security-log-retention-azure-data-explorer.yml)|Store security logs in Azure Data Explorer on a long-term basis. Minimize costs and easily access the data. Use Grafana to build near real-time analytics dashboards.|Analytics|
|[Optimize administration of SQL Server instances in on-premises and multi-cloud environments by using Azure Arc](../hybrid/azure-arc-sql-server.yml)|Learn how to use Azure Arc for management, maintenance, and monitoring of SQL Server instances in on-premises and multicloud environments. Use Grafana dashboards for monitoring.|Databases|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation. Grafana provides monitoring.|SAP|
|[Web application monitoring on Azure](../reference-architectures/app-service-web-app/app-monitoring.yml)|Learn about the monitoring services you can use on Azure by reviewing a reference architecture that uses a dataflow model for use with multiple data sources. Use Azure Monitor Data Source for Grafana to consolidate Azure Monitor and Application Insights metrics.|Web|

## InfluxDB

|Architecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](../guide/data/monitor-apache-nifi-monitofi.yml)|Monitor deployments of Apache NiFi on Azure by using MonitoFi. MonitoFi uses local instances of InfluxDB to provide real-time monitoring and alerts. |Analytics|
|[Monitor a microservices app in AKS](../microservices/logging-monitoring.yml)|Learn best practices for monitoring a microservices application that runs on AKS. Includes information about using InfluxDB for metrics when data rates trigger throttling.|Microservices|

## Jenkins

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to CI systems like Jenkins.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. A custom Jenkins-based solution is used for CI/CD.|Migration|
|[Building blocks for autonomous-driving simulation environments](../industries/automotive/building-blocks-autonomous-driving-simulation-environments.yml)|Simulate the behavior of autonomous-driving vehicles. Jenkins can be used for CI/CD.|Compute|
|[CI/CD pipeline for container-based workloads](../example-scenario/apps/devops-with-aks.yml)|Build a DevOps CI/CD pipeline for a Node.js web app with Jenkins, Azure Container Registry, AKS, Azure Cosmos DB, and Grafana.|Containers|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS.|DevOps|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-baseline.yml)|Build a continuous integration and deployment pipeline for an application. This article focuses on Azure DevOps, but you can use Jenkins as an alternative.|DevOps|
|[DevTest Image Factory](../solution-ideas/articles/dev-test-image-factory.yml)|Create, maintain, and distribute custom images by using Image Factory, an automated image development and management solution in Azure DevTest Labs. Jenkins is used with GitHub for source code control.|DevOps|
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)|When you use CI/CD pipelines to automate deployments, apply RBAC not just on the Azure Resource Manager side but also earlier in the process when developers check in code. This article focuses on Azure DevOps, but you can use Jenkins as an alternative.|Management|
|[Immutable infrastructure CI/CD using Jenkins and Terraform on Azure](../solution-ideas/articles/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview.yml)|When you develop apps, use a continuous integration and continuous deployment (CI/CD) pipeline to automatically push changes to Azure virtual machines.|DevOps|
|[Java CI/CD using Jenkins and Azure Web Apps](../solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps.yml)|Create web apps in Azure App Service. Use the CI/CD pipeline to deliver value to customers faster.|DevOps|
|[MLOps for Python with Azure Machine Learning](../reference-architectures/ai/mlops-python.yml)|Implement a continuous integration (CI), continuous delivery (CD), and retraining pipeline for an AI application by using Azure DevOps and Azure Machine Learning. This solution can be easily adapted for Jenkins.|AI|
|[Run a Jenkins server on Azure](../example-scenario/apps/jenkins.yml)|Learn about the architecture and the considerations to take into account when you install and configure Jenkins.|DevOps|

## Jupyter

|Architecture|Summary|Technology focus|
|--|--|--|
[Automated Jupyter notebooks for diagnostics](../example-scenario/data/automating-diagnostic-jupyter-notebook.yml)|Learn how to automate diagnostic or routine notebooks by using an Azure serverless architecture.|DevOps|
[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Use interactive analytics in Azure Data Explorer. Examine structured, semi-structured, and unstructured data with improvised, interactive, fast queries. Jupyter Notebook is used to connect to Azure Data Explorer. |Analytics|
[Azure Machine Learning decision guide for optimal tool selection](../example-scenario/mlops/aml-decision-tree.yml)|Learn how to choose the best services for building an end-to-end machine learning pipeline. Includes information about using Jupyter Notebook for the experimentation phase.|AI|
[Choose a data analytics and reporting technology](../data-guide/technology-choices/analysis-visualizations-reporting.md)|Evaluate big-data analytics technology options for Azure, including Jupyter Notebook.|Databases|
[Citizen AI with Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|Learn how to use Azure Machine Learning and Power Platform to quickly create a machine learning proof of concept and production version. Azure Machine Learning provides a hosted Jupyter Notebook environment. |AI|
[Data analysis in an Azure industrial IoT analytics solution](../guide/iiot-guidance/iiot-data.yml)|View an Azure industrial IoT (IIoT) analytics solution. Use visualization, data trends, dashboards, schematic views, and Jupyter Notebook.|IoT|
[DevOps for quantum computing](../guide/quantum/devops-for-quantum-computing.yml)|Learn about DevOps requirements for quantum-based apps. You can use Jupyter Notebook to develop quantum components.|DevOps|
[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)|Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices. Analyze data that's stored in Azure Data Explorer by using Jupyter Notebook.|Analytics|
[Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](../example-scenario/mlops/mlops-technical-paper.yml)|Learn how to apply the MLOps maturity model to implement a machine learning solution for predicting product shipping levels. Initial experimental models are developed in Jupyter Notebook. |AI|
[Many models machine learning with Spark](../example-scenario/ai/many-models-machine-learning-azure-spark.yml)|Learn about many models machine learning in Azure. Azure Machine Learning provides a hosted Jupyter Notebook environment.|AI|
[Precision medicine pipeline with genomics](../example-scenario/precision-medicine/genomic-analysis-reporting.yml)|Build a precision medicine pipeline for genomic analysis and reporting. Use Microsoft Genomics for efficient secondary and tertiary analysis. Jupyter Notebook is used to annotate Microsoft Genomics output, merge output files with other data, and analyze data.|Analytics|
[Tune hyperparameters for machine learning models in Python](/azure/architecture/example-scenario/ai/training-python-models)|Learn recommended practices for tuning hyperparameters (training parameters) of scikit-learn and deep-learning machine learning models in Python. A Jupyter widget is used to monitor the progress of hyperparameter tuning runs.|AI|

## KEDA

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure Functions in a hybrid environment](../hybrid/azure-functions-hybrid.yml)|View an architecture that illustrates how to use Azure Functions from on-premises virtual machines. KEDA provides event-driven scale in Kubernetes clusters.|Serverless|
|[AKS in event stream processing](../solution-ideas/articles/serverless-event-processing-aks.yml)|View a serverless event-driven architecture that runs on AKS with a KEDA scaler. The solution ingests and processes a stream of data and writes the results to a database.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. KEDA is used to scale a service that processes funds transfers. |Containers|
|[Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster. In this scenario, you can use KEDA to scale event-driven workloads.|Containers|
|[Integrate Event Hubs with Azure Functions](../serverless/event-hubs-functions/event-hubs-functions.yml)|Learn how to architect, develop, and deploy efficient and scalable code that runs on Azure Functions and responds to Azure Event Hubs events. KEDA scaler for Event Hubs can be used for Kubernetes hosted apps.|Serverless|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud. Includes an architecture for KEDA scaling. |Serverless|

## Kubernetes

|Architecture|Summary|Technology focus|
|--|--|--|
|[Advanced AKS microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)|Learn about a scalable, highly secure  Azure Kubernetes Service (AKS) microservices architecture that builds on recommended AKS microservices baseline architectures and implementations.|Containers|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Azure Arc hybrid management and deployment for Kubernetes clusters](../hybrid/arc-hybrid-kubernetes.yml)|Learn how Azure Arc extends Kubernetes cluster management and configuration across datacenters, edge locations, and multiple cloud environments.|Hybrid|
|[Azure Kubernetes in event stream processing](../solution-ideas/articles/serverless-event-processing-aks.yml)|View a serverless event-driven architecture that runs on AKS with a KEDA scaler. The solution ingests and processes a stream of data and writes the results to a database.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. The solution uses Kubernetes clusters.|Containers|
|[Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster.|Containers|
|[Big data analytics on confidential computing](../example-scenario/confidential/data-analytics-containers-spark-kubernetes-azure-sql.yml)|Use confidential computing on Kubernetes to run big data analytics with Spark inside confidential containers that are protected by Intel Software Guard Extensions.|Analytics|
|[Build a CI/CD pipeline for microservices on Kubernetes](../microservices/ci-cd-kubernetes.yml)|Learn about building a CI/CD pipeline for deploying microservices to AKS.|Microservices|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS.|Containers|
|[Choose a bare-metal Kubernetes-at-the-edge platform option](../operator-guides/aks/choose-bare-metal-kubernetes.yml)|Find the best option for configuring Kubernetes clusters at the edge.|Containers|
|[Choose a Kubernetes-at-the-edge compute option](../operator-guides/aks/choose-kubernetes-edge-compute-option.md)|Learn about trade-offs for various options that are available for extending compute on the edge.|Containers|
|[Choose an Azure multiparty computing service](../guide/technology-choices/multiparty-computing-service.yml)|Decide which multiparty computing services to use for your solution. Includes information about using Kubernetes to manage containers.|Blockchain|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS.|DevOps|
|[Container orchestration for microservices](../microservices/design/orchestration.yml)|Learn how container orchestration makes it easy to manage complex multi-container microservice deployments, scaling, and cluster health. Review options for microservices container orchestration, including AKS.|Microservices|
|[Create a CI/CD pipeline for AI apps using Azure Pipelines, Docker, and Kubernetes](../data-science-process/ci-cd-flask.yml)|Create a continuous integration and continuous delivery pipeline for AI applications by using Docker and Kubernetes.|AI|
|[Employee retention with Databricks and Kubernetes](../example-scenario/ai/employee-retention-databricks-kubernetes.yml)|Learn how to use Kubernetes to build, deploy, and monitor a machine learning model for employee attrition that can be integrated with external applications.|Analytics|
|[GitOps for Azure Kubernetes Service](../example-scenario/gitops-aks/gitops-blueprint-aks.yml)|See a GitOps solution for an AKS cluster. This solution provides full audit capabilities, policy enforcement, and early feedback.|Containers|
|[Helm-based deployments for Apache NiFi](../guide/data/helm-deployments-apache-nifi.yml)|Use Helm charts when you deploy NiFi on AKS. Helm streamlines the process of installing and managing Kubernetes applications.|Analytics|
|[Instant IoT data streaming with AKS](../solution-ideas/articles/aks-iot-data-streaming.yml)|Learn how to ingest and analyze high volumes of IoT data and generate real-time recommendations and insights.|Containers|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)|Learn about the infrastructure and DevOps considerations of deploying and running a microservices architecture on AKS.|Containers|
|[Microservices with AKS and Azure DevOps](../solution-ideas/articles/microservices-with-aks.yml)|Learn how AKS simplifies the deployment and management of microservices-based architecture.|Containers|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud. Includes an architecture for Kubernetes Event-driven Autoscaler (KEDA) scaling.|Serverless|
|[High security DevOps for AKS](../solution-ideas/articles/secure-devops-for-kubernetes.yml)|Implement DevOps with Kubernetes on Azure to balance speed and security and to deliver code faster.|Containers|
|[Use Application Gateway Ingress Controller with a multitenant AKS cluster](../example-scenario/aks-agic/aks-agic.yml)|Learn how to use the Application Gateway Ingress Controller with your AKS cluster to expose microservice-based applications to the internet.|Containers|
|[Use Azure Firewall to help protect an AKS cluster](../example-scenario/aks-firewall/aks-firewall.yml)|Deploy an AKS cluster in a hub-and-spoke network topology by using Terraform and Azure DevOps. Help protect the inbound and outbound traffic by using Azure Firewall.|Containers|

## Lustre

|Architecture|Summary|Technology focus|
|--|--|--|
[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure IaaS by following the architecture and design guidance in an example scenario. Lustre can be used as a storage solution.|Media|
[Run reservoir simulation software on Azure](../example-scenario/infrastructure/reservoir-simulation.yml)|Run OPM Flow reservoir simulation and ResInsight visualization software on an Azure HPC compute cluster and visualization VM. Lustre is used as an orchestrated parallel file service.|Compute|
[SAS on Azure architecture](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. In this scenario, Lustre is a recommended option for permanent storage.|Compute|

## MariaDB

|Architecture|Summary|Technology focus|
|--|--|--|
|[Core startup stack architecture](../example-scenario/startups/core-startup-stack.yml)|Review the components of a simple core startup stack architecture. Azure Database for MariaDB is one recommended relational database.|Startup|
|[Mainframe and midrange data replication to Azure using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)|Use Qlik Replicate to migrate mainframe and midrange systems to the cloud, or to extend such systems with cloud applications. Azure Database for MariaDB is one recommended relational database.|Mainframe|
|[Mainframe file replication and sync on Azure](../solution-ideas/articles/mainframe-azure-file-replication.yml)|Learn about several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and in Azure. Store data in Azure Database for MariaDB.|Mainframe|
|[Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)|Learn how to modernize IBM mainframe and midrange data and see how to use a data-first approach to migrate this data to Azure. Azure Database for MariaDB is one recommended relational database.|Mainframe|
|[Replicate and sync mainframe data in Azure](../reference-architectures/migration/sync-mainframe-data-with-azure.yml)|Replicate data while modernizing mainframe and midrange systems. Sync on-premises data with Azure data during modernization. Azure Database for MariaDB is one recommended relational database.|Mainframe|
|[Scalable and secure WordPress on Azure](../example-scenario/infrastructure/wordpress.yml)|Learn how to use Content Delivery Network and other Azure services to deploy a highly scalable and highly secure installation of WordPress. In this scenario, MariaDB is used as a data store.|Web|
|[Understand data store models](../guide/technology-choices/data-store-overview.md)|Learn about the high-level differences between the various data storage models found in Azure data services. Azure Database for MariaDB is one example of a relational database.|Databases|

## MLflow

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure Machine Learning decision guide for optimal tool selection](../example-scenario/mlops/aml-decision-tree.yml)|Learn how to choose the best services for building an end-to-end machine learning pipeline, from experimentation to deployment. Includes information about using MLflow for tracking and versioning.|AI|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|Improve operations by using Azure Databricks, Delta Lake, and MLflow for data science and machine learning. Develop, train, and deploy machine learning models.|AI|
|[Determine customer lifetime value and churn with Azure AI services](../example-scenario/ai/customer-lifecycle-churn.yml)|Learn how to create a solution for predicting customer lifetime value and churn by using Azure Machine Learning. The solution demonstrates how to use MLflow to track machine learning experiments.|AI|
|[Employee retention with Databricks and Kubernetes](../example-scenario/ai/employee-retention-databricks-kubernetes.yml)|Learn how to use Kubernetes to build, deploy, and monitor a machine learning model for employee attrition that can be integrated with external applications. Includes a proof-of-concept that illustrates how to train an MLflow model for employee attrition on Azure Databricks.|Analytics|
|[Modern analytics architecture with Azure Databricks](../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml)|Create a modern analytics architecture with Azure Databricks, Data Lake Storage, and other Azure services. Unify data, analytics, and AI workloads at any scale. MLflow manages parameter, metric, and machine learning model tracking.|Analytics|
|[Orchestrate MLOps on Azure Databricks using Databricks notebooks](../reference-architectures/ai/orchestrate-mlops-azure-databricks.yml)|Learn about an approach to MLOps that involves running model training and batch scoring on Azure Databricks by using Azure Databricks notebooks for orchestration. MLflow manages the machine learning lifecycle.|AI|
|[Population health management for healthcare](../solution-ideas/articles/population-health-management-for-healthcare.yml)|Use population health management to improve clinical and health outcomes and reduce costs. The Azure Machine Learning native support for MLflow is used to log experiments, store models, and deploy models.|AI|

## Moodle

|Architecture|Summary|Technology focus|
|--|--|--|
[Moodle deployment with Azure NetApp Files](../example-scenario/file-storage/moodle-azure-netapp-files.yml)|Deploy Moodle with Azure NetApp Files for a resilient solution that offers high-throughput, low-latency access to scalable shared storage.|Storage|

## MySQL

|Architecture|Summary|Technology focus|
|--|--|--|
[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run MySQL database workloads.|Containers|
[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS. MySQL is used to store expense reports.|Containers|
[Build web and mobile applications with MySQL and Redis](../solution-ideas/articles/webapps.yml)|Build web and mobile applications with an Azure microservices-based architecture. Use this solution, inspired by PayMe, for e-commerce platforms and more.|Web|
|[Finance management apps with Azure Database for MySQL](../solution-ideas/articles/finance-management-apps-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to store critical data with high security and provide users with high-value analytics and insights on aggregated data.|Databases|
| [Gaming using Azure Database for MySQL](../solution-ideas/articles/gaming-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL for gaming solutions so that databases scale elastically during traffic bursts and deliver low-latency multi-player experiences.|Databases|
|[IBM z/OS online transaction processing on Azure](../example-scenario/mainframe/ibm-zos-online-transaction-processing-azure.yml)|Migrate a z/OS online transaction processing (OLTP) workload to an Azure application that's cost-effective, responsive, scalable, and adaptable. The data layer can include Azure implementations of MySQL databases.|Mainframe|
|[Intelligent apps using Azure Database for MySQL](../solution-ideas/articles/intelligent-apps-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on.|Databases|
|[Java CI/CD using Jenkins and Azure Web Apps](../solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps.yml)|Use App Service to create web apps backed by Azure Database for MySQL. Use the CI/CD pipeline to deliver value to customers faster.|DevOps|
|[Lift and shift to containers with AKS](/azure/cloud-adoption-framework/migrate/)|Migrate existing applications to containers in AKS. Use Open Service Broker for Azure to access databases like Azure Database for MySQL.|Containers|
|[Mainframe file replication and sync on Azure](../solution-ideas/articles/mainframe-azure-file-replication.yml)|Learn about several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and in Azure. Store data in Azure Database for MySQL.|Mainframe|
|[Microservices with AKS](../solution-ideas/articles/microservices-with-aks.yml)|Learn how AKS simplifies the deployment and management of microservices-based architecture. Use Azure Database for MySQL to store and retrieve information used by the microservices.|Containers|
|[Online transaction processing (OLTP)](../data-guide/relational-data/online-transaction-processing.md)|Learn about atomicity, consistency, and other features of OLTP, which manages transactional data and supports querying. Azure Database for MySQL is one Azure data store that meets the requirements for OLTP.|Databases|
|[Retail and e-commerce using Azure Database for MySQL](../solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to build highly secure, scalable e-commerce solutions that meet customer and business demands.|Databases|
|[Scalable apps using Azure Database for MySQL](../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to rapidly build engaging, performant, and scalable cross-platform and native apps for iOS, Android, Windows, or Mac.|Mobile|
|[Security considerations for highly sensitive IaaS apps in Azure](../reference-architectures/n-tier/high-security-iaas.yml)|Learn about VM security, encryption, NSGs, perimeter networks (also known as DMZs), access control, and other security considerations for highly sensitive IaaS and hybrid apps. A common replication scenario for IaaS architectures uses MySQL Replication. |Security|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, MySQL, and Redis components.|Analytics|
|[Understand data store models](../guide/technology-choices/data-store-overview.md)|Learn about the high-level differences between the various data storage models found in Azure data services. Azure Database for MySQL is one example of a relational database.|Databases|

## PostgreSQL

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run PostgreSQL database workloads.|Containers|
|[Azure Database for PostgreSQL intelligent apps](../solution-ideas/articles/intelligent-apps-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on.|Databases|
|[Build a telehealth system on Azure](../example-scenario/apps/telehealth-system.yml)|Learn how to build a telehealth system that connects a professional healthcare organization to its remote patients. Azure Database for PostgreSQL stores user and device-related data.|Databases|
|[Build cloud-native applications](../solution-ideas/articles/cloud-native-apps.yml)|Learn how to build cloud-native applications with Azure Cosmos DB, Azure Database for PostgreSQL, and Azure Cache for Redis.|Containers|
|[Data cache](../solution-ideas/articles/data-cache-with-redis-cache.yml)|Store and share database query results, session states, static contents, and more by using a common cache-aside pattern. This solution works with data stored in Azure Database for PostgreSQL and other databases.|Databases|
|[Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml)|Use AKS to easily ingest and process a real-time data stream with millions of data points collected via sensors. Processed data is stored in Azure Database for PostgreSQL.|Containers|
|[Finance management apps using Azure Database for PostgreSQL](../solution-ideas/articles/finance-management-apps-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to store critical data with high security and provide users with high-value analytics and insights on aggregated data.|Databases|
|[Geospatial data processing and analytics](../example-scenario/data/geospatial-data-processing-analytics-azure.yml)|Collect, process, and store geospatial data by using managed Azure services. Make the data available through web apps. Visualize, explore, and analyze the data. In this solution, Azure Database for PostgreSQL stores GIS data.|Analytics|
|[IBM z/OS online transaction processing on Azure](../example-scenario/mainframe/ibm-zos-online-transaction-processing-azure.yml)|Migrate a z/OS OLTP workload to an Azure application that's cost-effective, responsive, scalable, and adaptable. The data layer can include Azure Database for PostgreSQL.|Mainframe|
|[Integrate IBM mainframe and midrange message queues with Azure](../example-scenario/mainframe/integrate-ibm-message-queues-azure.yml)|Learn about a data-first approach to middleware integration that enables IBM message queues. This approach supports Azure Database for PostgreSQL.|Mainframe|
|[Mainframe file replication and sync on Azure](../solution-ideas/articles/mainframe-azure-file-replication.yml)|Learn about several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and in Azure. PostgreSQL is the main database for a common AIML use case. |Mainframe|
|[Online transaction processing (OLTP)](../data-guide/relational-data/online-transaction-processing.md)|Learn about atomicity, consistency, and other features of OLTP, which manages transactional data and supports querying. Azure Database for PostgreSQL is one Azure data store that meets the requirements for OLTP.|Databases|
|[Oracle database migration: Refactor](../example-scenario/oracle-migrate/oracle-migration-refactor.yml)|Refactor your Oracle database by using Azure Database Migration Service, and move it to PostgreSQL.|Migration|
|[Overview of Oracle database migration](../example-scenario/oracle-migrate/oracle-migration-overview.yml)|Learn about Oracle database migration paths and the methods you can use to migrate your schema to SQL or PostgreSQL.|Migration|
|[Retail and e-commerce using Azure Database for PostgreSQL](../solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to build highly secure and scalable e-commerce solutions that meet customer and business demands.|Databases|
|[Scalable apps using Azure Database for PostgreSQL](../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to rapidly build engaging, performant, and scalable cross-platform and native apps for iOS, Android, Windows, or Mac.|Mobile|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|
|[Understand data store models](../guide/technology-choices/data-store-overview.md)|Learn about the high-level differences between the various data storage models found in Azure data services. Azure Database for PostgreSQL is one example of a relational database.|Databases|
|[Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](../example-scenario/mainframe/lzlabs-software-defined-mainframe-in-azure.yml)|Learn an approach for rehosting mainframe legacy applications in Azure by using the LzLabs SDM platform. This architecture uses PostgreSQL IaaS. |Mainframe|

## Prometheus

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. Astra Trident provides a rich set of Prometheus metrics that you can use to monitor provisioned storage.|Containers|
|[Architecture of an AKS regulated cluster for PCI-DSS 3.2.1](../reference-architectures/containers/aks-pci/aks-pci-ra-code-assets.yml)|Learn about an architecture for an AKS cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard. Prometheus metrics are used in monitoring.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Prometheus is a core component for monitoring test results.|Migration|
|[Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster. Azure Monitor, the recommended monitoring tool, can be used to visualize Prometheus metrics.|Containers|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF. Prometheus captures application metrics. |Containers|
|[JMeter implementation for a load-testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline. The implementation supports use of Prometheus for observability on solution components. |Migration|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)|Learn about the infrastructure and DevOps considerations of deploying and running a microservices architecture on AKS. Prometheus can be used for cluster monitoring.|Containers|
|[Monitor a microservices app in AKS](../microservices/logging-monitoring.yml)|Learn best practices for monitoring a microservices application that runs on AKS. Includes information about using Prometheus for metrics when data rates trigger throttling.|Containers|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation. Prometheus provides monitoring. |SAP|

## PyTorch

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run AI and machine learning components like PyTorch.|Containers|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|Improve operations by using Azure Databricks, Delta Lake, and MLflow for data science and machine learning. Azure Databricks uses pre-installed, optimized machine learning frameworks, including PyTorch. |AI|
|[Machine learning in IoT Edge vision](../guide/iot-edge-vision/machine-learning.yml)|Learn about machine learning data and models in Azure IoT Edge vision AI solutions. Includes information about PyTorch.|IoT|
|[Real-time scoring of machine learning models](../reference-architectures/ai/real-time-scoring-machine-learning-models.yml)|Deploy Python machine learning models as web services to make real-time predictions by using Azure Machine Learning and AKS. Learn about an image classification scenario that uses PyTorch.|AI|

## RabbitMQ

|Architecture|Summary|Technology focus|
|--|--|--|
[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)|Learn about an end-to-end approach for an automotive original equipment manufacturer (OEM). Includes a reference architecture and several published open-source libraries that you can reuse. RabbitMQ is used as a message broker. |Web|
[Publisher-Subscriber pattern](../patterns/publisher-subscriber.yml)|Learn about the Publisher-Subscriber pattern, which enables an application to announce events to many interested consumers asynchronously. RabbitMQ is recommended for messaging.|Integration|

## Red Hat

|Architecture|Summary|Technology focus|
|--|--|--|
|[AIX UNIX on-premises to Azure Linux migration](../example-scenario/unix-migration/migrate-aix-azure-linux.yml)|Migrate an on-premises IBM AIX system and web application to a highly available, highly secure Red Hat Enterprise Linux solution in Azure.|Mainframe|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Azure Red Hat OpenShift is used for autoscaling tests. |Containers|
|[Container orchestration for microservices](../microservices/design/orchestration.yml)|Learn how container orchestration makes it easy to manage complex multi-container microservice deployments, scaling, and cluster health. Review options for microservices container orchestration, including Azure Red Hat OpenShift.|Microservices|
|[JBoss deployment with Red Hat on Azure](../solution-ideas/articles/jboss-deployment-red-hat.yml)|Learn how the Red Hat JBoss Enterprise Application Platform (JBoss EAP) streamlines and simplifies the development and deployment of a range of applications.|Containers|
|[Run a Linux VM on Azure](../reference-architectures/n-tier/linux-vm.yml)|Learn best practices for running a Linux virtual machine on Azure. Azure supports many popular Linux distributions, including Red Hat Enterprise.|Compute|
|[SAP HANA for Linux VMs in scale-up systems](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml)|Learn proven practices for running SAP HANA in a high-availability, scale-up environment that supports disaster recovery. Use Red Hat Enterprise Linux in multi-node configurations. For high availability, use a Pacemaker cluster on Red Hat Enterprise Linux. |SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/guide/sap/sap-s4hana)|Learn proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability. Red Hat Enterprise Linux is used for a high availability SAP Central Services cluster.|SAP|
|[SAS on Azure](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. SAS supports Red Hat 7 and later.|Compute|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect](../example-scenario/finance/swift-alliance-messaging-hub.yml)|Run SWIFT AMH on Azure. This messaging solution helps financial institutions securely and efficiently bring new services to market. A key component, the AMH node, runs on JBoss Enterprise Application Platform (EAP) on Red Hat Enterprise Linux. |Networking|
|[SWIFT\'s AMH with Alliance Connect Virtual](../example-scenario/finance/swift-alliance-messaging-hub-vsrx.yml)|Run SWIFT AMH on Azure. Use this messaging solution with the Alliance Connect Virtual networking solution, which also runs on Azure. A key component, the AMH node, runs on JBoss EAP on Red Hat Enterprise Linux. |Networking|

## Redis

|Architecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Azure Cache for Redis is used in a Publish-Subscribe messaging pattern for bank transactions. |Containers|
|[Build cloud-native applications](../solution-ideas/articles/cloud-native-apps.yml)|Learn how to build cloud-native applications with Azure Cosmos DB, Azure Database for PostgreSQL, and Azure Cache for Redis.|Containers|
|[Build web and mobile applications with MySQL and Redis](../solution-ideas/articles/webapps.yml)|Build web and mobile applications with an Azure microservices-based architecture. Use this solution, inspired by PayMe, for e-commerce platforms and more.|Web|
|[COVID-19 safe solutions with IoT Edge](../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)|Create a COVID-19 safe environment that monitors social distance, mask/PPE use, and occupancy requirements with CCTVs and Azure IoT Edge, Azure Stream Analytics, and Azure Machine Learning. Redis is used to store cloud data for analytics and visualization.|IoT|
|[Data cache](../solution-ideas/articles/data-cache-with-redis-cache.yml)| Azure Cache for Redis provides a cost-effective solution to scale read and write throughput of your data tier. Store and share database query results, session states, static contents, and more by using a common cache-aside pattern.|Databases|
|[Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml)|Use AKS to easily ingest and process a real-time data stream with millions of data points collected via sensors. Azure Cache for Redis is used to cache processed data.|Containers|
|[DevTest and DevOps for PaaS solutions](../solution-ideas/articles/dev-test-paas.yml)|Combine Azure platform as a service (PaaS) resources with DevTest and DevOps practices to support rapid iteration cycles and reduced overhead. Azure Cache for Redis provides an in-memory data store that's provisioned by Terraform.|DevOps|
|[Messaging](../solution-ideas/articles/messaging.yml)|Learn how Azure Cache for Redis routes real-time messages in publish and subscribe systems.|Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml)|Learn about non-relational databases that store data as key-value pairs, graphs, time series, objects, and other storage models, based on data requirements. Azure Cache for Redis can be used to store key-value pairs.|Databases|
|[Personalized offers](../solution-ideas/articles/personalized-offers.yml)|Build intelligent marketing systems that provide customer-tailored content by using machine learning models that analyze data from multiple sources. Azure Cache for Redis is used to provide pre-computed product affinities for customers.|AI|
|[Publisher-Subscriber pattern](../patterns/publisher-subscriber.yml)|Learn about the Publisher-Subscriber pattern, which enables an application to announce events to many interested consumers asynchronously. In this pattern, Redis can be used for messaging.|Integration|
|[Rate Limiting pattern](../patterns/rate-limiting-pattern.yml)|Use a rate limiting pattern to avoid or minimize throttling errors. In this scenario, you can use Redis/Redsync to create a system that grants temporary leases to capacity.|Integration|
|[Re-engineer mainframe batch applications on Azure](../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)|Use Azure services to re-engineer mainframe batch applications. This architecture change can reduce costs and improve scalability. You can use Azure Cache for Redis to speed up a re-engineered application.|Mainframe|
|[Scalable Sitecore marketing website](../solution-ideas/articles/digital-marketing-sitecore.yml)|Learn how the Sitecore Experience Platform (XP) provides the data, integrated tools, and automation you need to engage customers throughout an iterative lifecycle. In this solution, Sitecore's session state is managed by Azure Cache for Redis.|Web|
|[Scalable web apps with Azure Redis Cache](/azure/architecture/reference-architectures/app-service-web-app/scalable-web-app)|Improve app performance by using Azure Cache for Redis to improve responsiveness and handle increasing loads with fewer web-compute resources.|Web|
|[Scalable web application](../reference-architectures/app-service-web-app/scalable-web-app.yml)|Use the proven practices in this reference architecture to improve scalability and performance in an Azure App Service web application. Semi-static data is stored in Azure Cache for Redis.|Web|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|

## SUSE

|Architecture|Summary|Technology focus|
|--|--|--|
|[Run SAP BW/4HANA with Linux VMs](../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml)|Learn about the SAP BW/4HANA application tier and how it's suitable for a high availability, small-scale production environment of SAP BW/4HANA on Azure. Azure is certified to run SAP BW/4HANA on SUSE Linux Enterprise.|SAP|
|[SAP deployment in Azure using an Oracle database](../example-scenario/apps/sap-production.yml)|Learn proven practices for running SAP on Oracle in Azure, with high availability. In this architecture, SUSE SBD can be used as part of a mechanism to automate failovers. |SAP|
|[SAP HANA for Linux VMs in scale-up systems](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml)|Learn proven practices for running SAP HANA in a high availability, scale-up environment that supports disaster recovery on Azure. For high availability, use a Pacemaker cluster on SUSE Linux Enterprise Server. |SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/guide/sap/sap-s4hana)|Review proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability. SUSE Linux Enterprise Server is used for a high availability SAP Central Services cluster.|SAP|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation.|SAP|
|[SAS on Azure architecture](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. SAS supports SUSE Linux Enterprise Server (SLES) 12.2.|Compute|

## TensorFlow

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run AI and machine learning components like TensorFlow.|Containers|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|Improve operations by using Databricks, Delta Lake, and MLflow for data science and machine learning. Develop, train, and deploy machine learning models. Azure Databricks uses pre-installed, optimized machine learning frameworks, including TensorFlow.|AI|
|[Distributed training, deep learning models](../reference-architectures/ai/training-deep-learning.yml)|Learn how to conduct distributed training of deep learning models across clusters of GPU-enabled VMs. In this scenario, TensorFlow is used to train a CNN model.|AI|
|[Machine learning in IoT Edge vision](../guide/iot-edge-vision/machine-learning.yml)|Learn about machine learning data and models in Azure IoT Edge vision AI solutions. Includes information about TensorFlow.|IoT|
|[Real-time scoring of machine learning models](../reference-architectures/ai/real-time-scoring-machine-learning-models.yml)|Deploy Python machine learning models as web services to make real-time predictions by using Azure Machine Learning and AKS. Learn about an image classification scenario that uses TensorFlow.|AI|
|[Vision classifier model with Azure Cognitive Services Custom Vision](../example-scenario/dronerescue/vision-classifier-model-with-custom-vision.yml)|Create an image classifier with a solution architecture that includes Microsoft AirSim Drones simulator, Azure Cognitive Services Custom Vision, and TensorFlow.|AI|

## Terraform

|Architecture|Summary|Technology focus|
|--|--|--|
|[Architectural approaches for the deployment and configuration of multitenant solutions](../guide/multitenant/approaches/deployment-configuration.yml)|Learn about approaches to consider when you deploy and configure a multitenant solution. Terraform is recommended for automation.|Multitenancy|
|[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)|Learn about an end-to-end approach for an automotive original equipment manufacturer (OEM). Includes a reference architecture and several published open-source libraries that you can reuse. Terraform is used to deploy Azure instances. |Web|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Terraform is used for load testing.|Migration|
|[Deployment Stamps pattern](../patterns/deployment-stamp.yml)|Learn about the Deployment Stamps pattern, which deploys many independent copies of application components. Terraform is recommended for deployment.|Networking|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-baseline.yml)|Build a continuous integration and deployment pipeline for an application. In this architecture, Terraform can be used for deployment.|DevOps|
|[DevOps in a hybrid environment](../solution-ideas/articles/devops-in-a-hybrid-environment.yml)|Learn about an implementation of DevOps that manages cloud and on-premises environments in tandem. Terraform is used to manage infrastructure as code.|DevOps|
|[DevSecOps on AKS](../guide/devsecops/devsecops-on-aks.yml)|Learn about DevSecOps, a solution that incorporates security best practices from the beginning of development. Terraform is used to manage infrastructure as code.|DevOps|
|[DevTest and DevOps for PaaS solutions](../solution-ideas/articles/dev-test-paas.yml)|Combine Azure PaaS resources with DevTest and DevOps practices to support rapid iteration cycles and reduced overhead. Terraform provisions and modifies resources for the environments.|DevOps|
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)|When you use CI/CD pipelines to automate deployments, apply RBAC not just on the Azure Resource Manager side but also earlier in the process when developers check in code. The scenario described uses Terraform for infrastructure as code.|Management|
|[Gridwich cloud media system](../reference-architectures/media-services/gridwich-architecture.yml)|Learn about a stateless action execution workflow that ingests, processes, and delivers media assets using Terraform Sandwiches and Event Grid Sandwiches.|Media|
|[Gridwich CI/CD pipeline](../reference-architectures/media-services/gridwich-cicd.yml)|Learn about the guiding principles and considerations for the Gridwich continuous CD/CD pipeline, including information about Terraform.|Media|
|[Gridwich keys and secrets management](../reference-architectures/media-services/maintain-keys.yml)|Learn about the two types of keys Gridwich uses, and logic apps that add, change, or rotate the keys. Terraform is used in an app that rotates or adds third-party keys.|Media|
|[Gridwich Media Services setup and scaling](../reference-architectures/media-services/media-services-setup-scale.yml)|Learn how Gridwich uses Azure Media Services V2 and V3 APIs to set up authentication and authorization, and how to scale Media Services resources for media processing. A Terraform file is used in the authentication and authorization process.|Media|
|[Gridwich pipeline-generated admin scripts](../reference-architectures/media-services/run-admin-scripts.yml)|Learn about Gridwich pipeline-generated admin scripts and how to run them. The pipelines use Terraform to generate and publish the scripts. |Media
|[Gridwich variable flow](../reference-architectures/media-services/variable-group-terraform-flow.yml)|Learn how Gridwich converts Azure Pipelines pipeline variable group variables to Terraform variables.|Media|
|[Immutable infrastructure CI/CD using Jenkins and Terraform on Azure](../solution-ideas/articles/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview.yml)|When you develop apps, use a continuous integration and continuous deployment (CI/CD) pipeline to automatically push changes to Azure virtual machines.|DevOps|
|[JMeter implementation for a load-testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline. The implementation uses JMeter and Terraform to provision and remove the required infrastructure.|Migration|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation. Terraform is used to deploy the SAP infrastructure into Azure.|SAP|
|[Use Azure Firewall to help protect an AKS cluster](../example-scenario/aks-firewall/aks-firewall.yml)|Deploy an AKS cluster in a hub-and-spoke network topology by using Terraform and Azure DevOps. Help protect inbound and outbound traffic by using Azure Firewall.|Containers|
|[Virtual network integrated serverless microservices](../example-scenario/integrated-multiservices/virtual-network-integration.yml)|Learn about an end-to-end solution for health records management that uses Azure Functions microservices integrated with other services via a virtual network. Terrraform automates all code and infrastructure deployments.|Security|

## Umbraco

|Architecture|Summary|Technology focus|
|--|--|--|
|[Scalable Umbraco CMS web app](../solution-ideas/articles/medium-umbraco-web-app.yml)|Run an Umbraco content management system on the Web Apps feature of App Service. Use Azure managed services for a high availability environment.|Web|
|[Simple digital marketing website](../solution-ideas/articles/digital-marketing-smb.yml)|Use an Azure-based content management system to easily maintain messaging on your website in real time, from a browser, with no coding skills. Umbraco manages content and deploys it to the website.|Web|

## WordPress

|Architecture|Summary|Technology focus|
|--|--|--|
|[Scalable and secure WordPress on Azure](../example-scenario/infrastructure/wordpress.yml)|Learn how to use Azure Content Delivery Network and other Azure services to deploy a highly scalable and highly secure installation of WordPress.|Web|

## Related resources

- [Microsoft partner and non-open-source third-party scenarios on Azure](../guide/partner-scenarios.md)
- [Scenarios featuring Microsoft on-premises technologies](../guide/on-premises-microsoft-technologies.md)
- [Architecture for startups](../guide/startups/startup-architecture.md)
- [Azure and Power Platform scenarios](../solutions/power-platform-scenarios.md)
- [Azure and Microsoft 365 scenarios](../solutions/microsoft-365-scenarios.md)
- [Azure and Dynamics 365 scenarios](../solutions/dynamics-365-scenarios.md)
- [Azure for AWS professionals](../aws-professional/index.md)
- [Azure for Google Cloud professionals](../gcp-professional/index.md)
