This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS). 

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

## Protect Cardholder Data 

**Requirement 3**&mdash;Protect stored cardholder data

***
**Requirement 4**&mdash;Encrypt transmission of cardholder data across open, public networks.

|Requirement|Responsibility|
|---|---|
|[Requirement 4.1](#requirement-41)|Use strong cryptography and security protocols (for example, TLS, IPSEC, SSH, etc.) to safeguard sensitive cardholder data during transmission over open, public networks, including the following:|
|[Requirement 4.2](#requirement-42)|Never send unprotected PANs by end-user messaging technologies (for example, e-mail, instant messaging, SMS, chat, etc.).|
|[Requirement 4.3](#requirement-43)|4.3 Ensure that security policies and operational procedures for encrypting transmissions of cardholder data are documented, in use, and known to all affected parties.|


### Requirement 4.1

Use strong cryptography and security protocols (for example, TLS, IPSEC, SSH, etc.) to safeguard sensitive cardholder data during transmission over open, public networks, including the following:


##### Your responsibilities
      
Data that transits over the public internet must be encyrpted. Data must be encrypted with TLS 1.2 (or later), with reduced cipher support for all transmissions. Do not support non-TLS to TLS redirects on any data transmission services. Have many TLS terminiation points in your design starting at the first point of interception and all the way to your cluster. This means that TLS should be maintained between network hops that may include firewalls and the cluster. At each hop, inspect the packet, block, or route it to the next destination. Have the final TLS termination point at the cluster's ingress resource. Consider taking it further and provide TLS connections between the pods within the cluster resources.

:::image type="content" source="./images/flow.svg" alt-text="Data encryption" lightbox="./images/flow.png":::

Deny the creation of any non https ingress resource via azure policy. Also deny the creation of any public IP or any public load balacners in your cluster, to ensure web traffic is being tunneled through your gateway.

For more information, see [Azure encryption overview](https://docs.microsoft.com/azure/security/fundamentals/encryption-overview).


<Ask Chad: to give input around can the approval process be automated, who should be responsible and how is that incorporated in the pipeline.>

#### Requirement 4.1.1

Ensure wireless networks transmitting cardholder data or connected to the cardholder data environment, use industry best practices (for example, IEEE 802.11i) to implement strong encryption for authentication and transmission.

##### Your responsibilities
      
<Ask Chad>

#### Requirement 4.2
Never send unprotected PANs by end-user messaging technologies (for example, e-mail, instant messaging, SMS, chat, etc.).

##### Your responsibilities
      
<Ask Chad>


#### Requirement 4.3

Ensure that security policies and operational procedures for encrypting transmissions of cardholder data are documented, in use, and known to all affected parties.

##### Your responsibilities
      
<Ask Chad>



## Next

Protect all systems against malware and regularly update anti-virus software or programs. Develop and maintain secure systems and application

> [!div class="nextstepaction"]
> [Maintain a Vulnerability Management Program](aks-pci-malware.yml)