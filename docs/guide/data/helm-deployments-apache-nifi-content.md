This solution shows you how to use Helm charts when you deploy NiFi on Azure Kubernetes Service (AKS). Helm streamlines the process of installing and managing Kubernetes applications.

*Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="./media/helm-deployments-apache-nifi-architecture.svg" alt-text="Diagram showing how a user configures a Helm chart to deploy an application on Kubernetes. Components include pods and volumes that Kubernetes creates." border="false" lightbox="./media/helm-deployments-apache-nifi-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/helm-deployments-apache-nifi.vsdx) of this architecture.*

### Workflow

- A Helm chart contains a `values.yaml` file. That file lists input values that users can edit.

- A user adjusts settings in a chart, including values for:

  - Volume sizes.
  - The number of pods.
  - User authentication and authorization mechanisms.

- The user runs the Helm `install` command to deploy the chart.

- Helm checks whether the user input contains values for all required variables.

- Helm creates a manifest that describes the objects to deploy on Kubernetes.

- Helm sends the manifest to the Kubernetes cluster. Apache ZooKeeper provides cluster coordination.

- Kubernetes creates the specified objects. A NiFi deployment requires these objects:

  - Configuration objects.
  - Data volumes. Pod storage is temporary.
  - A log volume.
  - Pods that use an image to run NiFi in a container. Kubernetes uses a *StatefulSet* workload resource to manage the pods.
  - A Kubernetes service that makes the NiFi UI available to users.
  - Ingress routes if the cluster uses ingress to make the UI available externally.

### Components

A Helm chart is a collection of files in a folder with a tree structure. These files describe Kubernetes resources. You can configure the following components in a Helm chart:

#### ZooKeeper

ZooKeeper uses a separate chart. You can use the standard ZooKeeper chart that Kubernetes supplies in its [incubator chart repository][Helm Incubator]. But when your dependencies include public registry content, you introduce risk into your image development and deployment workflows. To mitigate this risk, keep local copies of public content when you can. For detailed information, see [Manage public content with Azure Container Registry][Manage public content with Azure Container Registry].

As an alternative, you can deploy ZooKeeper on your own. If you choose this option, provide the ZooKeeper server and port number so that the pods that run NiFi can access the ZooKeeper service.

#### Kubernetes StatefulSet

To run an application on Kubernetes, you run a pod. This basic unit runs different containers that implement the application's different activities.

Kubernetes offers two solutions for managing pods that run an application like NiFi:

- A *ReplicaSet*, which maintains a stable set of the replica pods that run at any given time. You often use a ReplicaSet to guarantee the availability of a specified number of identical pods.
- A *StatefulSet*, which is the workload API object that you use to manage stateful applications. A StatefulSet manages pods that are based on an identical container specification. Kubernetes creates these pods from the same specification. But these pods aren't interchangeable. Each pod has a persistent identifier that it maintains across rescheduling.

Since you use NiFi to manage data, a StatefulSet provides the best solution for NiFi deployments.

#### ConfigMaps

Kubernetes offers *ConfigMaps* for storing non-confidential data. Kubernetes uses these objects to manage various configuration files like `nifi.properties`. The container that runs the application accesses the configuration information through mounted volumes and files. ConfigMaps make it easy to manage post-deployment configuration changes.

#### ServiceAccount

In secured instances, NiFi uses authentication and authorization. NiFi manages this information in file system files. Specifically, each cluster node needs to maintain an `authorizations.xml` file and a `users.xml` file. All members need to be able to write to these files. And each node in the cluster needs to have an identical copy of this information. Otherwise, the cluster goes out of sync and breaks down.

To meet these conditions, you can copy these files from the first member of the cluster to every member that comes into existence. Each new member then maintains its own copies. Pods generally don't have authorization to copy content from another pod. But a Kubernetes *ServiceAccount* provides a way to get authorization.

#### Services

Kubernetes services make the application service available to users of the Kubernetes cluster. Service objects also make it possible for member nodes of NiFi clusters to communicate with each other. For Helm chart deployments, use two service types: headless services and IP-based services.

#### Ingress

An ingress manages external access to cluster services. Specifically, a pre-configured ingress controller exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. You can define ingress rules that determine how the controller routes the traffic. The Helm chart includes the ingress route in the configuration.

#### Secrets

To configure secured NiFi clusters, you need to store credentials. Kubernetes secrets provide a secure way to store and retrieve these credentials.

## Scenario details

[Apache NiFi][Apache NiFi] users often need to deploy NiFi on Kubernetes. A Kubernetes deployment involves many objects, such as pods, volumes, and services. It's difficult to manage the *manifests*, or specification files, that Kubernetes uses for this number of objects. The difficulty increases when you deploy several NiFi clusters that use different configurations.

Helm *charts* provide a solution for managing the manifests. Helm is the package manager for Kubernetes. By using the Helm tool, you can streamline the process of installing and managing Kubernetes applications.

A chart is the packaging format that Helm uses. You enter configuration requirements into chart files. Helm keeps track of each chart's history and versions. Helm then uses charts to generate Kubernetes manifest files.

From a single chart, you can deploy applications that use different configurations. When you run [NiFi on Azure][Apache NiFi on Azure], you can use Helm charts to deploy different NiFi configurations on Kubernetes.

Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Data disks

For disk usage, consider using a striped set of disks for repositories. In test deployments that used Virtual Machine Scale Sets, this approach worked best. The following excerpt from `nifi.properties` shows a disk usage configuration:

```config
nifi.flowfile.repository.directory=/data/partition1/flowfiles
nifi.provenance.repository.directory.stripe1=/data/partition1/provenancenifi.provenance.repository.directory.stripe2=/data/partition2/provenancenifi.provenance.repository.directory.stripe3=/data/partition3/provenancenifi.content.repository.directory.stripe2=/data/partition2/content
nifi.content.repository.directory.stripe3=/data/partition3/content
```

This configuration uses three volumes of equal size. You can adjust the values and the striping to meet your system requirements.

### Deployment scenarios

You can use a public or private load balancer or an ingress controller to expose a NiFi cluster. When you use Helm charts for this implementation, two configurations are available:

- An unsecured NiFi cluster that's accessible through an HTTP URL without user authentication or authorization.
- A secured NiFi cluster that's accessible through an HTTPS URL. This kind of cluster is secured with TLS. When you configure secured clusters, you can provide your own certificates. Alternatively, the charts can generate the certificates. For this purpose, the charts use a NiFi toolkit that provides a self-signed Certificate Authority (CA).

If you configure a NiFi cluster to run as a secured cluster with TLS communication, you need to turn on user authentication. Use one of the following supported user authentication methods:

- Certificate-based user authentication. Users are authenticated by the certificate that they present to the NiFi UI. To use this kind of user authentication system, add the CA's public certificate to the NiFi deployment.
- LDAP-based user authentication. An LDAP server authenticates user credentials. When you deploy the chart, provide information about the LDAP server and the information tree.
- OpenID-based user authentication. Users provide information to the OpenID server to configure the deployment.

### Resource configuration and usage

To optimize resource usage, use these Helm options to configure CPU and memory values:

- The `request` option, which specifies the initial amount of the resource that the container requests
- The `limit` option, which specifies the maximum amount of the resource that the container can use

When you configure NiFi, consider your system's memory configuration. Because NiFi is a Java application, you should adjust settings like the minimum and maximum java virtual machine (JVM) memory values. Use the following settings:

- `jvmMinMemory`
- `jvmMaxMemory`
- `g1ReservePercent`
- `conGcThreads`
- `parallelGcThreads`
- `initiatingHeapOccupancyPercent`

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Use a Kubernetes security context to improve the security of the underlying containers that run the NiFi binary. A security context manages access to those containers and their pods. Through a security context, you can grant non-root users permissions to run the containers.

Other uses of security contexts include:

- Restricting the access of OS-based users that run the containers.
- Specifying which groups can access the containers.
- Limiting access to the file system.

### Container images

Kubernetes containers are the basic units that run NiFi binaries. To configure a NiFi cluster, focus on the image that you use to run these containers. You have two options for this image:

- Use the standard NiFi image to run the NiFi chart. The Apache NiFi community supplies that image. But you need to add a `kubectl` binary to the containers to configure secured clusters.
- Use a custom image. If you take this approach, consider your file system requirements. Ensure that the location of your NiFi binaries is correct. For more information on the configured file system, see [Dockerfile in the Apache NiFi source code][Apache NiFi Dockerfile on GitHub].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Muazma Zahid](https://www.linkedin.com/in/muazmazahid/) | Principal PM Manager
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Helm][Helm]
- [Helm charts][Helm charts]
- [Kubernetes][Kubernetes]
- [Kubernetes StatefulSets][Kubernetes StatefulSets]
- [Kubernetes Volumes][Kubernetes Volumes]
- [Kubernetes ConfigMaps][Kubernetes ConfigMaps]
- [Kubernetes Secrets][Kubernetes Secrets]
- [Kubernetes Service][Kubernetes Service]
- [Kubernetes Ingress][Kubernetes Ingress]
- [Azure Kubernetes Service][Azure Kubernetes Service]
- [Apache NiFi Docker Image][Apache NiFi Docker Image]

## Related resources

- [Apache NiFi on Azure][Apache NiFi on Azure]
- [Apache NiFi monitoring with MonitoFi][Apache NiFi monitoring with MonitoFi]
- [Microservices architecture on Azure Kubernetes Service (AKS)][Microservices architecture on Azure Kubernetes Service (AKS)]
- [Advanced Azure Kubernetes Service (AKS) microservices architecture][Advanced Azure Kubernetes Service (AKS) microservices architecture]

[Advanced Azure Kubernetes Service (AKS) microservices architecture]: ../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml
[Apache NiFi]: https://nifi.apache.org
[Apache NiFi on Azure]: ../../example-scenario/data/azure-nifi.yml
[Apache NiFi Docker Image]: https://hub.docker.com/r/apache/nifi
[Apache NiFi Dockerfile on GitHub]: https://github.com/apache/nifi/blob/main/nifi-docker/dockerhub/Dockerfile
[Apache NiFi monitoring with MonitoFi]: ./monitor-apache-nifi-monitofi.yml
[Azure Kubernetes Service]: https://azure.microsoft.com/services/kubernetes-service
[Helm]: https://helm.sh/docs
[Helm charts]: https://helm.sh/docs/chart_template_guide/getting_started
[Helm Incubator]: https://charts.helm.sh/incubator
[Kubernetes]: https://kubernetes.io/docs/home
[Kubernetes ConfigMaps]: https://kubernetes.io/docs/concepts/configuration/configmap
[Kubernetes Ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress
[Kubernetes Secrets]: https://kubernetes.io/docs/concepts/configuration/secret
[Kubernetes Service]: https://kubernetes.io/docs/concepts/services-networking/service
[Kubernetes StatefulSets]: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset
[Kubernetes Volumes]: https://kubernetes.io/docs/concepts/storage/volumes
[Manage public content with Azure Container Registry]: /azure/container-registry/buffer-gate-public-content
[Microservices architecture on Azure Kubernetes Service (AKS)]: ../../reference-architectures/containers/aks-microservices/aks-microservices.yml
