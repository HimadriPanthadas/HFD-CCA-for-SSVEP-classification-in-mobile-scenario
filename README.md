# HFD-CCA

## Overview
A Brain-Computer Interface (BCI) is a system that enables direct communication between the brain and an external device, bypassing traditional neural pathways. It typically captures brain signals, processes them, and translates them into commands to control computers, prosthetics, or other devices, offering new ways for individuals to interact with technology. 
SSVEP (Steady-State Visually Evoked Potential) is a type of brain response generated when a person looks at a visual stimulus that flickers at a constant frequency, such as a flashing light or patterned display. It is commonly used in Brain-Computer Interfaces (BCIs) to detect which stimulus a user is focusing on, enabling control of external devices based on visual attention.

## Dataset, Extensions and Codes:
The dataset, dependent libraries and several crucial parts of the code have been takem from:
https://github.com/youngeun1209/MobileBCI_Data

## Descriptions of the dataset are available in:
https://www.nature.com/articles/s41597-021-01094-4

## Codes Involved
a_load_all_data.m : Loads dataset 
creator.m: Filters the EEG signal
HFDCCA_code.m: main code applying the proposed methodology
train_test_LDAA_hfd_cca.m: five fold cross validation of three machine learning models: Local Discriminant Analysis. Naive Bayes and Tree.

## Developing Environment
Matlab R2020b
BBCI toolbox (https://github.com/bbci/bbci_public)

## Published paper
https://ieeexplore.ieee.org/document/10677051
