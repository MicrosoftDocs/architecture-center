---
title: Blockchain Workflow Application
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Explore how blockchain is used to digitize workflows and supply chains across organizations with the Blockchain Workflow Application from Microsoft Azure.
ms.custom: acom-architecture, blockchain, Blockchain Workflow Application, Azure Blockchain, Azure Blockchain Service, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/blockchain-workflow-application/'
ms.service: architecture-center
ms.category:
  - blockchain
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/blockchain-workflow-application.png
---

# Blockchain Workflow Application

[!INCLUDE [header_file](../header.md)]

Businesses use blockchain to digitize workflows they share with other organizations, such as moving physical assets across supply chains. The anatomy of blockchain apps is similar across use cases. Here, we use Azure Blockchain Service as the foundational managed blockchain network and build a consortium application that can ingest signals from relevant user interfaces and communicate ledger data to consuming apps across the consortium.

## Architecture

![Architecture diagram](../media/blockchain-workflow-application.png)
*Download an [SVG](../media/blockchain-workflow-application.svg) of this architecture.*

## Data Flow

1. Relevant apps, devices, and data sources send events or data to a message broker (Azure Service Bus).
1. The distributed ledger technology (DLT) consumer Logic App fetches the data from the Service Bus and sends to transaction builder which builds and signs the transaction.
1. The signed transaction gets routed to Azure Blockchain Service (fully managed Ethereum consortium network) via a ledger-specific Logic App connector.
1. The blockchain data manager captures block and transaction data from configured transaction nodes, decodes events and properties and then sends the data to configured destinations.
1. Message broker sends ledger data to consuming business applications and off-chain database.
1. Information is analyzed and visualized using tools such as Power BI by connecting to off-chain database.

## Components

* [Azure Blockchain Service](https://azure.microsoft.com/services/blockchain-service): Build, govern, and expand consortium blockchain networks
* [Service Bus](https://azure.microsoft.com/services/service-bus): Connect across private and public cloud environments
* [Azure IoT Central](https://azure.microsoft.com/services/iot-central): Accelerate the creation of IoT solutions
* Application Insights: Detect, triage, and diagnose issues in your web apps and services
* [Event Grid](https://azure.microsoft.com/services/event-grid): Get reliable event delivery at massive scale
* [Logic Apps](https://azure.microsoft.com/services/logic-apps): Automate the access and use of data across clouds without writing code
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database): Managed, intelligent SQL in the cloud
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory): Synchronize on-premises directories and enable single sign-on
* [Key Vault](https://azure.microsoft.com/services/key-vault): Safeguard and maintain control of keys and other secrets
* [App Service](https://azure.microsoft.com/services/app-service): Quickly create powerful cloud apps for web and mobile
* [Virtual Network](https://azure.microsoft.com/services/virtual-network): Provision private networks, optionally connect to on-premises datacenters
* [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded): Embed fully interactive, stunning data visualizations in your applications

## Next steps

* [Azure Blockchain documentation](https://docs.microsoft.com/azure/blockchain/service)
* [Service Bus documentation](https://docs.microsoft.com/azure/service-bus)
* [Azure IoT Central documentation](https://docs.microsoft.com/azure/iot-central)
* [Application Insights documentation](https://docs.microsoft.com/azure/azure-monitor/learn/tutorial-runtime-exceptions)
* [Event Grid Documentation](https://docs.microsoft.com/azure/event-grid)
* [Logic Apps Documentation](https://docs.microsoft.com/azure/logic-apps)
* [Azure SQL Database Documentation](https://docs.microsoft.com/azure/sql-database)
* [Azure Active Directory Documentation](https://docs.microsoft.com/azure/active-directory)
* [Key Vault documentation](https://docs.microsoft.com/azure/key-vault)
* [App Service Documentation](https://docs.microsoft.com/azure/app-service)
* [Virtual Network Documentation](https://docs.microsoft.com/azure/virtual-network)
* [Power BI Documentation](https://docs.microsoft.com/azure/power-bi-embedded)
