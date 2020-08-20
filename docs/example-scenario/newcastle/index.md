---
title: Virtual network integrated serverless microservices
titleSuffix: Azure Example Scenarios
description: This reference architecture is an end-to-end sample derived from a customer engagement. It is an example of a microservices architecture, built using Azure Functions that can integrate with other services residing in a vnet. 
author: hannesne
ms.date: 08/18/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Serverless microservices integrated security and deployment

This article describes an Azure serverless microservices scenario that securely creates and stores patients' medical test results. For auditing purposes, the system also records all operations and interactions with patient data in an audit register.

Internal and third-party systems interface with the data via an application programming interface (API) that allows reading and writing the data. The API is publicly accessible only through a single managed endpoint. Access to the API is managed by [Azure API Management (APIM)](https://azure.microsoft.com/services/api-management/) to allow for easy integration with different authentication mechanisms.

The core of the solution is a set of microservices deployed together in an [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/). The solution architecture has one APIM instance, two [Azure Functions](https://azure.microsoft.com/services/functions/) function apps, one [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) database instance, and associated keys, secrets, and connection strings stored in [Azure Key Vault](https://azure.microsoft.com/services/key-vault/).

The **PatientTests API** service provides the *create, read, update, delete (CRUD)* operations for patients and their test results. The **Audit API** function app provides operations to create auditing entries. Both services store data in Cosmos DB, using the [MongoDB Node.JS Driver](https://mongodb.github.io/node-mongodb-native/). You can replace the Cosmos DB endpoint with another MongoDB service without changing the code. The services don't share data, and you can deploy each service to its own independent database.

To avoid exposing APIs and functions publicly, services integrate with other designated services within a *virtual network*. Network access restrictions limit API and function access to only specific IP addresses. Both API Management and Azure Functions support access restriction and deployment in virtual networks. The current scenario uses network access restriction and virtual network deployment for the two serverless function apps, but not for APIM. The organization wants to expose the APIM endpoint publicly to allow clients to test it from anywhere.

This article and the referenced code project distill the example scenario down to the main technical components, to serve as a scaffold for future work. The solution automates all code and infrastructure deployments.

The example scenario features:

- Interdependent Azure Functions microservices and networking lockdown in a virtual network
- Azure Key Vault key, secret, and connection string management
- Azure Cosmos DB database access using the MongoDB API
- Distributed telemetry using Application Insights in Azure Monitor
- Load testing using Locust
- *Infrastructure-as-Code (IaC)* management and deployment with Terraform

## Use cases

- Apps with high security requirements that require access from a designated external endpoint
- Interdependent microservices apps that need to be integrated with common security mechanisms

## Architecture

![Diagram showing virtual network integrated microservices](./media/vnet-microservices1.png)

1. Outside services and clients make a POST request to **Patient API** in API Management, with a data body that includes patient information.
1. Since **Patient API** uses the **PatientTests API** function app as its backend, it calls the `CreatePatient` function in the **PatientTests API** function app with the given patient information.
1. The `CreatePatient` function in **PatientTests** API calls the `CreateAuditRecord` function in the **Audit API** function app to create an audit record.
1. The `CreateAuditRecord` function creates the audit record in Cosmos DB, and returns a success response to the `CreatePatient` function.
1. The `CreatePatient` function creates a patient document in Cosmos DB, and returns a success response to API Management.
1. The outside services and clients receive the success response from API Management.
1. Telemetry, Application Insights in Azure Monitor.

## Components

The serverless microservices solution uses the following components:

### API Management

Only the API Management instance is accessible from the public internet.


### Azure Virtual Network

The **Audit API** is locked down and configured to be accessible at a network level only from other services in the known subnet in the same virtual network. The **PatientTests API** is locked down to  be accessible only from known IP addresses assigned to API Management. The APIs reject traffic from other sources.

### Key Vault

In this solution, in addition to network-level security, the function apps require service keys for access. The keys are maintained in Azure Key Vault along with other sensitive data like the Azure Cosmos DB connection strings, and are only available to specified identities.

Although it's technically possible to keep host keys and connection strings in the application settings, it's not good practice. The keys and connection string are then exposed to all developers who can access the app. The best practice is keeping sensitive information like the host keys and connection strings in Key Vault, especially for the production environment.

The following components use a Managed Service Identity (MSI), which is granted the following GET secret permissions:
- The **Patient API** app in API Management gets the host key of the **PatientTests API** function app. An advanced API Management inbound policy caches the key for better performance. For subsequent attempts, API Management looks for the key in its cache first.
- The **PatientTests API** function app gets the **Audit API** function app host key and the Cosmos DB connection string.
- The **Audit API** function app gets the Cosmos DB connection string.

Keys are also automatically rotated to make the system more secure.

More information on the security aspects can be found here. More information about key rotation can be found here.

### Azure Functions

The APIs are built on Azure Functions using Typescript. Both the **PatientTests API** and the **Audit API** have a full suite of automated integration and unit tests to help prevent regressions when changes are made. The project is also configured for *linting* using ESLint, to maintain code styles and help guard against unintentional errors.

The services' respective readme's contain information on how to run the tests and linting.

The source code for this sample may be found [here](https://github.com/Azure-Samples/project-newcastle/). The [PatientTests API](https://github.com/Azure-Samples/project-newcastle/blob/master/src/PatientTestsApi/readme.md) and the [Audit API](https://github.com/Azure-Samples/project-newcastle/blob/master/src/AuditApi/readme.md) may be found in the `/src` folder. The API's source includes a [dev container](https://code.visualstudio.com/docs/remote/containers), which will have all the prerequisites installed, to help you get going quicker.

The function apps are protected using service keys in the Azure Functions runtime. These keys are stored in Azure Key Vault and only available to specified identities.

### Application Insights
A common issue in microservices based architectures is that failures can be caused by circumstances distributed over a variety of components, so can't be diagnosed when looking at components in isolation. The ability to correlate the telemetry for an operation across components becomes vital to diagnose certain issues.

This solution uses Application Insights telemetry to centralize logging across the whole request pipeline, including API Management and the APIs running on Azure Functions. API Management and the Azure Functions runtime have built-in support for Application Insights to generate and correlate a wide variety of telemetry, including standard application output. The telemetry shares a common operation ID, allowing it to be correlated across these components. 

More information about this distributed telemetry tracing can be found [here](https://github.com/Azure-Samples/project-newcastle/blob/master/docs/distributed_telemetry.md). The Application Insights Nodejs SDK is used in the Function apps to manually track dependencies and other custom telemetry.

The telemetry sent to Application Insights can feed into a wider Azure Monitor workspace. Components such as Cosmos DB can send telemetry to Azure Monitor, where it can be correlated with telemetry from Application Insights.

## Locust load testing

Assuming API performance is one of your concerns, you may want to use some tools to run load testing against your APIs.
The project contains a [Locust load test](https://github.com/Azure-Samples/project-newcastle/blob/master/src/LoadTest/README.md) in the `/src/LoadTest` folder. [Locust](https://locust.io/) is an open-source load testing tool, and the tests are written in Python. The load tests can be run locally and remotely in AKS cluster. The tests will perform a variety of operations against the API Management endpoint, verifying behaviors against success and failure expectations.

### Terraform
We used Terraform to provision all resources and configurations, including the networking lockdown and the security pattern for access keys. You can use the Terraform templates in the /env folder to deploy and configure this solution in your own Azure environment. Terraform deploys API Management and the Function apps and configures them to use the deployed Application Insights instance. The complete code can be found in the /env folder.

## Deployment

This reference architecture includes scripts for deployment using Terraform. The Terraform templates and code are available in the `/env` folder. The deployment [readme](https://github.com/Azure-Samples/project-newcastle/blob/master/env/readme.md) explains how to deploy the environment in your own Azure subscription. You can also automate deployment with a system like Azure DevOps or GitHub Actions. The `/env` folder also includes a [dev container](https://code.visualstudio.com/docs/remote/containers).

