This architecture provides guidance for designing a carrier-grade solution for a telecommunication use case. The design choices focus on high reliability by minimizing points of failure and ultimately the overall downtime using native Azure capabilities. It applies the design principles for [Well-Architected carrier-grade workloads](/azure/architecture/framework/carrier-grade/carrier-grade-get-started) to a carrier-grade application. 

The server is composed of two layers. Each layer is a collection of immutable service instances (SIs). There are differences between the two layers based on their distinct functions and different lifetimes.

- Application SIs deliver the actual application function. They Each instance is immutable and intended to be short-lived. 
- Management SIs only deliver the management and monitoring aspects for the application. There is coupling with the application SI.

There are common aspects. All SIs are interchangeable in that any SI can service any request. 

Various clients connect to the server using different protocols potentially for different classes of server operation being requested. 

 that delivers to a large set of subscribers and stores state related to each subscriber in a database.  It allows for different types of clients connecting to the server using different protocols, potentially for different classes of server operation being requested.  Some of the operations will result in data being written into a database, and other operations will retrieve and/or delete that data.  These operations can be viewed as simple request/response, meaning there is no long-lived session associated with these, and interruption of any of these operations will just lead to the client retrying. 