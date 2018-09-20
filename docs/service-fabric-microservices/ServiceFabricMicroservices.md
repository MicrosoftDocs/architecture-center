Using the Service Fabric Platform for Breaking Up and Taming Unwieldy Applications
==================================================================================

In this example scenario, we walk through an approach using [Service Fabric](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-overview) as a platform for decomposing an unwieldy monolithic application.

Here we consider an iterative approach to decomposing an IIS/ASP.Net web site into an application composed of multiple, manageable microservices.

A large IIS application on a server farm is merely used to make the use case more concrete. This same concept of iterative decomposition and hosting can be used for any type of large application that has become difficult for your organization to manage. Neither is the concept limited to Windows. Service Fabric can run on Linux as the underlying OS also. It can be run on-premises, in Azure, or on VM nodes in the cloud provider of your choice.

Related Use Cases
-----------------

This scenario is relevant to organizations with large monolithic Web applications that are experiencing:

- Errors in small code changes that break the whole site

- Releases taking multiple days due to the need to release the site as a whole

- Difficulty onboarding and long ramp up for new developers or teams due the complex code base requiring a single individual to know more than is feasible to retain

Architecture
------------

Using Service Fabric as the hosting platform, we could turn a large IIS web site into a collection of microservices as shown below:

![](file:///./figures/clip_image002.png)

In the picture above, we decomposed all the parts of a large IIS application into:

- A routing or gateway service that accepts incoming browser requests, parses them to determine what service should handle them, then forwards the request to that service.

- Four ASP.Net Core applications that were formally virtual directories (VDirs) under the single IIS site running as ASP.Net applications. The applications were separated into their own independent microservices. The effect is that they can be changed, versioned, and upgraded separately. In this example, we rewrote each application using .Net Core and ASP.Net Core. These were written as "[Reliable Services](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-reliable-services-introduction)" so they can natively access the full Service Fabric platform capabilities and benefits (communication services, health reports, notifications, etc).

- A Windows Service, called "Indexing Service", placed in a Windows container so that it no longer makes direct changes to registry of the underlying server, but can run self-contained and be deployed with all its dependencies as a single unit.

- An Archive Service, which is just an executable that runs according to a schedule and performs some tasks for the sites. It is hosted directly as a stand-alone executable because we determined it does what it needs to do without modification and it is not worth the investment to change.

By refactoring the application, we can achieve the following benefits:

- The ability to change one small, understandable unit of code and deploy only that unit

- Code units each requiring minutes or less to deploy

- If there is an error in that small unit, only that unit stops working, not the whole application

- The small units of code can easily and discretely be distributed over multiple development teams

- New developers can quickly and easily grasp the discrete functionality of the unit

The first challenge then is to begin to identify smaller bits of code that can be factored out from the monolith into microservices that the monolith can call. Iteratively over time, with continued factoring, the monolith is broken up into a collection of these microservices that developers can easily understand, change, and quickly deploy at low risk.

However, there is another important part to making it practical to break up: a platform capable of supporting running all these microservices. This can be an issue because microservices will take on various forms. For example you may have a mix of stand-alone executables, new small web sites, new small APIs, and containerized services, etc. Service Fabric is a platform that can all these service types on a single cluster.

To get to this final, decomposed application, we used an iterative approach. We started with a large IIS/ASP.Net web site on a server farm. A single node of the server farm is pictured below. It contains the original web site with several VDirs, an additional Windows Service the site calls, and an executable that does some periodic site archive maintenance.

![](file:///C:/Users/tomta/AppData/Local/Temp/msohtmlclip1/01/clip_image004.png)

On the first development iteration, the IIS site and its VDirs placed in a Windows [Container](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-containers-overview). Doing this allows the site to remain operational, but not tightly bound to the underlying server node OS. The container is just run and orchestrated by the underlying Service Fabric node, but the node does not have to have any state that the site is dependent on (registry entries, files, etc). All of those items are in the container. We have also placed the Indexing service in a Windows Container for the same reasons. The containers can be deployed, versioned, and scaled independently. Finally, we hosted the Archive Service a simple [stand-alone exe](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-guest-executables-introduction) since it is a self-contained exe with no special requirements.

The picture below shows how our large web site is now partially decomposed into independent units and poised to be decomposed more as time allows in further iterations.

![](file:///C:/Users/tomta/AppData/Local/Temp/msohtmlclip1/01/clip_image006.png)

Further development iterations focus on separating the single large Default Web site container pictured above. Each of the VDir ASP.Net apps are removed from the container one at a time and ported to ASP.Net Core [reliable services](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-reliable-services-introduction).

Once each of the VDirs have been factored out, the Default Web site is written as an ASP.Net Core reliable service which accepts incoming browser requests and routes them to the correct ASP.Net app. The picture below shows the decomposed state we set out to achieve:

![](file:///C:/Users/tomta/AppData/Local/Temp/msohtmlclip1/01/clip_image002.png)

Availability, Scalability, and Security
---------------------------------------

Service Fabric is [capable of supporting all these various forms of microservices](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-choose-framework), while keeping calls between them on the same cluster, fast and simple. Service Fabric is a [fault tolerant](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-availability-services), self-healing cluster that can run containers, executables, and even has a native API for writing microservices directly to it (the 'Reliable Services' referred to above). The platform facilitates rolling upgrades and versioning of each microservice. You can tell the platform to run more or fewer of any given microservice distributed across the Service Fabric cluster in order to [scale](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-concepts-scalability) in or out only the microservices you need.

Considerations
--------------

Service Fabric is a cluster built on an infrastructure of virtual (or physical) nodes, which have networking, storage, and an operating system. As such, it has a set of administrative, maintenance, and monitoring tasks.

You'll also want to consider governance and control of the cluster. Just as you would not want people arbitrarily deploying databases to your production database server, neither would you want people deploying applications to the Service Fabric cluster without some oversite.

Service Fabric is capable of hosting many different [application scenarios](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-application-scenarios), take some time to see which ones apply to your scenario.

Pricing
-------

For a Service Fabric cluster hosted in Azure, the largest part of the cost is the number and size of the nodes in your cluster. Azure allows quick and simple creation of a cluster composed of the underlying node size you specify, but the compute charges are based on the node size multiplied by the number of nodes.

Other less costly components of cost are the storage charges for each node's virtual disks and network IO egress charges from Azure (for example network traffic out of Azure to a user's browser).

To get an idea of cost, we have created an example using some default values for cluster size, networking and storage: Please take a look at the [pricing calculator](https://azure.com/e/52dea096e5844d5495a7b22a9b2ccdde). Of course, please feel free to update the values in this default calculator to those relevant to your situation.

Next Steps
----------

Take some time to familiarize yourself with the platform by going through the [documentation](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-overview). The documentation will tell you what a cluster consists of, what it can run on, what it can run, architecting software for it, and maintaining it.

To see a demonstration of Service Fabric for an existing .NET application, deploy the Service Fabric [quickstart](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-dotnet).

From the standpoint of your current application, begin to think about its different functions. Choose one of them and think through how you can separate only that function from the whole. Take it one discrete, understandable, piece at a time. Before you know it, you will have 'eaten the elephant' so to speak.

Related Resources
-----------------

[Building Microservices on Azure](https://docs.microsoft.com/en-us/azure/architecture/microservices/)

[Service Fabric Overview](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-overview)

[Service Fabric Programming Model](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-choose-framework)

[Service Fabric Availability](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-availability-services)

[Scaling Service Fabric](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-concepts-scalability)

[Hosting Containers in Service Fabric](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-containers-overview)

[Hosting Stand-Alone Executables in Service Fabric](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-guest-executables-introduction)

[Service Fabric Native Reliable Services](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-reliable-services-introduction)

[Service Fabric Application Scenarios](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-application-scenarios)