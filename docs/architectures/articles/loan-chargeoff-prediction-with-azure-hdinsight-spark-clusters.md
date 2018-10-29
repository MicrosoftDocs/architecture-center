---
title: Loan ChargeOff Prediction with Azure HDInsight Spark Clusters 
description: A charged off loan is a loan that is declared by a creditor (usually a lending institution) that an amount of debt is unlikely to be collected, usually when the loan repayment is severely delinquent by the debtor. Given that high chargeoff has negative impact on lending institutions' year end financials, lending institutions often monitor loan chargeoff risk very closely to prevent loans from getting charged-off. Using Azure HDInsight R Server, a lending institution can leverage machine learning predictive analytics to predict the likelihood of loans getting charged off and run a report on the analytics result stored in HDFS and hive tables.
author: adamboeglin
ms.date: 10/29/2018
---
# Loan ChargeOff Prediction with Azure HDInsight Spark Clusters 
A charged off loan is a loan that is declared by a creditor (usually a lending institution) that an amount of debt is unlikely to be collected, usually when the loan repayment is severely delinquent by the debtor. Given that high chargeoff has negative impact on lending institutions' year end financials, lending institutions often monitor loan chargeoff risk very closely to prevent loans from getting charged-off. Using Azure HDInsight R Server, a lending institution can leverage machine learning predictive analytics to predict the likelihood of loans getting charged off and run a report on the analytics result stored in HDFS and hive tables.

## Architecture
<img src="media/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.svg" alt='architecture diagram' />