[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

By using SQL Server 2016 and later with Machine Learning Services, a lending institution can make use of predictive analytics to reduce number of loans they offer to those borrowers most likely to default, increasing the profitability of their loan portfolio.

## Architecture

![Architecture Diagram](../media/loan-credit-risk-with-sql-server.png)
*Download the [Visio file](../media/loan-credit-risk-with-sql-server.vsdx) of this architecture.*

### Data flow

Start a Windows or Linux version of the Azure Data Science Virtual Machine. Connect to your data source. Use your preferred IDE to develop Python and/or R models. When the model is ready, [publish it to SQL Server](https://docs.microsoft.com/sql/machine-learning/deploy/modify-r-python-code-to-run-in-sql-server), incorporate into your Azure Machine Learning workspace, or visualize in Power BI.  

### Components

* [SQL Server Machine Learning Services](/sql/machine-learning/sql-server-machine-learning-services?view=sql-server-ver15): SQL Server stores the lender and borrower data. R-based analytics provide training and predicted models, as well as predicted results for consumption.
* [Data Science Virtual Machine](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.
* [Power BI](https://powerbi.microsoft.com) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.

## Solution details

If we had a crystal ball, we would only loan money to someone we knew would pay us back. A lending institution can make use of predictive analytics to reduce number of loans they offer to those borrowers most likely to default, increasing the profitability of their loan portfolio. This solution uses simulated data for a small personal loan financial institution, building a model to help detect whether the borrower will default on a loan.

### Business perspective

The business user uses the predicted scores to help determine whether or not to grant a loan. He fine tunes his prediction by using the Power BI Dashboard to see the number of loans and the total dollar amount saved under different scenarios. The dashboard includes a filter based on percentiles of the predicted scores. When all the values are selected, he views all the loans in the testing sample, and can inspect information about how many of them defaulted. Then by checking just the top percentile (100), he drills down to information about loans with a predicted score in the top 1%. Checking multiple continuous boxes allows him to find a cutoff point he is comfortable with to use as a future loan acceptance criteria.

### Data scientist perspective

SQL Server Machine Learning Services brings the compute to the data by running R or Python on the computer that hosts the database. It includes a database service that runs outside the SQL Server process and communicates securely with the R or Python runtime.

This solution walks through the steps to create and refine data, train R or Python models, and perform scoring on the SQL Server machine. The final scored database table in SQL Server gives a predicted score for each potential borrower. This data is then visualized in Power BI.

Data scientists who are testing and developing solutions can work from the convenience of their R IDE on their client machine, while [pushing the compute to the SQL Server machine](/sql/advanced-analytics/r/getting-started-with-sql-server-r-services). The completed solutions are deployed to SQL Server 2019 by embedding calls to R in stored procedures. These solutions can then be further automated with SQL Server Integration Services and SQL Server agent.

## Next steps

* [Get started with SQL Server R Services](/sql/advanced-analytics/r/getting-started-with-sql-server-r-services)
* [Learn more about Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-service-get-started)
