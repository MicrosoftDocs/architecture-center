Have you ever been the victim of online fraud? If so, the chances are that a thief made multiple transactions leading to a loss of thousands. That is why fraud detection must happen in near real-time. With over 800+ million people using mobile apps today, mobile bank fraud increases dramatically. The financial industry is seeing a 100% year-over-year increase in losses due to access from mobile platforms. But there is mitigation: with Azure technology, we've created a solution to predict a fraudulent transaction within 2 seconds. This document provides guidance on how to architect a solution in Azure for detecting mobile bank fraud; it is based on a solution developed for a Microsoft customer in the banking industry.

## Problem: Needle in a haystack, rigid rules

Most mobile fraud occurs by compromising a device using a "SIM swap attack", in which a mobile number is hacked. The phone number is cloned and the criminal receives all the SMS notifications and calls sent to the victim's mobile device. Then login credentials are obtained through social engineering, phishing, vishing (using a phone to phish), or an infected downloaded app. With this information, the criminal can impersonate a bank customer, register for mobile access, and immediately generate fund transfers and withdrawals. 

Mobile fraud is hard to detect and expensive for consumers and banks. The first challenge is that it is rare. Less than 1% of all transactions are fraudulent, which means it can take a lot of time for a fraud or case management team to sift through a pile of potentially fraudulent transactions to identify the genuinely fraudulent ones. A second challenge is that many fraud monitoring solutions today still rely on rule-based engines. Traditionally, rule-based engines have been very effective at detecting established patterns of fraud-like transactions generated from risky IP addresses or multiple transactions generated within a brief period on a brand-new account. But rule-based engines have one significant limitation in today's criminal environment: rules do not adapt quickly to new or evolving types of attacks. They have the following constraints:

- Detection is not real-time, so fraud is detected after a financial loss occurs. 
- Rules are binary and limited; they cannot accommodate the complexity and combinations of input variables that can be evaluated. This results in high false positives. 
- Rules are hardcoded into business logic. Curating the rules, incorporating new data sources, or adding new fraud patterns usually means application changes that impact a business process.  Propagating changes throughout a business process can be cumbersome and expensive.

Artificial intelligence (AI) models can dramatically improve fraud detection rates and detection times, and banks are using them in combination with other approaches to reduce losses. The process described here is based on three factors:
- an AI model that acts on a derived set of behavioral characteristics
- a methodology for machine learning
- a model evaluation process similar to the one used by a fraud manager to evaluate his / her portfolio

## Operational context

For this bank client, as customers were increasing their use of digital services, there was a spike in fraud across the mobile channel. It was time to re-think their fraud detection and prevention approach. This solution started with questions that would impact their fraud process and decisions:*Which activities or transactions are likely fraudulent?  Which accounts are compromised? Which activities need further investigation and case management?*

For a solution to deliver value, there must be a clear understanding of how mobile bank fraud becomes evident in the operational environment: *What kinds of fraud are perpetuated on the platform? How is it being committed? What are the patterns in fraudulent activities and transactions?*

The answers to these questions led to an understanding of the type of behavior that could signal fraud. Data attributes were mapped to the messages collected from the mobile application gateways with the behaviors identified. Account behavior most relevant for determining fraud could then be profiled.

The table below identifies the types of compromise, data attributes that could signal fraud, and behaviors that were relevant for this bank:
 
|  |Credential compromises*  |Device compromises  |Financial compromises  |Non-Transactional compromises|
|---------|---------|---------|---------|---|
|What methods are used?     | Phishing, vishing        |   SIM swap, Vishing, Malware, Jail braking, Device emulators      |   Requires knowledge about account credentials, device, and user digital identifiers (email, address, etc.)      |Adding new users to account, bumping up card or account limits, changing account details and customer profile information, or password|
|What data?     | Email ID/password, credit/debit card numbers, PINs (either customer-selected or one-time-pins)        |  Device ID, SIM card number, Geolocation, and IP       |   Transaction amounts, transfer/withdrawal/payment beneficiaries      |Account details|
|What are some of the patterns?     | New digital customer (not previously registered) with an existing card and PIN. <br><br> Failed logins for users that do not exist or are unknown.<br><br>Logins during timeframes that are not usual for this account.<br><br> Multiple attempts to change login passwords |  Geographical irregularities (access from an unusual location).<br><br>Access from multiple devices in a short period of time.|There are patterns in the transactions. For instance, many small transactions are logged for the same account in a short time, sometimes followed by a large withdrawal, or payments, withdrawals, or transfers made for maximum allowable amounts.<br><br>Unusual frequency in transactions.|   There are patterns in the logins and sequence of activities. For instance, multiple logins within a short period, multiple attempts to change contact information, add devices within an unusual time frame. |

\* Most common indicator of compromise and precedes financial and non-financial compromises

Table 1 Four pillars of compromise

The behavioral dimension is critical for detecting mobile fraud. Behavioral based profiles can help establish typical behavior patterns for an account, and the analytics can alert to an activity that appears to be out of the norm. Below are examples of types of behavior that were profiled: 
- How many accounts are associated with this device?
- How many devices are associated with this account? And how frequently are they dropped or added?
- How frequently does this device or customer login?
- How often does this customer change passwords?
- What is the average monetary transfer or withdrawal amount from this account?
- How often are withdrawals made from this account?

This solution used an approach based on:
- Feature engineering to create behavioral profiles for customers and accounts
- Azure machine learning to create a fraud classification model for suspicious or inconsistent account behavior
- Azure services for real-time event processing and end-to-end workflow

## High-level architecture

There are three workstreams in this architecture:
- An event-driven pipeline that ingests and processes log data, creates and maintains behavioral account profiles, incorporates a fraud classification model, and produces a predictive score
- A model training workstream that combines on-premises historical fraud data and ingested log data
- Functionality to integrate back-end business processes

The diagram below illustrates the placement for each of the significant technology components.

diagram 

Figure 1 Conceptual Architecture for Online Bank Fraud Detection

download link 

The solution integrates with the bank's on-premises environment using an Enterprise Service Bus (ESB) and a performant network connection. 

Most steps in the event processing pipeline start with an [Azure Function](https://azure.microsoft.com/services/functions). Azure Functions were selected because they are serverless, easily scaled out, and scheduled. The primary workload requires processing millions of incoming mobile transactions and assessing them for fraud in near real-time. 

A second workload is batch-oriented and used for model training and re-training. Azure Data Factory orchestrates the processing steps, including:

- Upload of labelled historical fraud data from on-prem sources
- Archival of data feature sets and score history for all transactions
- Extraction of events and messages into a structured format for feature engineering, model re-training and evaluation, and 
- Training and re-training of a fraud model using [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning).

And finally, the 3rd workstream involves integration to backend business processes. In the diagram, this is represented with [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps). Logic Apps can be used to connect and synchronize to an on-premises system to create a fraud management case, suspend account access, or to generate a phone contact.

Central to this architecture is the data pipeline and AI model, which are discussed in more detail below.

### Data pipeline and automation 

Once a criminal has access to a bank account through a mobile app, financial loss can occur in minutes. Effective detection of fraud activity must occur while the criminal is interacting with the mobile application and before a monetary transaction has occurred. The time it takes to react to a fraudulent transaction directly influences how much financial loss can be prevented. The sooner the detection takes place, the less the financial loss.

Less than two seconds and – ideally - a lot less. That's the maximum amount of time between when a mobile banking activity gets forwarded for processing and when it needs to be assessed for fraud. Two seconds to collect a complex JSON event, validate, authenticate, parse, and transform the JSON, create account features from the data attributes, submit the transaction for an inferencing, retrieve the fraud score, and synchronize with a backend case management system. Latency and response times are critical in a fraud detection solution, and the infrastructure to support it must be fast and scalable.

### Event processing

Telemetry events from the bank's mobile and internet application gateways are formatted as JSON files with a loosely defined schema. These events are streamed as application telemetry to [Azure Event Hub](/azure/event-hubs/event-hubs-about) where an Azure Function in a dedicated App Services Environment (ASE) is used to orchestrate the processing.

The diagram below illustrates the fundamental interactions for an Azure Function within this infrastructure, which includes:

- Ingest raw JSON events payload from Azure Event Hubs and authenticate using an SSL certificate retrieved from [Azure Key Vault](https://azure.microsoft.com/services/key-vault).
- Coordinate the deserialization, parsing, storing, and logging of raw JSON messages in [Azure Data Lake](https://docs.microsoft.com/azure/architecture/data-guide/scenarios/data-lake) and user financial transaction history in [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview).
- Update and retrieve User account and device profiles from Azure SQL Database, and Azure Data Lake.  
- Call out to Azure Machine Learning endpoint to execute a predictive model and obtain a fraud score. Persist the inferencing result to a data lake for Operational Analytics
- Power BI connects to data lake via Azure Synapse Analytics for a real-time operational analytics dashboard with Power BI.
- Post the scored results as an event to an on-premises system for further fraud investigation and management activity.

image 

link? 

Figure 2 Azure Function Processing Infrastructure

### Data Pre-Processing & JSON Transformation

Pre-processing the data was an integral step in formatting the data for development and training of the machine learning models. There were years of historic mobile and internet banking events including transaction data from the application gateway telemetry in JSON format. There were hundreds of thousands of files that contained multiple events that had to be deserialized and flattened and cleaned for the purpose of training the machine learning model.

Each of the application gateways produces telemetry from a user's interaction, capturing information like the OS, mobile device metadata, account data, and transaction requests and responses. A lot of variation existed between JSON files and attributes and data types were disparate and inconsistent. Another complication with the JSON files was that attributes and data types could change unexpectedly as application updates were pushed out to the gateways and features were removed, modified, or added. Data transformation challenges with the schemas include: 

- A JSON file may include one or more mobile phone interactions; each interaction needs to be extracted as a separate message
- Fields may be named or represented differently
- Characters like new lines or carriage returns are embedded inconsistently within messages
- Attributes like email addresses may be missing or partially formatted, 
- Complex, nested properties and values

A Spark pool was used as part of the cold path to process historical JSON files, deserialize, flatten, and extract device and transaction attributes. Each JSON file was validated, parsed, and the transaction attributes extracted and persisted onto a data lake and partitioned based on the date of the transaction.  

These attributes are used later to create features for the fraud classifier. The power of data in this solution is because the JSON data can be standardized, joined, and aggregated with historical data to create behavior profiles.

### Near real-time data processing & featurization using Azure SQL DB

In this solution events are produced from multiple sources including authentication records, customer information and demographics, transaction records, and log and activity data from mobile devices. In For this solution Azure SQL Database was used to perform real-time data parsing, pre-processing, and featurization because SQL was the skill set most familiar to the bank developers. Within Azure SQL Database, the Hybrid Transaction/Analytical Processing (HTAP) capabilities were used including: 

- [Memory-Optimized Tables]() were used to store the account profiles. Memory-optimized tables have advantages over traditional SQL tables because they are created and accessed in the main memory. The latencies and overhead of disk access are avoided. This requirement for this solution was to process 300 JSON messages/second and memory-optimized tables provided for this level of throughput.
- Memory-optimized tables are most efficiently accessed from [natively compiled stored procedures](/sql/relational-databases/in-memory-oltp/natively-compiled-stored-procedures). Unlike interpreted stored procedures, natively compiled stored procedures are compiled when they are first created.
- A [temporal table](/azure/sql-database/sql-database-temporal-tables) is a feature that automatically maintains change history in a table. A row is added or updated is versioned and written to the history table. In this solution, the account profiles were stored in a temporal table, created with a 7-day retention policy, so rows were automatically removed when they exceeded the retention period.

HTAP functionality is a necessity when retrieving user account behavior history for a particular device over the last 7 days in order to calculate features in near real-time with low latency.

This approach also provided the customer with the added benefits of:
- Access to archived data for Operational Analytics and ML Model retraining and Fraud validation 
- Simplified data archiving to long-term storage.
- Scalability thru sharding data and using an elastic database.

### Event schema management 

How can schema management be automated? JSON is a very flexible and portable file format and one of the reasons for this is that a schema is not stored with the data. When JSON files need to be parsed, deserialized, and processed a schema must be coded somewhere that represents the structure of the JSON to validate the data properties and datatypes. If the schema is not synchronized with the incoming JSON message, the JSON validation fails and data is not extracted.

The challenge comes when the structure of JSON messages changes because of new application functionality. In the original solution, the bank deployed multiple application gateways, each with their own UI, functionality, telemetry, and JSON message structure. When the schema was out-of-sync with the incoming JSON data, the inconsistencies created data loss and processing delays for fraud detection.

The bank did not have any formal Schema defined for these events and the constant fluctuations in the structure of the JSON files created technical debt at each iteration of the solution. The recommendation to the customer was to establish a schema for these events and consider making use of Azure Schema Registry. [Azure Schema Registry](/azure/event-hubs/schema-registry-overview) provides a central repository of schemas for events and provides flexibility for producers and consumer applications to **exchange data without having to manage and share the schema**. The simple governance framework it introduces for reusable schemas and the relationship it defines between schemas through the grouping constructs (schema groups) will eliminate a lot of the technical debt, enforce conformance, and provide backward compatibility across changing schemas.

### Feature Engineering for Machine Learning

Features are a way to profile account behavior by aggregating activity over different time scales. They are created from data in the application logs representing transactional, non-transactional, and device behavior. Transactional behavior includes monetary transaction activities like payments or withdrawals. Non-transactional behavior includes user actions like login attempts or password changes. Device behavior includes activities that involve a mobile device, like adding or removing a device. Features were constructed to represent current and past account behavior, including

- New user registration attempts from a specific device
- Successful/unsuccessful login attempts
- Requests to add 3rd party payees or beneficiaries
- Requests to increase account or credit card limits
- Password changes

An account profile table was created with attributes from the JSON transaction like Message-ID, Transaction Type, Payment Amount, day-of-week, hour-of-the-day. Activities were aggregated across multiple timeframes like an hour, day, 7-days and stored as a behavior history for each account. Each row in the table represented a single account. Examples of some of the features include:

image 

Table 2 Feature set

Once the account features are calculated and the profile updated, an Azure function makes a call to the machine learning model for scoring via a REST API to answer the question: *What is the probability this account is in a state of fraud based on the behavior we have seen up till now?*

## AutoML

In this solution [Azure AutoML](/azure/machine-learning/concept-automated-ml) was chosen because of speed and ease of use. Azure AutoML can be a useful starting point for quick discovery and learning because it does not require specialized knowledge or setup. Azure AutoML automates the time-consuming, iterative tasks of machine learning model development. It allows data scientists, analysts, and developers to build ML models with high scale, efficiency, and productivity all while sustaining model quality. 

AutoML can perform the following tasks in an ML process:
- Split data into Train/Validation data sets
- Optimize training based on a chosen metric
- Perform Cross Validation
- Feature generation
- Impute missing values
- Perform one-hot encoding as well as a variety of scalers
 
### Data Imbalance

Fraud classification is challenging because of the severe class imbalance. In a fraud dataset there are many more non-fraud transactions than fraudulent transactions.  Typically, less than 1% of the data set contains fraud transactions. Unless it is addressed, this imbalance between fraud/non-fraud transactions can cause a credibility problem with the model because all transactions could end up classified as non-fraud. It means the model completely misses all the fraud transactions but still achieves a 99% accuracy rate. A highly accurate model that does not detect fraudulent transactions is unacceptable.

To redistribute data and create a better balance between fraud and non-fraud transactions, Azure AutoML has built-in capabilities to help:  

- AutoML supports a column of weights as input causing the rows in the data to be weighted up or down, which can make a class less important. The algorithms used by AutoML detect imbalance when the number of samples in the minority class is equal to or fewer than 20% of the number of samples in the majority class.  Subsequently, AutoML will run an experiment with sub-sampled data to check if using class weights would remedy this problem and improve performance. If it ascertains a better performance through this experiment, then this remedy is applied.
- Use a performance measurement metric that deals better with imbalanced data; for instance, if your model needs to be sensitive to false negatives use Recall, or when the model needs to be sensitive to false positives use Precision. An F1-Score can also be used which is the harmonic mean between precision and recall, thus not effected by a high number of true positives or true negatives.  Keep in mind some metrics may need to be calculated manually during your testing phase.

Alternatively, to increase the number of fraud transactions, you can manually use a technique called Synthetic Minority Oversampling Technique (SMOTE) can be used. SMOTE is a statistical technique that uses bootstrapping and k-nearest neighbor (KNN) to produce instances of the minority class.

### Model Training

For model training, the Python SDK expects data in either a pandas dataframe format or as an Azure Machine learning tabular dataset.  The value to predict needs to be in the dataset, and the y column is passed in as part of the parameters when creating the training job.  In the code (sample image below):

1. Load the data set into an Azure tabular dataset or pandas dataframe
1. Split the dataset into 70% training 30% validation
1. Create a variable with the column we would like to predict
1. Begin the AutoML parameters creation
1. Configure AutoMLConfig
   1. Task is the type of ML you would like to do, Classification or Regression, in our case classification
   1. Debug_log is the location to write the debug information to
   1. Training_data is the dataframe or tabular object of the training data was loaded into
   1. Label_column_name is the column you would like to predict
1. And lastly the actual execution of the ML job. 

Comments are in line in the code:

image 

Figure 3 AzureML Code snippet

### Model evaluation 

A ‘good’ model is one that produces realistic and actionable results and that is one of the challenges with a fraud detection model. Most fraud detection models produce a binary decision to answer the question: Is this a fraudulent transaction (Y/N)? The decision is based on two factors; (1) a probability score between 0-100 returned by the classification algorithm and, (2) a probability threshold pre-established by the business; above the threshold the transaction is considered fraudulent, below the threshold the transaction is considered non-fraudulent. While probability is a standard metric for any classification model, it is typically insufficient in a fraud scenario for a business to decide to block an account to prevent further losses.

For this solution, account level metrics were created and factored into the decision on whether the business should act to block an account. The account level metrics were defined based on industry standard metrics described in the table below:


|Fraud manager cares about…  |Metric  |Description  |
|---------|---------|---------|
|Am I detecting fraud?     |    Fraud Account Detection Rate (ADR)     |   The percentage of detected fraud accounts in all fraud accounts.      |The percentage of monetary savings, assuming the current fraud transaction triggered a blocking action on subsequent transactions, over all fraud losses.
|How much money am I saving (loss prevention)? How much will a delay to react to an alert cost?     |      Value Detection Rate (VDR)   |  The percentage of monetary savings, assuming the current fraud transaction triggered a blocking action on subsequent transactions, over all fraud losses.  |
|How many good customers am I inconveniencing?     |   Account False Positive Ratio (AFPR)      |      How many non-fraud accounts get flagged for every real fraud detected (per day)? The ratio of detected false positive accounts over detected fraud accounts.        |

Table 3 Industry standard fraud detection metrics

These metrics are valuable data points for a fraud manager and are used to get a more complete picture of the account risk and decide on remediation. 

### Model operationalization and retraining

Predictive models need to be updated periodically. Over time - and as new and different data becomes available - a predictive model will need to be re-trained to continue to be effective. This is especially true for fraud detection models where new patterns of criminal activity are frequent, requiring a model to be updated to learn the new patterns. It also becomes necessary when the telemetry from mobile application logs change due to modification pushed out to the application gateway. To provide for re-training in this solution, every transaction submitted for analysis and the corresponding model evaluation metrics were logged. Over time, the model performance was monitored; and when it appeared to degrade, a re-training workflow was triggered. In this solution, several different Azure services were introduced into the re-training workflow:

- [Azure Synapse Analytics](/azure/architecture/data-guide/relational-data/data-warehousing) or Azure Data Lake can be used to store historical customer data and known fraudulent transactions uploaded from on-premises sources as well as data archived from the AML web service including transactions, predictions, and model evaluation metrics. The data needed for retraining is stored in this data store.
- [Azure Data Factory](/azure/data-factory/introduction) or [Synapse Pipelines](/azure/data-factory/concepts-pipelines-activities?tabs=data-factory) can be used to orchestrate the data flow and process for retraining including the extraction of historical data and log files from on-premises systems, the JSON deserialization process, and data pre-processing logic.  A detailed reference for how to use Azure Data Factory for model re-training is available in [Retraining and Updating Azure Machine Learning models with Azure Data Factory](https://azure.microsoft.com/en-us/blog/retraining-and-updating-azure-machine-learning-models-with-azure-data-factory).
- Blue Green deployments can be used in Azure Machine learning using "[Safe rollout for online endpoints](/azure/machine-learning/how-to-safely-rollout-managed-endpoints)" easing you rollout if a new model with minimal downtime.

## Technical Considerations 

Selecting the right technology components for a 24*7, cloud-based infrastructure for fraud detection depends on understanding current—and sometimes vague—requirements. The technology choices for this solution were based on considerations that may be helpful to guide similar decisions.

### Skill Sets

What are the current technology skill sets for the teams designing, implementing, and maintaining the solution? Cloud and AI technologies expand the choices available for implementing a solution. For this project, the current skill set of the team was an important consideration and had a direct impact on the technology chosen for implementation. For example, the team had basic data science skills so the decision to use Azure Machine Learning was made for model creation and endpoint. Another decision influenced by team skills was the decision to use Event Hubs. Event Hubs is a managed service that is easy to set up and maintain. And while there were technical advantages for an alternative decision using Kafka, it would have required an investment in re-training.

### Hybrid Operational Environment

The deployment for this solution spanned the bank’s on-premises environment and the Azure environment. Services, networks, applications, and communication had to work effectively across both infrastructures to support the workload. The technology decisions included:
- How will environments be integrated?
- What are the network connectivity requirements between the Azure datacenter and the bank’s on-premises infrastructure? ExpressRoute was adopted because it provided dual lines, redundancy, and failover. Site-to-site VPN did not provide the security or Quality-of-Service (QoS) needed for the workload.
- How will fraud detection scores integrate with the bank’s backend systems? Scoring responses should integrate with backend fraud workflows to automate verification of transactions with customers or other case management activities. Integration from Azure services to the on-premises bank systems can be done with either Azure Functions or Logic Apps.

### Security

Hosting a solution in the cloud brings with it new security responsibilities.  In the cloud, security is a shared responsibility between a cloud vendor and a customer tenant and workload responsibilities vary depending on whether the workload being hosted is SaaS, PaaS, or an IaaS service.  The shared responsibility model is described here: [Shared Responsibility in the cloud](/azure/security/fundamentals/shared-responsibility).  

Whether you are moving towards a [Zero Trust](https://www.microsoft.com/security/business/zero-trust) approach or working to apply regulatory compliance requirements, securing a solution end-to-end requires careful planning and consideration.  In design and deployment, our recommendation is to adopt the security principles that are consistent with a Zero Trust approach.  Adopting principles like verify explicitly, use least privilege access, and assume breach will strengthen workload security. 

**Verify Explicitly** means to examine and assess many different aspects of an access request and includes considerations like:
- Use a strong identity platform like Azure Active Directory. 
- Understand the security model for each of the cloud services and how data and access are secured
- When possible, control access to cloud services using Managed Identity and Service Principles 
- Store keys, secrets, certificates, and application artifacts like database strings, REST endpoint URLs, and API keys in Key Vault.

**Use Least Privilege Access** helps ensure permissions are granted only to meet specific business needs from an appropriate environment to an appropriate client and includes considerations like 
- Compartmentalize the workload by limiting how much access a component or resource has through role assignments or network access,
- Disallow public access to endpoints and services and use private endpoints to protect your services unless your service requires public access, 
- Secure service endpoints through firewall rules or isolate to VNET(s).
 
**Assume Breach** is a strategy to guide design and deployment decisions and assumes a solution has been compromised. It is an approach to build resilience into a workload by planning for detection, response to, and remediation of a security threat. For design and deployment decisions it implies (1) workload components are isolated and segmented so a compromise of one component minimizes impact to upstream or downstream components, (2) telemetry is captured and analyzed for proactively to identify anomalies and potential threats, and (3) automation is in place to detect, respond, and remediate a threat.  Examples of capabilities to consider:

- Encrypt data at rest and in transit,
- Enable auditing for services
- Capture and centralize audit logs and telemetry into a single log workspace to facilitate analysis and correlation, 
- Enable [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) to scan for potentially vulnerable configurations and provide early warning to potential security issues.

Networking is one of the most important roles in terms of security practices. By default, Synapse workspace endpoints are public endpoints which means they can be accessed from any public network, so it is strongly recommended to disable public access to the workspace. Consider deploying Synapse with the Managed VNet feature enabled to add a layer of isolation between the workspace and other Azure services.  More information about Managed VNet and other security protections are  here: [Azure Synapse Analytics security white paper: Network Security](/azure/synapse-analytics/guidance/security-white-paper-network-security).

image 

Figure 4 Network considerations

For the Bank Fraud architecture, security guidance specific to each of the solution components is included in the table below. For a good starting point, review the [Azure Security Benchmark](/security/benchmark/azure/introduction) which includes security baselines for each of the individual Azure services.  The security baseline recommendations will help in selecting the security configuration settings for each of the services.


|  |Event Hub Clusters  |Key Vault  |ADLS Gen2  |Azure Synapse Analytics Workspace: Spark Pools |Azure SQL|Azure Functions|
|---------|---------|---------|---------|---|---|---|
|**Data Protection**     |         |         |         ||
|  - [Encryption at rest](/azure/security/fundamentals/encryption-atrest)   |  Built-in       |     Built-in    |   Built-in      |Built-in|Built-in|Built-in|
|   - [Encryption in transit](/azure/security/fundamentals/encryption-overview#encryption-of-data-in-transit)  |     TLS 1.2    |  TLS 1.2       |     TLS 1.2    |TLS 1.2|TLS 1.2, [Configure Clients to connect securely to SQL DB](/azure/azure-sql/database/security-best-practice#network-security)|[Enforce TLS 1.2](/azure/azure-functions/security-concepts?tabs=v4#require-https)|
|  - Data classification   |         |         |  [Purview](/azure/purview/concept-classification)       ||[Purview](/azure/purview/concept-classification) or [SQL Data Discovery and Classification](/azure/azure-sql/database/data-discovery-and-classification-overview)||
|  **Access Control**  |   [Azure AD RBAC, SAS](/azure/event-hubs/authorize-access-event-hubs)      |   [Azure AD RBAC](/azure/key-vault/general/security-features#access-model-overview), [Conditional access](/azure/key-vault/general/security-features#conditional-access)      |     [RBAC (coarse grained), ACL (fine grained), SAS, Shared Access Keys](/azure/storage/blobs/data-lake-storage-access-control-model)|[Synapse RBAC](/azure/synapse-analytics/security/synapse-workspace-synapse-rbac)   |[SQL RBAC, Separation of Duties](/azure/azure-sql/database/security-best-practice#access-management)|[Azure RBAC](/azure/role-based-access-control/overview), [Function and Host Keys](/azure/azure-functions/security-concepts?tabs=v4#authorization-scopes-function-level), [Endpoints](/azure/azure-functions/security-concepts?tabs=v4#authenticationauthorization)|
|   **Authentication**  |         |   [Azure AD options](/azure/key-vault/general/security-features#key-vault-authentication-options)      |     [Azure AD, AAD security group recommended as assigned principal](/azure/storage/blobs/data-lake-storage-access-control-model#security-groups)    |[Azure AD, MFA, Managed Identity](https://docs.microsoft.com/en-us/azure/synapse-analytics/guidance/security-white-paper-authentication)|[Use Azure AD for Authentication](/azure/azure-sql/database/authentication-aad-overview)|Use [Managed Identity](/azure/azure-functions/security-concepts?tabs=v4#managed-identities) both user-assigned and system assigned are supported |
|  **Logging and monitor**   |   [Monitor Event Hubs](/azure/event-hubs/monitor-event-hubs)      |  [Monitor Key Vault](/azure/key-vault/general/monitor-key-vault) and [Logging](/azure/key-vault/general/logging)       |  [Monitor Azure Blob Storage](/azure/storage/blobs/monitor-blob-storage)       |[Enable logging/ diagnostic settings](/azure/synapse-analytics/monitoring/how-to-monitor-using-azure-monitor#diagnostic-settings)|[Monitoring, Logging, and Auditing](/azure/azure-sql/database/security-best-practice#monitoring-logging-and-auditing)|[Log and monitor](/azure/azure-functions/security-concepts?tabs=v4#log-and-monitor)|
|   **Protection and detection**  |         |         |         ||||
|  - Azure Security Baseline   |    [Event Hubs](/security/benchmark/azure/baselines/event-hubs-security-baseline)     |    [Key Vault](/security/benchmark/azure/baselines/key-vault-security-baseline)     |        [Azure Storage](/security/benchmark/azure/baselines/storage-security-baseline) |[Synapse Analytic Workspace](/security/benchmark/azure/baselines/synapse-analytics-workspace-security-baseline)|[Azure SQL Database](/security/benchmark/azure/baselines/sql-database-security-baseline#identity-management)|[Azure Functions](/security/benchmark/azure/baselines/functions-security-baseline)|
| - Recommended Security Practices    |         |[Key Vault](/azure/key-vault/general/best-practices)         |  [Azure Storage](/azure/storage/blobs/security-recommendations)       |[Azure Synapse Analytics Security Whitepaper](/azure/synapse-analytics/guidance/security-white-paper-introduction)|[Playbook for Common Security Requirements](/azure/azure-sql/database/security-best-practice#network-security)|[Securing Azure Functions](/azure/azure-functions/security-concepts)|
|   - Monitor security posture and configuration with Defender for Cloud   |      Yes   |Yes         |Yes         |Yes|Yes|Yes|
| - Advanced threat detection     | No native service. Customer option to forward logs to log analytics workspace/Sentinel.         |   [Defender for Key Vault](/azure/defender-for-cloud/defender-for-storage-introduction)      |    [Defender for Storage](/azure/defender-for-cloud/defender-for-storage-introduction)    |No native service. Customer option to forward logs to log analytics workspace/ Sentinel. |[Defender for SQL](/azure/azure-sql/database/azure-defender-for-sql)|No native service. Customer option to forward logs to log analytics workspace/ Sentinel.|

Table 4 Security Features and References

For more information, see [Zero Trust Deployment Guides](/security/zero-trust).

### Scalability

Will the solution perform end-to-end through peak times? A streaming workflow to handle millions of continuously arriving events demands incredible throughput. Plan to build a test system to simulate the volume and concurrency to ensure the technology components are configured and tuned to meet the required latencies. Scalability testing was especially important for these components: 

- Data ingestion to handle concurrent data streams. In this architecture, Event Hub was selected because multiple versions of it could be deployed and assigned to different consumer groups. A scale-out approach turned out to be a better option because scaling-up could cause locking. The scale-out approach also was a better fit with plans to expand fraud detection from mobile banking to include the internet banking channel.
- A framework to manage and schedule the process flow. Azure Functions were used to orchestrate the workflow. With this scenario, the best throughput was found when messages were batched up in micro batches and processed through a single azure function rather than a configuration set up to process 1 message per function call.
- A low-latency data process to handle parsing, pre-processing, aggregations, and storage. In this solution, the capabilities of in-memory optimized SQL functions met the scalability and concurrency requirements.
- Model scoring to handle concurrent requests. With Azure Machine Learning Web Services there are two options for scaling; (1) select a production web tier to support the API concurrency workload, or (2) add multiple endpoints to a web service if there is a requirement to support more than 200 concurrent requests.

### Technologies presented
  
The glossary is an index of terms, patterns, and technologies used in the article and relating to the scenario.
- [Azure Functions](https://azure.microsoft.com/services/functions)
- [Azure Event Hub](/azure/event-hubs/event-hubs-features)
- [Azure Key Vault](/azure/key-vault/general/overview)
- [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Azure AutoML](/azure/machine-learning/concept-automated-ml)
- [Azure SQL Database]()
- [Azure Synapse Analytics]()

## Additional Links

- [A fast, serverless, big data pipeline powered by a single Azure Function](https://azure.microsoft.com/blog/a-fast-serverless-big-data-pipeline-powered-by-a-single-azure-function)
- [Considering Azure Functions for a serverless data streaming scenario](https://azure.microsoft.com/blog/considering-azure-functions-for-a-serverless-data-streaming-scenario)
- [Networking considerations - Azure App Service Environment](/azure/app-service/environment/network-info)

## Related resources

- [Performance and scale guidance for Event Hubs with Azure Functions](/azure/architecture/serverless/event-hubs-functions/performance-scale)
- [Monitor Azure Functions and Event Hubs](/azure/architecture/serverless/event-hubs-functions/observability)