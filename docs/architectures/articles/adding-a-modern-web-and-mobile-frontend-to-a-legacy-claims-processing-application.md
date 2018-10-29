---
title: Lift and Shift and Innovate - LOB Apps 
description: The solution demonstrates modernizing an existing application by consolidating data from multiple business systems into one place and surfacing it through web and mobile frontends. This is targeted at improving employee productivity and to enable faster decision making.
author: adamboeglin
ms.date: 10/29/2018
---
# Lift and Shift and Innovate - LOB Apps 
This line-of-business application solution consolidates data from multiple business systems and surfaces the data through web and mobile front endshelping to improve employee productivity and speed decision making.

## Architecture
<img src="media/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.svg" alt='architecture diagram' />

## Data Flow
1. Customers mobile app authenticates via Azure Active Directory B2C
1. Customers mobile app connects to the back-end web service that aggregates data from different systems using asynchronous connection
1. Web application connects to SQL database
1. Power BI connects to SQL database and SharePoint
1. Logic app pulls data from CRM (Salesforce)
1. Logic app connects to SAP system (on-premises or in the cloud)
1. Employee mobile app connects to the logic app that orchestrates the business process
1. Employee mobile app authenticates via Azure Active Directory

## Components
* Azure [Virtual Machines](http://azure.microsoft.com/services/virtual-machines/) lets you deploy a Windows Server or Linux image in the cloud. You can select images from a marketplace or use your own customized images.
* [Azure SQL Database](http://azure.microsoft.com/services/sql-database/) is a relational database service that lets you rapidly create, extend, and scale relational applications into the cloud.

## Next Steps
* [Running SAP on Azure](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/get-started?toc=%2Fazure%2Fvirtual-machines%2Fwindows%2Fclassic%2Ftoc.json)
* [Running SQL server in Azure](https://docs.microsoft.com/azure/sql-database/sql-database-get-started-portal/)