[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution template demonstrates a solution end to end, to run predictive analytics on loan data and produce scoring on chargeoff probability. A Power BI report will also walk through the analysis and trend of credit loans and prediction of chargeoff probability.

## Architecture

![Diagram that shows an architecture diagram of building and deploying an ML model to predict a bank loan.](../media/loan-chargeoff-prediction-with-sql-server.svg)

*Download a [Visio file](https://arch-center.azureedge.net/loan-chargeoff-prediction.vsdx) for this architecture.*

### Dataflow

1. Develop and deploy R code into R Studio IDE, which is installed on a VM or Data Scientist workstation. It's connected to a Data Science VM, where SQL Server is installed.

1. Predict and score the model. The prediction and scored data can be visualized into Power BI.

Data scientists do the data preparation, model training, and evaluation from their favorite R IDE. DBAs can take care of the deployment using SQL stored procedures with embedded R code.

Finally, a Power BI report is used to visualize the predicted and scored results that are deployed.

### Components

Key technologies used to implement this architecture:

- [Power BI](https://powerbi.microsoft.com)
- [Data Science Virtual Machines](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines)
- [Virtual Machines](https://azure.microsoft.com/services/virtual-machines)

In a Data Science VM, the SQL Server 2019 Developer edition is pre-installed. For information about the other tools included on the Azure Data Science VM, see [What tools are included on the Azure Data Science Virtual Machine?](/azure/machine-learning/data-science-virtual-machine/tools-included).

## Solution details

A charged off loan is a loan that is declared by a creditor (usually a lending institution) that an amount of debt is unlikely to be collected, usually when the loan repayment is severely delinquent by the debtor. Given that high chargeoff has a negative impact on lending institutions’ year-end financials, lending institutions often monitor loan chargeoff risk very closely to prevent loans from getting charged-off.

There are multiple benefits for lending institutions to equip with loan chargeoff prediction data. Charging off a loan is the last resort that the bank will do on a severely delinquent loan, with the prediction data at hand, the loan officer could offer personalized incentives like lower interest rate or longer repayment period to help customers to keep making loan payments and thus prevent the loan of getting charged off. To get to this type of prediction data, often credit unions or banks manually handcraft the data based on customers' past payment history and performed simple statistical regression analysis. This method is highly subject to data compilation error and not statistically sound.

### Potential use cases

This solution demonstrates how to build and deploy a machine learning model, with SQL Server 2019 pre-installed in a Data Science VM with R Services embedded, to predict if a bank loan will need to be charged off within the given period. This solution is ideal for the finance industry.

### Business manager perspective

This loan chargeoff prediction uses a simulated loan history data to predict probability of loan chargeoff in the immediate future (next three months). The higher the score, the higher is the probability of the loan getting charged-off in the future.

With the analytics data, loan manager is also presented with the trends and analytics of the chargeoff loans by branch locations. Characteristics of the high chargeoff risk loans will help loan managers to make business plan for loan offering in that specific geographical area.

SQL Server R Services brings the compute to the data by allowing R to run on the same computer as the database. It includes a database service that runs outside the SQL Server process and communicates securely with the R runtime.

This solution template walks through how to create and clean up a set of simulated data, use various algorithms to train the R models, select the best performant model, and perform chargeoff predictions and save the prediction results back to SQL Server. A Power BI report connects to the prediction result table and show interactive reports with the user on the predictive analytics.

### Data scientist perspective

SQL Server R Services brings the compute to the data by running R on the computer that hosts the database. It includes a database service that runs outside the SQL Server process and communicates securely with the R runtime.

This solution walks through the steps to create and refine data, train R models, and perform scoring on the SQL Server machine. The final prediction results will be stored in SQL Server. This data is then visualized in Power BI, which also contains a summary of the loan chargeoff analysis and chargeoff prediction for the next three months. (Simulated data is shown in this template to illustrate the feature)

Data scientists who are testing and developing solutions can work from the convenience of their R IDE on their client machine, while [pushing the compute to the SQL Server machine](/sql/advanced-analytics/r/getting-started-with-sql-server-r-services). The completed solutions are deployed to SQL Server 2016 by embedding calls to R in stored procedures. These solutions can then be further automated with SQL Server Integration Services and SQL Server agent.

Click on the Deploy button to test the automation and the entire solution will be made available in your Azure subscription.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Your Azure subscription used for the deployment will incur consumption charges on the services used in this solution, approximately $1.15/hour for the default VM.

Ensure that you stop your VM instance when not actively using the solution. If you run the VM, you'll incur higher costs.

Make sure to delete the solution if you're not using it.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Avijit Prasad](https://www.linkedin.com/in/avijit-prasad🌐-96768a42) | Cloud Consultant

## Next steps

Product documentation:

- [Linux virtual machines in Azure](/azure/virtual-machines/linux/overview)
- [Run SQL Server in the cloud](/sql/linux/quickstart-install-connect-clouds)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [What is SQL Server on Windows Azure Virtual Machines?](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview)
- [Windows virtual machines in Azure](/azure/virtual-machines/windows/overview)

Microsoft Learn modules:

- [Create a Linux virtual machine in Azure](/training/modules/create-linux-virtual-machine-in-azure)
- [Create a Windows virtual machine in Azure](/training/modules/create-windows-virtual-machine-in-azure)
- [Create reports and dashboards with Power BI](/training/modules/explore-power-bi)
- [Deploy and configure servers, instances, and databases for Azure SQL](/training/modules/azure-sql-deploy-configure)

## Related resources

- [Azure Kubernetes Service (AKS) architecture design](../../reference-architectures/containers/aks-start-here.md)
- [Campaign optimization with SQL Server and machine learning](campaign-optimization-with-sql-server.yml)
- [Finance management apps using Azure Database for PostgreSQL](finance-management-apps-using-azure-database-for-postgresql.yml)
- [Finance management apps using Azure Database for MySQL](finance-management-apps-using-azure-database-for-mysql.yml)
- [Loan charge-off prediction with Azure HDInsight Spark clusters](loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)
