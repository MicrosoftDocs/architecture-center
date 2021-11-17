This article shows how to conceptualize, architect, build, and deploy an application that uses projects from the [Cloud Native Computing Foundation](https://www.cncf.io/projects) (CNCF) after deployment of Azure Kubernetes Service. The architecture describes the [CNCF Projects App](https://github.com/Azure/cloud-native-app) on GitHub. The repo provides for steps for deploying the architecture.

 This is just one type of reference architecture. You can deploy it on any Kubernetes cluster, not just Azure Kubernetes Service (AKS). This architecture provides one example of the flexibility of the AKS platform. AKS makes it simple to deploy a managed Kubernetes cluster in Azure.
 
After you review this article, you'll have a good understanding of how to deploy a typical application that's made up mostly of CNCF projects.

## Potential use cases
These other uses cases have similar design patterns:
- Creating a CI/CD pipeline for container-based workloads
- Using GitOps for Azure Kubernetes Service

## Architecture

![Diagram that shows the reference architecture for building a CNCF project.](./media/cncf-architecture.png)

Download a [Visio](https://arch-center.azureedge.net/cncf-architecture.vsdx) file of this architecture.

The workload is a simple web application that allows employees to submit and view expense reports. When an expense report is submitted, an email is sent to the employee's manager. 

### Application flow

**1.** The employee accesses a web app via NGINX Ingress to submit expenses.

**2.** The web app calls an API app to retrieve the employee's manager.

**3.** The web app pushes a message generated to create the expense report to a NATS queue.

**4.** The expense report is saved in MySQL.

**5.** NATS Connector invokes the Email Dispatcher OpenFaaS function with the expense message as the payload.

**6.** Email Dispatcher creates a SendGrid message.

**7.** SendGrid sends an email to the retrieved manager for review.

### DevOps flow

**a.** Developers write/update the code in Visual Studio Code.

**b.** Developers push the code to GitHub from their local workspace in Visual Studio Code.

**c.** Tekton pipelines use the GitHub code.

**d.** Pipelines push and a pull container image from a Harbor registry.

**e.** Tekton deploys the web app, API app, and Email Dispatcher applications.

**f.** Prometheus captures application metrics.

**g.** Metrics can be viewed on a Grafana Dashboard.

**h.** DevOps engineers monitor the Grafana Dashboard.

### Infrastructure components

**i.** Azure Kubernetes Service (AKS) cluster that's based on the infrastructure presented in the [AKS baseline](../../reference-architectures/containers/aks/secure-baseline-aks.yml).

**ii.** Rook Ceph that's used for cluster storage.

**iii.** Linkerd service mesh.

**iv.** Jaeger for overall application tracing on the Kubernetes cluster.

### Cluster operations components

It's often beneficial to manage clusters and cluster bootstrapping by using GitOps management. [Flux](https://fluxcd.io) is a popular GitOps operator. It's often paired with GitHub Actions to enable validation on updated manifests and Helm charts.

### Open-source software (OSS) components

#### CNCF components
- [Kubernetes](https://kubernetes.io). Used to automate deployment, scaling, and management of containerized applications.
- [Rook](https://rook.io). Provides storage management for the clusters. 
- [Harbor](https://goharbor.io). Container registry for the images.
- [NATS](https://nats.io). Provides publish/subscribe messaging for messages generated to create the expense report. 
- [Linkerd](https://linkerd.io). Service mesh that integrates with OpenFaaS, NGINX, Prometheus, and Jaeger. 
- [Prometheus](https://prometheus.io). Captures application metrics.
- [Jaeger](https://www.jaegertracing.io). Provides overall application tracking on the Kubernetes cluster. 

#### Other components 
- [OpenFaaS](https://www.openfaas.com). Used to deploy the Email Dispatcher function.
- [MySQL](https://www.mysql.com). Database that stores the expense reports. 
- [NGINX](https://www.nginx.com). Kubernetes ingress controller that employees use to access the web app to submit expense reports. 
- [Tekton](https://tekton.dev). Continuous Delivery Foundation project used for continuous integration / continuous deployment (CI/CD). Deploys the web app, API app, and Email Dispatcher applications.
- [Grafana](https://grafana.com). Dashboard for application metrics. 
- [SendGrid](https://sendgrid.com). External email service that sends mail to the manager for expense report review. 
- [GitHub](https://github.com). Code repository. Tekton pipelines use GitHub code.
- [.NET Core](/dotnet/core/about). Used for the web front end and the web API.

### Alternatives
This project uses CNCF graduated and incubated projects. There could be multiple alternatives for the services used. See the [CNCF](https://www.cncf.io) website for alternatives. Here are some resources that describe some of them:

* [Comparison of service mesh options](https://www.cncf.io/blog/2021/07/15/networking-with-a-service-mesh-use-cases-best-practices-and-comparison-of-top-mesh-options)
* [Function as a service (serverless) alternatives](https://landscape.cncf.io/serverless)
* [Vitess: sharded MySQL on Kubernetes](https://www.cncf.io/online-programs/vitess-sharded-mysql-on-kubernetes)
* [Monitoring your microservices by using Zipkin and OpenTracing](https://www.cncf.io/blog/2018/03/19/trace-your-microservices-application-with-zipkin-and-opentracing)
* [GitOps with a developer-centric experience](https://www.cncf.io/blog/2020/12/22/argocd-kubevela-gitops-with-developer-centric-experience)

You can consider various Microsoft Azure services as alternatives. For example, Application Gateway Ingress Controller (AGIC), Azure Container Registry, and Azure Monitor.

Microsoft also supports OSS projects, including Open Service Mesh.

## Considerations

* For the Kubernetes cluster, you need at least a 3-node user-node pool with virtual machine (VM) SKU DS2_v2 or larger.
* Volumes that use Azure managed disks can't be attached across zones. They must be located in the same zone.
* Rook installation could take between 20 and 25 minutes. Be sure that the Ceph cluster is completely provisioned before you move on to the next step.
* The Jaeger setup could take about minutes. 
* It takes about 12 minutes for Linkerd to appear in the dashboard.

## Deploy this scenario
Deploy this scenario from the [Azure/cloud-native-app](https://github.com/Azure/cloud-native-app) GitHub repo. Follow the [setup instructions](https://github.com/Azure/cloud-native-app/blob/main/notes.md) in the provided sequence to deploy the CNCF Projects App in your environment. 

This repo is a community project. It accepts and approves pull requests (PRs) for enhancements and modifications from the community.

## Pricing
You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Following are some pricing considerations for running this project in
Azure. There is a negligible bandwidth cost.

### Virtual Machine Scale Sets
* A cost is associated with VMs used in Azure Virtual Machine Scale Sets for the AKS cluster. For more information, see [Virtual Machine Scale Sets pricing](https://azure.microsoft.com/pricing/details/virtual-machine-scale-sets/linux).

### Storage
* Storage costs are associated with each data disk required by the Rook installation. For this 3-node AKS cluster, the Rook configuration uses two data disks per node, 1 GB and 200 GB. For more information, see [Storage cost pricing](https://azure.microsoft.com/pricing/details/managed-disks).

### Load balancer
* A cost is incurred for the load balancer associated with this AKS cluster. For more information, see [Load Balancer pricing](https://azure.microsoft.com/pricing/details/load-balancer/).

### Virtual network
* A charge is incurred for the virtual network used by the AKS cluster. For more information, see [Virtual Network pricing](https://azure.microsoft.com/pricing/details/virtual-network). 

## Next steps

[Azure Kubernetes Service architecture design](../../reference-architectures/containers/aks-start-here.md)

[Baseline architecture for an Azure Kubernetes Service cluster](../../reference-architectures/containers/aks/secure-baseline-aks.yml)

[CI/CD pipeline for container-based workloads](../../example-scenario/apps/devops-with-aks.yml) 

[Basic web application](../../reference-architectures/app-service-web-app/basic-web-app.yml)


## Related resources 

[Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster by using the Azure portal](/azure/aks/kubernetes-walkthrough-portal)

[Introduction to Azure Kubernetes Service](/learn/modules/intro-to-azure-kubernetes-service/)
