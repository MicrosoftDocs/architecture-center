[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Marketing campaigns are about more than the message being delivered; when and how that message is delivered is just as important. Without a data-driven, analytical approach, campaigns can easily miss opportunities or struggle to gain traction.

Nowadays, marketing campaigns are often based on social media analysis, which has become increasingly important for companies and organizations around the world.  It is a powerful tool that can be leveraged to receive instant feedback on products and services, improve interactions with customers to increase customer satisfaction, keep up with the competition, and more. Companies often lack efficient, viable ways to monitor these conversations and as a result miss countless opportunities to use these insights to inform their strategies and plans.

## Potential use cases
Organizations nowadays are capitalizing in various ways to extract knowledge and information about their customers in order to enhance the customer experience, increase customer satisfaction, gain new leads as well as prevent customer churn. There are three areas where customers are forcing their investments regarding social media analytics, some examples of use cases that this architecture and the solution accelerator could be used, are:

- **Measure Brand Health:** 
    * Capture customer reactions and feedback for new products on social media.
    * Analyze Sentiment on social media interactions for a newly introduced product.

- **Build & maintain customer relationships:**
    * Identify quickly all customer concerns
    * Listen to untagged brand mentions

- **Optimize marketing spends:**
    * Extract insights from social media for campaign analysis.

## Architecture

![Diagram of this marketing optimization architecture.][architecture-png]
*Download a [SVG file][architecture-svg] of this architecture.*

### Dataflow

1. [Azure Synapse Analytics][synapse-overview] is an integrated analytics service that accelerates time to insight across data warehouses and big data systems. In this solution, Azure Synapse Analytics will enrich data in dedicated SQL pools with the model registered in AML via a stored procedure.
2. [Cognitive Services](https://azure.microsoft.com/en-gb/services/cognitive-services/#api) and [Azure Machine Learning (AML)][aml-overview].
    - **Cognitive Services** brings AI within reach of every developer and data scientist. With leading models, a variety of use cases can be unlocked. All it takes is an API call to embed the ability to see, hear, speak, search, understand, and accelerate advanced decision-making into your apps. Enable developers and data scientists of all skill levels to easily add AI capabilities to their apps.

    - **Azure Machine Learning Service (AML)** is a cloud-based environment you can use to train, deploy, automate, manage, and track machine learning models. In this solution, it's used to develop a machine learning model and register the model in the AML model registry.
3. [Azure Data Lake Storage (ADLS)](https://azure.microsoft.com/en-us/services/storage/data-lake-storage/#overview) is a massively scalable and secure data lake for your high-performance analytics workloads.
4. [Power BI][pbi-overview] and [Azure Web App](https://azure.microsoft.com/en-us/services/app-service/web/) 
    - **Azure Web App** is used to create and deploy scalable mission-critical web applications.
    - **Power BI** provides an interactive dashboard with visualizations that use data stored in Azure Synapse Analytics to drive decisions on the predictions.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | AI Cloud Solution Architect

Other contributors:

 * [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore) | Cloud Architecture / Data / Artificial Intelligence

## Next steps

Learn more with the following learning paths:

* [Create machine learning models][ms-learn-create-ml]
* [Build AI solutions with Azure Machine Learning][ms-learn-build-ai-solutions]
* [Data integration at scale with Azure Data Factory or Azure Synapse Pipeline][ms-learn-synapse-data-integration]
* [Sentiment Analysis with Cognitive Services in Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/tutorial-cognitive-services-sentiment)
* [Text Analytics with Cognitive Services in Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/tutorial-text-analytics-use-mmlspark)


## Related resources

* [Azure Machine Learning documentation][aml-docs]
* [Azure Synapse Analytics documentation][synapse-docs]
* [Cognitive Services](https://azure.microsoft.com/services/cognitive-services/)
* [Cognitive Services Documentation](https://docs.microsoft.com/azure/cognitive-services/)
* [Power BI documentation][pbi-docs]
* [Azure Web App Service](https://azure.microsoft.com/services/app-service/web/)
* [Azure Web App Service Documentation](/azure/app-service/overview)
* [Train machine learning models in Azure Synapse Analytics][apache-spark-machine-learning-training]
* [Machine learning model scoring for dedicated SQL pools in Azure Synapse Analytics][tutorial-sql-pool-model-scoring-wizard]
* [Machine learning with Apache Spark in Azure Synapse Analytics](/azure/synapse-analytics/spark/apache-spark-machine-learning-concept)

<!-- links -->
[architecture-png]: ../media/optimize-marketing-with-machine-learning.png
[architecture-svg]: ../media/optimize-marketing-with-machine-learning.png
[synapse-docs]: /azure/synapse-analytics
[aml-docs]: /azure/machine-learning
[pbi-docs]: /power-bi
[synapse-overview]: /azure/synapse-analytics/overview-what-is
[aml-overview]: /azure/machine-learning/overview-what-is-azure-ml
[apache-spark-machine-learning-training]: /azure/synapse-analytics/spark/apache-spark-machine-learning-training
[tutorial-sql-pool-model-scoring-wizard]: /azure/synapse-analytics/machine-learning/tutorial-sql-pool-model-scoring-wizard
[pbi-overview]: /power-bi/fundamentals/power-bi-overview
[ms-learn-create-ml]: /learn/paths/create-machine-learn-models
[ms-learn-build-ai-solutions]: /learn/paths/build-ai-solutions-with-azure-ml-service
[ms-learn-synapse-data-integration]: /learn/paths/data-integration-scale-azure-data-factory
