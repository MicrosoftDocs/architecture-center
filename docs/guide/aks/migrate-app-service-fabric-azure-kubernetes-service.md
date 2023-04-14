---
title: Migrate a simple app from Service Fabric to AKS
description: Use an example to guide your application migration from Azure Service Fabric to Azure Kubernetes Service.  
author: allyford
ms.author: allyford
ms.date: 04/18/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-service-fabric
categories:
  - containers
  - migration
---

# Migrate a simple app from Service Fabric to AKS

This article provides an example workload migration to help you implement some of the conceptual information provided in [Migrate your workload from Service Fabric to AKS](docs/guide/aks/service-fabric-azure-kubernetes-service.md). That article provides information about Azure Kubernetes Service (AKS) and a comparison of AKS with Azure Service Fabric. It also describes considerations to take into account when you migrate your workloads. 

This example focuses on Windows-based Service Fabric applications that have already been containerized. If your application isn't containerized, consider investigating whether you can containerize it. If the application depends on Service Fabric programming models (Reliable Services, Reliable Actors, ASP.NET Core, and guest executables), you'll probably need to do some refactoring.

For information about containerizing your application, see [Prepare an application for AKS](/azure/aks/tutorial-kubernetes-prepare-app). For information about containerizing an ASP.NET application, see [ASP.NET app containerization and migration to AKS](/azure/migrate/tutorial-app-containerization-aspnet-kubernetes).

## Prerequisites

Before starting migration, you need the following prerequisites.

- An application image stored in the Azure Container Registry 
- A Bash environment for which you can configure your Azure resources. 
   - [Azure Cloud Shell](/azure/cloud-shell/overview) allows you to work from the browser: [Quickstart for Bash in Azure Cloud Shell](/azure/cloud-shell/quickstart)
   - If you're using a local installation, sign in to the Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).  
     - When prompted, install the Azure CLI extension on first use. For more information about extensions, see [Use extensions with the Azure CLI](/cli/azure/azure-cli-extensions-overview).

Once these are set up, install [kubectl](https://kubernetes.io/docs/tasks/tools/) Kubernetes command-line tool by running the following command: 

```
az aks install-cli 
```

## Steps

The first step will be to set up the resources needed to build a Windows node pool in Kubernetes. [Everything you need is in this guide here](), but for the purposes of this guide stop once you reach the “Deploy the application” section – we’ll be doing that here!  

One of the most important pieces to consider when moving over is how to translate the Service Fabric configuration manifest to an AKS manifest.  Figure 1 is a sample ServiceManifest XML which you might use for a basic Service Fabric deployment. Figure 2 is a functionally equivalent AKS manifest which creates a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and [Service](https://kubernetes.io/docs/concepts/services-networking/service/) objects. The manifests between these services do not have a direct 1-1 mapping as they follow the functional paradigms specific to each service, but the overall intent is the same. A Deployment provides declarative updates for [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) and [ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/), while a Service exposes an application running on a set of Pods as a network service. Much of the power of Kubernetes is offered through its extensibility.

```
<?xml version="1.0" encoding="utf-8"?>

<ServiceManifest Name="<APP NAME>"
                 Version="1.0.0"
                 xmlns="http://schemas.microsoft.com/2011/01/fabric"
                 xmlns:xsd="https://www.w3.org/2001/XMLSchema"
                 xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance">
  <ServiceTypes>
    <StatelessServiceType ServiceTypeName="<SERVICE NAME>" UseImplicitHost="true" />
  </ServiceTypes>
 
  <!-- Code package is your service executable. -->
  <CodePackage Name="Code" Version="1.0.0">
    <EntryPoint>
      <ContainerHost>
        <ImageName><YOUR IMAGE></ImageName>
        <Commands></Commands>
      </ContainerHost>
    </EntryPoint>
    <!-- Pass environment variables to your container: -->    
    <EnvironmentVariables>
      <EnvironmentVariable Name="HttpGatewayPort" Value=""/>
      <EnvironmentVariable Name="BackendServiceName" Value=""/>
    </EnvironmentVariables>
 
  </CodePackage>
 
  <ConfigPackage Name="Config" Version="1.0.0" />
 
  <Resources>
    <Endpoints>
      <Endpoint Name="<HTTP ENDPOINT NAME>" UriScheme="http" Port="80" Protocol="http"/>
    </Endpoints>
  </Resources>
</ServiceManifest>
```
igure 2: Sample Service Fabric ServiceManifest. Note that <VARIABLE> notation refers to variable names of your choosing.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: <APP NAME>
  labels:
    app: <APP NAME>
spec:
  replicas: 1
  template:
    metadata:
      name: <APP NAME>
      labels:
        app: <APP NAME>
    spec:
      nodeSelector:
        "kubernetes.io/os": windows
      containers:
      - name: <SERVICE NAME>
        image: <YOUR IMAGE>
        resources:
          limits:
            cpu: 1
            memory: 800M
        ports:
          - containerPort: 80
	- env:
	    - name: HttpGatewayPort
	      value: ""
	    - name: BackendServiceName
	      value: ""
  selector:
    matchLabels:
      app: <APP NAME>
---
apiVersion: v1
kind: Service
metadata:
  name: <SERVICE NAME>
spec:
  type: LoadBalancer
  ports:
  - protocol: TCP
    port: 80
  selector:
    app: <SERVICE NAME>
```
Figure 3: AKS Config Manifest

Kubernetes provides a vast toolset of configuration options, which is very useful for experienced operators, but can lead to large and complex manifests. In this case it is recommended you read through our explanation of [Deployment YAML manifests](/azure/aks/concepts-clusters-workloads#deployments-and-yaml-manifests) and some of the standard configurations.  

```
kubectl apply -f <YOUR MANIFEST>.yaml
kubectl get service <SERVICE NAME> --watch
```

From here it’s just a matter of applying your manifest and watching your app go!

> [!NOTE] 
> This example utilizes the default Kubernetes namespace which is generally only used for basic scenarios. In Kubernetes, namespaces provide a mechanism for isolating groups of resources within a single cluster. Namespaces are important in enforcing security, networking, and resources boundaries. Follow the documentation here to help decide what configuration works best for your application: [Namespaces | Kubernetes](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ally Ford](https://www.linkedin.com/in/allison-ford-pm/) | Product Manager II 
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer 
- [Brandon Smith](https://www.linkedin.com/in/brandonsmith68/) | Program Manager II 

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Senior Program Manager 
- [Moumita Dey Verma](https://www.linkedin.com/in/moumita-dey-verma-8b61692a/) | Senior Cloud Solutions Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps  

- AKS news: [AKS release notes](https://github.com/Azure/AKS/releases), the [AKS Roadmap](https://github.com/Azure/AKS/projects/1), and [Azure updates](https://azure.microsoft.com/updates/)
- Use the [latest windows server images](/virtualization/windowscontainers/manage-containers/container-base-images) as we are constantly making updates, maintaining security, improving performance, and reducing overhead. 
- Keep up to date with the [latest version of Kubernetes](/azure/aks/release-tracker). 
- Utilize the [latest frameworks for .NET workloads](/dotnet/azure/sdk/azure-sdk-for-dotnet)Consider performing load tests and performance tuning and periodically assess CPU and Memory quotas applied to AKS pods: [Monitor Azure Kubernetes Service (AKS) with Azure Monitor - Azure Kubernetes Service | Microsoft Learn](/azure/aks/monitor-aks) 
- Learn how rapidly create and operate workloads on AKS using proven practices with the [AKS Landing Zone Accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator)
- Learn about [day-2 operations on AKS](/azure/architecture/operator-guides/aks/day-2-operations-guide?WT.mc_id=AKSDOCSPAGE)

## Related resources

Link to Transition your workload from Service Fabric to AKS article 