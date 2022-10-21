---
title: Deploy a custom speech-to-text solution
description: <Write a 100-160 character description that ends with a period and ideally starts with a call to action. This becomes the browse card description.>
author: mishrapratyush
ms.author: pmishra
ms.date: 10/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-cognitive-services
  - azure-speech
  - azure-speech-text
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Deploy a custom speech-to-text solution

This article is an implementation guide and case study that provides a sample deployment for the associated article, Implement custom speech-to-text.[link to other article]

Contoso is a broadcast media company responsible for airing broadcasts and commentary on Olympic events. In addition, Contoso provides reliable event transcription both for accessibility and data mining purposes as part of the broadcast agreement. 

Contoso seeks to provide live subtitling and audio transcription for Olympic events using the Azure Speech service. However, it is important to note that Contoso employs diverse commentators worldwide, representing different genders and accents. In addition, each event has specific terminology that can make transcription difficult. This section describes the application development process of this scenario – providing subtitles for an application focused on delivering accurate event transcription to its users.
