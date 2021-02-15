


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This reference architecture shows how to deploy an e-commerce web site on Azure using Azure CosmosDB as data store. Azure CosmosDB is used to store product information and session state. 

This archietcture also supports in-depth queries over diverse product catalogs, traffic spikes, and rapidly changing inventory provided by Azure Search.

![Architecture Diagram](../media/retail-and-e-commerce-using-cosmos-db.png)
*Download an [SVG](../media/retail-and-e-commerce-using-cosmos-db.svg) of this architecture.*

## Architecture

The architecture has following components

**Azure Web App**  Azure web app is used to host the e-commerce web application.

**Azure CosmosDB** Azure CosmosDB stores the products and the session state.

**Azure Storage** Static product images are stored in Azure Storage Account.

**Azure Search** Azure search provides search over products

