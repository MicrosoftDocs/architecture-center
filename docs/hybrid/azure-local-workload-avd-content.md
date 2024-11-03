This workload reference architecture document aims to provide customer guidance on selecting and setting up an Azure Virtual Desktop workload for Azure Local, thereby streamlining the Edge solution procurement process. By leveraging trusted Reference Architectures (RAs) from Microsoft, customers can minimize the time and effort required to deploy and manage their infrastructure.

Central to this, this guide factors in workload specific design considerations, requirements, and scale limitations, offering customers a complementary tool to the existing [Azure Local catalog](https://aka.ms/hci-catalog#catalog) and [Azure Local Sizer](https://aka.ms/hci-catalog#sizer) in designing their solution.

For additional information, this document is also best used in conjunction with [Azure Local baseline reference architecture](azure-stack-hci-baseline.yml) and [Azure Local Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-stack-hci), which provides guidelines and recommendations for how to deploy highly available and resilient Azure Local instances.

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture](#architecture) <br>&#9642; [Potential use cases](#potential-use-cases) <br>&#9642; [Scenario details](#scenario-details) <br>&#9642; [Platform resources](#platform-resources) <br>&#9642; [Platform-supporting resources](#platform-supporting-resources) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>|&#9642; [Cluster design choices](#cluster-design-choices)<br> &#9642; [Physical disk drives](#physical-disk-drives) <br> &#9642; [Network design](#network-design) <br> &#9642; [Monitoring](#monitoring) <br> &#9642; [Update management](#update-management)|&#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost optimization](#cost-optimization) <br> &#9642; [Operational excellence](#operational-excellence) <br> &#9642; [Performance efficiency](#performance-efficiency)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [Azure Virtual Desktop on Azure Local template](https://github.com/Azure/RDS-Templates/blob/master/ARM-wvd-templates/HCI/QuickDeploy/CreateHciHostpoolQuickDeployTemplate.json) demonstrates how to use an Azure Resource Management template (ARM template) and parameter file to deploy Azure Virtual Desktop session hosts deployed on Azure Local with simple configurations.

## Architecture

:::image type="complex" source="images/azure-local-workload-avd.png" alt-text="Diagram that shows a reference architecture for deploying Azure Virtual Desktop on Azure Local" lightbox="images/azure-local-workload-avd.png" border="false":::
    Diagram that shows a reference architecture for deploying Azure Virtual Desktop on Azure Local.
:::image-end:::

For more information, see [Related resources](#related-resources).

## Potential use cases
test 4
