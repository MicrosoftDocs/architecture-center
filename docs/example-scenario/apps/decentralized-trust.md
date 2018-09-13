---
title: Decentralized trust between banks on Azure
description: A scenario where a consortiurm of banks can establish a trusted environment for communication and information sharing without resorting to a centralized database
author: vitoc
ms.date: 09/09/2018
---
# Decentralized trust between banks on Azure

This example scenario is useful for banks or any other institutions that want to establish a trusted environment for information sharing without resorting to a centralized database. For the purpose of this example, we will describe the scenario in the context of maintaining credit score information between banks, but the architecture can be applied to any scenario where a consortium of organizations want to share validated information with one another without resorting to the use of a central system ran by one single party.

Traditionally, banks within a financial system rely on centralized sources such as credit bureaus for information on an individuals's credit score and history. A centralized approach presents a concentration of operational risk and sometimes an unnecessary third party.

With DLTs (distributed ledger technology), a consortium of banks can establish a decentralized system that can be more efficient, less susceptible to attack and serve as a new platform where innovative structures can be implemented to solve traditional challenges with privacy, speed and cost.

This example will show you how Azure services such as VMSS, Virtual Network, Key Vault, Storage, Load Balancer and Monitor can be quickly provisioned for the deployment of an efficient private Ethereum PoA blockchain where member banks can establish their own nodes.

## Potential use cases

These other uses cases have similar design patterns:

* Movement of allocated budgets between different business units of a multinational corporation
* Cross-border payments
* Trade finance scenarios
* Loyalty systems involving different companies
* Supply chain ecosystems and many more

## Architecture

### Components

### Alternatives

The Ethereum PoA approach is chosen for this example because it is a good entry point for a consortium of organizations that want to create an environment where information can be exchanged and shared with one another easily in a trusted, decentralized and easy to understand way. The available Azure solution templates also provide a fast and convenient way not just for a consortium leader to start an Ethereum PoA blockchain, but also for member organizations in the consortium to spin up their own Azure resources within their own resource group and subscription to join an existing network.

For other extended or different scenarios, concerns such as transaction privacy may arise. For example, in a securities transfer scenario, members in a consortium may not want their transactions to be visible even to other members. Other alternatives to Ethereum PoA exists that addresses these concerns in their own way:

* Corda
* Quorum
* Hyperledger