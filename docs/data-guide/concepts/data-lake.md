# Data lakes

A data lake is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data,  

Unlike a traditional [data warehouse](../scenarios/data-warehousing.md), a data lake holds raw, untransformed data. The data that is placed in a data warehouse typically comes from multiple heterogenous sources, and may be structured, semi-structured, or unstructured. 

- Does not throw away any data, because the data is stored in its raw format. This is especially useful in a big data environment, when you may not know in advance what insights are available from the data.
- Users can explore data and create their own queries.
- May be faster than traditional ETL tools.
- More flexible than a data warehouse, because it can store unstructured and semi-structured data. 

A complete data lake solution consists of both storage and processing. Data lake storage is designed for fault-tolerance, infinite scalability, and high-throughput ingestion of data with varying shapes and sizes. Data lake processing involves one or more processing engines built with these goals in mind, and can operate on data stored in a data lake at scale.

A data lake may the data source for a data warehouse. With this approach, the raw data is ingested into the data lake and then transformed into a structured quaryable format. Typically this transformation uses an [ELT](../scenarios/etl.md#extract-load-and-transform-elt) (extract-load-transform) pipeline, where the data is ingested and transformed in place. 

Other uses for a data lake include data exploration, data analytics, and machine learning. Source data that is already relational may go directly into the data warehouse, using an ETL process, skipping the data lake.

Data lake stores are often used in event streaming or IoT scenarios, because they can persist large amounts of relational and nonrelational data without transformation or schema definition. They are built to handle high volumes of small writes at low latency, and are optimized for massive throughput.

Challenges:

- Lack of a schema or descriptive metadata can make the data hard to consume or query.
- Similarly, lack of semantic consistency across multiple data sources can make it hard to 
- It can be hard to guarantee the quality of the data going into the data lake. 
- Without proper governance, access control and privacy can be problems. What information is going into the data lake, who can access that data, and for what uses?
- A data lake may not be the best way to integrate data that is already relational.
- By itself, a data lake does not provide integrated or holistic views across the organization. 
- A data lake may become a dumping ground for data that is never actually analyzed or mined for insights.

Relevant Azure services:

- [Data Lake Store](/azure/data-lake-store/) is a hyper-scale, Hadoop-compatible repository.
- [Data Lake Analytics](/azure/data-lake-analytics/) is an on-demand analytics job service to simplify big data analytics.

