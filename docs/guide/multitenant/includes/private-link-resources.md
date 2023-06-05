---
author: johndowns
ms.author: jodowns
ms.topic: include
ms.service: architecture-center
---

* [Azure Private Link Service explanation and demos from provider (SaaS ISV) and consumer perspectives](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-private-link-service-explanation-and-demos-from-provider/ba-p/3570251): A video that looks at the Azure Private Link service feature that enables multitenant service providers (such as independent software vendors building SaaS products). This solution enables consumers to access the provider's service using private IP addresses from the consumer's own Azure virtual networks.
* [TCP Proxy Protocol v2 with Azure Private Link Service—Deep Dive](https://arsenvlad.medium.com/tcp-proxy-protocol-v2-with-azure-private-link-service-deep-dive-64f8db9586cf): A video that presents a deep dive into TCP Proxy Protocol v2, which is an advanced feature of the Azure Private Link service. It's useful in multitenant and SaaS scenarios. The video shows you how to enable Proxy Protocol v2 in the Azure Private Link service. It also shows you how to configure an NGINX service to read the source private IP address of the original client, rather than the NAT IP, to access the service via the private endpoint.
* [Using NGINX Plus to decode Proxy Protocol TLV `linkIdentifier` from the Azure Private Link service](https://arsenvlad.medium.com/using-nginx-plus-to-decode-proxy-protocol-tlv-linkidentifier-from-azure-private-link-service-135675be84c3): A video that looks at how to use NGINX Plus to get the TCP Proxy Protocol v2 TLV from the Azure Private Link service. The video shows how you can then extract and decode the numeric `linkIdentifier`, also called `LINKID`, of the private endpoint connection. This solution is useful for multitenant providers who need to identify the specific consumer tenant from which the connection was made.
* [SaaS Private Connectivity pattern](https://github.com/Azure/SaaS-Private-Connectivity): An example solution that illustrates one approach to automate the approval of private endpoint connections, by using Azure Managed Applications.
