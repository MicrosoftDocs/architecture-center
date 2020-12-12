


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Customer Churn Prediction uses Cortana Intelligence Suite components to predict churn probability and helps find patterns in existing data associated with the predicted churn rate.

## Architecture

![Architecture Diagram](../media/customer-churn-prediction.png)
*Download an [SVG](../media/customer-churn-prediction.svg) of this architecture.*

## Description

For more details on how this solution is built, visit the solution guide in [GitHub](https://github.com/Azure/cortana-intelligence-churn-prediction-solution).

Keeping existing customers is five times cheaper than the cost of attaining new ones. For this reason, marketing executives often find themselves trying to estimate the likelihood of customer churn and finding the necessary actions to minimize the churn rate.

Customer Churn Prediction uses Azure Machine Learning to predict churn probability and helps find patterns in existing data associated with the predicted churn rate. This information empowers businesses with actionable intelligence to improve customer retention and profit margins.

The objective of this guide is to demonstrate predictive data pipelines for retailers to predict customer churn. Retailers can use these predictions to prevent customer churn by using their domain knowledge and proper marketing strategies to address at-risk customers. The guide also shows how customer churn models can be retrained to leverage additional data as it becomes available.

## What's Under the Hood

The end-to-end solution is implemented in the cloud, using Microsoft Azure. The solution is composed of several Azure components, including data ingest, data storage, data movement, advanced analytics and visualization. The advanced analytics are implemented in Azure Machine Learning, where one can use Python or R language to build data science models (or reuse existing in-house or third-party libraries). With data ingest, the solution can make predictions based on data that being transferred to Azure from an on-premises environment.

## Solution Dashboard

The snapshot below shows an example PowerBI dashboard that gives insights into the the predicted churn rates across the customer base.

![Insights](https://azurecomcdn.azureedge.net/cvt-add179e08f40a2f574f2c13e23c39140f82f2f0c5faf32b8e79061bb1ec3c7ca/images/shared/solutions/architectures/customer-churn-prediction/dashboard.png)
