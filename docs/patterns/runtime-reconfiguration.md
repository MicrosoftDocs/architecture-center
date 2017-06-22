---
title: Runtime Reconfiguration
description: Design an application so that it can be reconfigured without requiring redeployment or restarting the application.
keywords: design pattern
author: dragon119
ms.service: guidance
ms.topic: article
ms.author: pnp
ms.date: 06/23/2017

pnp.series.title: Cloud Design Patterns
pnp.pattern.categories: [design-implementation, management-monitoring]
---

# Runtime Reconfiguration

[!INCLUDE [header](../_includes/header.md)]

Design an application so that it can be reconfigured without requiring redeployment or restarting the application. This helps to maintain availability and minimize downtime.

## Context and problem

A primary goal for applications such as commercial and business websites is to minimize downtime and interruption to customers and users. Sometimes it's necessary to reconfigure the application to change specific behavior or settings while it's deployed and in use. Therefore, it's an advantage for the application to be designed to allow these configuration changes to be applied while it's running, and for the components of the application to detect the changes and apply them as soon as possible.

Examples of the kinds of configuration changes to be applied might be adjusting the granularity of logging to assist in debugging a problem with the application, swapping connection strings to use a different data store, or turning on or off specific sections or functionality of the application.

## Solution

The solution for implementing this pattern depends on the features available in the application hosting environment. Typically, the application code will respond to one or more events that are raised by the hosting infrastructure when it detects a change to the application configuration. This is usually the result of uploading a new configuration file, or in response to changes in the configuration through the administration portal or by accessing an API.

Code that handles the configuration change events can examine the changes and apply them to the components of the application. These components have to detect and react to the changes, and so the values they use will usually be exposed as writable properties or methods that the code in the event handler can set to new values or execute. From this point, the components should use the new values so that the required changes to the application behavior occur.

If it isn't possible for the components to apply the changes at runtime, it'll be necessary to restart the application so that these changes are applied when the application starts up again. In some hosting environments it's possible to detect these types of changes, and indicate to the environment that the application must be restarted. In other cases it might be necessary to implement code that analyses the setting changes and forces an application restart when necessary.

The figure shows an overview of this pattern.

![Figure 1 - A basic overview of this pattern](./_images/runtime-reconfiguration-pattern.png)


Most environments expose events raised in response to configuration changes. In those that don't, it will be necessary to have a polling mechanism that regularly checks for changes to the configuration and applies these changes. It might also be necessary to restart the application if the changes can't be applied at runtime. For example, it's possible to compare the date and time of a configuration file at preset intervals, and run code to apply the changes when a newer version is found. Another approach is to incorporate a control in the administration UI of the application, or expose a secured endpoint that can be accessed from outside the application, that executes code that reads and applies the updated configuration.

Alternatively, the application can react to some other change in the environment. For example, occurrences of a specific runtime error might change the logging configuration to automatically collect additional information, or the code could use the current date to read and apply a theme that reflects the season or a special event.

## Issues and considerations

Consider the following points when deciding how to implement this pattern:

The configuration settings must be stored outside of the deployed application so they can be updated without requiring the entire package to be redeployed. Typically, the settings are stored in a configuration file, or in an external repository such as a database or online storage. Access to the runtime configuration mechanism should be strictly controlled, as well as strictly audited when used.

If the hosting infrastructure doesn't automatically detect configuration change events, and expose these events to the application code, you must implement an alternative mechanism to detect and apply the changes. This can be through a polling mechanism, or by exposing an interactive control or endpoint that initiates the update process.

If you need to implement a polling mechanism, consider how often checks for updates to the configuration should take place. A long polling interval means that changes might not be applied for some time. A short interval might adversely affect operation by absorbing available compute and I/O resources.

If there's more than one instance of the application, additional factors should be considered, depending on how changes are detected. If changes are detected automatically through events raised by the hosting infrastructure, they might not be detected by all application instances at the same time. This means that some instances will be using the original configuration for a period while others will use the new settings. If the update is detected through a polling mechanism, this must communicate the change to all instances in order to maintain consistency.

Some configuration changes require the application to be restarted, or even require the hosting server to be rebooted. You must identify these types of configuration settings and perform the appropriate action for each one. For example, a change that requires the application be restarted might do this automatically, or it might be the responsibility of the administrator to initiate the restart when the application isn't under excessive load and other instances of the application can handle the load.

Plan for a staged rollout of updates and confirm they're successful, and that the updated application instances are performing correctly, before applying the update to all instances. This can prevent a total outage of the application should an error occur. Where the update requires a restart or a reboot of the application, particularly where the application has a significant start up or warm up time, use a staged rollout to prevent multiple instances being offline at the same time.

Consider how you'll roll back configuration changes that cause issues, or that result in failure of the application. For example, it should be possible to roll back a change immediately instead of waiting for a polling interval to detect the change.

Consider how the location of the configuration settings might affect application performance. For example, handle any errors that might occur if the external store is unavailable when the application starts, or when configuration changes are applied. You can do this using a default configuration or by caching the settings locally on the server and reusing these values while retrying access to the remote data store.

Caching can help to reduce delays if a component needs to repeatedly access configuration settings. However, when the configuration changes, the application code has to invalidate the cached settings, and the component must use the updated settings.

## When to use this pattern

This pattern is useful for:

- Applications that have to avoid all unnecessary downtime, while still being able to apply changes to the application configuration.

- Environments that expose events raised automatically when the main configuration changes. Typically this is when a new configuration file is detected, or when changes are made to an existing configuration file.

- Applications where the configuration changes often and the changes can be applied to components without requiring the application to be restarted, or without requiring the hosting server to be rebooted.

This pattern might not be useful when:

- Your deployment process uses an immutable infrastructure approach. With this approach, infrastructure is never modified after it’s deployed to production. Instead, components are replaced with each deployment.

- The effort of updating components can't be justified in comparison to restarting the application and enduring a short downtime.

- Reconfiguration is undesirable due to security restrictions.

- The runtime components are designed so they can only be configured at initialization time.

## Related patterns and guidance

- Moving configuration information out of the application deployment package to a centralized location can provide easier management and control of configuration data, and allows sharing of configuration data across applications and application instances. For more information, see [External Configuration Store pattern](external-configuration-store.md).
