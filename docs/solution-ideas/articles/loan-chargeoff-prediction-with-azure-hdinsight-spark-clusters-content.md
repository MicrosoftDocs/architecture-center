[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

A charged-off loan is a loan that a creditor deems unlikely to be collected. The creditor is usually a lending institution. Loans are usually declared charged-off when the loan repayment is severely delinquent by the debtor. High charge-off has a negative impact on lending institutions' year-end financials. As a result, lending institutions often monitor loan charge-off risk very closely. By using machine learning services on Azure HDInsight, a lending institution can predict the likelihood of loans getting charged off. Reports can be run on the analytics result that's stored in Apache Hadoop distributed file system (HDFS) and Apache Hive tables.

*Apache®, [Apache Hive](https://hive.apache.org), and [Apache Hadoop](https://hadoop.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

![Architecture diagram that shows the flow of data from RStudio through HDInsight and then to Power BI or a web app.](../media/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.png)

*Download an [SVG](../media/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.svg) of this architecture.*

### Dataflow

1. A data scientist uses a web browser to connect to RStudio Server. The compute context determines the location of the server. The following options are possible:

   - Distributed across the nodes of an HDInsight Spark cluster
   - On a local cluster edge node

1. The following raw data is deployed to the server as CSV files:

   - Lending institution customer demographic information
   - Detailed information about loans
   - Payment history records

1. R scripts run a logistic regression over the data to predict the loan charge off variable.

1. An Azure HDInsights Spark connector is used to access the analytics results that are in HDFS and Hive tables.

1. Power BI is used to interpret and display the results.

1. The model is optionally deployed as a web service that PCs and mobile devices can access.

### Components

- [Azure HDInsight](https://azure.microsoft.com/products/hdinsight) is a managed, full-spectrum, open-source analytics service in the cloud for enterprises. With HDInsight, you can use open-source frameworks such as Hadoop, Apache Spark, Apache Hive, LLAP, Apache Kafka, Apache Storm, and R in your Azure environment.
- [Power BI](https://powerbi.microsoft.com) provides interactive dashboards that display predictive analytics data and related data that's needed for business decisions.

## Scenario details

Charging off a loan is an action that a bank takes as a last resort on a severely delinquent loan. Prediction data can help loan officers from reaching the point where they charge off loans. Specifically, loan officers can use the prediction data to offer personalized incentives like lower interest rates or longer repayment periods. These incentives can help customers to keep making loan payments and to avoid having their loans charged off.

To get this type of prediction data, credit unions and banks often perform manually calculations based on a customer's past payment history. They also often run a simple statistical regression analysis. This approach is highly subject to data compilation errors and isn't statistically sound.

This article's end-to-end solution runs predictive analytics on loan data and produces scoring on chargeoff probability. A Power BI report presents the details of the analysis, the credit loan trends, and the prediction of charge-off probability.

### Business perspective

This loan chargeoff prediction uses simulated loan history data to predict the probability of loan chargeoff in the next three months. The higher the score, the higher the probability is that the loan gets charged off in the future.

Together with the analytics data, the loan manager is also presented with the trends and analytics of chargeoff loans by branch location. Loan managers can use the characteristics of loans with a high charge-off risk in a specific geographical area to make a business plan for loan offerings in that area.

Power BI also presents visual summaries of loan payments and chargeoff predictions.

### Potential use cases

This solution demonstrates how to build and deploy a machine learning model to predict whether a bank loan gets charged off within a given period. This solution is ideal for the finance industry.

## Deploy this scenario

A template for this solution is available in a [GitHub repo](https://github.com/Microsoft/r-server-loan-chargeoff). It walks through the end-to-end process of how to develop predictive analytics by using simulated loan history data to predict loan chargeoff risk. The data contains information for each loan like the holder demographic data, the amount, the contractual duration, and the payment history. The solution template also includes a set of R scripts that:

- Perform data processing and feature engineering.
- Use several algorithms to train the data.
- Select the best performant model to score the data to produce a probability score for each loan.

Data scientists who test this solution can work with the R code that the GitHub repo provides. They can work from the browser-based open-source edition of RStudio Server that runs on the edge node of the machine learning services on the Azure HDInsight cluster. By [setting the compute context](/azure/hdinsight/hdinsight-hadoop-r-server-compute-contexts), the user can decide where the computation is performed. The options are locally on the edge node, or distributed across the nodes in the Spark cluster.

This solution creates a cluster of type Apache Spark on Azure HDInsight. This cluster contains two head nodes, two worker nodes, and one edge node with a total of 32 cores. For the approximate cost of this HDInsight Spark cluster, see [HDInsight pricing](https://azure.microsoft.com/pricing/details/hdinsight/). Billing starts when a cluster is created and stops when the cluster is deleted. Billing is pro-rated per minute, so delete your cluster when it's no longer in use. After you're finished using the solution, use the **Deployments** page to delete the entire solution.

## Next steps

- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [Analyze Apache Spark data using Power BI in HDInsight](/azure/hdinsight/spark/apache-spark-use-bi-tools)
- [Operationalize ML Services cluster on Azure HDInsight](https://azure.microsoft.com/services/hdinsight/r-server/)

## Related resources

- [R developer's guide to Azure](../../data-guide/technology-choices/r-developers-guide.md)
- [Loan chargeoff prediction with SQL Server](./loan-chargeoff-prediction-with-sql-server.yml)
- [Use a demand forecasting model for price optimization](./demand-forecasting-price-optimization-marketing.yml)
- [Product recommendations for retail using Azure](./product-recommendations.yml)