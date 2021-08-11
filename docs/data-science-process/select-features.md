---
title: Feature selection in the Team Data Science Process
description: Explains the purpose of feature selection and provides examples of their role in the data enhancement process of machine learning.
services: machine-learning
author: marktab
manager: marktab
editor: marktab
ms.service: machine-learning
ms.subservice: team-data-science-process
ms.topic: article
ms.date: 01/10/2020
ms.author: tdsp
ms.custom: seodec18, previous-author=deguhath, previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Feature selection in the Team Data Science Process (TDSP)

This article explains the purposes of feature selection and provides examples of its role in the data enhancement process of machine learning. These examples are drawn from Azure Machine Learning Studio.

The engineering and selection of features is one part of the Team Data Science Process (TDSP) outlined in the article [What is the Team Data Science Process?](overview.md). Feature engineering and selection are parts of the **Develop features** step of the TDSP.

* **feature engineering**: This process attempts to create additional relevant features from the existing raw features in the data, and to increase predictive power to the learning algorithm.
* **feature selection**: This process selects the key subset of original data features in an attempt to reduce the dimensionality of the training problem.

Normally **feature engineering** is applied first to generate additional features, and then the **feature selection** step is performed to eliminate irrelevant, redundant, or highly correlated features.

## Filter features from your data - feature selection

Feature selection may be used for classification or regression tasks. The goal is to select a subset of the features from the original dataset that reduce its dimensions by using a minimal set of features to represent the maximum amount of variance in the data. This subset of features is used to train the model. Feature selection serves two main purposes.

* First, feature selection often increases classification accuracy by eliminating irrelevant, redundant, or highly correlated features.
* Second, it decreases the number of features, which makes the model training process more efficient. Efficiency is important for learners that are expensive to train such as support vector machines.

Although feature selection does seek to reduce the number of features in the dataset used to train the model, it is not referred to by the term "dimensionality reduction". Feature selection methods extract a subset of original features in the data without changing them.  Dimensionality reduction methods employ engineered features that can transform the original features and thus modify them. Examples of dimensionality reduction methods include principal component analysis (PCA), canonical correlation analysis, and singular value decomposition (SVD).

Among others, one widely applied category of feature selection methods in a supervised context is called "filter-based feature selection". By evaluating the correlation between each feature and the target attribute, these methods apply a statistical measure to assign a score to each feature. The features are then ranked by the score, which may be used to help set the threshold for keeping or eliminating a specific feature. Examples of statistical measures used in these methods include Pearson correlation coefficient (PCC), mutual information (MI), and the chi-squared test.

In Azure Machine Learning Studio, there are modules provided for feature selection. As shown in the following figure, these modules include [Filter-Based Feature Selection][filter-based-feature-selection] and [Fisher Linear Discriminant Analysis][fisher-linear-discriminant-analysis].

![Feature Selection modules](./media/select-features/feature-Selection.png)

Consider, for example, the use of the [Filter-Based Feature Selection][filter-based-feature-selection] module. For convenience, continue using the text mining example. Assume that one wants to build a regression model after a set of 256 features are created through the [Feature Hashing][feature-hashing] module, and that the response variable is the "Col1" that contains book review ratings ranging from 1 to 5. By setting "Feature scoring method" to be "Pearson Correlation", the "Target column" to be "Col1", and the "Number of desired features" to 50. Then the module [Filter-Based Feature Selection][filter-based-feature-selection] produces a dataset containing 50 features together with the target attribute "Col1". The following figure shows the flow of this experiment and the input parameters:

![Filter-Based Feature Selection module properties](./media/select-features/feature-selection-1.png)

The following figure shows the resulting datasets:

![Resulting dataset for Filter Based Feature Selection module](./media/select-features/feature-selection-2.png)

Each feature is scored based on the Pearson correlation coefficient between itself and the target attribute "Col1". The features with top scores are kept.

The corresponding scores of the selected features are shown in the following figure:

![Scores for Filter Based Feature Selection module](./media/select-features/feature-selection-3.png)

By applying this [Filter-Based Feature Selection][filter-based-feature-selection] module, 50 out of 256 features are selected because they have the most correlated features with the target variable "Col1", based on the scoring method "Pearson Correlation".

## Conclusion

Feature engineering and feature selection are two commonly engineering techniques to increase training efficiency. These techniques also improve the model's power to classify the input data accurately and to predict outcomes of interest more robustly. Feature engineering and selection can also combine to make the learning more computationally efficient by enhancing and then reducing the number of features needed to calibrate or train a model. Mathematically speaking, the features selected to train the model are a minimal set of independent variables that explain the maximum variance in the data to predict the outcome feature.

It is not always necessarily to perform feature engineering or feature selection. Whether it is needed or not depends on the data collected, the algorithm selected, and the objective of the experiment.

<!-- Module References -->
[feature-hashing]: /azure/machine-learning/studio-module-reference/feature-hashing
[filter-based-feature-selection]: /previous-versions/azure/dn905854(v=azure.100)
[fisher-linear-discriminant-analysis]: /azure/machine-learning/studio-module-reference/fisher-linear-discriminant-analysis
