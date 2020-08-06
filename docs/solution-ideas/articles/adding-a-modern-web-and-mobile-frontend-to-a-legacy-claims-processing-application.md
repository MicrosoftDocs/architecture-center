---
title: Adding a mobile front-end to a legacy app
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: The solution demonstrates modernizing an existing application by consolidating data from multiple business systems into one place and surfacing it through web and mobile frontends. This is targeted at improving employee productivity and to enable faster decision making.
ms.custom: acom-architecture, line of business app, lob app, lift and shift cloud strategy, cloud migration, cloud innovation, lift and shift solution, lift and shift strategy, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application/'
ms.service: architecture-center
ms.category:
  - migration
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.png
---

# Lift and Shift and Innovate - Adding a mobile front-end to a legacy app

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This line-of-business application solution consolidates data from multiple business systems and surfaces the data through web and mobile front ends-helping to improve employee productivity and speed decision making.

## Architecture
![Architecture Diagram](../media/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.png)
*Download an [SVG](../media/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.svg) of this architecture.*

## Data Flow

1. Customer's mobile app authenticates via Azure Active Directory B2C
1. Customer's mobile app connects to the back-end web service that aggregates data from different systems using asynchronous connection
1. Web application connects to SQL database
1. Power BI connects to SQL database and SharePoint
1. Logic app pulls data from CRM (Salesforce)'''
1. Logic app connects to SAP system (on-premises or in the cloud)
1. Employee mobile app connects to the logic app that orchestrates the business process
1. Employee mobile app authenticates via Azure Active Directory

## Components''

* Azure [Virtual Machines](https://azure.microsoft.com/services/virtual-machines) lets you deploy a Windows Server or Linux image in the cloud. You can select images from a marketplace or use your own customized images.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a relational database service that lets you rapidly create, extend, and scale relational applications into the cloud.

## Next steps

* [Running SAP on Azure](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/get-started?toc=%2Fazure%2Fvirtual-machines%2Fwindows%2Fclassic%2Ftoc.json)
* [Running SQL server in Azure](https://docs.microsoft.com/azure/sql-database/sql-database-get-started-portal)
