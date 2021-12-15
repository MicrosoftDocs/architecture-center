[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes how to build and deploy a machine learning model with [Microsoft Machine Learning Server](/machine-learning-server/what-is-machine-learning-server) on Azure HDInsight Spark clusters to recommend actions to maximize the purchase rate of leads targeted by a campaign. This solution enables efficient handling of big data on Spark with Machine Learning Server.

## Potential use cases

When a business launches a marketing campaign to interest customers in new or existing product(s), they often use a set of business rules to select leads for their campaign to target. Machine learning can be used to help increase the response rate from these leads.

This solution idea describes how to use a model to predict actions that are expected to maximize the purchase rate of leads targeted by the campaign. These predictions serve as the basis for recommendations to be used by a renewed campaign on how to contact (for example, e-mail, SMS, or cold call) and when to contact (day of week and time of day) the targeted leads.

## Architecture

![Architecture diagram: Marketing campaign optimization with Microsoft Machine Learning Server.](../media/campaign-optimization-with-azure-hdinsight-spark-clusters.png)
*Download an [SVG](../media/campaign-optimization-with-azure-hdinsight-spark-clusters.svg) of this architecture.*

### Components

[Microsoft Machine Learning Server](/machine-learning-server/what-is-machine-learning-server) - Enterprise software for data science, providing R and Python interpreters, base distributions of R and Python, other high-performance libraries from Microsoft, and an operationalization capability for advanced deployment scenarios.

[Azure HDInsight](/azure/hdinsight/hdinsight-overview) - A managed, full-spectrum, open-source analytics service in the cloud for enterprises. You can use open-source frameworks such as Hadoop, Apache Spark, Apache Hive, LLAP, Apache Kafka, Apache Storm, R, and more.

## Business perspective

This solution uses machine learning with historical campaign data to predict customer responses and recommend when and how to connect with your leads. The recommendations include the best channel to contact a lead (in our example, email, SMS, or cold call), the best day of the week and the best time of day in which to make the contact.

Microsoft Machine Learning Server on HDInsight Spark clusters provides distributed and scalable machine learning capabilities for big data, combining power of Machine Learning Server and Apache Spark. This solution demonstrates how to develop machine learning models for marketing campaign optimization (including data processing, feature engineering, training and evaluating models), deploy the models as a web service (on the edge node) and consume the web service remotely with Microsoft Machine Learning Server on Azure HDInsight Spark clusters. The final predictions and recommendation table are saved to a Hive table containing recommendations for how and when to contact each lead. This data is then visualized in Power BI. Power BI gives visual summaries of the effectiveness of the campaign recommendations.

The Recommendations tab of this dashboard shows the predicted recommendations. At the top of the dashboard, there is a table of individual leads for our new deployment. The table includes fields for the lead ID, campaign, and product, populated with leads on which our business rules are to be applied. These fields are followed by the model predictions for the leads, giving the optimal channel and time to contact each one, along with the estimated probabilities that the leads will buy our product using these recommendations. These probabilities can be used to increase the efficiency of the campaign by limiting the number of leads contacted to the subset most likely to buy.

Also on the Recommendations tab there are various summaries of recommendations and demographic information on the leads. The Campaign Summary tab of the dashboard shows summaries of the historical data used to create the predicted recommendations. While this tab also shows values of Day of Week, Time of Day, and Channel, these values are actual past observations, not to be confused with the recommendations from the model, shown on the Recommendations tab.

## Data scientist perspective

This solution demonstrates the end-to-end process of how to develop and deploy machine learning models for marketing campaign optimization. It contains sample data, R code for each step of building the model (including data processing, feature engineering, training and evaluating models along with sample data), deploying the model as a web service (on the edge node) and consuming the web service remotely with Microsoft Machine Learning Server on Azure HDInsight Spark clusters.

Data scientists who are testing this solution can work with the provided R code from the browser-based Open Source Edition of RStudio Server that runs on the Edge Node of the Azure HDInsight Spark cluster. By setting the compute context, users can decide where the computation will be performed: locally on the edge node, or distributed across the nodes in the Spark cluster. All the R code can also be found in [public GitHub repository](https://github.com/Microsoft/r-server-campaign-optimization).

## Deploy this scenario

The [campaign optimization GitHub repo](https://github.com/Microsoft/r-server-campaign-optimization) is an implementation of this solution idea. The repo code uses simulated data from the insurance industry to model responses of the leads to the campaign. The model predictors include demographic details of the leads, historical campaign performance, and product-specific details. The model predicts the probability that each lead in the database makes a purchase from a channel, on each day of the week at various times of day. Recommendations on which channel, day of week and time of day to use when targeting users are based then on the channel and timing combination that the model predicts will have the highest probability a purchase being made.

## Pricing

This solution will create an HDInsight Spark cluster with Microsoft Machine Learning Server. This cluster will contain two head nodes, two worker nodes, and one edge node with a total of 32 cores. The approximate cost for this HDInsight Spark cluster can be estimated with the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/). Billing starts once a cluster is created and stops when the cluster is deleted. Billing is pro-rated per minute, so you should always delete your cluster when it is no longer in use. Use the Deployments page to delete the entire solution once you are done.

## Next steps

Read other Azure Architecture Center articles:

- [Campaign optimization with SQL Server and machine learning](./campaign-optimization-with-sql-server.yml)
- [Digital campaign management](./digital-marketing-using-azure-database-for-postgresql.yml)
- [R developer's guide to Azure](../../data-guide/technology-choices/r-developers-guide.md)

Learn more and try out some code:

- Microsoft Learn module [Introduction to Azure HDInsight](/learn/modules/intro-to-azure-hdinsight)
- Microsoft Machine Learning Server documentation [tutorials and sample data](/machine-learning-server/r/tutorial-introduction)
- Azure AI Gallery - [Campaign Optimization with Azure HDInsight Spark Clusters](https://gallery.azure.ai/Solution/Campaign-Optimization-with-Azure-HDInsight-Spark-Clusters)
