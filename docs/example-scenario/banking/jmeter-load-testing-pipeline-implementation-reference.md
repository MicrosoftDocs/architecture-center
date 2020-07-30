---
title: JMeter Implementation Reference for Load Testing Pipeline Solution
description: Scalable cloud load testing pipeline creates and destroys infrastructure on-demand for stress testing
author: tmmarshall
ms.date: 6/23/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# JMeter Implementation Reference for Load Testing Pipeline Solution

This paper provides an overview of an implementation for a scalable cloud load testing pipeline that creates and destroys infrastructure on-demand to perform stress testing and enables observation and viewing of test results. This load testing implementation—which has been recently tested in critical use cases such as analysis relating to the Coronavirus pandemic—leverages [Apache JMeter](https://jmeter.apache.org/), an open-source load and performance testing tool, and [Terraform](https://www.terraform.io/) to provision and destroy the required infrastructure from Azure.

## Capabilities

This implementation enables the following capabilities:

* Viewing consolidated data in a dashboard to monitor the scalability and performance of a solution infrastructure.

* The ability to determine the impact of infrastructure scalability and reaction to failures in the existing architectural design and various workloads through a set of simulations, using a synthetic application to input functional scenarios and monitor the performance and scalability of the infrastructure.

* Supports any system that exposes a JMeter supported endpoint (for example, Azure Container Instances (ACI), Azure Kubernetes Service (AKS), and so on), and perform pod/node autoscaling and performance tests on all services. In addition to performing the tests, the implementation supports:

  * Executing performance tests over the microservices until a set number of transactions per second target is reached or surpassed

  * Executing horizontal pod/node autoscaling tests over microservices

  * Providing observability on specific solution component(s) by activating metrics captured (for example, with Prometheus and Grafana)

  * Providing a detailed report about the tests executed, the applications' behavior and the partitioning strategies adopted where applicable (for example, Kafka)

## Advantages

* Full integration with Azure DevOps

* Alternative to other proprietary/deprecating solutions

* Fully open-source

## Solution Overview

### Architecture

The load testing implementation is structured into two Azure Pipelines:

1. One pipeline builds a custom JMeter Docker container and pushes the image to Azure Container Registry (ACR). This structure provides flexibility for adding any JMeter plugin.

1. The other pipeline validates the JMeter test definition (.jmx file), dynamically provisions the load testing infrastructure, runs the load test, publishes the test results and artifacts to Azure DevOps, and then destroys the infrastructure.

:::image type="content" source="./images/Load-testing-pipeline-with-JMeter.png" alt-text="diagram of Load Testing Pipeline with JMeter, ACI, and Terraform":::

<p style="text-align:center;font-style:italic;">Figure 1 - Load Testing Pipeline with JMeter, ACI, and Terraform</p>

The Docker pipeline is created and run first, and then the JMeter pipeline is created.

The flow is triggered and controlled by an Azure Pipeline on Azure DevOps. During setup, JMeter agents are provisioned as ACI instances using the [Remote Testing](https://jmeter.apache.org/usermanual/remote-test.html) approach, where a JMeter controller configures all workers using its own protocol and consolidates all load testing results and generates the resulting artifacts, such as dashboard and logs.

Docker pipeline and JMeter pipeline definition files, which contain branch, path, variable and other settings, are in YAML (.yml) format. Once the pipelines are created, the JMeter pipeline can be run from the command line by defining which JMeter test definition file (.jmx) and the number of JMeter workers required for the test.

To integrate with Azure DevOps test results, a Python script is used to convert the JMeter test results format (.jtl file) to JUnit format (.xml file).

:::image type="content" source="./images/Azure-DevOps-Test-Results-Dashboard.png" alt-text="sample of Azure DevOps Dashboard Displaying Successful Requests":::

<p style="text-align:center;font-style:italic;">Figure 2 - Azure DevOps Dashboard Displaying Successful Requests</p>

### Tech Stack

* Azure DevOps

* Azure Container Registry (ACR)

* Azure Container Instances (ACI)

* Apache JMeter

* Terraform

## Applicable Scenarios

* Any scenario in which there is a need to evaluate the capability of different infrastructure designs / configurations to handle different types of loads.

## Next Steps

* Visit the project page on GitHub: [Load Testing Pipeline with JMeter, ACI, and Terraform](https://github.com/Azure-Samples/jmeter-aci-terraform)

## Additional Reading

* [Technical Whitepaper — Banking System Cloud Transformation on Microsoft Azure](banking-system-cloud-transformation.md)  – describes the use of this load testing pipeline in the Financial Services Industry (FSI)

* [Azure Container Instances (ACI)](https://azure.microsoft.com/services/container-instances/#documentation) – additional documentation and resources on ACI

* [Apache JMeter](https://jmeter.apache.org/)

* [Terraform](https://www.terraform.io/)

* [A Guide to Getting Started with Successful Load Testing (PDF file)](https://www.proxy-sniffer.com/en/doc/LoadTestKnowHowEN.pdf) – Guide from [Apica](https://www.proxy-sniffer.com/)

* [Multilayered Cloud Applications Autoscaling Performance Estimation](https://www.researchgate.net/publication/323791761_Multilayered_Cloud_Applications_Autoscaling_Performance_Estimation) – Conference paper available from ResearchGate