# Design principles for Azure applications

**[Use managed services.](managed-services.md)** When possible, use Platform as a Service (PaaS) over Infrastructure as a Service (IaaS).

**[Minimize coordination.](minimize-coordination.md)** Minimize coordination between application services to achieve scalability.
 
**[Partition around limits.](partition.md)** Use partitioning to work around database, network, and compute limits.

**[Design for scale out/in.](scale-out.md)** Design your application so that it can scale horizontally, adding or removing new instances as demand requires.

**[Design for self-healing.](self-healing.md)** In a distributed system, failures happen. Design your application to be self-healing when failures occur.

**[Make all things redundant.](redundancy.md)** Build redundancy into your application, to avoid having single points of failure.
 
**[Use the best data store for the job.](use-the-best-data-store.md)** Pick the storage technology that is the best fit for your data and how it will be used. 
 
**[Design for change.](design-for-change.md)** All successful applications change over time. An evolutionary design is key for continuous innovation.

**[Design for operations.](design-for-operations.md)** Design your application so that the operations team has the tools they need.

**[Build for the needs of business.](build-for-business.md)** Every design decision must be justified by a business requirement.

