


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Marketing campaigns are about more than the message being delivered; when and how that message is delivered is just as important. Without a data-driven, analytical approach, campaigns can easily miss opportunities or struggle to gain traction.

Through machine learning informed by historical campaign data, this solution helps predict customer responses and recommends an optimized plan for connecting with your leads-including the best channel to use (by email, SMS, a cold call, etc.), the best day of the week, and the best time of the day.

Optimizing your campaigns with machine learning helps improve both sales leads and revenue generation and can provide strong ROI for your marketing investment.

In this solution, SQL Server R Services brings the compute to the data by running R on the computer that hosts the database.

## Architecture

![Architecture Diagram](../media/optimize-marketing-with-machine-learning.png)
*Download an [SVG](../media/optimize-marketing-with-machine-learning.svg) of this architecture.*

## Components

* [SQL Server R Services](/sql/machine-learning/r/sql-server-r-services?view=sql-server-2016): SQL Server stores the campaign and lead data. R-based analytics provide training and predicted models and predicted results for consumption using R.
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Machine Learning helps you design, test, operationalize, and manage predictive analytics solutions in the cloud.
* [Power BI](https://powerbi.microsoft.com) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.

## Next steps

* [Get started with SQL Server R Services](/sql/machine-learning/r/sql-server-r-services?view=sql-server-2016)
* [Learn more about Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)