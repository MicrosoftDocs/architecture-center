[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea helps to improve employee productivity and speed decision making by giving legacy processing applications a modern day front end. This line-of-business application solution consolidates data from multiple business systems. It then presents the data in web and mobile front ends.

## Potential use cases

Organizations that want to connect disparate legacy systems and give users access through a mobile UI can benefit from this solution. Legacy systems include:

* Sales order entry and inventory systems.
* Hospital databases.
* Insurance billing and claims software.
* Banking systems.

## Architecture

![Architecture Diagram](../media/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.png)
*Download an [SVG](../media/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.svg) of this architecture.*

### Dataflow

1. Customer's mobile app authenticates via Azure Active Directory B2C.
1. Customer's mobile app connects to the back-end web service that aggregates data from different systems using asynchronous connection.
1. Web application connects to SQL database.
1. Power BI connects to SQL database and SharePoint.
1. Logic app pulls data from CRM (Salesforce).
1. Logic app connects to SAP system (on-premises or in the cloud).
1. Employee mobile app connects to the logic app that orchestrates the business process.
1. Employee mobile app authenticates via Azure Active Directory.

### Components

* [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) lets you deploy a Windows Server or Linux image in the cloud. You can select images from a marketplace or use your own customized images.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a relational database service that lets you rapidly create, extend, and scale relational applications into the cloud.

## Next steps

* [Running SAP on Azure](/azure/virtual-machines/workloads/sap/get-started?toc=%2fazure%2fvirtual-machines%2fwindows%2fclassic%2ftoc.json)
* [Running SQL server in Azure](/azure/sql-database/sql-database-get-started-portal)
