In cybersecurity, setting up automatic certificate renewal is important to maintaining a secure and reliable environment. Failure to update or renew certificates in a timely manner exposes systems to vulnerabilities. Potentially vulnerable areas include:

- TLS/SSL certificates that are expired.
- Networks that are subject to potential breaches.
- Sensitive data that's unsecured.
- Services that go down for business-to-business processes.
- Brand reputation loss that compromises the integrity and confidentiality of digital transactions.

Azure Key Vault supports [automatic certificate renewal](/azure/key-vault/certificates/overview-renew-certificate?tabs=azure-portal) issued by an integrated certification authority (CA) such as *DigiCert* or *GlobalSign*. For a nonintegrated CA, a [manual](/azure/key-vault/certificates/overview-renew-certificate?tabs=azure-portal#renew-a-nonintegrated-ca-certificate) approach is required.

This article bridges the gap by providing an automatic renewal process tailored to certificates from nonintegrated CAs. This process stores the new certificates in Key Vault, improves efficiency, enhances security, and simplifies deployment by integrating with various Azure resources.

An automatic renewal process reduces human error and minimizes service interruptions. When you automate certificate renewal, it accelerates the renewal process and decreases the likelihood of errors that might occur during manual handling. When you use the capabilities of Key Vault and its extensions, you can build an efficient automatic process to optimize operations and reliability.

Automatic certificate renewal is the initial focus, but a broader objective is to enhance security across all areas of the process. This effort includes how to implement the principle of least privilege or similar access controls by using Key Vault. It also emphasizes the importance of robust logging and monitoring practices for Key Vault. This article highlights the importance of using Key Vault to fortify your entire certificate management lifecycle and demonstrates that the security benefits aren't limited to storing certificates.

You can use Key Vault and its automatic renewal process to continuously update certificates. Automatic renewal plays an important role in the deployment process and helps Azure services that integrate with Key Vault benefit from up-to-date certificates. This article provides insight into how continuous renewal and accessibility contribute to the overall deployment efficiency and reliability of Azure services.

## Architecture

The following diagram provides an overview of the underlying architecture that powers this solution.

:::image type="complex" source="./media/certlc-arch.svg" alt-text="Diagram of the certificate lifecycle management architecture." border="false" lightbox="./media/certlc-arch.svg":::
   The diagram has two main sections. One section is labeled Azure landing zone subscription, and the other section is labeled on-premises. In the landing zone subscription section, a large gray box that's labeled CERTLC contains smaller boxes for Virtual Network and an Azure Automation account. In the Virtual Network box, two computer icons are labeled DC and ENT-CA. On the ENT-CA icon, a dotted line that represents the hybrid runbook worker begins. The line connects the runbook worker to the CERTLC runbook that's inside of the Automation account box. The Virtual Network box also contains computer icons that represent two servers, one with the Key Vault extension and one with a custom script. A solid line connects the Virtual Network box to the on-premises section of the diagram. The Automation account box also contains the dashboard ingestion runbook. A dotted line connects this runbook to the Log Analytics workspace in the larger CERTLC gray box. Icons that represent an Azure Storage account, Azure Event Grid, Key Vault, and a workbook are also inside of the CERTLC box. Icons that represent a recovery services vault, role assignments, policy assignments, Azure Network Watcher, and Microsoft Defender for Cloud are inside of the Azure landing zone subscription section. In the on-premises section, a box that's labeled Azure Active Directory contains two smaller boxes for Azure Arc-enabled servers. One server uses the Key Vault extension, and the other uses a custom script.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/certlc-arch.vsdx) of this architecture.*

The Azure environment comprises the following platform as a service (PaaS) resources: 

- A key vault that's dedicated to storing certificates issued only by the same nonintegrated CA

- An Azure Event Grid system topic

- A storage account queue

- An Azure Automation account that exposes a webhook targeted by Event Grid

To monitor the process and status of expired and expiring certificates, Log Analytics stores the data, and the workspace presents it in the form of tabular and graphical dashboards.

This scenario assumes that an existing public key infrastructure (PKI) is already in place and consists of a Microsoft Enterprise CA joined to a domain in Microsoft Entra ID. Both the PKI and the Active Directory domain can reside on Azure or on on-premises servers that are configured for certificate renewal.

The virtual machines (VMs) that have certificates to monitor renewal don't need to be joined to Active Directory or Microsoft Entra ID. The sole requirement is for the CA and the hybrid worker, if it's located on a different VM than the CA, to be joined to Active Directory.

The following diagram shows the automatic workflow for certificate renewal within the Azure ecosystem.

:::image type="complex" source="./media/workflow.png" alt-text="Diagram of the automatic workflow for certificate renewal within the Azure ecosystem." border="false" lightbox="./media/workflow.png":::
   The diagram uses arrows and numbers to show the automatic workflow for certificate renewal within the Azure ecosystem. Icons for Key Vault, a server, a CA, Event Grid, a Storage account, and an Automation account are at the top of the diagram. Arrows are labeled 1 through 9. Number 1 goes from a certificate in the CA to Key Vault. Number 2 goes from a certificate in Key Vault to the server. Number 3 goes from a certificate in Key Vault to Event Grid. Number 4 goes from Event Grid to both the Storage account and the webhook in the Automation account. Number 5 is a double-sided arrow that goes to and from the certificate in the Storage account and the Automation account. Number 6 is a double-sided arrow that goes to and from the certificate in the CA and the Automation account. Number 7 goes from the certificate in the Automation account to the server. Number 9 goes from the certificate in Key Vault to the server.
:::image-end:::

### Workflow

The following workflow corresponds to the previous diagram:

1. **Key Vault configuration:** The initial phase of the renewal process entails storing the certificate object in the designated Certificates section of the key vault.

    Although not mandatory, you can set up custom email notifications by tagging the certificate with the recipient's email address. Tagging the certificate ensures timely notifications when the renewal process completes. If multiple recipients are necessary, separate their email addresses by a comma or a semicolon. The tag name for this purpose is *Recipient*, and its value is one or more email addresses of the designated administrators.

    When you use tags instead of [built-in certificate notifications](/azure/key-vault/certificates/overview-renew-certificate?tabs=azure-portal#get-notified-about-certificate-expiration), you can apply notifications to a specific certificate with a designated recipient. Built-in certificate notifications apply indiscriminately to all certificates within the key vault and use the same recipient for all.

    You can integrate built-in notifications with the solution but use a different approach. Built-in notifications can only notify about an upcoming certificate expiration, but the tags can send notifications when the certificate renews on the internal CA and when it's available in Key Vault.

1. **Key Vault extension configuration:** You must equip the servers that need to use the certificates with the Key Vault extension, a versatile tool compatible with [Windows](/azure/virtual-machines/extensions/key-vault-windows) and [Linux](/azure/virtual-machines/extensions/key-vault-linux) systems. Azure infrastructure as a service (IaaS) servers and on-premises or other cloud servers that integrate through [Azure Arc](/azure/azure-arc/overview) are supported. Configure the Key Vault extension to periodically poll Key Vault for any updated certificates. The polling interval is customizable and flexible so it can align with specific operational requirements.

   > [!NOTE]
   > The Key Vault extension isn't available on Linux RedHat and CentOS. To extend the solution to these systems, schedule the [**`script_for_not_supported_ARC_on_Linux_distro`**](https://github.com/Azure/certlc/tree/main/.scripts) script that periodically checks Key Vault for certificate updates and applies them to the server. The script can run on Azure native VMs (IaaS) and on-premises servers integrated with Azure Arc.

1. **Event Grid integration:** As a certificate approaches expiration, two Event Grid subscriptions intercept this important lifetime event from the key vault.

1. **Event Grid triggers:** One Event Grid subscription sends certificate renewal information to a storage account queue. The other subscription triggers the launch of a runbook through the configured webhook in the Automation account. If the runbook fails to renew the certificate, or if the CA is unavailable, a scheduled process retries renewing the runbook from that point until the queue clears. This process makes the solution robust.

   To enhance the solution's resiliency, set up a [dead-letter location](/azure/event-grid/manage-event-delivery#set-dead-letter-location) mechanism. It manages potential errors that might occur during the message's transit from Event Grid to the subscription targets, the storage queue, and the webhook.

1. **Storage account queue:** The runbook launches within the CA server that's configured as an Automation Hybrid Runbook Worker. It receives all messages in the storage account queue that contain the name of the expiring certificate and the key vault that hosts the runbook. The following steps occur for each message in the queue.

1. **Certificate renewal:** The script in the runbook connects to Azure to retrieve the certificate's template name that you set up during generation. The template is the configuration component of the certification authority that defines the attributes and purpose of the certificates to be generated.

   After the script interfaces with Key Vault, it initiates a certificate renewal request. This request triggers Key Vault to generate a certificate signing request (CSR) and applies the same template that generated the original certificate. This process ensures that the renewed certificate aligns with the predefined security policies. For more information about security in the authentication and authorization process, see the [Security](#security) section.

   The script downloads the CSR and submits it to the CA.

   The CA generates a new x509 certificate based on the correct template and sends it back to the script. This step ensures that the renewed certificate aligns with the predefined security policies.

1. **Certificate merging and Key Vault update:** The script merges the renewed certificate back into the key vault. This step finalizes the update process and removes the message from the queue. Throughout the entire process, the private key of the certificate is never extracted from the key vault.

1. **Monitoring and email notification:** All operations that various Azure components run, such as an Automation account, Key Vault, a storage account queue, and Event Grid, are logged within the Azure Monitor Logs workspace to enable monitoring. After the certificate merges into the key vault, the script sends an email message to administrators to notify them of the outcome.

1. **Certificate retrieval:** The Key Vault extension on the server plays an important role during this phase. It automatically downloads the latest version of the certificate from the key vault into the local store of the server that's using the certificate. You can configure multiple servers with the Key Vault extension to retrieve the same certificate (wildcard or with multiple Subject Alternative Name (SAN) certificates) from the key vault.

   For Linux distributions where the Key Vault extension can't be installed, schedule the [script_for_not_supported_ARC_on_Linux_distro](https://github.com/Azure/certlc/tree/main/.scripts) script to achieve the same functionality as the extension.

### Components

The solution uses various components to handle automatic certificate renewal on Azure. The following sections describe each component and its specific purpose.

#### Key Vault extension

The Key Vault extension is a tool installed on servers to automate certificate retrieval from Key Vault. This extension plays a vital role in automating certificate renewal and must be installed on servers that require the automation. In this architecture, this extension periodically polls Key Vault for updated certificates and automatically installs them on the server.

  - For more information about installation procedures on Windows servers, see [Key Vault extension for Windows](/azure/virtual-machines/extensions/key-vault-windows).
  - For more information about installation steps for Linux servers, see [Key Vault extension for Linux](/azure/virtual-machines/extensions/key-vault-linux).
  - For more information about Azure Arc-enabled servers, see [Key Vault extension for Azure Arc-enabled servers](https://techcommunity.microsoft.com/t5/azure-arc-blog/in-preview-azure-key-vault-extension-for-arc-enabled-servers/ba-p/1888739).

> [!NOTE]
> You can run the following sample scripts from Azure Cloud Shell to configure the Key Vault extension:
>
> - [Key Vault extension for Windows servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionWin.ps1)
> - [Key Vault extension for Linux servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionLinux.ps1)
> - [Key Vault extension for Azure Arc-enabled Windows servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionARCWin.ps1)
> - [Key Vault extension for Azure Arc-enabled Linux servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionARCLinux.ps1)

The Key Vault extension configuration parameters include:

- **Key Vault name:** The key vault that contains the certificate for renewal.

- **Certificate name:** The name of the certificate to be renewed.

- **Certificate store, name, and location:** The certificate store where the certificate is stored. On Windows servers, the default value for *Name* is `My` and *Location* is `LocalMachine`, which is the personal certificate store of the computer. On Linux servers, you can specify a file system path, assuming that the default value is `AzureKeyVault`, which is the certificate store for Key Vault.

- **linkOnRenewal:** A flag that indicates whether the certificate should be linked to the server on renewal. If it's set to `true` on Windows machines, it copies the new certificate in the store and links it to the old certificate, which effectively rebinds the certificate. The default value is `false`, so an explicit binding is required.

- **pollingIntervalInS:** This value indicates the polling interval for the Key Vault extension to check for certificate updates. The default value is `3600` seconds (1 hour).

- **authenticationSetting:** The authentication setting for the Key Vault extension. For Azure servers, you can omit this setting, so the system-assigned managed identity of the VM is used against the key vault. For on-premises servers, specify the setting `msiEndpoint = "http://localhost:40342/metadata/identity"` so that the service principal that's associated with the computer object created during the Azure Arc onboarding is used.

> [!NOTE]
> Specify the Key Vault extension parameters only during the initial setup. This approach ensures that they don't undergo any changes throughout the renewal process.

#### Automation account

An Automation account is a cloud-based service that automates tasks via runbooks. In this architecture, it hosts the PowerShell runbook that renews certificates and is triggered by Event Grid via a webhook. You need to configure the account with a runbook by using the [PowerShell script](https://github.com/Azure/certlc/blob/main/.runbook/runbook_v3.ps1).

You also need to create a Hybrid Worker Group. Associate the Hybrid Worker Group with a Windows Server member of the same Active Directory domain of the CA, ideally the CA itself, for launching runbooks.

The runbook must have an associated [webhook](/azure/automation/automation-webhooks) initiated from the Hybrid Runbook Worker. Configure the webhook URL in the event subscription of the Event Grid system topic.

#### Storage account queue

The storage account queue is a message queue within Azure Storage. In this architecture, it stores the messages that contain the name of the certificate being renewed and the key vault that contains the certificate. Configure the storage account queue in the event subscription of the Event Grid system topic. The queue handles decoupling the script from the certificate expiration notification event. It supports persisting the event within a queue message. This approach helps ensure that the renewal process for certificates is repeated through scheduled jobs even if problems occur during the script's run.

#### Hybrid Runbook Worker

The Hybrid Runbook Worker allows runbooks to run on-premises or non-Azure machines. In this architecture, it runs the certificate renewal script on a Windows Server in the same Windows Server Active Directory domain as the certificate authority (CA), ideally on the CA itself. It plays a vital role in using runbooks. You need to install the Hybrid Runbook Worker by using the [Azure Hybrid Worker extension](/azure/automation/extension-based-hybrid-runbook-worker-install) method, which supports new installation.

#### Key Vault

Key Vault is a secure repository for secrets, keys, and certificates. In this architecture, it stores certificates from a nonintegrated CA and emits expiration events that trigger the renewal workflow. The Event Grid system topic is integrated with the webhook of the Automation account.

#### Event Grid

Event Grid is an event-routing service. In this architecture, it monitors certificate expiration events and triggers actions such as launching the renewal runbook and posting messages to the storage queue. To configure Event Grid, set up the system topic and event subscription to monitor relevant events. Relevant events include certificate expiration alerts, actions triggered within the automation workflow, and messages posted in the storage account queue. Configure the Event Grid system topic with the following parameters:

- **Source:** The name of the key vault that contains the certificates.

- **Source type:** The type of the source. For example, the source type for this solution is `Azure Key Vault`.

- **Event types:** The event type to be monitored. For example, the event type for this solution is `Microsoft.KeyVault.CertificateNearExpiry`. This event triggers when a certificate is near expiration.

- **Subscription for webhook:**

  - **Subscription name:** The name of the event subscription.

  - **Endpoint type:** The type of endpoint to be used. For example, the endpoint type for this solution is `Webhook`.

  - **Endpoint:** The URL of the webhook that's associated with the Automation account runbook. For more information, see the [Automation account](#automation-account) section.

- **Subscription for StorageQueue:**

  - **Subscription name:** The name of the event subscription.

  - **Endpoint type:** The type of endpoint to be used. For example, the endpoint type for this solution is `StorageQueue`.

  - **Endpoint:** The storage account queue.

#### Log Analytics workspace and Azure workbook

These tools collect and store logs from Azure services. This solution uses Log Analytics workspace and Azure workbook to enhance monitoring and visualization of certificate statuses stored in Key Vault. These components play a crucial role in maintaining visibility into certificate health:

- **Log Analytics workspace** collects and stores data about certificate states. It identifies whether certificates are expired, expiring soon, or still valid.

- **Azure workbook** retrieves data from the Log Analytics workspace and presents it in a dashboard with visual representations, like pie charts and detailed tables. It categorizes certificates into *Not Expired* (green), *Expiring Soon* (yellow), and *Expired* (red).

The following components retrieve and present certificate information in the workbook:

- A **data ingestion runbook** runs directly from Azure and doesn't require the context of a Hybrid Worker. It retrieves certificate data from Key Vault and sends it to a custom table that's defined in the Log Analytics workspace. The runbook runs on a scheduled cadence.

- A **workbook** queries the data from the custom table and displays it in both a pie chart and a detailed table. It highlights certificates based on their expiration status.

By integrating these components, your solution builds a more comprehensive approach to certificate lifecycle management.

:::image type="content" source="./media/workbook.png" alt-text="Screenshot that shows the dashboard of the certificates' status." lightbox="./media/workbook.png":::

### Alternatives

This solution uses an Automation account to orchestrate the certificate renewal process and uses Hybrid Runbook Worker to provide the flexibility to integrate with a CA on-premises or in other clouds.

An alternative approach is to use Azure Logic Apps. The main difference between the two approaches is that the Automation account is a PaaS solution, and Logic Apps is a software as a service (SaaS) solution.

The main advantage of Logic Apps is that it's a fully managed service. You don't need to worry about the underlying infrastructure. Also, Logic Apps can easily integrate with external connectors. This capability expands the range of notification possibilities, such as engagement with Microsoft Teams or Microsoft 365.

Logic Apps doesn't have a feature that's similar to Hybrid Runbook Worker, which results in less flexible integration with the CA, so an Automation account is the preferred approach.

## Scenario details

Every organization requires secure and efficient management of their certificate lifecycle. Failing to update a certificate before expiration can lead to service interruptions and incur significant costs for the business.

Enterprises typically operate complex IT infrastructures that involve multiple teams who are responsible for the certificate lifecycle. The manual nature of the certificate renewal process often introduces errors and consumes valuable time.

This solution addresses those challenges by automating certificate renewal issued by Microsoft Certificate Service. The service is widely used for various server applications such as web servers, SQL servers, and for encryption, nonrepudiation, signing purposes, and ensuring timely updates and secure certificate storage within Key Vault. The service's compatibility with Azure servers and on-premises servers supports flexible deployment.

### Potential use cases

This solution caters to organizations across various industries that:

- Use Microsoft Certificate Service for server certificate generation.

- Require automation in the certificate renewal process to accelerate operations and minimize errors, which helps avoid business loss and service-level agreement (SLA) violations.

- Require secure certificate storage in repositories like Key Vault.

This architecture serves as a foundational deployment approach across application landing zone subscriptions.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Within the Key Vault system, certificates are more securely stored as encrypted secrets and protected by Azure role-based access control (Azure RBAC).

Throughout the certificate renewal process, components that use identities are:

- The system account of the Hybrid Runbook Worker, which operates under the VM's account.

- The Key Vault extension, which uses the managed identity that's associated with the VM.

- The Automation account, which uses its designated managed identity.

The principle of least privilege is rigorously enforced across all identities engaged in the certificate renewal procedure.

The system account of the Hybrid Runbook Worker server must have the right to enroll certificates on one or more certificate templates that generate new certificates.

On the key vault that contains the certificates, the Automation account identity must have the `Key Vault Certificate Officer` role. Additionally, servers that require certificate access must have `Get` and `List` permissions within the Key Vault certificate store.

On the storage account queue, the Automation account identity must have the `Storage Queue Data Contributor`, `Reader and Data Access`, and `Reader` roles.

In scenarios where the Key Vault extension deploys on an Azure VM, the authentication occurs via the managed identity of the VM. However, when it's deployed on an Azure Arc-enabled server, authentication is handled by using a service principal. Both the managed identity and service principal must be assigned the Key Vault secret user role within the key vault that stores the certificate. You must use a secret role because the certificate is stored in the key vault as a secret.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This solution uses Azure PaaS solutions that operate under a pay-as-you-go framework to optimize cost. Expenses depend on the number of certificates that need renewal and the number of servers equipped with the Key Vault extension, which results in low overhead.

Expenses that result from the Key Vault extension and the Hybrid Runbook Worker depend on your installation choices and polling intervals. The cost of Event Grid corresponds to the volume of events generated by Key Vault. At the same time, the cost of the Automation account correlates with the number of runbooks that you use.

The cost of Key Vault depends on various factors, including your chosen SKU (Standard or Premium), the quantity of stored certificates, and the frequency of operations conducted on the certificates.

Similar considerations to the configurations described for Key Vault apply equally to the storage account. In this scenario, a Standard SKU with locally redundant storage replication suffices for the storage account. Generally, the cost of the storage account queue is minimal.

To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Input the services described in this article.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The automatic certificate renewal procedure securely stores certificates by way of standardized processes applicable across all certificates within the key vault.

Integrating with Event Grid triggers supplementary actions, such as notifying Microsoft Teams or Microsoft 365 and streamlining the renewal process. This integration significantly reduces certificate renewal time and mitigates the potential for errors that can lead to business disruptions and violations of SLAs.

Also, seamless integration with Azure Monitor, Microsoft Sentinel, Microsoft Copilot for Security, and Microsoft Defender for Cloud facilitates continuous monitoring of the certificate renewal process. It supports anomaly detection and ensures that robust security measures are maintained.

## Deploy this scenario

Select the following button to deploy the environment described in this article. The deployment takes about two minutes to complete and creates a key vault, an Event Grid system topic configured with the two subscriptions, a storage account that contains the *certlc* queue, and an Automation account that contains the *runbook* and the *webhook* linked to Event Grid.

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcertlc%2Fmain%2F.armtemplate%2Fmindeploy.json)

You can find detailed information about the parameters needed for the deployment in the [code sample](/samples/azure/certlc/certlc/) portal.

> [!IMPORTANT]
> You can deploy a full lab environment to demonstrate the entire automatic certificate renewal workflow. Use the [code sample](/samples/azure/certlc/certlc/) to deploy the following resources:
> - **Active Directory Domain Services (AD DS)** within a domain controller VM.
> - **Active Directory Certificate Services (AD CS)** within a CA VM, joined to the domain, configured with a template, *WebServerShort*, for enrolling the certificates to renew.
> - A **Windows Simple Mail Transfer Protocol (SMTP) server** installed on the same VM of the CA for sending email notifications. MailViewer also installs to verify the email notifications sent.
> - The **Key Vault extension** installed on the VM of the domain controller for retrieving the renewed certificates from the Key Vault extension.
>
> [![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcertlc%2Fmain%2F.armtemplate%2Ffulllabdeploy.json)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Fabio Masciotra](https://www.linkedin.com/in/fabiomasciotra/) | Principal Consultant
- [Angelo Mazzucchi](https://www.linkedin.com/in/angelo-mazzucchi-a5a94270) | Principal Consultant

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [About Azure Key Vault](/azure/key-vault/general/overview)
- [Key Vault VM extension for Windows](/azure/virtual-machines/extensions/key-vault-windows?tabs=version3)
- [Key Vault VM extension for Linux](/azure/virtual-machines/extensions/key-vault-linux)
- [What is Azure Automation?](/azure/automation/overview)
- [Azure Automation Hybrid Runbook Worker overview](/azure/automation/automation-hybrid-runbook-worker)
- [What is Event Grid?](/azure/event-grid/overview)
