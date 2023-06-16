[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Event Grid can serve as an essential building block in the automation of cloud operations.

## Architecture

:::image type="content" source="../media/ops-automation-using-event-grid.svg" alt-text="Architecture diagram that shows the flow of data during the process of automatically tagging a new VM." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ops-automation-using-event-grid.vsdx) of this architecture.*

### Dataflow

1. A user deploys a new resource in Azure. In this case, the resource is a virtual machine (VM).
1. The deployment creates the VM.
1. The Azure subscription of the VM emits an event that Event Grid subscribes to.
1. Event Grid fires an event that the subscriber Automation account receives.
1. The Automation account reacts to the event by completing a task. For example, Automation applies a tag to the new VM.
1. Optionally, Azure Logic Apps also consumes the Event Grid event. A logic app reacts to the event, for example by making an entry in an operation tool.

### Components

- [Event Grid](https://azure.microsoft.com/products/event-grid)
- [Automation](https://azure.microsoft.com/products/automation)
- [Logic Apps](https://azure.microsoft.com/products/logic-apps)

## Scenario details

This solution helps you simplify the process of managing resources.

Specifically, Event Grid can consume topics from [multiple services](/azure/event-grid/system-topics) in Azure. In this solution, Event Grid uses Azure subscriptions as a source. As a result, when a VM is created, Event Grid is notified. Event Grid can then notify an Automation account.

These events provide a way to automate resource management tasks.

### Potential use cases

This solution has many applications. Examples include automating the following tasks:

- Checking whether service configurations are compliant
- Inserting metadata into operations tools
- Tagging VMs
- Filing work items

## Next steps

- [Sample quickstart custom events](/azure/event-grid/custom-event-quickstart)
- [Azure subscription as an Event Grid source](/azure/event-grid/event-schema-subscriptions)
- [How to subscribe to events in the Azure portal](/azure/event-grid/subscribe-through-portal)
- [What is Azure Event Grid?](/azure/event-grid/overview)
- [Quickstart: Create an Automation account using the Azure portal](/azure/automation/quickstarts/create-azure-automation-account-portal)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)

## Related resources

- [Event-based cloud automation](../../reference-architectures/serverless/cloud-automation.yml)
- [Azure Automation update management](../../hybrid/azure-update-mgmt.yml)
- [Automate Jupyter Notebooks for diagnostics](../../example-scenario/data/automating-diagnostic-jupyter-notebook.yml)
- [Application integration using Azure Event Grid](./application-integration-using-event-grid.yml)
- [Serverless application architectures using Event Grid](./serverless-application-architectures-using-event-grid.yml)