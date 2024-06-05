This reference architecture describes how to modify and harden a [medallion lakehouse](/azure/databricks/lakehouse/medallion) as the system is adopted across an enterprise. 

Following a typical adoption pattern, as shown in the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml), the architecture provided in this article is hardened to meet additional non-functional requirements (NFRs), provide additional capabilities, and shift user and operator responsibilities to a domain-based federated model.  

This architecture reflects [Microsoft's Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) for best practice and guidance, specifically for the implementation of [data domains](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-domains) and the adoption of [data products](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-landing-zone-data-products). 

>[!NOTE]
>The guidance provided in this article is limited to key differences from the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml). 

## Context and key design decisions

As described in the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml), Consoto operates a medallion lakehouse that supports their first data workloads for the financial department. Consoto has decided to harden this system and extend it to support the enterprise analytical data needs, providing a data science capability and self-service functionality.   

### Key requirements
- The Solution MUST be hardened to operate as an enterprise data and analytics platform and extended to support other corporate functions, while adhering to Consoto's data access policy requirements.  
- The Platform MUST be able to ingest, store, process, and serve data in near-real time. The performance target is defined as a sub-one minute processing time from ingestion to being available in the reporting layer.
- The Platform MUST deliver economy of scale savings and efficiency, while driving reuse. 
- The Platform MUST provide the ability for business areas to determine the level of self-service and control they will have over their data solutions and products.
- The Platform MUST support an enterprise data science capability, including the enablement of data citizens.
- The Platform MUST support higher target SLAs:
  - 99.9% target uptime (or ~8.5 hours downtime per year).
  - Recovery Point Objective (RPO) of 1.5 days.
  - Recovery Time Objective (RTO) of less than 1 day.
- The Platform MUST support the forecast usage of 1000 users across the various domains with an estimated growth of 5% annually.
   - While only Consoto employees can directly access the platform, there SHOULD be the capability to share data with third parties. 

### The key design decisions (KDDs)
- The [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml) can be modified to meet these requirements without rearchitecting.
- Given the requirements for extending the platform across the enterprise and self-service functionality, and the business strategic objective, a [domain design](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-domains#domain-modeling-recommendations) supported by an enterprise managed foundation is chosen. The foundation is defined as:
  - Identity and access controls.
  - The underlying networking, boundary controls and security baseline.
  - The governance, audit and monitoring functionality.
  - The ingestion and initial processing of data into the platform.
- The domain design is anchored around a given business departments' ownership of their data and the originating source system. 
- A new [operating model](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/organize-roles-teams) allows business groups to optionally build their own stack of model-and-serve components, which they control and maintain going forward.
  - Domains operate within guardrails, based upon enterprise requirements and are enabled to perform well-defined experiments.
- The data science capability is delivered via:
  - [Power BI](https://learn.microsoft.com/power-bi/connect-data/service-tutorial-build-machine-learning-model) for low code, simple or medium complexity use cases across tabular data. This is an ideal starting point for data citizens.
  - [Azure Machine Learning](https://learn.microsoft.com/en-us/azure/machine-learning/?view=azureml-api-2) and AI service offerings, supporting the full set of use cases and [end-user maturity](/azure/machine-learning/tutorial-first-experiment-automated-ml?view=azureml-api-2).
  - [Azure Databricks](/azure/databricks/lakehouse-architecture/performance-efficiency/best-practices#use-parallel-computation-where-it-is-beneficial) for large enterprise volume use cases with significant processing demands.
  - An innovation sandbox supports any proof-of-concept work for new technologies or techniques in a logically segregated area.
- Azure Data Factory capabilities to cover near-real time and micro-batch ingestion use cases is provided with [Change-Data-Capture](/azure/data-factory/concepts-change-data-capture) functionality. This functionality combined with Azure Databricks [Structured streaming](/azure/databricks/structured-streaming/), and [Power BI](https://learn.microsoft.com/power-bi/connect-data/service-real-time-streaming) supports the end-to-end solution. 
- The use of Power BI allows data sharing with external parties, as required, with [Microsoft Entra B2B](/power-bi/enterprise/service-admin-azure-ad-b2b) authorization and access controls.

## Architecture

![Diagram showing hardened Medlallion architecture.](_images/ADF-ALZ-Medallion-hardening.png)

### Design callouts

The design callouts for the hardened architecture are:
1.	The Ingestion and Delta Lake are [source aligned](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-domains#source-system-aligned-domains) and remain the responsibility of the central technical team. This decision reflects the level of technical expertise required for Spark development and supports a consistent, standardized implementation approach that accounts for enterprise reusability.
- Data feeds from source systems are governed with [data contracts](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-contracts#data-contracts-1), which can be used to drive a [metadata-driven](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-contracts#:~:text=metadata%2Ddriven%20ingestion%20frameworks) ETL (extract, transform, load) framework and surfaced up to end users as part of the [governance capability](https://learn.microsoft.com/purview/how-to-browse-catalog).
- The delta lake's Bronze layer (Raw) directory structure reflects how [data is consumed](/azure/storage/blobs/data-lake-storage-best-practices?toc=%2Fazure%2Farchitecture%2Ftoc.json&bc=%2Fazure%2Farchitecture%2F_bread%2Ftoc.json#directory-structure), ordered by source system. This organization methodology enables a unified security implementation based on business ownership of source systems.
- To support the streaming requirement,a fast-path for data is designed. To that end, data is ingested through ADF and directly processed by the Azure Databricks structured stream for analysis and use. Delta lake [CDC](/azure/databricks/structured-streaming/delta-lake#stream-a-delta-lake-change-data-capture-cdc-feed) can be used create the audit history, supporting replay and propagating incremental changes to downstream tables in the medallion architecture. 

2. A model-and-serve path remains the responsibility of the central technical team to support the enterprise owned data solutions and provide the service catalog optionality for business areas who require data solutions but do not have the skilling, budget or interest in technically managing their own domain implementation.
- Self-service will still be offered within the model and serve components managed by the central technical team.
  
3. The Enterprise data science capability will be established under the central technical team. Once again, supporting the enterprise focused solutions, providing service optionality and hosting services with a enterprise pricing structure.

4. Domains will be enabled via logical containers at the subscription level. [Subscriptions](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions) provide the domain level unit of management, billing, governance, and isolation that clearly separates concerns.
- This approach will be enabled via [IaC](https://learn.microsoft.com/devops/deliver/what-is-infrastructure-as-code) which provides a baseline of enterprise monitoring, audit and security controls. The Platform [Tagging strategy](/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging) will be extended to support the domain extension.
- Each Domain will have it's own set of RBAC roles covering the [control and data planes](/azure/azure-resource-manager/management/control-plane-and-data-plane). Control plane roles will largely be used within the domain logical containers, where as data plane roles will be used across the platform, providing a consistent, unified and low-complexity control.   
  
5.	Within a Domain subscription, there will be optionality on the components made available, depending on the Business's skillset, priorities and use cases.
- Power BI [workspaces](https://learn.microsoft.com/power-bi/collaborate-share/service-new-workspaces) will be used to enable domains. These can be individual linked to specific [premium capacities](https://learn.microsoft.com/power-bi/enterprise/service-premium-what-is#workspaces) if increased performance is required.
- An Innovation Sandpit is a temporary entity, enabling the validation of new technologies or processes. Data storage will be available to onboard, create or change data, outside of constraints of the append-only functionality of the Data Lake - Bronze layer. 


### Network Design

TO BE ADDED - Darren
- How is the domain structure added?


### Data Science Capability

For data science scenarios, Azure Data Factory’s primary role lies in data movement, scheduling and orchestration required as part of batch inferencing machine learning use-cases. Batch inference, or batch scoring, scenarios involve making predictions on a batch of observations. These scenarios are usually characterised by a high-throughput of data with scoring at a pre-defined frequency. 

Within Azure Data Factory these workflows are defined in pipelines consisting of various interlinked activities. Scalable Azure Data Factory pipelines are usually parameterized and driven by metadata defined in a control table. This pattern is characterized by the ingestion of data, processing it to generate machine learning predictions, and moving the data outputs to a service for modelling and serving purposes. The processing of data to generate machine learning predictions are performed differently in Azure Machine Learning and Azure Databricks - this is described in more details below. 

#### Azure Databricks:
- An [Azure Databricks notebook](https://learn.microsoft.com/en-us/azure/databricks/notebooks/) will incorporate all model scoring logic.
- Execute model scoring using a [Databricks Notebook activity](https://learn.microsoft.com/en-us/azure/data-factory/transform-data-databricks-notebook).

#### Azure Machine Learning:
- An Azure Machine Learning [Batch Endpoint](https://learn.microsoft.com/en-us/azure/machine-learning/concept-endpoints-batch?view=azureml-api-2) will be used to incorporate all model scoring logic.
- Execute model scoring using a [Machine Learning pipeline activity](https://learn.microsoft.com/en-us/azure/data-factory/transform-data-machine-learning-service).


## Callouts

- Streaming data patterns can be complicated to implement and manage, especially in failure case scenarios. It is strongly recommended that business requirements are tested for acceptable latency, source system and network infrastructure can support streaming requirements, before such work is undertaken.
- Any decision to move toward a domain model must be taken in collaboration with business stakeholders. Its critical that stakeholders understand and accept the increased [responsibilities](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/organize-roles-responsibilities) of domain ownership.
  - Stakeholders data maturity, available skilling across the SDLC, governance framework, standards and automation coverage are all influencing factors for how far the initial operating model leans into [domain enablement](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/self-serve-data-platforms), although this could shift out to the target state for the [adoption lifecycle](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-mesh-checklist). 
 

## Alternatives

- [Azure Event Hubs](/azure/event-hubs/) as alternative for the streaming: Discounted due to Azure Databricks functional match, and the desire for simplification.
- [Azure Data Share](/azure/data-share/) as alternative for the data sharing: Discounted due to basic sharing functionality offered by Power BI, and the desire for simplification. 


## Considerations

The following considerations provide guidance for implementing the pillars of the [Azure Well-Architected Framework](/azure/well-architected/) in the context of this architecture. 


### Reliability

[Reliability](/azure/well-architected/reliability/) ensures that solution resilient to malfunction and to ensure that it returns to a fully functioning state after a failure occurs. 

The delta this architecture provides, includes:
- The default Azure [SLA's](https://www.azure.cn/support/sla/summary/) across the solution still meet the uplifted requirements, so no high-availability or multi-regional uplift is required.
- Uplift the [DR strategy](/azure/architecture/data-guide/disaster-recovery/dr-for-azure-data-platform-overview) to cover the full scope of platform services and stakeholder RACI. This must be regularly tested to ensure it remains "fit-for-purpose".
- Solution components will utilise zone-redundancy features to protect against localised service issues. The following table shows the resiliency types for the services in this architecture:

**Service**|**Resiliency Type**
:-----:|:-----:
Azure Data Factory (ADF)|Zone-redundant
Azure Databricks (ADB)|Zone-redundant
Azure Data Lake Storage Gen2 (ADLS Gen2)|Zone-redundant
Azure Databricks Auto Loader|Zone-redundant
Azure Key Vault|Zone-redundant
Azure Virtual Network Gateway|Zone-redundant
Self-hosted integration runtime (SHIR)|Same-zone high availability


  - *NB* - Azure services aren't supported in all regions and not all regions support zones. Before you select a region, verify its regional and zone support.


### Security

[Security](/azure/well-architected/security/) provides guidance to your architecture to help ensure the confidentiality, integrity, and availability of your data and systems.

The delta this architecture provides, includes:
- Domain specific data RBAC roles will be created when domain specific data is ingested onto the platform with data classification higher than enterprise - [general](/azure/cloud-adoption-framework/govern/policy-compliance/data-classification#classifications-microsoft-uses) and then reused across all solution components which uses this data.
  - These domain data roles will be reused for new domain data onboarded to the platform, delivering a consistent, unified controls for the access to data.
- Given the increased in data ssensitivity on the platform, [PIM](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-resource-roles-assign-roles) should be considered for all key operational support roles. 


### Cost Optimization

[Cost optimization](/azure/well-architected/cost-optimization/) provides guidance in your architecture to sustain and improve your return on investment (ROI).

The delta this architecture provides, includes:
- Uplift of the Domain teams to ensure they understand the discipline of [cost optimization](https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/) and their responsibilities under the new operating model.
- Extending the [cost management alerting](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending) to the domains and business stakeholders, providing transparency and observability. 


### Operational Efficiency

[Operational excellence](/azure/well-architected/operational-excellence/) ensures workload quality through standardized processes and team cohesion. 

The delta this architecture provides, includes:
- Evolve the operating model to account for the new domain model, stakeholders, governance structures, persona-based training and RACI. 
- Extend the [Tagging strategy](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) to account for domain model.
- Develop an central [NFR](/azure/architecture/guide/design-principles/build-for-business) register and [software development best practices](/azure/architecture/best-practices/index-best-practices) which can be referenced by any platform solution, irrespective of developer area. This should be supported by a [testing framework](https://learn.microsoft.com/devops/develop/shift-left-make-testing-fast-reliable) within the CI/CD suite, successfully run for every production change.
  - This will be a key enabler of quality, particularly for 3rd party deliverables.
 

### Performance Efficiency

[Performance efficiency](/azure/well-architected/performance-efficiency/) is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. 

The delta this architecture provides, includes:
- As part of the domain establishment and baseline of [monitoring](/azure/azure-monitor/overview), alerting and [observability](/azure/cloud-adoption-framework/manage/monitor/observability) will be provided to the domain teams.
- Encourage the sharing of knowledge and best-practice between knowledge workers, offering [incentives](https://learn.microsoft.com/power-bi/guidance/fabric-adoption-roadmap-community-of-practice?context=%2Ffabric%2Fcontext%2Fcontext#incentives) for community engagement.

## Anti-Patterns

- **Technology Led Transformation** - The shift to a domain model is a major undertaking that requires significant change across the organisation. This works best when Business stakeholders understand the scope of activities needed and value the outputs delivered. Deep collaboration is the key to any successful transformation.   
- **LinkedIn Architecture** - Technology is driven by new ideas. Questions such as "Are we solving the business problem at hand?", "what are the industry validated patterns?", "is this a problem needing a technical solution, or the other way around?", etc. can tempter earlier adopter enthusiasm and risk.  
- **Understanding the RACI for Product Ownership** - When a gap in technical services is identified, it is often tempting to "build your own". While this is a valid approach in many cases, consideration needs to be given to the responsibility of adoption a Product ownership role across the full lifecycle, which can be a lengthy period of time for a productionised solution. The Cost and risk from activities such as support, feature uplift, security patching, environment interoperability, etc. can quickly weight any benefit provided. 
   
## Next steps

- [Azure Data Factory Mission Critical](TO_BE_ADDED) 


## Related resources

- [Azure Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/)
- [Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/)
- [Data Domain Guidance](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-domains)
- [Initial Implementation](TO_BE_ADDED)
