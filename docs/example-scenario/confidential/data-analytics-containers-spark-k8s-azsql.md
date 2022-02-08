There is exponential growth of datasets that has resulted in growing scrutiny of how data is exposed — both from a consumer data privacy and compliance perspective. In this context, confidential computing becomes an important tool to help organizations meet their privacy and security needs surrounding business and consumer data. Organizations can gain new insights on regulated data if processed in a compliant manner especially in scenarios where the scale of cloud is needed to process the data confidentially.

Confidential computing technology encrypts data in memory and only processes it once the cloud environment is verified or "attested", preventing data access from cloud operators, malicious admins, and privileged software such as the hypervisor. It helps keep data protected throughout its lifecycle—in addition to existing solutions of protecting data at rest and in transit, data is now protected while in use.

[Confidential containers](https://docs.microsoft.com/en-us/azure/confidential-computing/confidential-nodes-aks-overview) on Azure Kubernetes Service (AKS) provides the necessary infrastructure for customers to bring popular applications such as [Apache Spark](https://spark.apache.org/) to perform data cleansing and ML training. This article presents a solution that Azure confidential computing (ACC) offers to run an Apache Spark application on an AKS cluster using Intel SGX confidential NodePools and safely store the processed data into [Azure SQL Always Encrypted with Secure Enclaves](https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/always-encrypted-enclaves?view=sql-server-ver15).

> [!NOTE]
> Confidential data analytics in this context is meant to imply: **_"run analytics on PII data with peace of mind against data exfiltration"_** - this includes potential `root`-level container access breach both internally (rogue admin) or externally (system compromise). Confidential data analytics helps meet the highest security and confidentiality needs by removing the untrusted parties from computation like cloud operator, service/guest admins. This execution helps meet data compliance needs through hardware backed guarantees.

## Potential use cases

Many industries - specially Financial Services - protect their data by using confidential computing for these purposes:
- Extending the data confidentiality to cross organization datasets (multi-party computation):
:::image type="complex" source="./media/data-analytics-containers-data-sharing-use-case.png" alt-text="Diagram of several banks sharing data and encryption keys for analytics in enclave" border="false":::
Diagram showing how multiple financial institutions can share sensitive, encrypted PII information about banking transactions in a secured enclave for analytics to detect fraudulent patterns that would not be possible with a single Bank's Dataset and compute.
:::image-end:::
- Virtual clean room - collective insights across organization boundaries:
:::image type="complex" source="./media/data-analytics-containers-vcr-use-case.png" alt-text="Diagram of a traditional Physical Clean Room contrasted with a Virtual Clean Room" border="false":::
Diagram showing how the traditional concept of a Physical Clean Room can be achieved Virtually using Confidential Computing Enclave Technology.
:::image-end:::
- Securing financial data or regulated data from a cloud operator
- Meeting high data privacy and protection needs
- Running ML model training and inferencing on sensitive data
- Dataset refining using familiar data prep tools
- Protecting container data and code integrity

## Architecture

### Overview
:::image type="complex" source="./media/data-analytics-containers-confidential-data-processing.png" alt-text="Diagram of confidential Big Data Analytics with Apache Spark, Azure SQL Always Encrypted, AKS and Scone" border="false":::
Diagram showing how sensitive data flows from ingestion phase to analytics securely within the bounds of confidential computing environment. The problem this architecture aims to solve is how sensitive data can be ingested and stored in Azure cloud to gather business insights by processing and storing it at scale while ensuring confidentially through hardware enforced means.
:::image-end:::

*Download a [PowerPoint file][media/confidential-data-processing.pptx] of this architecture.*

The diagram above outlines the architecture - a scalable pattern for processing larger datasets in a distributed fashion, as well as showcasing confidential analytics on relational Database Engines storing confidential data. In particular - the containerized Spark app can process datasets from 2 data sources as illustrated:
1. [Azure Data Lake Storage - Parquet/Delta Lake files](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction): As shown in the [sample demonstration](#deploy-this-scenario), a 4 Pod Spark deployment (1 Driver, 3 Executor on [Scone's runtime](https://sconedocs.github.io/sconeapps_spark)) is capable of processing 1.5 Billion Rows of Parquet/Delta Lake files stored on Azure Data Lake Storage within 2 minutes or ~131 seconds.
2. [Azure SQL DB - Always Encrypted with secure enclaves](https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/always-encrypted-enclaves?view=sql-server-ver15): We use Spark to access Always Encrypted data as plaintext using the [Azure SQL JDBC Driver](https://docs.microsoft.com/en-us/sql/connect/jdbc/using-always-encrypted-with-the-jdbc-driver?view=sql-server-ver15) inside the Spark Container Enclave to run Analytics and machine learning pipelines.

This pattern can be easily extended to include any Data Sources supported within Spark's large ecosystem.

### Execution steps
The solution involves the following steps:

1. Operator persona: A DevOps Engineer provisions Kubernetes Clusters, [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/), [Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) and Confidential VM NodePools (e.g. [`DC4s_v3`](https://docs.microsoft.com/en-us/azure/virtual-machines/dcv3-series)).
2. Developer persona: A Data Engineer writes a PySpark analytics application designed to analyze large volumes of data.
3. Data custodian persona: The Data and/or Security Engineer creates a security policy for the PySpark application from a shared repository in the organization (one-time activity). This policy specifies the expected state of the data and app code, minimum security requirements for the platform, and any environment variables, command line arguments or secrets (such as the JDBC string, input blob URI and a SAS token to access it). This can also be made available to the Spark runtime using Kubernetes [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) or [AKV-backed secrets](https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver) as required by established Enterprise Guidelines. This configuration is injected into the enclave only if the evidence provided by it is validated by an attestation provider. The [attestation provider](https://sgx101.gitbook.io/sgx101/sgx-bootstrap/attestation) (for example, [Azure Attestation Service](https://docs.microsoft.com/en-us/azure/attestation/overview)) is also defined in the security policy.
4. With the help of the SCONE confidential computing software through Azure ISV partner, the Data engineer is able to build a confidential Docker image that contains the encrypted analytics code and a secure version of PySpark. SCONE works within an AKS cluster that has the [Software Guard Extensions (SGX) enabled](https://docs.microsoft.com/en-us/azure/confidential-computing/confidential-enclave-nodes-aks-get-started#create-an-aks-cluster-with-a-system-node-pool) that allows the container to run inside of an enclave. PySpark will provide evidence that the sensitive data and app code is encrypted and isolated in a Trusted Execution Environment. This means that no humans, no processes, and no logs have access to the plaintext data or the application code.
5. The PySpark application is deployed to the remote AKS cluster. It starts and sends its attestation evidence to the attestation provider. If the evidence is valid, an _attestation token_ is returned. The remote infrastructure accepts the attestation token and verifies it with a public certificate found in the Azure Attestation service. If the token is verified, there is near certainty that the enclave is safe and neither the data or app code have been opened outside of the enclave. The configuration in the security policy (env. variables, command line arguments and secrets) is then injected into PySpark enclaves.
6. The PySpark execution can be horizontally scaled across several Kubernetes nodes. All PySpark instances communicate over an encrypted channel, and all the files that need to be written to their local filesystems (e.g. shuffle files) are also encrypted.
7. The results of the analysis are encrypted and uploaded to an [Azure SQL Database with Always Encrypted](https://docs.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-azure-key-vault-configure?tabs=azure-powershell) (Column level encryption). Access to the output data and encryption keys can be securely granted to other confidential applications (e.g., in a pipeline) using the same security policies and hardware-based attestation evidence approach described here.


### Components

- [Azure Kubernetes Service](https://azure.microsoft.com/en-us/services/kubernetes-service/#overview) simplifies the process of deploying and managing a Kubernetes cluster.

- [Confidential computing nodes](https://docs.microsoft.com/en-us/azure/confidential-computing/confidential-nodes-aks-overview) are hosted on a specific virtual machine series that can run sensitive workloads on AKS within a hardware-based trusted execution environment (TEE) by allowing user-level code to allocate private regions of memory, known as [enclaves](https://sgx101.gitbook.io/sgx101/sgx-bootstrap/enclave). Confidential computing nodes can support confidential containers or enclave-aware containers.

- [SCONE platform](https://azuremarketplace.microsoft.com/marketplace/apps/scontainug1595751515785.scone?tab=Overview) is an Azure Partner independent software vendor (ISV) solution from Scontain.

- [Secure Container Environment (SCONE)](https://sconedocs.github.io/) supports the execution of confidential applications in containers that run inside a Kubernetes cluster.

- [Apache Spark](https://spark.apache.org/) is an open-source, multi-language engine for executing data engineering, data science, and machine learning on both single-node machines or multi-node clusters - such as Kubernetes Pods.

- [Azure SQL Database - Always Encrypted with Secure Enclaves](https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/always-encrypted-enclaves?view=sql-server-ver15) expands confidential computing capabilities of [SQL Server's Always Encrypted technology](https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/always-encrypted-database-engine?view=sql-server-ver15) by enabling in-place encryption and richer confidential queries.

- [Azure Attestation](/azure/attestation/) is a unified solution that remotely verifies the trustworthiness of a platform. Azure Attestation also remotely verifies the integrity of the binaries that run in the platform. Use Azure Attestation to establish trust with the confidential application.


### Alternatives for Intel SGX wrapper software for containers

[Occlum]( https://occlum.io/) is a memory-safe, multi-process library OS (LibOS) for Intel SGX. The OS enables legacy applications to run on SGX with little to no modifications to source code. Occlum transparently protects the confidentiality of user workloads while allowing an easy "lift and shift" to existing Docker applications. Occlum supports Java apps.

The SCONE engineering team maintains an [Apache Spark](https://sconedocs.github.io/sconeapps_spark/) Container Image running the latest version of Spark. Some alternatives - not specific to Apache Spark include:

- [Fortanix](https://www.fortanix.com) to deploy confidential containers to use with your containerized application. Fortanix provides the flexibility needed to run and manage the broadest set of applications: existing applications, new enclave-native applications, and pre-packaged applications.

## Considerations

Azure Confidential Enclave VM's DCsv3 and DCdsv3 offers large EPC memory sizes to help run memory intensive applications like analytics. This scenario uses Intel SGX-enabled DCsv3-series virtual machines. You can only deploy certain sizes in certain regions. For more information, see [Quickstart: Deploy an Azure Confidential Computing VM in the Marketplace](/azure/confidential-computing/quick-create-marketplace) and [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines).

### Enclave assurances

Kubernetes admins, or any privileged user with the highest level of access (e.g. `root`), cannot inspect the in-memory contents or source code of driver or executors. EPC is specialized memory partition in an Azure Confidential VMs that Enclaves or Confidential containers use. These VM's also come with regular memory (un-encrypted) memory to run non-enclave apps. Read more about Intel SGX Enclaves [here](https://docs.microsoft.com/en-us/azure/confidential-computing/confidential-computing-enclaves)

### Attestation

Attestation is a mechanism that allows any client(party) that needs cryptographic evidence that the environment where the app is running can be verified including its software and hardware components before exchanging data.

Remote attestation ensures that your workload has not been tampered with when deployed to a untrusted host, such as a VM instance or a Kubernetes node that runs in the cloud. In this process, attestation evidence provided by Intel SGX hardware is analyzed by an attestation provider. To perform remote attestation on a Scone application (such as Spark Driver and Executor pods), two services are required:
* **Local Attestation Service (LAS)**: runs on the untrusted host (AKS Nodepool VM) and gathers the attestation evidence provided by Intel SGX about the application being attested. This evidence is signed and forwarded to CAS because of Scone app deployment methods; and
* **Configuration and Attestation Service (CAS**): a central service that manages security policies (called Scone sessions), configuration and secrets. CAS compares the attestation evidence gathered by LAS against the application's security policies (defined by the application owner) to decide whether the enclave is trustworthy of not. If so, CAS allows the enclave to run and securely injects configuration and secrets into it. [Learn more about CAS and its features, such as secret generation and access control](https://sconedocs.github.io/CASOverview/).

For this scenario, we use a [Public CAS](https://sconedocs.github.io/public-CAS/) provided by Scone for demonstration and simplicity. We deploy the [LAS](https://sconedocs.github.io/LASIntro/) to run as a [`DaemonSet`](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) per AKS node.


## Deploy this scenario

Deploying this scenario involves the following high-level steps:

- Get access to the PySpark base image used in this scenario from Scone's Container Registry: `registry.scontain.com:5050` - [see instructions here](https://sconedocs.github.io/SCONE_Curated_Images/).

- Clone the [SGX PySpark Demo project on GitHub](https://github.com/Azure-Samples/confidential-container-samples/tree/main/confidential-big-data-spark). This project contains all the needed resources, deployment steps and source-code to reproduce the demo.
  
- Deploy an [Azure SQL Always Encrypted with Secure Enclaves demo](https://github.com/microsoft/sql-server-samples/blob/master/samples/features/security/always-encrypted-with-secure-enclaves/azure-sql-database/README.md) containing a Confidential Dataset - we will be decrypting this data into plaintext inside the Spark Containers Enclave.

- Deploy an [Intel SGX-enabled AKS cluster node pool](https://docs.microsoft.com/en-us/azure/confidential-computing/confidential-enclave-nodes-aks-get-started).

- Deploy the SCONE Local Attestation Service to the cluster using the included Kubernetes manifest.

- The repo has a demo application that counts the number of lines in the NYC Taxi Yellow open dataset. This can be adapted to your specific needs. Build the encrypted image with SCONE confidential computing software and push it to your own Azure Container Registry.

- Deploy the Spark application using the `spark-submit` command. This will deploy a driver pod and a configurable number of executor pods (demo uses 3) that run the tasks and report the analysis results back to the driver. All communication is encrypted.

Alternatively, the [SCONE Confidential PySpark on Kubernetes Virtual Machine](https://portal.azure.com/#create/scontainug1595751515785.scone-pysparkstandard) includes the same demo that can be reproduced in a local [minikube](https://minikube.sigs.k8s.io/docs/start/) cluster. Check the [official documentation](https://sconedocs.github.io/azure/scone-pyspark/) for more info.

## Pricing

To explore the cost of running this scenario, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator), which preconfigures all Azure services. Please note the additional licenses required by the partner to run production workloads. 

## Next steps

- Learn more about [Azure confidential computing](/azure/confidential-computing/).

## Related resources

- [Confidential containers on AKS](/azure/confidential-computing/confidential-containers).

[Confidential Healthcare Inference svg]: ./media/confidential-healthcare-inference.svg
