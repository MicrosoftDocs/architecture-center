This article demonstrates how to conceptualize, architect, build, and deploy an application that uses projects from the [Cloud Native Computing Foundation](https://www.cncf.io/projects) (CNCF) after deployment of Azure Kubernetes Service. The architecture describes the [CNCF Projects App](https://github.com/Azure/cloud-native-app) on GitHub. The repo provides for steps for deploying the architecture.

 This is just one type of reference architecture. You can deploy it on any Kubernetes cluster, not just Azure Kubernetes Service. After you review this article, you'll have a good understanding of how to deploy a typical application that's made up mostly of CNCF projects.

## Potential use cases

## Architecture

![Diagram that shows the reference architecture for building a CNCF project.](./media/cncf-architecture.png)

link to visio

The workload is a simple web application that allows employees to submit and view expense reports. When an expense report is submitted, an email is sent to the employee's manager. 

### Application flow

**1.** The employee accesses a web app via NGINX Ingress to submit expenses.

**2.** The web app calls an API app to retrieve the employee's manager.

**3.** The web app pushes a message generated to create the expense report to a Neural Autonomic Transport System (NATS) queue.

**4.** The expense report is saved in MySOL.

**5.** NATS Connector invokes the Email Dispatcher OpenFaaS function with the expense message as the payload.

**6.** Email Dispatcher creates a SendGrid message.

**7.** SendGrid sends an email to the retrieved manager for review.

### DevOps flow

**a.** Developers write/update the code in Visual Studio Code.

**b.** Developers push the code to GitHub from their local workspace in Visual Studio Code.

**c.** Tekton pipelines use the GitHub code.

**d.** Pipelines push and a pull container image from a Harbor registry.

**e.** Tekton deploys the web app, API app, and Email Dispatcher applications.

**f.** Application metrics are captured by Promethius.

**g.** Metrics can be viewed on a Grafana Dashboard.

**h.** DevOps engineers monitor the Grafana Dashboard.

### Infrastructure components

**i.** Azure Kubernetes Service (AKS) cluster that's based on the infrastructure presented in the [AKS baseline](../../reference-architectures/containers/aks/secure-baseline-aks).

**ii.** Rook Ceph that's used for cluster storage.

**iii.** Linkerd service mesh.

**iv.** Jaeger for overall application tracing on the Kubernetes cluster.

### Cluster operations components

It's often beneficial to manage clusters and cluster bootstrapping by using GitOps management. Flux is a popular GitOps operator and is often paired with GitHub Actions to perform validation on updated manifests and Helm charts.

### Open-source software components
- [Kubernetes](https://kubernetes.io) - Container Orchestration Cluster (CNCF)
- [Rook](https://rook.io) - Storage Management (CNCF)
- [Harbor](https://goharbor.io) - Container Registry (CNCF)
- [NATS](https://nats.io) - Pub/Sub Messaging (CNCF)
- [Linkerd](https://linkerd.io) - Service Mesh (CNCF)
- [Prometheus](https://prometheus.io) - Monitoring (CNCF)
- [Jaeger](https://www.jaegertracing.io) - Observability/Tracing (CNCF)
- [OpenFaaS](https://www.openfaas.com) - Functions
- [MySQL](https://www.mysql.com) - Database
- [NGINX](https://www.nginx.com) - Kubernetes Ingress Controller
- [Tekton](https://tekton.dev) CI/CD (CD Foundation)
- [Grafana](https://grafana.com) - Metrics Dashboard
- [SendGrid](https://sendgrid.com) - External Email Service
- [GitHub](https://github.com) - Code Repository and infrastructure deployment pipelines
- [Flux](https://fluxcd.io) – GitOps operator
- Web Front-End & Web API - [.NET Core](/dotnet/core/about)

### Alternatives
This project uses CNCF Graduated and Incubated projects and there could be multiple alternatives for the services used. Please refer **[CNCF](https://www.cncf.io) Projects** for other alternatives. Few of the considerations are below.

* [Service mesh references](https://www.cncf.io/blog/2021/07/15/networking-with-a-service-mesh-use-cases-best-practices-and-comparison-of-top-mesh-options)
* [Function as a Service (Serverless)](https://landscape.cncf.io/serverless)
* [Vitess: sharded MySQL on Kubernetes](https://www.cncf.io/online-programs/vitess-sharded-mysql-on-kubernetes)
* [Tracing your microservices](https://www.cncf.io/blog/2018/03/19/trace-your-microservices-application-with-zipkin-and-opentracing)
* [Gitops with Developer centric Experience](https://www.cncf.io/blog/2020/12/22/argocd-kubevela-gitops-with-developer-centric-experience)

There are first party Azure services (eg. AGIC, ACR, Monitor) and Microsoft supported OSS projects (eg. Open Service Mesh) which can be considered as alternatives. 

## Considerations

* A minimum of 3 node user node pool with VM SKU DS2_v2 or larger is required
* Volumes using Azure Managed Disks cannot be attached across zones and must be co-located in the same zone.
* Rook Installation could take ~20 to ~25 mins. Ensure that the Ceph cluster is completely provisioned before moving on to the next step.
* Jaeger could take ~5 mins to complete setup
* Linkerd takes approximately ~12 mins to show up on dashboard

## Deploy this scenario
Deploy this scenario from the GitHub repo at [Azure/cloud-native-app]. Follow the instructions [here] in sequence to deploy the CNCF Projects App in your environment. Please do note that this repo is a community project accepting and approving PRs for enhancements and modifications from the community

## Pricing
In general, use the [Azure pricing calculator](https://azure.microsoft.com/ pricing/calculator) to estimate costs. Below are some considerations for running this project in
Azure. Additionally, there is almost negligible bandwidth cost.

### VM Scale Sets
* There will be cost associated with VMs used in VMSSs for the AKS cluster. Please refer to [VM Scale Set pricing](https://azure.microsoft.com/ pricing/details/virtual-machine-scale-sets/linux) for more information.

### Storage
* There will be storage costs associated with each data disk required by Rook Installation. For this 3 Node AKS cluster, the Rook configuration used utilizes two data disks per node, 1 GB and 200 GB. Please refer to [Storage Cost Pricing](https://azure.microsoft.com/pricing/details/managed-disks) for more information.

### Load Balancer
* There is cost for the Load Balance associated with this AKS Cluster. Please refer to [Load Balancer Prining](https://azure.microsoft.com/pricing/details/load-balancer/) for more information.

### Virtual Network
* There will be a charge for the Virtual Network used by the AKS cluster. Please refer to [Virtual Network Pricing](https://azure.microsoft.com/ 

## Next steps
## Related resources 
