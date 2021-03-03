


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Using SQL Server 2016 with R Services, a lending institution can make use of predictive analytics to reduce number of loans they offer to those borrowers most likely to default, increasing the profitability of their loan portfolio.

## Architecture

![Architecture Diagram](../media/loan-credit-risk-with-sql-server.png)
*Download an [SVG](../media/loan-credit-risk-with-sql-server.svg) of this architecture.*

## Overview

If we had a crystal ball, we would only loan money to someone we knew would pay us back. A lending institution can make use of predictive analytics to reduce number of loans they offer to those borrowers most likely to default, increasing the profitablity of their loan portfolio. This solution uses simulated data for a small personal loan financial institution, building a model to help detect whether the borrower will default on a loan.

## Business Perspective

The business user uses the predicted scores to help determine whether or not to grant a loan. He fine tunes his prediction by using the PowerBI Dashboard to see the number of loans and the total dollar amount saved under different scenarios. The dashboard includes a filter based on percentiles of the predicted scores. When all the values are selected, he views all the loans in the testing sample, and can inspect information about how many of them defaulted. Then by checking just the top percentile (100), he drills down to information about loans with a predicted score in the top 1%. Checking multiple continuous boxes allows him to find a cutoff point he is comfortable with to use as a future loan acceptance criteria.

Use the "Try It Now" button below to view the PowerBI Dashboard.

## Data Scientist Perspective

SQL Server R Services brings the compute to the data by running R on the computer that hosts the database. It includes a database service that runs outside the SQL Server process and communicates securely with the R runtime.

This solution walks through the steps to create and refine data, train R models, and perform scoring on the SQL Server machine. The final scored database table in SQL Server gives a predicted score for each potential borrower. This data is then visualized in PowerBI.

Data scientists who are testing and developing solutions can work from the convenience of their R IDE on their client machine, while [pushing the compute to the SQL Server machine](/sql/advanced-analytics/r/getting-started-with-sql-server-r-services). The completed solutions are deployed to SQL Server 2016 by embedding calls to R in stored procedures. These solutions can then be further automated with SQL Server Integration Services and SQL Server agent.

Use the "Deploy" button below to create a Virtual Machine that includes the data, R code, SQL code, and a SQL Server 2016 database (Loans) containingn the full solution.

## Pricing

Your Azure subscription used for the deployment will incur consumption charges on the services used in this solution, approximately $1.15/hour for the default VM.

Please ensure that you stop your VM instance when not actively using the solution. Running the VM will incur higher costs.

Please delete the solution if you are not using it.