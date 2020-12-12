


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

In an energy grid, energy consumers are engaged with various types of energy supplying, trading, and storage components such as substations, batteries, windfarms and solar panels, micro-turbines, as well as demand response bids, to meet their respective demands and minimize the cost of energy commitment. To do so, the grid operator must determine how much energy each type of the resources should commit over a time frame, given the prices of soliciting different types of resources and the capacities and the physical characteristics of them.

This solution is built upon Cortana Intelligence Suite and external open-source tools, and it computes the optimal energy unit commitments from various types of energy resources. This solution demonstrates the ability of Cortana Intelligence Suite to accommodating external tools, to solve parallelized numerical optimization problems over an Azure Batch of Azure Virtual Machines.

## Architecture

![Architecture Diagram](../media/energy-supply-optimization.png)
*Download an [SVG](../media/energy-supply-optimization.svg) of this architecture.*

## Description

Save time and let one of these [trained SI partners](https://aka.ms/energysupplyoptimization-sipartners) help you with a proof of concept, deployment & integration of this solution.

Estimated Daily Cost: [$12](https://azure.github.io/Azure-CloudIntelligence-SolutionAuthoringWorkspace/solution-prices#resource-optimization)

For more details on how this solution is built, visit the solution guide in [GitHub](https://github.com/Azure/cortana-intelligence-energy-supply-optimization).

An energy grid consists of energy consumers, as well as various types of energy supplying, trading, and storage components: Substations accepts power load or exports excessive power; Batteries may discharge energy or store it for future use; Windfarms and solar panel (self-scheduled generators), micro-turbines (dispatchable generators), and demand response bids can all be engaged to satisfying the demand from the consumers within the grid. The costs of soliciting different types of resources vary, while the capacities and the physical characteristics of each resource type limit the dispatch of the resource. Given all these constraints, a central challenge the smart grid operator must face, is how much energy each type of the resources should commit over a time frame, so that the forecasted energy demand from the grid are satisfied.

This solution provides an Azure-based smart solution, leveraging external open-source tools, that determines the optimal energy unit commitments from various types of energy resources for an energy grid. The goal is to minimize the overall cost incurred by these commitments while satisfying the energy demand. This solution demonstrates the ability of Azure to accommodating external tools, such as Pyomo and CBC, to solve large-scale numerical optimization problems such as mixed integer-linear programming, parallelizing multiple optimization tasks over an Azure Batch of Azure Virtual Machines. Other involved products include Azure Blob Storage, Azure Queue Storage, Azure Web App, Azure SQL Database, as well as Power BI.

## Technical details and workflow

  1. The sample data is streamed by newly deployed Azure Web Jobs. The web job uses resource related data from Azure SQL to generate the simulated data.
  2. The data simulator feeds this simulated data into the Azure Storage and writes message in Storage Queue, that will be used in the rest of the solution flow.
  3. Another Web Job monitors the storage queue and initiate an Azure Batch job once message in the queue is available.
  4. The Azure Batch service together with Data Science Virtual Machines is used to optimize the energy supply from a particular resource type given the inputs received.
  5. Azure SQL Database is used to store the optimization results received from the Azure Batch service. These results are then consumed in the Power BI dashboard.
  6. Finally, Power BI is used for results visualization.
