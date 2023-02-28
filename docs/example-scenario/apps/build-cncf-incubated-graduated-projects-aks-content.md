This article shows how to conceptualize, architect, build, and deploy an application that uses projects from the [Cloud Native Computing Foundation](https://www.cncf.io/projects) (CNCF) after you deploy Azure Kubernetes Service (AKS). The architecture describes the [CNCF Projects App](https://github.com/Azure/cloud-native-app) on GitHub. The setup instructions in the repo provide steps for deploying the architecture.

## Architecture

:::image type="content" source="./media/cncf-architecture.svg" alt-text="Architecture diagram that shows the reference architecture for building a CNCF project." lightbox="./media/cncf-architecture.svg":::

*Download a [Visio](https://arch-center.azureedge.net/cncf-architecture.vsdx) file of this architecture.*

The workload is a simple web application that employees can use to submit and view expense reports. When an employee submits an expense report, the employee's manager receives an email.

### Workflow

#### Application flow

**1.** The employee accesses a web app via NGINX Ingress to submit expenses.

**2.** The web app calls an API app to retrieve the employee's manager.

**3.** The web app pushes a message that's generated for the creation of the expense report to a NATS queue.

**4.** The expense report is saved in MySQL.

**5.** NATS Connector invokes the Email Dispatcher OpenFaaS function with the expense message as the payload.

**6.** Email Dispatcher creates a SendGrid message.

**7.** SendGrid sends an email to the retrieved manager for review.

#### DevOps flow

**a.** Developers write or update the code in Visual Studio Code.

**b.** Developers push the code to GitHub from their local workspace in Visual Studio Code.

**c.** Tekton pipelines pull in the GitHub code.

**d.** Pipelines push and pull a container image from a Harbor registry.

**e.** Tekton deploys the web app, API app, and Email Dispatcher applications.

**f.** Prometheus captures application metrics.

**g.** Engineers monitor metrics on a Grafana Dashboard.

**h.** DevOps engineers monitor the Grafana Dashboard.

#### Infrastructure

**i.** AKS cluster that's based on the infrastructure presented in the [AKS baseline](/azure/architecture/reference-architectures/containers/aks/baseline-aks).

**ii.** Rook Ceph that's used for cluster storage.

**iii.** Linkerd service mesh.

**iv.** Jaeger for overall application tracing on the Kubernetes cluster.

#### Cluster operations

You might find it beneficial to manage clusters and cluster bootstrapping by using GitOps management. [Flux](https://fluxcd.io) is a popular GitOps operator. It's often paired with GitHub Actions to enable validation on updated manifests and Helm charts. 

### Components

#### Azure

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service). Provides the managed cluster infrastructure.
- [Azure App Service](https://azure.microsoft.com/services/app-service). Used to build the web app and API app.

#### Open-source software (OSS)

- [Kubernetes](https://kubernetes.io). CNCF. Automates deployment, scaling, and management of containerized applications.
- [Rook](https://rook.io). CNCF. Provides storage management for the clusters.
- [Harbor](https://goharbor.io). CNCF. Container registry for the images.
- [NATS](https://nats.io). CNCF. Provides publish/subscribe messaging for messages that are generated to create the expense report.
- [Linkerd](https://linkerd.io). CNCF. Service mesh that integrates with OpenFaaS, NGINX, Prometheus, and Jaeger.
- [Prometheus](https://prometheus.io). CNCF. Captures application metrics.
- [Jaeger](https://www.jaegertracing.io). CNCF. Provides overall application tracking on the Kubernetes cluster.
- [OpenFaaS](https://www.openfaas.com). Used to deploy the Email Dispatcher function.
- [MySQL](https://www.mysql.com). Database that stores the expense reports.
- [NGINX](https://www.nginx.com). Kubernetes ingress controller that employees use to access the web app to submit expense reports.
- [Tekton](https://tekton.dev). Continuous Delivery Foundation project that's used for continuous integration / continuous deployment (CI/CD). Deploys the web app, API app, and Email Dispatcher applications.
- [Grafana](https://grafana.com). Dashboard for application metrics.
- [SendGrid](https://sendgrid.com). External email service that sends mail to the manager for expense report review.
- [GitHub](https://github.com). Code repository. Tekton pipelines use GitHub code.
- [.NET Core](/dotnet/core/about). Used for the web front end and the web API.
- [Flux](https://fluxcd.io). Provides GitOps management.

### Alternatives

This project uses CNCF graduated and incubated projects. There could be multiple alternatives for the services used. See the [CNCF](https://www.cncf.io) website for alternatives. Here are some resources that describe some of them:

* [Comparison of service mesh options](https://www.cncf.io/blog/2021/07/15/networking-with-a-service-mesh-use-cases-best-practices-and-comparison-of-top-mesh-options)
* [Function as a service (serverless) alternatives](https://landscape.cncf.io/serverless)
* [Vitess: sharded MySQL on Kubernetes](https://www.cncf.io/online-programs/vitess-sharded-mysql-on-kubernetes)
* [Monitoring your microservices by using Zipkin and OpenTracing](https://www.cncf.io/blog/2018/03/19/trace-your-microservices-application-with-zipkin-and-opentracing)
* [GitOps with a developer-centric experience](https://www.cncf.io/blog/2020/12/22/argocd-kubevela-gitops-with-developer-centric-experience)

You can consider various Azure services as alternatives. For example, Application Gateway Ingress Controller, Azure Container Registry, and Azure Monitor.

Microsoft also supports OSS projects, including Open Service Mesh.

## Scenario details

You can deploy this architecture on any Kubernetes cluster, not just AKS. It provides one example of the flexibility of the AKS platform. AKS makes it simple to deploy a managed Kubernetes cluster in Azure.

After you review this article, you'll have a good understanding of how to deploy a typical application that's made up mostly of CNCF projects.

### Potential use cases

These other uses cases have similar design patterns:

- Creating a CI/CD pipeline for container-based workloads
- Using GitOps for AKS

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

* For the Kubernetes cluster, you need at least a 3-node user-node pool with virtual machine (VM) SKU DS2_v2 or larger.
* Volumes that use Azure managed disks can't be attached across zones. They must be located in the same zone.
* Rook installation can take between 20 and 25 minutes. Be sure the Ceph cluster is completely provisioned before you move on to the next step.
* The Jaeger setup takes about 5 minutes. 
* It takes about 12 minutes for Linkerd to appear in the dashboard.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Following are some pricing considerations for running this project in Azure. A negligible bandwidth cost applies.

#### Virtual Machine Scale Sets

VMs that are used in Azure Virtual Machine Scale Sets for the AKS cluster incur a charge. For more information, see [Virtual Machine Scale Sets pricing](https://azure.microsoft.com/pricing/details/virtual-machine-scale-sets/linux).

#### Storage

Storage costs apply for each data disk that's required by the Rook installation. For this 3-node AKS cluster, the Rook configuration uses two data disks per node: a 1-GB disk and a 200-GB disk. For more information, see [Storage cost pricing](https://azure.microsoft.com/pricing/details/managed-disks).

#### Load balancer

The load balancer that's associated with this AKS cluster incurs a charge. For more information, see [Load Balancer pricing](https://azure.microsoft.com/pricing/details/load-balancer).

#### Virtual network

The virtual network that's used by the AKS cluster incurs a charge. For more information, see [Virtual Network pricing](https://azure.microsoft.com/pricing/details/virtual-network).

## Deploy this scenario

Deploy this scenario from the [Azure/cloud-native-app](https://github.com/Azure/cloud-native-app) GitHub repo. Follow the [setup instructions](https://github.com/Azure/cloud-native-app/blob/main/notes.md) in the provided sequence to deploy the CNCF Projects App in your environment.

This repo is a community project. It accepts and approves pull requests (PRs) for enhancements and modifications from the community.

## Next steps

- [Quickstart: Deploy an AKS cluster by using the Azure portal](/azure/aks/kubernetes-walkthrough-portal)
- [Introduction to AKS](/training/modules/intro-to-azure-kubernetes-service)

## Related resources

- [AKS architecture design](../../reference-architectures/containers/aks-start-here.md)
- [Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [CI/CD pipeline for container-based workloads](../../example-scenario/apps/devops-with-aks.yml) 
- [Basic web application](../../reference-architectures/app-service-web-app/basic-web-app.yml)
