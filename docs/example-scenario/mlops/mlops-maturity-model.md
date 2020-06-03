---
title: MLOps Maturity Model
titleSuffix: Technical Description
description: Detailed explanation of the MLOps Maturity Model stages and defining characteristics of each stage.
author: Dan Azlin (v-daazli@microsoft.com)
ms.date: 06/01/2020
ms.topic: MLOps, MLOps Maturity Model
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
    - fcp
    - cse
ms.category:
    - developer-tools
    - hybrid
social_image_url: /azure/architecture/example-scenario/serverless/media/mlops.png

---

<!-- cSpell:ignore Apigee -->

# MLOps Maturity Model

## Purpose

The purpose of this maturity model is to help clarify the MLOps principles and practices that can be targeted to represent continuous improvement in the creation and operation of a production level Machine Learning (ML) application environment. It is intended to be used as a metric for establishing the progressive requirements needed to measure the maturity of the ML production environment and its associated processes. It is also useful for estimating the scope of the work required for a new ML project, establish some success criteria, and identify project deliverables.

## MLOps Maturity Model

The MLOps Maturity Model helps clarify the DevOps principles and practices necessary to identify gaps in an existing organization's attempt to implement a sustainable production level MLOps environment. It is also a way to show a customer how to incrementally grow their MLOps capability rather than overwhelming them with the requirements of a fully mature environment. Thus, it should be used as a guide to estimate the scope of the work for new engagements, establish realistic success criteria, and identify deliverables to be handed over at the conclusion of the engagement.

As with most maturity models, the MLOps maturity model assesses qualitatively people/culture, processes/structures, and objects/technology. As the maturity level increases, the probability increases that incidents or errors will lead to improvements either in the quality and/or in the use of the development and production processes.

The MLOps Maturity Model is built upon the following levels of technical capability:  

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='width:90%;border-collapse:collapse;border:none;'>
 <tr style='mso-yfti-firstrow:yes'>
  <td valign=top style='width:10%;border:solid windowtext 1.0pt;background:#BDD6EE;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:normal;font-weight:bold;'>Level</p>
  </td>
  <td valign=top style='border:solid windowtext 1.0pt;border-left:none;background:#BDD6EE;padding:0in 5.4pt 4pt 5.4pt;width:20%;'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'><span style='color:black;'>Description</span></p>
  </td>
  <td valign=top style='border:solid windowtext 1.0pt;border-left:none;background:#BDD6EE;padding:0in 5.4pt 4pt 5.4pt;width:35%;'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'><span style='color:black;'>Highlights</span></p>
  </td>
  <td valign=top style='border:solid windowtext 1.0pt;border-left:none;background:#BDD6EE;padding:0in 5.4pt 4pt 5.4pt;width:35%;'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'><span style='color:black;'>Technology</span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1'>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:normal;'>0</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>No Ops</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Difficult to Manage full ML model lifecycle</li>
  <li>Teams are disparate &amp; releases are painful</li>
  <li>Most systems exist as "black boxes," little feedback during/post deployment</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Manual builds and deployments</li>
  <li>Manual testing of model and application</li>
  <li>No centralized tracking of model performance</li>
  <li>Training of model is manual</li></ul>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2'>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:normal'>1</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>DevOps but no MLOps</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Releases are less painful but rely on Data Team for every new model</li>
  <li>Still very limited feedback on how well a model performs in production</li>
  <li>Difficult to trace/reproduce results</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Automated builds</li>
  <li>Automated tests for application code</li></ul>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:normal'>2</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Automated Training</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Training environment is fully managed &amp; traceable</li>
  <li>Easy to reproduce model</li>
  <li>Releases are manual, but low friction</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Automated Model Training</li>
  <li>Centralized tracking of model training performance</li>
  <li>Model Management</li></ul>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4'>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:normal'>3</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Automated Model Deployment</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Releases are low friction &amp; automatic</li>
  <li>Full traceability from deployment back to original data</li>
  <li>Entire environment is managed: <span style="font-style:italic;">train > test > production</span></li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Integrated A/B testing of model performance for deployment</li>
  <li>Automated tests for all code</li>
  <li>Centralized traing of model training performance</li></ul>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;mso-yfti-lastrow:yes'>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:normal'>4</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Automated Operations (full MLOps)</p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Full system is automated and easily monitored</li>
  <li>Production systems are providing information on how to improve and, in some cases, automatically improving with new models</li>
  <li>Approaching a zero-downtime system</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li>Automated model training and testing</li>
  <li>Verbose, centralized metrics from deployed model</li></ul>
  </td>
 </tr>
</table>

Within these levels, the tables that follow identify the details characteristic for that level of process maturity. While the model will continue to evolve, this version was last updated in January 2020.

## Level 0 - No MLOps

<table border=0 cellspacing=0 cellpadding=0 style='width:90%;border-collapse:collapse'>
  <td style='border:solid #AEAAAA 1.0pt;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Maturity Level</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>People</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Model Creation</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Model Release</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Application Integration</span></b></p>
  </td>
 </tr>
 <tr style='height:95.0pt'>
  <td valign=top style='border:solid #AEAAAA 1.0pt;border-top:none;padding:.75pt 1.55pt 0in 1.55pt;height:95.0pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:106%'><b><span style='font-size:13.0pt;line-height:106%;font-family:"Times New Roman",serif;color:black'>Level 0 - No Ops</span></b></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 1.55pt 0in 1.55pt;height:95.0pt'>
  <ul>
  <li style=''>Data Scientists - siloed, not in regular comms with larger team</li>
  <li style=''>Data Engineers - siloed (if exists), not in regular comms with larger team</li>
  <li style=''>Software Engineers - siloed, receive model &quot;over the wall&quot;</li></ul>
  </td>
  <td valign=top style='border-top:none;
  border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;
  padding:.75pt 1.55pt 0in 1.55pt;height:95.0pt'>
  <ul>
  <li style=''>Data is gathered manually</li>
  <li style=''>Compute is likely not managed</li>
  <li style=''>Experiments are not predictably tracked</li>
  <li style=''>End result may be a single file manually handed off (model), with inputs/outputs</li></ul>
  </td>
  <td valign=top style='border-top:none;
  border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;
  padding:.75pt 1.55pt 0in 1.55pt;height:95.0pt'>
  <ul>
  <li style=''>Manual process</li>
  <li style=''>Scoring script may be manually created well after experiments, not version controlled</li>
  <li style=''>Release may be handled by Data Scientist or Data Engineer alone</li></ul>
  </td>
  <td valign=top style='border-top:none;
  border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;
  padding:.75pt 1.55pt 0in 1.55pt;height:95.0pt'>
  <ul>
  <li style=''>Heavily reliant on Data Scientist expertise to implement</li>
  <li style=''>Manual releases each time</li></ul>
  </td>
  <td style='border:none;padding:0in 0in 0in 0in' ><p>&nbsp;</td>
 </tr>
 </table>

## Level 1

 <table border=0 cellspacing=0 cellpadding=0 style='width:90%;border-collapse:collapse'>
  <td style='border:solid #AEAAAA 1.0pt;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Maturity Level</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>People</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Model Creation</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Model Release</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Application Integration</span></b></p>
  </td>
 </tr>
 <tr style='height:190.4pt'>
  <td valign=top style='border:solid #AEAAAA 1.0pt;
  border-top:none;padding:.75pt 1.55pt 0in 1.55pt;height:190.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  106%'><b><span style='font-size:13.0pt;line-height:106%;font-family:"Times New Roman",serif;
  color:black'>Level 1 - DevOps, but no MLOps</span></b></p>
  </td>
  <td valign=top style='border-top:none;
  border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;
  padding:.75pt 1.55pt 0in 1.55pt;height:190.4pt'>
  <ul>
  <li style=''>Data Scientists - siloed, not in regular comms with larger team</li>
  <li style=''>Data Engineers - siloed (if exists), not in regular comms with larger team</li>
  <li style=''>Software Engineers - siloed, receive model &quot;over the wall&quot;</li><ul>
  </td>
  <td valign=top style='border-top:none;
  border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;
  padding:.75pt 1.55pt 0in 1.55pt;height:190.4pt'>
  <ul>
  <li style=''>Data pipeline gathers data automatically</li>
  <li style=''>Compute may or may not be managed</li>
  <li style=''>Experiments are not predictably tracked</li>
  <li style=''>End result may be a single file manually handed off (model), with inputs/outputs</li></ul>
  </td>
  <td valign=top style='border-top:none;
  border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;
  padding:.75pt 1.55pt 0in 1.55pt;height:190.4pt'>
  <ul>
  <li style=''>Manual process</li>
  <li style=''>Scoring script may be manually created well after experiments, likely version controlled</li>
  <li style=''>Is handed off to Software Engineers</li></ul>
  </td>
  <td valign=top style='border-top:none;
  border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;
  padding:.75pt 1.55pt 0in 1.55pt;height:190.4pt'>
  <ul>
  <li style=''>Basic integration tests exist for the model</li>
  <li style=''>Heavily reliant on Data Scientist expertise to implement model</li>
  <li style=''>Releases are automated</li>
  <li style=''>Application code has unit tests</li></ul>
  </td>
  <td style='border:none;padding:0in 0in 0in 0in' ><p>&nbsp;</td>
 </tr>
</table>

## Level 2

<table border=0 cellspacing=0 cellpadding=0 style='width:90%;border-collapse:collapse;'>
 <tr style='height:36.8pt'>
  <td style='border:solid #AEAAAA 1.0pt;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.8pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b>Maturity Level</b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.8pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black'>People</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.8pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black'>Model Creation</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.8pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black'>Model Release</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.8pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black'>Application Integration</span></b></p>
  </td>
 </tr>
  <tr style='height:150.0pt'>
  <td valign=top style='width:80.0pt;border:solid #AEAAAA 1.0pt;border-top:none;padding:.75pt 5.75pt 0in 5.75pt;height:150.0pt'>
  <p><b>Level 2 - Automated Training</b></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:150.0pt'>
  <ul>
  <li style=''>Data Scientists - Working directly with Data Engineers to convert experimentation code into repeatable scripts/jobs</li>
  <li style=''>Data Engineers - Working with Data Scientists</li>
  <li style=''>Software Engineers - siloed, receive model &quot;over the wall&quot;</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:150.0pt'>
  <ul>
  <li style=''>Data pipeline gathers data automatically</li>
  <li style=''>Compute is managed</li>
  <li style=''>Experiment results are tracked</li>
  <li style=''>Both training code and resulting models are version controlled</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:150.0pt'>
  <ul>
  <li style=''>Manual Release</li>
  <li style=''>Scoring Script is version controlled with tests</li>
  <li style=''>Release is managed by Software engineering team</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:150.0pt'>
  <ul>
  <li style=''>Basic integration tests exist for the model</li>
  <li style=''>Heavily reliant on Data Scientist expertise to implement model</li>
  <li style=''>Application code has unit tests</li></ul>
  </td>
 </tr>
 </table>

## Level 3

 <table border=0 cellspacing=0 cellpadding=0 style='width:90%;border-collapse:collapse'>
  <td style='border:solid #AEAAAA 1.0pt;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Maturity Level</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>People</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Model Creation</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Model Release</span></b></p>
  </td>
  <td style='border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 4pt 1.55pt;height:36.45pt;width:20%'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black;'>Application Integration</span></b></p>
  </td>
 </tr>
 <tr style='height:217.35pt'>
  <td valign=top style='width:80.0pt;border:solid #AEAAAA 1.0pt;border-top:none;padding:.75pt 5.75pt 0in 5.75pt;height:217.35pt'>
  <p><b>Level 3 - Automated Model Deployment</b></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:217.35pt'>
  <ul>
  <li style=''>Data Scientists - Working directly with Data Engineers to convert experimentation code into repeatable scripts/jobs</li>
  <li style=''>Data Engineers - Working with Data Scientists and Software Engineers to manage inputs/outputs</li>
  <li style=''>Software Engineers - Working with Data Engineers to automate model integration into application code</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:217.35pt'>
  <ul>
  <li style=''>Data pipeline gathers data automatically</li>
  <li style=''>Compute is managed</li>
  <li style=''>Experiment results are tracked</li>
  <li style=''>Both training code and resulting models are version controlled</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:217.35pt'>
  <ul>
  <li style=''>Automatic Release</li>
  <li style=''>Scoring Script is version controlled with tests</li>
  <li style=''>Release is managed by CI/CD pipeline</li></ul>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:217.35pt'>
  <ul>
  <li style=''>Unit and Integration tests for each model release</li>
  <li style=''>Less reliant on Data Scientist expertise to implement model</li>
  <li style=''>Application code has unit/integration tests</li></ul>
  </td>
 </tr>
</table>

## Level 4 – Full MLOps  

<table border=0 cellspacing=0 cellpadding=0 style='width:90%;border-collapse:collapse;'>
 <tr style='height:36.45pt;width:20%;'>
  <td style='width:85.0pt;border:solid #AEAAAA 1.0pt;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b>Maturity Level</b></p>
  </td>
  <td style='width:206.0pt;border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black'>People</span></b></p>
  </td>
  <td style='width:206.0pt;border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black'>Model Creation</span></b></p>
  </td>
  <td style='width:206.0pt;border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black'>Model Release</span></b></p>
  </td>
  <td style='width:206.0pt;border:solid #AEAAAA 1.0pt;border-left:none;background:#BDD6EE;padding:.75pt 1.55pt 0in 1.55pt;height:36.45pt;width:20%;'>
  <p style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:106%'><b><span style='color:black'>Application Integration</span></b></p>
  </td>
 </tr>
 <tr style='height:117.8pt'>
  <td valign=top style='width:85.0pt;border:solid #AEAAAA 1.0pt;border-top:none;padding:.75pt 5.75pt 0in 5.75pt;height:117.8pt'>
  <p><b>Level 4 - Automated Retraining (full MLOps)</b></p>
  </td>
  <td valign=top style='width:206.0pt;border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:117.8pt'>
  <ul>
  <li>Data Scientists - Working directly with Data Engineers to convert experimentation code into repeatable scripts/jobs. Working with Software Engineers to identify markers for Data Engineers</li>
  <li>Data Engineers - Working with Data Scientists and Software Engineers to manage inputs/outputs</li>
  <li>Software Engineers - Working with Data Engineers to automate model integration into application code. Implementing metrics gathering post-deployment</li></ul>
  </td>
  <td valign=top style='width:206.0pt;border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:117.8pt'>
  <ul>
  <li>Data pipeline gathers data automatically</li>
  <li>Retraining triggered automatically based on production metrics</li>
  <li>Compute is managed</li>
  <li>Experiment results are tracked</li>
  <li>Both training code and resulting models are version controlled</li></ul>
  </td>
  <td valign=top style='width:206.0pt;border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:117.8pt'>
  <ul>
  <li>Automatic Release</li>
  <li>Scoring Script is version controlled with tests</li>
  <li>Release is managed by CI/CD pipeline</li></ul>
  </td>
  <td valign=top style='width:206.0pt;border-top:none;border-left:none;border-bottom:solid #AEAAAA 1.0pt;border-right:solid #AEAAAA 1.0pt;padding:.75pt 5.75pt 0in 5.75pt;height:117.8pt'>
  <ul>
  <li style=''>Unit and Integration tests for each model release</li>
  <li style=''>Less reliant on Data Scientist expertise to implement model</li>
  <li style=''>Application code has unit/integration tests</li></ul>
  </td>
 </tr>
</table>

## MLOps Maturity Questionnaire

The *MLOps Maturity Questionnaire* is a tool designed as a worksheet to help clarify the MLOps principles and practices that can be executed on any new ML engagement. Use it to estimate the scope of the work that will be required, establish success criteria, and identify project deliverables.

Download here:  [MLOps Maturity Questionnaire](https://csefy19.visualstudio.com/CSECodeShare/_git/CSECodeShare?path=%2Fbest-practices%2Fml-ops%2Fmlops-maturity-model.md&_a=preview&anchor=questionnaire)

## Credits

Taylor Rockey (tarockey); David Tesar (davete); Sushant Divate (sudivate)
