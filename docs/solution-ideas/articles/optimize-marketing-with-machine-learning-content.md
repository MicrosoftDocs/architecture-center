[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Marketing campaigns are about more than the message being delivered; when and how that message is delivered is just as important. Without a data-driven, analytical approach, campaigns can easily miss opportunities or struggle to gain traction.

In this solution, a model will be created and registered to an Azure Machine Learning workspace. The model will be consumed from the Azure Machine Learning model registry for deployment in Azure Synapse SQL pools and launch predictions to enrich the data. Power BI will be used to connect to the Azure Synapse Analytics instance to visualize the data.

## Potential use cases

Through machine learning informed by historical campaign data, this solution helps predict customer responses. The solution recommends an optimized plan for connecting with your leads, including the best channel to use (by email, SMS, a cold call, and so on), the best day of the week, and the best time of the day.

Optimizing your campaigns with machine learning helps improve both sales leads and revenue generation and can provide strong ROI for your marketing investment. This solution is ideal for the retail industry.

## Architecture

![Diagram of this marekting optimization architecture.][architecture-png]
*Download an [SVG file][architecture-svg] of this architecture.*

### Components

* [Azure Machine Learning (AML)][aml-overview] is a cloud-based environment you can use to train, deploy, automate, manage, and track machine learning models. In this solution, it is used to develop a machine learning model and register the model in the AML model registry.
* [Azure Synapse Analytics][synapse-overview] is an integrated analytics service that accelerates time to insight across data warehouses and big data systems. In this solution, Azure Synapse Analytics will enrich data in dedicated SQL pools with the model registered in AML via a stored procedure.
* [Power BI][pbi-overview] provides an interactive dashboard with visualizations that use data stored in Azure Synapse Analytics to drive decisions on the predictions.

## Next steps

Learn more with the following learning paths:

* [Create machine learning models][ms-learn-create-ml]
* [Build AI solutions with Azure Machine Learning][ms-learn-build-ai-solutions]
* [Data integration at scale with Azure Data Factory or Azure Synapse Pipeline][ms-learn-synapse-data-integration]

## Related resources

* [Azure Machine Learning documentation][aml-docs]
* [Azure Synapse Analytics documentation][synapse-docs]
* [Power BI documentation][pbi-docs]
* [Train machine learning models in Azure Synapse Analytics][apache-spark-machine-learning-training]
* [Machine learning model scoring for dedicated SQL pools in Azure Synapse Analytics][tutorial-sql-pool-model-scoring-wizard]

<!-- links -->
[architecture-png]: ../media/optimize-marketing-with-machine-learning.png
[architecture-svg]: ../media/optimize-marketing-with-machine-learning.png
[synapse-docs]: /azure/synapse-analytics/
[aml-docs]: /azure/machine-learning/
[pbi-docs]: /power-bi/
[synapse-overview]: /azure/synapse-analytics/overview-what-is
[aml-overview]: /azure/machine-learning/overview-what-is-azure-ml
[apache-spark-machine-learning-training]: /azure/synapse-analytics/spark/apache-spark-machine-learning-training
[tutorial-sql-pool-model-scoring-wizard]: /azure/synapse-analytics/machine-learning/tutorial-sql-pool-model-scoring-wizard
[pbi-overview]: /power-bi/fundamentals/power-bi-overview
[ms-learn-create-ml]: /learn/paths/create-machine-learn-models/
[ms-learn-build-ai-solutions]: /learn/paths/build-ai-solutions-with-azure-ml-service/
[ms-learn-synapse-data-integration]: /learn/paths/data-integration-scale-azure-data-factory/
