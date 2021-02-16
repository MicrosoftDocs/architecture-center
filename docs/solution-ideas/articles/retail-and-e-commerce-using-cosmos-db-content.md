


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This reference architecture shows how to deploy an e-commerce web site on Azure. The e-commerce web site is hosted on Azure Web App and uses Azure CosmosDB as data store for  product information and session state. Azure Search provides search functionality over diverse product catalogs, traffic spikes, and rapidly changing inventory.

![Architecture Diagram](../media/retail-and-e-commerce-using-cosmos-db.png)
*Download an [SVG](../media/retail-and-e-commerce-using-cosmos-db.svg) of this architecture.*

## Architecture

The architecture has following components

**Azure Web App**  Azure web app is used to host the e-commerce web application.

**Azure CosmosDB** Azure CosmosDB stores the products and the session state.

**Azure Storage** Static product images and other static contents are stored in Azure Storage Account.

**Azure Search** Azure search provides search over products

