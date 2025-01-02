Now that you gathered your test documents and queries, and performed a document analysis in the [preparation phase](./rag-preparation-phase.yml), the next phase is chunking. Breaking down documents into a collection of right-sized chunks, each containing semantically relevant content, is a key factor in the success of your Retrieval-Augmented Generation (RAG) implementation. Passing entire documents or oversized chunks is expensive, might overwhelm the token limits of the model, and doesn't produce the best results. Passing information to a language model that is irrelevant to the query can lead to hallucinations. You need to optimize the process of passing relevant information and removing irrelevant information. You do this optimization by using effective chunking and searching strategies to minimize false positives and false negatives, and maximize true positives and true negatives.

Passing chunks that are too small and don't contain sufficient context to address the query also leads to poor results. Relevant context that exists across multiple chunks might not be captured. The art is implementing effective chunking approaches for your specific document types and their structures and content. There are various chunking approaches to consider, each with their own cost implications and effectiveness, depending on the type and structure of document they're applied to.

This article describes various chunking approaches, and examines how the structure of your documents can influence the chunking approach you choose.

> This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.yml).

## Chunking economics

When determining your overall chunking strategy, you must consider your budget along with your quality and throughput requirements for your document corpus. There are engineering costs for the design and implementation of each unique chunking implementation and per-document processing costs that differ depending upon the approach. If your documents have embedded or linked media, you must consider the economics of processing those elements. For chunking, this processing generally uses language models to generate descriptions of the media, and those descriptions are then chunked. An alternate approach with some media is to pass them as-is to a multi-modal model at inferencing time, but that approach wouldn't affect the chunking economics.

This section examines the economics of both chunking images and the overall solution.

### Image chunking economics

There's a cost to using a language model to generate a description of an image which is then chunked. For example, cloud-based services such as Azure OpenAI either charge on a per-transaction basic or on a prepaid provisioning basis. Larger images incur a larger cost. Through your document analysis, you should determine what images are valuable to chunk and what images you should ignore. From there, you need to understand the number and sizes of the images in your solution and you should weigh the value of chunking the image descriptions against the cost of generating those descriptions.

One way to determine what images to process is to use a service such as [Azure AI Vision](/azure/ai-services/computer-vision) to classify images, tag images, or do logo detection. You can then use the results and confidence indicators to determine whether the image adds meaningful, contextual value and should be processed. Calls to Azure AI Vision might be less expensive than calls to language models, so this approach could lead to cost savings. You need to experiment to determine what confidence levels and what classifications or tags provide the best results for your data. Another option is to build your own classifier model. You need to take into account the costs of building, hosting, and maintaining your own classifier model.

Another cost optimization is caching using the [cache-aside pattern](/azure/architecture/patterns/cache-aside). You can generate a key based on the hash of the image. As a first step, you can check to see if you have a cached result from a prior run or previously processed document. If you do, you can use that result. That approach keeps you from the costs of calling a classifier or a language model. If there's no cache, when you call to the classifier or language model, you would cache the result. Future calls for this image would use the cache.

A simple workflow integrating all of these cost optimization processes would be:

1. Check to see if the image processing was cached. If so, use the cached results.
1. Run your classifier to determine if you should process the image. Cache the classification result. Only proceed if your classification logic tells you to do so.
1. Generate the description for your image. Cache the result.

### Economics of the overall solution

The following are factors to consider when looking at the cost of your overall solution:

- **Number of unique chunking implementations** - Each unique implementation has both an engineering and maintenance cost. You need to consider the number of unique document types in your corpus and the cost vs. quality tradeoffs of unique implementations for each.
- **Per-document cost of each implementation** - Some chunking approaches might lead to better quality chunks but have a higher financial and temporal cost to generate those chunks. For example, using a prebuilt model in Azure AI Document Intelligence likely has a higher per-document cost than a pure text parsing implementation, but might lead to better chunks.
- **Number of initial documents** - The number of initial documents you need to process to launch your solution.
- **Number of incremental documents** - The number and rate of new documents that you must process for ongoing maintenance of the system.

## Loading and chunking

Logically, during chunking, you must first load the document into memory in some format. The chunking code then operates against the in-memory representation of the document. You can choose to combine the loading code with chunking, or you can separate loading into its own phase. The approach you choose should largely be based upon architectural constraints and your preferences. This section briefly explores both options and then provides you with some general recommendations.

### Separate loading and chunking

There are several reasons you might choose to separate the loading and chunking phases. You might want to encapsulate logic in the loading code. You might want to persist the result of the loading code before chunking, especially when experimenting with various chunking permutations to save on processing time or cost. Lastly, you might want to run the loading and chunking code in separate processes for architectural reasons such as process bulkheading or security segmentation involving removing PII.

#### Encapsulate logic in the loading code

You might choose to encapsulate preprocessing logic in the loading phase. This simplifies the chunking code because it doesn't need to do any preprocessing. Preprocessing can be as simple as removing or annotating parts of the document you determined you want to ignore in document analysis, such as watermarks, headers, and footers or as complex as reformatting the document. The following are some examples of preprocessing you might choose to encapsulate in the loading phase:

- Remove or annotate items you want to ignore.
- Replace image references with image descriptions. During this phase, you use an LLM to generate a description for the image and update the document with that description. If you determined in the document analysis that there's surrounding text that provides valuable context to the image, pass that, along with the image, to the LLM.
- Download or copy images to file storage like Azure Data Lake to be processed separately from the document text. If you determined in the document analysis that there's surrounding text that provides valuable context to the image, you need to store this text along with the image in file storage.
- Reformat tables so they're more easily processed.

#### Persisting the result of the loading code

There are multiple reasons you might choose to persist the result of the loading code. One reason is if you want the ability to inspect the documents after they're loaded and pre-processed, but before the chunking logic is run. Another reason is that you might want to run different chunking logic against the same pre-processed code while in development or in production. Persisting the loaded code speeds up this process.

#### Run loading and chunking code in separate processes

Separating the loading and chunking code into separate processes helps enable running multiple chunking implementations against the same pre-processed code. This separation also allows you to run loading and chunking code in different compute environments and on different hardware. Further, this design allows you to independently scale the compute used for loading and chunking.

### Combine loading and chunking

Combining the loading and chunking code is a simpler implementation in most cases. Many of the operations that you might consider doing in preprocessing in a separate loading phase can be accomplished in the chunking phase. For example, instead of replacing image URLs with a description in the loading phase, the chunking logic can make calls to the LLM to get a text description and chunk the description.

When you have document formats like HTML that have tags with references to images, you need to ensure that the reader or parser that the chunking code is using doesn't strip out the tags. The chunking code needs to be able to identify image references.

### Recommendations

The following are some recommendations to consider when determining whether you combine or separate your chunking logic.

- Start with combining loading and chunking logic. Separate them when your solution requires it.
- Avoid converting documents to an intermediate format if you choose to separate the processes. Operations such as that can be lossy.

## Chunking approaches

This section gives you an overview of some common chunking approaches. This list isn't meant to be exhaustive, rather some common representative approaches. You can use multiple approaches in implementation, such as combining the use of a language model to get a text representation of an image with many of the listed approaches.

Each approach is accompanied by a summarized decision-making matrix that highlights the tools, associated costs, and more. The engineering effort and processing costs are subjective and are included for relative comparison.

### Sentence-based parsing

This straightforward approach breaks down text documents into chunks made up of complete sentences. The benefits of this approach include that it's inexpensive to implement, it has low processing cost, and it can be applied to any text-based document that is written in prose, or full sentences. A challenge with this approach is that each chunk might not capture the complete context of a thought or meaning. Often, multiple sentences must be taken together to capture the semantic meaning.

**Tools**: [SpaCy sentence tokenizer](https://spacy.io/api/tokenizer), [LangChain recursive text splitter](https://python.langchain.com/docs/how_to/recursive_text_splitter/), [NLTK sentence tokenizer](https://www.nltk.org/api/nltk.tokenize.html)<br/>
**Engineering effort**: Low<br/>
**Processing cost**: Low<br/>
**Use cases**: Unstructured documents written in prose, or full sentences, and your corpus of documents contains a prohibitive number of different document types to build individual chunking strategies for<br/>
**Examples**: User-generated content like open-ended feedback from surveys, forum posts, reviews, email messages, a novel, or an essay

### Fixed-size parsing (with overlap)

This approach breaks up a document into chunks based on a fixed number of characters or tokens and allows for some overlap of characters between chunks. This approach has many of the same advantages and disadvantages as sentence-based parsing. An advantage this approach has over sentence-based parsing is that it's possible to get chunks with semantic meaning that spans multiple sentences.

You must choose the fixed size of the chunks and the amount of overlap. Because the results differ for different document types, it's best to use a tool like the HuggingFace chunk visualizer to do exploratory analysis. Tools like this allow you to visualize how your documents are chunked, given your decisions. It's best practice to use BERT tokens over character counts when using fixed-sized parsing. BERT tokens are based on meaningful units of language, so they preserve more semantic information than character counts.

**Tools**:  [LangChain recursive text splitter](https://python.langchain.com/docs/how_to/recursive_text_splitter/), [Hugging Face chunk visualizer](https://huggingface.co/spaces/m-ric/chunk_visualizer)<br/>
**Engineering effort**: Low<br/>
**Processing cost**: Low<br/>
**Use cases**: Unstructured documents written in prose or non-prose with complete or incomplete sentences. Your corpus of documents contains a prohibitive number of different document types to build individual chunking strategies for<br/>
**Examples**: User-generated content like open-ended feedback from surveys, forum posts, reviews, email messages, personal, or research notes or lists

### Custom code

This approach parses documents using custom code to create chunks. This approach is most successful for text-based documents where the structure is either known or can be inferred and a high degree of control over chunk creation is required. You can use text parsing techniques like regular expressions to create chunks based on patterns within the document's structure. The goal is to create chunks that have similar size in length and chunks that have distinct content. Many programming languages provide support for regular expressions, and some have libraries or packages that offer more elegant string manipulation features.

**Tools**: [Python](https://docs.python.org/3/) ([re](https://docs.python.org/3/library/re.html), [regex](https://pypi.org/project/regex/),  [BeautifulSoup](https://pypi.org/project/BeautifulSoup/), [lxml](https://pypi.org/project/lxml/), [html5lib](https://pypi.org/project/html5lib/), [marko](https://pypi.org/project/marko/)), [R](https://www.r-project.org/other-docs.html) ([stringr](https://cran.r-project.org/web/packages/stringr/index.html), [xml2](https://xml2.r-lib.org/reference/read_xml.html)), [Julia](https://docs.julialang.org/en/v1/) ([Gumbo.jl](https://github.com/JuliaWeb/Gumbo.jl))<br/>
**Engineering effort**: Medium<br/>
**Processing cost**: Low<br/>
**Use cases**: Semi-structured documents where structure can be inferred<br/>
**Examples**: Patent filings, research papers, insurance policies, scripts, and screenplays

### Language model augmentation

Language models can be used to create chunks. Common use cases are to use a large language model, such as GPT-4, to generate textual representations of images or summaries of tables that can be used as chunks. Language model augmentation is used with other chunking approaches such as custom code.

If you determined in the [images portion of the document analysis section](./rag-preparation-phase.yml#determine-your-image-processing-requirements) that the text before or after the image is required to answer some questions, you need to pass this additional context to the language model. It's important to experiment to determine whether this additional context does or doesn't improve the performance of your solution.

If your chunking logic splits the image description into multiple chunks, make sure you include the image URL in each chunk. Including the image URL in each chunk ensures that metadata is returned for all queries that the image serves, especially for scenarios where the end user requires the ability to access the source image through that URL or wants to use raw images during inferencing time.

**Tools**: [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service), [OpenAI](https://platform.openai.com/docs/introduction)<br/>
**Engineering effort**: Medium<br/>
**Processing cost**: High<br/>
**Use cases**: Images, tables<br/>
**Examples**: Generate text representations of tables, and images, summarize transcripts from meetings, speeches, interviews, or podcasts

### Document layout analysis

Document layout analysis libraries and services combine optical character recognition (OCR) capabilities with deep learning models to extract both the structure of documents, and text. Structural elements can include headers, footers, titles, section headings, tables, and figures. The goal is to provide better semantic meaning to content contained in documents.

Document layout analysis libraries and services expose a model that represents the content, both structural and text, of the document. You still have to write code that interacts with the model.

> [!NOTE]
> Azure AI Document Intelligence is a cloud-based service that requires you to upload your document to the service. You need to ensure your security and compliance regulations allow you to upload documents to services such as this.

**Tools**:  [Azure AI Document Intelligence document analysis models](/azure/ai-services/document-intelligence/overview#document-analysis-models), [Donut](https://github.com/clovaai/donut/), [Layout Parser](https://github.com/Layout-Parser/layout-parser)<br/>
**Engineering effort**: Medium<br/>
**Processing cost**: Medium<br/>
**Use cases**: Semi-structured documents<br/>
**Examples**: News articles, web pages, resumes

### Prebuilt model

There are services, such as Azure AI Document Intelligence, that offer prebuilt models you can take advantage of for a various document types. Some models are trained for specific document types, such as the US Tax W-2 form, while others target a broader genre of document types such as an invoice.

**Tools**:  [Azure AI Document Intelligence prebuilt models](/azure/ai-services/document-intelligence/overview#prebuilt-models), [Power Automate Intelligent Document Processing](https://powerautomate.microsoft.com/en-us/intelligent-document-processing/), [LayoutLMv3](https://huggingface.co/microsoft/layoutlmv3-base)<br/>
**Engineering effort**: Low<br/>
**Processing cost**: Medium/High<br/>
**Use cases**: Structured documents where a prebuilt model exists<br/>
**Specific examples**: Invoices, receipts, health insurance card, W-2 form

### Custom model

For highly structured documents where no prebuilt model exists, you might have to build a custom model. This approach can be effective for images or documents that are highly structured, making them difficult to use text parsing techniques.

**Tools**:  [Azure AI Document Intelligence custom models](/azure/ai-services/document-intelligence/overview#custom-models), [Tesseract](https://github.com/tesseract-ocr/tessdoc)<br/>
**Engineering effort**: High<br/>
**Processing cost**: Medium/High<br/>
**Use cases**: Structured documents where a prebuilt model doesn't exist<br/>
**Examples**: Automotive repair and maintenance schedules, academic transcripts, and records, technical manuals, operational procedures, maintenance guidelines

## Document structure

Documents vary in the amount of structure they have. Some documents, like government forms have a complex and well-known structure, such as a W-2 U.S. tax document. At the other end of the spectrum are unstructured documents like free-form notes. The degree of structure to a document type is a good starting point for determining an effective chunking approach. While there are no hard and fast rules, this section provides you with some guidelines to follow.

:::image type="complex" source="./_images/chunking-approaches-by-document-structure.png" lightbox="_images/chunking-approaches-by-document-structure.png" alt-text="Diagram showing chunking approaches by document structure." border="false":::
   The diagram shows document structure from high to low on the X axis. It ranges from (high) structured, semi-structured, inferred, to unstructured (low). The next line up shows examples with W-2 being between high and structured, Invoice being between structured and semi-structured, web page between semi-structured and inferred, European Union (EU) regulation between inferred and unstructured and Field notes between unstructured and low. Above the X axis, are six chunking approaches. Each approach has a green shading indicating where it's most effective. The following list the approaches: 1. Prebuilt model - Darkest green over structured. 2. Custom model - darkest green over semi-structured. 3. Document analysis model - darkest green over semi-structured to inferred. 4. Custom code - darkest green over semi-structured to inferred. 5. Boundary based - darkest green over inferred to unstructured. 6. Sentence based - darkest green over unstructured.
:::image-end:::
*Figure 1. Chunking approach fits by document structure*

### Structured documents

Structured documents, sometimes referred to as fixed-format documents, have defined layouts. The data in these documents is located at fixed locations. For example, the date, or customer family name, is found in the same location in every document of the same fixed format. Examples of fixed format documents are the W-2 U.S. tax document.

Fixed format documents might be scanned images of original documents that were hand-filled or have complex layout structures, making them difficult to process with a basic text parsing approach. A common approach to processing complex document structures is to use machine learning models to extract data and apply semantic meaning to that data, where possible.

**Examples**: W-2 form, Insurance card<br/>
**Common approaches**: Prebuilt models, custom models

### Semi-structured documents

Semi-structured documents don't have a fixed format or schema, like the W-2 form, but they do offer consistency regarding format or schema. For example, all invoices aren't laid out the same, however, in general they have a consistent schema. You can expect an invoice to have an `invoice number` and some form of `bill to` and `ship to` name and address, among other data. A web page might not have schema consistencies, but they have similar structural or layout elements, such as `body`, `title`, `H1`, and `p` that can be used to add semantic meaning to the surrounding text.

Like structured documents, semi-structured documents that have complex layout structures are difficult to process with text parsing. For these document types, machine learning models are a good approach. There are prebuilt models for certain domains that have consistent schemas like invoices, contracts, or health insurance. Consider building custom models for complex structures where no prebuilt model exists.

**Examples**: Invoices, receipts, web pages, markdown files<br/>
**Common approaches**: Document analysis models

### Inferred structure

Some documents have a structure but aren't written in markup. For these documents, the structure must be inferred. A good example is the following EU regulation document.

:::image type="complex" source="./_images/eu-regulation-example.png" lightbox="./_images/eu-regulation-example.png" alt-text="Diagram showing an EU regulation as an example of a document with inferred structure." border="false":::
   The diagram shows an EU regulation. It shows that there's a structure that can be inferred. There are paragraphs numbered 1, 2, and 3. Under 1, there's a, b, c, and d. Under a, there's i, ii, iii, iv, v, and vi.
:::image-end:::
*Figure 2. EU regulation showing an inferred structure*

Because you can clearly understand the structure of the document, and there are no known models for it, you can determine that you can write custom code. A document format such as this might not warrant the effort to create a custom model, depending upon the number of different documents of this type you're working with. For example, if your corpus is all EU regulations or U.S. state laws, a custom model might be a good approach. If you're working with a single document, like the EU regulation in the example, custom code might be more cost effective.

**Examples**: Law documents, scripts, manufacturing specifications<br/>
**Common approaches**: Custom code, custom models

### Unstructured documents

A good approach for documents with little to no structure are sentence-based or fixed-size with overlap approaches.

**Examples**: User-generated content like open-ended feedback from surveys, forum posts, or reviews, email messages, and personal or research notes<br/>
**Common approaches**: Sentence-based or boundary-based with overlap

### Experimentation

Although the best fits for each of the chunking approaches are listed, in practice, any of the approaches might be appropriate for any document type. For example, sentence-based parsing might be appropriate for highly structured documents, or a custom model might be appropriate for unstructured documents. Part of optimizing your RAG solution is experimenting with various chunking approaches, taking into account the number of resources you have, the technical skill of your resources, and the volume of documents you have to process. To achieve an optimal chunking strategy, you need to observe the advantages and tradeoffs of each of the approaches you test to ensure you're choosing the appropriate approach for your use case.

## Next steps

> [!div class="nextstepaction"]
> [Chunk enrichment phase](./rag-enrichment-phase.yml)

## Related resources

- [Chunking large documents for vector search solutions in Azure AI Search](/azure/search/vector-search-how-to-chunk-documents)
- [Integrated data chunking and embedding in Azure AI Search](/azure/search/vector-search-integrated-vectorization)
