---
title: "Cloud Deployment Models" 
description: Intro to Cloud Deployment Models
author: BrianBlanchard
ms.date: 10/02/2018
---
# What Cloud Deployment Models are available?

Businesses use different models to deploy cloud resources. In this article, we build on ["How Azure works"](what-is-azure.md), by discussing the four cloud models: Private, Public, Hybrid, and Multi-Cloud.

This is an introductory article, meant to create a basic comparison between deployment options. This article is not expected to provide enough context to allow the reader to select the most appropriate deployment model for their specific needs. For more decision criteria & design considerations regarding Hybrid-specific deployment, see the [Governance design for multiple teams](../governance/governance-multiple-teams.md), which discusses identity, network, and other topics required to make a decision regarding a hybrid deployment model.  

## Private cloud

The first set of definitions we’ll discuss is the distinction between “private” and “public” clouds.

The term private cloud is often misused, with some claiming it's the same as a traditional on-premises datacenter. In fact, they're different. On-premises IT departments buy and deploy hardware as applications need them, only to upgrade or refresh again in a few years. IT departments traditionally maintain a mix of hardware and software, ranging from mainframe to PC server, with many different operating systems, databases, and other system software. Investing heavily in this type of asset driven business model to IT effectively prevents the notion of on-demand computing, which is the essence of the cloud.

In a private cloud, technologies specific to the cloud model are hosted in an on-premises datacenter. This includes a large amount of commodity hardware that runs identical system software and equates to a “cloud” that belongs to you. Private clouds can be useful because they can implement a technology stack that is consistent with the public cloud. This might be necessary in scenarios for which certain applications or data cannot be moved off the premises. However, private clouds are of limited utility. They do not provide the cost savings and efficiencies of the public cloud. Private clouds require a significant capital expense budget and operations staff, thus remaining on your company’s balance sheet. Moreover, individual companies cannot achieve the economies of scale of a public cloud provider, so their costs are proportionately higher.

## Public cloud

The public cloud is defined as computing services offered by third-party providers over the public internet, making it available to anyone. Public cloud is managed and maintained by a large technology vendor who makes computing, storage, and software available on a rental basis. The leading public cloud vendors have datacenters all over the world with literally millions of servers available for use. Organizations can either take advantage of applications that already exist in the cloud, or they can migrate their own proprietary applications. There are several ways in which applications can physically exist in the cloud but appear to be private to the enterprise corporate network.

While security concerns have been raised over public cloud environments, when implemented correctly, the public cloud can be as secure as the most effectively managed private cloud implementation—especially if the provider uses proper security methods, such as intrusion detection and prevention systems (IDPS), encrypted communication, network and infrastructure security, defense against threats, controlled identity, and user access.

## Hybrid cloud

A hybrid cloud is a computing environment that combines public and private cloud by allowing data and applications to be shared between them. Often, an enterprise will want to keep some of its applications on-premises while moving others to the public cloud. Or, when computing and processing demand fluctuates, hybrid cloud computing gives businesses the ability to seamlessly scale their on-premises infrastructure up to the public cloud to handle any overflow—without giving third-party datacenters access to the entirety of their data. Organizations gain the flexibility and computing power of the public cloud for basic and non-sensitive computing tasks, while keeping business-critical applications and data on-premises, safely behind a company firewall.

There are many ways to securely connect the two environments.

* A virtual private network (VPN) can connect on-premises to the cloud. VPNs makes cloud applications appear to be on the same internal network as the enterprise. You can set up VPNs on a per-application basis or, with a hardware device, for the entire datacenter.
* If greater reliability or performance is required, enterprises can lease a dedicated line linking the corporate datacenter with the cloud, and bandwidth can be added as needed. This solution is preferable when it is desired to keep all traffic off the public internet, or when substantially higher bandwidth is required. Of course, a leased line could increase costs.

## Multi-Cloud

Multi-cloud is the most complex deployment model. In this model, a computing environment would consist of asset deployments across private cloud and at least two public cloud vendors. This is the least common model of deployment.

Multi-cloud models across multiple cloud vendors can theoretically distribute risk of outage. Different public cloud vendors advance specific technologies at different paces. A multi-cloud strategy could allow a company to advance components of a solution at different paces. From a financial perspective, public cloud vendors are actively competing to reduce prices of similar services, in this "race to the bottom" customer could theoretically reduce costs.

> [!CAUTION]
> Many of the ideas that support multi-cloud approaches are unproven. Seldom do companies reach a high state of maturity across multiple clouds. Further, Multiple cloud vendors requires duplication of skills across IT, which results in bifurcated and abandoned adoption efforts. In the case of competing technical abilities, the advantages of advancing point solutions is often outweighed by the difficulty of integrating multiple cloud providers.

> [!TIP]
> Consolidating deployments with a single cloud vendor produces opportunities to create a stronger buying position & in some cases, better pricing.  

To begin planning for Cloud adoption in Azure, you may want to read  [Getting Started](overview.md). If a Hybrid cloud deployment model aligns with your needs, [Governance design for multiple teams](../governance/governance-multiple-teams.md) could help clarify the design considerations needed to implement such a model. 