This solution uses confidential computing on Kubernetes to run big data analytics with Apache Spark inside confidential containers with data from Azure Data Lake and Azure SQL Database. Confidential computing is provided by Intel Software Guard Extensions and AMD EPYC<sup>TM</sup> processors with Secure Encrypted Virtualization-Secure Nested Paging. For more information on provisioning an AKS cluster with AMD SEV-SNP confidential VMs, see [Confidential VM node pool support on AKS with AMD SEV-SNP confidential VMs](/azure/confidential-computing/confidential-node-pool-aks). For more information about deploying an AKS cluster with confidential computing Intel SGX agent nodes, see [Deploy an AKS cluster with confidential computing Intel SGX agent nodes by using the Azure CLI](/azure/confidential-computing/confidential-enclave-nodes-aks-get-started).

_Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks._

## Architecture

:::image type="complex" source="./media/data-analytics-containers-confidential-data-processing.svg" alt-text="Diagram of confidential big data analytics with Apache Spark, Azure SQL Always Encrypted, AKS, and Secure Container Environment." lightbox="./media/data-analytics-containers-confidential-data-processing.svg":::
Diagram that shows how sensitive data flows securely from ingestion phase to analytics within the bounds of a confidential computing environment. The problems that this architecture aims to solve are: ingestion and storage of sensitive data in the Azure cloud, gathering business insights by processing and storing the data at scale, and ensuring confidentiality through hardware-enforced means.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/confidential-data-analytics-containers-spark-kubernetes-azure-sql.pptx) of this architecture.*

The preceding diagram outlines the architecture: a scalable pattern for processing larger datasets in a distributed fashion. It also showcases confidential analytics on relational database engines and storing confidential data. In particular, the containerized Spark app can process datasets from two data sources, as illustrated:

1. [Azure Data Lake Storage - Parquet/Delta Lake files](/azure/storage/blobs/data-lake-storage-introduction): As shown in the [sample demonstration](#deploy-this-scenario), a four-pod Spark deployment—one Driver, three Executors on the [Secure Container Environment (SCONE) runtime](https://sconedocs.github.io/sconeapps_spark)—is capable of processing 1.5 billion rows of Parquet/Delta Lake files that are stored on Azure Data Lake storage within two minutes, or approximately 131 seconds.

2. [Azure SQL DB - Always Encrypted with secure enclaves](/sql/relational-databases/security/encryption/always-encrypted-enclaves?view=sql-server-ver15): This example uses Spark to access Always Encrypted data as plaintext by using the [Azure SQL JDBC driver](/sql/connect/jdbc/using-always-encrypted-with-the-jdbc-driver?view=sql-server-ver15) inside the Spark container enclave to run analytics and machine learning pipelines.

You can easily extend this pattern to include any data sources that Spark's large ecosystem supports.

### Workflow

1. Operator persona: A DevOps engineer provisions Kubernetes clusters, [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces), [Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account), and Confidential virtual machine (VM) node pools (for example, [DC4s_v3](/azure/virtual-machines/dcv3-series)).

2. Developer persona: A data engineer uses [PySpark](https://spark.apache.org/docs/latest/api/python/index.html) to write an analytics application that's designed to analyze large volumes of data.

3. Data custodian persona: The data or security engineer creates a security policy for the PySpark application from a shared repository in the organization (a one-time activity). This policy specifies the expected state of the data and app code, the minimum security requirements for the platform, and any environment variables, command-line arguments, or secrets (such as the JDBC string, input blob URI, and a SAS token for access). You can also make this configuration available to the Spark runtime by using Kubernetes [Secrets](https://kubernetes.io/docs/concepts/configuration/secret) or by using Azure Key Vault. (For more information, see [Use the Azure Key Vault Provider for Secrets Store CSI Driver in an AKS cluster](/azure/aks/csi-secrets-store-driver)). The configuration is injected into the enclave only if the evidence that it provides is validated by an attestation provider. The [attestation provider](https://sgx101.gitbook.io/sgx101/sgx-bootstrap/attestation) (for example, [Azure Attestation Service](/azure/attestation/overview)), is also defined in the security policy.

4. With the help of the SCONE confidential computing software, the data engineer builds a confidential Docker image that contains the encrypted analytics code and a secure version of PySpark. SCONE works within an AKS cluster that has Intel SGX enabled (see [Create an AKS cluster with a system node pool](/azure/confidential-computing/confidential-enclave-nodes-aks-get-started#create-an-aks-cluster-with-a-system-node-pool)), which allows the container to run inside an enclave. PySpark provides evidence that the sensitive data and app code is encrypted and isolated in a Trusted Execution Environment (TEE)—which means that no humans, no processes, and no logs have access to the plaintext data or the application code.

5. The PySpark application is deployed to the remote AKS cluster. It starts and sends its attestation evidence to the attestation provider. If the evidence is valid, an _attestation token_ is returned. The remote infrastructure accepts the attestation token and verifies it with a public certificate that's found in the Azure Attestation service. If the token is verified, there's near certainty that the enclave is safe and that neither the data nor the app code have been opened outside the enclave. The configuration in the security policy (environment variables, command-line arguments, and secrets) is then injected into PySpark enclaves.

6. You can horizontally scale the PySpark execution across several Kubernetes nodes. All PySpark instances communicate over an encrypted channel, and all the files are encrypted that need to be written to their local file systems (for example, shuffle files).

7. The results of the analysis are encrypted and uploaded to an [Azure SQL Database with Always Encrypted](/azure/azure-sql/database/always-encrypted-azure-key-vault-configure?tabs=azure-powershell) (that uses column-level encryption). Access to the output data and encryption keys can be securely granted to other confidential applications (for example, in a pipeline) by using the same sort of security policies and hardware-based attestation evidence that's described in this article.

### Components

- [Azure Attestation](/azure/attestation) is a unified solution that remotely verifies the trustworthiness of a platform. Azure Attestation also remotely verifies the integrity of the binaries that run in the platform. Use Azure Attestation to establish trust with the confidential application.

- [Azure confidential computing](https://azure.microsoft.com/solutions/confidential-compute) nodes are hosted on a specific VM series that can run sensitive workloads on AKS within a hardware-based TEE. In this environment, user-level code can allocate private regions of memory, known as [enclaves](https://sgx101.gitbook.io/sgx101/sgx-bootstrap/enclave). Confidential computing nodes can support confidential containers or enclave-aware containers.

- [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service) simplifies the process of deploying and managing a Kubernetes cluster.

- [Apache Spark](https://spark.apache.org) is an open-source, multi-language engine for executing data engineering, data science, and machine learning on both single-node machines and multi-node clusters, such as Kubernetes pods.

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database/campaign) now offers [Always Encrypted with secure enclaves](/azure/azure-sql/database/always-encrypted-with-secure-enclaves-landing), expanding the confidential computing capabilities of [SQL Server's Always Encrypted technology](/sql/relational-databases/security/encryption/always-encrypted-database-engine?view=sql-server-ver15) to include in-place encryption and rich confidential queries.

- [SCONE](https://sconedocs.github.io) supports the execution of confidential applications in containers that run inside a Kubernetes cluster.

- [SCONE platform](https://azuremarketplace.microsoft.com/marketplace/apps/scontainug1595751515785.scone?tab=Overview) is a solution from Scontain, an independent software vendor and Azure partner.

### Alternatives

[Occlum](https://occlum.io) is a memory-safe, multi-process library OS (LibOS) for Intel SGX. Occlum makes it possible for legacy applications to run on Intel SGX with little to no modifications to source code. Occlum transparently protects the confidentiality of user workloads while allowing easy migration to existing Docker applications. Occlum supports Java apps.

The SCONE engineering team maintains an [Apache Spark](https://sconedocs.github.io/sconeapps_spark) container image that runs the latest version of Spark. An alternative that isn't specific to Apache Spark is [Fortanix](https://www.fortanix.com), with which you can deploy confidential containers to use with your containerized application. Fortanix provides the flexibility required to run and manage the broadest set of applications: existing applications, new enclave-native applications, and pre-packaged applications.

## Scenario details

There's exponential growth of datasets, which has resulted in growing scrutiny of how data is exposed from the perspectives of both consumer data privacy and compliance. In this context, confidential computing becomes an important tool to help organizations meet their privacy and security needs for business and consumer data. Organizations can gain new insights from regulated data if the data is processed in a compliant manner. Confidential computing is especially helpful in scenarios where the scale that's provided by cloud computing is needed to process the data confidentially.

Confidential computing technology encrypts data in memory and only processes it after the cloud environment is verified, or _attested_. Confidential computing prevents data access by cloud operators, malicious admins, and privileged software, such as the hypervisor. It also helps to keep data protected throughout its lifecycle—while the data is at rest, in transit, and also now while it's in use.

[Confidential containers](/azure/confidential-computing/confidential-nodes-aks-overview) on Azure Kubernetes Service (AKS) provide the necessary infrastructure for customers to use popular applications, such as [Apache Spark](https://spark.apache.org), to perform data cleansing and machine learning training. This article presents a solution that Azure confidential computing offers for running an Apache Spark application on an AKS cluster by using node pools with Intel Software Guard Extensions (Intel SGX). The data from that processing is safely stored in Azure SQL Database by using [Always Encrypted with secure enclaves](/sql/relational-databases/security/encryption/always-encrypted-enclaves?view=sql-server-ver15).

> [!NOTE]
> Confidential data analytics in this context is meant to imply _run analytics on sensitive data with peace of mind against data exfiltration_. This includes a potential container access breach at the root level, both internally (for example, by a rogue admin) or externally (by system compromise).
> 
> Confidential data analytics helps to meet the highest needs of security and confidentiality by removing from computation the untrusted parties, such as the cloud operator and service or guest admins. This method helps to meet data compliance needs through hardware-backed guarantees.

### Potential use cases

Many industries, especially financial services, protect their data by using confidential computing for these purposes:

- Extending data confidentiality to cross-organization datasets (that is, multi-party computation):

  :::image type="complex" source="./media/data-analytics-containers-data-sharing-use-case.png" alt-text="Diagram of several banks sharing data and encryption keys for analytics in enclave." lightbox="./media/data-analytics-containers-data-sharing-use-case.png":::
  Diagram that shows how multiple financial institutions can share sensitive, encrypted information about banking transactions in a secured enclave for analytics to detect fraudulent patterns that wouldn't be possible with a single bank's dataset and compute.
  :::image-end:::

- Providing collective insights across organizational boundaries by using a virtual clean room:

  :::image type="complex" source="./media/data-analytics-containers-vcr-use-case.png" alt-text="Diagram of a traditional physical clean room, contrasted with a virtual clean room." lightbox="./media/data-analytics-containers-vcr-use-case.png":::
  Diagram that shows how you can achieve virtually the traditional concept of a physical clean room by using Confidential computing enclave technology.
  :::image-end:::

- Securing financial data or regulated data from a cloud operator.

- Meeting high requirements for data privacy and protection.

- Running ML model training and inferencing on sensitive data.

- Refining datasets by using familiar data preparation tools.

- Protecting container data and code integrity.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Azure confidential enclaves that use [DCsv3 and DCdsv3-series](/azure/virtual-machines/dcv3-series) VMs offer large memory sizes to help run memory-intensive applications like analytics. This scenario uses Intel SGX-enabled DCsv3-series VMs. You can only deploy certain sizes in certain regions. For more information, see [Quickstart: Deploy an Azure Confidential Computing VM in the Marketplace](/azure/confidential-computing/quick-create-marketplace) and [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Two primary factors in security for this scenario are secure enclaves and attestation.

#### Enclave assurances

Kubernetes admins, or any privileged user with the highest level of access (for example, root), can't inspect the in-memory contents or source code of drivers or executors. Enclave page cache (EPC) is a specialized memory partition in Azure Confidential VMs that enclaves or confidential containers use. DCsv3 and DCdsv3-series VMs also come with regular, unencrypted memory to run apps that don't require the secure enclave. For more information about using Intel SGX for enclaves, see [Build with SGX enclaves](/azure/confidential-computing/confidential-computing-enclaves).

#### Attestation

_Attestation_ is a mechanism that provides to a client, or _party_, cryptographic evidence that the environment where an app is running is trustworthy, including both its hardware and software, before exchanging data. _Remote attestation_ ensures that your workload hasn't been tampered with when deployed to an untrusted host, such as a VM instance or a Kubernetes node that runs in the cloud. In this process, attestation evidence provided by Intel SGX hardware is analyzed by an attestation provider. 

To perform remote attestation on a SCONE application (such as Spark Driver and Executor pods), two services are required:

- **Local attestation service (LAS)**: A local service that runs on the untrusted host (AKS node pool VM) and gathers the attestation evidence that's provided by Intel SGX about the application being attested. Because of SCONE's method of app deployment, this evidence is signed and forwarded to the configuration and attestation service (CAS).

- **CAS**: A central service that manages security policies (called _SCONE sessions_), configuration, and secrets. CAS compares the attestation evidence that's gathered by LAS against the application's security policies (which are defined by the application owner) to decide whether the enclave is trustworthy. If it is, CAS allows the enclave to run, and SCONE securely injects configuration and secrets into it. To learn more about CAS and its features, such as secret generation and access control, see [SCONE Configuration and Attestation Service](https://sconedocs.github.io/CASOverview).

This scenario uses a [public CAS](https://sconedocs.github.io/public-CAS) provided by SCONE for demonstration and simplicity, and it deploys the [LAS](https://sconedocs.github.io/LASIntro) to run as a [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset) on each AKS node.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator), which preconfigures all Azure services. Please note the additional licenses that are required by the partner to run production workloads.

## Deploy this scenario

Deploying this scenario involves the following high-level steps:

- Get access to the PySpark base image that's used in this scenario from SCONE's container registry: see **registry.scontain.com:5050** on [SCONE curated images](https://sconedocs.github.io/SCONE_Curated_Images).

- Clone the demo project on GitHub, [Confidential Data Analytics with Apache Spark on Intel SGX Confidential Containers](https://github.com/Azure-Samples/confidential-container-samples/tree/main/confidential-big-data-spark). This project contains all the needed resources, deployment steps, and source-code to reproduce the demo.
  
- Deploy [Always Encrypted with secure enclaves in Azure SQL Database - Demos](https://github.com/microsoft/sql-server-samples/blob/master/samples/features/security/always-encrypted-with-secure-enclaves/azure-sql-database-sgx/README.md). These demos use a confidential dataset, ContosoHR, which is included. This scenario decrypts confidential data into plaintext inside the Spark containers enclave.

- Deploy an Intel SGX-enabled AKS cluster node pool. For instructions, see [Quickstart: Deploy an AKS cluster with confidential computing nodes by using the Azure CLI](/azure/confidential-computing/confidential-enclave-nodes-aks-get-started).

- Deploy the SCONE Local Attestation Service to the cluster by using the included Kubernetes manifest.

- Build the encrypted image with SCONE confidential computing software and push it to your own Azure Container Registry. The repo has a demo application that counts the number of lines in New York City's [Yellow Taxi trip records](/azure/open-datasets/dataset-taxi-yellow?tabs=azureml-opendatasets), an open dataset of times, locations, fares, and other data that's related to taxi trips. You can adapt this to your specific needs.

- Deploy the Spark application by running the command **spark-submit**. This deploys a driver pod and a configurable number of executor pods (the demo uses three) that run the tasks and report the analysis results to the driver. All communication is encrypted.

Alternatively, SCONE Confidential PySpark on Kubernetes, a VM, includes the same demo that you can reproduce in a local [minikube](https://minikube.sigs.k8s.io/docs/start) cluster. For more information, see the official documentation: [SCONE PySpark virtual machine](https://sconedocs.github.io/azure/scone-pyspark).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Amar Gowda](https://www.linkedin.com/in/nramar) | Principal Program Manager

Other contributor:

* [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure confidential computing](/azure/confidential-computing)
- [Confidential containers on AKS](/azure/confidential-computing/confidential-containers)

## Related resources

- [Attestation, authentication, and provisioning](/azure/architecture/example-scenario/iot/attestation-provisioning)
- [Big data analytics with enterprise-grade security using Azure Synapse](/azure/architecture/solution-ideas/articles/big-data-analytics-enterprise-grade-security)
- [Confidential computing on a healthcare platform](/azure/architecture/example-scenario/confidential/healthcare-inference)
- [Multiparty computing with Azure services](/azure/architecture/guide/blockchain/multiparty-compute)
