Data contextualization is the process of putting the information relevant to the data based on the context information, and it can improve the efficiency of big data processing and make the data useful and easier for interpretation. This article demonstrates how to contextualize data by looking up the relevant context that has been stored in the graph model in Azure SQL database. 

## Architecture

The following diagram shows the high-level architecture for our sample solution for data contextualization.

![Diagram of the data architecture.](media/data-contextualization-based-on-azure-sql-graph.png)

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

In this architecture, the data from a delta lake (Silver Layer) is read incrementally, contextualized based on a graph lookup, and finally merged into a SQL database as well as another delta lake (Gold Layer).

Here are the details about the terminologies which has been used and processes definitions:

### Silver Layer

The solution is based on Databrick's [Medallion Architecture](https://www.databricks.com/glossary/medallion-architecture) where the data is logically organized in different layers with the goal of incrementally and progressively improving the structure and quality of data.

For simplicity, the architecture uses only two layers; Silver layer representing the input data and Gold layer representing the contextualized data.

The data in the Silver layer has been stored in [Delta Lake](https://docs.databricks.com/delta/index.html) and exposed as delta tables.

### Incremental Data Load 

The solution performs incremental data processing i.e., only the data which has been modified or added since the last run is processed. This is a typical requirement for batch processing so that the data can be processed quickly and economically. 

Refer to the [incremental data load](#incremental-data-load-1) section for more detials.

### Data Contextualization

Data Contextualization is quite a broad term. In context of above architecture, contextualization has been defined as the process of performing a graph lookup based on one/many input columns and retrieving the matching values (one or many).

The solution assumes that the graph has already been created in a graph database. The internal complexity of the graph isn't a concern here as the graph query is passed via a configuration and executed dynamically by passing the input values.

Also, the solution uses Azure Databricks for this data contextualization process.

### Graph Database

This is the database which holds the actual graph. There are many options to choose for the graph database choice such as Neo4j, Redis Graph, GraphQL over CosmosDB and so on. In this case, the [graph capabilities of SQL Server](https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-overview?view=sql-server-ver16) has been used for the creation of the graph.

### Azure SQL Database

For storing the contextualized data, [Azure SQL database](https://azure.microsoft.com/en-au/products/azure-sql/database/) has been used but it can be any other storage option. To ensure idempotent processing, the data has been "merge" into the source system rather than simply been appended.

### Dataflow

As show in the architecture diagram above, the data flow goes through the following steps:
1. The incoming to-be-contextulaized data is appended in the delta table in the 'Silver Layer'
2. The incoming data is incrementally loaded to Azure Databricks
3. Look up the graph database to get the context information
4. Contextualize the incoming data
5. Append the contextualized data into the corresponding table in the SQL database
6. (Optionally) append the contextualized data into the corresponding delta table in the 'Gold Layer'

### Components
* [Azure Data Lake Storage Gen 2](https://azure.microsoft.com/products/storage/data-lake-storage) stores input data and contextualized data in delta tables.
* [Azure Databricks](https://azure.microsoft.com/products/databricks) is the platform where we run python notebook files to contextualize data.
* [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) stores graph models and contextualized data.

### Alternatives
In the market, there are many graph databases to choose. Here is a Graph Database Comparison Spreadsheet to show the differences of some of the popular products.

| Name      | Azure Cosmos DB for Apache Gremlin| Neo4j | Azure Database for PostgreSQL| Azure SQL Database Graph| RedisGraph|
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| Description |NoSQL JSON database for rapid, iterative app development.|Neo4j stores data in nodes connected by directed,typed relationships with properties on both,also known as a Property Graph|PostgreSQL is an object-relational database management system (ORDBMS) based on POSTGRES. CTE mechanism provides graph search (N-depth, shortest path etc) capabilities, and Apache AGE which is a PostgreSQL extension also provides graph database functionality.|SQL Server offers graph database capabilities to model many-to-many relationships. The graph relationships are integrated into Transact-SQL and receive the benefits of using SQL Server as the foundational database management system.|RedisGraph is based on a unique approach and architecture that translates Cypher queries to matrix operations executed over a GraphBLAS engine.A high-performance graph database implemented as a Redis module.|
| [Workload Type](https://csefy19.visualstudio.com/CSE_Engineer_for_Reuse/_git/Data-GraphDB?path=%2Fanalysis.md&anchor=asset-modeling-%28manufacturing%2Fenergy%29&_a=preview)| OLTP|OLTP|OLTP|OLTP|OLTP|
| [Design Type](https://csefy19.visualstudio.com/CSE_Engineer_for_Reuse/_git/Data-GraphDB?path=%2Fanalysis.md&anchor=asset-modeling-%28manufacturing%2Fenergy%29&_a=preview)|Multi-modal|Dedicated|SQL Plugin|SQL Plugin|Multi-modal|
| Azure Managed Service|Yes|In Azure Marketplace, Neo4j offers the single and causal cluster versions of the Enterprise Edition|Graph extension--Apache Age is not supported for Azure| Yes |No |
|Query Language|[Gremlin query language](https://learn.microsoft.com/en-us/azure/cosmos-db/gremlin/tutorial-query)|[CypherQL](https://neo4j.com/docs/cypher-manual/5/introduction/)|[CypherQL, SQL (allow Recursive CTEs)](https://age.apache.org/age-manual/master/intro/overview.html)|[Transact-SQL](https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-architecture?view=sql-server-ver16#transact-sql-reference)|[Subset of OpenCypher](https://redis.io/docs/stack/graph/cypher_support/)|
|Performance|low latency, fast queries and traversals|Not as performant as some of the competitors|Graph schema can be easily and significantly customized to include your requirements without affecting performance. Outstanding query performance in multiple joins via graph model|High availability|Claims high performance owing to using adjacency matrices|
|[MapReduce](https://db-engines.com/en/system/Microsoft+Azure+Cosmos+DB%3BMicrosoft+SQL+Server%3BNeo4j%3BPostgreSQL%3BRedis)|with Hadoop integration|No|No|No|through RedisGears|
|Scale|automatic horizontal [partitioning](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview)|scales writes vertically and reads horizontally|horizontal and vertical scaling|horizontal and vertical scaling|horizontal and vertical scaling|
|[Partitioning methods](https://db-engines.com/en/system/Microsoft+Azure+Cosmos+DB%3BMicrosoft+SQL+Server%3BNeo4j%3BPostgreSQL%3BRedis)|Sharding|Neo4j Fabric|Partitioning by range, list and by hash|Sharding|Sharding|
|[Multi-Tenancy](https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/overview)|Container per tenant, Database per tenant, Database account per tenant|Database per tenant,(Community edition limited to single database)|Schema per tenant, Database per tenant|Database per tenant|Graph Per Tenant|
|Filter|Perform filters using Gremlin's has and hasLabel|CypherQL for filitering|Hybrid Querying|using T-SQL|A query can filter out entities by creating predicates like using where argument|
|[Benchmark](https://github.com/RedisGraph/graph-database-benchmark)|[For a 1 KB document: a read costs 1 RU, a write costs 5 RU](https://learn.microsoft.com/en-us/azure/cosmos-db/request-units)|Cypher O(1) access using fixed-size array|12,000TPS/2.1ms per query with 5 bilion nodes|-|[RedisGraph is able to create over 1 million nodes under half a second and form 500K relations within 0.3 of a second, inserting a new relationship is done in O(1)](https://redis.io/docs/stack/graph/design/)|
|Support Shortest path|[Yes](https://tinkerpop.apache.org/docs/current/recipes/#shortest-path)|[Yes](https://neo4j.com/docs/graph-data-science/current/algorithms/pathfinding/)|Not provide any such function|[SHORTEST_PATH](https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-shortest-path?view=sql-server-ver16) function can only be used inside MATCH, which finds an unweighted shortest path|[Yes](https://redis.io/commands/graph.query/#path-functions)|
|Support Page ranking|[Yes](https://tinkerpop.apache.org/docs/current/recipes/#pagerank-centrality)|[Yes](https://neo4j.com/docs/graph-data-science/current/algorithms/page-rank/)|Not provide any such function|Not provide any such function|[Yes](https://redis.io/commands/graph.query/#path-functions)|
|[Deployment Options](https://cycode.engineering/blog/aws-neptune-neo4j-arangodb-or-redisgraph-how-we-at-cycode-chose-our-graph-database/)|Cloud Offering|Cloud & Self-Hosted (Enterprise Edition requires commercial license)|Cloud Offering, but Apache AGE (AGE) Extension is not supported on Azure database for PostgreSQL|Cloud Offering|Cloud & Self-Hosted|

Reference Links:
1. [Graph Database Analysis](https://csefy19.visualstudio.com/CSE_Engineer_for_Reuse/_git/Data-GraphDB?path=%2Fanalysis.md&anchor=asset-modeling-%28manufacturing%2Fenergy%29&_a=preview)
2. [Azure Cosmos DB for Apache Gremlin](https://learn.microsoft.com/en-us/azure/cosmos-db/gremlin/)
3. [Azure SQL Database Graph](https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-overview?view=sql-server-ver16)
4. [Neo4J](https://neo4j.com/docs/operations-manual/current/introduction/)
5. [Redis Graph](https://redis.io/docs/stack/graph/)
6. [PostgreSQL Apache Age](https://age.apache.org/age-manual/master/intro/overview.html)

Finnally we choose to use Azure SQL Database, because:
* It's an Azure managed relational database servcie with graph capabilities.
* It's easy to get started since we are farmiliar with SQL Server or Azure SQL Database.
* We'll also benefit from using Transact-SQL since the graph database is based on SQL Database.

## Scenario details
### Sample scenario
The sample solution in this article is derived from the scenario described below.

Let’s imagine Gary is an operation engineer from Contoso company and one of his reponsibility is to provide a weekly health check report for the enterprise assets from Contoso’s factories within his city. 

First, Gary has to fetch all the asset ID he is interested in from the company’s ‘Asset’ system,  then look for all the attributes belong to the asset as the input for the health check report, e.g., the operation efficiency data of the asset with ID ‘AE0520’. 

![Scenario Demonstration](images/Scenario.png =500x)

Contoso has many market leading products and applications to help factory owners to monitor the processes and operations, and the operation efficiency data is recorded in another application system called ‘Quality system’. 

So Gary logged in the ‘Quality system’ and used the asset ID ‘AE0520’ to look up the table from AE_OP_EFF which contains the all the key attributes for operation efficiency data.

There are many columns in the AE_OP_EFF table and Gary is speficially interested in the ‘alarm’ status. However the details for the most critical alarms of the asset is kept in another table called ‘alarm’. Gary needs to record the key ID ‘MA_0520’ of ‘alarm’ table which correspoinding to the asset ‘AE0520’, as they are using different naming conventions.  
 
In the reality, the relationship is much more complicated than this. Gary has to search for more than one attribute of the asset and has to log in to many more tables from different systems to get all the data for a complete report. Gary used query and script to faciliate his work but the queries become complicated and hard to maintain. Even worse thing is, the systems are growing and the demand of the report is changing, that more data needs to be added to the report for different decision makers’ perspectives. 

One of the major pain points for Gary is, the ID of one asset in different system are different, as these systems have been developed and  mainained  separately and even using different protocols. He has to manually query the different tables to get the data for the same asset, that caused his query not only complex but also difficult to understand without domain expertise. He uses a lot of time to recruit to the newly onboarded operation engineer and explain the relationships behind. 

If there is a mechnism to ‘link’ the different names but belong to the same asset across systems, Gary’s life will be much easier and his report query will be much simplier.

### Graph Design
Azure SQL Database offers graph database capabilities to model many-to-many relationships. The graph relationships are integrated into Transact-SQL and receive the benefits of using SQL Database as the foundational database management system.

A graph database is a collection of nodes (or vertices) and edges (or relationships). A node represents an entity (for example, a person or an organization) and an edge represents a relationship between the two nodes that it connects (for example, likes or friends). 

![Graph](images/graph01.png)

#### Design the Graph Model for the Demo
For the scenario described preiously, we can design the graph model as below:
* 'Alarm' is one of the metrics that belong to the 'Quality System'
* The 'Quality System' is assocated with an 'Asset'

![Graph](images/graph08.png)

The dummy data is prepared as below:

![Graph](images/graph06.png)

In the graph model, the nodes and edges (relationships) can be defined as the following. As Azure SQL graph uses Edge tables to represent relationships, in our demo, there are two edge tables to record the relationships between Alarm and Quality System, Quality System and Asset.

![Graph](images/graph09.png =300x)

After creating the graph model by using the [scripts](src\sql\Create-graph-table.sql), you'll be able to find the 'Graph Tables' shown as below:

![Graph](images/graph04.png)

To look up this graph database with nodes and edges, we use the new [MATCH](https://learn.microsoft.com/en-us/sql/t-sql/queries/match-sql-graph?view=sql-server-ver16) clause to match some patterns and traverse through the graph.

``` SQL
SELECT [dbo].[Alarm].Alarm_Type, [dbo].[Asset].Asset_ID
FROM [dbo].[Alarm], [dbo].[Asset], [dbo].[Quality_System], [dbo].[belongs_to], [dbo].[is_associated_with]
WHERE MATCH (Alarm-(belongs_to)->Quality_System -(is_associated_with)-> Asset)
```

#### Query JSON Data from Graph Table Node Properties

JSON is a popular textual data format that's used for exchanging data in modern web and mobile applications. JSON is also used for storing unstructured data in log files or NoSQL databases such as Microsoft Azure Cosmos DB.

JSON data in SQL Server enable you to combine NoSQL and relational concepts in the same database. Now you can combine classic relational columns with columns that contain documents formatted as JSON text in the same table, parse and import JSON documents in relational structures, or format relational data to JSON text.

The SQL engine supports JSON Data query and graph syntax can work with JSON query as well.
For example, we input the person details to the column (info) as JSON format. Then MATCH and JSON query can be used as a SQL search condition.

![Graph](images/graph02.png)
``` SQL
SELECT Restaurant.name
FROM Person_Info_Json_demo, likes_Json_demo, Restaurant
WHERE MATCH (Person_Info_Json_demo-(likes_Json_demo)->Restaurant)
AND JSON_value(Person_Info_Json_demo.info,'$.age') = '20';
```

Please refer to more information about [JSON data in SQL Database](https://learn.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver15):
- [ISJSON (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/functions/isjson-transact-sql?view=sql-server-ver15) tests whether a string contains valid JSON.
- [JSON_VALUE (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/functions/json-value-transact-sql?view=sql-server-ver15) extracts a scalar value from a JSON string.
- [JSON_QUERY (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/functions/json-query-transact-sql?view=sql-server-ver15) extracts an object or an array from a JSON string.
- [JSON_MODIFY (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/functions/json-modify-transact-sql?view=sql-server-ver15) changes a value in a JSON string.


#### Performance of SQL Engine Processing JSON Data
Azure SQL Database lets you work with text formatted as JSON. There are several ways to improve the performance. 

- Store JSON in [memory-optimized tables](https://learn.microsoft.com/en-us/sql/relational-databases/json/optimize-json-processing-with-in-memory-oltp?view=sql-server-ver16#store-json-in-memory-optimized-tables)

- [Validate the structure of JSON documents](https://learn.microsoft.com/en-us/sql/relational-databases/json/optimize-json-processing-with-in-memory-oltp?view=sql-server-ver16#validate) stored in memory-optimized tables by using natively compiled CHECK constraints.
- [Expose and strongly type values](https://learn.microsoft.com/en-us/sql/relational-databases/json/optimize-json-processing-with-in-memory-oltp?view=sql-server-ver16#computedcol) stored in JSON documents by using computed columns.
- [Index values](https://learn.microsoft.com/en-us/sql/relational-databases/json/optimize-json-processing-with-in-memory-oltp?view=sql-server-ver16#index) in JSON documents by using memory-optimized indexes.
- [Natively compile SQL queries](https://learn.microsoft.com/en-us/sql/relational-databases/json/optimize-json-processing-with-in-memory-oltp?view=sql-server-ver16#compile) that use values from JSON documents or that format results as JSON text.

### Incremental Data Load
As the architecture diagram shows, the system should only contextualize the new incoming data, not the whole data set in the delta table. Therefore, an incremental data loading solution is needed.

In delta lake, [Change Data Feed](https://learn.microsoft.com/en-us/azure/databricks/delta/delta-change-data-feed) is a feature to simplify the architecture for implementing CDC. Once CDF is enabled, as shown in the diagram below, the system records data change that includes inserted rows and two rows that represent the pre- and post-image of an updated row, so that we can evaluate the differences in the changes if needed. There is also a delete Change Type that is returned for deleted rows. Then to query the change data, we use the table_changes operation.

![cdf](images/cdf.jpeg)

In our solution, we enable the change data feed feature for delta tables which store the source data, by using the following command:
```
CREATE TABLE tbl_alarm_master 
  (alarm_id INT, alarm_type STRING, alarm_desc STRING, valid_from TIMESTAMP, valid_till TIMESTAMP)
	USING DELTA
	TBLPROPERTIES (delta.enableChangeDataFeed = true)
```
And running the following query can get the newly changed rows in the table (‘2’ is the commit version number):
```SELECT * from table_changes('tbl_alarm_master',2)```

If only newly inserted data is needed, we can use:
```
SELECT * from table_changes('tbl_alarm_master',2)
	WHERE _change_type = ‘insert’
```
For more samples, please refer to [Change Data Feed demo](https://docs.databricks.com/_extras/notebooks/source/delta/cdf-demo.html).

As you can see, we can leverage Change Data Feed feature to load the data incrementally. In order to get the last commit version number, we can store the relevant information into another delta table:
```
CREATE TABLE table_commit_version
	( table_name STRING, last_commit_version LONG)
	USING DELTA
```
Every time we load the newly added data in raw_system_1, we take the following steps:
* Get the last_commit_version in table_commit_version for table tbl_alarm_master
* Query and load the newly added data since last_commit_version
* Get the largest commit version number of table tbl_alarm_master
* Update last_commit_version in table table_commit_version for the next query

Please note that enabling CDF will not make significant impact for the system performance and cost. The change data records are generated in line during the query execution process, and are generally much smaller than the total size of rewritten files.

### Potential use cases

* A manufacturing solution provider would like to contextualize the master data and event data provided by its customers continuously. Since the context information is too complicated to be represented by relational tables, graph models are used for data contextualization.
* A process engineer in the factory needs to troubleshoot for an issue of the factory equipment. The graph model stores the all the related data, direct or indirect, of the troubleshooting equipment that can provide a overall information for root cause analysis. 

## Considerations

> REQUIRED STATEMENT: Include the following statement to introduce this section:

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?

> REQUIREMENTS: 
>   You must include the "Cost optimization" section. 
>   You must include at least two of the other H3 sub-sections/pillars: Reliability, Security, Operational excellence, and Performance efficiency.

### Reliability

> REQUIRED STATEMENT: If using this section, include the following statement to introduce the section:

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

> This section includes resiliency and availability considerations. They can also be H4 headers in this section, if you think they should be separated.
> Are there any key resiliency and reliability considerations (past the typical)?

### Security

> REQUIRED STATEMENT: If using this section, include the following statement to introduce the section:

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

> This section includes identity and data sovereignty considerations.
> Are there any security considerations (past the typical) that I should know about this?
> Because security is important to our business, be sure to include your Azure security baseline assessment recommendations in this section. See https://aka.ms/AzureSecurityBaselines

### Cost optimization

> REQUIRED: This section is required. Cost is of the utmost importance to our customers.

> REQUIRED STATEMENT: Include the following statement to introduce the section:

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

> How much will this cost to run? See if you can answer this without dollar amounts.
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?

> Link to the pricing calculator (https://azure.microsoft.com/en-us/pricing/calculator) with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

### Operational excellence

> REQUIRED STATEMENT: If using this section, include the following statement to introduce the section:

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

> This includes DevOps, monitoring, and diagnostics considerations.
> How do I need to think about operating this solution?

### Performance efficiency

> REQUIRED STATEMENT: If using this section, include the following statement to introduce the section:

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

> This includes scalability considerations.
> Are there any key performance considerations (past the typical)?
> Are there any size considerations around this specific solution? What scale does this work at? At what point do things break or not make sense for this architecture?

## Deploy this scenario

### Prepare relevant Azure services ??
### Create SQL Graph
As mentioned previously, we can use [sql script](src\sql\Create-graph-table.sql) to build the graph model.
### Create Tbl_alarm_master and Insert Dummy Data
Create tbl_alarm_master table which is the source data to be contextualized, and enable change data feed feature, so that we can load data incrementally.
```
%sql
CREATE TABLE tbl_alarm_master (alarm_id INT, alarm_type STRING, alarm_desc STRING, valid_from TIMESTAMP, valid_till TIMESTAMP) 
USING DELTA
LOCATION '/mnt/honeywell/raw/tbl_alarm_master'
TBLPROPERTIES (delta.enableChangeDataFeed = true)
```
Insert sample data into this table.
```
%sql
INSERT INTO tbl_alarm_master VALUES 
(1, "Carbon Monoxide Warning", "TAG_1", "2023-01-01 00:00:00.0000", "2999-12-31 23:59:59.0000"),
(2, "Fire Warning", "TAG_2", "2023-01-01 00:00:00.0001", "2999-12-31 23:59:59.0000"),
(3, "Flood Warning", "TAG_3",  "2023-01-01 00:00:00.0002", "2999-12-31 23:59:59.0000")
```

### Create Table_commit_version
Create table_commit_version so that we can record last commit version for each table.
```
%sql
CREATE TABLE table_commit_version (table_name STRING, last_commit_version LONG, updated_at TIMESTAMP)
USING DELTA
LOCATION '/mnt/honeywell/table_commit_version'
```
Insert one record into this table to set last_commit_version to 1.
```
%sql
INSERT INTO table_commit_version VALUES('tbl_alarm_master', 1, current_timestamp())
```

### Connect Azure SQL Database Using JDBC
Azure Databricks supports connecting to external databases using JDBC. It is necessary to connect SQL Graph with Azure Databricks for further operations.
```
jdbcUsername = "<Username>"
jdbcPassword = "<Password>"
jdbcHostname = "<Hostname>.database.windows.net"
jdbcPort = 1433
jdbcDatabase ="<DatabaseName>"

jdbc_url = f"jdbc:sqlserver://{jdbcHostname}:{jdbcPort};database={jdbcDatabase};user={jdbcUsername};password={jdbcPassword};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;"
```

You must configure a number of settings to read data using JDBC, and then get expected data by T-SQL query.

```
pushdown_query = "(SELECT a.Alarm_Type, b.Asset_ID\
                   FROM Alarm a, belongs_to, Asset b, is_associated_with, Quality_System c\
                   WHERE MATCH (a-(belongs_to)->c-(is_associated_with)->b)) as new_tbl2"

ala2ass = spark.read \
        .format("jdbc") \
        .option("url", jdbc_url) \
        .option("dbtable", pushdown_query).load()
```
Using the T-SQL query above, we can query the knowledge graph model to get the relationship between Asset and Alarm.

### Contextualize the Source Data
Using process_data method to contextualize source data tbl_alarm_master, adding information about asset.
```
def process_data(system): 
     # Get last_commit_version in table_commit_version for the data source table
    last_commit_version = spark.sql(f"select max(last_commit_version) as last_commit_version from table_commit_version where table_name='{system}'").collect()[0].asDict()['last_commit_version']

    # Get the max(_commit_version) from the table_changes
    max_commit_version = spark.sql(f"select max(_commit_version) as max_commit_version from table_changes('{system}',1)").collect()[0].asDict()['max_commit_version']
    
    # Query and process the newly added data since the last_commit_version
    df_tlb_change = spark.sql(f"select * from table_changes('{system}',{last_commit_version})")
    
    if(last_commit_version == max_commit_version + 1):
        return None
    
    df = spark.sql(f"select raw.alarm_id, raw.alarm_type, raw.alarm_desc, raw.valid_from, raw.valid_till,a.asset_id context_asset from table_changes('{system}',{last_commit_version}) raw left join ala2ass a on raw.alarm_type = a.alarm_type")
    
    max_commit_version = max_commit_version + 1
    
    # Update last_commit_version in table_commit_version for the data source table
    spark.sql(f"update table_commit_version set last_commit_version={max_commit_version} where table_name='{system}'")
    
    return df, df_tlb_change
```

### Write Data to the Relational Data Store
For simplicity, we save the contextualized data to the corresponding table in the SQL database.
```
df_alarm_master.write \
               .format("jdbc") \
               .option("url", jdbc_url) \
               .option("dbtable", "Tbl_Alarm_Master") \
               .mode("append") \
               .save()
```


## Contributors
*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors: 
 - [Anuj Parashar](https://www.linkedin.com/in/promisinganuj/) | Senior Data Engineer
 - [Chenshu Cai](http://linkedin.com/ProfileURL) | Software Engineer
 - [Bo Wang](https://www.linkedin.com/in/bo-wang-67755673/) | Software Engineer
 - [Hong Bu](https://www.linkedin.com/in/hongbu/) | Senior Program Manager
 - [Gary Wang](https://www.linkedin.com/in/gang-gary-wang/) | Principal Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> Link to Learn articles, along with any third-party documentation.
> Where should I go next if I want to start building this?
> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful? Are there product documents that go into more detail on specific technologies that are not already linked?

Examples:
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Machine Learning documentation](/azure/machine-learning)
* [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
* [What is Language Understanding (LUIS)?](/azure/cognitive-services/luis/what-is-luis)
* [What is the Speech service?](/azure/cognitive-services/speech-service/overview)
* [What is Azure Active Directory B2C?](/azure/active-directory-b2c/overview)
* [Introduction to Bot Framework Composer](/composer/introduction)
* [What is Application Insights](/azure/azure-monitor/app/app-insights-overview)
 
## Related resources
* [Graph processing with SQL Server and Azure SQL Database](https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-overview?view=sql-server-ver16)
* [Use Delta Lake change data feed on Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/delta/delta-change-data-feed) 
* [How to Simplify CDC With Delta Lake's Change Data Feed](https://www.databricks.com/blog/2021/06/09/how-to-simplify-cdc-with-delta-lakes-change-data-feed.html)
