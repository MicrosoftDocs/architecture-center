# Automated Foundational Architecture for PCI DSS-Compliant Environments  

## PCI DSS - High-Level Overview

The Payment Card Industry Data Security Standard (PCI DSS) was developed to encourage and enhance cardholder data security and facilitate the broad adoption of consistent data security measures globally. PCI DSS provides a baseline of technical and operational requirements designed to protect account data. PCI DSS applies to all entities involved in payment card processing, including merchants, processors, acquirers, issuers, and service providers. PCI DSS also applies to all other entities that store, process, or transmit cardholder data (CHD) and/or sensitive authentication data (SAD). Below is a high-level overview of the 12 PCI DSS requirements.

> **Note:** These requirements are defined by the [Payment Card Industry (PCI) Security Standards Council](https://www.pcisecuritystandards.org/pci_security/) as part of the [PCI Data Security Standard (DSS) Version 3.2](https://www.pcisecuritystandards.org/document_library?category=pcidss&document=pci_dss). Please refer to the PCI DSS for information on testing procedures and guidance for each requirement.

|   |   |
|---|---|
| **Build and Maintain a Secure<br/>Network and Systems** | 1. [Install and maintain a firewall configuration to protect cardholder data](./pci-req1.md)<br/><br/> 2. [Do not use vendor-supplied defaults for system passwords and other security parameters](./pci-req2.md) |  
| **Protect Cardholder Data** | 3. [Protect stored cardholder data](./pci-req3.md)<br/><br/> 4. [Encrypt transmission of cardholder data across open, public networks](./pci-req4.md) |
| **Maintain a Vulnerability<br/>Management Program** | 5. [Protect all systems against malware and regularly update anti-virus software or programs](./pci-req5.md)<br/><br/> 6. [Develop and maintain secure systems and applications](./pci-req6.md) |
| **Implement Strong Access<br/>Control Measures** | 7. [Restrict access to cardholder data by business need to know](./pci-req7.md)<br/><br/> 8. [Identify and authenticate access to system components](./pci-req8.md) <br/><br/> 9. [Restrict physical access to cardholder data](./pci-req9.md) |
| **Regularly Monitor and<br/>Test Networks** | 10. [Track and monitor all access to network resources and cardholder data](./pci-req10.md) <br/><br/> 11. [Regularly test security systems and processes](./pci-req11.md) |
| **Maintain an Information<br/>Security Policy** | 12. [Maintain a policy that addresses information security for all personnel](./pci-req12.md) |

