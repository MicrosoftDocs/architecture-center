# Use the best data store for the job

Gone are the days when you would shove all of your data into a big SQL database. 
Relational databases are very good at what they do &mdash; providing ACID guarantees for transactions over relational data. But they come with some costs:

- Queries may require expensive joins
- Data must be normalized and conform to a predefined schema ("schema on write")
- Lock contention may impact performance

Alternatives to relational databases include key/value stores, document databases, search engine databases, time series databases, and graph databases. Each has pros and cons, and different types of data fit more naturally into one or another. 

For example, you might store a product catalog in a document database, such as DocumentDb, which allows for a flexible schema. In that case, each product description is a self-contained document. For queries over the entire catalog, you might index the catalog and store the index in Azure Search. Product inventory might go into a SQL database, because that data requires ACID guarantees.

Remember that data includes more than just the persisted application data. It also includes application logs, events, messages, and caches.

## Recommendations

**Don’t use SQL for everything**. Use SQL for what it’s good for, but consider other data stores when appropriate. 

**Embrace polyglot persistence**. In any large solution, it’s likely that a single data store technology won’t fill all of your needs. 

**Consider the type of data**. For example, put transactional data into SQL, put JSON documents into a document database, put telemetry data into a time series data base, put application logs in Elasticsearch.

**Consider the skill set of the development team**. There are advantages to using polyglot persistence, but it's possible to go overboard. Adopting a new data storage technology requires a new set of skills. The development team must understand how to get the most out of the technology. They must understand appropriate usage patterns, how to optimize queries, tune for performance, and so on. Factor this in when considering storage technologies. 

**Use compensating transactions**. A side effect of polyglot persistence is that single transaction might write data to multiple stores. If something fails, use compensating transactions to undo any steps that already completed.

**Look at bounded contexts**. *Bounded context* is a term from domain driven design. A bounded context contains a unified domain model that applies to a subdomain of the application. The bounded contexts in your system are a natural place to consider polyglot persistence, because each context has its own responsibilities and requirements. 
