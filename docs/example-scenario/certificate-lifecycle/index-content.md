In cybersecurity, setting up automatic renewal of certificates is an important part of maintaining a secure and reliable environment. Failure to update or renew certificates in a timely manner exposes systems to vulnerabilities. Vulnerabilities can include:

- SSL/TLS certificates that are expired.
- Networks that are subject to potential breaches.
- Sensitive data that's unsecured.
- Services that go down for business-to-business processes.
- Brand reputation loss that compromises the integrity and confidentiality of digital transactions.

Azure Key Vault supports the [automatic renewal of certificates](https://learn.microsoft.com/en-us/azure/key-vault/certificates/overview-renew-certificate?tabs=azure-portal) issued by an integrated Certification Authority (*DigiCert* or *GlobalSign*). For a nonintegrated Certification Authority (CA) however, the process requires a [manual](https://learn.microsoft.com/en-us/azure/key-vault/certificates/overview-renew-certificate?tabs=azure-portal#renew-a-nonintegrated-ca-certificate) approach.

This article aims to bridge the gap by providing an **automated renewal process tailored for certificates from non-integrated CAs**. 
This process seamlessly stores the new certificates in Azure Key Vault, helps with efficiency, enhances security, and helps you integrate with various Azure resources to simplify deployment.

An automated renewal process fuels the need to minimize human errors and reduce service interruptions. When you automate certificate renewal, it not only accelerates the process but decreases the likelihood of errors that might occur during manual handling. When you apply the capabilities of Key Vault and its extensions, you can build an efficient automated process that helps you optimize operations and reliability.

While the initial focus is on automating certificate renewal, a broader objective is to enhance security across all areas of the process. This effort includes guiding users on implementing the Principle of Least Privilege (PoLP) or similar access controls over Key Vault. It also emphasizes the importance of robust logging and monitoring practices for Key Vault. This article demonstrates that the security benefits extend beyond merely storing certificates. It also highlights the importance of using Key Vault to fortify your entire certificate management lifecycle.

By using Key Vault and its automated renewal process, it updates certificates continually. The renewal process helps all Azure services that integrate with Key Vault benefit from up-to-date certificates. It forms an important part of the deployment process. This article provides insights into how continuous renewal and accessibility contribute to the overall deployment efficiency and reliability of Azure services.

## Architecture

Here's a brief overview of the underlying architecture that powers this solution.

![Diagram of the Certificate Lifecycle on Azure architecture](./media/certlc-arch.svg)

*Download a [Visio file](./media/certlc.vsdx) of this architecture.*

The Azure environment in question comprises the following Platform as a Service (PaaS) resources: a **Key Vault** (dedicated for storing only certificates issued by the same nonintegrated CA), an **Event Grid system topic**, a **Storage Account Queue**, and an **Automation Account** that exposes a webhook targeted by the Event Grid.

This scenario assumes that an existing Public Key Infrastructure (PKI), consisting of a Microsoft Enterprise Certification Authority joined to an Active Directory (AD) domain, is already in place. Both the PKI and the AD can reside on Azure or on-premises, and the servers that need to be configured for certificate renewal. 

The Virtual Machines (VMs) with certificates to monitor renewal don't need to be joined to Active Directory (AD) or Microsoft Entra ID. The sole requirement is for the Certification Authority (CA) and the Hybrid worker, if located on a different virtual machine from the CA, to be joined to Active Directory.

Subsequent sections provide an in-depth explanation of the automated renewal process.

### Workflow

The following drawing shows the automated workflow for certificate renewal within the Azure ecosystem. 

![detailed workflow](./media/workflow.png)

- **Key Vault Configuration:** The initial phase of the renewal process entails storing the certificate object in the designated "Certificates" section of the Azure Key Vault.
  
  While not mandatory, if you're interested in implementing custom email notifications, tag this certificate with the recipient's email address. Tagging ensures timely notifications when the renewal procedure completes. If multiple recipients are necessary, separate their email addresses by a comma or semicolon. The tag name for this purpose is '*Recipient,*' and its value is one or more email addresses of the designated administrators.

  When you use tags, as opposed to [built-in certificate notifications](https://learn.microsoft.com/azure/key-vault/certificates/overview-renew-certificate?tabs=azure-portal#get-notified-about-certificate-expiration), it offers the advantage of applying notification to a specific certificate with a designated recipient. Conversely, built-in certificate notification applies indiscriminately to all certificates within the key vault, utilizing the same recipient for all.
  
  You can integrate the built-in notification mechanism into the solution but with a different purpose. While the built-in notification mechanism can only notify about the upcoming certificate expiration, the tags can send notifications upon the complete renewal of the certificate, performed on the internal CA, and its subsequent availability on the key vault.

- **Key Vault Extension Configuration:** The servers that need to utilize these certificates must be equipped with the Key Vault extension, a versatile tool compatible with *[Windows](https://learn.microsoft.com/azure/virtual-machines/extensions/key-vault-windows),* and *[Linux](https://learn.microsoft.com/azure/virtual-machines/extensions/key-vault-linux)*-based systems. Azure-based (IaaS) servers and on-premises/other-clouds servers integrated through *[Azure ARC](https://learn.microsoft.com/azure/azure-arc/overview)* are supported. The Key Vault extension must be configured to periodically poll the Key Vault for any updated certificates. This polling interval is customizable, allowing flexibility to align with specific operational requirements.

- **Event Grid Integration:** As the certificate approaches expiration, two Event Grid subscriptions intercept this crucial lifetime event from the key vault.

- **Event Grid Triggers:** One Event Grid subscription sends certificate renewal information to a Storage Account Queue, while the other subscription triggers the launch of a runbook through the configured webhook in the Automation Account. If the runbook fails to renew the certificate, for example, due to unavailability of the CA, a scheduled process retries renewing the runbook from that point until the queue clears. This helps make the solution robust. 
  To enhance the solution's resiliency, implement a [dead-lettering](https://learn.microsoft.com/en-us/azure/event-grid/manage-event-delivery#set-dead-letter-location) mechanism to manage potential errors that can occur during the messages transit from Event Grid to the subscription targets (storage queue and webhook).

- **Storage Account Queue:** The RunBook, executed within the Certification Authority server configured as a Hybrid RunBook Worker, takes as input all the messages in the storage account queue containing the name of the expiring certificate and the Key Vault hosting it. The following steps happen for each message in the queue.

- **Certificate renewal:** With Azure connectivity, the script in the RunBook connects to Azure to retrieve the certificate's template name set up during generation. In this context, the "certificate template" is the configuration component of the certification authority that defines the attributes and purpose of the certificates to be generated.

  After, the script interfaces with the Key Vault, initiating a certificate renewal request. This request results in the generation of a Certificate Signing Request (CSR). Azure Key Vault generates the CSR, applying the same template used to generate the original certificate. This process ensures that the renewed certificate aligns with the predefined security policies. For more information about security involved in the authentication and authorization process, see the [Security](#security) section.

  The script downloads the CSR and submits it to the Certification Authority.

  The Certification Authority generates a new x509 certificate based on the correct template and sends it back to the script. This ensures that the renewed certificate aligns with the predefined security policies.

- **Certificate Merging and Key Vault Update:** The script merges the renewed certificate back into the Key Vault, finalizing the update process and removing the message from the queue. Throughout the entire process, the private key of the certificate is never extracted from the key vault.

- **Monitoring and e-mail notification:** All operations performed by the different Azure components (Automation account, Key Vault, Storage Account Queue and Event Grid) are logged within the Log Analytics workspace to enable monitoring. Following the certificate merge phase into the Key Vault, the script sends an email message to administrators to notify them of the renewal procedure's outcome.

- **Certificate retrieval:** The Key Vault extension running on the server plays a pivotal role in this phase by automatically downloading the latest version of the certificate from the Key Vault into the local store of the server utilizing it. Multiple servers can be configured with the Key Vault extension to retrieve the same certificate (wildcard or with multiple Subject Alternative Names) from the Key Vault.

### Components

The solution uses various components to facilitate automatic certificate renewal on Azure. The following sections elaborate on each component and its specific purpose.

#### Key Vault Extension
The Key Vault Extension plays a pivotal role in automating certificate renewal and must be installed on servers requiring this automation. Installation procedures for Windows servers can be found at [Key Vault Extension for Windows](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/key-vault-windows), for Linux servers at [Key Vault Extension for Linux](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/key-vault-linux), and for Azure ARC-enabled servers at [Azure Key Vault Extension for ARC-enabled Servers](https://techcommunity.microsoft.com/t5/azure-arc-blog/in-preview-azure-key-vault-extension-for-arc-enabled-servers/ba-p/1888739).

> [!NOTE]
> You can find sample scripts, that can be executed from Azure Cloud Shell, for configuring the *Key Vault extension* at the links below:
> - [KV extension for Windows servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionWin.ps1)
> - [KV extension for Linux servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionLinux.ps1)
> - [KV extension for Azure ARC-enabled Windows servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionARCWin.ps1)
> - [KV extension for Azure ARC-enabled Linux servers](https://github.com/Azure/certlc/blob/main/.scripts/kvextensionARCLinux.ps1)

The Key Vault extension configuration parameters include:

- **Key Vault Name:** The Key Vault containing the certificate for renewal.
- **Certificate Name:** The name of the certificate to be renewed.
- **Certificate Store (Name and Location):** The certificate store where the certificate is to be stored. On Windows servers, the default value for Name  is 'My' and for Location is 'LocalMachine,' which is the personal certificate store of the computer. On Linux servers, a file system path can be specified, considering that the default value is 'AzureKeyVault,' which is the certificate store for Azure Key Vault.
- **linkOnRenewal:** A flag indicating whether the certificate should be linked to the server on renewal. If 'true' on Windows machines it copies the new certificate in the store and links it to the old one doing an effective rebinding of the certificate. The default value is 'false' meaning that an explicit binding is required.
- **pollingIntervalInS:** The polling interval for the Key Vault extension to check for certificate updates. The default value is 3600 seconds (1 hour).
- **authenticationSetting:** The authentication setting for the Key Vault extension. For Azure-based servers this setting can be omitted, meaning that the System Assigned Managed Identity (MI) of the VM is used against the Key Vault. For on-premises servers, specifying the setting `msiEndpoint = "http://localhost:40342/metadata/identity"` means the usage of the service principal associated with the computer object created during the ARC onboarding.

> [!NOTE]
> The key vault extension parameters should be specified only during the initial setup, and they will not undergo any changes throughout the renewal process.

#### Automation Account
The Automation Account orchestrates the certificate renewal process. It needs to be configured with a RunBook, and the PowerShell script for the RunBook can be found [here](https://github.com/Azure/certlc/blob/main/.runbook/runbook_v3.ps1). 
Additionally, a Hybrid Worker Group must be created, associating it with an Azure Windows Server member of the same AD domain of the Certification Authority (ideally the Certification Authority itself) for executing RunBooks. 
The RunBook should have a [webhook](https://learn.microsoft.com/azure/automation/automation-webhooks) associated with it, initiated from the Hybrid RunBook Worker. 
The webhook URL should be configured in the Event Subscription of the Event Grid system topic. 

>> [!CAUTION]
> DISCLAIMER: The code is provided as-is and is not supported by Microsoft. It is intended to be used as a sample and can be customized to meet specific requirements. Microsoft does not guarantee the operation of this code nor does it provide support for issues arising from its operation.

#### Storage Account Queue
The Storage Account Queue is used to store the messages containing the name of the certificate to be renewed and the Key Vault containing it. The Storage Account Queue should be configured in the Event Subscription of the Event Grid system topic. The usage of the queue facilitates the decoupling of script execution from the certificate expiration notification event, allowing the persistence of the event within a queue message. This approach ensures that the renewal process for certificates can be repeated through scheduled jobs, even if there are issues that occur during the script execution.

#### Hybrid RunBook worker
The Hybrid RunBook Worker plays a pivotal role in executing RunBooks. It needs to be installed with the [Azure Hybrid Worker Extension](https://learn.microsoft.com/azure/automation/extension-based-hybrid-runbook-worker-install) method, which is the supported mode for the new installation. It must be created and associated with an Azure Windows Server member of the same AD domain of the Certification Authority (ideally the Certification Authority itself). 


#### Azure Key Vault
Azure Key Vault is the secure repository for certificates.  
In the 'Event' section of the Key Vault, the Event Grid system topic should be associated with the webhook of the Automation Account with a subscription. 


#### Azure Event Grid
Event Grid facilitates event-driven communication within Azure. Configuration includes setting up the Event Grid system topic and Event Subscription to monitor relevant events, such as certificate expiration alerts, triggering actions within the automation workflow and posting messages in the Storage Account Queue. The Event Grid system topic should be configured with the following parameters:

- **Source:** The name of the Key Vault containing the certificates.
- **Source Type:** The type of the source. In this case, the source type is 'Azure Key Vault'.
- **Event Types:** The event type to be monitored. In this case, the event type is 'Microsoft.KeyVault.CertificateNearExpiry'. This event is triggered when a certificate is near to expire.
- **Subscription for Webhook**: 
    - **Subscription Name:** The name of the event subscription.
    - **Endpoint Type:** The type of endpoint to be used. In this case, the endpoint type is 'Webhook'.
    - **Endpoint:** The URL of the webhook associated with the Automation Account RunBook as explained in the 'Automation Account' section.
- **Subscription for StorageQueue**: 
    - **Subscription Name:** The name of the event subscription.
    - **Endpoint Type:** The type of endpoint to be used. In this case, the endpoint type is 'StorageQueue'.
    - **Endpoint:** The storage account queue.
    

### Alternatives

This solution uses Azure Automation Account to orchestrate the certificate renewal process and, using Hybrid RunBook Worker, it gives the flexibility to integrate with Certification Authorities on-premises or in other clouds. 

An alternative approach could be to use **Azure Logic Apps**. The main difference between the two approaches is that Azure Automation Account is a PaaS service, while Azure Logic Apps is a SaaS service. 

The main advantage of Azure Logic Apps is that it's a fully managed service, meaning that the customer doesn't need to worry about the underlying infrastructure. Additionally, Azure Logic Apps can easily integrate with external connectors, expanding the range of notification possibilities, such as engaging with Teams or Microsoft 365.

The main disadvantage is the lack of a feature similar to Hybrid RunBook Worker, which results in less flexible integration with the Certification Authorities.
For this reason, Azure Automation Account was chosen as the preferred approach. 


## Scenario details

Every organization requires secure and efficient management of their certificate lifecycle. Failing to update a certificate before expiration can lead to service interruptions, incurring significant costs for the business.

Enterprises typically operate complex IT infrastructures involving multiple teams responsible for the certificate lifecycle. The manual nature of the certificate renewal process often introduces errors and consumes valuable time. 

This solution addresses these challenges by automating the renewal of certificates issued by Microsoft Certificate Service (widely used for various server applications such as web servers, SQL servers, and for encryption, nonrepudiation, and signing purpose), ensuring timely updates and secure storage of certificates within Azure Key Vault. Its compatibility with Azure-based and on-premises servers enables flexible deployment.

### Potential use cases

This solution caters to organizations across various industries that:

- Use Microsoft Certificate Service for server certificate generation.
- Require automation in the certificate renewal process to accelerate operations and minimize errorsto help avoid business loss and SLA violations.
- Require secure certificate storage in repositories like Azure Key Vault.

This architecture serves as a foundational deployment approach across landing zone subscriptions.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).


### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Within the Key Vault system, certificates are securely stored as encrypted secrets, protected by Azure Role-Based Access Control (RBAC).

The identities utilized throughout the certificate renewal process encompass:

- The 'System' account of the Hybrid RunBook Worker, which operates under the VM's account where it's installed.
- The Key Vault extension, using the Managed Identity (MI) associated with the VM where it's installed.
- The Automation Account using its designated 'managed identity'.

The principle of least privilege is rigorously enforced across all identities engaged in the certificate renewal procedure.

The 'System' account of the Hybrid RunBook Worker Server must have the right to enroll certificate on the Certificate template(s) used to generate new certificates.

On the Key Vault containing the certificates, the Automation Account identity must have the 'Key Vault Certificate Officer' role. Additionally, servers requiring certificate access must be granted 'Get' and 'List' permissions  within the key vault's certificate store.

On the Storage Account Queue, the Automation Account identity must have the 'Storage Queue Data Contributor', 'Reader and Data Access' and 'Reader' roles.

In scenarios where the Key Vault extension is deployed on an Azure VM, the authentication occurs via the Managed Identity (MI) of the VM. However, when deployed on an Azure ARC-enabled server, authentication is facilitated using a service principal. Both the Managed Identity (MI) and Service Principal must be assigned the 'Key Vault Secret User' role within the Key Vault that stores the certificate. The usage of 'Secret' is because the certificate is stored in the Key Vault as a secret behind the scene. 

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The solution's cost-effectiveness stems from its utilization of Azure PaaS services, operating under a pay-as-you-go framework. Primarily, expenses are contingent upon the quantity of certificates requiring renewal and the quantity of servers equipped with the Key Vault extension, resulting in low overhead.

Expenses associated with the Key Vault extension and the Hybrid RunBook Worker are dictated by their installation on servers and polling intervals. The cost of the Event Grid corresponds to the volume of events generated by the Key Vault. Concurrently, the cost of the Automation Account correlates with the quantity of executed RunBooks.

Additionally, the cost of the Key Vault is influenced by various factors, including the chosen SKU (Standard versus Premium), the quantity of stored certificates, and the frequency of operations conducted on the certificates.

Similar considerations to those discussed for the Key Vault apply equally to the Storage Account. In this scenario, a standard SKU with Local Redundant Storage (LRS) replication suffices for the Storage Account. Generally, the cost of the Storage Account Queue is minimal.

To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator), inputting the services described in this article.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

The automated certificate renewal procedure securely stores certificates utilizing standardized processes applicable across all certificates within the Key Vault. 

Integration with Event Grid enables triggering supplementary actions, such as notifying Teams or Microsoft 365, streamlining the renewal process. This integration significantly diminishes certificate renewal time, mitigating the potential for errors that could lead to business disruptions and violations of Service Level Agreements (SLAs).

Furthermore, seamless integration with Azure Monitor, Azure Sentinel, Microsoft Security Copilot, and Azure Security Center facilitates continual monitoring of the certificate renewal process, allowing for anomaly detection and ensuring robust security measures are maintained.


## Deploy this scenario

The button below automatically deploys the environment described in this article. The deployment takes about 2 minutes to complete and creates a **Key Vault**, an **Event Grid system topic** configured with the two subscriptions, a **Storage Account** containing the '*certlc*' queue and an **Automation Account** containing the *RunBook* and the *webhook* linked to the Event Grid.

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcertlc%2Fmain%2F.armtemplate%2Fmindeploy.json)


Detailed information about the parameters needed for the deployment can be found in the [**code sample**](https://learn.microsoft.com/en-us/samples/azure/certlc/certlc/) portal.

> [!IMPORTANT]
> > If you want to deploy a **full LAB environment** ready to demonstrate the whole automatic certificate renewal workflow, you can refer to the provided [**code sample**](https://learn.microsoft.com/en-us/samples/azure/certlc/certlc/) that includes the deployment of the following additional resources:
> > - **Active Directory Domain Services** (ADDS) within a domain controller virtual machine;
> > - **Active Directory Certificate Services** (ADCS) within a Certification Authority virtual machine, joined to the domain, configured with a template, *WebServerShort*, for the enrollment of the certificates to be renewed.
> > - **Windows SMTP Server** installed on the same virtual machine of the Certification Authority for sending e-mail notifications. A MailViewer tool is also installed to facilitate the verification of the e-mail notifications sent.
> > - **KeyVault Extension** installed on the virtual machine of the Domain Controller for retrieving the renewed certificates from the Key Vault.
> >
> > [![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcertlc%2Fmain%2F.armtemplate%2Ffulllabdeploy.json)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Fabio Masciotra](https://www.linkedin.com/in/fabiomasciotra/) | Principal Consultant
- [Angelo Mazzucchi](https://www.linkedin.com/in/angelo-mazzucchi-a5a94270) | Delivery Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*


## Related resources

Explore further resources related to Azure Key Vault, Automation Account, Hybrid RunBook Worker, Event Grid, and other relevant services:

[Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/overview)</BR>
[Azure Key Vault Extension for Windows](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/key-vault-windows?tabs=version3)</BR>
[Azure Key Vault Extension for Linux](https://learn.microsoft.com/azure/virtual-machines/extensions/key-vault-linux)</BR>
[Automation account](https://learn.microsoft.com/azure/automation/overview)</BR>
[Automation Hybrid Runbook Worker](https://learn.microsoft.com/azure/automation/automation-hybrid-runbook-worker)</BR>
[Event Grid](https://learn.microsoft.com/azure/event-grid/overview)

