[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution demonstrates how to build and deploy a machine learning model with SQL Server 2016 with R Services to predict if a bank loan will need to be charged off within next three months.

## Architecture

![Architecture diagram of building and deploying an ML model to predict a bank loan.](../media/loan-chargeoff-prediction-with-sql-server.png)
*Download an [SVG](../media/loan-chargeoff-prediction-with-sql-server.svg) of this architecture.*

### Components

Key technologies used to implement this architecture:

- [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded)
- [SQL Server on Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/sql-server)
- [Virtual Machines](https://azure.microsoft.com/services/virtual-machines)

## Solution details

There are multiple benefits for lending institutions to equip with loan chargeoff prediction data. Charging off a loan is the last resort that the bank will do on a severely delinquent loan, with the prediction data at hand, the loan officer could offer personalized incentives like lower interest rate or longer repayment period to help customers to keep making loan payments and thus prevent the loan of getting charged off. To get to this type of prediction data, often credit unions or banks manually handcraft the data based on customers' past payment history and performed simple statistical regression analysis. This method is highly subject to data compilation error and not statistically sound.

This solution template demonstrates a solution end to end, to run predictive analytics on loan data and produce scoring on chargeoff probability. A Power BI report will also walk through the analysis and trend of credit loans and prediction of chargeoff probability.

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

## Pricing

Your Azure subscription used for the deployment will incur consumption charges on the services used in this solution, approximately $1.15/hour for the default VM.

Ensure that you stop your VM instance when not actively using the solution. If you run the VM, you will incur higher costs.

Make sure to delete the solution if you are not using it.

## Next steps

Product documentation:

- [Linux virtual machines in Azure](/azure/virtual-machines/linux/overview)
- [Run SQL Server in the cloud](/sql/linux/quickstart-install-connect-clouds)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [What is SQL Server on Windows Azure Virtual Machines?](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview)
- [Windows virtual machines in Azure](/azure/virtual-machines/windows/overview)

Microsoft Learn modules:

- [Create a Linux virtual machine in Azure](/learn/modules/create-linux-virtual-machine-in-azure)
- [Create a Windows virtual machine in Azure](/learn/modules/create-windows-virtual-machine-in-azure)
- [Create reports and dashboards with Power BI](/learn/modules/explore-power-bi)
- [Deploy and configure servers, instances, and databases for Azure SQL](/learn/modules/azure-sql-deploy-configure)

## Related resources

- [Azure Kubernetes Service (AKS) architecture design](../../reference-architectures/containers/aks-start-here.md)
- [Campaign optimization with SQL Server and machine learning](campaign-optimization-with-sql-server.yml)
- [Finance management apps using Azure Database for PostgreSQL](finance-management-apps-using-azure-database-for-postgresql.yml)
- [Finance management apps using Azure Database for MySQL](finance-management-apps-using-azure-database-for-mysql.yml)
- [Loan charge-off prediction with Azure HDInsight Spark clusters](loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)
