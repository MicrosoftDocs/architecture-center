---
title: About the Tailspin Surveys application
description: An overview of the Tailspin Surveys application.
author: MikeWasson
ms.date: 07/21/2017
ms.topic: guide
ms.service: architecture-center
ms.subservice: reference-architecture
---

# The Tailspin scenario

[![GitHub](../_images/github.png) Sample code][sample application]

Tailspin is a fictional company that is developing a SaaS application named Surveys. This application enables organizations to create and publish online surveys.

* An organization can sign up for the application.
* After the organization is signed up, users can sign into the application with their organizational credentials.
* Users can create, edit, and publish surveys.

> [!NOTE]
> To get started with the application, see the [GitHub readme](https://github.com/mspnp/multitenant-saas-guidance/blob/master/get-started.md).

## Users can create, edit, and view surveys

An authenticated user can view all the surveys that he or she has created or has contributor rights to, and create new surveys. Notice that the user is signed in with his organizational identity, `bob@contoso.com`.

![Surveys app](./images/surveys-screenshot.png)

This screenshot shows the Edit Survey page:

![Edit survey](./images/edit-survey.png)

Users can also view any surveys created by other users within the same tenant.

![Tenant surveys](./images/tenant-surveys.png)

## Survey owners can invite contributors

When a user creates a survey, he or she can invite other people to be contributors on the survey. Contributors can edit the survey, but cannot delete or publish it.

![Add contributor](./images/add-contributor.png)

A user can add contributors from other tenants, which enables cross-tenant sharing of resources. In this screenshot, Bob (`bob@contoso.com`) is adding Alice (`alice@fabrikam.com`) as a contributor to a survey that Bob created.

When Alice logs in, she sees the survey listed under "Surveys I can contribute to".

![Survey contributor](./images/contributor.png)

Note that Alice signs into her own tenant, not as a guest of the Contoso tenant. Alice has contributor permissions only for that survey &mdash; she cannot view other surveys from the Contoso tenant.

## Architecture

The Surveys application consists of a web front end and a web API backend. Both are implemented using [ASP.NET Core].

The web application uses Azure Active Directory (Azure AD) to authenticate users. The web application also calls Azure AD to get OAuth 2 access tokens for the Web API. Access tokens are cached in Azure Cache for Redis. The cache enables multiple instances to share the same token cache (for example, in a server farm).

![Architecture](./images/architecture.png)

[**Next**][authentication]

<!-- links -->

[authentication]: authenticate.md

[ASP.NET Core]: /aspnet/core
[sample application]: https://github.com/mspnp/multitenant-saas-guidance
