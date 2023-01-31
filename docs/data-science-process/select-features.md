---
title: Feature selection in the Team Data Science Process
description: Explains the purpose of feature selection and provides examples of their role in the data enhancement process of machine learning.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 12/21/2021
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Feature selection in the Team Data Science Process (TDSP)

This article explains the purposes of feature selection and provides examples of its role in the data enhancement process of machine learning. These examples are drawn from Azure Machine Learning Studio.

The engineering and selection of features is one part of the Team Data Science Process (TDSP) outlined in the article [What is the Team Data Science Process?](overview.yml). Feature engineering and selection are parts of the **Develop features** step of the TDSP.

* **feature engineering**: This process attempts to create additional relevant features from the existing raw features in the data, and to increase predictive power to the learning algorithm.
* **feature selection**: This process selects the key subset of original data features in an attempt to reduce the dimensionality of the training problem.

Normally **feature engineering** is applied first to generate additional features, and then the **feature selection** step is performed to eliminate irrelevant, redundant, or highly correlated features.

## Filter features from your data - feature selection

Feature selection may be used for classification or regression tasks. The goal is to select a subset of the features from the original dataset that reduce its dimensions by using a minimal set of features to represent the maximum amount of variance in the data. This subset of features is used to train the model. Feature selection serves two main purposes.

* First, feature selection often increases classification accuracy by eliminating irrelevant, redundant, or highly correlated features.
* Second, it decreases the number of features, which makes the model training process more efficient. Efficiency is important for learners that are expensive to train such as support vector machines.

Although feature selection does seek to reduce the number of features in the dataset used to train the model, it is not referred to by the term "dimensionality reduction". Feature selection methods extract a subset of original features in the data without changing them. Dimensionality reduction methods employ engineered features that can transform the original features and thus modify them. Examples of dimensionality reduction methods include principal component analysis (PCA), canonical correlation analysis, and singular value decomposition (SVD).

Among others, one widely applied category of feature selection methods in a supervised context is called "filter-based feature selection". By evaluating the correlation between each feature and the target attribute, these methods apply a statistical measure to assign a score to each feature. The features are then ranked by the score, which may be used to help set the threshold for keeping or eliminating a specific feature. Examples of statistical measures used in these methods include Pearson correlation coefficient (PCC), mutual information (MI), and the chi-squared test.

## Azure Machine Learning Designer

One tool inside Azure Machine Learning is the [designer](/azure/machine-learning/concept-designer). Azure Machine Learning designer is a drag-and-drop interface used to train and deploy models in Azure Machine Learning. To manage features, there are [different tools available inside designer](/azure/machine-learning/how-to-select-algorithms#number-of-features).

The [Filter Based Feature Selection component](/azure/machine-learning/component-reference/filter-based-feature-selection) in Azure Machine Learning designer helps you identify the columns in your input dataset that have the greatest predictive power. 

The [Permutation Feature Importance component](/azure/machine-learning/component-reference/permutation-feature-importance) in Azure Machine Learning designer computes a set of feature importance scores for your dataset; you then use these scores to help you determine the best features to use in a model.


## Conclusion

Feature engineering and feature selection are two commonly engineering techniques to increase training efficiency. These techniques also improve the model's power to classify the input data accurately and to predict outcomes of interest more robustly. Feature engineering and selection can also combine to make the learning more computationally efficient by enhancing and then reducing the number of features needed to calibrate or train a model. Mathematically speaking, the features selected to train the model are a minimal set of independent variables that explain the maximum variance in the data to predict the outcome feature.

It is not always necessarily to perform feature engineering or feature selection. Whether it is needed or not depends on the data collected, the algorithm selected, and the objective of the experiment.

<!-- Module References -->
[feature-hashing]: /azure/machine-learning/studio-module-reference/feature-hashing
[filter-based-feature-selection]: /previous-versions/azure/dn905854(v=azure.100)
[fisher-linear-discriminant-analysis]: /azure/machine-learning/studio-module-reference/fisher-linear-discriminant-analysis

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*
