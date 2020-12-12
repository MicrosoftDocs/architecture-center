


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Quality assurance systems allow businesses to prevent defects throughout their processes of delivering goods or services to customers. Building such a system that collects data and identifies potential problems along a pipeline can provide enormous advantages. For example, in digital manufacturing, quality assurance across the assembly line is imperative. Identifying slowdowns and potential failures before they occur rather than after they are detected can help companies reduce costs for scrap and rework while improving productivity.

This solution shows how to predict failures using the example of manufacturing pipelines (assembly lines). This is done by leveraging test systems already in place and failure data, specifically looking at returns and functional failures at the end of assembly line. By combining these with domain knowledge and root cause analysis within a modular design that encapsulates main processing steps, we provide a generic advanced analytics solution that uses machine learning to predict failures before they happen. Early prediction of future failures allows for less expensive repairs or even discarding, which are usually more cost efficient than going through recall and warranty cost.

## Architecture

![Architecture Diagram](../media/quality-assurance.png)
*Download an [SVG](../media/quality-assurance.svg) of this architecture.*

## Description

Save time and let one of these trained SI partners help you with a proof of concept, deployment & integration of this solution.

The Cortana Intelligence Suite provides advanced analytics tools through Microsoft Azure - data ingestion, data storage, data processing and advanced analytics components - all of the essential elements for building a Quality Assurance for Manufacturing solution. The solution is implemented in the cloud, using the flexible on-line Microsoft Azure platform that decouples infrastructure components (data ingestion, storage, data movement, visualization) from analytics engine that supports modern DS languages like R and Python. The solution modeling component can thus be retrained as needed and be implemented using high performance Azure Machine Learning algorithms, or open source (R/Python) libraries, or from a third-party solution vendor. The 'Deploy' button will launch a workflow that will deploy an instance of the solution within a Resource Group in the Azure subscription you specify. The solution includes multiple Azure services (described below) along with a web job that simulates data so that immediately after deployment you have a working end-to-end solution. For post deployment instructions and more details on the technical implementation, please see the instructions.

## Technical details and workflow

  1. The Manufacturing Assembly Line simulation data is streamed by the newly deployed Azure Web Jobs.
  2. This synthetic data feeds into the Azure Event Hubs as data points/events, that will be consumed in the rest of the solution flow and stored in Azure Synapse Analytics.
  3. There are 2 Azure Stream Analytics jobs used in this pattern to provide near real-time analytics on the input stream from the Azure Event Hub. Both jobs filter through the input data and pass the data points along to a Azure Machine Learning endpoint sending the results to a Power BI Dashboard.
  4. Finally, Power BI is used for results visualization.
