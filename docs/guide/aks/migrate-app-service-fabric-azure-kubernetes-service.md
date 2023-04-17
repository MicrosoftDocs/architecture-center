---
title: Migrate a simple app from Service Fabric to AKS
description: Use an example to guide the migration of your application from Azure Service Fabric to Azure Kubernetes Service.  
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

This article provides an example workload migration to help you implement some of the conceptual information provided in [Migrate your workload from Service Fabric to AKS](service-fabric-azure-kubernetes-service.md). That article provides information about Azure Kubernetes Service (AKS) and a comparison of AKS with Azure Service Fabric. It also describes considerations to take into account when you migrate your workloads. 

This example focuses on Windows-based Service Fabric applications that have already been containerized. If your application isn't containerized, consider investigating whether you can containerize it. If the application depends on Service Fabric programming models (Reliable Services, Reliable Actors, ASP.NET Core, and guest executables), you'll probably need to do some refactoring.

For information about containerizing your application, see [Prepare an application for AKS](/azure/aks/tutorial-kubernetes-prepare-app). For information about containerizing an ASP.NET application, see [ASP.NET app containerization and migration to AKS](/azure/migrate/tutorial-app-containerization-aspnet-kubernetes).

## Prerequisites

Before you start the migration, you need:

- An application image that's stored in Azure Container Registry. 
- A Bash environment that you can use to configure your Azure resources. 
   - [Azure Cloud Shell](/azure/cloud-shell/overview) enables you to work from the browser. For more information, see [Quickstart for Bash in Azure Cloud Shell](/azure/cloud-shell/quickstart).
   - If you're using a local installation, sign in to the Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).  
  
     The first time you use Azure CLI, you need to install the Azure CLI extension when prompted. For more information about extensions, see [Use extensions with the Azure CLI](/cli/azure/azure-cli-extensions-overview).
- The [kubectl](https://kubernetes.io/docs/tasks/tools/) Kubernetes command-line tool. Install it by running this command: 

   ```azurecli    
   az aks install-cli 
   ```

## Migration steps

The first step is to set up the resources that you need to build a Windows node pool in Kubernetes. To do that, follow the guidance in [Create a Windows Server container on an AKS cluster](/azure/aks/learn/quick-windows-container-deploy-cli), but *be sure to stop* when you reach the "Deploy the application" section. At that point, follow the instructions in this article.  

The translation of the Service Fabric configuration manifest to an AKS manifest is an important step. The following sections show:
- ServiceManifest XML that you might use for a basic Service Fabric deployment. 
- A functionally equivalent AKS manifest that creates Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and [Service](https://kubernetes.io/docs/concepts/services-networking/service/) objects. 

The two manifests don't map one-to-one because they're based on the functional paradigms that are specific to each service, but their intents are the same. (In these samples, variables use the format `<VARIABLE DESCRIPTION>`.)

In the AKS manifest, a `Deployment` object provides declarative updates for [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) and [ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/). A `Service` object exposes an application that's running on a set of pods as a network service. Much of the power of Kubernetes comes from its extensibility.

### Sample Service Fabric ServiceManifest

```xml
<?xml version="1.0" encoding="utf-8"?>

<ServiceManifest Name="<APP NAME>"
                 Version="1.0.0"
                 xmlns="http://schemas.microsoft.com/2011/01/fabric"
                 xmlns:xsd="https://www.w3.org/2001/XMLSchema"
                 xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance">
  <ServiceTypes>
    <StatelessServiceType ServiceTypeName="<SERVICE NAME>" UseImplicitHost="true" />
  </ServiceTypes>
 
  <!-- Code package is your service executable file. -->
  <CodePackage Name="Code" Version="1.0.0">
    <EntryPoint>
      <ContainerHost>
        <ImageName><YOUR IMAGE></ImageName>
        <Commands></Commands>
      </ContainerHost>
    </EntryPoint>
    <!-- Pass environment variables to your container. -->    
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

### Sample AKS manifest

```yml
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

Kubernetes provides a large set of configuration options, which is useful for experienced developers. But manifests can become large and complex when you use too many of them. To learn about implementing a simple migration, we recommend that you review [Deployments and YAML manifests](/azure/aks/concepts-clusters-workloads#deployments-and-yaml-manifests). 
 
After you have your manifest, you just need to apply it, and you can watch your app:

```
kubectl apply -f <YOUR MANIFEST>.yaml
kubectl get service <SERVICE NAME> --watch
```

> [!NOTE] 
> This example uses the default Kubernetes namespace, which is generally used only for basic scenarios. In Kubernetes, namespaces provide a mechanism for isolating groups of resources within a single cluster. Namespaces are important for enforcing security, networking, and resource boundaries. To determine a configuration that works best for your application, see the Kuberetes [namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) documentation.

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

- Keep up-to-date on AKS with [AKS release notes](https://github.com/Azure/AKS/releases), the [AKS Roadmap](https://github.com/Azure/AKS/projects/1), and [Azure updates](https://azure.microsoft.com/updates/).
- Use the [latest windows server images](/virtualization/windowscontainers/manage-containers/container-base-images) to help maintain security, improve performance, and reduce overhead. 
- Use the [AKS release tracker](/azure/aks/release-tracker) to keep up-to-date with the latest version of Kubernetes. 
- Use the [latest SDK for .NET workloads](/dotnet/azure/sdk/azure-sdk-for-dotnet).
- Consider performing load tests and performance tuning, and periodically assess CPU and memory quotas that are applied to AKS pods: [Monitor AKS with Azure Monitor](/azure/aks/monitor-aks).
- Use the [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator) to implement workloads on AKS and apply best practices.

## Related resources

- [Migrate your workload from Service Fabric to AKS](service-fabric-azure-kubernetes-service.md)
- [AKS day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)
- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- [AKS architecture design](../../reference-architectures/containers/aks-start-here.md)