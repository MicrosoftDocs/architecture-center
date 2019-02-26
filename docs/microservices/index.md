---
title: Building microservices on Azure
description: Designing, building, and operating microservices architectures on Azure
ms.date: 02/26/2019
layout: LandingPage
ms.topic: landing-page
---

# Building microservices on Azure

<!-- markdownlint-disable MD033 -->

<img src="../_images/microservices.svg" style="float:left; margin-top:8px; margin-right:8px; max-width: 80px; max-height: 80px;"/>

Microservices are a popular architectural style for building applications that are resilient, highly scalable, independently deployable, and able to evolve quickly. But a successful microservices architecture requires a different approach to designing and building applications.

<ul  class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="./introduction.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>What are microservices?</h3>
                        <p>How do microservices differ from other architectures, and when should you use them?</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./domain-analysis.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Modeling microservices</h3>
                        <p>To avoid some common pitfalls when designing microservices, use domain analysis to define your microservice boundaries.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Example microservices architectures

The following scenarios show how microservices can be used in various application architectures.

<ul  class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="../example-scenario/infrastructure/service-fabric-microservices.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Use Service Fabric to decompose monolithic applications</h3>
                        <p>An iterative approach to decomposing an ASP.NET web site into microservices.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="../example-scenario/data/ecommerce-order-processing.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Scalable order processing on Azure</h3>
                        <p>Order processing using a functional programming model implemented via microservices.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Designing a microservices architecture

These articles dive deep into how to build a microservices architecture.

<ul  class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="../reference-architectures/microservices/aks.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Reference architecture for microservices on AKS</h3>
                        <p>This reference architecture shows a basic AKS configuration that can be the starting point for most deployments.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="https://github.com/mspnp/microservices-reference-implementation" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Reference implementation (GitHub)</h3>
                        <p>To illustrate best practices for a microservices architecture, we created a reference implementation called the Drone Delivery application.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./gateway.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Using API gateways in microservices</h3>
                        <p>An API gateway routes requests from clients to services. It can also perform cross-cutting tasks such as authentication and SSL termination.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./interservice-communication.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Interservice communication</h3>
                        <p>This article looks at the tradeoffs between asynchronous messaging versus synchronous APIs.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Deploying and running microservices in production

<ul  class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="./logging-monitoring.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Logging and monitoring</h3>
                        <p>The distributed nature of microservices architectures makes logging and monitoring especially critical.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./ci-cd.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Continuous integration and deployment</h3>
                        <p>Continuous integration and continuous delivery (CI/CD) are key to achieving success with microservices.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>
