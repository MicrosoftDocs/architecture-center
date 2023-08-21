This article presents a solution that Azure confidential computing (ACC) offers for encrypting in-use data.

## Architecture

:::image type="complex" source="./media/confidential-healthcare-inference.svg" alt-text="Diagram of a confidential healthcare platform demonstration. The platform includes a hospital, medical platform provider, and diagnostic provider." lightbox="./media/confidential-healthcare-inference.svg" border="false":::
Diagram showing how data flows between three parties in a healthcare setting. Three rectangles represent the three parties: a hospital, a medical platform, and a diagnostic provider. Each rectangle contains icons that represent various components, such as a website, a client application, Azure Attestation, a web API, data storage, and a runtime. The medical platform and diagnostic provider rectangles also contain smaller rectangles that represent confidential nodes and A K S clusters. Arrows connect these components and show the flow of data. Numbered callouts correspond to the steps that this article describes after the diagram.
:::image-end:::

*Download a [Visio file][Confidential Healthcare Inference vsdx] of this architecture.*

The diagram outlines the architecture. Throughout the system:

- Network communication is TLS encrypted in transit.
- [Azure Monitor](/azure/azure-monitor) tracks component performance, and [Azure Container Registry](/azure/container-registry) (ACR) manages the solution's containers.

### Workflow

The solution involves the following steps:

1. A clerk for a local hospital opens a web portal. The entire web app is an [Azure Blob Storage](/azure/storage/blobs) static website.
1. The clerk enters data into the hospital's web portal, which connects to a Python Flask–based web API built by a popular medical platform vendor. A confidential node in the [SCONE](https://sconedocs.github.io/#scone-executive-summary) confidential computing software protects the patient data. SCONE works within an AKS cluster that has the Software Guard Extensions (SGX) enabled that help run the container in an enclave. The Web API will provide evidence that the sensitive data and app code is encrypted and isolated in a Trusted Execution Environment. This means that no humans, no processes, and no logs have access to the cleartext data or the application code.
1. The hospital's web app client requests that an attestation service (Azure Attestation) validates this evidence, and receives a signed *attestation token* for other apps to verify.
1. If the Web API requires additional components (like a Redis cache), it can pass along the attestation token to verify that the data and app code have so far remained in a safe enclave (see step 6 for verification).
1. The Web API can even consume remote services, such as an ML model hosted by a third-party diagnostics provider. When doing so, it continues to pass along any attestation tokens for evidence that required enclaves are safe. The Web API could also attempt to receive and verify attestation tokens for the diagnostic provider's infrastructure.
1. The remote infrastructure accepts the attestation token from the medical platform's web api and verifies it with a public certificate found in the Azure Attestation service. If the token is verified, there is near certainty that the enclave is safe and neither the data or app code have been opened outside of the enclave.
1. The diagnostics provider, confident that the data has not been exposed, sends it into its own enclave in an Open Neural Network Exchange (ONNX) runtime server. An AI model interprets the medical imagery and returns its diagnosis results back to the medical platform's confidential Web API app. From here, the software can then interact with patient records and/or contact other hospital staff.

### Components

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) serves static content like HTML, CSS, JavaScript, and image files directly from a storage container.

- [Azure Attestation](/azure/attestation/) is a unified solution that remotely verifies the trustworthiness of a platform. Azure Attestation also remotely verifies the integrity of the binaries that run in the platform. Use Azure Attestation to establish trust with the confidential application.

- [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service) simplifies the process of deploying a Kubernetes cluster.

- [Confidential computing nodes](/azure/confidential-computing/confidential-nodes-aks-overview) are hosted on a specific virtual machine series that can run sensitive workloads on AKS within a hardware-based trusted execution environment (TEE) by allowing user-level code to allocate private regions of memory, known as enclaves. Confidential computing nodes can support confidential containers or enclave-aware containers.

- [SCONE platform](https://azuremarketplace.microsoft.com/marketplace/apps/scontainug1595751515785.scone?tab=Overview) is an Azure Partner independent software vendor (ISV) solution from Scontain.

- [Redis](https://redis.io) is an open-source, in-memory data structure store.

- [Secure Container Environment (SCONE)](https://sconedocs.github.io/) supports the execution of confidential applications in containers that run inside a Kubernetes cluster.

- [Confidential Inferencing ONNX Runtime Server Enclave (ONNX RT - Enclave)](https://github.com/microsoft/onnx-server-openenclave) is a host that restricts the ML hosting party from accessing both the inferencing request and its corresponding response.

### Alternatives

- You can use [Fortanix](https://www.fortanix.com) instead of SCONE to deploy confidential containers to use with your containerized application. Fortanix provides the flexibility you need to run and manage the broadest set of applications: existing applications, new enclave-native applications, and pre-packaged applications.

- [Graphene](https://gramine.readthedocs.io/en/stable/) is a lightweight, open-source guest OS. Graphene can run a single Linux application in an isolated environment with benefits comparable to running a complete OS. It has good tooling support for converting existing Docker container applications to Graphene Shielded Containers (GSC).

## Scenario details

When organizations collaborate, they share information. But most parties don't want to give other parties access to all parts of the data. Mechanisms exist for safeguarding data at rest and in transit. However, encrypting data in use poses different challenges. 

By using confidential computing and containers, the solution provides a way for a provider-hosted application to securely collaborate with a hospital and a third-party diagnostic provider. Azure Kubernetes Service (AKS) hosts confidential computing nodes. Azure Attestation establishes trust with the diagnostic provider. By using these Azure components, the architecture isolates the sensitive data of the hospital patients while the specific shared data is being processed in the cloud. The hospital data is then inaccessible to the diagnostic provider. Through this architecture, the provider-hosted application can also take advantage of advanced analytics. The diagnostic provider makes these analytics available as confidential computing services of machine learning (ML) applications.

### Potential use cases

Many industries protect their data by using confidential computing for these purposes:

- Securing financial data
- Protecting patient information
- Running ML processes on sensitive information
- Performing algorithms on encrypted datasets from many sources
- Protecting container data and code integrity

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Azure confidential computing virtual machines (VMs) are available in 2nd-generation D family sizes for general purpose needs. These sizes are known collectively as D-Series v2 or DCsv2 series. This scenario uses Intel SGX-enabled DCs_v2-series virtual machines with Gen2 operating system (OS) images. But you can only deploy certain sizes in certain regions. For more information, see [Quickstart: Deploy an Azure Confidential Computing VM in the Marketplace](/azure/confidential-computing/quick-create-marketplace) and [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator), which preconfigures all Azure services.

A [sample cost profile](https://azure.com/e/5e776a5dbebf4f20974ebbfa0e247747) is available for the Contoso Medical SaaS Platform, as pictured in the diagram. It includes the following components:

- System node pool and SGX node pool: no disks, all ephemeral
- AKS Load Balancer
- Azure Virtual Network: nominal
- Azure Container Registry
- Storage account for single-page application (SPA)

The profile doesn't include the following components:

- Azure Attestation Service: free
- Azure Monitor Logs: usage based
- SCONE ISV licensing
- Compliance services required for solutions working with sensitive data, including:

  - Microsoft Defender for Cloud and Microsoft Defender for Kubernetes
  - Azure DDoS Protection: Network Protection
  - Azure Firewall
  - Azure Application Gateway and Azure Web Application Firewall
  - Azure Key Vault

## Deploy this scenario

Deploying this scenario involves the following high-level steps:

- Deploy the confidential inferencing server on an existing SGX-enabled AKS Cluster. See the [confidential ONNX inference server](https://github.com/microsoft/onnx-server-openenclave) project on GitHub for information on this step.

- Configure Azure Attestation policies.

- Deploy an SGX-enabled AKS cluster node pool.

- Get access to [curated confidential applications called SconeApps](https://sconedocs.github.io/helm). SconeApps are available on a private GitHub repository that's currently only available for commercial customers, through SCONE Standard Edition. Go to the [SCONE website](https://scontain.com) and contact the company directly to get this service level.

- Install and run SCONE services on your AKS cluster.

- Install and test the Flask-based application on your AKS cluster.

- Deploy and access the web client.

These steps focus on the enclave containers. A secured infrastructure would extend beyond this implementation and include compliance requirements, such as added protections required by HIPAA.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Amar Gowda](https://www.linkedin.com/in/nramar) | Principal Product Manager

## Next steps

- Learn more about [Azure confidential computing](/azure/confidential-computing)
- [Static website hosting in Blob Storage](/azure/storage/blobs/storage-blob-static-website)
- See the [confidential ONNX inference server](https://github.com/microsoft/onnx-server-openenclave) project on GitHub.
- [Official ONNX runtime website](https://www.onnxruntime.ai/)
- [Confidential ONNX inference server (GitHub sample)](https://github.com/microsoft/onnx-server-openenclave)

- [Confidential containers on AKS](/azure/confidential-computing/confidential-containers)
- [MobileCoin use case with anonymized blockchain data](https://customers.microsoft.com/story/844245-mobilecoin-banking-and-capital-markets-azure)
- [Sample brain segmentation image](https://github.com/mateuszbuda/brain-segmentation-pytorch/blob/master/assets/TCGA_CS_4944.png) for use with the delineation function that invokes the confidential inferencing server.

## Related resources

- [Health data consortium on Azure](../data/azure-health-data-consortium.yml)
- [HIPAA and HITRUST compliant health data AI](../../solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai.yml)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)

[Confidential Healthcare Inference vsdx]: https://arch-center.azureedge.net/healthcare-inference.vsdx
