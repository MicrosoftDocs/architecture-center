[Apache NiFi][Apache NiFi] users often need to deploy NiFi on Kubernetes. At a minimum, a Kubernetes deployment involves the following objects:

- Pods that run NiFi in containers.
- Volumes that store configuration information and data because. Pod storage is temporary.
- Configuration objects that Kubernetes uses to manage the NiFi instances that it deploys.
- A service that makes the NiFi UI available to users.

It's difficult to manage the *manifests*, or specification files, that Kubernetes uses for this number of objects. The difficulty increases when you deploy multiple NiFi clusters that use different configurations.

Helm charts provide a solution for managing the manifests. Helm is the package manager for Kubernetes. By using the Helm tool, you can streamline the process of installing and managing Kubernetes applications.

Helm uses a packaging format called a *chart*. A Helm chart is a collection of files that describe a related set of Kubernetes resources. You might use a single chart to deploy something simple, like a *memcached* pod. Or you might deploy something complex. Examples include a full stack web app with HTTP servers, databases, caches, and other components.

Helm charts convert into Kubernetes manifest files. You create a chart in a folder with a tree structure. You can enter NiFi configuration requirements into the chart files. You can also package the chart into versioned archives. Kubernetes uses the chart to deploy different configurations of NiFi.

## Architecture

:::image type="content" source="./media/helm-deployments-apache-nifi-architecture.svg" alt-text="Diagram showing the flow of data between a NiFi cluster and MonitoFi. Other architecture components include Application Insights, InfluxDB, and Grafana." border="false" lightbox="./media/helm-deployments-apache-nifi-architecture-lightbox":::

*Download an [SVG file][SVG file of architecture diagram] of this architecture.*

- A Helm chart contains a `values.yaml` file. That file lists input values that users can configure.

- A user enters information into a chart:

  - Volume sizes
  - The number of pods
  - User authentication and authorization mechanisms

- The user runs the Helm `install` command to deploy the chart.

- Helm checks whether the user input contains values for all required variables.

- Helm creates a manifest that describes the objects to deploy on Kubernetes.

- Helm sends the manifest to the Kubernetes cluster. ZooKeeper provides cluster coordination.

- Kubernetes creates the specified objects. A NiFi deployment requires these objects:

  - Configuration objects.
  - Data volumes.
  - A log volume.
  - Pods that use an image to run NiFi in a container. Kubernetes uses a StatefulSet workload resource to manage the pods.
  - A Kubernetes service.
  - Ingress routes if the cluster uses ingress and makes the UI available through ingress.

## Components

A NiFi deployment uses the following components:

### ZooKeeper

ZooKeeper uses a separate chart. You can use the standard ZooKeeper chart that Kubernetes supplies in its [incubator chart repository][Helm Incubator]. But when your dependencies include public registry content, you introduce risk into your image development and deployment workflows. To mitigate this risk, keep local copies of public content when you can. For detailed information, see [Manage public content with Azure Container Registry][Manage public content with Azure Container Registry].

As an alternative, you can deploy ZooKeeper on your own. If you choose this option, provide the ZooKeeper server and port number so that the pods that run NiFi can access the ZooKeeper service.

### Kubernetes StatefulSet

To run an application on Kubernetes, you run a pod. This basic unit runs different containers that implement the application's different activities.

Kubernetes offers two solutions for managing pods that run an application like NiFi:

- A *ReplicaSet*, which maintains a stable set of the replica pods that run at any given time. You often use a ReplicaSet to guarantee the availability of a specified number of identical pods.
- A *StatefulSet*, or the workload API object that you use to manage stateful applications. A StatefulSet manages pods that are based on an identical container specification. Kubernetes creates these pods from the same specification. But these pods aren't interchangeable. Each pod has a persistent identifier that it maintains across rescheduling.

Since NiFi manages data, a StatefulSet provides the best pod-management solution in this case.

### Data disks

Concerning disk usage, consider disk striping and using multiple disks for repositories. In test deployments that used virtual machine scale sets, this approach worked best. The following excerpt from `nifi.properties` shows a disk usage configuration:

```config
nifi.flowfile.repository.directory=/data/partition1/flowfiles
nifi.provenance.repository.directory.stripe1=/data/partition1/provenancenifi.provenance.repository.directory.stripe2=/data/partition2/provenancenifi.provenance.repository.directory.stripe3=/data/partition3/provenancenifi.content.repository.directory.stripe2=/data/partition2/content
nifi.content.repository.directory.stripe3=/data/partition3/content
```

This configuration uses three volumes of equal size. You can adjust the values and the striping to meet your system's requirements.

### ConfigMaps

Kubernetes offers *ConfigMaps*. These objects store non-confidential data. Kubernetes uses them to manage various configuration files like `nifi.properties`. The container that runs the application accesses the configuration information through the mounted volumes and files. ConfigMaps make it easy to manage post-deployment configuration changes.

### ServiceAccount

In secured instances, NiFi uses authentication and authorization. NiFi manages this information in file system files. Specifically, each cluster node needs to maintain an `authorizations.xml` file and a `users.xml` file. All members need to be able to write to these files. And each node in the cluster needs to have an identical copy of this information. Otherwise, the cluster goes out of sync and breaks down.

To meet these conditions, you can copy these files from the first member of the cluster to every member that comes into existence. Each new member then maintains their own copies. Pods generally don't have the authorization that they need to copy content from another pod. But a Kubernetes *ServiceAccount* provides a way for pods to get that authorization.

## Next steps


## Related resources

- [Apache NiFi on Azure][Apache NiFi on Azure]


[Apache NiFi]: https://nifi.apache.org
[Apache NiFi on Azure]: ../../example-scenario/data/azure-nifi.yml
[Helm Incubator]: https://charts.helm.sh/incubator/
[Manage public content with Azure Container Registry]: https://docs.microsoft.com/en-us/azure/container-registry/buffer-gate-public-content
[SVG file of architecture diagram]: ./media/helm-deployments-apache-nifi-architecture.svg