Organizations that use an internal or nonintegrated certification authority (CA) often rely on manual processes to renew Transport Layer Security (TLS) and Secure Sockets Layer (SSL) certificates. Manual renewal can lead to expired certificates that cause service outages, for example when a web server certificate expires unnoticed and disrupts customer-facing applications.

Azure Key Vault supports [automatic certificate renewal](/azure/key-vault/certificates/overview-renew-certificate) for integrated CAs like *DigiCert* or *GlobalSign*, but nonintegrated CAs require a [manual approach](/azure/key-vault/certificates/overview-renew-certificate#renew-a-nonintegrated-ca-certificate). This article presents an architecture that automates certificate renewal for nonintegrated CAs by using Key Vault, Azure Event Grid, Azure Automation, and the Key Vault extension. The solution reduces human error, minimizes service interruptions, and enforces the principle of least privilege across all identities in the renewal process.

## Architecture

This section provides an overview of the underlying architecture that powers this solution.

:::image type="complex" source="./media/certlc-arch.svg" alt-text="Diagram of the certificate life cycle management architecture." border="false" lightbox="./media/certlc-arch.svg":::
   The diagram has two main sections. One section is labeled Azure landing zone subscription, and the other section is labeled on-premises. In the landing zone subscription section, a large box labeled CERTLC contains smaller boxes for Azure Virtual Network and an Automation account. In the Virtual Network box, two computer icons are labeled DC and ENT-CA. On the ENT-CA icon, a dotted line that represents the Hybrid Runbook Worker begins. The line connects the runbook worker to the CERTLC runbook in the Automation account box. The Virtual Network box also contains computer icons that represent two servers, one with the Key Vault extension and one with a custom script. A solid line connects the Virtual Network box to the on-premises section of the diagram. The Automation account box also contains the dashboard ingestion runbook. A dotted line connects this runbook to the Log Analytics workspace in the CERTLC box. The CERTLC box also contains icons that represent a storage account, Event Grid, Key Vault, and a workbook. The Azure landing zone subscription section includes icons that represent a recovery services vault, role assignments, policy assignments, Azure Network Watcher, and Microsoft Defender for Cloud. In the on-premises section, a box labeled Active Directory contains two smaller boxes for Azure Arc-enabled servers. One server uses the Key Vault extension, and the other server uses a custom script.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/certlc-arch.vsdx) of this architecture.*

The Azure environment comprises the following platform as a service (PaaS) resources: 

- A key vault that only stores certificates issued by the same nonintegrated CA

- An Event Grid system topic

- A storage account queue

- An Automation account that exposes a webhook that Event Grid targets

To monitor the process and status of expired and expiring certificates, Log Analytics stores the data, and the workspace presents it in the form of tabular and graphical dashboards.

This scenario assumes that an existing public key infrastructure (PKI) is already in place and consists of a Microsoft Enterprise CA joined to an Active Directory domain. The PKI, the Active Directory domain, and the servers that require certificate renewal can reside on Azure or on‑premises environments.

You don't need to join the virtual machines (VMs) that have certificates that monitor renewal to Active Directory or to Microsoft Entra ID. You only need to join the CA and the hybrid worker, if it's located on a different VM than the CA, to Active Directory.

The following sections provide details about the automatic renewal process.

### Workflow

The following diagram shows the automatic workflow for certificate renewal within the Azure ecosystem.

:::image type="complex" source="./media/workflow.png" alt-text="Diagram of the automatic workflow for certificate renewal within the Azure ecosystem." border="false" lightbox="./media/workflow.png":::
   The diagram uses arrows and numbers to show the automatic workflow for certificate renewal within the Azure ecosystem. Icons for Key Vault, a server, a CA, Event Grid, a storage account, and an Automation account are at the top of the diagram. Arrows are labeled 1 through 9. Number 1 goes from a certificate in the CA to Key Vault. Number 2 goes from a certificate in Key Vault to the server. Number 3 goes from a certificate in Key Vault to Event Grid. Number 4 goes from Event Grid to both the storage account and the webhook in the Automation account. Number 5 is a double-sided arrow that goes to and from the certificate in the storage account and the Automation account. Number 6 is a double-sided arrow that goes to and from the certificate in the CA and the Automation account. Number 7 goes from the certificate in the Automation account to the server. Number 9 goes from the certificate in Key Vault to the server.
:::image-end:::

The following workflow corresponds to the previous diagram:

1. **Key Vault configuration:** The initial phase of the renewal process entails storing the certificate object in the designated certificates section of the key vault.

   We recommend that you use certificate tags to configure custom email notifications by tagging each certificate with the recipient's email address. This approach lets you notify specific administrators for each certificate, rather than applying the same recipient to all certificates.
   Use the *Recipient* tag and set its value to one or more email addresses separated by a comma or semicolon. Tag-based notifications ensure timely alerts when the certificate renewal completes on the internal CA and when the renewed certificate becomes available in Key Vault.

    You can use [built-in Key Vault certificate notifications](/azure/key-vault/certificates/overview-renew-certificate#get-notified-about-certificate-expiration) in combination with this approach, but they serve a different purpose. Built-in notifications apply globally to all certificates in the key vault and are limited to upcoming certificate expiration alerts. They use the same recipient for all certificates.

1. **Key Vault extension configuration:** You must equip the servers that need to use the certificates with the Key Vault extension. The extension is compatible with [Windows](/azure/virtual-machines/extensions/key-vault-windows) and [Linux](/azure/virtual-machines/extensions/key-vault-linux) systems. It supports Azure infrastructure as a service (IaaS) servers and on-premises or other cloud servers that integrate through [Azure Arc](/azure/azure-arc/overview). Configure the Key Vault extension to periodically poll Key Vault for any updated certificates. The polling interval is customizable and flexible, so it can align with specific operational requirements.

   > [!NOTE]
   > On some Linux distributions or hardened enterprise images, the Key Vault extension might not be available or supported. In these cases, schedule the [script_for_not_supported_ARC_on_Linux_distro script](https://github.com/Azure/certlc/tree/main/.scripts) as a recommended fallback. The script periodically checks Key Vault for certificate updates and applies them to the server. It can run on Azure native VMs (IaaS) and on-premises servers integrated with Azure Arc.

1. **Event Grid integration:** As a certificate approaches expiration, two Event Grid subscriptions intercept this important lifetime event from the key vault.

1. **Event Grid triggers:** One Event Grid subscription sends certificate renewal information to a storage account queue. The other subscription triggers the launch of a runbook through the configured webhook in the Automation account. If the runbook fails to renew the certificate, or if the CA is unavailable, a scheduled process retries renewing the runbook from that point until the queue clears. This process makes the solution robust.

   To enhance the solution's resiliency, set up a [dead-letter location](/azure/event-grid/manage-event-delivery#set-dead-letter-location) mechanism. It manages potential errors that might occur during message transit from Event Grid to the subscription targets, the storage queue, and the webhook.

1. **Storage account queue:** The runbook launches within the CA server configured as an Automation Hybrid Runbook Worker. It receives all messages in the storage account queue that contain the name of the expiring certificate and the key vault that hosts the runbook. The following steps occur for each message in the queue.

1. **Certificate renewal:** The script in the runbook connects to Azure to retrieve the certificate's template name that you set up during generation. The template is the configuration component of the CA that defines the attributes and purpose of the certificates that it generates.

   After the script interfaces with Key Vault, it initiates a certificate renewal request. This request triggers Key Vault to generate a certificate signing request (CSR) and applies the same template that generated the original certificate. This process ensures that the renewed certificate aligns with the predefined security policies. For more information about security in the authentication and authorization process, see the [Security](#security) section.

   The script downloads the CSR and submits it to the CA.

   The CA generates a new x509 certificate based on the correct template and sends it back to the script. This step ensures that the renewed certificate aligns with the predefined security policies.

1. **Certificate merging and Key Vault update:** The script merges the renewed certificate back into the key vault. This step finalizes the update process and removes the message from the queue. Throughout the entire process, the private key of the certificate is never extracted from the key vault.

1. **Monitoring and email notification:** To enable monitoring, the Azure Monitor Logs workspace logs all operations that various Azure components run, including the Automation account, Key Vault, the storage account queue, and Event Grid. After the certificate merges into the key vault, the script sends an email message to administrators to notify them of the outcome.

1. **Certificate retrieval:** The Key Vault extension on the server plays an important role during this phase. It automatically downloads the latest version of the certificate from the key vault into the local store of the server that uses the certificate. You can configure multiple servers with the Key Vault extension to retrieve the same certificate, including wildcard or with multiple Subject Alternative Name (SAN) certificates, from the key vault.

   For Linux distributions in which you can't install the Key Vault extension, schedule the [script_for_not_supported_ARC_on_Linux_distro script](https://github.com/Azure/certlc/tree/main/.scripts) to achieve the same functionality as the extension.

### Components

This solution uses various components to handle automatic certificate renewal on Azure. The following sections describe each component and its specific purpose.

#### Key Vault extension

The Key Vault extension is a tool installed on servers that provides automatic refresh of certificates stored in an Azure key vault. In this architecture, the Key Vault extension plays a vital role in automating certificate renewal. You must install it on servers that require the automation. For more information about installation procedures for various servers, see the following articles:

- [Key Vault extension for Windows](/azure/virtual-machines/extensions/key-vault-windows)
- [Key Vault extension for Linux](/azure/virtual-machines/extensions/key-vault-linux)
- [Key Vault extension for Azure Arc-enabled servers](https://techcommunity.microsoft.com/t5/azure-arc-blog/in-preview-azure-key-vault-extension-for-arc-enabled-servers/ba-p/1888739)

> [!NOTE]
> The following scripts are samples that you can run from Azure Cloud Shell to configure the Key Vault extension:
>
> - [Key Vault extension for Windows servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionWin.ps1)
> - [Key Vault extension for Linux servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionLinux.ps1)
> - [Key Vault extension for Azure Arc-enabled Windows servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionARCWin.ps1)
> - [Key Vault extension for Azure Arc-enabled Linux servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionARCLinux.ps1)

The Key Vault extension configuration parameters include:

- **Key Vault Name:** The key vault that contains the certificate for renewal.

- **Certificate Name:** The name of the certificate to renew.

- **Certificate Store, Name, and Location:** The certificate store where the certificate is stored. On Windows servers, the default value for *Name* is `My` and *Location* is `LocalMachine`, which is the personal certificate store of the computer. On Linux servers, you can specify a file system path, assuming that the default value is `AzureKeyVault`, which is the certificate store for Key Vault.

- **linkOnRenewal:** A flag that indicates whether the certificate should be linked to the server on renewal. If the flag is set to `true` on Windows machines, it copies the new certificate in the store and links it to the old certificate, which effectively rebinds the certificate. The default value is `false`, which means that an explicit binding is required.

- **pollingIntervalInS:** The polling interval for the Key Vault extension to check for certificate updates. The default value is `3600` seconds (1 hour).

- **authenticationSetting:** The authentication setting for the Key Vault extension. For Azure servers, you can omit this setting so that the VM's system-assigned managed identity is used against the key vault. For on-premises servers, if you specify the setting `msiEndpoint = "http://localhost:40342/metadata/identity"`, the service principal associated with the computer object created during the Azure Arc onboarding is used.

> [!NOTE]
> Specify the Key Vault extension parameters only during the initial setup. This approach ensures that they won't undergo any changes throughout the renewal process.

#### Automation account

An [Automation account](/azure/automation/automation-security-overview) is a cloud-based service that automates tasks via runbooks. In this architecture, it handles the certificate renewal process. You need to configure the account with a runbook by using the [PowerShell script](https://github.com/Azure/certlc/blob/main/.runbook/runbook_v3.ps1).

You also need to create a Hybrid Worker Group. Associate the Hybrid Worker Group with a Windows Server member of the same Active Directory domain of the CA, ideally the CA itself, for launching runbooks.

The runbook must have an associated [webhook](/azure/automation/automation-webhooks) initiated from the Hybrid Runbook Worker. Configure the webhook URL in the event subscription of the Event Grid system topic.

#### Storage account queue

The storage account queue is a message queue within Azure Storage. In this architecture, it stores the messages that contain the name of the certificate being renewed and the key vault that contains the certificate. Configure the storage account queue in the event subscription of the Event Grid system topic. The queue handles decoupling the script from the certificate expiration notification event. It supports persisting the event within a queue message. This approach helps ensure that the renewal process for certificates is repeated through scheduled jobs even if problems occur during the script's run.

#### Hybrid Runbook Worker

The Hybrid Runbook Worker is a feature of Automation that you use to run runbooks on machines located in a data center. In this architecture, it runs the certificate renewal runbook. Install the Hybrid Runbook Worker by using the [Azure Hybrid Worker extension](/azure/automation/extension-based-hybrid-runbook-worker-install) method, which is the supported mode for a new installation. You create the worker and associate it with a Windows Server member in the same Active Directory domain of the CA, ideally the CA itself.

#### Key Vault

Key Vault is the secure repository for certificates. In this architecture, it stores certificates issued only by the same nonintegrated CA. Under the event section of the key vault, associate the Event Grid system topic with the webhook of the Automation account and a subscription.

#### Event Grid

Event Grid is an event-routing service. In this architecture, it handles event-driven communication within Azure. Configure Event Grid by setting up the system topic and event subscription to monitor relevant events. Relevant events include certificate expiration alerts, actions triggered within the automation workflow, and messages posted in the storage account queue. Configure the Event Grid system topic by using the following parameters:

- **Source:** The name of the key vault that contains the certificates.

- **Source Type:** The type of the source. For example, the source type for this solution is `Azure Key Vault`.

- **Event Type:** The event type to monitor. For example, the event type for this solution is `Microsoft.KeyVault.CertificateNearExpiry`. This event triggers when a certificate is near expiration.

- **Subscription for Webhook:**

  - **Subscription Name:** The name of the event subscription.

  - **Endpoint Type:** The type of endpoint to use. For example, the endpoint type for this solution is `Webhook`.

  - **Endpoint:** The URL of the webhook associated with the Automation account runbook. For more information, see the [Automation account](#automation-account) section.

- **Subscription for StorageQueue:**

  - **Subscription Name:** The name of the event subscription.

  - **Endpoint Type:** The type of endpoint to use. For example, the endpoint type for this solution is `StorageQueue`.

  - **Endpoint:** The storage account queue.

#### Log Analytics workspace and Azure workbook

Log Analytics workspaces and Azure workbooks are Azure resources that collect, aggregate, and analyze data. In this architecture, they enhance monitoring and visualization of certificate statuses stored in Key Vault. These components play a crucial role in maintaining visibility into certificate health:

- **Log Analytics workspace:** Collects and stores data about certificate states. It identifies expired certificates, certificates that expire soon, and valid  certificates.

- **Azure workbook:** Retrieves data from the Log Analytics workspace and presents it in a dashboard with visual representations, such as pie charts and detailed tables. It categorizes certificates into *Not Expired* (green), *Expiring Soon* (yellow), and *Expired* (red).

The following components retrieve and present certificate information in the workbook:

- **Data ingestion runbook execution:** A runbook, run directly from Azure without requiring the context of a Hybrid Worker, retrieves certificate data from the Key Vault and sends this information to a custom table defined in the Log Analytics workspace. The runbook runs on a scheduled cadence.

- **Workbook visualization:** A workbook queries the data from the custom table and displays it in both a pie chart and a detailed table. It highlights certificates based on their expiration status.

By integrating these extra components, your solution builds a more comprehensive approach to certificate life cycle management.

:::image type="content" source="./media/workbook.png" alt-text="Screenshot that shows the certificate status dashboard." lightbox="./media/workbook.png":::

### Alternatives

This solution uses an Automation account to orchestrate the certificate renewal process. It also uses Hybrid Runbook Worker to provide the flexibility to integrate with a CA on-premises or in other clouds.

An alternative approach is to use Azure Logic Apps. The main difference between the two approaches is that the Automation account is a PaaS solution, and Logic Apps is a software as a service (SaaS) solution.

The main advantage of Logic Apps is that it's a fully managed service. You don't need to manage the underlying infrastructure. Also, Logic Apps can easily integrate with external connectors. This capability expands the range of notification possibilities, such as engagement with Microsoft Teams or Microsoft 365.

Logic Apps doesn't have a feature similar to Hybrid Runbook Worker, which results in less flexible integration with the CA, so an Automation account is the preferred approach.

## Scenario details

Every organization requires secure and efficient management of their certificate life cycle. Failing to update a certificate before expiration can lead to service interruptions and incur significant costs for the business.

Enterprises typically operate complex IT infrastructures that involve multiple teams who are responsible for the certificate life cycle. The manual nature of the certificate renewal process often introduces errors and consumes valuable time.

This solution addresses these challenges by automating certificate renewal issued by Microsoft Certificate Service. The service is widely used for various server applications, such as web servers and SQL servers, and for encryption, nonrepudiation, signing purposes, and ensuring timely updates and secure certificate storage within Key Vault. The service's compatibility with Azure servers and on-premises servers supports flexible deployment.

### Potential use cases

This solution caters to organizations across various industries that:

- Use Microsoft Certificate Service for server certificate generation.

- Require automation in the certificate renewal process to accelerate operations and minimize errors, which helps avoid business loss and service-level agreement (SLA) violations.

- Require secure certificate storage in repositories like Key Vault.

This architecture serves as a foundational deployment approach across application landing zone subscriptions.

> [!NOTE]
> You can extend the same life cycle pattern to Azure App Service, Azure Application Gateway, and Kubernetes workloads that integrate with Key Vault.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Key Vault securely stores certificates as encrypted secrets protected by Azure role-based access control (RBAC).

> [!TIP]
> In environments that have strict compliance requirements, such as NIS2 or public-sector regulations, consider evaluating [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview) for key protection while keeping the same renewal workflow.

Throughout the certificate renewal process, the following components use identities:

- The system account of the Hybrid Runbook Worker, which operates under the VM's account

- The Key Vault extension, which uses the managed identity associated with the VM

- The Automation account, which uses its designated managed identity

The principle of least privilege is rigorously enforced across all identities engaged in the certificate renewal procedure.

The system account of the Hybrid Runbook Worker server must have the right to enroll certificates on one or more certificate templates that generate new certificates.

On the key vault that contains the certificates, the Automation account identity must have the `Key Vault Certificate Officer` role. Additionally, servers that require certificate access must have `Get` and `List` permissions within the Key Vault certificate store.

On the storage account queue, the Automation account identity must have the `Storage Queue Data Contributor`, `Reader and Data Access`, and `Reader` roles.

In scenarios in which the Key Vault extension deploys on an Azure VM, authentication occurs via the VM's managed identity. However, when the extension deploys on an Azure Arc-enabled server, a service principal handles authentication. You must assign the Key Vault secret user role within the key vault that stores the certificate to both the managed identity and the service principal. You must use a secret role because the certificate is stored in the key vault as a secret.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This solution uses Azure PaaS solutions that operate under a pay-as-you-go framework to optimize cost. Expenses depend on the number of certificates that need renewal and the number of servers equipped with the Key Vault extension, which results in low overhead.

Expenses that result from the Key Vault extension and the Hybrid Runbook Worker depend on your installation choices and polling intervals. The cost of Event Grid corresponds to the volume of events that Key Vault generates. The cost of the Automation account correlates with the number of runbooks that you use.

The cost of Key Vault depends on various factors, including Standard or Premium SKUs, the quantity of stored certificates, and the frequency of operations conducted on the certificates.

Similar considerations for Key Vault configuration apply to the storage account. In this scenario, a Standard SKU with locally redundant storage replication suffices for the storage account. Generally, the cost of the storage account queue is minimal.

To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Input the services described in this article.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The automatic certificate renewal procedure securely stores certificates by applying standardized processes across all certificates within the key vault.

Integration with Event Grid triggers supplementary actions, such as notifying Microsoft Teams or Microsoft 365 and streamlining the renewal process. This integration significantly reduces certificate renewal time and mitigates the potential for errors that migiht lead to business disruptions and SLA violations.

Integration with Azure Monitor, Microsoft Sentinel, Microsoft Security Copilot, and Microsoft Defender for Cloud facilitates continuous monitoring of the certificate renewal process. It supports anomaly detection and ensures that robust security measures are maintained. Defender for Cloud contributes primarily through posture management and alert correlation rather than direct certificate renewal event handling.

## Deploy this scenario

Select the following button to deploy the environment described in this article. The deployment takes about two minutes to complete and creates a key vault, an Event Grid system topic configured with the two subscriptions, a storage account containing the *certlc* queue, and an Automation account containing the *runbook* and the *webhook* linked to Event Grid.

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcertlc%2Fmain%2F.armtemplate%2Fmindeploy.json)

Detailed information about the parameters needed for the deployment can be found in the [code sample](/samples/azure/certlc/certlc/) portal.

> [!IMPORTANT]
> You can deploy a full lab environment to demonstrate the entire automatic certificate renewal workflow. Use the [code sample](/samples/azure/certlc/certlc/) to deploy the following resources:
>
> - **Active Directory Domain Services (AD DS)** within a domain controller VM.
> - **Active Directory Certificate Services (AD CS)** within a CA VM, joined to the domain, configured with a template, *WebServerShort*, for enrolling the certificates to renew.
> - A **Windows Simple Mail Transfer Protocol (SMTP) server** installed on the same VM of the CA for sending email notifications. MailViewer also installs to verify the email notifications sent.
> - The **Key Vault extension** installed on the VM of the domain controller for retrieving the renewed certificates from the Key Vault extension.
>
> [![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcertlc%2Fmain%2F.armtemplate%2Ffulllabdeploy.json)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Fabio Masciotra](https://www.linkedin.com/in/fabiomasciotra/) | Senior Cloud Solution Architect
- [Angelo Mazzucchi](https://www.linkedin.com/in/angelo-mazzucchi-a5a94270) | Principal Consultant

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Key Vault](/azure/key-vault/general/overview)
- [Key Vault extension for Windows](/azure/virtual-machines/extensions/key-vault-windows?tabs=version3)
- [Key Vault extension for Linux](/azure/virtual-machines/extensions/key-vault-linux)
- [Automation overview](/azure/automation/overview)
- [Automation Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker)
- [Azure Event Grid](/azure/event-grid/overview)
