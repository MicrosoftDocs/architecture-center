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

This example will show you how Azure services such as VMSS, Virtual Network, Key Vault, Storage, Load Balancer and Monitor can be quickly provisioned for the deployment of an efficient private Ethereum PoA blockchain that can be used to establish a shared ledger where member banks can establish their own nodes within the decentralized network.

## Potential use cases

These other uses cases have similar design patterns:

* Movement of allocated budgets between different business units of a multinational corporation
* Cross-border payments
* Trade finance scenarios
* Loyalty systems involving different companies
* Supply chain ecosystems and many more

Scenarios where there is exchange of some sort of value will find this example applicable in a very straightforward way. The Ethereum PoA network deployed in this scenario can be used for more complex use-cases with the use of smart contracts.

## Architecture

### Components

### Alternatives

The Ethereum PoA approach is chosen for this example because it is a good entry point for a consortium of organizations that want to create an environment where values can be transacted with one another easily in a trusted, decentralized and easy to understand way. The available Azure solution templates also provide a fast and convenient way not just for a consortium leader to start an Ethereum PoA blockchain, but also for member organizations in the consortium to spin up their own Azure resources within their own resource group and subscription to join an existing network.

For other extended or different scenarios, concerns such as transaction privacy, data residency, storage efficiency, speed and capacity may arise. For example, if the value transferred are securities such as stocks, members in a consortium may not want their transactions to be visible even to other members. Other alternatives to Ethereum PoA exists that addresses these concerns in their own way:

* Corda
* Quorum
* Hyperledger