## Update code and configurations

The following sections details essential the code and configuration updates you need to make to your web app. It follows the pillars of the Well-Architected Framework and covers the design patterns and key updates of the Reliable Web App pattern.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist). The Reliable Web App pattern introduces two key design patterns at the code level to enhance reliability: the Retry pattern and the Circuit Breaker pattern.

### Use the Retry pattern

Add the [Retry pattern](/azure/architecture/patterns/retry) to your application code to addresses temporary service disruptions, termed [transient faults](/azure/architecture/best-practices/transient-faults). Transient faults usually resolve themselves within seconds. The Retry pattern allows you to resend failed requests and configure the request delays and attempts before conceding failure.