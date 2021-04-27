This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS 3.2.1). 

> This article is part of a series. Read the [prerequisites](aks-pci-prerequisites.yml) here.

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

## AKS cluster configuration

The starting point for the infrastructure is the [AKS baseline reference architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). That infrastructure is modified 
to move away from public cloud access to a private environment with sufficient controls to meet the requirements of the standard. 


Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications. Azure Kubernetes Service (AKS) makes it simple to deploy a managed Kubernetes cluster in Microsoft Azure. Many enterprise customers are leveraging or plan to leverage AKS as the fundemental infrastructure to support large scale applications in cloud. For any payment related, PII related workloads, PCI DSS compliance approval process natually kicks in for enterprise customers to ensure that PCI DSS compliance is followed appropriately.

Responsibility
Customers of Microsoft Azure are ultimately responsible for their own PCI DSS compliance. The following tabs describe the various responsibilities of Microsoft Azure, its customers, and those shared by both to achieve PCI DSS compliance. In all assessments, proper scoping is key to success. For cloud deployments, reading the PCI requirements to understand their intent, and correlating this Responsibility Summary will aid customers in planning ahead for a successful assessment.
"																
																
						The guidance is focused on the infrastructure and _not_ the workload. The starting point for the infrastructure is the AKS baseline secure architecture. That infrastructure is modified to move away from public cloud access to a private enviroment with sufficient controls to meet the requirements of the standard. 										
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																							
