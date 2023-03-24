---
title: Design a collection structure for a Microsoft Purview federated catalog
description: Learn how to design the structure of collections in a Microsoft Purview federated catalog to avoid data silos.
author: jcorioland
ms.author: jucoriol
ms.date: 03/29/2023 
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - microsoft-purview
categories:
  - databases
  - analytics
---

# Design a collection structure for a Microsoft Purview federated catalog

This guide describes the structure of collections in a federated catalog created using [Microsoft Purview](/security/business/microsoft-purview). 

## Potential use case 

Data has an increasingly important role nowadays and it brings huge benefits to the organizations who unlock its potential.  

For example, Contoso, like many large companies, would like to create a holistic view of their data assets to enable data driven business scenarios. Contoso is composed of multiple subdivisions / subsidiaries which work independently, resulting in data silos and limited collaboration. 

For example, as an employee in division A, you are about to create a new project. Data assets such as web site logs, trends analysis, social network analysis might be relevant to your project. However, these assets belong to other subsidiaries, and you are not even aware of their existence - which limits the success of your project. 

This is exactly the type of situation Contoso would like to avoid by creating a federated metadata catalog. An example of metadata is the name and schema of a SQL Table - without revealing the content of the table itself. 

Microsoft Purview has been chosen as the perfect solution for this - which allows searching and discovering metadata about data assets. Such a catalog would enable collaboration and would break down organizational boundaries. Subdivisions / subsidiaries will continue owning their data, however, by sharing metadata about their data, collaboration is enabled, and, on a case-by-case basis, data can be potentially shared. 

The challenge Contoso is facing right now is how to structure the collections in Purview. To overcome this challenge, Contoso follows the structure proposed in the rest of the guide. 

## Description 

One important aspect in building a federated catalog with [Microsoft Purview]() is the structure of the [collections](). The recommended structure is illustrated in the diagram below: 

 image 

- The *Purview Account Root Collection* represents the root collection that is created by default with the Purview account and is recommended to not be used directly. 

- The *Federated Metadata Catalog* collection is the first collection that needs to be created by the administrator of the catalog and is used to propagate permissions to the children’s collections. 

- Since the goal of the *Federated Metadata Catalog* is to facilitate the discovery of metadata between subdivisions, a security group “*Federated Metadata Catalog Users*” will be created and assigned as Data Reader on the root collection of the account. Permissions are propagated by default to all sub-collections, which will ensure that all the users belonging to this group will have read access to all the metadata in the federated catalog. To learn more about permissions, read the [access permission](/azure/purview/catalog-permissions) documentation. 

The structure above enables the creation of a federated catalog for two types of subdivisions within a company: 

1. Subdivisions who are or will use Purview as their only data catalog – represented by *Division1* and *Division2*. Such divisions will have the best-in-class experience using Microsoft Purview and will be able to: 
- Register data sources, scan, and classify assets. 
- Create further sub-collections and assign specific permissions based on their needs.  
- Create *private collections* - by breaking the default propagation of permission to the desired collection through [Restrict inherited permissions options](/azure/purview/how-to-create-and-manage-collections#restrict-inheritance): 

image 

Note: In this case, all role assignments from the upper levels are not inherited anymore, apart from Collection Administrator for which inheritance cannot be broken. 

2. Subdivisions which are using a different catalog and will import their metadata in the Federated Data Catalog through other means, such as through the proposed [Synchronization Framework](aac link) - represented by collections under *External Catalogs Root Collections*. 
- Such subdivisions will not be granted permission to create further sub-collections. Each subdivision will get its own root collection, but they will only have Data Reader role assigned. They will not be granted Collection Administrator nor Data Source Administrator roles – these roles will be kept to the administrator of the catalog. 
- The metadata that they choose to import will be available for read for all the users of the federated catalog. 

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Julien Corioland | Principal Software Engineer 

Adina Stoll | Software Engineer 2 

line 

## Next steps
## Related resources

 TODO: Link Raouf’s article about observability in distributed systems : proposal-guide-obs-e2e.docx 

TODO: Link the article about sync framework: Synchronization Framework.docx (sharepoint.com) 