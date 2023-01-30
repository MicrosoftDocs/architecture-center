This article demonstrates how to use [multiple indexers](/azure/search/search-indexer-overview#indexer-scenarios-and-use-cases) in [Azure Cognitive Search](/azure/search/search-what-is-azure-search) to create a single [search index](/azure/search/search-what-is-an-index) from files in [Blob storage](/azure/storage/blobs/storage-blobs-overview), with additional metadata in [Table storage](/azure/storage/tables/table-storage-overview).

## Architecture

![Diagram of the "Index file contents and metadata in Azure Cognitive Search" architecture.](./media/architecture-search-blob-metadata.png)

*Download a [PowerPoint file](https://arch-center.azureedge.net/search-blob-metadata.pptx) of this architecture.*

### Dataflow

The following dataflow corresponds to the above diagram:

1. Files are stored in Blob storage, optionally along with a limited amount of metadata (for example, the document's author).
2. Additional metadata is stored in Table storage, which allows significantly more information to be stored for each document.
3. An indexer reads the contents of each file along with any blob metadata and stores it in the search index.
4. Another indexer reads the additional metadata from the table and stores it in the same search index.
5. A search query is sent to the search service and returns matching documents based on their content as well as their metadata.

### Components

- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/) provides very cost-effective cloud storage for file data (such as PDF, HTML, CSV, Microsoft Office files, ...).
- [Azure Table Storage](https://azure.microsoft.com/products/storage/tables/) allows you to store non-relational structured data; in this scenario it's used to store the metadata for each document.
- [Azure Cognitive Search](https://azure.microsoft.com/products/search/) is a fully managed search service that gives developers infrastructure, APIs, and tools for building a rich search experience.

### Alternatives

This scenario uses [indexers in Azure Cognitive Search](/azure/search/search-indexer-overview) to automatically discover new content in supported data sources (such as Blob and Table storage) and add it to the search index. Alternatively, you can also use the APIs provided by Azure Cognitive Search to [push data into the search index](/azure/search/search-what-is-data-import#pushing-data-to-an-index). In that case, however, you have to write code not only to push the data into the search index, but also to parse and extract text from the binary documents you want to search through. The [Blob storage indexer supports a large number of document formats](/azure/search/search-howto-indexing-azure-blob-storage#supported-document-formats), which significantly simplifies the text extraction and indexing process.

Furthermore, by using indexers, you can optionally [enrich the data as part of an indexing pipeline](/azure/search/cognitive-search-concept-intro). For example, you can inject cognitive services to perform [Optical Character Recognition (OCR)](/azure/search/cognitive-search-skill-ocr) or [visual analysis](/azure/search/cognitive-search-skill-image-analysis) of the images found in the documents, [detect the language](/azure/search/cognitive-search-skill-language-detection) of documents, [translate](/azure/search/cognitive-search-skill-text-translation) them, or define your own [custom skills](/azure/search/cognitive-search-create-custom-skill-example) to enrich the data in any way that is relevant to your business scenario.

In this article, we've chosen to use Blob and Table storage as they are very cost-effective and efficient. This also allows us to keep the documents and metadata together in a single Storage account. Alternative supported data sources for the documents themselves could be [Azure Data Lake Storage Gen2](/azure/search/search-howto-index-azure-data-lake-storage) or [Azure Files](/azure/search/search-file-storage-integration); their metadata could be stored in any other supported data source which holds structured data, such as [Azure SQL Database](/azure/search/search-howto-connecting-azure-sql-database-to-azure-search-using-indexers) or [Azure Cosmos DB](/azure/search/search-howto-index-cosmosdb).

## Scenario details

In this example scenario, we want to allow users to search for documents based on their file contents, as well as additional metadata that we store separately for each document. For example, next to the actual text contents of the document, we might want to search for the document's *author*, the *document type* (for example, whether's it's a paper or a report), and its *business impact* (for example, high, medium or low).

[Azure Cognitive Search](/azure/search/search-what-is-azure-search) is a fully managed search service which we can use to create [search indexes](/azure/search/search-what-is-an-index) containing the information we want to allow users to search for.

Because the files we want to search for are binary documents, we can easily store them in [Azure Blob storage](/azure/storage/blobs/storage-blobs-overview). This has the additional advantage that Azure Cognitive Search can use its built-in [Blob storage indexer](/azure/search/search-howto-indexing-azure-blob-storage) to automatically extract text from them and add their contents to the search index.

To include additional information on these files, blobs can have [metadata](/azure/storage/blobs/storage-blob-properties-metadata) directly associated with them, without the need for a separate data store. The built-in [Azure Blob Storage search indexer can even read this metadata](/azure/search/search-howto-indexing-azure-blob-storage#indexing-blob-metadata) and place it in the search index as well. This allows us to not only search for the file contents, but also for their metadata. However, [the total size of metadata is limited to 8KB per blob](https://learn.microsoft.com/rest/api/storageservices/Setting-and-Retrieving-Properties-and-Metadata-for-Blob-Resources#Subheading1), which means the amount of information that can be placed on each blob is fairly small. For example, we could choose to store only the most critical information on the blobs directly, such as the document's *author* in our case.

To overcome this storage size limitation, we can place additional metadata in another [data source with a supported indexer](/azure/search/search-indexer-overview#supported-data-sources), such as [Table storage](/azure/storage/tables/table-storage-overview). We can add the *document type*, *business impact* and many other metadata values as separate columns in the table. By configuring the built-in [Azure Table Storage indexer](/azure/search/search-howto-indexing-azure-tables) to target the same search index, the metadata from both the blobs themselves and from Table storage will be combined onto the same document within the search index.

The way we ensure that both indexers point at the same document in the search index, is by configuring the [document key in the search index](/azure/search/search-what-is-an-index#field-attributes) to be a unique identifier of the file that we can easily refer to from both data sources. The [Blob indexer uses the `metadata_storage_path` as the document key by default](/azure/search/search-howto-indexing-azure-blob-storage#add-search-fields-to-an-index): this is the full URL of the file in Blob storage, such as `https://contoso.blob.core.windows.net/files/paper/Resilience in Azure.pdf`. The indexer will also Base64-encode it to ensure that there are no invalid characters in the document key, so that it results in a unique document key such as `aHR0cHM6...mUucGRm0`.

If we add the `metadata_storage_path` as a column in Table storage, we know exactly for which blob we've stored the metadata in the other columns. This leaves us free to use any `PartitionKey` and `RowKey` in the table for our use case. For example, we could use the container name of the blobs as the `PartitionKey` and the Base64-encoded full URL of the blob as the `RowKey` - ensuring that there are no [invalid characters in these keys](https://learn.microsoft.com/rest/api/storageservices/understanding-the-table-service-data-model#characters-disallowed-in-key-fields) either.

We can then use a [field mapping](/azure/search/search-indexer-field-mappings) in the Table indexer to map the `metadata_storage_path` column in Table storage (or another column name if we choose) to the `metadata_storage_path` document key field in the search index. By applying the [base64Encode function](/azure/search/search-indexer-field-mappings#base64EncodeFunction) on the field mapping, we end up with the same document key (such as `aHR0cHM6...mUucGRm0` from the example above) and the metadata from Table storage will be added to the same document that was extracted from Blob storage.

> [!NOTE]
> The documentation for the Table indexer calls out explicitly to ["not define a field mapping to alternative unique string field in your table"](/azure/search/search-howto-indexing-azure-tables#add-search-fields-to-an-index). This is because by default, it uses a concatenation of the `PartitionKey` and `RowKey` as the document key. However, since we're already relying on the document key as configured by the Blob indexer (which is the Base64-encoded full URL of the blob), creating a field mapping to ensure both indexers refer to the same document in the search index is perfectly fine and supported.

Alternatively, the `RowKey` (which we had set to the Base64-encoded full URL of the blob) could also have been mapped to the `metadata_storage_path` document key directly, without having to store it separately and Base64-encoding it as part of the field mapping. However, keeping the unencoded URL as a separate column makes it easier to see immediately which blob it refers to, and allows the partition and row keys to be decided without impact to the search indexer.

### Potential use cases

This scenario applies to any application in any industry which needs to allow users to search for documents based on their file contents and additional metadata.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Azure Cognitive Search provides a [99.9% availability SLA](https://go.microsoft.com/fwlink/?LinkId=716855) for *reads* (that is, querying) if you have at least two replicas, and for *updates* (that is, updating the search indexes) if you have at least three replicas. Therefore you should provision at least two replicas if you want your users to be able to *search* reliably, and 3 if actual *changes to the index* should also be considered high availability operations.

[Azure Storage always stores multiple copies of your data](/azure/storage/common/storage-redundancy) so that it's protected from planned and unplanned events, and it has additional redundancy options to replicate data across regions. This includes the data in Blob and Table storage.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Cognitive Search is compliant with many [security and data privacy standards](/azure/search/search-security-overview), which makes it possible to be used in most industries.

Whenever possible, you should use [Azure AD authentication](/azure/search/search-security-rbac) for accessing the search service itself, and [connect your search service to other Azure resources (like Blob and Table storage in this scenario) using a managed identity](/azure/search/search-howto-managed-identities-data-sources).

Furthermore, you can [connect from the search service to the storage account through a private endpoint](/azure/search/search-indexer-howto-access-private?tabs=portal-create%2Cportal-status) to go over a private connection without requiring the blob and table storage to be accessible publicly.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, all the services mentioned above are [pre-configured in the Azure pricing calculator](https://azure.com/e/375d2b930db14fbe90537421331f41de) for an example with a total document size of 20 GB in Blob storage and 1 GB of additional metadata in Table storage. We've chosen two search units to satisfy the SLA for read purposes, as explained in the [reliability](#reliability) section above. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected usage.

As you can see from the pricing calculator, Blob and Table storage make up only a fraction of the cost; the majority is spent on Azure Cognitive Search as it performs the actual indexing and compute for running search queries.

## Deploy this scenario

To deploy this example workload, see the [Indexing file contents and metadata in Azure Cognitive Search](https://github.com/Azure-Samples/azure-cognitive-search-blob-metadata) repository in the Azure Samples. It allows you to easily create the necessary Azure services, upload a few sample documents to Blob storage, populate the *author* metadata value on the blob, store the *document type* and *business impact* metadata values in Table storage, and then create the indexers which maintain the search index.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer

## Next steps

To learn more, see these resources:

- [Get started with Azure Cognitive Search](/azure/search/search-what-is-azure-search#how-to-get-started)
- [Increase relevancy using Semantic search in Azure Cognitive Search](/azure/search/semantic-search-overview)
- [Security filters for trimming results in Azure Cognitive Search](/azure/search/search-security-trimming-for-azure-search)

## Related resources

- [Choose a search data store in Azure](/azure/architecture/data-guide/technology-choices/search-options)
- [Intelligent product search engine for e-commerce](/azure/architecture/example-scenario/apps/ecommerce-search)
