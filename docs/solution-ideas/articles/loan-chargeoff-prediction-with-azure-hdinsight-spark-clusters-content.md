


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

A charged off loan is a loan that is declared by a creditor (usually a lending institution) that an amount of debt is unlikely to be collected, usually when the loan repayment is severely delinquent by the debtor. Given that high chargeoff has negative impact on lending institutions' year end financials, lending institutions often monitor loan chargeoff risk very closely to prevent loans from getting charged-off. Using Azure HDInsight R Server, a lending institution can use machine learning predictive analytics to predict the likelihood of loans getting charged off and run a report on the analytics result stored in HDFS and hive tables.

## Architecture

![Architecture diagram](../media/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.png)
*Download an [SVG](../media/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.svg) of this architecture.*

## Description

This solution will create an HDInsight Spark cluster with Microsoft R Server. This cluster will contain 2 head nodes, 2 worker nodes, and 1 edge node with a total of 32 cores. The approximate cost for this HDInsight Spark cluster is $8.29/hour. Billing starts once a cluster is created and stops when the cluster is deleted. Billing is pro-rated per minute, so you should always delete your cluster when it is no longer in use. Use the Deployments page to delete the entire solution once you are done.

## Overview

There are multiple benefits for lending institutions to equip with loan chargeoff prediction data. Charging off a loan is the last resort that the bank will do on a severely delinquent loan, with the prediction data at hand, the loan officer could offer personalized incentives like lower interest rate or longer repayment period to help customers to keep making loan payments and thus prevent the loan of getting charged off. To get to this type of prediction data, often credit unions or banks manually handcraft the data based on customers' past payment history and performed simple statistical regression analysis. This method is highly subject to data compilation error and not statistically sound.

This solution template demonstrates a solution end to end to run predictive analytics on loan data and produce scoring on chargeoff probability. A PowerBI report will also walk through the analysis and trend of credit loans and prediction of chargeoff probability.

## Business Perspective

This loan chargeoff prediction uses a simulated loan history data to predict probability of loan chargeoff in the immediate future (next three months). The higher the score, the higher is the probability of the loan getting charged-off in the future.

With the analytics data, loan manager is also presented with the trends and analytics of the chargeoff loans by branch locations. Characteristics of the high chargeoff risk loans will help loan managers to make business plan for loan offering in that specific geographical area.

Microsoft R Server on HDInsight Spark clusters provides distributed and scalable machine learning capabilities for big data, using the combined power of R Server and Apache Spark. This solution demonstrates how to develop machine learning models for predicting loan chargeoff (including data processing, feature engineering, training and evaluating models), deploy the models as a web service (on the edge node) and consume the web service remotely with Microsoft R Server on Azure HDInsight Spark clusters. The final predictions is saved to a Hive table which could be visualized in Power BI.

Power BI also presents visual summaries of the loan payments and chargeoff predictions (shown here with simulated data). You can try out this dashboard by clicking the "Try it Now" button to the right.

## Data Scientist Perspective

This solution template walks through the end-to-end process of how to develop predict analytics using a set of simulated loan history data to predict loan chargeoff risk. The data contains information like loan holder demographic data, loan amount, contractual loan duration and loan payment history. The solution template also includes a set of R scripts that perform data processing, feature engineering, and several different algorithms to train the data, and finally select the best performant model to score the data to produce probability score for each loan. The solution also include scripts to deploy the model as a web service (on the edge node) and consuming the web service remotely with Microsoft R Server on Azure HDInsight Spark clusters.

Data scientists who are testing this solution can work with the provided R code from the browser-based Open Source Edition of RStudio Server that runs on the Edge Node of the Azure HDInsight Spark cluster. By [setting the compute context](/azure/hdinsight/hdinsight-hadoop-r-server-compute-contexts) the user can decide where the computation will be performed: locally on the edge node, or distributed across the nodes in the Spark cluster. All the R code can also be found in public GitHub repository. Have fun!