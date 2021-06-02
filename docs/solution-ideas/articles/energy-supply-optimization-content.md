


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

## Description

An energy grid consists of energy consumers, and various types of energy supplying, trading, and storage components: Substations accept power load or exports excessive power; Batteries may discharge energy or store it for future use; Windfarms and solar panel (self-scheduled generators), micro-turbines (dispatchable generators), and demand response bids can all be engaged to satisfying the demand from the consumers within the grid. The costs of soliciting different types of resources vary, while the capacities and the physical characteristics of each resource type limit the dispatch of the resource. Given all these constraints, a central challenge the smart grid operator must face, is how much energy each type of the resources should commit over a time frame, so that the forecasted energy demand from the grid is satisfied.

This solution provides an Azure-based smart solution, applying external open-source tools, to determine the optimal energy unit commitments from various energy resources for an energy grid. The goal is to minimize the overall cost incurred by these commitments while satisfying the energy demand. This solution demonstrates the ability of Azure to accommodating external tools, such as Pyomo and CBC, to solve large-scale numerical optimization problems such as mixed integer-linear programming, parallelizing multiple optimization tasks over an Azure Batch of Azure Virtual Machines. Other involved products include Azure Blob Storage, Azure Queue Storage, Azure Web App, Azure SQL Database, and Power BI.

For more details on how this solution is built, visit the solution guide in [GitHub](https://github.com/Azure/cortana-intelligence-energy-supply-optimization).

## Architecture

![Architecture Diagram](../media/energy-supply-optimization.png)
*Download an [SVG](../media/energy-supply-optimization.svg) of this architecture.*

## Technical details and workflow

  1. The sample data is streamed by newly deployed Azure Web Jobs. The web job uses resource-related data from Azure SQL to generate the simulated data.
  2. The data simulator feeds this simulated data into the Azure Storage and writes message in Storage Queue, that will be used in the rest of the solution flow.
  3. Another Web Job monitors the storage queue and initiate an Azure Batch job once message in the queue is available.
  4. The Azure Batch service together with Data Science Virtual Machines is used to optimize the energy supply from a particular resource type given the inputs received.
  5. Azure SQL Database is used to store the optimization results received from the Azure Batch service. These results are then consumed in the Power BI dashboard.
  6. Finally, Power BI is used for results visualization.
