---
title: Decentralized trust between banks on Azure
description: A scenario where a consortiurm of banks can establish a trusted environment for interbank fund transfer without resorting to a centralized database
author: vitoc
ms.date: 09/09/2018
---
# Decentralized trust between banks on Azure

This example scenario is useful for banks or any other institutions that need to establish a trusted environment for transactions without resorting to a centralized database. For the purpose of this example, we will describe the scenario in the context of interbank fund transfers between banks, but the architecture can be applied to any scenario where a consortium of organizations want to share validated information with one another without resorting to the use of a central system ran by one single party.

Traditionally, banks within a financial system rely on a trusted authority to maintain a database of all transactions that occur between them in their daily operations. Within a domestic payment situation within a country, this trusted authority can be the central bank. A centralized approach presents a concentration of operational risk and an unnecessary third party that is privy to all transactions.

With DLTs (distributed ledger technology), a consortium of banks can establish a decentralized system that can be more efficient, less susceptible to attack and serve as a new platform where innovative structures can be implemented to solve traditional challenges with privacy, speed and cost. 

This example will show you how Azure services such as VMSS, Virtual Network, Key Vault, Storage, Load Balancer and Monitor can be quickly provisioned for the deployment of an efficient private blockchain that can be used to establish a secure, ledger where member banks can establish their own nodes within the decentralized network.
