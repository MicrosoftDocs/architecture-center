This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS). 

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

## Build and Maintain a Secure Network and Systems
1. Install and maintain a firewall configuration to protect cardholder data
2. Do not use vendor-supplied defaults for system passwords and other security parameters




## Next

Protect stored cardholder data. Encrypt transmission of cardholder data across open, public networks

> [!div class="nextstepaction"]
> [Protect Cardholder Data](aks-pci-data.yml)