---
title: Design a collection structure for a Microsoft Purview federated catalog
description: Avoid data silos by using a recommended structure for collections in a Microsoft Purview federated catalog.
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

This guide describes a recommended structure for collections in a [Microsoft Purview](https://www.microsoft.com/security/business/microsoft-purview) federated catalog. The design can help your organization avoid data silos.  

## Scenario details

Organizations that take advantage of the potential of data can gain significant benefits.
For example, Contoso, like many large companies, wants to create a holistic view of its data assets to enable data-driven business scenarios. Contoso is made up of multiple subdivisions and subsidiaries that work independently, which results in data silos and limited collaboration. 

For example, employees in Division A are starting a new project. Data assets like web site logs, trend analysis, and social network analysis might be relevant to the project. However, these assets belong to other subsidiaries, and the employees aren't even aware of them, which affects the success of the project.

Contoso wants to avoid this type of situation by creating a federated metadata catalog. Examples of metadata include the name and schema of a SQL table. The metadata doesn't reveal the contents of the table.

Contoso decides to use Microsoft Purview to solve this problem. Microsoft Purview enables the search and discovery of metadata about data assets. A federated catalog improves collaboration and breaks down organizational boundaries. Subdivisions and subsidiaries still own their data. However, because they share metadata about the data, collaboration improves. On a case-by-case basis, data can also be shared.

Contoso's next challenge is to determine how to structure its collections in Microsoft Purview. The rest of this article describes a recommended structure.

## Collection structure

When you build a federated catalog by using Microsoft Purview, it's important to consider the structure of the [collections](/azure/purview/how-to-create-and-manage-collections). This diagram shows the recommended structure for resolving Contoso's data silo challenge: 

:::image type="content" source="./media/collection-structure.png" alt-text="Diagram that shows a recommended structure for collections in Microsoft Purview." lightbox="./media/collection-structure.png" border="false":::
 
- The *Microsoft Purview account root collection* is the root collection that's created by default when the Microsoft Purview account is created. We don't recommend that you use it directly. 

- The *Federated metadata catalog* collection is the first collection that needs to be created by the administrator of the catalog. It's used to propagate permissions to the child collections. 

- Because the goal of the federated metadata catalog collection is to facilitate the discovery of metadata among subdivisions, a Federated Metadata Catalog Users security group is created and assigned as **Data reader** on the root collection of the account. Permissions are propagated by default to all subcollections. This propagation ensures that all users who belong to the group have read access to all metadata in the federated catalog. To learn more about permissions, see [Access control in the Microsoft Purview governance portal](/azure/purview/catalog-permissions). 

The preceding structure enables the creation of a federated catalog for two types of subdivisions: 

- **Type 1.** Subdivisions that use Microsoft Purview as their only data catalog, represented by Division 1 and Division 2. Members of these divisions are granted the highest permissions. They can: 
   - Register data sources and scan and classify assets. 
   - Create subcollections and assign specific permissions based on their needs.  
   - Create private collections by breaking the default propagation of permissions to a collection by using [restrict inherited permissions options](/azure/purview/how-to-create-and-manage-collections#restrict-inheritance): 

   :::image type="content" source="./media/restrict-inherited-permissions.png" alt-text="Diagram that illustrates restricted inheritance." lightbox="./media/restrict-inherited-permissions.png" border="false"::: 

   > [!Note] 
   > When inherited permissions are restricted, role assignments from the higher levels aren't inherited, with the exception of Collection Administrator. Inheritance can't be broken for that role. 

- **Type 2.** Subdivisions that use different catalogs and import their metadata to the federated data catalog in other ways. (For an example architecture, see [Ingest metadata from external catalogs to Microsoft Purview](../../solution-ideas/articles/sync-framework-metadata-ingestion.yml).) These catalogs are represented by collections under *External catalogs root collection* in the first diagram. 
   - Members of these subdivisions aren't granted permissions to create subcollections. Each subdivision gets its own root collection, but only the **Data deader** role is assigned to the users. Collection Administrator and Data Source Administrator roles aren't assigned. These roles are assigned only to the administrator of the catalog. 
   - All users of the federated catalog can read the metadata that members of these divisions import.

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors: 

- [Julien Corioland](https://www.linkedin.com/in/juliencorioland) | Principal Software Engineer 
- [Adina Stoll](https://www.linkedin.com/in/adina-stoll) | Software Engineer 2

Other contributor: 

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.* 

## Next steps

- [What is Microsoft Purview?](/purview/purview)
- [What's available in the Microsoft Purview governance portal?](/azure/purview/overview)
- [Training module: Introduction to Microsoft Purview](/training/modules/intro-to-microsoft-purview)

## Related resources

- [Ingest metadata from external catalogs to Microsoft Purview](../../solution-ideas/articles/sync-framework-metadata-ingestion.yml)
- [Classification best practices in the Microsoft Purview governance portal](/azure/purview/concept-best-practices-classification)
- [Business processes for managing data effectively](/azure/purview/concept-best-practices-asset-lifecycle)